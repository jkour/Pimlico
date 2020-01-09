unit Motif;

interface

uses
  System.Classes, System.SysUtils, System.Rtti, System.Generics.Collections;

type
  TPatternItem = class
  private
    fResponse: string;
    fTag: string;
    fValue: TValue;
    procedure setTag(const aValue: string);
  public
    constructor Create;
    destructor Destroy; override;

    property Response: string read fResponse write fResponse;
    property Tag: string read fTag write setTag;
    property Value: TValue read fValue write fValue;
  end;

  TOnBeforeAdd = procedure (const aPattern: string; var aValue: string;
                                var aContinue:Boolean) of object;

  TMotif = class
  private
    fList: TStringList;
    fItemsList: TList<TPatternItem>;
    fOnBeforeAdd: TOnBeforeAdd;

    procedure addItem(const aTag: string; const aItem: TPatternItem);
    function getGlobPatternItem(const itemString, tag: string): TList<TPatternItem>;

    function prepareTag(const aPattern: string): string;

    procedure retrievePatternItems(const aPattern: string; const aExact: Boolean);
    function getPatternItemResponse(const index: integer): string;
  public
    function add(const aPattern: string; const aReturn: string = ''): TMotif; overload;
    function add<T>(const aPattern: string; const aFunc: TFunc<T>):TMotif; overload;

    {$REGION 'Returns a list of strings of the return items based on aPattern'}
    /// <summary>
    ///   Returns a list of strings of the return items based on aPattern
    /// </summary>
    /// <remarks>
    ///   The consumer of the function is responsible for destroying the list
    /// </remarks>
    {$ENDREGION}
    function findByPattern(const aPattern: string; const aExact: Boolean = False): TList<string>;
          {$IFNDEF DEBUG}inline;{$ENDIF}
    function findClassByPattern<T>(const aPattern: string; const aExact: Boolean = False):
        TList<T>; {$IFNDEF DEBUG}inline;{$ENDIF}

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
  ArrayHelper, System.TypInfo, flcStringPatternMatcher;

function TMotif.getGlobPatternItem(const itemString, tag: string):
    TList<TPatternItem>;
var
  pattern: string;
  testStr: string;
begin
  result:=nil;

  if (tag.Contains('?') or tag.Contains('*') or tag.Contains('[') or
        tag.Contains(']')) or (itemString.Contains('?') or
          itemString.Contains('*') or itemString.Contains('[') or
                                        itemString.Contains(']')) then
  begin
    if tag.Contains('?') or tag.Contains('*') or tag.Contains('[') or
      tag.Contains(']') then
    begin
      pattern:=tag;
      testStr:=itemString;
    end
    else
    begin
      pattern:=itemString;
      testStr:=tag;
    end;

    if tag.Equals('*') then
      result:=fList.Objects[fList.IndexOf(itemString)] as TList<TPatternItem>
    else
      if StrZMatchPatternW(PWideChar(pattern), PWideChar(testStr)) > 0 then
        result:=fList.Objects[fList.IndexOf(itemString)] as TList<TPatternItem>;
  end
  else
    if (itemString = tag) or (tag.Trim = '') then
      result:=fList.Objects[fList.IndexOf(itemString)] as TList<TPatternItem>;
end;

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

procedure TMotif.retrievePatternItems(const aPattern: string; const aExact:
    Boolean);
var
  arrList: TList<string>;
  arrStr: TArrayRecord<string>;
  index: integer;
  tag: string;
  item: TPatternItem;
  strItem: string;
  pattern: string;
  testStr: string;
  list: TList<TPatternItem>;
begin
  fItemsList.Clear;
  tag:=prepareTag(aPattern);
  for strItem in fList do
  begin
    if aExact then
    begin
      if strItem = tag then
        for item in (fList.Objects[fList.IndexOf(strItem)] as TList<TPatternItem>) do
          fItemsList.Add(item);
    end
    else
    begin
      list:=getGlobPatternItem(strItem, tag);
      if Assigned(list) then
        for item in list do
          fItemsList.Add(item);
    end;
  end;
  if aExact or (fItemsList.Count > 0) then
    Exit;
  arrStr:=TArrayRecord<string>.Create(tag.Split([',']));
  while arrStr.Count > 0 do
  begin
    arrStr.Delete(arrStr.Count - 1);

    arrList:=TList<string>.Create;
    arrStr.List(arrList);
    tag:=string.Join(',', arrList.ToArray);
    arrList.Free;

    if tag.Trim <> '' then
    begin
      list:=getGlobPatternItem(strItem, tag);
      if Assigned(list) then
        for item in list do
          fItemsList.Add(item);
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

