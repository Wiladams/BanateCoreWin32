local ffi = require "ffi"
require "WTypes"
require "Rpcrt4"


--[[
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
--]]
--[[
-- Stopped at IStorage
print("IGlobalOptions", IGlobalOptions)
--]]


ffi.cdef[[
typedef struct IMarshal IMarshal;
typedef struct IMarshal2 IMarshal2;
typedef struct IMalloc IMalloc;
typedef struct IMallocSpy IMallocSpy;
typedef struct IStdMarshalInfo IStdMarshalInfo;
typedef struct IExternalConnection IExternalConnection;
typedef struct IMultiQI IMultiQI;
typedef struct AsyncIMultiQI AsyncIMultiQI;
typedef struct IInternalUnknown IInternalUnknown;
typedef struct IEnumUnknown IEnumUnknown;
typedef struct IBindCtx IBindCtx;
typedef struct IEnumMoniker IEnumMoniker;
typedef struct IRunnableObject IRunnableObject;
typedef struct IRunningObjectTable IRunningObjectTable;
typedef struct IPersist IPersist;
typedef struct IPersistStream IPersistStream;
typedef struct IMoniker IMoniker;
typedef struct IROTData IROTData;
typedef struct IEnumString IEnumString;
typedef struct ISequentialStream ISequentialStream;
typedef struct IStream IStream;
typedef struct IEnumSTATSTG IEnumSTATSTG;
typedef struct IStorage IStorage;
typedef struct IPersistFile IPersistFile;
typedef struct IPersistStorage IPersistStorage;
typedef struct ILockBytes ILockBytes;
typedef struct IEnumFORMATETC IEnumFORMATETC;
typedef struct IEnumSTATDATA IEnumSTATDATA;
typedef struct IRootStorage IRootStorage;
typedef struct IAdviseSink IAdviseSink;
typedef struct AsyncIAdviseSink AsyncIAdviseSink;
typedef struct IAdviseSink2 IAdviseSink2;
typedef struct AsyncIAdviseSink2 AsyncIAdviseSink2;
typedef struct IDataObject IDataObject;
typedef struct IDataAdviseHolder IDataAdviseHolder;
typedef struct IMessageFilter IMessageFilter;
typedef struct IRpcChannelBuffer IRpcChannelBuffer;
typedef struct IRpcChannelBuffer2 IRpcChannelBuffer2;
typedef struct IAsyncRpcChannelBuffer IAsyncRpcChannelBuffer;
typedef struct IRpcChannelBuffer3 IRpcChannelBuffer3;
typedef struct IRpcSyntaxNegotiate IRpcSyntaxNegotiate;
typedef struct IRpcProxyBuffer IRpcProxyBuffer;
typedef struct IRpcStubBuffer IRpcStubBuffer;
typedef struct IPSFactoryBuffer IPSFactoryBuffer;
typedef struct IChannelHook IChannelHook;
typedef struct IClientSecurity IClientSecurity;
typedef struct IServerSecurity IServerSecurity;
typedef struct IClassActivator IClassActivator;
typedef struct IRpcOptions IRpcOptions;
typedef struct IGlobalOptions IGlobalOptions;
typedef struct IFillLockBytes IFillLockBytes;
typedef struct IProgressNotify IProgressNotify;
typedef struct ILayoutStorage ILayoutStorage;
typedef struct IBlockingLock IBlockingLock;
typedef struct ITimeAndNoticeControl ITimeAndNoticeControl;
typedef struct IOplockStorage IOplockStorage;
typedef struct ISurrogate ISurrogate;
typedef struct IGlobalInterfaceTable IGlobalInterfaceTable;
typedef struct IDirectWriterLock IDirectWriterLock;
typedef struct ISynchronize ISynchronize;
typedef struct ISynchronizeHandle ISynchronizeHandle;
typedef struct ISynchronizeEvent ISynchronizeEvent;
typedef struct ISynchronizeContainer ISynchronizeContainer;
typedef struct ISynchronizeMutex ISynchronizeMutex;
typedef struct ICancelMethodCalls ICancelMethodCalls;
typedef struct IAsyncManager IAsyncManager;
typedef struct ICallFactory ICallFactory;
typedef struct IRpcHelper IRpcHelper;
typedef struct IReleaseMarshalBuffers IReleaseMarshalBuffers;
typedef struct IWaitMultiple IWaitMultiple;
typedef struct IUrlMon IUrlMon;
typedef struct IForegroundTransfer IForegroundTransfer;
typedef struct IAddrTrackingControl IAddrTrackingControl;
typedef struct IAddrExclusionControl IAddrExclusionControl;
typedef struct IPipeByte IPipeByte;
typedef struct AsyncIPipeByte AsyncIPipeByte;
typedef struct IPipeLong IPipeLong;
typedef struct AsyncIPipeLong AsyncIPipeLong;
typedef struct IPipeDouble IPipeDouble;
typedef struct AsyncIPipeDouble AsyncIPipeDouble;
typedef struct IThumbnailExtractor IThumbnailExtractor;
typedef struct IDummyHICONIncluder IDummyHICONIncluder;
typedef struct IEnumContextProps IEnumContextProps;
typedef struct IContext IContext;
typedef struct IObjContext IObjContext;
typedef struct IProcessLock IProcessLock;
typedef struct ISurrogateService ISurrogateService;
typedef struct IComThreadingInfo IComThreadingInfo;
typedef struct IProcessInitControl IProcessInitControl;
typedef struct IInitializeSpy IInitializeSpy;
]]


