# frozen_string_literal: true

require 'octokit'

module Web
  class RepositoriesController < Web::ApplicationController
    before_action :authenticate_user!

    def index
      @repositories = current_user.repositories.order(created_at: :desc)
    end

    def show
      @repository = Repository.find(params[:id])
      authorize @repository
    end

    def new
      authorize Repository
      @repository = current_user.repositories.build
      @github_repos = fetch_permitted_repos_from_github
    end

    def create
      authorize Repository
      @repository = find_or_initialize_repository
      if update_repository
        redirect_to repositories_path, notice: t('.success')
      else
        flash.now[:alert] = t('.failure')
        render :new, status: :unprocessable_entity
      end
    end

    private

    def repository_params
      params.require(:repository).permit(:github_id)
    end

    def fetch_permitted_repos_from_github
      Rails.cache.fetch("#{current_user.cache_key_with_version}/repos", expires_in: 10.minutes) do
        client = Octokit::Client.new(access_token: current_user.token, auto_paginate: true)
        client.repos.select { |repo| Repository::ACCEPTED_LANGUAGES.include? repo[:language] }
      end
    end

    def find_or_initialize_repository
      current_user.repositories.find_or_initialize_by(repository_params)
    end

    def update_repository
      unless @repository.github_id
        @repository.errors.add(:github_id, :blank)
        return false
      end

      repository_data = RepositoryDataBuilderService.new.build(@repository.github_id)
      @repository.update(repository_data)
    end
  end
end
