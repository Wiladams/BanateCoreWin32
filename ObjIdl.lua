local ffi = require "ffi"
require "Win32Types"
require "Rpcrt4"

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
]]


ffi.cdef[[

typedef struct _COSERVERINFO
    {
    DWORD dwReserved1;
    LPWSTR pwszName;
    COAUTHINFO *pAuthInfo;
    DWORD dwReserved2;
    } 	COSERVERINFO;

typedef  IMarshal *LPMARSHAL;

]]

IID_IMarshal = UUIDFromString("00000003-0000-0000-C000-000000000046")
