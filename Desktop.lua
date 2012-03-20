-- Desktop.lua
local ffi = require "ffi"
local C = ffi.C

require "Win32Types"
require "win_user32"

ffi.cdef[[

typedef BOOL (__stdcall *DESKTOPENUMPROCA)(LPTSTR lpszDesktop, LPARAM lParam);
typedef BOOL (__stdcall *WINSTAENUMPROCA)(LPTSTR stationname, LPARAM lParam);



// CloseDesktop
BOOL CloseDesktopA(HDESK hDesktop);

// CreateDesktop
HDESK CreateDesktopA(LPCTSTR lpszDesktop, LPCTSTR lpszDevice,
	PDEVMODE pDevmode,DWORD dwFlags,
	ACCESS_MASK dwDesiredAccess, LPSECURITY_ATTRIBUTES lpsa);


// EnumDesktops
BOOL EnumDesktopsA(HWINSTA hwinsta, DESKTOPENUMPROCA lpEnumFunc, LPARAM lParam);

// EnumDesktopWindows
BOOL EnumDesktopWindows(HDESK hDesktop, WNDENUMPROC lpfn, LPARAM lParam);


// GetThreadDesktop
HDESK GetThreadDesktop(DWORD dwThreadId);

// OpenDesktop
HDESK OpenDesktop(LPCTSTR lpszDesktop, DWORD dwFlags, BOOL fInherit, ACCESS_MASK dwDesiredAccess);


// OpenInputDesktop
HDESK OpenInputDesktop(DWORD dwFlags, BOOL fInherit, ACCESS_MASK dwDesiredAccess);

// SetThreadDesktop
BOOL SetThreadDesktop(HDESK hDesktop);

// SwitchDesktop
BOOL SwitchDesktop(HDESK hDesktop);

// PaintDesktop
BOOL PaintDesktop(HDC hdc);


// Window Station
BOOL CloseWindowStation(HWINSTA hWinSta);

HWINSTA CreateWindowStationA(LPCTSTR lpwinsta,
  DWORD dwFlags,
  ACCESS_MASK dwDesiredAccess,
  LPSECURITY_ATTRIBUTES lpsa);

BOOL EnumWindowStationsA(WINSTAENUMPROCA lpEnumFunc, LPARAM lParam);


HWINSTA GetProcessWindowStation();

BOOL LockWorkStation(void);

HWINSTA OpenWindowStation(LPTSTR lpszWinSta, BOOL fInherit, ACCESS_MASK dwDesiredAccess);

BOOL SetProcessWindowStation(HWINSTA hWinSta);

]]

function CreateDesktop(desktopName, dwFlags, dwAccess, lpsa)
	return C.CreateDesktop(desktopName, nil, nil, dwFlags, dwAccess, lpsa);
end

--jit.off(GetDesktops)
function GetDesktops(winsta)
	local desktops = {}

	--jit.off(enumdesktop)
	function enumdesktop(desktopname, lParam)
		local name = ffi.string(desktopname)
		print("Desktop: ", name)
		--table.insert(desktops, name)

		return true
	end

	print("WINSTA: ", winsta)

	local result = C.EnumDesktopsA(winsta, enumdesktop, 0)
print("Result: ", result)
	--while C.EnumDesktopsA(winsta, enumdesktop, 0) ~= 0 do  end

	return desktops
end

function GetWindowStations()
	local stations = {}

	--jit.off(enumdesktop)
	function enumstation(stationname, lParam)
		local name = ffi.string(stationname)
		print("Station: ", name)
		table.insert(stations, name)

		return 0
	end


	while C.EnumWindowStationsA(enumstation, 0) > 0 do end

	return stations
end


function test_GetDesktops()
	local winsta = C.GetProcessWindowStation()
	local desktops = GetDesktops(winsta)
end

test_GetDesktops()

--C.LockWorkStation()

--GetWindowStations()
