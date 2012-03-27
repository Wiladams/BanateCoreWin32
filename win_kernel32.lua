local ffi = require "ffi"
local C = ffi.C

require "Win32Types"

ffi.cdef[[


	HMODULE GetModuleHandleA(LPCSTR lpModuleName);

	BOOL CloseHandle(HANDLE hObject);

	HANDLE CreateEventA(LPSECURITY_ATTRIBUTES lpEventAttributes,
		BOOL bManualReset, BOOL bInitialState, LPCSTR lpName);

	void * GetProcAddress(HMODULE hModule, LPCSTR lpProcName);

	BOOL QueryPerformanceFrequency(__int64 *lpFrequency);
	BOOL QueryPerformanceCounter(__int64 *lpPerformanceCount);

//	DWORD QueueUserAPC(PAPCFUNC pfnAPC, HANDLE hThread, ULONG_PTR dwData);

	void Sleep(DWORD dwMilliseconds);

	DWORD SleepEx(DWORD dwMilliseconds, BOOL bAlertable);

]]

function GetPerformanceFrequency()
	local anum = ffi.new("__int64[1]")
	local success = C.QueryPerformanceFrequency(anum)
	if success == 0 then return nil end

	return tonumber(anum[0])
end

function GetPerformanceCounter()
	local anum = ffi.new("__int64[1]")
	local success = C.QueryPerformanceCounter(anum)
	if success == 0 then return nil end

	return tonumber(anum[0])
end

function GetProcAddress(library, funcname)
	ffi.load(library)
	local paddr = C.GetProcAddress(C.GetModuleHandleA(library), funcname)
	return paddr
end



--[[
	WinNls.h

	Defined in Kernel32
--]]

ffi.cdef[[

int MultiByteToWideChar(UINT CodePage,
    DWORD    dwFlags,
    LPCSTR   lpMultiByteStr, int cbMultiByte,
    LPWSTR  lpWideCharStr, int cchWideChar);


int WideCharToMultiByte(UINT CodePage,
    DWORD    dwFlags,
    LPCWSTR  lpWideCharStr, int cchWideChar,
    LPSTR   lpMultiByteStr, int cbMultiByte,
    LPCSTR   lpDefaultChar,
    LPBOOL  lpUsedDefaultChar);
--]]



