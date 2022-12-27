# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Proposals
    describe Proposal, type: :model do

      let(:proposal_component) { create :proposal_component, :with_amendments_enabled, :with_moderation_amendment_enabled }
      let(:proposal) { create :proposal, component: proposal_component, state: 'draft', published_at: nil }
      let(:current_organization) { create :organization }
      let(:admin) { create :user, :admin, organization: current_organization }
      let(:author) { proposal.creator_author }
      let(:current_user) { create :user, organization: current_organization }
      let(:amendment) { create(:proposal_amendment, state: "draft", amendable: proposal, amender: current_user) }

      describe "methods to check states" do
        it "should do return 'false'" do
          expect(proposal.review?).to eq(false)
          expect(proposal.acceptance?).to eq(false)
          expect(proposal.review_failed?).to eq(false)
        end

        it "scopes" do
          expect(Proposal.in_moderation_rejected).not_to include(proposal)
          expect(Proposal.not_in_moderation_rejected).to include(proposal)
          expect(Proposal.in_moderation_rejected_for_user(author)).not_to include(proposal)
          expect(Proposal.in_review).not_to include(proposal)
          expect(Proposal.not_in_review).to include(proposal)
          expect(Proposal.not_in_moderation_rejected_for_user(author)).not_to include(proposal)
          expect(Proposal.in_review_for_user(author)).not_to include(proposal)
          expect(Proposal.in_review_accepted).not_to include(proposal)
          expect(Proposal.in_acceptance_for_user(author)).not_to include(proposal)
        end

        it "should be editable" do
          expect(proposal.editable_by?(author)).to eq(true)
          expect(proposal.editable_by?(current_user)).to eq(false)
        end

        describe "methods to check review" do
          before do
            proposal.update_column(:state, 'review')
          end

          it "should do return 'true'" do
            expect(proposal.review?).to eq(true)
          end

          it "should do return 'false'" do
            expect(proposal.editable_by?(current_user)).to eq(false)
          end

          it "scopes" do
            expect(Proposal.in_moderation_rejected).not_to include(proposal)
            expect(Proposal.not_in_moderation_rejected).to include(proposal)
            expect(Proposal.in_moderation_rejected_for_user(author)).not_to include(proposal)
            expect(Proposal.in_review).to include(proposal)
            expect(Proposal.not_in_review).not_to include(proposal)
            expect(Proposal.not_in_moderation_rejected_for_user(author)).not_to include(proposal)
            expect(Proposal.in_review_for_user(author)).to include(proposal)
            expect(Proposal.in_review_for_user(current_user)).not_to include(proposal)
            expect(Proposal.in_review_accepted).not_to include(proposal)
            expect(Proposal.in_acceptance_for_user(author)).not_to include(proposal)
          end
        end

        describe "methods to check acceptance" do
          before do
            proposal.update_column(:state, 'review_accepted')
          end

          it "should do return 'true'" do
            expect(proposal.acceptance?).to eq(true)
          end

          it "scopes" do
            expect(Proposal.in_moderation_rejected).not_to include(proposal)
            expect(Proposal.not_in_moderation_rejected).to include(proposal)
            expect(Proposal.in_moderation_rejected_for_user(author)).not_to include(proposal)
            expect(Proposal.in_review).not_to include(proposal)
            expect(Proposal.not_in_review).to include(proposal)
            expect(Proposal.not_in_moderation_rejected_for_user(author)).not_to include(proposal)
            expect(Proposal.in_review_for_user(author)).not_to include(proposal)
            expect(Proposal.in_review_accepted).to include(proposal)
            expect(Proposal.in_acceptance_for_user(author)).to include(proposal)
            expect(Proposal.in_acceptance_for_user(current_user)).not_to include(proposal)
          end
        end

        describe "methods to check review failed" do
          before do
            proposal.update_column(:state, 'moderation_rejected')
          end

          it "should do return 'true'" do
            expect(proposal.review_failed?).to eq(true)
          end

          it "should do return 'false'" do
            expect(proposal.editable_by?(current_user)).to eq(false)
          end

          it "scopes" do
            expect(Proposal.in_moderation_rejected).to include(proposal)
            expect(Proposal.not_in_moderation_rejected).not_to include(proposal)
            expect(Proposal.in_moderation_rejected_for_user(author)).to include(proposal)
            expect(Proposal.in_moderation_rejected_for_user(current_user)).not_to include(proposal)
            expect(Proposal.in_review).not_to include(proposal)
            expect(Proposal.not_in_review).to include(proposal)
            expect(Proposal.not_in_moderation_rejected_for_user(author)).not_to include(proposal)
            expect(Proposal.not_in_moderation_rejected_for_user(current_user)).to include(proposal)
            expect(Proposal.in_review_for_user(author)).not_to include(proposal)
            expect(Proposal.in_review_accepted).not_to include(proposal)
            expect(Proposal.in_acceptance_for_user(author)).not_to include(proposal)
          end
        end

      end

    end
  end
end