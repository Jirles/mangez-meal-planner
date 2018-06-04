class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.string :ingredients, null: false
      t.string :instruction, null: false
    end
  end
end
