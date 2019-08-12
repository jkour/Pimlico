unit Pimlico.LoadBalancer.Default;

interface

uses
  Pimlico.Base.Types, Pimlico.LoadBalancer.Types, Pimlico.mService.Types,
  System.Generics.Collections;

type
  TLoadBalancerDefault = class(TBaseInterfacedObject, ILoadBalancer)
  private
    fDictionary: TObjectDictionary<string, TList<ImService>>;
    fList: TList<ImService>;
{$REGION 'Interface'}
    function addMService(const aPattern: string; const amService: ImService):
                                                                ILoadBalancer;
    procedure deleteMService (const amService: ImService);
    procedure distribute(const aPattern: string; const aParameters: string);
    function getMServices (const aPattern: string): TList<ImService>;
{$ENDREGION}
  public
    constructor Create;
    destructor Destroy; override;
  end;
implementation

uses
  System.SysUtils;

function TLoadBalancerDefault.addMService(const aPattern: string;
  const amService: ImService): ILoadBalancer;
var
  list:TList<ImService>;
begin
  Assert(Assigned(amService));
  if fDictionary.ContainsKey(aPattern.ToUpper) then
    list:=fDictionary.Items[aPattern.ToUpper]
  else
    list:=TList<ImService>.Create;
  list.Add(amService);
  fDictionary.AddOrSetValue(aPattern.ToUpper, list);
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

procedure TLoadBalancerDefault.distribute(const aPattern, aParameters: string);
var
  mService: ImService;
begin
  {TODO -oOwner -cGeneral : Add Pattern Matching)}
  if fDictionary.ContainsKey(aPattern.ToUpper) then
  begin
    for mService in fDictionary[aPattern.ToUpper] do
      mService.invoke(aParameters);
  end;
end;

function TLoadBalancerDefault.getMServices(
  const aPattern: string): TList<ImService>;
var
  pattern: string;
  mService: ImService;
begin
  fList.Clear;
  for pattern in fDictionary.Keys do
  begin
    {TODO -oOwner -cGeneral : Add Pattern Matching)}
    if pattern.StartsWith(aPattern) then
      fList.AddRange(fDictionary.Items[pattern]);
  end;
  Result:=fList;
end;

end.
