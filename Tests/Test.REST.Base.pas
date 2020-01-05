unit Test.REST.Base;

interface
uses
  DUnitX.TestFramework, nePimlico.REST.Types;

type

  [TestFixture]
  TTestRESTBase = class(TObject)
  private
    fREST: IPimlicoRESTBase;
  public
    [SetupFixture]
    procedure setupFixture;

    [Test]
    procedure request;
  end;

implementation

uses
  nePimlico.REST.Base, nePimlico.mService.Types, nePimlico.mService.Base;


{ TTestRESTBase }

procedure TTestRESTBase.request;
var
  serv: ImService;
begin
  Assert.WillRaise(procedure
                   begin
                     fREST.request(nil, '');
                   end);

  serv:=TmServiceBase.Create;
  Assert.AreEqual('', fREST.request(serv, ''));
end;

procedure TTestRESTBase.setupFixture;
begin
  fREST:=TPimlicoRESTBase.Create;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestRESTBase);
end.
