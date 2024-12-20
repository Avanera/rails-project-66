# frozen_string_literal: true

class Repository < ApplicationRecord
  ACCEPTED_LANGUAGES = %w[Ruby JavaScript].freeze

  extend Enumerize

  belongs_to :user, touch: true
  has_many :checks, dependent: :destroy

  validates :github_id, presence: true
  enumerize :language, in: ACCEPTED_LANGUAGES
end
