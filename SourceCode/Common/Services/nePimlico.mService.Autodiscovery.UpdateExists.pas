unit nePimlico.mService.Autodiscovery.UpdateExists;

interface

uses
  nePimlico.mService.Base, nePimlico.mService.Types;

type
  TServiceAutodiscoveryUpdateExists = class(TmServiceBase)
  protected
    procedure invoke(const aParameters: string); override;
  public

  end;

implementation

uses
  nePimlico.Utils, SysUtils, nePimlico.Types, nePimlico.Base.Types;

{$I ..\pimlico-autodiscovery.inc}

procedure TServiceAutodiscoveryUpdateExists.invoke(const aParameters: string);
var
  id: string;
begin
  inherited;
  id:=extractValueFromParams(aParameters, 'app-id');
  fStatus.Response:='false';
  try
    fStatus.Response:=RESTHTTP.get(string.Join('',
                      [PIMLICO_AUTODISCOVERY_URL,
                        Format(PIMLICO_AUTODISCOVERY_UPDATE_EXISTS_ENDPOINT,
                                [id])]));
  except
    ; //PALOFF
  end;

end;

end.
