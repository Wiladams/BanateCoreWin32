-- test_Networking.lua
-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;..\\core\\?.lua;'
package.path = ppath;

require "Networking"

local node1 = IPNode("localhost")
print(node1)

local node2 = IPNode("Office-AMD")
print(node2)

local node3 = IPNode("www.google.com")
print(node3)
