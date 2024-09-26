# frozen_string_literal: true

class Repository < ApplicationRecord
  belongs_to :user
  validates :github_id, presence: true
end
