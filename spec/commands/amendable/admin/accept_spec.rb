# frozen_string_literal: true

require "spec_helper"

describe Decidim::Amendable::Admin::Accept do

  let(:current_organization) { create :organization }
  let(:admin) { create :user, :admin, organization: current_organization }
  let(:user) { create :user, organization: current_organization }
  let(:amendment) { create :proposal_amendment }
  let(:subject) { described_class.new(amendment.emendation) }

  context "when accept amendment with invalid form" do
    it "broadcasts invalid for missing current_user" do
      amendment.update_column(:state, "review_accepted")
      expect { subject.call }.to raise_error(NameError)
    end

    it "broadcasts invalid for wrong state" do
      allow(subject).to receive(:current_user).and_return(admin)
      expect { subject.call }.to broadcast :invalid
    end
  end

  context "when accept amendment already confirmed from user" do
    before do
      amendment.update_column(:state, "review_accepted")
      allow(subject).to receive(:current_user).and_return(admin)
    end

    it "accept amendment" do
      expect { subject.call }.to broadcast :ok
      expect(amendment.emendation.state).to eq('accepted')
    end

  end
end