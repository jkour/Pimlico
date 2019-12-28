program Demo.Basic;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  nePimlico.Factory,
  nePimlico.mService.Types,
  nePimlico.mService.Default,
  nePimlico,
  nePimlico.Types,
  nePimlico.Base.Types,
  flcUtils in '..\..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcUtils.pas',
  flcStrings in '..\..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcStrings.pas',
  flcStringPatternMatcher in '..\..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcStringPatternMatcher.pas',
  flcStdTypes in '..\..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcStdTypes.pas',
  flcASCII in '..\..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcASCII.pas',
  ArrayHelper in '..\..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\ArrayHelper.pas',
  Motif in '..\..\SourceCode\Third Party\Motif\SourceCode\Common\Motif.pas',
  Services.Login in 'Services.Login.pas';

var
  mSLogin: ImService;
  mSLogin2: ImService;
  mSLogout: ImService;

  answer: Integer;

begin
  try
    mSLogin:=TServiceLogin.Create;
    mSLogin2:=TmServiceDefault.Create;

    mSLogout:=TmServiceDefault.Create;

    Pimlico.add('role:user-management, cmd: login', mSLogin);
    Pimlico.add('role:user-management, cmd: logout', mSLogout);


    answer:=-1;
    while answer <> 0 do
    begin
      Writeln;
      Writeln('   1: Login, Async');
      Writeln('   2: Login, Sync');
      Writeln('----------------------');
      Writeln('0: Exit');
      Writeln;
      Write('Choice?');
      Readln(answer);

      case answer of
        1: Pimlico.act('role:user-management, cmd: login', 'username:john, pass:1234',
                        atAsync,
                        procedure (aStatus: TStatus)
                        begin
                          Writeln('Response: '+aStatus.Response);
                        end);
        2: Pimlico.act('role:user-management, cmd: login', 'username:john, pass:1234',
                        atSync,
                        procedure (aStatus: TStatus)
                        begin
                          Writeln('Response: '+aStatus.Response);
                        end);
        0: Exit;
      end;
    end;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

