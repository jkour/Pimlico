unit nePimlico.mService.Pimlico.LoadConfiguration;

interface

uses
  nePimlico.mService.Base;

type
  TServicePimlicoLoadConfiguration = class (TmServiceBase)
  private
    fFullPath: string;
    fPoll: Boolean;
    fInterval: Cardinal;
  protected
    procedure invoke(const aParameters: string); override;
  end;

implementation

uses
  nePimlico.Utils, System.SysUtils, nePimlico.mService.Types, System.Classes,
  ArrayHelper, System.IOUtils, System.StrUtils, nePimlico.mService.Remote,
  nePimlico.Types, nePimlico.Factory;

{ TServiceSystemLoadConfiguration }

procedure TServicePimlicoLoadConfiguration.invoke(const aParameters: string);
var
  serv: ImService;
  lines: TStringList;
  line: string;
  conf: TArrayRecord<string>;
begin
  inherited;
  fFullPath:=extractValueFromParams(aParameters, 'Path');
  fPoll:=extractValueFromParams(aParameters, 'Poll') = 'true';
  fInterval:=StrToUInt(extractValueFromParams(aParameters, 'Interval'));

  fFullPath:=TPath.Combine(fFullPath, PIMLICO_CONFIG_FILE);
  if not FileExists(fFullPath) then
    raise Exception.Create('Configuration File Not Found at '+fFullPath);
  lines:=TStringList.Create;
  try
    lines.StrictDelimiter:=true;
    lines.LoadFromFile(fFullPath);
    for line in lines do
    begin
      if not line.StartsWith('//') then
      begin
        conf:=TArrayRecord<string>.Create(line.Split([#9]));
        if (conf.Count > 0) and (conf.Count >=5) then
        begin
          case IndexStr(conf[0].Trim.ToUpper, [SCOPE_LOCAL.ToUpper, SCOPE_REMOTE.ToUpper]) of
            0: ;
            1: begin
                 serv:=TmServiceRemote.Create;
                 serv.Address:=conf[2].Trim;
                 if serv.Address.EndsWith('/') then
                  serv.Address:=serv.Address.Substring(0, serv.Address.Length - 1);
                 serv.ProfileAddress:=string.Join('', [serv.Address, PIMLICO_PROFILE_ENDPOINT]);
                 serv.Port:=conf[3];
                 serv.Enabled:=conf[4].Trim.ToUpper = SERVICE_ENABLED.ToUpper;

                 Pimlico.add(conf[1], serv);
               end;
          end;
        end;
      end;
    end;
  finally
    lines.Free;
  end;

end;

end.
