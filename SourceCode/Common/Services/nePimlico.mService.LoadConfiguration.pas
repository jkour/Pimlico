unit nePimlico.mService.LoadConfiguration;

interface

uses
  nePimlico.mService.Base, ArrayHelper, nePimlico.mService.Types;

type
  TServiceLoadConfiguration = class(TmServiceBase)
  private
    procedure populateService(const serv: ImService; const conf:
        TArrayRecord<string>);
    function tryRESTHTTPGet(const aURL: string; var response: string): Boolean;
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

procedure TServiceLoadConfiguration.invoke(const aParameters: string);
var
  serv: ImService;
  lines: TStringList;
  line: string;
  conf: TArrayRecord<string>;
  fullPath: string;
begin
  inherited;
  fullPath:=extractValueFromParams(aParameters, 'Path');

  if not fullPath.ToUpper.EndsWith(PIMLICO_CONFIG_FILE.ToUpper) then
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

procedure TServiceLoadConfiguration.populateService(const serv:
    ImService; const conf: TArrayRecord<string>);
var
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
    serv.Token:='';
    if tryRESTHTTPGet(
            string.Join('', [serv.Address, PIMLICO_AUTHENTICATE_ENDPOINT]),
            response) then
      serv.Token:=response;
  end;

end;

function TServiceLoadConfiguration.tryRESTHTTPGet(const aURL: string; var
    response: string): Boolean;
begin
  Result:=true;
  response:='';
  try
    response:=RESTHTTP.Get(aURL);
  except
    Result:=False;
  end;
end;

end.
