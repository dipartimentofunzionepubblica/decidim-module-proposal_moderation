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