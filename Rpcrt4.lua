ffi = require "ffi"
C = ffi.C

require "guiddef"

Rpcrt4 = ffi.load("Rpcrt4")

ffi.cdef[[
LRESULT UuidCreate(UUID * Uuid);

LRESULT UuidFromStringA(const char * StringUuid, UUID * Uuid);

LRESULT UuidToStringA(UUID * Uuid , char ** StringUuid);
]]



function UUIDFromString(stringid)
	local id = ffi.new("UUID[1]")
	Rpcrt4.UuidFromStringA(stringid, id)
	id = id[0]

	return id
end

-- From ObjIdl.h

AsyncIMultiQI = UUIDFromString("000e0020-0000-0000-C000-000000000046")
IBindCtx = UUIDFromString("0000000e-0000-0000-C000-000000000046")
IEnumMoniker = UUIDFromString("00000102-0000-0000-C000-000000000046")
IEnumSTATSTG = UUIDFromString("0000000d-0000-0000-C000-000000000046")
IEnumString = UUIDFromString("00000101-0000-0000-C000-000000000046")
IEnumUnknown = UUIDFromString("00000100-0000-0000-C000-000000000046")
IExternalConnection = UUIDFromString("00000019-0000-0000-C000-000000000046")
IGlobalOptions = UUIDFromString("0000015B-0000-0000-C000-000000000046")
IInternalUnknown = UUIDFromString("00000021-0000-0000-C000-000000000046")
IMalloc = UUIDFromString("00000002-0000-0000-C000-000000000046")
IMallocSpy = UUIDFromString("0000001d-0000-0000-C000-000000000046")
IMarshal2 = UUIDFromString("000001cf-0000-0000-C000-000000000046")
IMoniker = UUIDFromString("0000000f-0000-0000-C000-000000000046")
IMultiQI = UUIDFromString("00000020-0000-0000-C000-000000000046")
IPersist = UUIDFromString("0000010c-0000-0000-C000-000000000046")
IPersistStream = UUIDFromString("00000109-0000-0000-C000-000000000046")
IROTData = UUIDFromString("f29f6bc0-5021-11ce-aa15-00006901293f")
IRunnableObject = UUIDFromString("00000126-0000-0000-C000-000000000046")
IRunningObjectTable = UUIDFromString("00000010-0000-0000-C000-000000000046")
ISequentialStream = UUIDFromString("0c733a30-2a1c-11ce-ade5-00aa0044773d")
IStdMarshalInfo = UUIDFromString("00000018-0000-0000-C000-000000000046")
IStorage = UUIDFromString("0000000b-0000-0000-C000-000000000046")
IStream = UUIDFromString("0000000c-0000-0000-C000-000000000046")

---[[
-- Stopped at IStorage
print("IGlobalOptions", IGlobalOptions)
--]]
