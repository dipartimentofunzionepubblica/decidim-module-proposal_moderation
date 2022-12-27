# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Proposals
    module Admin
      describe RejectProposal do

        let(:current_organization) { create :organization }
        let(:admin) { create :user, :admin, organization: current_organization }
        let(:proposal) { create :proposal }
        let(:user) { proposal.creator_author }
        let(:subject) { described_class.new(proposal, admin) }

        before do
          proposal.update_column(:state, 'review')
        end

        context "when reject comment invalid" do
          it "broadcasts invalid for invalid user" do
            allow(subject).to receive(:current_user).and_return(user)
            expect { subject.call }.to broadcast :invalid
          end
        end

        context "when reject proposal" do
          it "rejected proposal" do
            allow(subject).to receive(:current_user).and_return(admin)
            expect { subject.call }.to broadcast :ok
            expect(proposal.state).to eq("moderation_rejected")
          end

        end

      end
    end
  end
end