unit View.Project.Options;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects,
  System.Generics.Collections;

type
  TFormProjectOptions = class(TForm)
    Rectangle1: TRectangle;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    btnSave: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private

  public
  end;

implementation

uses
  nePimlico.Factory, nePimlico.mService.Types, Plugin.Types,
  Plugin.Manager.Types, Plugin.Manager;

{$R *.fmx}

procedure TFormProjectOptions.FormCreate(Sender: TObject);
var
  plugin: IPluginBase;
  projOptPlugin: IPluginProjectOptions;
begin
  for plugin in PluginManager.find('role: plugin, space: project-options, cmd: *') do
    if Supports(plugin, IPluginProjectOptions, projOptPlugin) then
      projOptPlugin.Host:=self;
  PlugInManager.startPlugins('role: plugin, space: project-options, cmd: *');
end;

procedure TFormProjectOptions.btnSaveClick(Sender: TObject);
begin
  self.Close;
end;

procedure TFormProjectOptions.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PlugInManager.stopPlugins('role: plugin, space: project-options, cmd: *');
end;

end.
