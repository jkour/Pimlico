unit nePimlico.Brokers.Types;

interface

uses
  nePimlico.Base.Types, nePimlico.mService.Types,
  nePimlico.REST.Types;

type
  IPimlicoBroker = interface (IBaseInterface)
    ['{449DF88E-FADF-496F-8868-CCE630FF729C}']
    // Getters/Setters
    function getRESTGateway: IPimlicoRESTBase;
    procedure setRESTGateway(const Value: IPimlicoRESTBase);

    // Methods
    function request(const aService: ImService; const aParameters: string): string;

    // Properties
    property RESTGateway: IPimlicoRESTBase read getRESTGateway write setRESTGateway;
  end;

implementation

end.
