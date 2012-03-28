local ffi = require "ffi"

-- {8c3cebfa-a35d-497e-bc9a-e9752a8155e0}
IID_INuiAudioBeam = DEFINE_UUID("IID_INuiAudioBeam", 0x8c3cebfa, 0xa35d, 0x497e, 0xbc, 0x9a, 0xe9, 0x75, 0x2a, 0x81, 0x55, 0xe0);

ffi.cdef[[
	typedef struct INuiAudioBeam INuiAudioBeam;

    typedef struct INuiAudioBeamVtbl
    {
        HRESULT (  *QueryInterface )(
            INuiAudioBeam * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */
            void **ppvObject);

        ULONG (  *AddRef )(INuiAudioBeam * This);
        ULONG (  *Release )(INuiAudioBeam * This);


        HRESULT (  *GetBeam )(INuiAudioBeam * This,
            /* [retval][out] */ double *angle);

        HRESULT (  *SetBeam )(
            INuiAudioBeam * This,
            /* [in] */ double angle);

        HRESULT (  *GetPosition )(
            INuiAudioBeam * This,
            /* [out] */ double *angle,
            /* [out] */ double *confidence);

    } INuiAudioBeamVtbl;

    typedef struct INuiAudioBeam
    {
        INuiAudioBeamVtbl *lpVtbl;
    }INuiAudioBeam;
]]

