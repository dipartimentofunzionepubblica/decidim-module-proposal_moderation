# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Comments
    describe ReviewComment do

      let(:current_organization) { create :organization }
      let(:admin) { create :user, :admin, organization: current_organization }
      let(:comment) { create :comment }
      let(:proposal) { create :proposal }
      let(:user) { comment.author }
      let(:form) do
        Decidim::Comments::CommentForm.from_params(
          { id: comment.id, comment: { body: "Test" } }.merge(commentable: proposal)
        ).with_context(
          current_organization: current_organization,
          current_component: proposal.component
        )
      end

      let(:subject) { described_class.new(form, user, comment) }

      context "when send in review comment invalid" do
        it "broadcasts invalid for missing current_user" do
          expect { subject.call }.to raise_error(NameError)
        end

        it "broadcasts invalid for invalid form" do
          form = Decidim::Comments::CommentForm.from_params(
            { id: comment.id, comment: { body: "" } }.merge(commentable: proposal)
          ).with_context(
            current_organization: current_organization,
            current_component: proposal.component
          )
          subject = described_class.new(form, user, comment)
          allow(subject).to receive(:current_user).and_return(user)
          expect { subject.call }.to broadcast :invalid
        end
      end

      context "when send in review comment" do
        it "review comment" do
          allow(subject).to receive(:current_user).and_return(user)
          expect { subject.call }.to broadcast :ok
          expect(comment.state).to eq("review")
        end
      end

    end
  end
end