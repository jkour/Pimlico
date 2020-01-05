unit nePimlico.REST.Base;

interface

uses
  nePimlico.REST.Types, nePimlico.mService.Types;

type
  TPimlicoRESTBase = class (TInterfacedObject, IPimlicoRESTBase)
  public
{$REGION 'Interface'}
    function request(const aService: ImService; const aParameters: string): string; virtual;
{$ENDREGION}
  end;

implementation

{ TPimlicoRESTBase }

function TPimlicoRESTBase.request(const aService: ImService;
  const aParameters: string): string;
begin
  Assert(Assigned(aService), 'Service is not assigned');
  result:='';
end;

end.
