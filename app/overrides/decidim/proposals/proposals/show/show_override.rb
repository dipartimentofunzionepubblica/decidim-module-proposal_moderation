# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# In caso di moderazione abilitata, rimuove il button per modificare una proposta

Deface::Override.new(virtual_path: "decidim/proposals/proposals/show",
                     name: "remove-edit-proposal",
                     replace: "erb[silent]:contains('if @proposal.amendable? && allowed_to?(:edit, :proposal, proposal: @proposal)')",
                     closing_selector: "erb[silent]:contains('end')") do
  "
    <% if @proposal.amendable? && allowed_to?(current_component.current_settings.try(:moderation_enabled) ? :update : :edit, :proposal, proposal: @proposal) %>
      <%= link_to t('.edit_proposal'), edit_proposal_path(@proposal), class: 'button hollow expanded button--sc' %>
    <% else %>
      <%= amend_button_for @proposal %>
    <% end %>
  "
end