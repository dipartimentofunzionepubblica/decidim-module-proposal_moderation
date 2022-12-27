# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe AmendmentsController, type: :controller do
    routes { Decidim::Core::Engine.routes }

    let(:proposal_component) { create :proposal_component, :with_amendments_enabled, :with_moderation_amendment_enabled }
    let(:proposal) { create :proposal, component: proposal_component }
    let(:current_organization) { create :organization }
    let(:admin) { create :user, :admin, organization: current_organization }
    # let(:amendment) { create :proposal_amendment, proposal: proposal }
    let(:author) { proposal.creator_author }
    let(:current_user) { create :user, organization: current_organization }

    before do
      request.headers["Referer"] = "#{root_url}#{Decidim::ResourceLocatorPresenter.new(proposal).path}"
      request.env["decidim.current_organization"] = current_organization
      sign_in current_user
    end

    describe "Redirect new proposal" do
      describe "#new" do
        it "new amendment with moderation enabled but proposal in review" do
          proposal.update_column(:internal_state, 'review')
          get :new, params: { amendable_gid: proposal.to_sgid.to_s }
          expect(response).to have_http_status(:found)
          expect(flash[:alert]).to be_present
        end
      end
    end

    describe "With draft amendment" do

      let(:amendment) { create(:proposal_amendment, state: "draft", amendable: proposal, amender: current_user) }

      describe "Review" do
        describe "#preview_draft" do
          it "amendment with moderation enabled send in review template" do
            get :preview_draft, params: { id: amendment.id }
            expect(response).to have_http_status(:ok)
            expect(response).to render_template("decidim/amendments/review_draft")
          end
        end
      end

      describe "Publish" do
        describe "#publish_draft" do
          it "amendment with moderation enabled sent in review instead piblish" do
            post :publish_draft, params: { id: amendment.id }
            expect(response).to have_http_status(:found)
            expect(flash[:notice]).to be_present
            expect(amendment.reload.state).to eq("review")
            expect(amendment.emendation.state).to eq("review")
          end
        end
      end
    end

    describe "With published amendment" do
      describe "Accept" do
        describe "#accept" do

          let(:amendment) { create(:proposal_amendment, state: "evaluating", amendable: proposal, amender: current_user) }
          let(:emendation) { amendment.emendation }

          before do
            emendation.update_column(:state, 'evaluating')
          end

          it "amendment with moderation enabled accept amendment" do
            post :accept, params: { id: amendment.id, amendment: { emendation_params: { title: "Title proposal Title proposal Title proposal", body: "Body proposal Body proposal Body proposal Body proposal Body proposal"}}}
            expect(response).to have_http_status(:found)
            expect(flash[:notice]).to be_present
            expect(amendment.reload.state).to eq("review_accepted")
            expect(amendment.emendation.state).to eq("review_accepted")
          end
        end
      end
    end

  end
end