-- ObjBase.h
ffi = require "ffi"
require "WTypes"

require "guiddef"
require "win32_IUnknown"
require "ObjIdl"

local _gszWlmOLEUIResourceDirective = "/macres:ole2ui.rsc";

ffi.cdef[[
typedef enum tagREGCLS
{
    REGCLS_SINGLEUSE = 0,       // class object only generates one instance
    REGCLS_MULTIPLEUSE = 1,     // same class object genereates multiple inst.
                                // and local automatically goes into inproc tbl.
    REGCLS_MULTI_SEPARATE = 2,  // multiple use, but separate control over each
                                // context.
    REGCLS_SUSPENDED      = 4,  // register is as suspended, will be activated
                                // when app calls CoResumeClassObjects
    REGCLS_SURROGATE      = 8   // must be used when a surrogate process
                                // is registering a class object that will be
                                // loaded in the surrogate
} REGCLS;


typedef enum tagCOINIT
{
  COINIT_APARTMENTTHREADED  = 0x2,      // Apartment model

  // These constants are only valid on Windows NT 4.0
  COINIT_MULTITHREADED      = 0x0,      // OLE calls objects on any thread.
  COINIT_DISABLE_OLE1DDE    = 0x4,      // Don't use DDE for Ole1 support.
  COINIT_SPEED_OVER_MEMORY  = 0x8,      // Trade memory for speed.
} COINIT;

// Obsolete
//DWORD CoBuildVersion( VOID );
//WINOLEAPI  CoCreateStandardMalloc(DWORD memctx, IMalloc FAR* FAR* ppMalloc);


HRESULT  CoInitialize(LPVOID pvReserved);
void  CoUninitialize(void);
HRESULT CoInitializeEx(LPVOID pvReserved, DWORD dwCoInit);

//HRESULT  CoGetMalloc(DWORD dwMemContext, LPMALLOC * ppMalloc);
DWORD CoGetCurrentProcess(void);

//HRESULT  CoRegisterMallocSpy(LPMALLOCSPY pMallocSpy);
//HRESULT  CoRevokeMallocSpy(void);

HRESULT CoGetCallerTID(LPDWORD lpdwTID);
HRESULT CoGetCurrentLogicalThreadId(GUID *pguid);


HRESULT  CoGetContextToken(ULONG_PTR* pToken);

/*
typedef struct _SECURITY_DESCRIPTOR {
  UCHAR  Revision;
  UCHAR  Sbz1;
  SECURITY_DESCRIPTOR_CONTROL  Control;
  PSID  Owner;
  PSID  Group;
  PACL  Sacl;
  PACL  Dacl;
} SECURITY_DESCRIPTOR, *PISECURITY_DESCRIPTOR;


int  CoRegisterInitializeSpy(LPINITIALIZESPY pSpy, ULARGE_INTEGER *puliCookie);
int  CoRevokeInitializeSpy(ULARGE_INTEGER uliCookie);


// COM System Security Descriptors (used when the corresponding registry
// entries are absent)
typedef enum tagCOMSD
{
    SD_LAUNCHPERMISSIONS = 0,       // Machine wide launch permissions
    SD_ACCESSPERMISSIONS = 1,       // Machine wide acesss permissions
    SD_LAUNCHRESTRICTIONS = 2,      // Machine wide launch limits
    SD_ACCESSRESTRICTIONS = 3       // Machine wide access limits

} COMSD;

HRESULT  CoGetSystemSecurityPermissions(COMSD comSDType, PSECURITY_DESCRIPTOR *ppSD);
*/


// definition for Win7 new APIs
//HRESULT CoGetApartmentType(APTTYPE * pAptType, APTTYPEQUALIFIER * pAptQualifier);


typedef struct tagSOleTlsDataPublic
{
    void *pvReserved0[2];
    DWORD dwReserved0[3];
    void *pvReserved1[1];
    DWORD dwReserved1[3];
    void *pvReserved2[4];
    DWORD dwReserved2[1];
    void *pCurrentCtx;
} SOleTlsDataPublic;


/* COM+ APIs */

HRESULT CoGetObjectContext(REFIID riid,  LPVOID * ppv);

/* register/revoke/get class objects */

HRESULT  CoGetClassObject( REFCLSID rclsid,  DWORD dwClsContext,  LPVOID pvReserved,
                     REFIID riid,  LPVOID * ppv);
HRESULT  CoRegisterClassObject( REFCLSID rclsid,  LPUNKNOWN pUnk,
                     DWORD dwClsContext,  DWORD flags,  LPDWORD lpdwRegister);
HRESULT  CoRevokeClassObject( DWORD dwRegister);
HRESULT  CoResumeClassObjects(void);
HRESULT  CoSuspendClassObjects(void);
ULONG CoAddRefServerProcess(void);
ULONG CoReleaseServerProcess(void);
HRESULT  CoGetPSClsid( REFIID riid,  CLSID *pClsid);
HRESULT  CoRegisterPSClsid( REFIID riid,  REFCLSID rclsid);

// Registering surrogate processes
HRESULT  CoRegisterSurrogate(LPSURROGATE pSurrogate);

/* marshaling interface pointers */

HRESULT CoGetMarshalSizeMax( ULONG *pulSize,  REFIID riid,  LPUNKNOWN pUnk,
                     DWORD dwDestContext,  LPVOID pvDestContext,  DWORD mshlflags);
HRESULT CoMarshalInterface( LPSTREAM pStm,  REFIID riid,  LPUNKNOWN pUnk,
                     DWORD dwDestContext,  LPVOID pvDestContext,  DWORD mshlflags);
HRESULT CoUnmarshalInterface( LPSTREAM pStm,  REFIID riid,  LPVOID * ppv);
HRESULT CoMarshalHresult( LPSTREAM pstm,  HRESULT hresult);
HRESULT CoUnmarshalHresult( LPSTREAM pstm,  HRESULT  * phresult);
HRESULT CoReleaseMarshalData( LPSTREAM pStm);
HRESULT CoDisconnectObject( LPUNKNOWN pUnk,  DWORD dwReserved);
HRESULT CoLockObjectExternal( LPUNKNOWN pUnk,  BOOL fLock,  BOOL fLastUnlockReleases);
HRESULT CoGetStandardMarshal( REFIID riid,  LPUNKNOWN pUnk,
                     DWORD dwDestContext,  LPVOID pvDestContext,  DWORD mshlflags,
                     LPMARSHAL * ppMarshal);


HRESULT CoGetStdMarshalEx( LPUNKNOWN pUnkOuter,  DWORD smexflags,
                             LPUNKNOWN * ppUnkInner);
]]

