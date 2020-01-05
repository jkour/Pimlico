unit Test.Broker.Local;

interface
uses
  DUnitX.TestFramework, nePimlico.mService.Types, nePimlico.mService.Base,
  nePimlico.REST.Types, nePimlico.Brokers.Types;

type
  TServiceLocalMock = class (TmServiceBase)
  protected
    procedure invoke(const aParameters: string); override;
  end;

  TServiceRESTMock = class (TInterfacedObject, IPimlicoRESTBase)
  public
    function request(const aService: ImService;
      const aParameters: string): string;
  end;

  [TestFixture]
  TTestBrokerLocal = class(TObject)
  private
    fBroker: IPimlicoBroker;
  public
  [SetupFixture]
  procedure setupFixture;

  [Test]
  procedure localService;
  [Test]
  procedure RESTService;
  end;

implementation

uses
  nePimlico.Base.Types, nePimlico.Brokers.Base, nePimlico.Brokers.Local;


{ TServiceLocalMock }

procedure TServiceLocalMock.invoke(const aParameters: string);
begin
  inherited;
  fStatus.Response:='Local';
end;

{ TTestBrokerLocal }

procedure TTestBrokerLocal.localService;
var
  serv: ImService;
begin
  serv:=TServiceLocalMock.Create;
  serv.&Type:=stLocal;

  Assert.AreEqual('Local', fBroker.request(serv, ''));
end;

procedure TTestBrokerLocal.RESTService;
var
  serv: ImService;
  gateway: IPimlicoRESTBase;
begin
  serv:=TmServiceBase.Create;
  serv.&Type:=stRemote;

  gateway:=TServiceRESTMock.Create;

  fBroker.RESTGateway:=gateway;

  Assert.AreEqual('Remote', fBroker.request(serv, ''));

end;

procedure TTestBrokerLocal.setupFixture;
begin
  fBroker:=TPimlicoBrokerLocal.Create;
end;

{ TServiceRESTMock }

function TServiceRESTMock.request(const aService: ImService;
  const aParameters: string): string;
begin
  result:='Remote';
end;

initialization
  TDUnitX.RegisterTestFixture(TTestBrokerLocal);
end.
