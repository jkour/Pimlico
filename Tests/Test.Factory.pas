unit Test.Factory;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTestFactory = class(TObject)
  public
    [Test]
    procedure createPimlico;
  end;

implementation

uses
  nePimlico.Factory;


{ TTestFactory }

procedure TTestFactory.createPimlico;
begin
  Assert.IsNotNull(Pimlico);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestFactory);
end.
