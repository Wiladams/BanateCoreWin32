-- WinBase.lua
-- From WinBase.h
local ffi = require "ffi"

require "WTypes"

INVALID_HANDLE_VALUE = ffi.cast("intptr_t", -1)
INVALID_FILE_SIZE         = (0xFFFFFFFF);
INVALID_SET_FILE_POINTER  = (-1);
INVALID_FILE_ATTRIBUTES   = (-1);

WAIT_TIMEOUT = 0X102;
WAIT_OBJECT_0 = 0;


FILE_SHARE_READ			= 0X01;
FILE_SHARE_WRITE		= 0X02;
FILE_FLAG_OVERLAPPED 	= 0X40000000;

OPEN_ALWAYS = 4;
OPEN_EXISTING = 3;

GENERIC_READ    = 0x80000000;
GENERIC_WRITE   = 0x40000000;
GENERIC_EXECUTE = 0x20000000;
GENERIC_ALL     = 0x10000000;

PURGE_TXABORT = 0x01;
PURGE_RXABORT = 0x02;
PURGE_TXCLEAR = 0x04;
PURGE_RXCLEAR = 0x08;




ERROR_IO_PENDING = 0x03E5; -- 997

INFINITE = 0xFFFFFFFF;


PROCESS_HEAP_REGION             =0x0001
PROCESS_HEAP_UNCOMMITTED_RANGE  =0x0002
PROCESS_HEAP_ENTRY_BUSY         =0x0004
PROCESS_HEAP_ENTRY_MOVEABLE     =0x0010
PROCESS_HEAP_ENTRY_DDESHARE     =0x0020

HEAP_NO_SERIALIZE				= 0x00000001
HEAP_GENERATE_EXCEPTIONS		= 0x00000004
HEAP_ZERO_MEMORY				= 0x00000008
HEAP_REALLOC_IN_PLACE_ONLY		= 0x00000010
HEAP_CREATE_ENABLE_EXECUTE		= 0x00040000


ffi.cdef[[


typedef struct _PROCESS_HEAP_ENTRY {
    PVOID lpData;
    DWORD cbData;
    BYTE cbOverhead;
    BYTE iRegionIndex;
    WORD wFlags;
    union {
        struct {
            HANDLE hMem;
            DWORD dwReserved[ 3 ];
        } Block;
        struct {
            DWORD dwCommittedSize;
            DWORD dwUnCommittedSize;
            LPVOID lpFirstBlock;
            LPVOID lpLastBlock;
        } Region;
    } DUMMYUNIONNAME;
} PROCESS_HEAP_ENTRY, *LPPROCESS_HEAP_ENTRY, *PPROCESS_HEAP_ENTRY;


HANDLE HeapCreate(DWORD flOptions,
    SIZE_T dwInitialSize,
    SIZE_T dwMaximumSize);


BOOL HeapDestroy(HANDLE hHeap);


LPVOID HeapAlloc(
    HANDLE hHeap,
    DWORD dwFlags,
    SIZE_T dwBytes);


LPVOID HeapReAlloc(HANDLE hHeap,
	DWORD dwFlags,
    LPVOID lpMem,
	SIZE_T dwBytes);

BOOL HeapFree(HANDLE hHeap, DWORD dwFlags, LPVOID lpMem);

SIZE_T HeapSize(HANDLE hHeap, DWORD dwFlags, LPCVOID lpMem);

BOOL HeapValidate(HANDLE hHeap, DWORD dwFlags, LPCVOID lpMem);

SIZE_T HeapCompact(HANDLE hHeap, DWORD dwFlags);

HANDLE GetProcessHeap( void );

DWORD GetProcessHeaps(DWORD NumberOfHeaps, PHANDLE ProcessHeaps);

BOOL HeapLock(HANDLE hHeap);

BOOL HeapUnlock(HANDLE hHeap);

BOOL HeapWalk(HANDLE hHeap, PROCESS_HEAP_ENTRY * lpEntry);

]]

--[[
BOOL HeapSetInformation (HANDLE HeapHandle,
    HEAP_INFORMATION_CLASS HeapInformationClass,
    PVOID HeapInformation,
    SIZE_T HeapInformationLength);

BOOL HeapQueryInformation (HANDLE HeapHandle,
    HEAP_INFORMATION_CLASS HeapInformationClass,
    __out_bcount_part_opt(HeapInformationLength, *ReturnLength) PVOID HeapInformation,
    SIZE_T HeapInformationLength,
    __out_opt PSIZE_T ReturnLength
    );
--]]
