unit nePimlico;

interface

uses
  nePimlico.Base.Types, nePimlico.Types, System.SysUtils, Motif,
  nePimlico.mService.Types, ArrayHelper, System.Generics.Collections,
  nePimlico.Brokers.Types;

type
  TPimlico = class (TBaseInterfacedObject, IPimlico)
  private
    fMotif: TMotif;
    fLastService: ImService;
    fExcludeFromStarting: TArrayRecord<ImService>;
    fBroker: IPimlicoBroker;
{$REGION 'Interface'}
    function add(const aPattern: string; const aService: ImService): IPimlico;
    procedure act(const aPattern, aParameters: string; const aActionType: TActionType = atAsync;
          const aCallBack: TCallBackProc = nil); overload;
    function find(const aPattern: string): TList<ImService>; inline;
    function start: IPimlico;
    function stop: IPimlico;
    procedure startAll;
    procedure stopAll;
    function service: ImService;
    function excludeFromStarting: IPimlico;
    function registerBroker(const aBroker: IPimlicoBroker): IPimlico;
{$ENDREGION}
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.Classes, System.Threading, nePimlico.Brokers.Local;

procedure TPimlico.act(const aPattern, aParameters: string; const aActionType:
    TActionType = atAsync; const aCallBack: TCallBackProc = nil);
var
  serv: ImService;
  list: TList<ImService>;
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

  list:=fMotif.find<ImService>(aPattern);
  for serv in list do
  begin
    if serv.Enabled then
    begin
      fLastService:=serv;
      if aActionType = atAsync then
        TTask.Run(procedure
                begin
                  fBroker.request(serv, aParameters);
                  if Assigned(aCallBack) then
                    aCallBack(serv.Status);
                end)
      else
      begin
        TThread.Synchronize(TThread.Current, procedure
                                             begin
                                               fBroker.request(serv, aParameters);
                                               if Assigned(aCallBack) then
                                                 aCallBack(serv.Status);
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
                                  end);
  fLastService:=aService;
  Result:=Self;
end;

constructor TPimlico.Create;
begin
  inherited;
  fMotif:=TMotif.Create;
  fExcludeFromStarting:=TArrayRecord<ImService>.Create(0);
  fBroker:=TPimlicoBrokerLocal.Create;
end;

destructor TPimlico.Destroy;
begin
  fMotif.Clear;
  fMotif.Free;
  fBroker:=nil;
  inherited;
end;

function TPimlico.excludeFromStarting: IPimlico;
begin
  if Assigned(fLastService) then
    fExcludeFromStarting.Add(fLastService);
end;

function TPimlico.find(const aPattern: string): TList<ImService>;
begin
  result:=fMotif.find<ImService>(aPattern);
end;

function TPimlico.registerBroker(const aBroker: IPimlicoBroker): IPimlico;
begin
  fBroker:=nil;
  fBroker:=aBroker;
  result:=self;
end;

function TPimlico.service: ImService;
begin
  Result:=fLastService;
end;

function TPimlico.start: IPimlico;
begin
  if Assigned(fLastService) then
    fLastService.start;
end;

procedure TPimlico.startAll;
var
  serv: ImService;
  serviceList: TList<ImService>;
begin
  serviceList:= fMotif.find<ImService>('*');
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
end;

procedure TPimlico.stopAll;
var
  serv: ImService;
  serviceList: TList<ImService>;
begin
  serviceList:= fMotif.find<ImService>('*');
  for serv in serviceList do
    serv.stop;
  serviceList.Free;
end;

end.
