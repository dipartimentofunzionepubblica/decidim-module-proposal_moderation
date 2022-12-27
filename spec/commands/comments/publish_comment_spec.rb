# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Comments
    describe PublishComment do

      let(:current_organization) { create :organization }
      let(:admin) { create :user, :admin, organization: current_organization }
      let(:comment) { create :comment }
      let(:user) { comment.author }
      let(:form) do
        Decidim::Comments::CommentForm.from_model(comment).with_context(
          current_organization: current_organization
        )
      end

      let(:subject) { described_class.new(comment, user, form) }

      before do
        comment.update_column(:state, 'review')
      end

      context "when publish comment invalid" do
        it "broadcasts invalid for invalid form" do
          comment.update_column(:body, nil)
          expect { subject.call }.to broadcast :invalid
        end
      end

      context "when publish comment" do
        it "published comment" do
          expect { subject.call }.to broadcast :ok
          expect(comment.state).to eq(nil)
        end

      end

    end
  end
end