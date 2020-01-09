unit mService.Register;

interface

procedure registeri18n;

implementation

uses
  nePimlico.Factory, mService.i18n.Translate, mService.i18n.TLabel,
  mService.i18n.TButton, mService.i18n.TRadioButton;

procedure registeri18n;
begin
  pimlico.add('role: i18n, cmd: translate', Ti18nTranslate.Create);

  pimlico.add('role: i18n, class: TLabel', Ti18nLabel.Create);
  pimlico.add('role: i18n, class: TButton', Ti18nButton.Create);
  pimlico.add('role: i18n, class: TRadioButton', Ti18nRadioButton.Create);
end;

end.
