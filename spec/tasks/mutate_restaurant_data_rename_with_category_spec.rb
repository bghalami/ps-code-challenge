require 'rails_helper'
require 'csv'

describe 'mutate restaurant data' do
  let (:run_rake_task) do
    Rake::Task["restaurant:rename_with_category"].invoke
  end

  after(:each) do
    Rake::Task["restaurant:rename_with_category"].reenable
  end

  it "should send small restaurant data to csv and remove from db" do
    restaurant = Restaurant.create(name: "namey",
                                    street_address: "1 Santa Clause Ln",
                                    post_code: "LS1 101",
                                    number_of_chairs: 5,
                                    category: "ls1 small")
    expect(restaurant).to be_truthy
    run_rake_task
    expect{restaurant.reload}.to raise_error(ActiveRecord::RecordNotFound)

    file = "#{Rails.root}/public/small_restaurants.csv"

    csv = CSV.read(file)
    expect(csv[1][1]).to eq("namey")
    expect(csv[1][2]).to eq("1 Santa Clause Ln")
    expect(csv[1][3]).to eq("LS1 101")
    expect(csv[1][4]).to eq("5")
    expect(csv[1][5]).to eq("ls1 small")
  end

  it "should amend medium and large restaurant names" do
    restaurant_one = Restaurant.create(name: "name",
                                      street_address: "1 Santa Clause Ln",
                                      post_code: "LS1 101",
                                      number_of_chairs: 64,
                                      category: "ls1 medium")
    restaurant_two = Restaurant.create(name: "namey",
                                      street_address: "1 Santa Clause Ln",
                                      post_code: "LS1 101",
                                      number_of_chairs: 140,
                                      category: "ls2 large")

    expect(restaurant_one.name).to eq("name")
    expect(restaurant_two.name).to eq("namey")
    run_rake_task
    restaurant_one.reload
    restaurant_two.reload
    expect(restaurant_one.name).to eq("ls1 medium name")
    expect(restaurant_two.name).to eq("ls2 large namey")
  end
end
