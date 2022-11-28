Deface::Override.new(virtual_path: "decidim/proposals/proposals/edit",
                     name: "replace-send-button-in-edit",
                     replace: "erb:contains('form.submit t(\".send\"), class: \"button expanded\", data: { disable: true }')") do
  "
  <% if current_component.current_settings.try(:moderation_enabled) %>
    <%= form.submit t('.send_in_review'), class: 'button expanded', data: { disable: true } %>
  <% end %>
  "
end