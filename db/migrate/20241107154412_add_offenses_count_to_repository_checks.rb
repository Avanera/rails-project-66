class AddOffensesCountToRepositoryChecks < ActiveRecord::Migration[7.1]
  def change
    add_column :repository_checks, :offenses_count, :integer, default: 0, null: false
  end
end
