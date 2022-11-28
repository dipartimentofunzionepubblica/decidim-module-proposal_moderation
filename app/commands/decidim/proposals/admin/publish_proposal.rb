module Decidim
  module Proposals
    module Admin
      class PublishProposal < Decidim::Proposals::PublishProposal

        def call
          return broadcast(:invalid) unless @current_user.admin?

          transaction do
            publish_proposal
            increment_scores
            send_notification
            send_notification_to_participatory_space
          end

          broadcast(:ok, @proposal)
        end

        def publish_proposal
          title = reset(:title)
          body = reset(:body)

          Decidim.traceability.perform_action!(
            "publish",
            @proposal,
            @current_user,
            visibility: "public-only"
          ) do
            @proposal.update title: title, body: body, published_at: Time.current, state: nil
          end
        end

      end
    end
  end
end