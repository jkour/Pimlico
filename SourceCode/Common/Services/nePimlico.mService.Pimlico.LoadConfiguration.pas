unit nePimlico.mService.Pimlico.LoadConfiguration;

interface

uses
  nePimlico.mService.Base, FMX.Types, ArrayHelper, nePimlico.mService.Types,
  IdHTTP;

type
  TServicePimlicoLoadConfiguration = class (TmServiceBase)
  private
    procedure populateService(const serv: ImService; const conf:
        TArrayRecord<string>);
    function tryIndyGet (const aIndy: TidHTTP; const aURL: string; var response: string): Boolean;
  protected
    procedure invoke(const aParameters: string); override;
  public
  end;

implementation

uses
  nePimlico.Utils, System.SysUtils, System.Classes,
  System.IOUtils, System.StrUtils, nePimlico.mService.Remote,
  nePimlico.Types, nePimlico.Factory;

{ TServiceSystemLoadConfiguration }

procedure TServicePimlicoLoadConfiguration.invoke(const aParameters: string);
var
  serv: ImService;
  lines: TStringList;
  line: string;
  conf: TArrayRecord<string>;
  fullPath: string;
begin
  inherited;
  fullPath:=extractValueFromParams(aParameters, 'Path');

  fullPath:=TPath.Combine(fullPath, PIMLICO_CONFIG_FILE);
  if not FileExists(fullPath) then
    raise Exception.Create('Configuration File Not Found at '+fullPath);
  lines:=TStringList.Create;
  try
    lines.StrictDelimiter:=true;
    lines.LoadFromFile(fullPath);
    for line in lines do
    begin
      if not line.StartsWith('//') then
      begin
        conf:=TArrayRecord<string>.Create(line.Split([#9]));
        if (conf.Count > 0) and (conf.Count >=5) then
        begin
          serv:=pimlico.unique(conf[1]);
          if not Assigned(serv) then
          begin
            case IndexStr(conf[0].Trim.ToUpper, [SCOPE_LOCAL.ToUpper, SCOPE_REMOTE.ToUpper]) of
              0: ;
              1: begin
                   serv:=TmServiceRemote.Create;
                   Pimlico.add(conf[1], serv);
                   populateService(serv, conf);
                 end;
            end;
          end
          else
          begin
            populateService(serv, conf);
          end;
        end;
      end;
    end;
  finally
    lines.Free;
  end;
end;

procedure TServicePimlicoLoadConfiguration.populateService(const serv:
    ImService; const conf: TArrayRecord<string>);
var
  indy: TidHTTP;
  response: string;
begin
  serv.Address:=conf[2].Trim;
  if serv.Address.EndsWith('/') then
   serv.Address:=serv.Address.Substring(0, serv.Address.Length - 1);
  serv.ProfileAddress:=string.Join('', [serv.Address, PIMLICO_PROFILE_ENDPOINT]);
  if conf[3].Trim = '' then
    serv.Port:='80'
  else
    serv.Port:=conf[3];
  serv.Enabled:=conf[4].Trim.ToUpper = SERVICE_ENABLED.ToUpper;

  if conf.Count >=6 then
   serv.Authenticate := conf[5].Trim.ToUpper = 'YES';

  if serv.Authenticate then
  begin
    indy:=TIdHTTP.Create(nil);
    try
      serv.Token:='';
      if tryIndyGet(indy,
            string.Join('', [serv.Address, PIMLICO_AUTHENTICATE_ENDPOINT]),
              response) then
        serv.Token:=response;
    finally
      indy.Free;
    end;
  end;

end;

function TServicePimlicoLoadConfiguration.tryIndyGet(const aIndy: TidHTTP;
    const aURL: string; var response: string): Boolean;
begin
  Assert(Assigned(aIndy));
  Result:=true;
  response:='';
  try
    response:=aIndy.Get(aURL);
  except
    Result:=False;
  end;
end;

end.
