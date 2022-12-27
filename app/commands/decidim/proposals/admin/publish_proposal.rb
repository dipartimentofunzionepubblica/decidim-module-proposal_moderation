# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Comando che gestisce la pubblicazione di una proposta da parte di un admin

# frozen_string_literal: true

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