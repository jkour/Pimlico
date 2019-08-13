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

procedure TPimlico.act(const aPattern, aParameters: string; const aCallBack:
    TCallBackProc = nil);
var
  status: TStatus;
  node: ImNode;
begin
//  for pattern in fNodes.Keys do
//  begin
//    if aRoot.ToUpper.StartsWith(pattern) then
//    begin
//      fNodes.Items[pattern].push(aRoot, aParameters, status);
//      while status.Status = secRunning do
//        ;
//      if Assigned(aCallBack) then
//        aCallBack(status);
//      Break;
//    end;
//  end;
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
