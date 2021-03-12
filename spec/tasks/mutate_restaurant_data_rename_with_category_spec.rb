require 'rails_helper'
require 'rake'
require 'csv'

Rails.application.load_tasks

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
    restaurant.reload
    expect(restaurant.category).to be_nil

    file = "#{Rails.root}/public/small_restaurants.csv"

    csv = CSV.open(file)
    expect(csv[1].name).to eq("namey")
    expect(csv[1].street_address).to eq("1 Santa Clause Ln")
    expect(csv[1].post_code).to eq("LS1 101")
    expect(csv[1].number_of_chairs).to eq(5)
    expect(csv[1].category).to eq("ls1 small")
  end
end
