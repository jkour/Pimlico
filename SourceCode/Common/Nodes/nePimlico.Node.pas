unit nePimlico.Node;

interface

uses
  nePimlico.Base.Types, nePimlico.Node.Types, System.Generics.Collections,
  nePimlico.LoadBalancer.Types;

type
  TmNode = class (TBaseInterfacedObject, ImNode)
  private
    fList: TList<ILoadBalancer>;
{$REGION 'Interface'}
  function add(const aLoadBalancer: ILoadBalancer): ImNode;
  procedure delete (const aLoadBalancer: ILoadBalancer);
  procedure getLoadBalancers (const aPattern: string; var list: TList<ILoadBalancer>);
{$ENDREGION}
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

constructor TmNode.Create;
begin
  inherited;
  fList:=TList<ILoadBalancer>.Create;
end;

destructor TmNode.Destroy;
begin
  fList.Free;
  inherited;
end;

procedure TmNode.getLoadBalancers (const aPattern: string; var list: TList<ILoadBalancer>);
var
  loader: ILoadBalancer;
begin
  Assert(Assigned(list));
  list.AddRange(fList);
end;

{ TmNode }

function TmNode.add(const aLoadBalancer: ILoadBalancer): ImNode;
begin
  Assert(Assigned(aLoadBalancer));
  if not fList.Contains(aLoadBalancer) then
    fList.Add(aLoadBalancer);
  Result:=Self;
end;

procedure TmNode.delete(const aLoadBalancer: ILoadBalancer);
begin
  Assert(Assigned(aLoadBalancer));
  if fList.Contains(aLoadBalancer) then
    fList.Remove(aLoadBalancer);
end;

end.
