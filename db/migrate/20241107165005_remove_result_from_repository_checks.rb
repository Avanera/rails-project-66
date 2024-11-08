class RemoveResultFromRepositoryChecks < ActiveRecord::Migration[7.1]
  def change
    remove_column :repository_checks, :result, :string
  end
end
