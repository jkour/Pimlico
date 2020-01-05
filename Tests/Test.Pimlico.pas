unit Test.Pimlico;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTestPimlico = class(TObject)
  private
    fTestFinished: Boolean;
  public
    [Test]
    procedure add;
    [Test]
    procedure actSync;
    [Test]
    procedure actASync;
    [Test]
    [TestCase ('Specific', 'domain: tests, scope: pimlico, test: remove-1#'+
                           'domain: tests, scope: pimlico, test: remove-1', '#')]
    [TestCase ('Wildcart', 'domain: tests, scope: pimlico, test: remove-2#'+
                           'domain: tests, scope: pimlico, test: *', '#')]
    procedure remove (const aAddTag, aRemoveTag: string);
    [Test]
    procedure removeAll;
    [Test]
    procedure findOne;
    [Test]
    procedure findMore;
    [Test]
    procedure unique;
    [Test]
    procedure start;
    [Test]
    procedure stop;
    [Test]
    procedure startAll;
    [Test]
    procedure stopAll;
    [Test]
    procedure excludeFromStarting;
    [Test]
    procedure registerBroker;
    [Test]
    procedure loadConfiguration;
  end;

implementation

uses
  nePimlico.mService.Types, nePimlico.mService.Base, nePimlico.Factory,
  nePimlico.Types, nePimlico.Base.Types,
  System.Generics.Collections, Aurelius.Criteria.Projections, nePimlico.Brokers.Local, System.IOUtils, System.SysUtils;


{ TTestPimlico }

procedure TTestPimlico.actASync;
var
  serv: ImService;
begin
  fTestFinished:=False;
  serv:=TmServiceBase.Create;
  pimlico.add('domain: tests, scope: pimlico, test: actASync', serv);
  pimlico.act('domain: tests, scope: pimlico, test: actASync', '', atASync,
           procedure(aStatus: TStatus)
           begin
             fTestFinished:=true;
           end);
  while not fTestFinished do
    ;
  Assert.AreEqual(1, 1);
  fTestFinished:=False;
  pimlico.remove('domain: tests, scope: pimlico, test: actASync');
end;

procedure TTestPimlico.actSync;
var
  serv: ImService;
  value: integer;
begin
  value:=0;
  serv:=TmServiceBase.Create;
  pimlico.add('domain: tests, scope: pimlico, test: actSync', serv);
  pimlico.act('domain: tests, scope: pimlico, test: actSync', '', atSync,
           procedure(aStatus: TStatus)
           begin
             value:=1;
           end);
  Assert.AreEqual(1, value);
  pimlico.remove('domain: tests, scope: pimlico, test: actSync');
end;

procedure TTestPimlico.add;
var
  serv: ImService;
begin
  serv:=TmServiceBase.Create;
  Assert.IsNotNull(pimlico.add('domain: tests, scope: pimlico, test: add', serv));
  Assert.AreEqual(serv, pimlico.unique('domain: tests, scope: pimlico, test: add'));
  Pimlico.remove('domain: tests, scope: pimlico, test: add');
end;

procedure TTestPimlico.excludeFromStarting;
var
  serv1: ImService;
  serv2: ImService;
  serv3: ImService;
begin
  serv1:=TmServiceBase.Create;
  serv2:=TmServiceBase.Create;
  serv3:=TmServiceBase.Create;

  pimlico.add('domain: tests, scope: pimlico, test: exclude-from, serv:1', serv1)
         .add('domain: tests, scope: pimlico, test: exclude-from, serv:2', serv2)
            .excludeFromStarting
         .add('domain: tests, scope: pimlico, test: exclude-from, serv:3', serv3)
         .startAll;

  Assert.AreEqual(ssStarted, serv1.Status.Status);
  Assert.AreEqual(ssIdle, serv2.Status.Status);
  Assert.AreEqual(ssStarted, serv1.Status.Status);

  pimlico.remove('domain: tests, scope: pimlico, test: exclude-from, serv:*');
end;

procedure TTestPimlico.findMore;
var
  serv1: ImService;
  serv2: ImService;
  serv3: ImService;
  list: TList<ImService>;
