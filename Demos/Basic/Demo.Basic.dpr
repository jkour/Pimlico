program Demo.Basic;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  {$IFDEF EurekaLog}
  EMemLeaks,
  EResLeaks,
  EDebugExports,
  EDebugJCL,
  EFixSafeCallException,
  EMapWin32,
  EAppConsole,
  ExceptionLog7,
  {$ENDIF EurekaLog}
  System.SysUtils,
  nePimlico.Base.Types in '..\..\SourceCode\Common\nePimlico.Base.Types.pas',
  nePimlico.Factory in '..\..\SourceCode\Common\nePimlico.Factory.pas',
  nePimlico.Globals in '..\..\SourceCode\Common\nePimlico.Globals.pas',
  nePimlico in '..\..\SourceCode\Common\nePimlico.pas',
  nePimlico.Types in '..\..\SourceCode\Common\nePimlico.Types.pas',
  nePimlico.Brokers.Base in '..\..\SourceCode\Common\Brokers\nePimlico.Brokers.Base.pas',
  nePimlico.Brokers.Local in '..\..\SourceCode\Common\Brokers\nePimlico.Brokers.Local.pas',
  nePimlico.Brokers.Types in '..\..\SourceCode\Common\Brokers\nePimlico.Brokers.Types.pas',
  nePimlico.REST.Indy in '..\..\SourceCode\Common\REST\nePimlico.REST.Indy.pas',
  nePimlico.REST.Types in '..\..\SourceCode\Common\REST\nePimlico.REST.Types.pas',
  nePimlico.mService.Base in '..\..\SourceCode\Common\Services\nePimlico.mService.Base.pas',
  nePimlico.mService.Types in '..\..\SourceCode\Common\Services\nePimlico.mService.Types.pas',
  Motif in '..\..\SourceCode\Third Party\Motif\SourceCode\Common\Motif.pas',
  ArrayHelper in '..\..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\ArrayHelper.pas',
  flcASCII in '..\..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcASCII.pas',
  flcStdTypes in '..\..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcStdTypes.pas',
  flcStringPatternMatcher in '..\..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcStringPatternMatcher.pas',
  flcStrings in '..\..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcStrings.pas',
  flcUtils in '..\..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcUtils.pas',
  Services.Login in 'Services.Login.pas',
  nePimlico.mService.Remote.Profile in '..\..\SourceCode\Common\Services\nePimlico.mService.Remote.Profile.pas',
  nePimlico.mService.Remote in '..\..\SourceCode\Common\Services\nePimlico.mService.Remote.pas',
  nePimlico.mService.LoadConfiguration in '..\..\SourceCode\Common\Services\nePimlico.mService.LoadConfiguration.pas',
  nePimlico.Utils in '..\..\SourceCode\Common\nePimlico.Utils.pas',
  System.Generics.Collections,
  Quick.FileMonitor in '..\..\SourceCode\Third Party\Quick.FileMonitor.pas',
  nePimlico.REST.Base in '..\..\SourceCode\Common\REST\nePimlico.REST.Base.pas',
  nePimlico.REST.HTTP.Types in '..\..\SourceCode\Common\REST\nePimlico.REST.HTTP.Types.pas',
  nePimlico.REST.HTTP.Indy in '..\..\SourceCode\Common\REST\nePimlico.REST.HTTP.Indy.pas',
  Quick.Commons in '..\..\SourceCode\Third Party\Quick.Commons.pas',
  Quick.Threads in '..\..\SourceCode\Third Party\Quick.Threads.pas',
  Quick.Value in '..\..\SourceCode\Third Party\Quick.Value.pas',
  Quick.FaultControl in '..\..\SourceCode\Third Party\Quick.FaultControl.pas',
  nePimlico.mService.Autodiscovery in '..\..\SourceCode\Common\Services\nePimlico.mService.Autodiscovery.pas';

var
  mSLogin: ImService;
  mSLogin2: ImService;
  mSLogout: ImService;

  answer: Integer;

//  mRest1: ImService;

  list: TList<ImService>;

  mMessage: string;
begin
  {$IFNDEF EurekaLog}
  ReportMemoryLeaksOnShutdown:=True;
  {$ENDIF}

  try
    mSLogin:=TServiceLogin.Create;
    mSLogin2:=TmServiceBase.Create;

    mSLogout:=TmServiceBase.Create;

    Pimlico.add('role:user-management, cmd: login', mSLogin);
    Pimlico.add('role:user-management, cmd: logout', mSLogout);

//    mRest1:=TmServiceBase.Create;
//    mRest1.Address:='http://localhost:2001/pimlico/basic/';
//    mRest1.Port:='';
//    mRest1.SSL:=False;
//    mRest1.&Type:=stRemote;
//    mRest1.ProfileAddress:='http://localhost:2001/pimlico/basic/profile';
//
//    Pimlico.add('role: user-management, cmd: auth', mRest1);

    Pimlico.loadConfiguration('..\..\..\..\..\TempFiles\', true, 3000);


    Pimlico.startAll;

    answer:=-1;
    while answer <> 0 do
    begin
      Writeln;
      Writeln('   1: Local, Login, Async');
      Writeln('   2: Local, Login, Sync');
      Writeln('   3: REST #1 --- Sync');
      Writeln('   4: REST #1 --- ASync');
      Writeln('   5: REST #1 --- Profile');
      Writeln('   6: Autodiscovery');
      Writeln('   7: Overload Invoke');
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
        3: Pimlico.act('role: user-management, cmd: auth', '',
                        atSync,
                        procedure (aStatus: TStatus)
                        begin
                          Writeln('Response: '+aStatus.Response);
                        end);
        4: Pimlico.act('role: user-management, cmd: auth', '',
                        atSync,
                        procedure (aStatus: TStatus)
                        begin
                          Writeln('Response: '+aStatus.Response);
                        end);
        5: begin
             list:=Pimlico.find('role: user-management, cmd: auth');
             if list.Count > 0 then
             begin
               Writeln;
               Writeln('Profile of REST #1');
               Writeln('------------------');
               Writeln('ID: '+list[0].ID);
               Writeln('Description: '+list[0].Description);
               Writeln('Version: '+list[0].Version);
               if list[0].Enabled then
                Writeln('Enabled: true')
               else
                Writeln('Enabled: false');
               Writeln;
             end;
             list.Free;
           end;
        6: begin
             Pimlico.autodiscovery;
             if Assigned(Pimlico.unique('role: user-management, cmd: new')) then
               Writeln('Service ''role: user-management, cmd: new'' is registered')
             else
               Writeln('Service ''role: user-management, cmd: new'' NOT FOUND');
           end;
        7: begin
             pimlico.act('role: user-management, cmd: auth', 'ThisParams', atSync,
                          procedure (const mSelf: ImService; const aParameters: string)
                          begin
                            if mSelf.&Type = stRemote then
                              Writeln('Remote Service at '+mSelf.Address)
                            else
                              Writeln('Local Service');
                            Writeln('Params: '+aParameters);
                            mMessage:='Passed Message '+RandomString(10);
                            Writeln('Passed: '+mMessage);
                          end,
                          procedure (aStatus: TStatus)
                          begin
                            Writeln('Received Message: '+mMessage);
                          end);

           end;
        0: begin
             Exit;
           end;
      end;
    end;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.





