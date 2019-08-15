unit Motif;

interface

uses
  System.Classes, System.SysUtils, System.Rtti;

type
  TPatternItem = class
  private
    fResponse: string;
    fValue: TValue;
  public
    constructor Create;

    property Response: string read fResponse write fResponse;
    property Value: TValue read fValue write fValue;
  end;

  TOnBeforeAdd = procedure (const aPattern: string; var aValue: string;
                                var aContinue:Boolean) of object;

  TMotif = class
  private
    fList: TStringList;
    fOnBeforeAdd: TOnBeforeAdd;

    procedure addFuncValue(const aPattern: string; const aValue: TValue);

    function prepareTag(const aPattern: string): string;

    function getPatternItem (const aPattern: string; const aExact: Boolean): TPatternItem;
    function getPatternItemResponse(const index: integer): string;
  public
    function add(const aPattern: string; const aReturn: string = ''): TMotif; overload;
    function add<T>(const aPattern: string; const aFunc: TFunc<T>):TMotif; overload;

    function find(const aPattern: string; const aExact: Boolean = False): string; overload;
    function find<T>(const aPattern: string; const aExact: Boolean = False): T; overload;

    function list(const aPattern: string; const aExact: Boolean = False): string;

    procedure remove(const aPattern: string);

    procedure clear;
  public
    constructor Create;
    destructor Destroy; override;

    property OnBeforeAdd: TOnBeforeAdd read fOnBeforeAdd write fOnBeforeAdd;
  end;

implementation

uses
  ArrayHelper, System.Generics.Collections, System.TypInfo, flcStringPatternMatcher;

function TMotif.prepareTag(const aPattern: string): string;
var
  strArray: TArrayRecord<string>;
  arrList: TList<string>;
  tag: string;
