unit Plugin.ProjectOptions.NewOption;

interface

uses
  Plugin.Types, System.Classes, FMX.Forms;

type
  TPluginProjectOptionsNewOption = class(TPluginBase, IPluginProjectOptions)
  private
    fHost: TForm;
{$REGION 'Interface'}
    function getHost: TForm;
    procedure setHost(const Value: TForm);
{$ENDREGION}
    procedure OnOptionChangeEventHandler (Sender: TObject);
  protected
    function getDescription: string; override;
    procedure setup; override;
    procedure start; override;
  public
    constructor Create;
  end;

implementation

uses
  nePimlico.Factory, FMX.StdCtrls, FMX.Dialogs,
  nePimlico.mService.Types, System.SysUtils, nePimlico.Base.Types,
  System.Math, FMX.Controls, FMX.Objects;

var
  idTag: string;

constructor TPluginProjectOptionsNewOption.Create;
begin
  inherited;
  fHost:=nil;
end;

{ TPluginProjectOptionsNewOption }

function TPluginProjectOptionsNewOption.getDescription: string;
begin
  Result:='Add New Option in Project Options';
end;

function TPluginProjectOptionsNewOption.getHost: TForm;
begin
  Result:=fHost;
end;

procedure TPluginProjectOptionsNewOption.OnOptionChangeEventHandler(
  Sender: TObject);
begin
  TThread.Synchronize(nil, procedure
                           begin
                             ShowMessage('Option Changed');
                           end);
end;

procedure TPluginProjectOptionsNewOption.setHost(const Value: TForm);
begin
  Assert(Assigned(Value));
  fHost:=Value;
end;

procedure TPluginProjectOptionsNewOption.setup;
var
  cb: TCheckBox;
  cbExist: TCheckBox;
  component: TComponent;
  num: Integer;
  y: single;
  x: single;
  margin: single;
begin
  inherited;
  if Assigned(fHost) then
  begin
    cb:=TCheckBox.Create(fHost);
    cb.Parent:=fHost;
    x:=0;
    y:=0;
    margin:=0;
    for num:=0 to fHost.ComponentCount - 1 do
    begin
      component:=fHost.Components[num];
      if (component is TCheckBox) and ((component as TCheckBox).Name <> '') then
      begin
        cbExist:=component as TCheckBox;
        x:=cbExist.Position.X;
        y:=Max(y, cbExist.Position.Y);
        margin:=cbExist.Height;
      end;
    end;
    cb.Name:='Checkbox_'+ IntToStr(random(1000));
    cb.Position.X:=x;
    cb.Position.Y:=y + margin + 10;
    cb.Text:='Option '+idTag;
    cb.OnChange:=OnOptionChangeEventHandler;
  end;
end;

procedure TPluginProjectOptionsNewOption.start;
begin
   if (fStatus.Status = ssStarted) then
    Exit;
  inherited;
  setup;
end;

procedure registerPlugin;
begin
  idTag:= IntToStr(Random(1000));
  pimlico.add('role: plugin, space: project-options, cmd: add-new-option-'+idTag,
                              TPluginProjectOptionsNewOption.Create);

end;

initialization

  registerPlugin;

end.