{ TMotif }

function TMotif.add(const aPattern: string; const aReturn: string = ''): TMotif;
var
  tag: string;
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
  patItem:=TPatternItem.Create;
  patItem.Response:=ret;
  patItem.Tag:=aPattern;
  addItem(tag, patItem);
end;

function TMotif.add<T>(const aPattern: string; const aFunc: TFunc<T>): TMotif;
var
  tag: string;
  index: Integer;
  funRec: T;
  item: TPatternItem;
begin
  Result:=Self;
  if not Assigned(aFunc) then
    Exit;
  tag:=prepareTag(aPattern);

  funRec:=aFunc();
  item:=TPatternItem.Create;
  item.Response:=tag;
  item.Tag:=aPattern;
  item.Value:=TValue.From<T>(funRec);
  addItem(tag, item);
end;

function TMotif.findByPattern(const aPattern: string; const aExact: Boolean = False):
    TList<string>;
var
  item: TPatternItem;
begin
  Result:=TList<string>.Create;
  retrievePatternItems(aPattern, aExact);
  for item in fItemsList do
    if Assigned(item) then
      Result.Add(item.Response);
end;

function TMotif.findClassByPattern<T>(const aPattern: string; const aExact: Boolean = False):
    TList<T>;
var
  item: TPatternItem;
begin
  Result:=TList<T>.Create;
  retrievePatternItems(aPattern, aExact);
  for item in fItemsList do
    if Assigned(item) then
      Result.Add(item.Value.AsType<T>);
end;

function TMotif.list(const aPattern: string; const aExact: Boolean): string;
var
  pattItem: TPatternItem;
begin
  Result:='';
  fItemsList.Clear;
  retrievePatternItems(aPattern, aExact);
  for pattItem in fItemsList do
  begin
    result:=Result+pattItem.Tag+#9+' -> '+#9+pattItem.Response;
    if not pattItem.Value.IsEmpty then
      result:=Result+#9+'('+pattItem.Value.AsString+')';
    Result:=Result+sLineBreak;
  end;
end;

procedure TMotif.remove(const aPattern: string);
var
  item: TPatternItem;
  list: TList<string>;
  tag: string;
begin
  retrievePatternItems(aPattern, true);
  list:=TList<string>.Create;
  for item in fItemsList do
  begin
    list.Add(prepareTag(item.Tag));
    item.Free;
  end;
  for tag in list do
    if fList.IndexOf(tag) > -1 then
      fList.Delete(fList.IndexOf(tag));
  list.Free;
end;

procedure TMotif.clear;
var
  list: TList<TPatternItem>;
  item: TPatternItem;
  index: integer;
begin
  for index:=0 to fList.Count-1 do
  begin
    list:=fList.Objects[index] as TList<TPatternItem>;
    if Assigned(list) then
    begin
      for item in list do
        item.Free;
      // list is freed when fList is destroyed because it owns the objects
      // list.Free;
    end;
  end;
  fList.Clear;
end;

constructor TMotif.Create;
begin
  inherited;
  fList:=TStringList.Create;
  fList.Sorted:=True;
  fList.OwnsObjects:=True;
  fList.Duplicates:=dupIgnore;

  fItemsList:=TList<TPatternItem>.Create;
end;

destructor TMotif.Destroy;
begin
  fList.Free;
  fItemsList.Free;
  inherited;
end;

procedure TMotif.addItem(const aTag: string; const aItem: TPatternItem);
var
  index: Integer;
  list: TList<TPatternItem>;
begin
  if fList.Find(aTag, index) then
  begin
    list:=fList.Objects[index] as TList<TPatternItem>;
    if not list.Contains(aItem) then
    begin
      list.Add(aItem);
      fList.Objects[index]:=list;
    end
    else
      aItem.Free;
  end
  else
  begin
    list:=TList<TPatternItem>.Create;
    list.Add(aItem);
    fList.AddObject(aTag, list);
  end;
end;

constructor TPatternItem.Create;
begin
  inherited;
  fResponse:='';
  fValue:=TValue.Empty;
end;

destructor TPatternItem.Destroy;
begin
  fValue:=TValue.Empty;
  inherited;
end;

procedure TPatternItem.setTag(const aValue: string);
begin
  fTag := aValue;
end;

end.
