# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Creazione evento per poter aggiungere la priorità nella notifica in caso il commento contenga parole in bad list

# frozen_string_literal: true

module Decidim
  module Comments
    class AdminEvent < Decidim::Events::SimpleEvent
      include Decidim::Comments::CommentEvent

      i18n_attributes :priority

      def priority
        I18n.t("decidim.events.comments.admin.priority_#{extra["priority"]}")
      end
    end
  end
end
