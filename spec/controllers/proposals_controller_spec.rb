# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Proposals
    describe ProposalsController, type: :controller do
      routes { Decidim::Proposals::Engine.routes }

      let(:proposal_component) { create :proposal_component, :with_amendments_enabled, :with_moderation_amendment_enabled }
      let(:proposal) { create :proposal, component: proposal_component, state: 'draft', published_at: nil }
      let(:current_organization) { create :organization }
      let(:admin) { create :user, :admin, organization: current_organization }
      let(:author) { proposal.creator_author }
      let(:current_user) { create :user, organization: current_organization }

      before do
        request.headers["Referer"] = proposals_url("assembly_slug": proposal.participatory_space.slug, component_id: proposal_component.id)
        request.env["decidim.current_component"] = proposal.component
        request.env["decidim.current_organization"] = current_organization
        request.env["decidim.current_participatory_space"] = proposal.participatory_space
        sign_in author
      end

      describe "Redirect new proposal" do
        describe "#new" do
          it "new proposal with moderation enabled but proposal in review" do
            proposal.update_column(:internal_state, 'review')
            get :new
            expect(response).to have_http_status(:found)
            expect(flash[:alert]).to be_present
          end
        end
      end

      describe "Review new proposal" do
        describe "#preview" do
          it "review proposal with moderation enabled but proposal in preview" do
            get :preview, params: { id: proposal.id }
            expect(response).to have_http_status(:ok)
            expect(response).to render_template("decidim/proposals/proposals/review")
          end
        end
      end

      describe "Send in review new proposal" do
        describe "#publish" do
          it "send in review proposal with moderation enabled instead publish" do
            allow(controller).to receive(:url_options).and_return({ "assembly_slug": proposal.participatory_space.slug, "component_id": proposal_component.id })
            get :publish, params: { id: proposal.id }
            expect(response).to have_http_status(:found)
            expect(flash[:notice]).to be_present
            expect(proposal.reload.state).to eq("review")
          end
        end
      end

      # Edit & Update permissions


    end
  end

end