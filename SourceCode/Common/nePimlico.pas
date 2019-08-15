unit nePimlico;

interface

uses
  nePimlico.Base.Types, nePimlico.Types,
  System.SysUtils, Motif, nePimlico.mService.Types;

type
  TPimlico = class (TBaseInterfacedObject, IPimlico)
  private
    fMotif: TMotif;
{$REGION 'Interface'}
    function add(const aPattern: string; const aService: ImService): IPimlico;
    procedure act(const aPattern, aParameters: string; const aActionType: TActionType = atAsync;
          const aCallBack: TCallBackProc = nil); overload;
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
    if aActionType = atAsync then
      TTask.Run(procedure
              begin
                service.invoke(aParameters);
                if Assigned(aCallBack) then
                  aCallBack(service.Status);
              end)
    else
    begin
      service.invoke(aParameters);
      if Assigned(aCallBack) then
        aCallBack(service.Status);
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
  inherited;
end;

end.