begin
  serv1:=TmServiceBase.Create;
  serv2:=TmServiceBase.Create;
  serv3:=TmServiceBase.Create;

  pimlico.add('domain: tests, scope: pimlico, test: find-more, serv:1', serv1);
  pimlico.add('domain: tests, scope: pimlico, test: find-more, serv:2', serv2);
  pimlico.add('domain: tests, scope: pimlico, test: find-more-plus, serv:1', serv3);

  list:=pimlico.find('domain: tests, scope: pimlico, test: find-more, serv:*');
  Assert.AreEqual(2, list.count);
  Assert.AreEqual(serv1, list[0]);
  Assert.AreEqual(serv2, list[1]);

  list.free;

  list:=pimlico.find('domain: tests, scope: pimlico, test: *');
  Assert.AreEqual(3, list.count);
  Assert.AreEqual(serv1, list[0]);
  Assert.AreEqual(serv2, list[1]);
  Assert.AreEqual(serv3, list[2]);

  list.free;

  pimlico.remove('domain: tests, scope: pimlico, test: find-more, serv:1');
  pimlico.remove('domain: tests, scope: pimlico, test: find-more, serv:2');
  pimlico.remove('domain: tests, scope: pimlico, test: find-more-plus, serv:1');
end;

procedure TTestPimlico.findOne;
var
  serv: ImService;
  list: TList<ImService>;
begin
  serv:=TmServiceBase.Create;
  pimlico.add('domain: tests, scope: pimlico, test: find-one', serv);
  list:=pimlico.find('domain: tests, scope: pimlico, test: find-one');
  Assert.AreEqual(1, list.count);
  Assert.AreEqual(serv, list[0]);
  list.free;
  pimlico.remove('domain: tests, scope: pimlico, test: find-one');
end;

procedure TTestPimlico.loadConfiguration;
var
  list: TList<ImService>;
  serv: ImService;
  existing: Integer;
begin
  list:=pimlico.find('*');
  existing:=list.Count;
  list.Free;

  if not FileExists('..\..\..\..\Tests\pimlico-services.conf') then
    raise Exception.Create('configuration file not found');

  Pimlico.loadConfiguration('..\..\..\..\Tests', false);

  list:=pimlico.find('*');
  // Number of loaded services
  Assert.AreEqual(3 + existing, list.Count);
  list.Free;

  // Service with all info
  serv:=pimlico.unique('role: test, scope: pimlico, test: load, serv: remote-1');
  Assert.IsNotNull(serv);
  with serv do
  begin
    Assert.AreEqual(stRemote, &Type);
    Assert.AreEqual('http://www.google.com', Address);
    Assert.AreEqual(80, Port.ToInteger);
    Assert.IsTrue(Enabled);
    Assert.IsTrue(Authenticate);
  end;

  // Service without the port
  serv:=pimlico.unique('role: test, scope: pimlico, test: load, serv: remote-2');
  Assert.IsNotNull(serv);
  with serv do
  begin
    Assert.AreEqual(stRemote, &Type);
    Assert.AreEqual('http://www.google.com', Address);
    Assert.AreEqual(80, Port.ToInteger);
    Assert.IsTrue(Enabled);
    Assert.IsTrue(Authenticate);
  end;

  // Service without authenticate
  serv:=pimlico.unique('role: test, scope: pimlico, test: load, serv: remote-3');
  Assert.IsNotNull(serv);
  with serv do
  begin
    Assert.AreEqual(stRemote, &Type);
    Assert.AreEqual('http://www.google.com', Address);
    Assert.AreEqual(80, Port.ToInteger);
    Assert.IsTrue(Enabled);
    Assert.IsFalse(Authenticate);
  end;

end;

procedure TTestPimlico.registerBroker;
begin
  Assert.WillRaise(procedure
                   begin
                     pimlico.registerBroker(nil);
                   end);
  Assert.IsNotNull(Pimlico.registerBroker(TPimlicoBrokerLocal.Create));
end;

procedure TTestPimlico.remove(const aAddTag, aRemoveTag: string);
var
  serv1: ImService;
  findSerV: ImService;
begin
  serv1:=TmServiceBase.Create;

  pimlico.add(aAddTag, serv1);
  Pimlico.remove(aRemoveTag);
  findSerV:=pimlico.unique(aAddTag);
  Assert.IsNull(findSerV);
end;

procedure TTestPimlico.removeAll;
var
  loadService: ImService;
  list: TList<ImService>;
  serv1: ImService;
  serv2: ImService;
