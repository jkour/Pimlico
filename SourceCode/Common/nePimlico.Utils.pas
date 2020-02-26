unit nePimlico.Utils;

interface

function extractValueFromParams (const aParameters: string; const aKey: string): string;

implementation

uses
  ArrayHelper, SysUtils;

function extractValueFromParams (const aParameters: string; const aKey: string): string;
var
  arrParams: TArrayRecord<string>;
  num: Integer;
begin
  Result:='';
  arrParams:=TArrayRecord<string>.Create(aParameters.Split([',']));
  num:=arrParams.Find(function(const Value: string): Boolean
                      begin
                        result:=Value.ToUpper.StartsWith(aKey.ToUpper);
                      end);
  if num > -1 then
  begin
    Result:=arrParams.ItemAt[num].Substring(aKey.Length + 1).Trim;
  end;
end;

end.
