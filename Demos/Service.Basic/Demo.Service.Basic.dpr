program Demo.Service.Basic;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Server in 'Server.pas',
  nePimlico.mService.Remote.Profile in '..\..\SourceCode\Common\Services\nePimlico.mService.Remote.Profile.pas';

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
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
