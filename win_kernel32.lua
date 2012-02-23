local ffi = require "ffi"
local C = ffi.C

require "Win32Types"

ffi.cdef[[
typedef struct _SECURITY_ATTRIBUTES {
	DWORD nLength;
	LPVOID lpSecurityDescriptor;
	BOOL bInheritHandle;
} SECURITY_ATTRIBUTES,  *PSECURITY_ATTRIBUTES,  *LPSECURITY_ATTRIBUTES;


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

--[[
print("win_kernel32.lua - TEST")

local freq = GetPerformanceFrequency()
local count = GetPerformanceCounter()

print(freq)
print(count)

print(count/freq)

--local paddr = C.GetProcAddress(C.GetModuleHandleA("kernel32"), "GetProcAddress")

--print("Proc Address: ", paddr)



--]]
