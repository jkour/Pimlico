unit nePimlico.Brokers.Local;

interface

uses
  nePimlico.Brokers.Base, nePimlico.mService.Types;

type
  TPimlicoBrokerLocal = class (TPimlicoBrokerBase)
  protected
    function request(const aService: ImService; const aParameters: string): string;
      override;
  end;

implementation

{ TPimlicoBrokerLocal }

function TPimlicoBrokerLocal.request(const aService: ImService; const
    aParameters: string): string;
begin
  inherited;
  if aService.&Type = stLocal then
  begin
    aService.invoke(aParameters);
    Result:=aService.Status.Response;
  end
  else
  begin
    result:=RESTGateway.request(aService, aParameters);
  end;
end;

end.
