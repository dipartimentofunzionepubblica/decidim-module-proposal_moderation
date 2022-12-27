# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Proposals
    describe ReviewProposal do

      let(:current_organization) { create :organization }
      let(:admin) { create :user, :admin, organization: current_organization }
      let(:proposal) { create :proposal, published_at: nil }
      let(:user) { proposal.creator_author }
      let(:subject) { described_class.new(proposal, user) }

      before do
        proposal.update_column(:state, 'review')
      end

      context "when review comment invalid" do
        it "broadcasts invalid for invalid user" do
          subject = described_class.new(proposal, admin)
          expect { subject.call }.to broadcast :invalid
        end
      end

      context "when review proposal" do
        it "reviewed proposal" do
          expect { subject.call }.to broadcast :ok
          expect(proposal.state).to eq('review')
          expect(proposal.published_at).to eq(nil)
        end

      end

    end
  end
end