# frozen_string_literal: true

class RepositoryDataBuilderService
  def build(repo_id)
    repository_data = retrieve_repository_data(repo_id)
    build_params(repository_data)
  end

  private

  def retrieve_repository_data(repo_id)
    client = create_client
    client.repository(repo_id)
  end

  def build_params(repository_data)
    {
      name: repository_data['name'],
      full_name: repository_data['full_name'],
      language: repository_data['language'],
      ssh_url: repository_data['ssh_url'],
      clone_url: repository_data['clone_url']
    }
  end

  def create_client
    # Octokit::Client.new(access_token: current_user.token, auto_paginate: true)
    Octokit::Client.new(credentials)
  end

  def credentials
    {
      login: Rails.application.credentials[:github_login],
      password: Rails.application.credentials[:github_password]
    }
  end
end
