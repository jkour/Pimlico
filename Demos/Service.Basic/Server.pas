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
  System.IOUtils, nePimlico.mService.Remote.Profile, REST.Json,
  Bcl.Jose.Core.JWT, Bcl.Jose.Core.Builder,
  Sparkle.HttpServer.Request;

var
  SparkleServer: THttpSysServer;
  token: string;
  profile: TmServiceRemoteProfile;

procedure createProfile;
var
  guid: TGUID;
begin
  profile:=TmServiceRemoteProfile.Create;
  CreateGUID(guid);
  profile.ID:=guid.ToString;
  profile.Description:='Demo Basic Service';
  profile.Version:='10.32.33';
end;

procedure StartServer;
var
  Module : TAnonymousServerModule;
  header: string;
  id: string;
begin
  if Assigned(SparkleServer) then
     Exit;

  SparkleServer := THttpSysServer.Create;

  Module := TAnonymousServerModule.Create(
    'http://+:2001/pimlico/basic',
    procedure(const C: THttpServerContext)
    begin
      if C.Request.Headers.GetIfExists('Authorization', header) then
      begin
        if not header.Contains(token) then
        begin
          C.Response.StatusCode:=401;
          C.Response.ContentType := 'text/html';
          C.Response.Close(TEncoding.UTF8.GetBytes('<h1>Unathorised Request</h1>'));
        end
        else
        begin
          C.Response.StatusCode := 200;
          C.Response.ContentType := 'text/html';
          C.Response.Close(TEncoding.UTF8.GetBytes('<h1>Hello from Basic Remote Service</h1>'));
        end;
      end
      else
      begin
        C.Response.StatusCode:=401;
        C.Response.ContentType := 'text/html';
        C.Response.Close(TEncoding.UTF8.GetBytes('<h1>Unathorised Request</h1>'));
      end;
    end
  );

  // Uncomment line below to enable CORS in the server
  //Module.AddMiddleware(TCorsMiddleware.Create);

  // Uncomment line below to allow compressed responses from server
  //Module.AddMiddleware(TCompressMiddleware.Create);

  SparkleServer.AddModule(Module);

  Module := TAnonymousServerModule.Create(
    'http://+:2001/pimlico/basic/profile',
    procedure(const C: THttpServerContext)
    begin
      C.Response.StatusCode := 200;
      C.Response.ContentType := 'application/json';
      C.Response.Close(TEncoding.UTF8.GetBytes(TJSON.ObjectToJsonString(profile)));
    end
  );

  SparkleServer.AddModule(Module);

  Module := TAnonymousServerModule.Create(
    'http://+:2001/pimlico/basic/authenticate',
    procedure(const C: THttpServerContext)
    var
      JWT: TJWT;
    begin
      C.Response.StatusCode := 200;
      C.Response.ContentType := 'text';

      JWT:=TJWT.Create(TJWTClaims);
      try
        JWT.Claims.SetClaimOfType<string>('id', profile.ID);
        JWT.Claims.Issuer:=profile.Description;

        token:= TJOSE.SHA256CompactToken('id', JWT);
        C.Response.Close(TEncoding.UTF8.GetBytes(token));
      finally
        JWT.Free;
      end;
    end
  );

  SparkleServer.AddModule(Module);

  SparkleServer.Start;
end;

procedure StopServer;
begin
  FreeAndNil(SparkleServer);
end;

initialization

  SparkleServer := nil;
  createProfile;

finalization

  profile.Free;
  StopServer;

end.
