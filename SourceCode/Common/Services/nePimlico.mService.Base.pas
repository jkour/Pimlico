unit nePimlico.mService.Base;

interface

uses
  nePimlico.Base.Types, nePimlico.mService.Types,
  nePimlico.mService.Remote.Profile;

type
  TmServiceBase = class(TBaseInterfacedObject, ImService)
  private
    fID: string;
    fType: TServiceType;
    fAddress: string;
    fPort: string;
    fSSL: Boolean;
    fProfileAddress: string;
{$REGION 'Interface'}
    function getStatus: TStatus;
    function getID: string;
    function getType: TServiceType;
    procedure setType(const Value: TServiceType);

    function getAddress: string;
    procedure setAddress(const Value: string);
    function getPort: string;
    procedure setPort(const Value: string);
    function getSSL: boolean;
    procedure setSSL(const Value: boolean);
    function getProfileAddress: string;
    procedure setProfileAddress(const Value: string);

    procedure setProfile (const aProfile: TmServiceRemoteProfile);
{$ENDREGION}
    procedure retrieveProfile;
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
    property &Type: TServiceType read getType write setType;

    // Properties - Remote
    property Address: string read getAddress write setAddress;
    property Port: string read getPort write setPort;
    property ProfileAddress: string read getProfileAddress write setProfileAddress;
    property SSL: boolean read getSSL write setSSL;
  end;

implementation

uses
  System.SysUtils, nePimlico.REST.Types, nePimlico.REST.Indy, System.Threading,
  REST.JSON, System.Classes;

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
  fAddress:='http://localhost';
  fPort:='80';
  fSSL:=false;
end;

function TmServiceBase.getAddress: string;
begin
  Result:=fAddress;
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

function TmServiceBase.getPort: string;
begin
  result:=fPort;
end;

function TmServiceBase.getProfileAddress: string;
begin
  Result:=fProfileAddress;
end;

function TmServiceBase.getSSL: boolean;
begin
  result:=fSSL;
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

procedure TmServiceBase.retrieveProfile;
              var
              mockService: ImService;
              rest: IPimlicoRestBase;
              response: string;
              profile: TmServiceRemoteProfile;
begin
  if fType <> stRemote then
    Exit;
  Assert(fAddress.Trim <> '');
  Assert(fProfileAddress.Trim <> '');

//  TTask.Run(procedure

            begin
              mockService:=TmServiceBase.Create;
              mockService.Address:=fProfileAddress;
              mockService.SSL:=fSSL;

              rest:=TPimlicoRESTIndy.Create;
              response:=rest.request(mockService, '');
              if not response.Contains('ERROR') then
              begin
                try
                  profile:=TJSON.JsonToObject<TmServiceRemoteProfile>(response);
                  if Assigned(profile) then
                  begin
                    fID:=profile.ID;
                    fDescription:=profile.Description;
                    fVersion:=profile.Version;
                    profile.Free;
                  end;
                except
                  ;
                end;
              end;
            end;
end;

procedure TmServiceBase.setAddress(const Value: string);
begin
  fAddress:=Value;
end;

procedure TmServiceBase.setEnabled(const Value: boolean);
begin
  fEnabled:=Value;
end;

procedure TmServiceBase.setPort(const Value: string);
begin
  fPort:=Value;
end;

procedure TmServiceBase.setProfile(const aProfile: TmServiceRemoteProfile);
begin
  Assert(Assigned(aProfile));
  if aProfile.ID.Trim <> '' then
    fID:=aProfile.ID;
  if aProfile.Description.Trim <> '' then
    fDescription:=aProfile.Description;
  fVersion:=aProfile.Version;
end;

procedure TmServiceBase.setProfileAddress(const Value: string);
begin
  fProfileAddress:=Value;
end;

procedure TmServiceBase.setSSL(const Value: boolean);
begin
  fSSL:=Value;
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
  retrieveProfile;
end;

procedure TmServiceBase.stop;
begin
  fStatus.Status:=ssStopped;
end;

end.
