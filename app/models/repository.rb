# frozen_string_literal: true

class Repository < ApplicationRecord
  ACCEPTED_LANGUAGES = ['Ruby'].freeze

  extend Enumerize

  belongs_to :user, touch: true
  validates :github_id, presence: true
  enumerize :language, in: ACCEPTED_LANGUAGES
end
