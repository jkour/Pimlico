unit Test.Service.Base;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTestServiceBase = class(TObject) 
  public
  end;

implementation


initialization
  TDUnitX.RegisterTestFixture(TTestServiceBase);
end.
