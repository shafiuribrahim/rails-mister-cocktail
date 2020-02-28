# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Ingredient.create(name: 'lemon')
Ingredient.create(name: 'ice')
Ingredient.create(name: 'mint leaves')

require 'open-uri'
require 'json'

("a".."b").each do |letter|
url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=#{letter}"
puts "getting #{letter}"
response = open(url).read
cocktail_repo = JSON.parse(response)
cocktails = cocktail_repo["drinks"]
next if cocktails.nil?
cocktails.each do |cocktail|
  new_cocktail = Cocktail.create(name: cocktail['strDrink'], description: cocktail['strInstructions'])
  i = 1
  loop do
    ingredient_name = cocktail["strIngredient#{i}"]
    ingredient_description = cocktail["strMeasure#{i}"]
    break if ingredient_name == nil
    new_ingredient = Ingredient.find_or_create_by(name: ingredient_name)
    Dose.create(cocktail: new_cocktail, ingredient: new_ingredient, description: ingredient_description)
    i += 1
    end
  end
end
