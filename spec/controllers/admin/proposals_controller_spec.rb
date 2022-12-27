# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Proposals
    module Admin

      describe ProposalsController, type: :controller do
        routes { Decidim::ProposalModeration::AdminEngine.routes }
        # let(:decidim_proposals_admin) { routes.url_helpers }
        # let(:current_participatory_space) { proposal.participatory_space }
        # let(:current_component) { proposal.component }

        let(:proposal_component) { create :proposal_component, :with_amendments_enabled, :with_moderation_amendment_enabled }
        let(:proposal) { create :proposal, component: proposal_component }
        let(:current_organization) { create :organization }
        let(:admin) { create :user, :admin, organization: current_organization }
        # let(:amendment) { create :proposal_amendment, proposal: proposal }
        let(:author) { proposal.creator_author }
        let(:current_user) { create :user, organization: current_organization }

        before do
          request.env["decidim.current_component"] = proposal.component
          request.env["decidim.current_organization"] = current_organization
          sign_in admin
        end

        describe "With review amendment" do

          let(:amendment) { create(:proposal_amendment, amendable: proposal, amender: current_user) }
          let(:emendation) { amendment.emendation }

          before do
            amendment.update_column(:state, "review")
          end

          describe "Publish amendment after review" do
            describe "#publish" do
              it "publish amendment with moderation enabled after review" do
                routes_key, p = case emendation.participatory_space
                                when Decidim::Assembly then ["publish_assembly_proposal_admin", "assembly_slug"]
                                when Decidim::ParticipatoryProcess then ["publish_process_proposal_admin", "participatory_process_slug"]
                                else
                                  ["publish_conference_proposal_admin", "conference_slug"]
                                end
                put :publish, params: { id: emendation.id, locale: :en, use_route: routes_key,
                                        p => emendation.participatory_space.slug, component_id: emendation.component.id }
                expect(response).to have_http_status(:found)
                expect(flash[:notice]).to be_present
                expect(emendation.published_at).not_to eq(nil)
                expect(emendation.state).to eq('evaluating')
                expect(amendment.reload.state).to eq('evaluating')
              end
            end
          end

          describe "Reject amendment after review" do
            describe "#reject" do
              it "reject amendment with moderation enabled after review" do
                routes_key, p = case emendation.participatory_space
                                when Decidim::Assembly then ["reject_assembly_proposal_admin", "assembly_slug"]
                                when Decidim::ParticipatoryProcess then ["reject_process_proposal_admin", "participatory_process_slug"]
                                else
                                  ["reject_conference_proposal_admin", "conference_slug"]
                                end
                put :reject, params: { id: emendation.id, locale: :en, use_route: routes_key,
                                       p => emendation.participatory_space.slug, component_id: emendation.component.id }
                expect(response).to have_http_status(:found)
                expect(flash[:notice]).to be_present
                expect(emendation.published_at).not_to eq(nil)
                expect(emendation.state).to eq('moderation_rejected')
                expect(amendment.reload.state).to eq('moderation_rejected')
                expect(Decidim::Moderation.where(reportable: emendation).count).to eq(1)
                expect(emendation.hidden?).to be(true)
              end
            end
          end
        end


        describe "With review acceptance amendment" do

          let(:amendment) { create(:proposal_amendment, amendable: proposal, amender: current_user) }
          let(:emendation) { amendment.emendation }

          before do
            amendment.update_column(:state, "review_accepted")
          end

          describe "Publish acceptance after review" do
            describe "#accept" do
              it "publish acceptance amendment with moderation enabled after review" do
                routes_key, p = case emendation.participatory_space
                                when Decidim::Assembly then ["accept_assembly_proposal_admin", "assembly_slug"]
                                when Decidim::ParticipatoryProcess then ["accept_process_proposal_admin", "participatory_process_slug"]
                                else
                                  ["accept_conference_proposal_admin", "conference_slug"]
                                end
                put :accept, params: { id: emendation.id, locale: :en, use_route: routes_key,
                                        p => emendation.participatory_space.slug, component_id: emendation.component.id }
                expect(response).to have_http_status(:found)
                expect(flash[:notice]).to be_present
                expect(emendation.published_at).not_to eq(nil)
                expect(emendation.state).to eq('accepted')
                expect(amendment.reload.state).to eq('accepted')
              end
            end
          end

          describe "Reject acceptance amendment after review" do
            describe "#reject_acceptance" do
              it "reject acceptance amendment with moderation enabled after review" do
                routes_key, p = case emendation.participatory_space
                                when Decidim::Assembly then ["reject_acceptance_assembly_proposal_admin", "assembly_slug"]
                                when Decidim::ParticipatoryProcess then ["reject_acceptance_process_proposal_admin", "participatory_process_slug"]
                                else
                                  ["reject_acceptance_conference_proposal_admin", "conference_slug"]
                                end
                put :reject_acceptance, params: { id: emendation.id, locale: :en, use_route: routes_key,
                                       p => emendation.participatory_space.slug, component_id: emendation.component.id }
                expect(response).to have_http_status(:found)
                expect(flash[:notice]).to be_present
                expect(emendation.published_at).not_to eq(nil)
                expect(emendation.state).to eq('moderation_rejected')
                expect(amendment.reload.state).to eq('moderation_rejected')
                expect(Decidim::Moderation.where(reportable: emendation).count).to eq(1)
                expect(emendation.hidden?).to be(true)
              end
            end
          end
        end

      end
    end

  end
end