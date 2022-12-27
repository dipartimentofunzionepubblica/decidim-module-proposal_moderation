# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Comments
    describe RejectComment do

      let(:current_organization) { create :organization }
      let(:admin) { create :user, :admin, organization: current_organization }
      let(:comment) { create :comment }
      let(:user) { comment.author }
      let(:form) do
        Decidim::Comments::CommentForm.from_model(comment).with_context(
          current_organization: current_organization
        )
      end

      let(:subject) { described_class }

      before do
        comment.update_column(:state, 'review')
      end

      context "when reject comment invalid" do
        it "broadcasts invalid for invalid form" do
          comment.update_column(:body, nil)
          expect { subject.call(comment, user, form) {} }.to broadcast :invalid
        end
      end

      context "when reject comment" do
        it "reject comment" do
          expect { subject.call(comment, user, form) {} }.to broadcast :ok
          expect(comment.state).to eq("review")
          expect(Decidim::Moderation.where(reportable: comment).count).to eq(1)
          expect(comment.hidden?).to be(true)
        end
      end

    end
  end
end