class ChangeGithubIdTypeInRepositories < ActiveRecord::Migration[7.1]
  def up
    change_column(:repositories, :github_id, :string, null: false)
    add_index(:repositories, :github_id, unique: true)
  end

  def down
    remove_index :repositories, :github_id
    change_column :repositories, :github_id, :integer, null: true
  end
end
