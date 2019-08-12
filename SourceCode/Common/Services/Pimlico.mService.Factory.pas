unit Pimlico.mService.Factory;

interface

uses
  Pimlico.mService.Types;

type
  TmServiceFactory = class
  public
    class function createMService (const aType: TServiceType): ImService;
  end;

implementation

uses
  Pimlico.mService.Default;

{ TmServiceFactory }

class function TmServiceFactory.createMService(
  const aType: TServiceType): ImService;
begin
  case aType of
    stLocal: Result:=TmServiceDefault.Create;
    stHTTP: ;
  end;
end;

end.
