unit mService.i18n.TLabel;

interface

uses
  nePimlico.mService.Base;

type
  Ti18nLabel = class(TmServiceBase)
  protected
    procedure invoke(const aParameters: string); override;
  end;

implementation

uses
  FMX.StdCtrls, nePimlico.Utils, System.SysUtils, nePimlico.Factory,
  nePimlico.Base.Types, nePimlico.Types;

{ Ti18nLabel }

procedure Ti18nLabel.invoke(const aParameters: string);
var
  obj: TObject;
  component: TLabel;
  pointerStr: string;
  fromLang: string;
  toLang: string;
  poin: Pointer;
begin
  inherited;
  pointerStr:=extractValueFromParams(aParameters, 'Pointer');
  fromLang:=extractValueFromParams(aParameters, 'from');
  toLang:=extractValueFromParams(aParameters, 'to');

  poin:=Pointer(pointerStr.ToInteger);

  obj:=TObject(poin^);
  if (obj is TLabel) then // and (TLabel(obj).ClassType = TLabel) then
  begin
    component:=TLabel(poin^);
    pimlico.act('role: i18n, cmd: Translate',
               'Text: ' + component.Text + ', From: ' + fromLang + 'To: ' + toLang, atSync,
                procedure(aStatus: TStatus)
                begin
                  component.Text:=aStatus.Response;
                end);
  end;
end;

end.
