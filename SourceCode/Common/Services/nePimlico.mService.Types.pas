unit nePimlico.mService.Types;

interface

uses
  nePimlico.Base.Types;

type
  TServiceType = (stLocal, stHTTP);

  ImService = interface (IBaseInterface)
    ['{1BCECA56-A4AD-476D-AFF3-5A0F70C7723A}']
    function getServiceType: TServiceType;
    function getStatus: TStatus;

    procedure invoke(const aParameters: string);

    property ServiceType: TServiceType read getServiceType;
    property Status: TStatus read getStatus;
  end;

implementation

end.
