# frozen_string_literal: true

require 'test_helper'

class RepositoryDataBuilderServiceTest < ActiveSupport::TestCase
  def setup
    @built_params = {
      name: 'aaa',
      full_name: 'owner/aaa',
      language: 'Ruby',
      ssh_url: 'git@github.com:owner/aaa.git',
      clone_url: 'https://github.com/owner/aaa.git'
    }
  end

  test '#build' do
    method_call = RepositoryDataBuilderService.new.build(100_500)

    assert { method_call == @built_params }
  end
end
