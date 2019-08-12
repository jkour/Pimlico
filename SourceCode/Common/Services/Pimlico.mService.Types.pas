unit Pimlico.mService.Types;

interface

uses
  Pimlico.Base.Types;

type
  TServiceErrorCode = (secOK, secError);

  TServiceType = (stLocal, stHTTP);

  ImService = interface (IBaseInterface)
    ['{1BCECA56-A4AD-476D-AFF3-5A0F70C7723A}']
    function getErrorCode: TServiceErrorCode;
    function getErrorMsg: string;
    function getResponse: string;
    function getServiceType: TServiceType;

    procedure invoke(const aParameters: string);

    property ErrorCode: TServiceErrorCode read getErrorCode;
    property ErrorMsg: string read getErrorMsg;
    property Response: string read getResponse;
    property ServiceType: TServiceType read getServiceType;
  end;

implementation

end.
