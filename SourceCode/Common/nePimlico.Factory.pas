unit nePimlico.Factory;

interface

uses
  nePimlico.Types;

function Pimlico: IPimlico;

implementation

uses
  System.SyncObjs, System.SysUtils, nePimlico.Globals, nePimlico;

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


function Pimlico: IPimlico;
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

