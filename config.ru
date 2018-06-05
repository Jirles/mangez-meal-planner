require './config/environment'

use Rack::MethodOverride
use UserController
use RecipeController
use MealPlanController
run AppController
