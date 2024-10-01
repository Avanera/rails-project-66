# frozen_string_literal: true

class Repository::CheckPolicy
  attr_reader :user, :check

  def initialize(user, check)
    @user = user
    @check = check
  end

  def show?
    user == check.repository.user
  end

  def create?
    show?
  end
end
