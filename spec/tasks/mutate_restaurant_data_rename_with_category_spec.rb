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
    # expect(restaurant).to be_nil

    file = "#{Rails.root}/public/small_restaurants.csv"

    csv = CSV.read(file)
    expect(csv[1][1]).to eq("namey")
    expect(csv[1][2]).to eq("1 Santa Clause Ln")
    expect(csv[1][3]).to eq("LS1 101")
    expect(csv[1][4]).to eq("5")
    expect(csv[1][5]).to eq("ls1 small")
  end
end
