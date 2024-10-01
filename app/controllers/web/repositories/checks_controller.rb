# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::ApplicationController
  before_action :authenticate_user!

  def show
    @check = Repository::Check.find(params[:id])
    authorize @check
  end

  def create
    @repository = Repository.find(params[:repository_id])
    @check = @repository.checks.create
    authorize @check
    CheckRepositoryJob.perform_later(@repository, @check)
    redirect_to @repository, notice: t('.success')
  end
end
