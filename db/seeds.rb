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
