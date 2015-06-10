require "config"
require "script/helper"

function create_subscribers_table()
  local query = [[
  CREATE TABLE IF NOT EXISTS subscribers
  (
  id int NOT NULL,
  PRIMARY KEY (id)
  );
  ]]
  return sqlite3(sqlite3_database, query)
end

create_subscribers_table()

function insert_subscriber(id)
  local query = [[
  INSERT INTO subscribers
  (id)
  VALUES (%d);
  ]]
  query = string.format(query,
    id
  )
  return sqlite3(sqlite3_database, query)
end

function delete_subscriber(id)
  local query = "DELETE FROM subscribers WHERE (id = ".. id ..");"
  return sqlite3(sqlite3_database, query)
end

function is_subscribing(id)
  local query = "SELECT id FROM subscribers WHERE (id = " .. id .. ");"
  local result = sqlite3(sqlite3_database, query)
  return (result ~= "")
end

function get_subscribers_ids()
  local query = "SELECT id FROM subscribers;"
  local result = sqlite3(sqlite3_database, query)
  local coll = {}
  for line in lines(result) do
    coll[line] = true
  end
  return coll
end
