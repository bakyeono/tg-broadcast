-- program options
run_path              = os.getenv("HOME") .. "/tg-broadcast"
cmd_path              = run_path .. "/cmd"

-- sqlite3 options
use_sqlite3           = true
sqlite3_database      = run_path .. "/subscribers.db"

-- mysql options
use_mysql             = false
mysql_user            = "your_id"
mysql_password        = "your password"
mysql_database        = "tg-broadcast"

-- text file record options
-- used when both 'use_sqlite3' and 'use_mysql' are false.
subscribers_record    = run_path .. "/subscribers.record"

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
ip          : Server's IP address
time        : Server's time
calendar    : Calendar
weather CITY: Weather for CITY
subscribe   : Subscribe my news
unsubscribe : Unsubscribe my news
]]
hidden_help_msg = [[
-------------------------
(admin only)
broadcast   : Force broadcast now
safequit    : Turn off robot
]]

-- command list
-- assign lua functions or shell program here
cmds = {
  ["help"]        = "help",
  ["safequit"]    = "safequit",
  ["broadcast"]   = "force_broadcast",
  ["subscribe"]   = "subscribe",
  ["unsubscribe"] = "unsubscribe",
  ["calendar"]    = cmd_path .. "/calendar.sh",
  ["time"]        = cmd_path .. "/date.sh",
  ["ip"]          = cmd_path .. "/ip.sh"
}
cmds_with_param = {
  ["weather"]     = cmd_path .. "/query-openweathermap.org.sh"
}