IID_IMarshal = UUIDFromString("00000003-0000-0000-C000-000000000046")

ffi.cdef[[
typedef  IMarshal *LPMARSHAL;

typedef struct IMarshalVtbl
{

        HRESULT (  *QueryInterface )(
            IMarshal * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */
            void **ppvObject);

        ULONG (  *AddRef )(
            IMarshal * This);

        ULONG (  *Release )(
            IMarshal * This);

        HRESULT (  *GetUnmarshalClass )(
            IMarshal * This,
            /* [annotation][in] */
              REFIID riid,
            /* [annotation][unique][in] */
              void *pv,
            /* [annotation][in] */
              DWORD dwDestContext,
            /* [annotation][unique][in] */
              void *pvDestContext,
            /* [annotation][in] */
              DWORD mshlflags,
            /* [annotation][out] */
              CLSID *pCid);

        HRESULT (  *GetMarshalSizeMax )(
            IMarshal * This,
            /* [annotation][in] */
              REFIID riid,
            /* [annotation][unique][in] */
              void *pv,
            /* [annotation][in] */
              DWORD dwDestContext,
            /* [annotation][unique][in] */
              void *pvDestContext,
            /* [annotation][in] */
              DWORD mshlflags,
            /* [annotation][out] */
              DWORD *pSize);

        HRESULT (  *MarshalInterface )(
            IMarshal * This,
            /* [annotation][unique][in] */
              IStream *pStm,
            /* [annotation][in] */
              REFIID riid,
            /* [annotation][unique][in] */
              void *pv,
            /* [annotation][in] */
              DWORD dwDestContext,
            /* [annotation][unique][in] */
              void *pvDestContext,
            /* [annotation][in] */
              DWORD mshlflags);

        HRESULT (  *UnmarshalInterface )(
            IMarshal * This,
            /* [annotation][unique][in] */
              IStream *pStm,
            /* [annotation][in] */
              REFIID riid,
            /* [annotation][out] */
              void **ppv);

        HRESULT (  *ReleaseMarshalData )(
            IMarshal * This,
            /* [annotation][unique][in] */
              IStream *pStm);

        HRESULT (  *DisconnectObject )(
            IMarshal * This,
            /* [annotation][in] */
              DWORD dwReserved);

    } IMarshalVtbl;

typedef struct IMarshal
{
		struct IMarshalVtbl *lpVtbl;
} IMarshal;

typedef  IMarshal *LPMARSHAL;
]]


