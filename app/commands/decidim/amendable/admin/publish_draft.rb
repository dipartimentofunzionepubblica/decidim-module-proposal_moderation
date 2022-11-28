# frozen_string_literal: true

module Decidim
  module Amendable
    module Admin
      class PublishDraft < ::Decidim::Amendable::PublishDraft

        def call
          return broadcast(:invalid) unless form.valid? && amendment.review? && current_user&.admin?

          transaction do
            set_first_emendation_version
            publish_emendation
            change_amendment_state_to_evaluating
            notify_emendation_state_change!
            notify_amendable_authors_and_followers
          end

          broadcast(:ok, emendation)
        end

      end
    end
  end
end
