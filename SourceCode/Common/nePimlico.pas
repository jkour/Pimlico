unit nePimlico;

interface

uses
  nePimlico.Base.Types, nePimlico.Types, nePimlico.Node.Types,
  System.Generics.Collections, System.SysUtils;

type
  TPimlico = class (TBaseInterfacedObject, IPimlico)
  private
    fNodes: TThreadList<ImNode>;
{$REGION 'Interface'}
    function add(const aNode: ImNode): IPimlico;
    procedure act(const aPattern, aParameters: string; const aCallBack:
        TCallBackProc = nil); overload;
{$ENDREGION}
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  nePimlico.LoadBalancer.Types;

procedure TPimlico.act(const aPattern, aParameters: string; const aCallBack:
    TCallBackProc = nil);
var
  status: TStatus;
  node: ImNode;
  list: TList<ImNode>;
  availList: TList<ILoadBalancer>;
  tmpList: TList<ILoadBalancer>;
  lBalancer: ILoadBalancer;
begin
  availList:=TList<ILoadBalancer>.Create;
  list:=fNodes.LockList;
  for node in list do
  begin
    tmpList:=TList<ILoadBalancer>.Create;
    node.getLoadBalancers(aPattern, tmpList);
    availList.AddRange(tmpList);
    tmpList.Free;
  end;
  for lBalancer in availList do
    lBalancer.distribute(aPattern, aParameters);
  fNodes.UnlockList;
  availList.Free;
end;

function TPimlico.add(const aNode: ImNode): IPimlico;
begin
  Assert(Assigned(aNode));
  if not fNodes.LockList.Contains(aNode) then
    fNodes.Add(aNode);
  fNodes.UnlockList;
  Result:=Self;
end;

constructor TPimlico.Create;
begin
  inherited;
  fNodes:=TThreadList<ImNode>.Create;
end;

destructor TPimlico.Destroy;
begin
  fNodes.Free;
  inherited;
end;

end.
