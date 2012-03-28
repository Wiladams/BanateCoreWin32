-- test_Kinect1.lua

-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;Kinect\\?.lua;'
package.path = ppath;


local ffi = require "ffi"


require "BanateCore"
require "KinectSensor"

require "NuiApi"
local kinectlib = ffi.load("Kinect10")

class.Kinect()

function Kinect.GetSensorCount()
	local count = ffi.new("int32_t[1]")
	local hr = kinectlib.NuiGetSensorCount(count)
	count = count[0]

	return count
end

function Kinect.GetSensorByIndex(idx, flags)
	return KinectSensor(idx, flags)
end





