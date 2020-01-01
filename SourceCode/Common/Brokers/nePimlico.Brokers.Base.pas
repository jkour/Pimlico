unit nePimlico.Brokers.Base;

interface

uses
  nePimlico.Brokers.Types, nePimlico.mService.Types, Motif, ArrayHelper,
  nePimlico.Types;

type
  TPimlicoBrokerBase = class (TInterfacedObject, IPimlicoBroker)
  protected
{$REGION 'Interface'}
    procedure request(const aService: ImService; const aParameters: string); virtual;
{$ENDREGION}
  public
  end;

implementation

procedure TPimlicoBrokerBase.request(const aService: ImService; const
    aParameters: string);
begin
  Assert(Assigned(aService), 'Service is nil in the broker');
end;

end.
