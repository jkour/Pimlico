unit nePimlico.mService.Base;

interface

uses
  nePimlico.Base.Types, nePimlico.mService.Types;

type
  TmServiceBase = class(TBaseInterfacedObject, ImService)
  private
    fID: string;
    fType: TServiceType;
{$REGION 'Interface'}
    function getStatus: TStatus;
    function getID: string;
    function getType: TServiceType;
    procedure setType(const Value: TServiceType);
{$ENDREGION}
  protected
    fStatus: TStatus;
    fDescription: string;
    fVersion: string;
    fEnabled: Boolean;
{$REGION 'Interface'}
    procedure invoke(const aParameters: string); virtual;
    procedure start; virtual;
    procedure stop; virtual;
    procedure setup; virtual;
    procedure cleanup; virtual;

    function getDescription: string; virtual;
    function getVersion: string; virtual;
    function getEnabled: boolean;
    procedure setEnabled(const Value: boolean);
{$ENDREGION}
    function continueInvoke (const aParameters: string): boolean;
  public
    constructor Create;

    property Description: string read getDescription;
    property Enabled: boolean read getEnabled write setEnabled;
    property ID: string read getID;
    property Status: TStatus read getStatus;
    property Version: string read getVersion;
  end;

implementation

uses
  System.SysUtils;

procedure TmServiceBase.cleanup;
begin
  // DO NOT DELETE
end;

function TmServiceBase.continueInvoke(const aParameters: string): boolean;
var
  param: string;
begin
  Result:=fEnabled;
  if not fEnabled then
    Exit;
  param:=aParameters.ToUpper;
  if param.Equals(ACTION_START.ToUpper) then
  begin
    self.start;
    Result:=False;
    Exit;
  end;

  if param.Equals(ACTION_STOP.ToUpper) then
  begin
    self.stop;
    Result:=False;
    Exit;
  end;
end;

constructor TmServiceBase.Create;
var
  guid: TGUID;
begin
  inherited;
  FillChar(fStatus, Sizeof(fStatus), 0);
  fStatus.Status:=ssIdle;
  CreateGUID(guid);
  fID:=GUIDToString(guid).Replace('-','').Replace('{','').Replace('}','')
                         .ToLower.Trim;
  fDescription:='Base Service';
  fVersion:='0.0.0';
  fEnabled:=True;
  fType:=stLocal;
end;

function TmServiceBase.getDescription: string;
begin
  Result:=fDescription;
end;

function TmServiceBase.getEnabled: boolean;
begin
  Result:=fEnabled;
end;

function TmServiceBase.getID: string;
begin
  Result:=fID;
end;

function TmServiceBase.getStatus: TStatus;
begin
  Result:=fStatus;
end;

function TmServiceBase.getType: TServiceType;
begin
  Result:=fType;
end;

function TmServiceBase.getVersion: string;
begin
  Result:=fVersion;
end;

procedure TmServiceBase.invoke(const aParameters: string);
begin
  fStatus.Status:=ssRunning;
end;

procedure TmServiceBase.setEnabled(const Value: boolean);
begin
  fEnabled:=Value;
end;

procedure TmServiceBase.setType(const Value: TServiceType);
begin
  fType:=Value;
end;

procedure TmServiceBase.setup;
begin
  // DO NOT DELETE
end;

procedure TmServiceBase.start;
begin
  fStatus.Status:=ssStarted;
end;

procedure TmServiceBase.stop;
begin
  fStatus.Status:=ssStopped;
end;

end.