ffi.cdef[[
typedef struct _COSERVERINFO
{
    DWORD dwReserved1;
    LPWSTR pwszName;
    COAUTHINFO *pAuthInfo;
    DWORD dwReserved2;
} 	COSERVERINFO;
]]




IID_IStream = UUIDFromString("0000000c-0000-0000-C000-000000000046")

ffi.cdef[[



typedef struct tagSTATSTG
    {
    LPOLESTR pwcsName;
    DWORD type;
    ULARGE_INTEGER cbSize;
    FILETIME mtime;
    FILETIME ctime;
    FILETIME atime;
    DWORD grfMode;
    DWORD grfLocksSupported;
    CLSID clsid;
    DWORD grfStateBits;
    DWORD reserved;
    } 	STATSTG;


typedef
enum tagSTGTY
    {	STGTY_STORAGE	= 1,
	STGTY_STREAM	= 2,
	STGTY_LOCKBYTES	= 3,
	STGTY_PROPERTY	= 4
    } 	STGTY;

typedef
enum tagSTREAM_SEEK
    {	STREAM_SEEK_SET	= 0,
	STREAM_SEEK_CUR	= 1,
	STREAM_SEEK_END	= 2
    } 	STREAM_SEEK;

typedef
enum tagLOCKTYPE
    {	LOCK_WRITE	= 1,
	LOCK_EXCLUSIVE	= 2,
	LOCK_ONLYONCE	= 4
    } 	LOCKTYPE;

typedef struct IStreamVtbl
{
	// IUnknown
	HRESULT (*QueryInterface)(IStream * This, REFIID riid, void **ppvObject);

	ULONG (*AddRef)(IStream * This);

	ULONG (*Release)(IStream * This);



	HRESULT (*Read)(IStream * This,
            void *pv,
            ULONG cb,
            ULONG *pcbRead);

	HRESULT (*Write)(IStream * This,
            const void *pv,
            ULONG cb,
			ULONG *pcbWritten);

	HRESULT (*Seek)(IStream * This,
            LARGE_INTEGER dlibMove,
            DWORD dwOrigin,
            ULARGE_INTEGER *plibNewPosition);

	HRESULT (*SetSize)(IStream * This,
            ULARGE_INTEGER libNewSize);

	HRESULT (*CopyTo )(IStream * This,
            IStream *pstm,
            ULARGE_INTEGER cb,
			ULARGE_INTEGER *pcbRead,
            ULARGE_INTEGER *pcbWritten);

	HRESULT (*Commit )(IStream * This, DWORD grfCommitFlags);

	HRESULT (*Revert)(IStream * This);

	HRESULT (*LockRegion)(IStream * This,
        ULARGE_INTEGER libOffset,
        ULARGE_INTEGER cb,
        DWORD dwLockType);

	HRESULT (*UnlockRegion)(IStream * This,
        ULARGE_INTEGER libOffset,
        ULARGE_INTEGER cb,
        DWORD dwLockType);

	HRESULT (*Stat)(IStream * This,
		STATSTG *pstatstg,
		DWORD grfStatFlag);

	HRESULT (*Clone)(IStream * This, IStream **ppstm);

} IStreamVtbl;

typedef struct IStream
{
    struct IStreamVtbl *lpVtbl;
} IStream;

typedef IStream *LPSTREAM;

]]







IID_ISurrogate = UUIDFromString("00000022-0000-0000-C000-000000000046")

ffi.cdef[[
typedef struct ISurrogateVtbl
{
	HRESULT (*QueryInterface )( ISurrogate * This,
		REFIID riid, void **ppvObject);

	ULONG (*AddRef)(ISurrogate * This);

	ULONG (*Release)(ISurrogate * This);

	HRESULT (*LoadDllServer)(ISurrogate * This, REFCLSID Clsid);

	HRESULT (*FreeSurrogate)(ISurrogate * This);

} ISurrogateVtbl;

typedef struct ISurrogate
{
	struct ISurrogateVtbl *lpVtbl;
} ISurrogate;

typedef  ISurrogate *LPSURROGATE;

]]

