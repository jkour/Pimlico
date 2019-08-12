unit nePimlico;

interface

uses
  nePimlico.Base.Types, nePimlico.Types, nePimlico.Node.Types,
  System.Generics.Collections, System.SysUtils;

type
  TPimlico = class (TBaseInterfacedObject, IPimlico)
  private
    fNodes: TDictionary<string, ImNode>;
{$REGION 'Interface'}
    function add(const aPattern: string; const aNode: ImNode): IPimlico;
    procedure act(const aRoot: string; const aParameters: string); overload; virtual;
    procedure act(const aRoot: string; const aParameters: string;
                                            const aCallBack: TCallBackProc); overload;
{$ENDREGION}
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

procedure TPimlico.act(const aRoot: string; const aParameters: string; const
    aCallBack: TCallBackProc);
var
  pattern: string;
  status: TStatus;
begin
  {TODO -oOwner -cGeneral : Pattern Matching}
  for pattern in fNodes.Keys do
  begin
    if aRoot.ToUpper.StartsWith(pattern) then
    begin
      fNodes.Items[pattern].push(aRoot, aParameters, status);
      Break;
    end;
  end;
  if Assigned(aCallBack) then
    aCallBack(status);
end;

procedure TPimlico.act(const aRoot, aParameters: string);
var
  pattern: string;
begin
  {TODO -oOwner -cGeneral : Pattern Matching}
  for pattern in fNodes.Keys do
  begin
    if aRoot.ToUpper.StartsWith(pattern) then
    begin
      fNodes.Items[pattern].push(aRoot, aParameters);
      Break;
    end;
  end;
end;

function TPimlico.add(const aPattern: string; const aNode: ImNode): IPimlico;
begin
  Assert(Assigned(aNode));
  if not fNodes.ContainsKey(aPattern.ToUpper) then
    fNodes.Add(aPattern.ToUpper, aNode);
  Result:=Self;
end;

constructor TPimlico.Create;
begin
  inherited;
  fNodes:=TDictionary<string, ImNode>.Create;
end;

destructor TPimlico.Destroy;
begin
  fNodes.Free;
  inherited;
end;

end.
