unit View.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls, System.Rtti,
  FMX.Grid.Style, FMX.Grid, FMX.ScrollBox, FMX.Edit, FMX.Objects,
  System.Generics.Collections, nePimlico.mService.Types;

type
  TFormMain = class(TForm)
    btnShow: TButton;
    btnOptions: TButton;
    gridPlugins: TStringGrid;
    StringColumn1: TStringColumn;
    Enabled: TCheckColumn;
    StringColumn2: TStringColumn;
    Label2: TLabel;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    procedure FormCreate(Sender: TObject);
    procedure btnOptionsClick(Sender: TObject);
    procedure btnShowClick(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses
  View.Project.Options, nePimlico.Factory, Plugin.Types,
  System.IOUtils
  {$IFDEF MSWINDOWS}
  , Winapi.Windows
  {$ENDIF}
  , nePimlico.Types, Plugin.Manager, Plugin.Manager.Types;

{$R *.fmx}

const
  PATTERN = 'role: plugin, space: project-options, cmd: add-new-option';

procedure TFormMain.FormCreate(Sender: TObject);
begin
  PluginManager.LoadPlugins;
end;

procedure TFormMain.btnOptionsClick(Sender: TObject);
var
  form: TFormProjectOptions;
  row: integer;
begin
  for row:= 0 to gridPlugins.RowCount - 1 do
    PlugInManager.EnablePlugin(gridPlugins.Cells[2, row],
                               gridPlugins.Cells[0, row].ToUpper = 'TRUE');

  form:=TFormProjectOptions.Create(self);
  form.ShowModal;
  form.Free;
end;

procedure TFormMain.btnShowClick(Sender: TObject);
var
  profile: TPluginProfile;
begin
  gridPlugins.RowCount:=0;
  for profile in PlugInManager.AvailablePlugings do
  begin
    gridPlugins.RowCount:=gridPlugins.RowCount + 1;
    if profile.Enabled then
      gridPlugins.Cells[0, gridPlugins.RowCount - 1]:= 'True'
    else
      gridPlugins.Cells[0, gridPlugins.RowCount - 1]:= 'False';
    if profile.&Type = ptInternal then
      gridPlugins.Cells[1, gridPlugins.RowCount - 1]:= 'Internal'
    else
      gridPlugins.Cells[1, gridPlugins.RowCount - 1]:= 'External';
    gridPlugins.Cells[2, gridPlugins.RowCount - 1]:= profile.ID;
    gridPlugins.Cells[3, gridPlugins.RowCount - 1]:= profile.Pattern;
    gridPlugins.Cells[4, gridPlugins.RowCount - 1]:= profile.Description;
  end;
end;

end.
