unit nePimlico.mService.Default;

interface

uses
  nePimlico.Base.Types, nePimlico.mService.Types;

type
  TmServiceDefault = class(TBaseInterfacedObject, ImService)
  private
    fID: string;
{$REGION 'Interface'}
    function getStatus: TStatus;
    function getID: string;
    procedure start; virtual;
    procedure stop; virtual;
{$ENDREGION}
  protected
    Status: TStatus;
{$REGION 'Interface'}
    procedure invoke(const aParameters: string); virtual;
{$ENDREGION}
    function continueInvoke (const aParameters: string): boolean;
  public
    constructor Create;

    property ID: string read getID;
  end;

implementation

uses
  System.SysUtils;

function TmServiceDefault.continueInvoke(const aParameters: string): boolean;
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

constructor TmServiceDefault.Create;
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

function TmServiceDefault.getID: string;
begin
  Result:=fID;
end;

function TmServiceDefault.getStatus: TStatus;
begin
  Result:=Status;
end;

procedure TmServiceDefault.invoke(const aParameters: string);
begin
  Status.Status:=ssRunning;
end;

procedure TmServiceDefault.start;
begin
  Status.Status:=ssStarted;
end;

procedure TmServiceDefault.stop;
begin
  Status.Status:=ssStopped;
end;

end.
