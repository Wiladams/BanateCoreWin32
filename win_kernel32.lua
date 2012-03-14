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

function GetProcAddress(library, funcname)
	ffi.load(library)
	local paddr = C.GetProcAddress(C.GetModuleHandleA(library), funcname)
	return paddr
end

--[[
print("win_kernel32.lua - TEST")

function test_PerformanceCounter()

	local freq = GetPerformanceFrequency()
	local count = GetPerformanceCounter()

	print(freq)
	print(count)

	print(count/freq)
end

function test_GetProcAddress(library, funcname)
	ffi.load(library)
	local paddr = C.GetProcAddress(C.GetModuleHandleA(library), funcname)
	print("Proc Address: ", library, funcname, paddr)
end

test_GetProcAddress("kernel32", "GetProcAddress")
test_GetProcAddress("opengl32", "wglGetProcAddress")
test_GetProcAddress("opengl32", "wglGetExtensionsStringARB")
--]]
