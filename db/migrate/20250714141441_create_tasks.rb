class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.integer :status, null: false
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
