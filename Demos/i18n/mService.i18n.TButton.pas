unit mService.i18n.TButton;

interface

uses
  nePimlico.mService.Base;

type
  Ti18nButton = class(TmServiceBase)
  protected
    procedure invoke(const aParameters: string); override;
  end;

implementation

uses
  FMX.StdCtrls, nePimlico.Utils, System.SysUtils, nePimlico.Factory,
  nePimlico.Base.Types, nePimlico.Types;

{ Ti18nButton }

procedure Ti18nButton.invoke(const aParameters: string);
var
  obj: TObject;
  component: TButton;
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
  if (obj is TButton) then // and (TButton(obj).ClassType = TButton) then
  begin
    component:=TButton(poin^);
    pimlico.act('role: i18n, cmd: Translate',
               'Text: ' + component.Text + ', From: ' + fromLang + 'To: ' + toLang, atSync,
                procedure(aStatus: TStatus)
                begin
                  component.Text:=aStatus.Response;
                end);
  end;
end;
end.
