program Pimlico.Tests;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}
uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  nePimlico.Utils in '..\SourceCode\Common\nePimlico.Utils.pas',
  nePimlico.Types in '..\SourceCode\Common\nePimlico.Types.pas',
  nePimlico in '..\SourceCode\Common\nePimlico.pas',
  nePimlico.Globals in '..\SourceCode\Common\nePimlico.Globals.pas',
  nePimlico.Factory in '..\SourceCode\Common\nePimlico.Factory.pas',
  nePimlico.Base.Types in '..\SourceCode\Common\nePimlico.Base.Types.pas',
  nePimlico.Brokers.Types in '..\SourceCode\Common\Brokers\nePimlico.Brokers.Types.pas',
  nePimlico.Brokers.Local in '..\SourceCode\Common\Brokers\nePimlico.Brokers.Local.pas',
  nePimlico.Brokers.Base in '..\SourceCode\Common\Brokers\nePimlico.Brokers.Base.pas',
  nePimlico.REST.Types in '..\SourceCode\Common\REST\nePimlico.REST.Types.pas',
  nePimlico.REST.Indy in '..\SourceCode\Common\REST\nePimlico.REST.Indy.pas',
  nePimlico.mService.Types in '..\SourceCode\Common\Services\nePimlico.mService.Types.pas',
  nePimlico.mService.Remote.Profile in '..\SourceCode\Common\Services\nePimlico.mService.Remote.Profile.pas',
  nePimlico.mService.Remote in '..\SourceCode\Common\Services\nePimlico.mService.Remote.pas',
  nePimlico.mService.LoadConfiguration in '..\SourceCode\Common\Services\nePimlico.mService.LoadConfiguration.pas',
  nePimlico.mService.Base in '..\SourceCode\Common\Services\nePimlico.mService.Base.pas',
  Quick.FileMonitor in '..\SourceCode\Third Party\Quick.FileMonitor.pas',
  Motif in '..\SourceCode\Third Party\Motif\SourceCode\Common\Motif.pas',
  flcUtils in '..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcUtils.pas',
  flcStrings in '..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcStrings.pas',
  flcStringPatternMatcher in '..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcStringPatternMatcher.pas',
  flcStdTypes in '..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcStdTypes.pas',
  flcASCII in '..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcASCII.pas',
  ArrayHelper in '..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\ArrayHelper.pas',
  Test.Utils in 'Test.Utils.pas',
  Test.Factory in 'Test.Factory.pas',
  Test.Broker.Base in 'Test.Broker.Base.pas',
  Test.Broker.Local in 'Test.Broker.Local.pas',
  nePimlico.REST.Base in '..\SourceCode\Common\REST\nePimlico.REST.Base.pas',
  Test.REST.Base in 'Test.REST.Base.pas',
  Test.REST.Indy in 'Test.REST.Indy.pas',
  Test.Pimlico in 'Test.Pimlico.pas',
  Test.Service.Base in 'Test.Service.Base.pas',
  nePimlico.REST.HTTP.Indy in '..\SourceCode\Common\REST\nePimlico.REST.HTTP.Indy.pas',
  nePimlico.REST.HTTP.Types in '..\SourceCode\Common\REST\nePimlico.REST.HTTP.Types.pas',
  Quick.Value in '..\SourceCode\Third Party\Quick.Value.pas',
  Quick.Threads in '..\SourceCode\Third Party\Quick.Threads.pas',
  Quick.FaultControl in '..\SourceCode\Third Party\Quick.FaultControl.pas',
  Quick.Commons in '..\SourceCode\Third Party\Quick.Commons.pas',
  nePimlico.mService.Autodiscovery in '..\SourceCode\Common\Services\nePimlico.mService.Autodiscovery.pas';

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //tell the runner how we will log things
    //Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; //When true, Assertions must be made during tests;

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.
