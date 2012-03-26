

local ffi = require "ffi"
require "Win32Types"
require "guiddef"

ffi.cdef[[
typedef HRESULT (*QueryInterfacePROC)(void * This, REFIID riid, void **ppvObject);
typedef ULONG (*AddRefPROC )(void * This);
typedef ULONG (*ReleasePROC)(void * This);


typedef struct _IUnknownVtbl {
	QueryInterfacePROC	QueryInterface;
	AddRefPROC			AddRef;
	ReleasePROC			Release;
} IUnknownVtbl;

typedef struct _IUnknown
{
    IUnknownVtbl *lpVtbl;
} IUnknown, *LPUNKNOWN;



// For Class Factory
typedef HRESULT (*CreateInstancePROC)(void * This, void *pUnkOuter, REFIID riid, void **ppvObject);
typedef HRESULT (*LockServerPROC)(void * This, BOOL fLock);


typedef struct {
	// From IUnknown
	QueryInterfacePROC	QueryInterface;
	AddRefPROC			AddRef;
	ReleasePROC			Release;

	// New for IClassFactory
    CreateInstancePROC CreateInstance;
    LockServerPROC LockServer;
} IClassFactoryVtbl;

]]

IID_IUnknown = DEFINE_OLEGUID("IUnknown", 0, 0, 0)

IUnknown = nil
IUnknown_mt = {
	__index = {
		QueryInterface = function(self, riid)
			local ppvObject = ffi.new("void * [1]")
			self.lpVtbl.QueryInterface(self, riid, ppvObject)
			ppvObject = ppvObject[0]
			return ppvObject
		end,

		AddRef = function(self)
			self.lpVtbl.AddRef(self)
		end,

		Release = function(self)
			self.lpVtbl.Release(self)
		end,
	},
}


--MIDL_INTERFACE("00000001-0000-0000-C000-000000000046")
IID_IClassFactory = DEFINE_OLEGUID("IClassFactory", 1, 0, 0)

IClassFactory = nil
IClassFactory_mt = {
	__index = {
		QueryInterface = function(self, riid)
			local ppvObject = ffi.new("void * [1]")
			self.lpVtbl.QueryInterface(self, riid, ppvObject)
			ppvObject = ppvObject[0]
			return ppvObject
		end,

		AddRef = function(self)
			self.lpVtbl.AddRef(self)
		end,

		Release = function(self)
			self.lpVtbl.Release(self)
		end,

		CreateInstance = function(self, pUnkOuter, riid)
			local ppvObject = ffi.new("void * [1]")
			self.lpVtbl.CreateInstance(self, pUnkOuter, riid, ppvObject)
			ppvObject = ppvObject[0]

			return ppvObject
		end,

		LockServer = function(self, fLock)
			return self.lpVtbl.LockServer(self, fLock)
		end,
	},
}


print("IID_IUnknown", IID_IUnknown)
print("IID_IClassFactory", IID_IClassFactory)

--[[
//////////////////////////////////////////////////////////////////
// IID_IUnknown and all other system IIDs are provided in UUID.LIB
// Link that library in with your proxies, clients and servers
//////////////////////////////////////////////////////////////////
--]]



