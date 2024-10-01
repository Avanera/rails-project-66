# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::ApplicationController
  before_action :authenticate_user!

  def show
    @check = Repository::Check.find(params[:id])
  end
end
