unit nePimlico;

interface

uses
  nePimlico.Base.Types, nePimlico.Types,
  System.SysUtils, Motif, nePimlico.mService.Types;

type
  TPimlico = class (TBaseInterfacedObject, IPimlico)
  private
    fMotif: TMotif;
    fLastService: ImService;
{$REGION 'Interface'}
    function add(const aPattern: string; const aService: ImService): IPimlico;
    procedure act(const aPattern, aParameters: string; const aActionType: TActionType = atAsync;
          const aCallBack: TCallBackProc = nil); overload;
    function start: IPimlico;
    function stop: IPimlico;
    procedure startAll;
    procedure stopAll;
    function service: ImService;
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
end;

destructor TPimlico.Destroy;
begin
  fMotif.Clear;
  fMotif.Free;
  inherited;
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
    service.start;
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
