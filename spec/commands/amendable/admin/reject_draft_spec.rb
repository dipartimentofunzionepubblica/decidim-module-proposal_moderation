# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Amendable
    module Admin
      describe RejectDraft do


        let(:current_organization) { create :organization }
        let(:admin) { create :user, :admin, organization: current_organization }
        let(:amendment) { create :proposal_amendment }
        let(:user) { amendment.amender }
        let(:form) do
          PublishForm
            .from_model(amendment)
            .with_context(current_user: admin)
        end

        let(:subject) { described_class.new(form) }


        context "when publish emendation invalid" do
          it "broadcasts invalid for missing current_user" do
            amendment.update_column(:state, "review")
            expect { subject.call }.to raise_error(NameError)
          end

          it "broadcasts invalid for wrong state" do
            expect { subject.call }.to broadcast :invalid
          end

          # it "broadcasts invalid for invalid form" do
          #   amendment.update_column(:state, "review")
          #   form = PublishForm
          #            .from_model(amendment)
          #            .with_context(current_user: user)
          #   subject = described_class.new(form)
          #   allow(subject).to receive(:current_user).and_return(admin)
          #   expect { subject.call }.to broadcast :invalid
          # end
        end

        context "when accept amendment already confirmed from user" do
          before do
            amendment.update_column(:state, "review")
            allow(subject).to receive(:current_user).and_return(admin)
          end

          it "reject amendment" do
            expect { subject.call }.to broadcast :ok
            expect(amendment.emendation.state).to eq('moderation_rejected')
          end

        end
      end
    end
  end
end