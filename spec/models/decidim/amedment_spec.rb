# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe Amendment, type: :model do

    let(:proposal_component) { create :proposal_component, :with_amendments_enabled, :with_moderation_amendment_enabled }
    let(:proposal) { create :proposal, component: proposal_component, state: 'draft', published_at: nil }
    let(:current_organization) { create :organization }
    let(:admin) { create :user, :admin, organization: current_organization }
    let(:author) { proposal.creator_author }
    let(:current_user) { create :user, organization: current_organization }
    let(:amendment) { create(:proposal_amendment, state: "draft", amendable: proposal, amender: current_user) }

    describe "methods to check states" do
      it "should do return 'false'" do
        expect(amendment.review?).to eq(false)
        expect(amendment.acceptance?).to eq(false)
      end

      describe "methods to check review" do
        before do
          amendment.update_column(:state, 'review')
        end

        it "should do return 'true'" do
          expect(amendment.review?).to eq(true)
        end

      end

      describe "methods to check acceptance" do
        before do
          amendment.update_column(:state, 'review_accepted')
        end

        it "should do return 'true'" do
          expect(amendment.acceptance?).to eq(true)
        end

      end

    end

  end
end