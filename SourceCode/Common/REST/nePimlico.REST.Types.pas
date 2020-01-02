unit nePimlico.REST.Types;

interface

uses
  nePimlico.Base.Types, nePimlico.mService.Types;

type
  IPimlicoRESTBase = interface (IBaseInterface)
    ['{476F4735-2A95-4FDE-8678-A63850133059}']
    function request(const aService: ImService; const aParameters: string): string;
  end;

implementation

end.
