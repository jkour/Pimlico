unit Pimlico.Core;

interface

uses
  Pimlico.Base.Types, Pimlico.Types, Pimlico.Node.Types,
  System.Generics.Collections, System.SysUtils;

type
  TPimlico = class (TBaseInterfacedObject, IPimlico)
  private
    fNodes: TDictionary<string, ImNode>;
{$REGION 'Interface'}
    function add(const aPattern: string; const aNode: ImNode): IPimlico;
    procedure act(const aRoot: string; const aParameters: string;
                    const aMessageType: TMessageType; const aCallBack: TProc);
{$ENDREGION}
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

procedure TPimlico.act(const aRoot, aParameters: string;
  const aMessageType: TMessageType; const aCallBack: TProc);
begin

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
