# frozen_string_literal: true

require "spec_helper"

describe Decidim::ProposalModeration::Admin::Permissions do

  subject { described_class.new(admin, permission_action, context).permissions.allowed? }

  let(:proposal_component) { create :proposal_component, :with_moderation_amendment_enabled, :with_moderation_comments_enabled, organization: current_organization }
  let(:current_organization) { create :organization }
  let(:proposal) { create :proposal, component: proposal_component }
  let(:admin) { create :user, :admin, organization: current_organization }
  let(:current_user) { create :user, organization: current_organization }
  let(:comment) { create :comment, author: current_user, commentable: proposal }

  let(:permission_action) { Decidim::PermissionAction.new(action) }
  let(:context) { { current_organization: current_organization, current_component: proposal.component, comment: comment } }

  context "when permission not set" do
    context "when have different scope" do
      let(:action) { { scope: :public, action: :update, subject: :setting } }
      it_behaves_like "permission is not set"
    end

    context "when have different different subject" do
      let(:action) { { scope: :public, action: :update, subject: :follow } }
      it_behaves_like "permission is not set"
    end

    context "when have different different action" do
      let(:action) { { scope: :public, action: :index, subject: :follow } }
      it_behaves_like "permission is not set"
    end
  end

  context "when permission is allowed" do
    context "when admin publish proposal" do
      let(:action) { { scope: :public, action: :publish, subject: :proposal } }
      it { is_expected.to eq true }
    end

    context "when admin accept amendment" do
      let(:action) { { scope: :public, action: :accept, subject: :amendment } }
      it { is_expected.to eq true }
    end
  end

  context "when permission is disallowed" do
    context "when not admin publish proposal" do
      subject { described_class.new(current_user, permission_action, context).permissions.allowed? }
      let(:action) { { scope: :public, action: :publish, subject: :proposal } }
      it_behaves_like "permission is not set"
    end

    context "when not admin accept amendment" do
      subject { described_class.new(current_user, permission_action, context).permissions.allowed? }
      let(:action) { { scope: :public, action: :accept, subject: :amendment } }
      it_behaves_like "permission is not set"
    end
  end
end