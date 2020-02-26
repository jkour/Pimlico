unit nePimlico.mService.Autodiscovery;

interface

uses
  nePimlico.mService.Base, nePimlico.mService.Types;

type
  TServiceAutodiscovery = class(TmServiceBase)
  protected
    procedure invoke(const aParameters: string); override;
  public

  end;

implementation

uses
  nePimlico.Utils, SysUtils, nePimlico.Types, nePimlico.Base.Types,
  System.Classes, System.IOUtils;

{$I ..\pimlico-autodiscovery.inc}

procedure TServiceAutodiscovery.invoke(const aParameters: string);
var
  auto: string;
  id: string;
  existsStr: string;
  strList: TStringList;
begin
  inherited;
  id:=extractValueFromParams(aParameters, 'app-id');
  fStatus.Response:='';
  try
    existsStr:=RESTHTTP.get(string.Join('',
                      [PIMLICO_AUTODISCOVERY_URL,
                        Format(PIMLICO_AUTODISCOVERY_UPDATE_EXISTS_ENDPOINT,
                                [id])]));
  except
    ; //PALOFF
  end;

  if existsStr = 'true' then
  begin
    try
      auto:=RESTHTTP.get(string.Join('',
                        [PIMLICO_AUTODISCOVERY_URL,
                          Format(PIMLICO_AUTODISCOVERY_UPDATE_ENDPOINT,
                                  [id])]));
    except
      ; //PALOFF
    end;

    strList:=TStringList.Create;
    try
      fStatus.Response:=TPath.Combine(TPath.GetTempPath, PIMLICO_CONFIG_FILE);
      strList.Text:=auto;
      strList.SaveToFile(fStatus.Response, TEncoding.UTF8);
    finally
      strList.Free;
    end;
  end;
end;

end.
