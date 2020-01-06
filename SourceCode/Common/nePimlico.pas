unit nePimlico;

interface

uses
  nePimlico.Base.Types, nePimlico.Types, System.SysUtils, Motif,
  nePimlico.mService.Types, System.Generics.Collections,
  nePimlico.Brokers.Types, ArrayHelper, Quick.FileMonitor;

type
  TPimlico = class (TBaseInterfacedObject, IPimlico)
  private
    fMotif: TMotif;
    fLastService: ImService;
    fExcludeFromStarting: TArrayRecord<ImService>;
    fBroker: IPimlicoBroker;
    fConfFileMonitor: TFileMonitor;
    fLoadParams: string;
    fLoadReloadOnChange: boolean;
    fLoadInterval: Cardinal;
{$REGION 'Interface'}
    function add(const aPattern: string; const aService: ImService): IPimlico;
    procedure act(const aPattern, aParameters: string; const aActionType: TActionType = atAsync;
          const aCallBack: TCallBackProc = nil); overload;
    procedure remove (const aPattern: string);
    /// <remarks>
    ///   The Result (TList&lt;ImService&gt;) must be freed by the consumer
    /// </remarks>
    function find(const aPattern: string): TList<ImService>; {$IFNDEF DEBUG}inline;{$ENDIF}
    function unique(const aPattern: string): ImService; {$IFNDEF DEBUG}inline;{$ENDIF}
    function start: IPimlico;
    function stop: IPimlico;
    procedure startAll;
    procedure stopAll;
    function service: ImService;
    function excludeFromStarting: IPimlico;
    function registerBroker(const aBroker: IPimlicoBroker): IPimlico;
    procedure loadConfiguration(const aPath: string;
                                const aReloadOnChange: Boolean = True;
                                const aInterval: Cardinal = POLL_INTERVAL);
{$ENDREGION}
    procedure OnFileModifiedEvent (MonitorNofify : TMonitorNotify);
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.Classes, System.Threading, nePimlico.Brokers.Local, System.IOUtils,
  System.StrUtils, nePimlico.mService.Remote, nePimlico.mService.Pimlico.LoadConfiguration;

procedure TPimlico.act(const aPattern, aParameters: string; const aActionType:
    TActionType = atAsync; const aCallBack: TCallBackProc = nil);
var
  serv: ImService;
  list: TList<ImService>;
  status: TStatus;
begin
  if aPattern.ToUpper = ACTION_START.ToUpper then
  begin
    startAll;
    Exit;
  end;

  if aPattern.ToUpper = ACTION_STOP.ToUpper then
  begin
    stopAll;
    Exit;
  end;

  list:=fMotif.findClassByPattern<ImService>(aPattern);
  for serv in list do
  begin
    status:=serv.Status;
    if serv.Enabled then
    begin
      fLastService:=serv;
      if aActionType = atAsync then
        TTask.Run(procedure
                begin
                  status.Response:=fBroker.request(serv, aParameters);  // PALOFF
                  if Assigned(aCallBack) then
                    aCallBack(status);
                end)
      else
      begin
        TThread.Synchronize(TThread.Current, procedure
                                             begin
                                               status.Response:=
                                                 fBroker.request(serv, aParameters);// PALOFF
                                               if Assigned(aCallBack) then
                                                 aCallBack(status);
                                             end);
      end;
    end;
  end;
  list.Free;
end;

function TPimlico.add(const aPattern: string; const aService: ImService):
    IPimlico;
begin
  Assert(Assigned(aService));
  fMotif.add<ImService>(aPattern, function: ImService
                                  begin
                                    Result:=aService;
                                  end); // PALOFF
  fLastService:=aService;
  Result:=Self;
end;

constructor TPimlico.Create;
begin
  inherited;
  fMotif:=TMotif.Create;
  fExcludeFromStarting:=TArrayRecord<ImService>.Create(0);
  fBroker:=TPimlicoBrokerLocal.Create;

  add(PIMLICO_SERVICE_LOAD_CONFIGURATION, TServicePimlicoLoadConfiguration.Create);
end;

