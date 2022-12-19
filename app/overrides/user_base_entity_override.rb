module Decidim
  class UserBaseEntity

    def public_followings(current_user)
      @public_followings ||= following_follows.select("array_agg(decidim_followable_id)")
                                              .group(:decidim_followable_type)
                                              .pluck(:decidim_followable_type, "array_agg(decidim_followable_id)")
                                              .to_h
                                              .flat_map do |type, ids|
        only_public(type.constantize, ids, current_user)
      end
    end

    private

    def only_public(klass, ids, current_user)
      scope = klass.where(id: ids)
      scope = scope.public_spaces if klass.try(:participatory_space?)
      scope = scope.includes(:component) if klass.try(:has_component?)
      if klass.respond_to?(:not_in_moderation_rejected_for_user)
        scope = scope.where.not(id: Decidim::Proposals::Proposal.not_in_moderation_rejected_for_user(current_user).ids).not_in_review
      end
      scope = scope.filter(&:visible?) if klass.method_defined?(:visible?)
      scope
    end


  end
end