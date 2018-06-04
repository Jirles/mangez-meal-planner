#Users
@user = User.create(username: "test queen", email: "all_hail@test.com", password: "supersecret")
@user2 = User.create(username: "the best ever", email: "awesome@me.com", password: "thebestpassword")
@user3 = User.create(:username => "testking", :email => "long_live_the_king@test.com", :password => "testingtesting")

#Recipes
@mac_n_cheese = Recipe.create(name: "Mac 'n' Cheese", ingredients: "cheese, macaroni, milk, butter", instruction: "mix it together in a pot", user_id: @user.id)
@cobb_salad = Recipe.create(name: "Cobb Salad", ingredients: "lettuce greens, eggs, chicken, dressing of choice", instruction: "mix it together in a bowl", user_id: @user.id)
@cereal = Recipe.create(name:"Fruity Pebbles", ingredients: "fruity pebbles, milk", instruction:"pour into a bowl", user_id: @user.id)
@oatmeal = Recipe.create(name: "Savory Oatmeal", ingredients: "oatmeal, vegetable stock, spinach, egg", instruction: "make oatmeal with vegetable stock, top with wilted spinach and a fried egg", user_id: @user2.id)
@hamburger = Recipe.create(name: "Hamburger", ingredients: "beef, onion, buns, ketchup, tomato", instruction: "put them together", user_id: @user2.id)
@banana_pb = Recipe.create(name: "Bananas with Peanut Butter", ingredients: "bananas, peanut butter", instruction: "eat the bananas with peanut butter", user_id: @user3.id)
@stew = Recipe.create(name: "Beef Stew", ingredients: "beef, onion, carrot, potato, water", instruction: "throw it in a pot and simmer", user_id: @user3.id)
@fried_rice = Recipe.create(name: "Fried Rice", ingredients: "rice, onions, carrots, soy sauce, oil", instruction: "fry it in a pan", user_id: @user3.id)

#Meal Plans
@meal_plan = MealPlan.create(name: "Rockin' Meal Plan", breakfast: @cereal.id, lunch: @cobb_salad.id, dinner: @mac_n_cheese.id, user_id: @user.id)
@meal_plan2 = MealPlan.create(breakfast: @oatmeal.id, dinner: @hamburger.id, user_id: @user2.id)
@meal_plan3 = MealPlan.create(name: "Thursday", breakfast: @banana_pb.id, lunch: @stew.id, dinner: @fried_rice.id, user_id: @user3.id)
