-- test_stopwatch.lua
require "StopWatch"

print("StopWatch.lua - TEST")
local sw = StopWatch()
--print(sw)

print("Start: ", sw:Milliseconds())

for i=1,10 do
sw:Reset()
kernel32.Sleep(50)

--print("Seconds: ", sw:Seconds())
print("Milliseconds: ", sw:Milliseconds())

end
--print(sw)
