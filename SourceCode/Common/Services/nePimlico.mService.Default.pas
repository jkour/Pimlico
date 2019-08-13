unit nePimlico.mService.Default;

interface

uses
  nePimlico.Base.Types, nePimlico.mService.Types;

type
  TmServiceDefault = class(TBaseInterfacedObject, ImService)
  private
{$REGION 'Interface'}
    function getServiceType: TServiceType;
    function getStatus: TStatus;
{$ENDREGION}
  protected
    Status: TStatus;
    ServiceType: TServiceType;
{$REGION 'Interface'}
    procedure invoke(const aParameters: string); virtual;
{$ENDREGION}
  public
    constructor Create;
  end;

implementation

constructor TmServiceDefault.Create;
begin
  inherited;
  ServiceType:=stLocal;
  Status.Status:=secOK;
  FillChar(Status, Sizeof(Status), 0);
end;

function TmServiceDefault.getServiceType: TServiceType;
begin
  Result:=ServiceType;
end;

function TmServiceDefault.getStatus: TStatus;
begin
  Result:=Status;
end;

procedure TmServiceDefault.invoke(const aParameters: string);
begin
  Status.Status:=secRunning;
  Status.Response:='Parameters: '+aParameters+' "All Good!"';
end;

end.
