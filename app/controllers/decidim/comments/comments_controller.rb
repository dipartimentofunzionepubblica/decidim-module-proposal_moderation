# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Override necessario per poter gestire il flusso personalizzato dei nuovi stati in caso di moderazione abilitata.

# frozen_string_literal: true


require_dependency Decidim::Comments::Engine.root.join('app', 'controllers', 'decidim', 'comments', 'comments_controller').to_s

module Decidim
  module Comments
    class CommentsController

      skip_before_action :ensure_commentable!, only: [:publish, :reject]

      def index
        enforce_permission_to :read, :comment, commentable: commentable

        @comments = SortedComments.for(
          commentable,
          order_by: order,
          after: params.fetch(:after, 0).to_i,
          current_user: current_user
        )
        @comments_count = commentable.comments_count

        respond_to do |format|
          format.js do
            if reload?
              render :reload
            else
              render :index
            end
          end

          # This makes sure bots are not causing unnecessary log entries.
          format.html { redirect_to commentable_path }
        end
      end

      def create
        enforce_permission_to :create, :comment, commentable: commentable

        form = Decidim::Comments::CommentForm.from_params(
          params.merge(commentable: commentable)
        ).with_context(
          current_organization: current_organization,
          current_component: current_component
        )

        if commentable.component.try(:settings).try(:moderation_comments_enabled) &&
          !current_user&.admin?
          Decidim::Comments::ReviewComment.call(form, current_user) do
            on(:ok) do |comment|
              handle_success(comment)
              respond_to do |format|
                format.js { render :create }
              end
            end

            on(:invalid) do
              @error = t("create.error", scope: "decidim.comments.comments")
              respond_to do |format|
                format.js { render :error }
              end
            end
          end
        else
          Decidim::Comments::CreateComment.call(form, current_user) do
            on(:ok) do |comment|
              handle_success(comment)
              respond_to do |format|
                format.js { render :create }
              end
            end

            on(:invalid) do
              @error = t("create.error", scope: "decidim.comments.comments")
              respond_to do |format|
                format.js { render :error }
              end
            end
          end
        end

      end

      def update
        set_comment
        enforce_permission_to :update, :comment, comment: comment

        form = Decidim::Comments::CommentForm.from_params(
          params.merge(commentable: comment.commentable)
        ).with_context(
          current_organization: current_organization
        )

        if comment.commentable.component.try(:settings).try(:moderation_comments_enabled) &&
          !current_user&.admin?

          Decidim::Comments::ReviewComment.call(form, current_user, comment) do
            on(:ok) do |comment|
              respond_to do |format|
                format.js { render :update }
              end
            end

            on(:invalid) do
              respond_to do |format|
                format.js { render :update_error }
              end
            end
          end

        else
          Decidim::Comments::UpdateComment.call(comment, current_user, form) do
            on(:ok) do
              respond_to do |format|
                format.js { render :update }
              end
            end

            on(:invalid) do
              respond_to do |format|
                format.js { render :update_error }
              end
            end
          end
        end
      end

      def publish
        set_comment
        enforce_permission_to :publish, :comment, comment: comment

        form = Decidim::Comments::CommentForm.from_model(comment).with_context(
          current_organization: current_organization
        )

        Decidim::Comments::PublishComment.call(comment, current_user, form) do
          on(:ok) do
            respond_to do |format|
              format.js { render :publish }
            end
          end

          on(:invalid) do
            respond_to do |format|
              format.js { render :publish_error }
            end
          end

        end
      end

      def reject
        set_comment
        enforce_permission_to :publish, :comment, comment: comment

        form = Decidim::Comments::CommentForm.from_model(comment).with_context(
          current_organization: current_organization
        )

        Decidim::Comments::RejectComment.call(comment, current_user, form) do
          on(:ok) do
            respond_to do |format|
              format.js { render :reject }
            end
          end

          on(:invalid) do
            respond_to do |format|
              format.js { render :update_error }
            end
          end
        end
      end

      def permission_class_chain
        [Decidim::ProposalModeration::Permissions] + super
      end

      def current_participatory_space
        comment.try(:participatory_space)
      end

    end
  end
end
