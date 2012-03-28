-- test_Kinect1.lua

-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;Kinect\\?.lua;'
package.path = ppath;


local ffi = require "ffi"
local C = ffi.C
local bit = require "bit"
local bor = bit.bor
local band = bit.band

require "NuiApi"
require "BanateCore"
require "win_kernel32"

local kinectlib = ffi.load("Kinect10")
local kernel32 = ffi.load("kernel32")

class.Kinect()

function Kinect.GetSensorCount()
	local count = ffi.new("int32_t[1]")
	local hr = kinectlib.NuiGetSensorCount(count)
	count = count[0]

	return count
end


function Kinect:_init(index, flags)
	local psensor = ffi.new("PINuiSensor[1]")
	local hr = kinectlib.NuiCreateSensorByIndex(index, psensor)

	local severity, facility, code = HRESULT_PARTS(hr)

	-- If there was an error, then return early
	if severity == 1 then return nil end

	self.Sensor = psensor[0]
	self.VTable = self.Sensor.lpVtbl


	-- Create events for signaling
	self.NextColorFrameEvent = kernel32.CreateEventA(nil, true, false, nil);
	self.NextDepthFrameEvent = kernel32.CreateEventA(nil, true, false, nil);
	self.NextSkeletonEvent = kernel32.CreateEventA(nil, true, false, nil);

	self:Initialize(flags)

	self:GetVideoStream()
end

--
-- Some attributes
--

function Kinect:GetCameraElevationAngle()
	local angle = ffi.new("long[1]")
	local hr = self.VTable.NuiCameraElevationGetAngle(self.Sensor, angle)
	angle = angle[0]

	return angle
end

function Kinect:SetCameraElevationAngle(angle)
	if angle < NUI_CAMERA_ELEVATION_MINIMUM then
		angle = NUI_CAMERA_ELEVATION_MINIMUM
	elseif angle > NUI_CAMERA_ELEVATION_MAXIMUM then
		angle = NUI_CAMERA_ELEVATION_MAXIMUM
	end

	local hr = self.VTable.NuiCameraElevationSetAngle(self.Sensor, angle)
	local severity, facility, code = HRESULT_PARTS(hr)
end


function Kinect:GetConnectionID()
	self.ConnectionID = self.VTable.NuiDeviceConnectionId(self.Sensor);
	return self.ConnectionID
end

function Kinect:GetSensorIndex()
	local index = self.VTable.NuiInstanceIndex(self.Sensor)
	return index
end

function Kinect:GetStatus()
	local hr = self.VTable.NuiStatus(self.Sensor)
	local severity, facility, code = HRESULT_PARTS(hr)
	return severity, facility, code
end

--[[
	Some Actual Functions
--]]
function Kinect:Initialize(flags)
	flags = flags or bor(NUI_INITIALIZE_FLAG_USES_AUDIO,
		NUI_INITIALIZE_FLAG_USES_DEPTH_AND_PLAYER_INDEX ,
		NUI_INITIALIZE_FLAG_USES_COLOR,
		NUI_INITIALIZE_FLAG_USES_SKELETON,
		NUI_INITIALIZE_FLAG_USES_DEPTH)

	local hr = self.VTable.NuiInitialize(self.Sensor, flags)

	local severity, facility, code = HRESULT_PARTS(hr)

	self.CurrentColorFrame = ffi.new("NUI_IMAGE_FRAME")
	self.LockedRect = ffi.new("NUI_LOCKED_RECT")

	return severity, facility, code
end


function Kinect:GetVideoStream()
	local handle = ffi.new("HANDLE[1]")

	local hr = self.VTable.NuiImageStreamOpen(self.Sensor,
		C.NUI_IMAGE_TYPE_COLOR,
		C.NUI_IMAGE_RESOLUTION_640x480,
		0,
		2,
		self.NextColorFrameEvent,
		handle)

	self.VideoStreamHandle = handle[0]

--print("Handle: ", self.VideoStreamHandle)
	local severity, facility, code = HRESULT_PARTS(hr)

--print("Kinect:GetVideoStream: ", severity, facility, code)

	-- If there's an error, return nil
	if severity == 1 then return nil end

	return handle
end

function Kinect:GetCurrentColorFrame(timeout)
	timeout = timeout or 100

	local imageFrame = ffi.new("NUI_IMAGE_FRAME[1]")
	local hr = self.VTable.NuiImageStreamGetNextFrame(self.Sensor,
		self.VideoStreamHandle,
		timeout,
		imageFrame)

	--local imageFrame = ffi.new("NUI_IMAGE_FRAME[1]")
	--local hr = kinectlib.NuiImageStreamGetNextFrame(self.VideoStreamHandle,
	--	timeout,imageFrame)

	-- If the call succedded, preserve the frame
	-- for later release
	self.CurrentColorFrame = imageFrame[0]

	local severity, facility, code = HRESULT_PARTS(hr)
--	print("Kinect:GetNextVideoFrame: ", severity, facility, code)

	-- If the call failed, then return failure (false)
	if severity == 1 then
		return false
	end


	-- Get the texture object out
	-- lock the bits, for later rendering
	self.CurrentTexture = self.CurrentColorFrame.pFrameTexture
	self.LockedRect = ffi.new("NUI_LOCKED_RECT[1]")

	hr = self.CurrentTexture.lpVtbl.LockRect(self.CurrentTexture,
		0,
		self.LockedRect,
		nil,
		0)
	local severity, facility, code = HRESULT_PARTS(hr)
--print("Lock Rect: ", severity, facility, code)
	self.LockedRect = self.LockedRect[0]

	return true
end

function Kinect:ReleaseCurrentColorFrame()
	local hr = self.CurrentTexture.lpVtbl.UnlockRect(self.CurrentTexture,0)

	hr = self.VTable.NuiImageStreamReleaseFrame(self.Sensor,
		self.VideoStreamHandle,
		self.CurrentColorFrame)

	local severity, facility, code = HRESULT_PARTS(hr)
--	print("Kinect:ReleaseCurrentColorFrame: ", severity, facility, code)
end


