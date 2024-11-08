class CreateRepositoryOffenses < ActiveRecord::Migration[7.1]
  def change
    create_table :repository_offenses do |t|
      t.string :path
      t.string :rule_id
      t.string :message
      t.string :coords
      t.string :github_url
      t.references :check, null: false, foreign_key: { to_table: :repository_checks }, index: true

      t.timestamps
    end
  end
end
