-- test_Kinect1.lua

-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;..\\Kinect\\?.lua;'
package.path = ppath;


local ffi = require "ffi"
local C = ffi.C
local bit = require "bit"
local bor = bit.bor
local band = bit.band

require "BanateCore"
require "win_kernel32"
require "Kinect"

local kinectlib = ffi.load("Kinect10")
local kernel32 = ffi.load("kernel32")


function printSensorAttributes(sensor)
	print("Status: ", sensor:GetStatus())

	print("Sensor Index: ", sensor:GetSensorIndex())
end

function testCameraAdjust(sensor)
	-- Play with camera angle
	print("CAMERA ANGLE MIN: ", NUI_CAMERA_ELEVATION_MINIMUM)
	print("CAMERA ANGLE MAX: ", NUI_CAMERA_ELEVATION_MAXIMUM)

	print("Current Elevation Angle: ", sensor:GetCameraElevationAngle())

--sensor:SetCameraElevationAngle(NUI_CAMERA_ELEVATION_MINIMUM)
--print("Set At Minimum Elevation Angle: ", sensor:GetCameraElevationAngle())


--sensor:SetCameraElevationAngle(NUI_CAMERA_ELEVATION_MAXIMUM)
--print("Set At Maximum Elevation Angle: ", sensor:GetCameraElevationAngle())

	sensor:SetCameraElevationAngle(0)
	print("Set Neutral Angle: ", sensor:GetCameraElevationAngle())
end


function testVideoStream(sensor)

	function printVideoFrame(frame)
		--if frame==nil then return end

		print("Image Frame")
		print("Number: ", frame.dwFrameNumber)
		print("Area: ", frame.ViewArea.lCenterX, frame.ViewArea.lCenterY)
		print("Resolution: ", frame.eResolution)

		local frameTexture = frame.pFrameTexture
		print("Texture: ", frameTexture)
	end

	for i=1,30 do
		print("Iteration: ", i)

		-- Poll for a frame
		sensor:GetCurrentColorFrame(1000)

		--printVideoFrame(sensor.CurrentColorFrame)

		-- Release the frame
		sensor:ReleaseCurrentColorFrame()

		-- Sleep for a second
		kernel32.Sleep(1000)
	end
end

local count = Kinect.GetSensorCount()
print("Number of Sensors: ", count)

-- Create a sensor object
local sensor0 = Kinect(0, NUI_INITIALIZE_FLAG_USES_COLOR)

--printSensorAttributes(sensor0)
--testCameraAdjust(sensor0)
testVideoStream(sensor0)

