program Demo.Basic;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  {$IFDEF EurekaLog}
  EMemLeaks,
  EResLeaks,
  EDialogWinAPIEurekaLogDetailed,
  EDialogWinAPIStepsToReproduce,
  EDebugExports,
  EDebugJCL,
  EFixSafeCallException,
  EMapWin32,
  EAppConsole,
  ExceptionLog7,
  {$ENDIF EurekaLog}
  System.SysUtils,
  nePimlico.Factory,
  nePimlico.mService.Types,
  nePimlico.mService.Base,
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
    mSLogin2:=TmServiceBase.Create;

    mSLogout:=TmServiceBase.Create;

    Pimlico.add('role:user-management, cmd: login', mSLogin);
    Pimlico.add('role:user-management, cmd: logout', mSLogout);


    answer:=-1;
    while answer <> 0 do
    begin
      Writeln;
      Writeln('   1: Login, Async');
      Writeln('   2: Login, Sync');
      Writeln('   3: Start directly');
      Writeln('   4: Stop directly');
      Writeln('   5: Start All');
      Writeln('   6: action: start and check of invoke');
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
        3: begin
             pimlico.add('123', mSLogin).start;
             if Pimlico.service.Status.Status = ssStarted then
               Writeln('123 Started')
             else
               Writeln('123 Unable to Start');
           end;
        4: begin
             pimlico.add('456', mSLogin).stop;
             if Pimlico.service.Status.Status = ssStopped then
               Writeln('456 Stopped')
             else
               Writeln('456 Unable to Start');
           end;
        5: Pimlico.startAll;
        6: begin
             Pimlico.act('role:user-management, cmd: login', 'action: start', atSync,
                    procedure (aStatus: TStatus)
                    begin
                      if Services.Login.Tag = 'beginning' then
                        Writeln('passed')
                      else
                        Writeln('not passed');
                    end);
           end;
        0: Exit;
      end;
    end;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.



