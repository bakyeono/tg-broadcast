require "config"
require "script/helper"

started = 0
our_id = 0
now = os.time()

-- reply

function reply(msg, text)
  --[[ where to reply?
  case    | from      | to         | reply to
  ------- | --------- | ---------- | --------
  0       | me        | me         | to
  1       | me        | someone    | to
  2       | me        | chat       | to
  3       | someone   | me         | from
  4       | someone   | someone    | 
  5       | someone   | chat       | to
  ------- | --------- | ---------- | --------
  ]]--

  -- case 0, 1, 2
  if (msg.from.id == our_id) then
    send_msg(msg.to.type .. "#" .. msg.to.id, bot_msg_header .. text, ok_cb, false)
    return
  end

  -- case 3
  if (msg.to.type == 'user' and msg.to.id == our_id) then
    send_msg(msg.from.type .. "#" .. msg.from.id, bot_msg_header .. text, ok_cb, false)
    return
  end

  -- case 5
  if (msg.to.type == 'chat') then
    send_msg(msg.to.type .. "#" .. msg.to.id, bot_msg_header .. text, ok_cb, false)
    return
  end
end


-- broadcast functions

if use_sqlite3 then
  require "script/subscriber-sqlite3"
elseif use_mysql then
  require "script/subscriber-mysql"
else
  require "script/subscriber-no-db"
end

function subscribe(msg)
  local id = tostring(msg.from.id)
  local name = string.gsub(msg.from.print_name, "_", " ")
  if is_subscribing(id) then
    reply(msg, name .. no_subscribe_msg)
  else
    insert_subscriber(id);
    write_broadcast_log(subscribe_log_sym .. "user#" .. id .. " " .. name)
    reply(msg, name .. subscribe_msg)
  end
end

function unsubscribe(msg)
  local id = tostring(msg.from.id)
  local name = string.gsub(msg.from.print_name, "_", " ")
  if is_subscribing(id) then
    delete_subscriber(id)
    reply(msg, name .. unsubscribe_msg)
    write_broadcast_log(unsubscribe_log_sym .. "user#" .. id .. " " .. name)
  else
    reply(msg, name .. no_unsubscribe_msg)
  end
end

function send_msg_to_subscribers(text)
  local count = 0;
  for id, _ in pairs(get_subscribers_ids()) do
    send_msg("user#" .. id, text, ok_cb, false)
    count = count + 1;
  end
  return count
end

function broadcast()
  local text = return_cmd_output(broadcast_text_cmd)
  write_broadcast_log(broadcast_try_log_sym .. "try to broadcast .. .")
  if (text == "") then
    write_broadcast_log(no_content_log_sym .. "nothing to broadcast.")
    return
  end
  text = broadcast_text_header .. text .. broadcast_text_footer
  local count = send_msg_to_subscribers(text)
  write_broadcast_log(broadcast_ok_log_sym .. "message sent to " .. count .. " subscribers.")
end

function force_broadcast(msg)
  if (msg.from.id == our_id) then
    broadcast()
  end
end

function notify(msg, text)
  if (msg.from.id == our_id) then
    local count = send_msg_to_subscribers(text)
    reply(msg, "Sent message to " .. count .. " subscribers.")
  end
end


-- commands

function call_cmd(msg, cmd, param)
  -- if cmd is lua function, call it
  if _G[cmd] then
    if param then
      param = string.gsub(param, "[^ ,.?!0-9A-Za-z]", "") -- prvent code injection
      _G[cmd](msg, param)
    else
      _G[cmd](msg)
    end
    -- if cmd is not lua function, call it as shell command.
  else
    local text
    if param then
      param = string.gsub(param, "[^ ,0-9A-Za-z]", "") -- prvent code injection (shell)
      text = return_cmd_output(cmd .. " " .. param)
    else
      text = return_cmd_output(cmd)
    end
    reply(msg, text)
  end
end

function handle_msg(msg)
  local cmd = parse_cmd(msg)
  if cmd then
    return call_cmd(msg, cmd)
  end
  local cmd_with_param = parse_cmd_with_param(msg)
  if cmd_with_param then
    local param = string.gsub(msg.text, "^[0-9A-Za-z가-힣_-]+ ", "", 1)
    return call_cmd(msg, cmd_with_param, param)
  end
end

function help(msg)
  local text = help_msg
  if (msg.from.id == our_id) then
    text = text .. help_msg_for_admin
  end
  reply(msg, text)
end

function safequit(msg)
  if (msg.from.id == our_id) then
    reply(msg, "Robot: Goodbye.")
    safe_quit()
  end
end


-- telegram-cli callbacks

function ok_cb(extra, success, result)
end

function parse_cmd(msg)
  local cmd = (string.match(msg.text, "^([0-9A-Za-z_-]+)$"))
  if cmd then
    if (msg.from.id == our_id) then
      cmd = (cmds_for_admin[string.lower(cmd)] or cmds[string.lower(cmd)])
    else
      cmd = cmds[string.lower(cmd)]
    end
  end
  return cmd
end

function parse_cmd_with_param(msg)
  local cmd = (string.match(msg.text, "^([0-9A-Za-z_-]+)"))
  if cmd then
    if (msg.from.id == our_id) then
      cmd = (cmds_with_param_for_admin[string.lower(cmd)] or cmds_with_param[string.lower(cmd)])
    else
      cmd = cmds_with_param[string.lower(cmd)]
    end
  end
  return cmd
end

function on_msg_receive(msg)
  if (started == 0) then
    return
  end
  if (msg.date < now) then
    return
  end
  if (msg.text == nil) then
    return
  end
  if (msg.unread == 0) then
    return
  end 
  handle_msg(msg)
end

function on_our_id(id)
  our_id = id
end

function on_secret_chat_created(peer)
end

function on_user_update(user)
end

function on_chat_update(user)
end

function on_get_difference_end()
end


-- cron

function cron()
  local hour = tonumber(return_cmd_output("date +'%H'"))
  if (broadcast_min_hour <= hour and hour < broadcast_max_hour) then
    broadcast()
  end
  postpone(cron, false, cron_interval)
end

function on_binlog_replay_end()
  started = 1
  postpone(cron, false, 1.0)
end

