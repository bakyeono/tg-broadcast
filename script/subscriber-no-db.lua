require "config"
require "script/helper"

subscribers = read_set(subscribers_record)

function insert_subscriber(id)
  subscribers[id] = true
  write_set(subscribers_record, subscribers)
end

function delete_subscriber(id)
  subscribers[id] = nil
  write_set(subscribers_record, subscribers)
end

function is_subscribing(id)
  return (subscribers[id] ~= nil)
end

function get_subscribers_ids()
  return subscribers
end

