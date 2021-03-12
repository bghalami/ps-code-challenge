require "rails_helper"

describe "SQL Query Validation" do
  describe "Testing View Query for Section 4" do
    it "Should Return a Table with Correct Row Names and Data" do

      Restaurant.create(name: "most chairs in ls1",
                        street_address: "1 Santa Clause Ln",
                        post_code: "LS1 101",
                        number_of_chairs: 2,
                        category: "temp")
      Restaurant.create(name: "name",
                        street_address: "1 Santa Clause Ln",
                        post_code: "LS1 101",
                        number_of_chairs: 1,
                        category: "temp")
      Restaurant.create(name: "most chairs in ls2",
                        street_address: "1 Santa Clause Ln",
                        post_code: "LS2 101",
                        number_of_chairs: 4,
                        category: "temp")
      Restaurant.create(name: "name",
                        street_address: "1 Santa Clause Ln",
                        post_code: "LS2 101",
                        number_of_chairs: 3,
                        category: "temp")

      new_table = Restaurant.find_by_sql(
        "SELECT post_code,
              COUNT(street_address) AS total_places,
              SUM(number_of_chairs) AS total_chairs,
              ROUND((SUM(number_of_chairs) * 100.00) / ((SELECT SUM(number_of_chairs) FROM restaurants) * 100.00) * 100, 2) AS chairs_pct,
              cafes_with_max_chairs_in_post_code.name AS place_with_max_chairs,
              MAX(number_of_chairs) AS max_chairs
       FROM   restaurants
       JOIN  (SELECT restaurants.name, restaurants.post_code AS max_post_code
              FROM restaurants
              JOIN (SELECT post_code, MAX(number_of_chairs) as max_number_of_chairs
                    FROM restaurants
                    GROUP BY post_code) max_chairs_in_post_code
              ON   restaurants.post_code = max_chairs_in_post_code.post_code
              AND  restaurants.number_of_chairs = max_chairs_in_post_code.max_number_of_chairs) cafes_with_max_chairs_in_post_code
       ON     cafes_with_max_chairs_in_post_code.max_post_code = post_code
       GROUP BY post_code, cafes_with_max_chairs_in_post_code.name
       ORDER BY post_code")

       expect(new_table.size).to eq(2)
       expect(new_table[0].post_code).to eq("LS1 101")
       expect(new_table[0].total_places).to eq(2)
       expect(new_table[0].total_chairs).to eq(3)
       expect(new_table[0].place_with_max_chairs).to eq("most chairs in ls1")
       expect(new_table[0].max_chairs).to eq(2)
       expect(new_table[1].post_code).to eq("LS2 101")
       expect(new_table[1].total_places).to eq(2)
       expect(new_table[1].total_chairs).to eq(7)
       expect(new_table[1].place_with_max_chairs).to eq("most chairs in ls2")
       expect(new_table[1].max_chairs).to eq(4)

       total_percentage = new_table[0].chairs_pct + new_table[1].chairs_pct
       expect(total_percentage).to eq(100.00)
     end
  end

  describe "Testing View Query for Section 6" do
    it "Should Return a Table with Correct Row Names and Data" do

      Restaurant.create(name: "name",
                        street_address: "1 Santa Clause Ln",
                        post_code: "LS1 101",
                        number_of_chairs: 2,
                        category: "ls1 small")
      Restaurant.create(name: "name",
                        street_address: "1 Santa Clause Ln",
                        post_code: "LS1 101",
                        number_of_chairs: 13,
                        category: "ls1 medium")
      Restaurant.create(name: "name",
                        street_address: "1 Santa Clause Ln",
                        post_code: "LS1 101",
                        number_of_chairs: 12,
                        category: "ls1 medium")
      Restaurant.create(name: "name",
                        street_address: "1 Santa Clause Ln",
                        post_code: "LS1 101",
                        number_of_chairs: 104,
                        category: "ls1 large")
      Restaurant.create(name: "most chairs in ls2",
                        street_address: "1 Santa Clause Ln",
                        post_code: "LS2 101",
                        number_of_chairs: 1,
                        category: "ls2 small")
      Restaurant.create(name: "name",
                        street_address: "1 Santa Clause Ln",
                        post_code: "LS2 101",
                        number_of_chairs: 3,
                        category: "ls2 large")
      Restaurant.create(name: "name",
                        street_address: "1 Santa Clause Ln",
                        post_code: "LS7 101",
                        number_of_chairs: 3,
                        category: "other")
      Restaurant.create(name: "name",
                        street_address: "1 Santa Clause Ln",
                        post_code: "LS7 101",
                        number_of_chairs: 4,
                        category: "other")

      new_table = Restaurant.find_by_sql(
        "SELECT category,
                COUNT(name) AS total_places,
                SUM(number_of_chairs) AS total_chairs
        FROM restaurants
        GROUP BY category
        ORDER BY category")

       expect(new_table.size).to eq(6)
       expect(new_table[0].category).to eq("ls1 large")
       expect(new_table[0].total_places).to eq(1)
       expect(new_table[0].total_chairs).to eq(104)
       expect(new_table[1].category).to eq("ls1 medium")
       expect(new_table[1].total_places).to eq(2)
       expect(new_table[1].total_chairs).to eq(25)
       expect(new_table[2].category).to eq("ls1 small")
       expect(new_table[2].total_places).to eq(1)
       expect(new_table[2].total_chairs).to eq(2)
       expect(new_table[3].category).to eq("ls2 large")
       expect(new_table[3].total_places).to eq(1)
       expect(new_table[3].total_chairs).to eq(3)
       expect(new_table[4].category).to eq("ls2 small")
       expect(new_table[4].total_places).to eq(1)
       expect(new_table[4].total_chairs).to eq(1)
       expect(new_table[5].category).to eq("other")
       expect(new_table[5].total_places).to eq(2)
       expect(new_table[5].total_chairs).to eq(7)
     end
  end
end
