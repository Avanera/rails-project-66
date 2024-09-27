# frozen_string_literal: true

class LinterStub
  def lint(*)
    { success: true, messages: [] }
  end
end
