# frozen_string_literal: true

module Web
  module WelcomeHelper
    LEARN_MORE_URL = 'https://ru.hexlet.io/programs/rails/projects/66'

    def create_learn_more_url
      if current_user
        repositories_path
      else
        LEARN_MORE_URL
      end
    end
  end
end
