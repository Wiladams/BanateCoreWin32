local ffi = require "ffi"
local C = ffi.C

require "WinBase"

-- File System Calls
--
ffi.cdef[[

HANDLE CreateFileA(LPCTSTR lpFileName,
	DWORD dwDesiredAccess,
	DWORD dwShareMode,
	LPSECURITY_ATTRIBUTES lpSecurityAttributes,
	DWORD dwCreationDisposition,
	DWORD dwFlagsAndAttributes,
	HANDLE hTemplateFile
);

BOOL GetFileInformationByHandle(HANDLE hFile,
    PBY_HANDLE_FILE_INFORMATION lpFileInformation);

BOOL GetFileTime(HANDLE hFile,
	LPFILETIME lpCreationTime,
	LPFILETIME lpLastAccessTime,
	LPFILETIME lpLastWriteTime);

BOOL FileTimeToSystemTime(const FILETIME* lpFileTime, LPSYSTEMTIME lpSystemTime);

	/*
HFILE WINAPI OpenFile(LPCSTR lpFileName,
	LPOFSTRUCT lpReOpenBuff,
	UINT uStyle);
*/
]]

ffi.cdef[[
typedef DWORD  (*LPTHREAD_START_ROUTINE)(LPVOID lpParameter);
]]



ffi.cdef[[
HMODULE GetModuleHandleA(LPCSTR lpModuleName);

BOOL CloseHandle(HANDLE hObject);

HANDLE CreateEventA(LPSECURITY_ATTRIBUTES lpEventAttributes,
		BOOL bManualReset, BOOL bInitialState, LPCSTR lpName);


HANDLE CreateIoCompletionPort(HANDLE FileHandle,
	HANDLE ExistingCompletionPort,
	ULONG_PTR CompletionKey,
	DWORD NumberOfConcurrentThreads);




HANDLE CreateThread(
	LPSECURITY_ATTRIBUTES lpThreadAttributes,
	size_t dwStackSize,
	LPTHREAD_START_ROUTINE lpStartAddress,
	LPVOID lpParameter,
	DWORD dwCreationFlags,
	LPDWORD lpThreadId);

DWORD ResumeThread(HANDLE hThread);
BOOL SwitchToThread(void);
DWORD SuspendThread(HANDLE hThread);


void * GetProcAddress(HMODULE hModule, LPCSTR lpProcName);

BOOL QueryPerformanceFrequency(int64_t *lpFrequency);
BOOL QueryPerformanceCounter(int64_t *lpPerformanceCount);

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
]]



