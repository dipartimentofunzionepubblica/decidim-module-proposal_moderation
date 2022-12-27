# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Rimuove i commenti in revisione per i non autori dello stesso

# frozen_string_literal: true

require_dependency Decidim::Comments::Engine.root.join('app', 'queries', 'decidim', 'comments', 'sorted_comments').to_s

module Decidim
  module Comments
    class SortedComments

      private

      def base_scope
        r = []
        id = @options[:id]
        r = Comment.where(root_commentable: commentable, id: id) if id.present?

        after = @options[:after]
        if after.present?
          r = Comment.where(root_commentable: commentable).where(
            "decidim_comments_comments.id > ?",
            after
          ) if r.empty?

        end
        r = Comment.where(commentable: commentable) if r.empty?
        if commentable.component.settings.moderation_comments_enabled?
          if @options[:current_user] && commentable.participatory_space.moderators.include?(@options[:current_user])
            return r
          elsif @options[:current_user]
            return r.where.not(id: commentable.comments.map{ |a| a.id if a.review? && a.decidim_author_id != @options[:current_user].id }.compact)
          else
            r.not_in_review
          end
        else
          return r
        end
      end

    end
  end
end