begin
  serv1:=TmServiceBase.Create;
  serv2:=TmServiceBase.Create;

  // *
  // We need to preserve this service for other tests
  loadService:=pimlico.unique(PIMLICO_SERVICE_LOAD_CONFIGURATION);

  pimlico.add('domain: tests, scope: pimlico, test: remove-3', serv1);
  pimlico.add('domain: tests, scope: pimlico, test: remove-4', serv2);
  Pimlico.remove('*');

  list:=pimlico.find('*');
  Assert.AreEqual(0, list.Count);
  list.Free;

  pimlico.add(PIMLICO_SERVICE_LOAD_CONFIGURATION, loadService);
end;

procedure TTestPimlico.start;
var
  serv1: ImService;
begin
  serv1:=TmServiceBase.Create;
  Assert.AreEqual(ssIdle, serv1.Status.Status);

  pimlico.add('domain: tests, scope: pimlico, test: start', serv1);
  Assert.IsNotNull(pimlico.start);
  Assert.AreEqual(ssStarted, serv1.Status.Status);
  pimlico.remove('domain: tests, scope: pimlico, test: start');
end;

procedure TTestPimlico.startAll;
var
  serv1: ImService;
  serv2: ImService;
  serv3: ImService;
begin
  serv1:=TmServiceBase.Create;
  serv2:=TmServiceBase.Create;
  serv3:=TmServiceBase.Create;

  pimlico.add('domain: tests, scope: pimlico, test: startAll, serv:1', serv1);
  pimlico.add('domain: tests, scope: pimlico, test: startAll, serv:2', serv2);
  pimlico.add('domain: tests, scope: pimlico, test: startAll, serv:3', serv3);

  Pimlico.startAll;

  Assert.AreEqual(ssStarted, serv1.Status.Status);
  Assert.AreEqual(ssStarted, serv2.Status.Status);
  Assert.AreEqual(ssStarted, serv3.Status.Status);

  pimlico.remove('domain: tests, scope: pimlico, test: startAll, serv:1');
  pimlico.remove('domain: tests, scope: pimlico, test: startAll, serv:2');
  pimlico.remove('domain: tests, scope: pimlico, test: startAll, serv:3');
end;

procedure TTestPimlico.stop;
var
  serv1: ImService;
begin
  serv1:=TmServiceBase.Create;
  Assert.AreEqual(ssIdle, serv1.Status.Status);
  pimlico.add('domain: tests, scope: pimlico, test: stop', serv1);
  pimlico.start;
  Assert.IsNotNull(pimlico.stop);
  Assert.AreEqual(ssStopped, serv1.Status.Status);
  pimlico.remove('domain: tests, scope: pimlico, test: stop');
end;

procedure TTestPimlico.stopAll;
var
  serv1: ImService;
  serv2: ImService;
  serv3: ImService;
begin
  serv1:=TmServiceBase.Create;
  serv2:=TmServiceBase.Create;
  serv3:=TmServiceBase.Create;

  pimlico.add('domain: tests, scope: pimlico, test: stopAll, serv:1', serv1);
  pimlico.add('domain: tests, scope: pimlico, test: stopAll, serv:2', serv2);
  pimlico.add('domain: tests, scope: pimlico, test: stopAll, serv:3', serv3);

  pimlico.startAll;
  Pimlico.stopAll;

  Assert.AreEqual(ssStopped, serv1.Status.Status);
  Assert.AreEqual(ssStopped, serv2.Status.Status);
  Assert.AreEqual(ssStopped, serv3.Status.Status);

  pimlico.remove('domain: tests, scope: pimlico, test: stopAll, serv:1');
  pimlico.remove('domain: tests, scope: pimlico, test: stopAll, serv:2');
  pimlico.remove('domain: tests, scope: pimlico, test: stopAll, serv:3');
end;

procedure TTestPimlico.unique;
var
  serv1: ImService;
  serv2: ImService;
  serv3: ImService;
  findServ: ImService;
begin
  serv1:=TmServiceBase.Create;
  serv2:=TmServiceBase.Create;
  serv3:=TmServiceBase.Create;

  pimlico.add('domain: tests, scope: pimlico, test: unique, serv:1', serv1);
  pimlico.add('domain: tests, scope: pimlico, test: unique, serv:2', serv2);
  pimlico.add('domain: tests, scope: pimlico, test: unique, serv:3', serv3);

  findServ:=pimlico.unique('domain: tests, scope: pimlico, test: unique, serv:2');
  Assert.IsNotNull(findServ);
  Assert.AreEqual(serv2, findServ);

  Assert.WillRaise(procedure
                   begin
     findServ:=pimlico.unique('domain: tests, scope: pimlico, test: unique, serv:*');
                   end);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestPimlico);
end.
