local ffi = require "ffi"
local C = ffi.C
local bit = require "bit"
local band = bit.band

require "Win32Types"
require "win_user32"

ffi.cdef[[
// These are used to indicate the DeviceState flag from the
// EnumDisplayDevices call
enum {
	DISPLAY_DEVICE_ATTACHED_TO_DESKTOP = 0x00000001,
	DISPLAY_DEVICE_MULTI_DRIVER = 0x00000002,
	DISPLAY_DEVICE_PRIMARY_DEVICE = 0x00000004,
	DISPLAY_DEVICE_MIRRORING_DRIVER = 0x00000008,
	DISPLAY_DEVICE_VGA_COMPATIBLE = 0x00000010,
	DISPLAY_DEVICE_REMOVABLE = 0x00000020,
	DISPLAY_DEVICE_TS_COMPATIBLE = 0x00200000,
	DISPLAY_DEVICE_DISCONNECT = 0x02000000,
	DISPLAY_DEVICE_REMOTE = 0x04000000,
	DISPLAY_DEVICE_MODESPRUNED = 0x08000000,
};
]]


ffi.cdef[[
typedef struct tagMONITORINFOA {
  DWORD  cbSize;
  RECT   rcMonitor;
  RECT   rcWork;
  DWORD  dwFlags;
} MONITORINFOA, *LPMONITORINFOA;

enum {
	CCHDEVICENAME = 32
};

typedef struct tagMONITORINFOEXA {
  DWORD  cbSize;
  RECT   rcMonitor;
  RECT   rcWork;
  DWORD  dwFlags;
  TCHAR  szDevice[CCHDEVICENAME];
} MONITORINFOEXA, *LPMONITORINFOEXA;

typedef struct {
  DWORD cb;
  TCHAR DeviceName[32];
  TCHAR DeviceString[128];
  DWORD StateFlags;
  TCHAR DeviceID[128];
  TCHAR DeviceKey[128];
} DISPLAY_DEVICEA, *PDISPLAY_DEVICEA;
]]


ffi.cdef[[
typedef BOOL  (*MONITORENUMPROC)(HMONITOR hMonitor, HDC hdcMonitor, RECT * lprcMonitor, LPARAM dwData);


  BOOL EnumDisplayMonitors(HDC hdc, const RECT * lprcClip, MONITORENUMPROC lpfnEnum, LPARAM dwData);

  BOOL GetMonitorInfoA(HMONITOR hMonitor, MONITORINFOEXA * lpmi);

  HMONITOR MonitorFromPoint(POINT pt, DWORD dwFlags);

  HMONITOR MonitorFromRect(const RECT * lprc, DWORD dwFlags);

  HMONITOR MonitorFromWindow(  HWND hwnd, DWORD dwFlags);

  BOOL EnumDisplayDevicesA(LPCTSTR lpDevice, DWORD iDevNum, PDISPLAY_DEVICEA lpDisplayDevice, DWORD dwFlags);
]]


MonitorInfo = nil
MonitorInfo_mt = {
	__tostring = function(self)
		local str = string.format("%s\n%s", ffi.string(self.szDevice), tostring(self.rcMonitor))
		return str
	end,

	__index = {
		Init = function(self)
			cbSize = ffi.sizeof("MONITORINFOEXA")
		end,
	}
}
MonitorInfo = ffi.metatype("MONITORINFOEXA", MonitorInfo_mt)


DisplayDevice = nil
DisplayDevice_mt = {
	__tostring = function(self)
		local str = string.format("Adaptor: %s\nName: %s\nID: %s\nKey: %s",
			ffi.string(self.DeviceName),
			ffi.string(self.DeviceString),
			ffi.string(self.DeviceID),
			ffi.string(self.DeviceKey))
		return str
	end,

	__index = {
		Init = function(self)
			cb = ffi.sizeof("DISPLAY_DEVICEA")
		end,

		GetName = function(self)
			return ffi.string(self.DeviceName)
		end,

		GetDescription = function(self)
			return ffi.string(self.DeviceString)
		end,

		IsDesktop = function(self)
			local result = band(self.StateFlags, C.DISPLAY_DEVICE_ATTACHED_TO_DESKTOP)>0
			return result
		end,

		IsPrimary = function(self)
			local result = band(self.StateFlags, C.DISPLAY_DEVICE_PRIMARY_DEVICE)>0
			return result
		end,
	}
}
DisplayDevice = ffi.metatype("DISPLAY_DEVICEA", DisplayDevice_mt)


function GetPhysicalMonitors()
	local monitors = {}

	function enummonitor(hMonitor, hdcMonitor, lprcMonitor, dwData)
		-- Allocate a structure to hold the monitor info
		local monitor = ffi.new("MONITORINFOEXA[1]")
		monitor[0].cbSize = ffi.sizeof("MONITORINFOEXA")

		-- Get the monitor structure
		if C.GetMonitorInfoA(hMonitor, monitor) > 0 then
			monitor = monitor[0]
			table.insert(monitors, monitor)
		end

		return 1
	end

	C.EnumDisplayMonitors(nil, nil, enummonitor, 0)

	return monitors
end

function GetMonitorForDisplayDevice(adaptor)
	local nextdevice = ffi.new("DISPLAY_DEVICEA[1]")
	nextdevice[0].cb = ffi.sizeof("DISPLAY_DEVICEA")

	if C.EnumDisplayDevicesA(adaptor:GetName(), 0, nextdevice, 0) > 0 then
		local monitor = nextdevice[0]
		print("MONITOR")
		print(monitor)
	else
		print("No Monitors found for device: ", adaptor:GetName())
	end
	print()
	print()
end

function GetDisplayAdaptors()
	local devNum = 0

	-- Enumerate all the display devices
	local nextdevice = ffi.new("DISPLAY_DEVICEA[1]")
	nextdevice[0].cb = ffi.sizeof("DISPLAY_DEVICEA")
	while C.EnumDisplayDevicesA(nil, devNum, nextdevice, 0) > 0 do
		local adaptor = nextdevice[0]
		print("Name: ", adaptor:GetName())
		print("Description: ", adaptor:GetDescription())
		print("IS DESKTOP: ", adaptor:IsDesktop())
		print("IS PRIMARY: ", adaptor:IsPrimary())
		print()

		GetMonitorForDisplayDevice(adaptor)

		-- Allocate another device for next time through the loop
		nextdevice = ffi.new("DISPLAY_DEVICEA[1]")
		nextdevice[0].cb = ffi.sizeof("DISPLAY_DEVICEA")
		devNum = devNum + 1
	end


end

function printMonitors(monitors)
	for i=1,#monitors do
		print(monitors[i])
	end
end

--local monitors = GetPhysicalMonitors()
--printMonitors(monitors)

GetDisplayAdaptors()