-- interface marshaling definitions

-- minimum number of bytes for interface marshl
MARSHALINTERFACE_MIN = 500
CWCSTORAGENAME = 32

-- Storage instantiation modes
STGM_DIRECT             = 0x00000000
STGM_TRANSACTED         = 0x00010000
STGM_SIMPLE             = 0x08000000

STGM_READ               = 0x00000000
STGM_WRITE              = 0x00000001
STGM_READWRITE          = 0x00000002

STGM_SHARE_DENY_NONE    = 0x00000040
STGM_SHARE_DENY_READ    = 0x00000030
STGM_SHARE_DENY_WRITE   = 0x00000020
STGM_SHARE_EXCLUSIVE    = 0x00000010

STGM_PRIORITY           = 0x00040000
STGM_DELETEONRELEASE    = 0x04000000
STGM_NOSCRATCH          = 0x00100000

STGM_CREATE             = 0x00001000
STGM_CONVERT            = 0x00020000
STGM_FAILIFTHERE        = 0x00000000

STGM_NOSNAPSHOT         = 0x00200000
STGM_DIRECT_SWMR        = 0x00400000

--  flags for internet asyncronous and layout docfile
ASYNC_MODE_COMPATIBILITY    = 0x00000001
ASYNC_MODE_DEFAULT          = 0x00000000

STGTY_REPEAT                = 0x00000100
STG_TOEND                   = 0xFFFFFFFF

STG_LAYOUT_SEQUENTIAL       = 0x00000000
STG_LAYOUT_INTERLEAVED      = 0x00000001


STGFMT_STORAGE          = 0
STGFMT_NATIVE           = 1
STGFMT_FILE             = 3
STGFMT_ANY              = 4
STGFMT_DOCFILE          = 5

-- This is a legacy define to allow old component to builds
STGFMT_DOCUMENT         = 0

S_OK			= (0)
S_FALSE			= (1)
