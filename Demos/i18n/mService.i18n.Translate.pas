unit mService.i18n.Translate;

interface

uses
  nePimlico.mService.Base, System.Generics.Collections;

type
  Ti18nTranslate = class (TmServiceBase)
  private
    fTranslation: TDictionary<string, string>;
  protected
    procedure invoke(const aParameters: string); override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  nePimlico.Utils,
  System.SysUtils;

constructor Ti18nTranslate.Create;
begin
  inherited;
  fTranslation:=TDictionary<string, string>.Create;
  fTranslation.Add('English', 'Αγγλικά');
  fTranslation.Add('Greek', 'Ελληνικά');
  fTranslation.Add('Hello!', 'Γεια σας!');
  fTranslation.Add('Translate', 'Μετάφρασε');

  fTranslation.Add('Αγγλικά', 'English');
  fTranslation.Add('Ελληνικά', 'Greek');
  fTranslation.Add('Γεια σας!', 'Hello!');
  fTranslation.Add('Μετάφρασε', 'Translate');
end;

destructor Ti18nTranslate.Destroy;
begin
  fTranslation.Free;
  inherited;
end;

{ Ti8nTranslate }

procedure Ti18nTranslate.invoke(const aParameters: string);
var
  text: string;
  fromLang: string;
  toLang: string;
begin
  inherited;
  text:=extractValueFromParams(aParameters, 'text');

  // We do not use the from: and to: tags in this example
  fromLang:=extractValueFromParams(aParameters, 'from');
  toLang:=extractValueFromParams(aParameters, 'to');

  if fTranslation.ContainsKey(text.Trim) then
    fStatus.Response:=fTranslation.Items[text.trim]
end;

end.
