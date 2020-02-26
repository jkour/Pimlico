unit Test.Utils;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTestUtils = class(TObject)
  public
    [Test]
    [TestCase ('Empty', ',Test:')]
    [TestCase ('Value-1', 'Value,Test,Test:Value')]
    [TestCase ('Value-2', 'C:\folder1\abc.pas,Test,Test:C:\folder1\abc.pas')]
    procedure extractValues (const aExpected: string; aKey: string; aParams: string);
  end;

implementation

uses
  nePimlico.Utils;

procedure TTestUtils.extractValues(const aExpected: string; aKey: string;
    aParams: string);
begin
  Assert.AreEqual(aExpected, extractValueFromParams(aParams, aKey));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestUtils);
end.
