unit Plugin.Manager;

interface

uses
  Plugin.Manager.Types;

function PlugInManager: IPluginManager;

implementation

uses
  System.SyncObjs, System.SysUtils, nePimlico.Types, neDebut.Globals,
  System.Generics.Collections
  {$IFDEF MSWINDOWS}
  , Winapi.Windows
  {$ENDIF}
  , FMX.Dialogs, nePimlico.Factory, nePimlico.mService.Types, Plugin.Types;

var
  critical: TCriticalSection;

type
  TPluginManager = class (TInterfacedObject, IPluginManager)
  private
    fHandles: TList<HMODULE>;
    fPimlicos: TList<IPimlico>;
    fAvailablePlugins: TObjectList<TPluginProfile>;
    fPluginList: TList<IPluginBase>;
{$REGION 'Interface'}
    function getAvailablePlugings: TObjectList<TPluginProfile>;
    procedure loadPlugins;
    procedure enablePlugin (const aID: string; const aStatus: boolean);
    function find (const aPattern: string): TList<IPluginBase>;
    procedure startPlugins (const aPattern: string);
    procedure stopPlugins (const aPattern: string);
{$ENDREGION}
    function isEnabled(const aID: string): boolean;
  public
    constructor Create;
    destructor Destroy; override;
  end;

procedure createPluginManager;
var
  func: TFunc<IPluginManager>;
begin
  func:=function: IPluginManager
                  begin
                    result:=TPluginManager.Create;
                  end;
  critical.Acquire;
  try
    TGlobals<IPluginManager>.createInstance(func);
  finally
    critical.Release;
  end;
end;

function PlugInManager: IPluginManager;
begin
  critical.Acquire;
  try
    Result:=TGlobals<IPluginManager>.Instance;
  finally
    critical.Release;
  end;
end;

constructor TPluginManager.Create;
begin
  inherited;
  fHandles:=TList<HMODULE>.Create;
  fPimlicos:=TList<IPimlico>.Create;
  fAvailablePlugins:=TObjectList<TPluginProfile>.Create;
  fPluginList:=TList<IPluginBase>.Create;
end;

destructor TPluginManager.Destroy;
var
  handle: HMODULE;
begin
  fPimlicos.Free;
  fHandles.Free;
  fAvailablePlugins.Free;

  fPluginList.Clear;
  fPluginList.Free;

  // This VERY VERY last
  for handle in fHandles do
    UnloadPackage(handle);

  inherited;
end;


procedure TPluginManager.enablePlugin(const aID: string; const aStatus:
    boolean);
var
  profile: TPluginProfile;
begin
  for profile in fAvailablePlugins do
    if profile.ID = aID then
    begin
      profile.Enabled:=aStatus;
      Break;
    end;
end;

function TPluginManager.find(const aPattern: string): TList<IPluginBase>;
var
  list: TList<ImService>;
  serv: ImService;
  plugin: IPluginBase;
  smallPimlico: IPimlico;
begin
  fPluginList.Clear;

  list:=pimlico.find(aPattern);
  for serv in list do
    if Supports(serv, IPluginBase, plugin) and isEnabled(plugin.ID) then
      fPluginList.Add(plugin);
  list.Free;

  for smallPimlico in fPimlicos do
  begin
    list:=smallPimlico.find(aPattern);
    for serv in list do
      if Supports(serv, IPluginBase, plugin) and isEnabled(plugin.ID) then
        fPluginList.Add(plugin);

    list.Free;
  end;

  result:=fPluginList;
end;

function TPluginManager.getAvailablePlugings: TObjectList<TPluginProfile>;
begin
  Result:=fAvailablePlugins;
end;

function TPluginManager.isEnabled(const aID: string): boolean;
var
  profile: TPluginProfile;
begin
  Result := false;
  for profile in fAvailablePlugins do
    if profile.ID = aID then
    begin
      Result:=profile.Enabled;
      break;
    end;
end;

procedure TPluginManager.loadPlugins;
var
  newHandle: HMODULE;
  path: string;
  registerPlugin: procedure (var aPim: IPimlico);
  pluginPimlico: IPimlico;
  smallPimlico: IPimlico;
  tagList: TList<string>;
  tag: string;
  serv: ImService;
  profile: TPluginProfile;
  pluginB: IPlugInBase;
begin
  {$IFDEF MSWINDOWS}
    path:='..\..\..\Demo.Plugin.BPL\Win32\Debug\Demo.Plugin.BPL.bpl';
  {$ENDIF}
    newHandle:=LoadPackage(path);
    if newHandle <> 0 then
    begin
      fHandles.Add(newHandle);

      @registerPlugin:=GetProcAddress(newHandle,
            '@Nepimlico@Factory@Pimlico$qqrv');
      if Assigned(registerPlugin) then
      begin
        registerPlugin(pluginPimlico);
        if Assigned(pluginPimlico) then
        begin
          fPimlicos.Add(pluginPimlico);
        end
      end
    end
    else
    begin
      ShowMessage('Plugin in not loaded');
      Exit;
    end;

    fAvailablePlugins.Clear;
    tagList:=pimlico.getExplicitPatterns('role: plugin, *');
    for tag in tagList do
    begin
      serv:=Pimlico.unique(tag);
      if Supports(serv, IPluginBase, pluginB) then
      begin
        profile:=TPluginProfile.Create;
        profile.Description:=pluginB.Description;
        profile.ID:=pluginB.ID;
        profile.Pattern:=tag;
        profile.&Type:=ptInternal;
        profile.Enabled:=True;
        fAvailablePlugins.Add(profile);
      end;
    end;
    tagList.Free;

    for smallPimlico in fPimlicos do
    begin
      tagList:=smallPimlico.getExplicitPatterns('role: plugin, *');
      for tag in tagList do
      begin
        serv:=smallPimlico.unique(tag);
        if Supports(serv, IPluginBase, pluginB) then
        begin
          profile:=TPluginProfile.Create;
          profile.Description:=pluginB.Description;
          profile.ID:=pluginB.ID;
          profile.Pattern:=tag;
          profile.&Type:=ptExternal;
          profile.Enabled:=True;
          fAvailablePlugins.Add(profile);
        end;
      end;
      tagList.Free;
    end;
end;

procedure TPluginManager.startPlugins(const aPattern: string);
var
  list: TList<ImService>;
  serv: ImService;
  smallPimlico: IPimlico;
begin
  list:=pimlico.find(aPattern);
  for serv in list do
    serv.start;
  list.Free;

  for smallPimlico in fPimlicos do
  begin
    list:=smallPimlico.find(aPattern);
    for serv in list do
      serv.start;
    list.Free;
  end;
end;

procedure TPluginManager.stopPlugins(const aPattern: string);
var
  list: TList<ImService>;
  serv: ImService;
  smallPimlico: IPimlico;
begin
  list:=pimlico.find(aPattern);
  for serv in list do
    serv.stop;
  list.Free;

  for smallPimlico in fPimlicos do
  begin
    list:=smallPimlico.find(aPattern);
    for serv in list do
      serv.stop;
    list.Free;
  end;
end;

initialization

critical:=TCriticalSection.Create;

createPluginManager;

finalization

critical.Free;

end.
