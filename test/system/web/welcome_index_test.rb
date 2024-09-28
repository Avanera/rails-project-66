# frozen_string_literal: true

require 'application_system_test_case'

module Web
  class WelcomeIndexTest < ApplicationSystemTestCase
    test 'visiting the welcome index' do
      visit root_path

      assert_selector 'div.display-4', text: I18n.t('welcome.index.greeting')

      assert_selector 'p', text: I18n.t('welcome.index.presentation')

      first_words = I18n.t('welcome.index.project_description').split[0, 3].join(' ')
      assert_selector 'p', text: first_words

      assert_selector 'a.btn', text: I18n.t('welcome.index.learn_more')
    end
  end
end
