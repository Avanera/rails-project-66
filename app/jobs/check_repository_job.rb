# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  def perform(repository, check)
    CheckRepositoryService.new(repository, check).run
  end
end
