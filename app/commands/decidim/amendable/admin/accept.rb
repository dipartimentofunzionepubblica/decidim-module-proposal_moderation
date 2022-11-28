# frozen_string_literal: true

module Decidim
  module Amendable
    module Admin
      class Accept < ::Decidim::Amendable::Accept

        def initialize(resource)
          @amendment = resource.amendment
          @amendable = resource.amendable
          @emendation = resource
          @amender = @emendation.creator_author
          @user_group = @emendation.creator.user_group
        end

        def call
          return broadcast(:invalid) unless @amendment.acceptance? && current_user&.admin?

          transaction do
            accept_amendment!
            update_amendable!
            notify_emendation_state_change!
            notify_amendable_and_emendation_authors_and_followers
          end

          broadcast(:ok, emendation)
        end

        private

        def update_amendable!
          @amendable = Decidim.traceability.perform_action!(
            :update,
            @amendable,
            @amender,
            visibility: "public-only"
          ) do
            emendation_params = @emendation.attributes.slice(*@amendable.amendable_fields.map(&:to_s))
            @amendable.assign_attributes(emendation_params)
            @amendable.title = emendation_params.with_indifferent_access[:title]
            @amendable.body = emendation_params.with_indifferent_access[:body]
            @amendable.save!
            @amendable
          end
          @amendable.add_coauthor(@amender, user_group: @user_group)
        end

      end
    end
  end
end
