# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Amendable
    describe ReviewDraft do

      let(:current_organization) { create :organization }
      let(:admin) { create :user, :admin, organization: current_organization }
      let(:amendment) { create :proposal_amendment }
      let(:user) { amendment.amender }
      let(:form) do
        PublishForm
          .from_model(amendment)
          .with_context(current_user: user)
      end

      before do
        amendment.update_column(:state, "draft")
      end

      let(:subject) { described_class.new(form) }

      context "when publish emendation invalid" do
        it "broadcasts invalid for invalid amender" do
          allow(subject).to receive(:current_user).and_return(admin)
          expect { subject.call }.to broadcast :invalid
        end

        it "broadcasts invalid for invalid form" do
          amendment.emendation.update_column(:title, "Ciao")
          amendment.update_column(:state, "review")
          expect { subject.call }.to broadcast :invalid
        end
      end

      context "when send in review" do
        it "review amendment" do
          expect { subject.call }.to broadcast :ok
          expect(amendment.emendation.state).to eq('review')
          expect(amendment.reload.state).to eq('review')
        end

      end
    end
  end
end