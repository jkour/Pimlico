unit nePimlico.Brokers.Types;

interface

uses
  nePimlico.Base.Types, nePimlico.mService.Types;

type
  IPimlicoBroker = interface (IBaseInterface)
    ['{449DF88E-FADF-496F-8868-CCE630FF729C}']
    procedure request(const aService: ImService; const aParameters: string);
  end;

implementation

end.
