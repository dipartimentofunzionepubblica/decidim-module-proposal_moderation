# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Comando che gestisce l'invio in revisione di un commento

# frozen_string_literal: true

module Decidim
  module Comments
    class ReviewComment < Rectify::Command
      def initialize(form, author, comment = nil)
        @form = form
        @author = author
        @comment = comment
      end

      def call
        if comment && comment.persisted?
          return broadcast(:invalid) if form.invalid? || !comment.authored_by?(current_user)
          update_comment
        else
          return broadcast(:invalid) if form.invalid?
          create_comment
        end

        broadcast(:ok, comment)
      end

      private

      attr_reader :form, :comment

      def create_comment
        priority = Decidim::ProposalModeration::ContentProcessor.parse_priority(form.body, I18n.locale)

        params = {
          author: @author,
          commentable: form.commentable,
          root_commentable: root_commentable(form.commentable),
          body: { I18n.locale => form.body },
          alignment: form.alignment,
          decidim_user_group_id: form.user_group_id,
          participatory_space: form.current_component.try(:participatory_space),
          state: 'review'
        }

        @comment = Decidim.traceability.create!(
          Comment,
          @author,
          params,
          visibility: "public-only"
        )

        send_admin_notifications(priority)
      end

      def update_comment
        priority = Decidim::ProposalModeration::ContentProcessor.parse_priority(form.body, I18n.locale)

        params = {
          body: { I18n.locale => form.body },
          state: 'review'
        }

        @comment = Decidim.traceability.update!(
          comment,
          current_user,
          params,
          visibility: "public-only",
          edit: true
        )

        send_admin_notifications(priority)
      end

      def send_admin_notifications(priority)
        NewCommentNotificationAdminCreator.new(comment, priority).create
      end

      def root_commentable(commentable)
        return commentable.root_commentable if commentable.is_a? Decidim::Comments::Comment

        commentable
      end
    end
  end
end
