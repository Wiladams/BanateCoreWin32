local ffi = require "ffi"

require "Win32Types"

ffi.cdef[[
typedef void *	HID_HANDLE;

typedef DWORD (*LPGET_REPORT) (
  HID_HANDLE hDevice,
  HIDP_REPORT_TYPE type,
  PCHAR pbBuffer,
  DWORD cbBuffer,
  PDWORD pcbTransferred,
  DWORD dwTimeout
);

typedef DWORD (*LPSET_REPORT) (
  HID_HANDLE hDevice,
  HIDP_REPORT_TYPE type,
  PCHAR pbBuffer,
  DWORD cbBuffer,
  DWORD dwTimeout
);

typedef DWORD (*LPGET_INTERRUPT_REPORT) (
  HID_HANDLE hDevice,
  PCHAR pbBuffer,
  DWORD cbBuffer,
  PDWORD pcbTransferred,
  HANDLE hCancel,
  DWORD dwTimeout
);

typedef DWORD (*LPGET_STRING) (
  HID_HANDLE hDevice,
  HID_STRING_TYPE stringType,
  DWORD dwIdx,
  LPWSTR pszBuffer,
  DWORD cchBuffer,
  PDWORD pcchActual
);

typedef DWORD (*LPGET_QUEUE_SIZE) (
  HID_HANDLE hDevice,
  PDWORD pdwSize
);

typedef DWORD (*LPSET_QUEUE_SIZE) (
  HID_HANDLE hDevice,
  DWORD dwSize
);


struct _HID_FUNCS {
  DWORD dwCount;
  LPGET_REPORT lpGetReport;
  LPSET_REPORT lpSetReport;
  LPGET_INTERRUPT_REPORT lpGetInterruptReport;
  LPGET_STRING lpGetString;
  LPGET_QUEUE_SIZE lpGetQueueSize;
  LPSET_QUEUE_SIZE lpSetQueueSize;
};

typedef struct _HID_FUNCS HID_FUNCS, * PHID_FUNCS, * LPHID_FUNCS;
typedef struct _HID_FUNCS const * PCHID_FUNCS;
typedef struct _HID_FUNCS const * LPCHID_FUNCS;


typedef struct _HID_DRIVER_SETTINGS {
  DWORD dwVendorId;
  DWORD dwProductId;
  DWORD dwReleaseNumber;
  DWORD dwInterfaceNumber;
  DWORD dwCollection;
  DWORD dwUsagePage;
  DWORD dwUsage;
} HID_DRIVER_SETTINGS, *PHID_DRIVER_SETTINGS;


typedef struct _HID_COLLECTION_INFORMATION {
  ULONG   DescriptorSize;
  BOOLEAN Polled;
  UCHAR   Reserved1[1];
  USHORT  VendorID;
  USHORT  ProductID;
  USHORT  VersionNumber;
} HID_COLLECTION_INFORMATION, *PHID_COLLECTION_INFORMATION;

typedef struct _HIDD_ATTRIBUTES {
  ULONG  Size;
  USHORT VendorID;
  USHORT ProductID;
  USHORT VersionNumber;
} HIDD_ATTRIBUTES, *PHIDD_ATTRIBUTES;

typedef struct _HIDP_BUTTON_CAPS {
  USAGE   UsagePage;
  UCHAR   ReportID;
  BOOLEAN IsAlias;
  USHORT  BitField;
  USHORT  LinkCollection;
  USAGE   LinkUsage;
  USAGE   LinkUsagePage;
  BOOLEAN IsRange;
  BOOLEAN IsStringRange;
  BOOLEAN IsDesignatorRange;
  BOOLEAN IsAbsolute;
  ULONG   Reserved[10];
  union {
    struct {
      USAGE  UsageMin;
      USAGE  UsageMax;
      USHORT StringMin;
      USHORT StringMax;
      USHORT DesignatorMin;
      USHORT DesignatorMax;
      USHORT DataIndexMin;
      USHORT DataIndexMax;
    } Range;
    struct {
      USAGE  Usage;
      USAGE  Reserved1;
      USHORT StringIndex;
      USHORT Reserved2;
      USHORT DesignatorIndex;
      USHORT Reserved3;
      USHORT DataIndex;
      USHORT Reserved4;
    } NotRange;
  };
} HIDP_BUTTON_CAPS, *PHIDP_BUTTON_CAPS;


typedef struct _HIDP_CAPS {
  USAGE  Usage;
  USAGE  UsagePage;
  USHORT InputReportByteLength;
  USHORT OutputReportByteLength;
  USHORT FeatureReportByteLength;
  USHORT Reserved[17];
  USHORT NumberLinkCollectionNodes;
  USHORT NumberInputButtonCaps;
  USHORT NumberInputValueCaps;
  USHORT NumberInputDataIndices;
  USHORT NumberOutputButtonCaps;
  USHORT NumberOutputValueCaps;
  USHORT NumberOutputDataIndices;
  USHORT NumberFeatureButtonCaps;
  USHORT NumberFeatureValueCaps;
  USHORT NumberFeatureDataIndices;
} HIDP_CAPS, *PHIDP_CAPS;


typedef struct _HIDP_DATA {
  USHORT DataIndex;
  USHORT Reserved;
  union {
    ULONG   RawValue;
    BOOLEAN On;
  };
} HIDP_DATA, *PHIDP_DATA;


typedef struct _HIDP_EXTENDED_ATTRIBUTES {
  UCHAR               NumGlobalUnknowns;
  UCHAR               Reserved[3];
  PHIDP_UNKNOWN_TOKEN GlobalUnknowns;
  ULONG               Data[1];
} HIDP_EXTENDED_ATTRIBUTES, *PHIDP_EXTENDED_ATTRIBUTES;


typedef struct _HIDP_LINK_COLLECTION_NODE {
  USAGE  LinkUsage;
  USAGE  LinkUsagePage;
  USHORT Parent;
  USHORT NumberOfChildren;
  USHORT NextSibling;
  USHORT FirstChild;
  ULONG  CollectionType  :8;
  ULONG  IsAlias  :1;
  ULONG  Reserved  :23;
  PVOID  UserContext;
} HIDP_LINK_COLLECTION_NODE, *PHIDP_LINK_COLLECTION_NODE;


typedef struct _HIDP_VALUE_CAPS {
  USAGE   UsagePage;
  UCHAR   ReportID;
  BOOLEAN IsAlias;
  USHORT  BitField;
  USHORT  LinkCollection;
  USAGE   LinkUsage;
  USAGE   LinkUsagePage;
  BOOLEAN IsRange;
  BOOLEAN IsStringRange;
  BOOLEAN IsDesignatorRange;
  BOOLEAN IsAbsolute;
  BOOLEAN HasNull;
  UCHAR   Reserved;
  USHORT  BitSize;
  USHORT  ReportCount;
  USHORT  Reserved2[5];
  ULONG   UnitsExp;
  ULONG   Units;
  LONG    LogicalMin;
  LONG    LogicalMax;
  LONG    PhysicalMin;
  LONG    PhysicalMax;
  union {
    struct {
      USAGE  UsageMin;
      USAGE  UsageMax;
      USHORT StringMin;
      USHORT StringMax;
      USHORT DesignatorMin;
      USHORT DesignatorMax;
      USHORT DataIndexMin;
      USHORT DataIndexMax;
    } Range;
    struct {
      USAGE  Usage;
      USAGE  Reserved1;
      USHORT StringIndex;
      USHORT Reserved2;
      USHORT DesignatorIndex;
      USHORT Reserved3;
      USHORT DataIndex;
      USHORT Reserved4;
    } NotRange;
  };
} HIDP_VALUE_CAPS, *PHIDP_VALUE_CAPS;


typedef enum _HIDP_REPORT_TYPE {
  HidP_Input,
  HidP_Output,
  HidP_Feature
} HIDP_REPORT_TYPE;


typedef struct _HIDP_UNKNOWN_TOKEN {
  UCHAR Token;
  UCHAR Reserved[3];
  ULONG BitField;
} HIDP_UNKNOWN_TOKEN, *PHIDP_UNKNOWN_TOKEN;


typedef struct _HIDP_PREPARSED_DATA * PHIDP_PREPARSED_DATA;


typedef struct _USAGE_AND_PAGE {
  USAGE Usage;
  USAGE UsagePage;
} USAGE_AND_PAGE, *PUSAGE_AND_PAGE;







BOOLEAN  HidD_FlushQueue(HANDLE HidDeviceObject);

BOOLEAN  HidD_FreePreparsedData(PHIDP_PREPARSED_DATA PreparsedData);

BOOLEAN  HidD_GetAttributes(
	HANDLE HidDeviceObject,
    PHIDD_ATTRIBUTES Attributes
);

BOOLEAN  HidD_GetFeature(
	HANDLE HidDeviceObject,
    PVOID ReportBuffer,
	ULONG ReportBufferLength
);

void  HidD_GetHidGuid(
    LPGUID HidGuid
);

BOOLEAN  HidD_GetIndexedString(
	HANDLE HidDeviceObject,
	ULONG StringIndex,
    PVOID Buffer,
	ULONG BufferLength
);

BOOLEAN  HidD_GetInputReport(
	HANDLE HidDeviceObject,
    PVOID ReportBuffer,
	ULONG ReportBufferLength
);

BOOLEAN  HidD_GetManufacturerString(
	HANDLE HidDeviceObject,
    PVOID Buffer,
     ULONG BufferLength
);

BOOLEAN  HidD_GetNumInputBuffers(
     HANDLE HidDeviceObject,
    PULONG NumberBuffers
);

BOOLEAN  HidD_GetPhysicalDescriptor(
     HANDLE HidDeviceObject,
    PVOID Buffer,
     ULONG BufferLength
);

BOOLEAN  HidD_GetPreparsedData(
     HANDLE HidDeviceObject,
    PHIDP_PREPARSED_DATA *PreparsedData
);

BOOLEAN  HidD_GetProductString(
     HANDLE HidDeviceObject,
    PVOID Buffer,
     ULONG BufferLength
);

BOOLEAN  HidD_GetSerialNumberString(
     HANDLE HidDeviceObject,
    PVOID Buffer,
     ULONG BufferLength
);

BOOLEAN  HidD_SetFeature(
    HANDLE HidDeviceObject,
    PVOID ReportBuffer,
    ULONG ReportBufferLength
);

BOOLEAN  HidD_SetNumInputBuffers(
    HANDLE HidDeviceObject,
    ULONG NumberBuffers
);

BOOLEAN  HidD_SetOutputReport(
    HANDLE HidDeviceObject,
    void * ReportBuffer,
    ULONG ReportBufferLength
);

int  HidP_GetCaps(
	PHIDP_PREPARSED_DATA PreparsedData,
    PHIDP_CAPS Capabilities
);

int  HidP_GetData(
	HIDP_REPORT_TYPE ReportType,
	PHIDP_DATA DataList,
	PULONG DataLength,
	PHIDP_PREPARSED_DATA PreparsedData,
	PCHAR Report,
	ULONG ReportLength
);

int  HidP_GetExtendedAttributes(
	HIDP_REPORT_TYPE ReportType,
	USHORT DataIndex,
	PHIDP_PREPARSED_DATA PreparsedData,
	PHIDP_EXTENDED_ATTRIBUTES Attributes,
	PULONG LengthAttributes
);

int  HidP_GetLinkCollectionNodes(
	PHIDP_LINK_COLLECTION_NODE LinkCollectionNodes,
    PULONG LinkCollectionNodesLength,
	PHIDP_PREPARSED_DATA PreparsedData
);

int  HidP_GetUsages(
	HIDP_REPORT_TYPE ReportType,
	USAGE UsagePage,
	USHORT LinkCollection,
	PUSAGE UsageList,
	PULONG UsageLength,
	PHIDP_PREPARSED_DATA PreparsedData,
	PCHAR Report,
	ULONG ReportLength
);

int  HidP_GetUsagesEx(
	HIDP_REPORT_TYPE ReportType,
	USHORT LinkCollection,
	PUSAGE_AND_PAGE ButtonList,
	ULONG *UsageLength,
	PHIDP_PREPARSED_DATA PreparsedData,
	PCHAR Report,
	ULONG ReportLength
);

int  HidP_GetValueCaps(
	HIDP_REPORT_TYPE ReportType,
	PHIDP_VALUE_CAPS ValueCaps,
	PUSHORT ValueCapsLength,
	PHIDP_PREPARSED_DATA PreparsedData
);

int  HidP_InitializeReportForID(
	HIDP_REPORT_TYPE ReportType,
	UCHAR ReportID,
	PHIDP_PREPARSED_DATA PreparsedData,
    PCHAR Report,
	ULONG ReportLength
);

]]
