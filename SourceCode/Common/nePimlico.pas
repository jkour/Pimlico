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
    function add(const aRole: string; const aNode: ImNode): IPimlico;
    procedure act(const aMessage, aParameters: string); overload; virtual;
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
      while status.Status = secRunning do
        ;
      if Assigned(aCallBack) then
        aCallBack(status);
      Break;
    end;
  end;
end;

procedure TPimlico.act(const aMessage, aParameters: string);
var
  pattern: string;
begin
  {TODO -oOwner -cGeneral : Pattern Matching}
  for pattern in fNodes.Keys do
  begin
    if aMessage.ToUpper.StartsWith(pattern) then
    begin
      fNodes.Items[pattern].push(aMessage, aParameters);
      Break;
    end;
  end;
end;

function TPimlico.add(const aRole: string; const aNode: ImNode): IPimlico;
var
  role: string;
begin
  role:=Trim(aRole);
  if role.ToUpper.Contains(ROLE_TAG) then
    role:=role.ToUpper.Replace(ROLE_TAG, '').Trim;
  if role='' then
    Exit;
  Assert(Assigned(aNode));
  if not fNodes.ContainsKey(role) then
    fNodes.Add(role, aNode);
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
