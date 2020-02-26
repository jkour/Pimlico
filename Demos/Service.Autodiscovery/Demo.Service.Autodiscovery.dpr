program Demo.Service.Autodiscovery;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Server in 'Server.pas';

var
  InputText : string;

begin
  try
    Write('Starting server... ');
    StartServer;
    WriteLn('done.');
    WriteLn('');

    Write('Press ENTER to stop the server and quit.');
    ReadLn(InputText);

    WriteLn('');
    Write('Stopping server... ');
    StopServer;
    WriteLn('done.');
  except
    on E: Exception do
      begin
        Writeln(E.ClassName, ': ', E.Message);
        writeln;
      end;
  end;
end.
