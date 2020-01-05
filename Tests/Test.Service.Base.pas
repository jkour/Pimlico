unit Test.Service.Base;

interface
uses
  DUnitX.TestFramework, nePimlico.mService.Base;

type
  TServiceLocalMock = class (TmServiceBase)

  end;

  {TODO -oOwner -cGeneral : Add test for Remote Service -- need to find howto make a server in one line}

  [TestFixture]
  TTestServiceBase = class(TObject)
  public
  [Test]
    procedure local;
  end;

implementation

uses
  nePimlico.mService.Types;


{ TTestServiceBase }

procedure TTestServiceBase.local;
var
  serv: ImService;
begin
  serv:=TServiceLocalMock.Create;
  Assert.AreEqual(stLocal, serv.&Type);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestServiceBase);
end.
