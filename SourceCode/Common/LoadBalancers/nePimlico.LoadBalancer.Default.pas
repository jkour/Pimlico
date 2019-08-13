unit nePimlico.LoadBalancer.Default;

interface

uses
  nePimlico.Base.Types, nePimlico.LoadBalancer.Types, nePimlico.mService.Types,
  System.Generics.Collections;

type
  TLoadBalancerDefault = class(TBaseInterfacedObject, ILoadBalancer)
  private
    fDictionary: TObjectDictionary<string, TList<ImService>>;
    fList: TList<ImService>;
{$REGION 'Interface'}
    function addMService(const aCommand: string; const amService: ImService):
                                                                ILoadBalancer;
    procedure deleteMService (const amService: ImService);
    procedure distribute(const aCommand: string; const aParameters: string); overload;
    procedure distribute (const aCommand: string; const aParameters: string;
                                var aStatus: TStatus); overload;
    function getMServices (const aCommand: string): TList<ImService>;
{$ENDREGION}
  public
    constructor Create;
    destructor Destroy; override;
  end;
implementation

uses
  System.SysUtils;

function TLoadBalancerDefault.addMService(const aCommand: string; const
    amService: ImService): ILoadBalancer;
var
  list:TList<ImService>;
  cmd: string;
begin
  Assert(Assigned(amService));

  cmd:=Trim(aCommand);
  if cmd.ToUpper.Contains(CMD_TAG) then
    cmd:=cmd.ToUpper.Replace(CMD_TAG, '').Trim;
  if cmd='' then
    Exit;

  if fDictionary.ContainsKey(cmd) then
    list:=fDictionary.Items[cmd]
  else
    list:=TList<ImService>.Create;
  if not list.Contains(amService) then
    list.Add(amService);
  fDictionary.AddOrSetValue(cmd, list);
  Result:=Self;
end;

constructor TLoadBalancerDefault.Create;
begin
  inherited;
  fDictionary:=TObjectDictionary<string, TList<ImService>>.Create([doOwnsValues]);
  fList:=TList<ImService>.Create;
end;

procedure TLoadBalancerDefault.deleteMService(const amService: ImService);
var
  list: TList<ImService>;
begin
  Assert(Assigned(amService));
  for list in fDictionary.Values do
  begin
    if list.Contains(amService) then
    begin
      list.Remove(amService);
      Break;
    end;
  end;
end;

destructor TLoadBalancerDefault.Destroy;
begin
  fDictionary.Free;
  fList.Free;
  inherited;
end;

procedure TLoadBalancerDefault.distribute(const aCommand, aParameters: string;
  var aStatus: TStatus);
var
  mService: ImService;
begin
  {TODO -oOwner -cGeneral : Add Pattern Matching)}
  if fDictionary.ContainsKey(aCommand.ToUpper) then
  begin
    for mService in fDictionary[aCommand.ToUpper] do
    begin
      mService.invoke(aParameters);
      aStatus:=mService.Status;
    end;
  end;
end;

procedure TLoadBalancerDefault.distribute(const aCommand: string; const
    aParameters: string);
var
  status: TStatus;
begin
  distribute(aCommand, aParameters, status);
end;

function TLoadBalancerDefault.getMServices(const aCommand: string):
    TList<ImService>;
var
  pattern: string;
  mService: ImService;
begin
  fList.Clear;
  for pattern in fDictionary.Keys do
  begin
    {TODO -oOwner -cGeneral : Add Pattern Matching)}
    if pattern.StartsWith(aCommand) then
      fList.AddRange(fDictionary.Items[pattern]);
  end;
  Result:=fList;
end;

end.
