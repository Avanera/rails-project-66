# frozen_string_literal: true

require 'octokit'

class RepositoriesController < ApplicationController
  LEARN_MORE_URL = 'https://ru.hexlet.io/programs/rails/projects/66'

  before_action :authenticate_user!

  def index
    @repositories = current_user.repositories.order(created_at: :desc)
  end

  def show
    @repository = current_user.repositories.find(params[:id])
  end

  def new
    @repository = current_user.repositories.build
    @github_repos = fetch_repos_from_github
  end

  def create
    @repository = current_user.repositories.find_or_initialize_by(repository_params)
    repository_data = RepositoryDataBuilderService.new.build(@repository.github_id)
    if @repository.update(repository_data)
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

  def fetch_repos_from_github
    client = Octokit::Client.new(access_token: current_user.token, auto_paginate: true)
    Rails.logger.debug client.repos
    client.repos
  end
end
