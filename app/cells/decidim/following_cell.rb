# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Override necessario per rimuovere tra le proposte seguite (in caso degli autori) eventuali proposte rigettate o in revisione

require_dependency Decidim::Core::Engine.root.join('app', 'cells', 'decidim', 'following_cell').to_s

module Decidim
  class FollowingCell

    def public_followings
      @public_followings ||= Kaminari.paginate_array(model.public_followings(current_user)).page(params[:page]).per(20)
    end

  end

end