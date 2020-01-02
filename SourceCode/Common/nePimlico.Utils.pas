unit nePimlico.Utils;

interface

function extractValueFromParams (const aParameters: string; const aKey: string): string;

implementation

uses
  ArrayHelper, SysUtils;

function extractValueFromParams (const aParameters: string; const aKey: string): string;
var
  arrParams: TArrayRecord<string>;
  arrValues: TArrayRecord<string>;
  num: Integer;
begin
  Result:='';
  arrParams:=TArrayRecord<string>.Create(aParameters.Split([',']));
  num:=arrParams.Find(function(const Value: string): Boolean
                      begin
                        result:=Value.ToUpper.Contains(aKey.ToUpper);
                      end);
  if num > -1 then
  begin
    arrValues:=TArrayRecord<string>.Create(arrParams.ItemAt[num].Split([':']));
    if arrValues.Count > 1 then
      Result:=arrValues.ItemAt[1].Trim;
  end;
end;

end.
