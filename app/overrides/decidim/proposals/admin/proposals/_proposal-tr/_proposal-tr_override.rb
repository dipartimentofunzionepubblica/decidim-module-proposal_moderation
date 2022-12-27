# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Aggiunge action all'admin per pubblicare o rigettare un proposta o un emendamento

Deface::Override.new(virtual_path: "decidim/proposals/admin/proposals/_proposal-tr",
                     name: "add-public-action-to-proposals",
                     insert_bottom: "td.table-list__actions") do
  "
  <% if current_component.current_settings.try(:moderation_enabled) && proposal.review? %>
    <%= icon_link_to 'check', get_moderation_action_url(proposal, 'publish'), t('actions.publish', scope: 'decidim.admin'), class: 'action-icon--publish', method: :put %>
    <%= icon_link_to 'flag', get_moderation_action_url(proposal, 'reject'), t('actions.reject', scope: 'decidim.admin'), class: 'action-icon--reject', method: :put %>
  <% end %>

  <% if current_component.current_settings.try(:moderation_enabled) && proposal.acceptance? %>
    <%= icon_link_to 'check', get_moderation_action_url(proposal, 'accept'), t('actions.accept', scope: 'decidim.admin'), class: 'action-icon--publish', method: :put %>
    <%= icon_link_to 'flag', get_moderation_action_url(proposal, 'reject_acceptance'), t('actions.reject_acceptance', scope: 'decidim.admin'), class: 'action-icon--reject_acceptance', method: :put %>
  <% end %>
"
end