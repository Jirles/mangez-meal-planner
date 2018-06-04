class CreateMealPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :meal_plans do |t|
      t.string :name, default: "Your Meal Plan"
      t.integer :breakfast
      t.integer :lunch
      t.integer :dinner
      t.integer :user_id, null: false 
    end
  end
end