destructor TPimlico.Destroy;
begin
  fMotif.Clear;
  fMotif.Free;
  fBroker:=nil;
  if Assigned(fConfFileMonitor) then
  begin
    fConfFileMonitor.OnFileChange:=nil;
    fConfFileMonitor.Enabled:=false;
  end;
  {TODO -oOwner -cGeneral : Fix TFileMonitor freesing}
  // This prevents the app from exiting
  // Disabled for now; but need to fix because it leaks
  // fConfFileMonitor.Free;
  inherited;
end;

function TPimlico.excludeFromStarting: IPimlico;
begin
  if Assigned(fLastService) then
    fExcludeFromStarting.Add(fLastService); // PALOFF
  Result:=self;
end;

function TPimlico.find(const aPattern: string): TList<ImService>;
begin
  result:=fMotif.findClassByPattern<ImService>(aPattern);
end;

procedure TPimlico.loadConfiguration(const aPath: string; const
    aReloadOnChange: Boolean = True; const aInterval: Cardinal = POLL_INTERVAL);
begin
  fLoadParams:=aPath;
  fLoadReloadOnChange:=aReloadOnChange;
  fLoadInterval:=aInterval;

  if Assigned(fConfFileMonitor) and fConfFileMonitor.Enabled then
    fConfFileMonitor.Enabled:=False;

  act(PIMLICO_SERVICE_LOAD_CONFIGURATION,
                    string.Join(': ', ['Path', aPath.Trim]), atSync,
                          procedure(aStatus: TStatus)
                          begin
                            if Assigned(fConfFileMonitor) then
                              fConfFileMonitor.Enabled:=fLoadReloadOnChange;
                          end);

  if (not Assigned(fConfFileMonitor)) and aReloadOnChange then
  begin
    fConfFileMonitor:=TFileMonitor.Create;
    fConfFileMonitor.FileName:=TPath.Combine(aPath, PIMLICO_CONFIG_FILE);
    fConfFileMonitor.Interval:=aInterval;
    fConfFileMonitor.Notifies:=[mnFileCreated, mnFileModified];
    fConfFileMonitor.OnFileChange:=OnFileModifiedEvent;
  end;
end;

procedure TPimlico.OnFileModifiedEvent(MonitorNofify: TMonitorNotify); //FI:O804
begin
  loadConfiguration(fLoadParams, fLoadReloadOnChange, fLoadInterval);
end;

function TPimlico.registerBroker(const aBroker: IPimlicoBroker): IPimlico;
begin
  Assert(Assigned(aBroker), 'Broker is nil');
  fBroker:=nil;
  fBroker:=aBroker;  // fi:W508
  result:=self;
end;

procedure TPimlico.remove(const aPattern: string);
var
  list: TList<string>;
  tag: string;
begin
  list:=fMotif.findByPattern(aPattern);
  for tag in list do
    fMotif.remove(tag);
  list.Free;
end;

function TPimlico.service: ImService;
begin
  Result:=fLastService;
end;

function TPimlico.start: IPimlico;
begin
  if Assigned(fLastService) then
    fLastService.start;
  Result:=self;
end;

procedure TPimlico.startAll;
var
  serv: ImService;
  serviceList: TList<ImService>;
begin
  serviceList:= fMotif.findClassByPattern<ImService>('*');
  for serv in serviceList do
  begin
    if (not fExcludeFromStarting.Contains(serv)) and
        serv.Enabled then
      serv.start;
  end;
  serviceList.Free;
end;

function TPimlico.stop: IPimlico;
begin
  if Assigned(fLastService) and fLastService.Enabled then
    fLastService.stop;
  Result:=self;
end;

procedure TPimlico.stopAll;
var
  serv: ImService;
  serviceList: TList<ImService>;
begin
  serviceList:= fMotif.findClassByPattern<ImService>('*');
  for serv in serviceList do
    serv.stop;
  serviceList.Free;
end;

function TPimlico.unique(const aPattern: string): ImService;
var
  list: TList<ImService>;
begin
  Result:=nil;
  list:=nil;
  try
    list:=find(aPattern);
    if list.Count = 1 then
      Result:=list[0]
    else
      if list.Count > 1 then
        raise Exception.Create('Result is not unique ('+aPattern+')');
  finally
    list.Free;
  end;
end;

end.
