# frozen_string_literal: true

class RepositoryPolicy
  attr_reader :user, :repository

  def initialize(user, repository)
    @user = user
    @repository = repository
  end

  def show?
    user == repository.user
  end

  def new?
    user
  end

  def create?
    new?
  end
end
