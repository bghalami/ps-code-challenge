require 'rails_helper'
require 'rake'

Rails.application.load_tasks

describe 'mutate restaurant data' do
  let (:run_rake_task) do
    Rake::Task["restaurant:categorize"].invoke
  end

  after(:each) do
    Rake::Task["restaurant:categorize"].reenable
  end

  it "should correctly categorize restaurants with under 10 chairs in the LS1 post code" do
    restaurant = Restaurant.create(name: "namey",
                                    street_address: "1 Santa Clause Ln",
                                    post_code: "LS1 101",
                                    number_of_chairs: 5,
                                    category: "temp")
    expect(restaurant.category).to eq("temp")
    run_rake_task
    restaurant.reload
    expect(restaurant.category).to eq("ls1 small")
  end

  it "should correctly categorize restaurants with under between 10-100 chairs in the LS1 post code" do
    restaurant_one = Restaurant.create(name: "name",
                                      street_address: "1 Santa Clause Ln",
                                      post_code: "LS1 101",
                                      number_of_chairs: 10,
                                      category: "temp")
    restaurant_two = Restaurant.create(name: "name",
                                      street_address: "1 Santa Clause Ln",
                                      post_code: "LS1 101",
                                      number_of_chairs: 99,
                                      category: "temp")

    expect(restaurant_one.category).to eq("temp")
    expect(restaurant_two.category).to eq("temp")
    run_rake_task
    restaurant_one.reload
    restaurant_two.reload
    expect(restaurant_one.category).to eq("ls1 medium")
    expect(restaurant_two.category).to eq("ls1 medium")
  end

  it "should correctly categorize restaurants with 100 or more chairs in the LS1 post code" do
    restaurant = Restaurant.create(name: "namey",
                                    street_address: "1 Santa Clause Ln",
                                    post_code: "LS1 101",
                                    number_of_chairs: 100,
                                    category: "temp")
    expect(restaurant.category).to eq("temp")
    run_rake_task
    restaurant.reload
    expect(restaurant.category).to eq("ls1 large")
  end

  it "should correctly categorize restaurants with the top half and bottom half restaurants in the LS2 post code" do
    restaurant_one = Restaurant.create(name: "name",
                                      street_address: "1 Santa Clause Ln",
                                      post_code: "LS2 101",
                                      number_of_chairs: 1,
                                      category: "temp")
    restaurant_two = Restaurant.create(name: "name",
                                      street_address: "1 Santa Clause Ln",
                                      post_code: "LS2 101",
                                      number_of_chairs: 2,
                                      category: "temp")
    restaurant_three = Restaurant.create(name: "name",
                                        street_address: "1 Santa Clause Ln",
                                        post_code: "LS2 101",
                                        number_of_chairs: 3,
                                        category: "temp")
    restaurant_four = Restaurant.create(name: "name",
                                        street_address: "1 Santa Clause Ln",
                                        post_code: "LS2 101",
                                        number_of_chairs: 4,
                                        category: "temp")

    expect(restaurant_one.category).to eq("temp")
    expect(restaurant_two.category).to eq("temp")
    expect(restaurant_three.category).to eq("temp")
    expect(restaurant_four.category).to eq("temp")
    run_rake_task
    restaurant_one.reload
    restaurant_two.reload
    restaurant_three.reload
    restaurant_four.reload
    expect(restaurant_one.category).to eq("ls2 small")
    expect(restaurant_two.category).to eq("ls2 small")
    expect(restaurant_three.category).to eq("ls2 large")
    expect(restaurant_four.category).to eq("ls2 large")
  end

  it "should correctly categorize all other restaurants in other post codes" do
    restaurant_one = Restaurant.create(name: "name",
                                      street_address: "1 Santa Clause Ln",
                                      post_code: "LS7 101",
                                      number_of_chairs: 10,
                                      category: "temp")
    restaurant_two = Restaurant.create(name: "name",
                                      street_address: "1 Santa Clause Ln",
                                      post_code: "LS8 101",
                                      number_of_chairs: 99,
                                      category: "temp")

    expect(restaurant_one.category).to eq("temp")
    expect(restaurant_two.category).to eq("temp")
    run_rake_task
    restaurant_one.reload
    restaurant_two.reload
    expect(restaurant_one.category).to eq("other")
    expect(restaurant_two.category).to eq("other")
  end

end
