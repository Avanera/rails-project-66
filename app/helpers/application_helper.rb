# frozen_string_literal: true

module ApplicationHelper
  def get_flash_class_for(type)
    {
      success: 'alert alert-success',
      error: 'alert alert-danger',
      alert: 'alert alert-warning',
      notice: 'alert alert-info'
    }[type.to_sym]
  end

  def assign_provider
    'github'
  end
end
