# frozen_string_literal: true

require 'test_helper'

module Web
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    def setup
      sign_in(users(:one))
    end

    def repository_params
      {
        name: 'Hello-World',
        full_name: 'octocat/Hello-World',
        language: 'Ruby',
        ssh_url: 'git@github.com:octocat/Hello-World.git',
        clone_url: 'https://github.com/octocat/Hello-World.git'
      }
    end

    def stub_fetch_repos_from_octokit # rubocop:disable Metrics/MethodLength
      response_body = load_fixture('files/response_array.json')
      stub_request(:get, 'https://api.github.com/user/repos?per_page=100')
        .with(
          headers: {
            'Accept' => 'application/vnd.github.v3+json',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization' => 'token ghp_23iac7xzd0t95p496ir4h5j11r73qomtpkzv',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Octokit Ruby Gem 9.1.0'
          }
        )
        .to_return(status: 200, body: response_body, headers: { 'Content-Type' => 'application/json' })
    end

    test 'should create repository' do
      mock = Minitest::Mock.new
      mock.expect(:build, repository_params, [100_500])

      RepositoryDataBuilderService.stub :new, mock do
        assert_difference('Repository.count') do
          post repositories_url, params: { repository: { github_id: 100_500 } }
        end

        assert { response.redirect? && response.location == repositories_url }
        assert { flash[:notice] == I18n.t('web.repositories.create.success') }
      end
    end

    test 'should get index' do
      get repositories_url

      assert { response.successful? }
    end

    test 'should get new' do
      stub_fetch_repos_from_octokit

      get new_repository_url

      assert { response.successful? }
    end

    test 'should show repository' do
      repository = repositories(:one)

      get repository_url(repository)

      assert { response.successful? }
    end
  end
end
