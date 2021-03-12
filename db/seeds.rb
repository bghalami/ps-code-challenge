require 'csv'
require './app/models/restaurant.rb'

class Seed
  OPTIONS = {headers: true, header_converters: :symbol}

  def self.start
    clear_existing_data
    seed_restaurants
  end

  def self.clear_existing_data
    Restaurant.destroy_all
  end

  def self.seed_restaurants
    read_restaurants.each do |restaurant|
      restaurant_hash = {name: restaurant[:cafrestaurant_name],
                        street_address: restaurant[:street_address],
                        post_code: restaurant[:post_code],
                        number_of_chairs: restaurant[:number_of_chairs],
                        category: "temp"
                        }
      new_restaurant = Restaurant.create!(restaurant_hash)
      puts "Created #{new_restaurant.name}"
    end
    puts "Created all restaurants."
    ActiveRecord::Base.connection.reset_pk_sequence!('restaurant')
  end

  def self.read_restaurants
    @restaurants = []
    CSV.foreach("./Street\ Cafes\ 2020-21.csv", OPTIONS) do |restaurant|
      @restaurants << restaurant
    end
    @restaurants
  end
end

Seed.start
