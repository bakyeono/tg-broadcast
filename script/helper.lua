-- helpers & utilities

function vardump(value, depth, key)
  local line_prefix = ""
  local spaces = ""
  
  if key ~= nil then
    line_prefix = "[" .. key .. "] = "
  end
  
  if depth == nil then
    depth = 0
  else
    depth = depth + 1
    for i=1, depth do spaces = spaces ..  "  " end
  end
  
  if type(value) == 'table' then
    mTable = getmetatable(value)
    if mTable == nil then
      print(spaces .. line_prefix .. "(table) ")
    else
    print(spaces .. "(metatable) ")
      value = mTable
    end    
    for table_key, table_value in pairs(value) do
      vardump(table_value, depth, table_key)
    end
  elseif type(value)  == 'function' or 
    type(value)  == 'thread' or 
    type(value)  == 'userdata' or
    value    == nil
  then
    print(spaces .. tostring(value))
  else
    print(spaces .. line_prefix .. "(" .. type(value) .. ") " .. tostring(value))
  end
end

function lines(str)
  return str:gmatch("([^\r\n]+)[\r\n]")
end

function write_set(filename, set)
  local file = io.open(filename, "w")
  io.output(file)
  for id, _ in pairs(set) do
    io.write(id .. "\n")
  end
  io.close(file)
end

function read_set(filename)
  local set = {}
  local file = io.open(filename, "r")
  if (file == nil) then
    return set
  end
  if (file:lines() == nil) then
    io.close(file)
    return set
  end
  for line in file:lines() do
    set[line] = true
  end
  io.close(file)
  return set
end

function write_broadcast_log(content)
  local file = io.open(broadcast_log, "a")
  io.output(file)
  io.write(os.date("%F %T") .. " | " .. content .. "\n")
  io.close(file)
end

function return_cmd_output(cmd)
  local execute = io.popen(cmd)
  local result = execute:read("*a")
  execute:close()
  return result
end

function mysql(query)
  local cmd = "mysql -bsN " .. 
      "-u '" .. mysql_user     .. "' " .. 
      "-p"   .. mysql_password .. " "  .. 
      "-D '" .. mysql_database .. "' " .. 
      "-e '" .. query          .. "'"
  return return_cmd_output(cmd)
end

function sqlite3(database, query)
  local cmd = "sqlite3 " .. database .. " '" ..
      "BEGIN; " .. query .. " COMMIT;'"
  return return_cmd_output(cmd)
end
