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
  System.IOUtils, System.Classes;

var
  SparkleServer: THttpSysServer;

procedure StartServer;
var
  Module : TAnonymousServerModule;
begin
  if Assigned(SparkleServer) then
     Exit;

  SparkleServer := THttpSysServer.Create;

  Module := TAnonymousServerModule.Create(
    'http://+:2001/pimlico/autodiscovery',
    procedure(const C: THttpServerContext)
    begin
      C.Response.StatusCode := 200;
      C.Response.ContentType := 'text/html';
      C.Response.Close(TEncoding.UTF8.GetBytes('<h1>Autodiscovery Service</h1><br/>Implement your server response here.'));
    end
  );

  // Uncomment line below to enable CORS in the server
  //Module.AddMiddleware(TCorsMiddleware.Create);

  // Uncomment line below to allow compressed responses from server
  //Module.AddMiddleware(TCompressMiddleware.Create);

  SparkleServer.AddModule(Module);

  Module := TAnonymousServerModule.Create(
    'http://+:2001/pimlico/autodiscovery/updateExists',
    procedure(const C: THttpServerContext)
    begin
      C.Response.StatusCode := 200;
      C.Response.ContentType := 'text/html';

      if FileExists('..\..\pimlico-services.conf') then
        C.Response.Close(TEncoding.UTF8.GetBytes('true'))
      else
        C.Response.Close(TEncoding.UTF8.GetBytes('false'));
    end
  );

  SparkleServer.AddModule(Module);

  Module := TAnonymousServerModule.Create(
    'http://+:2001/pimlico/autodiscovery/update',
    procedure(const C: THttpServerContext)
    var
      strList: TStringList;
    begin
      C.Response.StatusCode := 200;
      C.Response.ContentType := 'text/html';

      if FileExists('..\..\pimlico-services.conf') then
      begin
        strList:=TStringList.Create;
        try
          strList.LoadFromFile('..\..\pimlico-services.conf');
          C.Response.Close(TEncoding.UTF8.GetBytes(strList.Text));
        finally
          strList.Free;
        end;
        strList.Free;
      end
      else
        C.Response.Close;
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
finalization
  StopServer;
end.
