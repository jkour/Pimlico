unit Test.Broker.Base;

interface
uses
  DUnitX.TestFramework, nePimlico.REST.Types, nePimlico.mService.Types, nePimlico.Brokers.Types;

type
  TRESTGatewayMock =   class (TInterfacedObject, IPimlicoRESTBase)
  public
    function request(const aService: ImService;
      const aParameters: string): string;
  end;

  [TestFixture]
  TTestBrokerBase = class(TObject)
  private
    fBroker: IPimlicoBroker;
  public
  [SetupFixture]
  procedure setupFixture;

  [Test]
  procedure RESTGateway;
  [Test]
  procedure request;
  end;

implementation

uses
  nePimlico.Brokers.Base, nePimlico.REST.Indy, nePimlico.mService.Base;



{ TTestBrokerBase }

procedure TTestBrokerBase.request;

begin
  Assert.WillRaise(procedure
                      begin
                        fBroker.request(nil,'');
                      end);
  Assert.AreEqual('', fBroker.request(TmServiceBase.Create, ''));
end;

procedure TTestBrokerBase.RESTGateway;
var
  gateway: IPimlicoRESTBase;
  indy: IPimlicoRESTBase;
begin
  fBroker.RESTGateway:=nil;
  Assert.IsNotNull(fBroker.RESTGateway);
  indy:= TPimlicoRESTIndy.Create;
  if fBroker.RESTGateway is TPimlicoRESTIndy then
    Assert.IsTrue(1=1, 'default');

  gateway:=TRESTGatewayMock.Create;
  fBroker.RESTGateway:=gateway;
  Assert.IsNotNull(fBroker.RESTGateway);
  Assert.AreEqual(gateway, fBroker.RESTGateway, 'mock');
end;

procedure TTestBrokerBase.setupFixture;
begin
  fBroker:=TPimlicoBrokerBase.Create;
end;

{ TRESTGatewayMock }

function TRESTGatewayMock.request(const aService: ImService;
  const aParameters: string): string;
begin
  // Mock
end;

initialization
  TDUnitX.RegisterTestFixture(TTestBrokerBase);
end.
