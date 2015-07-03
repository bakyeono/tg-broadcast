-- program options
run_path              = os.getenv("HOME") .. "/tg-broadcast"
cmd_path              = run_path .. "/cmd"

-- sqlite3 options
use_sqlite3           = true
sqlite3_database      = run_path .. "/subscribers.db"

-- mysql options
-- To use MySQL, you need to create database.
-- Login to your MySQL server (as root) and send below queries.
-- CREATE DATABASE tg_broadcast;
-- GRANT ALL ON tg_broadcast.* TO 'you'@'localhost';
use_mysql             = false
mysql_user            = "your_id"
mysql_password        = "your password"
mysql_database        = "tg_broadcast"

-- text file record options
-- used when both 'use_sqlite3' and 'use_mysql' are false.
subscribers_record    = run_path .. "/subscribers.record"

-- robot message header
bot_msg_header        = "(bot)" -- not applied to broadcast messages

-- cron options
cron_interval         = 1800.0 -- seconds
broadcast_min_hour    = 9      -- broadcast allowed in 09:00 ~ 18:00
broadcast_max_hour    = 18

-- broadcast options
broadcast_text_cmd    = "echo put your broadcast script here"
broadcast_text_header = "BROADCAST HEADER\n"
broadcast_text_footer = "BROADCAST FOOTER\n" ..
                        "Send 'unsubscribe' message to me if you want unsubscribe."
subscribe_msg         = " is now subscribing.\n" ..
                        "Send 'unsubscribe' message to me if you want unsubscribe."
unsubscribe_msg       = " is not subscribing anymore. Goodbye."
no_subscribe_msg      = " is already subscribing."
no_unsubscribe_msg    = " is not subscribing."

-- broadcast log options
broadcast_log         = run_path .. "/broadcast.log"
broadcast_try_log_sym = "BROADCAST   | " -- tried to broadcast
broadcast_ok_log_sym  = "BROADCASTOK | " -- broadcast was successful
no_content_log_sym    = "BROADCASTNO | " -- nothing to broadcast
subscribe_log_sym     = "SUBSCRIBE   | " -- someone joined
unsubscribe_log_sym   = "UNSUBSCRIBE | " -- someone left

-- help message
help_msg = [[
help        : This help
time        : Server's time
calendar    : Calendar
weather CITY: Weather for CITY
subscribe   : Subscribe my news
unsubscribe : Unsubscribe my news
]]
help_msg_for_admin = [[
-------------------------
(admin only)
broadcast   : Force broadcast
notify      : Send a message to subscribers
safequit    : Turn off bot
ip          : Show server ip address
cpuinfo     : /proc/cpuinfo
meminfo     : /proc/meminfo
memfree     : free
diskfree    : df
]]

-- command list
-- assign lua functions or shell program here
cmds = {
  ["help"]        = "help",
  ["subscribe"]   = "subscribe",
  ["unsubscribe"] = "unsubscribe",
  ["calendar"]    = cmd_path .. "/calendar.sh",
  ["time"]        = cmd_path .. "/date.sh",
}
cmds_with_param = {
  ["weather"]     = cmd_path .. "/query-openweathermap.org.sh"
}
cmds_for_admin = {
  ["broadcast"]   = "force_broadcast",
  ["safequit"]    = "safequit",
  ["ip"]          = cmd_path .. "/ip.sh",
  ["cpuinfo"]     = cmd_path .. "/cpuinfo.sh",
  ["meminfo"]     = cmd_path .. "/meminfo.sh",
  ["memfree"]     = cmd_path .. "/memfree.sh",
  ["diskfree"]    = cmd_path .. "/diskfree.sh"
}
cmds_with_param_for_admin = {
  ["notify"]      = "notify"
}
