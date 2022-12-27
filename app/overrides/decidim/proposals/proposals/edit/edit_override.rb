# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Sostituisce etichetta in caso il modulo abbia la moderazione attiva. Indica all'utente che la proposta viene mandata in revisione invece che in pubblicazione

Deface::Override.new(virtual_path: "decidim/proposals/proposals/edit",
                     name: "replace-send-button-in-edit",
                     replace: "erb:contains('form.submit t(\".send\"), class: \"button expanded\", data: { disable: true }')") do
  "
  <% if current_component.current_settings.try(:moderation_enabled) %>
    <%= form.submit t('.send_in_review'), class: 'button expanded', data: { disable: true } %>
  <% end %>
  "
end