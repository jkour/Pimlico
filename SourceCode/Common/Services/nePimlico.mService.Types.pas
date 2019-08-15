unit nePimlico.mService.Types;

interface

uses
  nePimlico.Base.Types;

type
  ImService = interface (IBaseInterface)
    ['{1BCECA56-A4AD-476D-AFF3-5A0F70C7723A}']
    function getID: string;
    function getStatus: TStatus;

    procedure invoke(const aParameters: string);

    property ID: string read getID;
    property Status: TStatus read getStatus;
  end;

implementation

end.
