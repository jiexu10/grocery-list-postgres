require "spec_helper"

feature "user updates item from list" do
  scenario "see newly submitted item name on index" do
    grocery_id = nil
    db_connection do |conn|
      sql_query_1 = "INSERT INTO groceries (name) VALUES ($1)"
      data_1 = ["eggs"]
      conn.exec_params(sql_query_1, data_1)

      sql_query_2 = "SELECT * FROM groceries WHERE name = $1"
      data_2 = ["eggs"]
      grocery_id = conn.exec_params(sql_query_2, data_2).first["id"]

      sql_query_3 = "INSERT INTO comments (body, grocery_id) VALUES ($1, $2)"
      data_3 = ["make sure they are fresh", grocery_id]
      conn.exec_params(sql_query_3, data_3)
    end

    visit "/groceries"
    expect(page).to have_content ("eggs")
    click_link('Update')

    expect(current_path).to eq("/groceries/#{grocery_id}/edit")
    expect(find_field('Name').value).to eq("eggs")

    fill_in "Name", with: "Peanut Butter"
    click_button "Update"

    expect(page).to have_content ("Peanut Butter")
  end

  scenario "user updates with blank field" do
    grocery_id = nil
    db_connection do |conn|
      sql_query_1 = "INSERT INTO groceries (name) VALUES ($1)"
      data_1 = ["eggs"]
      conn.exec_params(sql_query_1, data_1)

      sql_query_2 = "SELECT * FROM groceries WHERE name = $1"
      data_2 = ["eggs"]
      grocery_id = conn.exec_params(sql_query_2, data_2).first["id"]

      sql_query_3 = "INSERT INTO comments (body, grocery_id) VALUES ($1, $2)"
      data_3 = ["make sure they are fresh", grocery_id]
      conn.exec_params(sql_query_3, data_3)
    end

    visit "/groceries"
    expect(page).to have_content ("eggs")
    click_link('Update')

    expect(current_path).to eq("/groceries/#{grocery_id}/edit")
    expect(find_field('Name').value).to eq("eggs")

    fill_in "Name", with: "   "
    click_button "Update"

    expect(current_path).to eq("/groceries/#{grocery_id}/edit")
    expect(page).to_not have_content ("Peanut Butter")
  end
end
