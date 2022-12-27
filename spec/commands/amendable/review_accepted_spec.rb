# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Amendable
    describe ReviewAccepted do

      let(:current_organization) { create :organization }
      let(:admin) { create :user, :admin, organization: current_organization }
      let(:amendment) { create :proposal_amendment }
      let(:user) { amendment.amender }
      let(:form) do
        ReviewForm.from_params({
                                 amendment:
                                    { emendation_params: { title: "Modifica emendamento", body: "Modifica emendamento"}},
                                 id: amendment.id}).with_context(current_user: admin)
      end

      before do
        amendment.update_column(:state, "review")
      end

      let(:subject) { described_class.new(form) }

      context "when publish emendation invalid" do

        it "broadcasts invalid for invalid form" do
          form = ReviewForm.from_params({
                                   amendment:
                                     { emendation_params: { title: "Modifica", body: "Modifica"}},
                                   id: amendment.id}).with_context(current_user: admin)
          subject = described_class.new(form)
          expect { subject.call }.to broadcast :invalid
        end
      end

      context "when publish review" do
        it "accepted amendment" do
          expect { subject.call }.to broadcast :ok
          expect(amendment.emendation.state).to eq('review_accepted')
          expect(amendment.reload.state).to eq('review_accepted')
        end

      end
    end
  end
end