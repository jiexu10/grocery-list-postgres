require "sinatra"
require "pg"
require "pry"

configure :development do
  set :db_config, { dbname: "grocery_list_development" }
end

configure :test do
  set :db_config, { dbname: "grocery_list_test" }
end

def db_connection
  begin
    connection = PG.connect(Sinatra::Application.db_config)
    yield(connection)
  ensure
    connection.close
  end
end

# FILENAME = "grocery_list.txt"

def get_grocery_list
  db_connection do |conn|
    sql_query = %(SELECT * FROM groceries)
    conn.exec(sql_query)
  end
end

def add_grocery_item(item)
  db_connection do |conn|
    sql_query = %(INSERT INTO groceries (name) VALUES ($1))
    data = [item]
    conn.exec_params(sql_query, data)
  end
end

def get_item_info(id)
  info = {}
  data = [id]
  db_connection do |conn|
    sql_query = %(SELECT * FROM groceries WHERE id = $1)
    info["grocery"] = conn.exec_params(sql_query, data)

    sql_query = %(
    SELECT groceries.id AS groceries_id, groceries.name, comments.body
    FROM groceries
    JOIN comments ON groceries.id = comments.grocery_id
    WHERE groceries.id = $1
    )
    info["comments"] = conn.exec_params(sql_query, data)
  end
  info
end

get "/" do
  redirect "/groceries"
end

get "/groceries" do
  @groceries = get_grocery_list
  erb :groceries
end

post "/groceries" do
  unless params[:name].strip.empty?
    add_grocery_item(params[:name])
  end
  redirect "/groceries"
end

get "/groceries/:id" do
  item_info = get_item_info(params["id"])
  @grocery_item = item_info["grocery"].first
  @comments = item_info["comments"]
  erb :show
end
