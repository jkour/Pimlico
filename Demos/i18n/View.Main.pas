unit View.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TFormMain = class(TForm)
    Label1: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses
  nePimlico.Factory, nePimlico.Types, mService.Register;

{$R *.fmx}

procedure TFormMain.Button1Click(Sender: TObject);
var
  fromLang: string;
  toLang: string;
  num: integer;
  comp: TComponent;
begin
  /// We do not use these values in this example

//  if RadioButton1.IsChecked then
//  begin
//    fromLang:='EN';
//    toLang:='GR';
//  end;
//  if RadioButton2.IsChecked then
//  begin
//    toLang:='EN';
//    fromLang:='GR';
//  end;

  for num := 0 to self.ComponentCount - 1 do
  begin
    comp:=Self.Components[num];
    pimlico.act('role: i18n, class: *',
          'Pointer: '+IntToStr(Integer(@comp))+
          ', From: '+fromLang + ', To: '+toLang, atSync);
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  registeri18n;
end;

end.