begin
  tag:=aPattern.Replace('{','')
               .Replace('}','')
               .Replace('''','')
               .Trim
               .ToUpper;

  strArray:=TArrayRecord<string>.Create(tag.Split([',']));
  strArray.ForEach(procedure(var Value: string; Index: integer)
                   begin
                     Value:=Value.Trim;
                   end);
  arrList:=TList<string>.Create;
  strArray.List(arrList);

  result:=string.Join(',', arrList.ToArray);

  arrList.Free;
end;

function TMotif.getPatternItem(const aPattern: string; const aExact: Boolean):
    TPatternItem;
var
  arrList: TList<string>;
  arrStr: TArrayRecord<string>;
  index: integer;
  tag: string;
  item: TPatternItem;
  strItem: string;
begin
  result:=nil;
  tag:=prepareTag(aPattern);
  if fList.Find(tag, index) then
  begin
    item:=fList.Objects[index] as TPatternItem;
    if Assigned(item) then
      Result:=item;
  end;
  if aExact or Assigned(Result) then
    Exit;
  // Need to check for glob pattern
  for strItem in fList do
  begin
    if StrZMatchPatternW(PWideChar(strItem), PWideChar(tag)) > 0 then
    begin
      item:=fList.Objects[fList.IndexOf(strItem)] as TPatternItem;
      if Assigned(item) then
        result:=item;
      Break;
    end;
  end;
  arrStr:=TArrayRecord<string>.Create(tag.Split([',']));
  while arrStr.Count > 0 do
  begin
    arrStr.Delete(arrStr.Count - 1);

    arrList:=TList<string>.Create;
    arrStr.List(arrList);
    tag:=string.Join(',', arrList.ToArray);
    arrList.Free;

    if fList.Find(tag,index) then
    begin
      item:=fList.Objects[index] as TPatternItem;
      if Assigned(item) then
        Result:=item;
      Break;
    end
    else
    begin
      // Need to check for glob pattern
      for strItem in fList do
      begin
        if StrZMatchPatternW(PWideChar(strItem), PWideChar(tag)) > 0 then
        begin
          item:=fList.Objects[fList.IndexOf(strItem)] as TPatternItem;
          if Assigned(item) then
            result:=item;
          Break;
        end;
      end;
    end;
  end;
end;

function TMotif.getPatternItemResponse(const index: integer): string;
var
  obj: TPatternItem;
begin
  Result:='';
  if (index>=0) and (index<=fList.Count - 1) then
  begin
    obj:=fList.Objects[index] as TPatternItem;
    if Assigned(obj) then
      if obj.Response<>'' then
        Result := obj.Response;
  end;
end;

function TMotif.list(const aPattern: string; const aExact: Boolean): string;
var
  pattItem: TPatternItem;
  strPattern: string;
begin
  Result:='Available Patterns:';
  if (aPattern.Trim = '') or (aPattern = '*') then
  begin
    for strPattern in fList do
    begin
      Result:=Result+sLineBreak+'Pattern: '+strPattern+': '+find(strPattern, aExact);
    end;
  end
  else
  begin
    Result:=Result+sLineBreak+'Pattern: '+aPattern+': '+find(aPattern, aExact);
  end;
end;

{ TMotif }

function TMotif.add(const aPattern: string; const aReturn: string = ''): TMotif;
var
  tag: string;
  index: Integer;
  patItem: TPatternItem;
  patt: string;
  ret: string;
  cont: Boolean;
begin
  Result:=Self;

  patt:=aPattern;
  ret:=aReturn;
  cont:=True;

  if Assigned(fOnBeforeAdd) then
    fOnBeforeAdd(aPattern, ret, cont);
  if not cont then
    Exit;

  tag:=prepareTag(aPattern);
  if not fList.Find(tag, index) then
  begin
    patItem:=TPatternItem.Create;
    patItem.Response:=ret;
    fList.AddObject(tag, patItem);
  end;
end;

function TMotif.add<T>(const aPattern: string; const aFunc: TFunc<T>): TMotif;
var
  tag: string;
  index: Integer;
  funRec: T;
begin
  Result:=nil;
  if not Assigned(aFunc) then
    Exit;
  tag:=prepareTag(aPattern);
  if not fList.Find(tag, index) then
  begin
    funRec:=aFunc();
    addFuncValue(tag, TValue.From<T>(funRec));
  end;
  Result:=Self;
end;

function TMotif.find(const aPattern: string; const aExact: Boolean): string;
var
  item: TPatternItem;
begin
  Result:='';
  item:=getPatternItem(aPattern, aExact);
  if Assigned(item) then
    result:=item.Response;
end;

function TMotif.find<T>(const aPattern: string; const aExact: Boolean = False):
    T;
var
  item: TPatternItem;
begin
  item:=getPatternItem(aPattern, aExact);
  if Assigned(item) then
    result:=item.Value.AsType<T>;
end;

procedure TMotif.remove(const aPattern: string);
var
  index: integer;
begin
  if fList.Find(prepareTag(aPattern), index) then
    fList.Delete(index);
end;

procedure TMotif.clear;
begin
  fList.Clear;
end;

constructor TMotif.Create;
begin
  inherited;
  fList:=TStringList.Create;
  fList.Sorted:=True;
  fList.OwnsObjects:=True;
end;

destructor TMotif.Destroy;
begin
  fList.Free;
  inherited;
end;

// Workaround to bypass compiler error when TPatternItem is called in add<T>
// Delphi dcc32 error E2506 Method of parameterized type declared in
// interface section must not use local symbol
procedure TMotif.addFuncValue(const aPattern: string; const aValue: TValue);
var
  patItem: TPatternItem;
begin
  patItem:=TPatternItem.Create;
  patItem.Response:='Function';
  patItem.Value:=aValue;
  fList.AddObject(aPattern, patItem);
end;

constructor TPatternItem.Create;
begin
  inherited;
  fResponse:='';
  fValue:=TValue.Empty;
end;

end.
