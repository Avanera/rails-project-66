# frozen_string_literal: true

class RepositoryDataBuilderService
  def build(repo_id, client)
    @client = client
    repository_data = retrieve_repository_data(repo_id)
    build_params(repository_data)
  end

  private

  def retrieve_repository_data(repo_id)
    @client.repository(repo_id)
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
end
