require_dependency Decidim::Core::Engine.root.join('app', 'queries', 'decidim', 'similar_emendations').to_s

# frozen_string_literal: true

module Decidim
    class SimilarEmendations
      def query
        emendation.class
                  .where(component: component)
                  .only_visible_emendations_for(amender, component)
                  .not_in_moderation_rejected
                  .not_in_review
                  .published
                  .not_hidden
                  .where(
                    "GREATEST(#{title_similarity}, #{body_similarity}) >= ?",
                    translated_attribute(emendation.title),
                    translated_attribute(emendation.body),
                    amendable_module.similarity_threshold
                  )
                  .limit(amendable_module.similarity_limit)
      end
    end
end