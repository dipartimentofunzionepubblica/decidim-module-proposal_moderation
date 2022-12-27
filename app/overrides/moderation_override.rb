# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Aggiunge metodi herper al model moderazione

# frozen_string_literal: true

module Decidim
  class Moderation

    belongs_to :reportable_comment, -> { where(decidim_moderations: { decidim_reportable_type: 'Decidim::Comments::Comment' }) }, foreign_key: 'decidim_reportable_id', class_name: 'Decidim::Comments::Comment', optional: true

    scope :for_user, -> (user) { Decidim::Moderation.left_joins(:reportable_comment).where(decidim_comments_comments: { decidim_author_id: user.id}) }


  end
end
