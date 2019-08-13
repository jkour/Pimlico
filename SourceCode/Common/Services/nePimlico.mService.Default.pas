unit nePimlico.mService.Default;

interface

uses
  nePimlico.Base.Types, nePimlico.mService.Types;

type
  TmServiceDefault = class(TBaseInterfacedObject, ImService)
  private
{$REGION 'Interface'}
    function getStatus: TStatus;
{$ENDREGION}
  protected
    Status: TStatus;
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
  FillChar(Status, Sizeof(Status), 0);
  Status.Status:=ssOK;
end;

function TmServiceDefault.getStatus: TStatus;
begin
  Result:=Status;
end;

procedure TmServiceDefault.invoke(const aParameters: string);
begin
  Status.Status:=ssRunning;
end;

end.
