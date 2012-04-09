require "DaytimeClient"

local dtc = DaytimeClient("192.168.1.6")

print("client ready to run")

dtc:Run()
