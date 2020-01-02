unit Server;

interface

uses
  System.SysUtils,
  Sparkle.Middleware.Cors,
  Sparkle.Middleware.Compress,
  Sparkle.HttpSys.Server,
  Sparkle.HttpServer.Context,
  Sparkle.HttpServer.Module;

procedure StartServer;
procedure StopServer;

implementation

uses
  System.IOUtils, nePimlico.mService.Remote.Profile, REST.Json;

var
  SparkleServer: THttpSysServer;

procedure StartServer;
var
  Module : TAnonymousServerModule;
  profile: TmServiceRemoteProfile;
  json: string;
begin
  if Assigned(SparkleServer) then
     Exit;

  SparkleServer := THttpSysServer.Create;

  Module := TAnonymousServerModule.Create(
    'http://+:2001/pimlico/basic',
    procedure(const C: THttpServerContext)
    begin
      C.Response.StatusCode := 200;
      C.Response.ContentType := 'text/html';
      C.Response.Close(TEncoding.UTF8.GetBytes('<h1>Hello, World!</h1><br/>Implement your server response here.'));
    end
  );

  // Uncomment line below to enable CORS in the server
  //Module.AddMiddleware(TCorsMiddleware.Create);

  // Uncomment line below to allow compressed responses from server
  //Module.AddMiddleware(TCompressMiddleware.Create);

  SparkleServer.AddModule(Module);

  profile:=TmServiceRemoteProfile.Create;
  profile.ID:='dfasdsa899dsghlksdfghsd907';
  profile.Description:='Demo Basic Service';
  profile.Version:='10.32.33';
  json:=TJSON.ObjectToJsonString(profile);
  profile.Free;

  Module := TAnonymousServerModule.Create(
    'http://+:2001/pimlico/basic/profile',
    procedure(const C: THttpServerContext)
    begin
      C.Response.StatusCode := 200;
      C.Response.ContentType := 'text/html';
      C.Response.Close(TEncoding.UTF8.GetBytes(json));
    end
  );


  // Uncomment line below to enable CORS in the server
  //Module.AddMiddleware(TCorsMiddleware.Create);

  // Uncomment line below to allow compressed responses from server
  //Module.AddMiddleware(TCompressMiddleware.Create);

  SparkleServer.AddModule(Module);

  SparkleServer.Start;
end;

procedure StopServer;
begin
  FreeAndNil(SparkleServer);
end;

initialization
  SparkleServer := nil;
finalization
  StopServer;
end.
