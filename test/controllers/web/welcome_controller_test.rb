# frozen_string_literal: true

require 'test_helper'

module Web
  class WelcomeControllerTest < ActionDispatch::IntegrationTest
    test 'should get index' do
      get root_url
      assert { response.successful? }
    end
  end
end
