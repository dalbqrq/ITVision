
print(arg[0], arg[1])


function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end


print("START")
s = os.capture("invoke-rc.d nagios stop")
print(s)

print("STOP")
s = os.capture("../bin/start_monitor")
print(s)


