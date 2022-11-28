# frozen_string_literal: true

module Decidim
  class Amendment


    def review?
      state == "review"
    end

    def acceptance?
      state == "review_accepted"
    end

  end
end
