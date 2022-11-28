module Decidim
  module Proposals
    class Proposal

      scope :in_review, -> { where(published_at: nil, state: "review") }
      scope :in_review_for_user, -> (user) do
        # Relation passed to #or must be structurally compatible. Incompatible values: [:join]
        where({published_at: nil, state: "review"}.merge(user.admin? ? {} : { id: Proposal.user_collection(user).ids }))
      end
      scope :in_review_accepted, -> { where(state: "review_accepted") }
      scope :in_acceptance_for_user, -> (user) do
        # Relation passed to #or must be structurally compatible. Incompatible values: [:join]
        where({state: "review_accepted"}.merge(user.admin? ? {} : { id: Proposal.user_collection(user).ids }))
      end

      def state
        return amendment.state if emendation?
        return nil unless published_state? || withdrawn? || review?

        super
      end

      def review?
        internal_state == "review"
      end

      def acceptance?
        internal_state == "review_accepted"
      end

      def editable_by?(user)
        return false if review?
        return true if draft? && created_by?(user)

        !published_state? && within_edit_time_limit? && !copied_from_other_component? && created_by?(user)
      end

      # def amendable?
      #   amendable.blank? && !review?
      # end

    end
  end
end