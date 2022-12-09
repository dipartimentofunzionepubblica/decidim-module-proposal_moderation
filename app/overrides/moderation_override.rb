# frozen_string_literal: true

module Decidim
  class Moderation

    belongs_to :reportable_comment, -> { where(decidim_moderations: { decidim_reportable_type: 'Decidim::Comments::Comment' }) }, foreign_key: 'decidim_reportable_id', class_name: 'Decidim::Comments::Comment', optional: true

    scope :for_user, -> (user) { Decidim::Moderation.left_joins(:reportable_comment).where(decidim_comments_comments: { decidim_author_id: user.id}) }


  end
end
