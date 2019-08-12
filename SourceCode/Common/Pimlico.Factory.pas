unit Pimlico.Factory;

interface

uses
  Pimlico.Types;

function Pimlico4D: IPimlico;

implementation

uses
  System.SyncObjs, System.SysUtils, Pimlico.Globals, Pimlico.Core;

var
  critical: TCriticalSection;

procedure createPimlico;    //PALOFF
var
  func: TFunc<IPimlico>;
begin
  func:=function: IPimlico
                  begin
                    result:=TPimlico.Create;
                  end;
  critical.Acquire;
  try
    TGlobals<IPimlico>.createInstance(func);
  finally
    critical.Release;
  end;
end;


function Pimlico4D: IPimlico;
begin
  critical.Acquire;
  try
    Result:=TGlobals<IPimlico>.Instance;
  finally
    critical.Release;
  end;
end;


initialization

critical:=TCriticalSection.Create;

createPimlico;

finalization

critical.Free;

end.

