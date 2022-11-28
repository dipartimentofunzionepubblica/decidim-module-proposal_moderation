Deface::Override.new(virtual_path: "decidim/proposals/admin/proposals/_proposal-tr",
                     name: "add-public-action-to-proposals",
                     insert_bottom: "td.table-list__actions") do
  "
  <% if current_component.current_settings.try(:moderation_enabled) && proposal.review? %>
    <% url = current_participatory_space.is_a?(Decidim::Assembly) ? decidim_proposals_admin.publish_assembly_proposal_admin_path(current_participatory_space, current_component, proposal) : decidim_proposals_admin.publish_process_proposal_admin_path(current_participatory_space, current_component, proposal) %>
    <%= icon_link_to 'check', url, t('actions.publish', scope: 'decidim.admin'), class: 'action-icon--publish', method: :put %>
  <% end %>

  <% if current_component.current_settings.try(:moderation_enabled) && proposal.acceptance? %>
    <% url = current_participatory_space.is_a?(Decidim::Assembly) ? decidim_proposals_admin.accept_assembly_proposal_admin_path(current_participatory_space, current_component, proposal) : decidim_proposals_admin.accept_process_proposal_admin_path(current_participatory_space, current_component, proposal) %>
    <%= icon_link_to 'check', url, t('actions.accept', scope: 'decidim.admin'), class: 'action-icon--publish', method: :put %>
  <% end %>
"
end