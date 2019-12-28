unit Test.mNode;

interface
uses
  DUnitX.TestFramework, Pimlico.Node.Types,
  Delphi.Mocks, Pimlico.LoadBalancer.Types;

type

  [TestFixture]
  TTestmNode = class(TObject)
  private
    fModel: ImNode;
    fMockLoadBalancer: TMock<ILoadBalancer>;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure addNil;
    [Test]
    procedure add;
  end;

implementation

uses
  Pimlico.Node;

procedure TTestmNode.add;
begin
  fModel:=TmNode.Create;
  fMockLoadBalancer:=TMock<ILoadBalancer>.Create;
  fModel.add(fMockLoadBalancer);
end;

procedure TTestmNode.addNil;
begin
  fModel:=TmNode.Create;
  Assert.WillRaise(procedure
                   begin
                     fModel.add(nil);
                   end);
end;

procedure TTestmNode.Setup;
begin

end;

procedure TTestmNode.TearDown;
begin
end;


initialization
  TDUnitX.RegisterTestFixture(TTestmNode);
end.
