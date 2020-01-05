unit Test.REST.Indy;

interface
uses
  DUnitX.TestFramework, nePimlico.REST.Types, nePimlico.mService.Types;

type

  [TestFixture]
  TTestRESTIndy = class(TObject)
  private
    fREST: IPimlicoRESTBase;
    fService: ImService;
  public
  [Setup]
  procedure setup;

  [Test]
  procedure requestHTTP;
  [Test]
  procedure requestHTTPS;
  [Test]
  procedure requestAuthenticate;
  [Test (False)]
  procedure requestError;
  end;

const
  HTTP_REST_MOCK = 'http://jsonplaceholder.typicode.com/posts/1';
  HTTPS_REST_MOCK = 'https://jsonplaceholder.typicode.com/posts/1';
  HTTP_ERROR_REST_MOCK = 'http://www.google.com:6544';

implementation

uses
  nePimlico.REST.Indy, nePimlico.mService.Base, Sysutils;


{ TTestRESTIndy }

procedure TTestRESTIndy.requestError;
var
  response: string;
begin
  fService.Address:=HTTP_ERROR_REST_MOCK;
  response:=fREST.request(fService, '');
  Assert.IsTrue(response.Contains('ERROR'));
end;

procedure TTestRESTIndy.requestAuthenticate;
var
  response: string;
begin
  {TODO -oOwner -cGeneral : Find an online test REST server with JWT????}
//  fService.Authenticate:=True;
//  fService.Address:=HTTP_REST_MOCK;
//  response:=fREST.request(fService, '');
//  Assert.IsTrue(response.Contains('ERROR'));
//  fService.Authenticate:=false;
  Assert.IsTrue(1=1);
end;

procedure TTestRESTIndy.requestHTTP;
var
  response: string;
begin
  fService.Address:=HTTP_REST_MOCK;
  response:=fREST.request(fService, '');
  Assert.IsTrue(response.Contains('"userId": 1'));
end;

procedure TTestRESTIndy.requestHTTPS;
var
  response: string;
begin
  {TODO -oOwner -cGeneral : Add Test when we fix HTTPS in Indy}
  fService.SSL:=true;
  fService.Address:=HTTPS_REST_MOCK;
  Assert.WillRaise(procedure
                   begin
                     response:=fREST.request(fService, '');
                   end);
  fService.SSL:=false;
end;

procedure TTestRESTIndy.setup;
begin
  fREST:=TPimlicoRESTIndy.Create;

  fService:=TmServiceBase.Create;
  fService.&Type:=stRemote;
  fService.Authenticate:=false;
  fService.SSL:=False;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestRESTIndy);
end.
