require_dependency Decidim::Core::Engine.root.join('app', 'cells', 'decidim', 'following_cell').to_s

module Decidim
  class FollowingCell

    def public_followings
      @public_followings ||= Kaminari.paginate_array(model.public_followings(current_user)).page(params[:page]).per(20)
    end

  end

end