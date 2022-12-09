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