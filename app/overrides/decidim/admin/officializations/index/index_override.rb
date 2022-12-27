# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Aggiunge badge all'utente che ha dei contenuto che sono stati rigettati in revisione
#
Deface::Override.new(virtual_path: "decidim/admin/officializations/index",
                     name: "add-badge-moderation_icon",
                     insert_before: 'div.card-section tbody tr td erb[loud]:contains("translated_attribute(user.officialized_as)")') do
'
  <%= moderation_icon  if Decidim::Moderation.for_user(user).present?  %>
'
end