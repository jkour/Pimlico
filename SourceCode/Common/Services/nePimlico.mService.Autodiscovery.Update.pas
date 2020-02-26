unit nePimlico.mService.Autodiscovery.Update;

interface

uses
  nePimlico.mService.Base, nePimlico.mService.Types;

type
  TServiceAutodiscoveryUpdate = class(TmServiceBase)
  protected
    procedure invoke(const aParameters: string); override;
  public

  end;

implementation

uses
  nePimlico.Utils, nePimlico.Types, SysUtils, System.IOUtils, System.Classes;

{$I ..\pimlico-autodiscovery.inc}

procedure TServiceAutodiscoveryUpdate.invoke(const aParameters: string);
var
  id: string;
  auto: string;
  strList: TStringList;
begin
  inherited;
  id:=extractValueFromParams(aParameters, 'app-id');
  fStatus.Response:='';
  try
    auto:=RESTHTTP.get(RESTHTTP.get(string.Join('',
                      [PIMLICO_AUTODISCOVERY_URL,
                        Format(PIMLICO_AUTODISCOVERY_UPDATE_ENDPOINT,
                                [id])])));
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

end.
