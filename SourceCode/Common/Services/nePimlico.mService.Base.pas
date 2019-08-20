unit nePimlico.mService.Base;

interface

uses
  nePimlico.Base.Types, nePimlico.mService.Types;

type
  TmServiceBase = class(TBaseInterfacedObject, ImService)
  private
    fID: string;
{$REGION 'Interface'}
    function getStatus: TStatus;
    function getID: string;
{$ENDREGION}
  protected
    Status: TStatus;
{$REGION 'Interface'}
    procedure invoke(const aParameters: string); virtual;
    procedure start; virtual;
    procedure stop; virtual;
{$ENDREGION}
    function continueInvoke (const aParameters: string): boolean;
  public
    constructor Create;

    property ID: string read getID;
  end;

implementation

uses
  System.SysUtils;

function TmServiceBase.continueInvoke(const aParameters: string): boolean;
begin
  Result:=True;
  if aParameters.ToUpper.Equals(ACTION_START.ToUpper) then
  begin
    self.start;
    Result:=False;
  end;

  if aParameters.ToUpper = ACTION_STOP.ToUpper then
  begin
    self.stop;
    Result:=False;
  end;
end;

constructor TmServiceBase.Create;
var
  guid: TGUID;
begin
  inherited;
  FillChar(Status, Sizeof(Status), 0);
  Status.Status:=ssIdle;
  CreateGUID(guid);
  fID:=GUIDToString(guid).Replace('-','').Replace('{','').Replace('}','')
                         .ToLower.Trim;
end;

function TmServiceBase.getID: string;
begin
  Result:=fID;
end;

function TmServiceBase.getStatus: TStatus;
begin
  Result:=Status;
end;

procedure TmServiceBase.invoke(const aParameters: string);
begin
  Status.Status:=ssRunning;
end;

procedure TmServiceBase.start;
begin
  Status.Status:=ssStarted;
end;

procedure TmServiceBase.stop;
begin
  Status.Status:=ssStopped;
end;

end.
