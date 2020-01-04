unit nePimlico.Brokers.Base;

interface

uses
  nePimlico.Brokers.Types, nePimlico.mService.Types, Motif, ArrayHelper,
  nePimlico.Types, nePimlico.REST.Types;

type
  TPimlicoBrokerBase = class (TInterfacedObject, IPimlicoBroker)
  private
    fRESTGateway: IPimlicoRESTBase;
{$REGION 'Interface'}
    function getRESTGateway: IPimlicoRESTBase;
    procedure setRESTGateway(const Value: IPimlicoRESTBase);
{$ENDREGION}
  protected
{$REGION 'Interface'}
    function request(const aService: ImService; const aParameters: string): string; virtual;
{$ENDREGION}
  public
    constructor Create;
    destructor Destroy; override;

    property RESTGateway: IPimlicoRESTBase read getRESTGateway write setRESTGateway;
  end;

implementation

uses
  nePimlico.REST.Indy;

constructor TPimlicoBrokerBase.Create;
begin
  inherited;
  fRESTGateway:=TPimlicoRESTIndy.Create;
end;

destructor TPimlicoBrokerBase.Destroy;
begin
  fRESTGateway:=nil;
  inherited;
end;

function TPimlicoBrokerBase.getRESTGateway: IPimlicoRESTBase;
begin
  Result:=fRESTGateway;
end;

function TPimlicoBrokerBase.request(const aService: ImService; const aParameters:  //FI:O804
    string): string;
begin
  Assert(Assigned(aService), 'Service is nil in the broker');
  Result:='';
end;

procedure TPimlicoBrokerBase.setRESTGateway(const Value: IPimlicoRESTBase);
begin
  fRESTGateway:=nil;
  if Assigned(Value) then
    fRESTGateway:=Value
  else
    fRESTGateway:=TPimlicoRESTIndy.Create;
end;

end.
