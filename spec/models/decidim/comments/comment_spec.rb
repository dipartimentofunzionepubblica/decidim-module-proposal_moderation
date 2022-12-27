# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Comments
    describe Comment, type: :model do

      let(:proposal_component) { create :proposal_component, :with_moderation_comments_enabled, organization: current_organization }
      let(:current_organization) { create :organization }
      let(:proposal) { create :proposal, component: proposal_component }
      let(:admin) { create :user, :admin, organization: current_organization }
      let(:current_user) { create :user, organization: current_organization }
      let(:comment) { create :comment, author: current_user, commentable: proposal }

      describe "methods to check states" do
        it "should do return 'false'" do
          expect(comment.review?).to eq(false)
        end

        it "scopes" do
          expect(Comment.in_review).not_to include(comment)
          expect(Comment.not_in_review).to include(comment)
        end

        describe "methods to check review" do
          before do
            comment.update_column(:state, 'review')
          end

          it "should do return 'true'" do
            expect(comment.review?).to eq(true)
          end

          it "scopes" do
            expect(Comment.in_review).to include(comment)
            expect(Comment.not_in_review).not_to include(comment)
          end
        end

      end

    end
  end
end