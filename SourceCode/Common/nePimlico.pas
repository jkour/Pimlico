unit nePimlico;

interface

uses
  nePimlico.Base.Types, nePimlico.Types,
  System.SysUtils, Motif, nePimlico.mService.Types, ArrayHelper;

type
  TPimlico = class (TBaseInterfacedObject, IPimlico)
  private
    fMotif: TMotif;
    fLastService: ImService;
    fExcludeFromStarting: TArrayRecord<ImService>;
{$REGION 'Interface'}
    function add(const aPattern: string; const aService: ImService): IPimlico;
    procedure act(const aPattern, aParameters: string; const aActionType: TActionType = atAsync;
          const aCallBack: TCallBackProc = nil); overload;
    function start: IPimlico;
    function stop: IPimlico;
    procedure startAll;
    procedure stopAll;
    function service: ImService;
    function excludeFromStarting: IPimlico;
{$ENDREGION}
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.Generics.Collections, System.Classes, System.Threading;

procedure TPimlico.act(const aPattern, aParameters: string; const aActionType:
    TActionType = atAsync; const aCallBack: TCallBackProc = nil);
var
  service: ImService;
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
  for service in list do
  begin
    fLastService:=service;
    if aActionType = atAsync then
      TTask.Run(procedure
              begin
                service.invoke(aParameters);
                if Assigned(aCallBack) then
                  aCallBack(service.Status);
              end)
    else
    begin
      TThread.Synchronize(TThread.Current, procedure
                                           begin
                                             service.invoke(aParameters);
                                             if Assigned(aCallBack) then
                                               aCallBack(service.Status);
                                           end);
    end;
  end;
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
end;

destructor TPimlico.Destroy;
begin
  fMotif.Clear;
  fMotif.Free;
  inherited;
end;

function TPimlico.excludeFromStarting: IPimlico;
begin
  if Assigned(fLastService) then
    fExcludeFromStarting.Add(fLastService);
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
  service: ImService;
begin
  for service in fMotif.find<ImService>('*') do
  begin
    if not fExcludeFromStarting.Contains(service) then
      service.start;
  end;
end;

function TPimlico.stop: IPimlico;
begin
  if Assigned(fLastService) then
    fLastService.stop;
end;

procedure TPimlico.stopAll;
var
  service: ImService;
begin
  for service in fMotif.find<ImService>('*') do
    service.stop;
end;

end.
