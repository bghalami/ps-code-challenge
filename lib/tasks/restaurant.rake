desc "Categorizes all restaurants in restaurant table"
namespace :restaurant do
  task :categorize => :environment do
    ls1_restaurants_under_ten = Restaurant.where("post_code LIKE :prefix", prefix: "#{'LS1 '}%").where("number_of_chairs < :small_number", small_number: 10)
    ls1_restaurants_between_ten_and_100 = Restaurant.where("post_code LIKE :prefix", prefix: "#{'LS1 '}%").where("number_of_chairs >= :small_number AND number_of_chairs < :large_number", small_number: 10, large_number: 100)
    ls1_restaurants_100_and_over = Restaurant.where("post_code LIKE :prefix", prefix: "#{'LS1 '}%").where("number_of_chairs >= :large_number", large_number: 100)

    half_of_ls2_count = Restaurant.where("post_code LIKE :prefix", prefix: "#{'LS2 '}%").count(:name)

    ls2_restaurants_top_fifty_percent = Restaurant.where("post_code LIKE :prefix", prefix: "#{'LS2 '}%").order(number_of_chairs: :desc).limit(half_of_ls2_count/2)
    ls2_restaurants_bottom_fifty_percent = Restaurant.where("post_code LIKE :prefix", prefix: "#{'LS2 '}%").order(number_of_chairs: :asc).limit(half_of_ls2_count/2)

    other_post_code_restaurants = Restaurant.where("post_code NOT LIKE :prefix_one AND post_code NOT LIKE :prefix_two", prefix_one: "#{'LS1 '}%", prefix_two: "#{'LS2 '}%")

    ls1_restaurants_under_ten.each do |restaurant|
      restaurant.category = "ls1 small"
      restaurant.save
    end
    puts "LS1 Restaurants With 10 or Fewer Chairs Successfully Categorized"

    ls1_restaurants_between_ten_and_100.each do |restaurant|
      restaurant.category = "ls1 medium"
      restaurant.save
    end
    puts "LS1 Restaurants With Between 10-100 Chairs Successfully Categorized"

    ls1_restaurants_100_and_over.each do |restaurant|
      restaurant.category = "ls1 large"
      restaurant.save
    end
    puts "LS1 Restaurants With 100 or More Chairs Successfully Categorized"

    ls2_restaurants_bottom_fifty_percent.each do |restaurant|
      restaurant.category = "ls2 small"
      restaurant.save
    end
    puts "Bottom Half of LS2 Restaurants by Number of Chairs Succesfully Categorized"

    ls2_restaurants_top_fifty_percent.each do |restaurant|
      restaurant.category = "ls2 large"
      restaurant.save
    end
    puts "Top Half of LS2 Restaurants by Number of Chairs Succesfully Categorized"

    other_post_code_restaurants.each do |restaurant|
      restaurant.category = "other"
      restaurant.save
    end
    puts "All Other Restaurants Categorized"

    puts "All Restaurants Categorized"
  end
end
