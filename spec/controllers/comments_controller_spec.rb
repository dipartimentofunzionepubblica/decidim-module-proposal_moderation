# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Comments
    describe CommentsController, type: :controller do
      routes { Decidim::Comments::Engine.routes }

      let(:proposal_component) { create :proposal_component, :with_moderation_comments_enabled, organization: current_organization }
      let(:current_organization) { create :organization }
      let(:proposal) { create :proposal, component: proposal_component }
      let(:admin) { create :user, :admin, organization: current_organization }
      let(:current_user) { create :user, organization: current_organization }
      let(:comment) { create :comment, author: current_user, commentable: proposal }

      before do
        request.env["decidim.current_organization"] = current_organization
        sign_in current_user
      end

      describe "Create" do
        describe "#create" do
          it "create a comment with moderation enabled" do
            post :create, params: { format: :js, comment: { commentable_gid: proposal.to_sgid.to_s, body: "Test body", alignment: 0, user_group_id: "" } }
            expect(response).to have_http_status(:ok)
            expect(response).to render_template("decidim/comments/comments/create")
            expect(Decidim::Comments::Comment.last.state).to eq("review")
          end
        end
      end

      describe "Update" do
        describe "#update" do
          it "update a comment with moderation enabled" do
            put :update, params: { format: :js, id: comment.id, comment: { body: "Test body" } }
            expect(response).to have_http_status(:ok)
            expect(response).to render_template("decidim/comments/comments/update")
            expect(Decidim::Comments::Comment.last.state).to eq("review")
          end
        end
      end

      describe "Admin moderation" do
        routes { Decidim::ProposalModeration::Engine.routes }

        before do
          sign_in admin
          comment.update_column(:state, 'review')
        end

        describe "#publish" do
          it "publish a comment with moderation enabled" do
            put :publish, params: { format: :js, id: comment.id }
            expect(response).to have_http_status(:ok)
            expect(response).to render_template("decidim/comments/comments/publish")
            expect(Decidim::Comments::Comment.last.state).to eq(nil)
          end
        end

        describe "#reject" do
          it "reject a comment with moderation enabled" do
            put :reject, params: { format: :js, id: comment.id }
            expect(response).to have_http_status(:ok)
            expect(response).to render_template("decidim/comments/comments/reject")
            expect(Decidim::Comments::Comment.last.state).to eq("review")
            expect(Decidim::Moderation.where(reportable: comment).count).to eq(1)
            expect(comment.hidden?).to be(true)
          end
        end
      end
      #
      #   describe "Publish" do
      #     describe "#publish_draft" do
      #       it "amendment with moderation enabled sent in review instead piblish" do
      #         post :publish_draft, params: { id: amendment.id }
      #         expect(response).to have_http_status(:found)
      #         expect(flash[:notice]).to be_present
      #         expect(amendment.reload.state).to eq("review")
      #         expect(amendment.emendation.state).to eq("review")
      #       end
      #     end
      #   end
      # end
      #
      # describe "With published amendment" do
      #   describe "Accept" do
      #     describe "#accept" do
      #
      #       let(:amendment) { create(:proposal_amendment, state: "evaluating", amendable: proposal, amender: current_user) }
      #       let(:emendation) { amendment.emendation }
      #
      #       before do
      #         emendation.update_column(:state, 'evaluating')
      #       end
      #
      #       it "amendment with moderation enabled accept amendment" do
      #         post :accept, params: { id: amendment.id, amendment: { emendation_params: { title: "Title proposal Title proposal Title proposal", body: "Body proposal Body proposal Body proposal Body proposal Body proposal" } } }
      #         expect(response).to have_http_status(:found)
      #         expect(flash[:notice]).to be_present
      #         expect(amendment.reload.state).to eq("review_accepted")
      #         expect(amendment.emendation.state).to eq("review_accepted")
      #       end
      #     end
      #   end
      # end

    end
  end
end
