# frozen_string_literal: true

require 'test_helper'

class RepositoryDataBuilderServiceTest < ActiveSupport::TestCase
  def setup
    @built_params = {
      name: 'Hello-World',
      full_name: 'octocat/Hello-World',
      language: 'Ruby',
      ssh_url: 'git@github.com:octocat/Hello-World.git',
      clone_url: 'https://github.com/octocat/Hello-World.git'
    }
  end

  def stub_fetch_data_from_octokit # rubocop:disable Metrics/MethodLength
    response_body = load_fixture('files/response_one_repo.json')
    stub_request(:get, 'https://api.github.com/repositories/100500')
      .with(
        headers: {
          'Accept' => 'application/vnd.github.v3+json',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type' => 'application/json',
          'User-Agent' => 'Octokit Ruby Gem 9.1.0'
        }
      )
      .to_return(status: 200, body: response_body, headers: { 'Content-Type' => 'application/json' })
  end

  test '#build' do
    stub_fetch_data_from_octokit
    method_call = RepositoryDataBuilderService.new.build(100_500)

    assert_equal(method_call, @built_params)
  end
end
