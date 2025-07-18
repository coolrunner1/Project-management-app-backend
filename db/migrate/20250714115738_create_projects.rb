class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.string :description
      t.references :user, null: false, foreign_key: { on_delete: :cascade, on_update: :cascade }

      t.timestamps
    end
  end
end
