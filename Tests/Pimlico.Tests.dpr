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
  Test.mNode in 'Test.mNode.pas',
  nePimlico.Types in '..\SourceCode\Common\nePimlico.Types.pas',
  nePimlico.Globals in '..\SourceCode\Common\nePimlico.Globals.pas',
  nePimlico.Factory in '..\SourceCode\Common\nePimlico.Factory.pas',
  nePimlico in '..\SourceCode\Common\nePimlico.pas',
  nePimlico.Base.Types in '..\SourceCode\Common\nePimlico.Base.Types.pas',
  nePimlico.mService.Types in '..\SourceCode\Common\Services\nePimlico.mService.Types.pas',
  Pimlico.mService.Factory in '..\SourceCode\Common\Services\Pimlico.mService.Factory.pas',
  nePimlico.mService.Default in '..\SourceCode\Common\Services\nePimlico.mService.Default.pas',
  nePimlico.Node.Types in '..\SourceCode\Common\Nodes\nePimlico.Node.Types.pas',
  nePimlico.Node in '..\SourceCode\Common\Nodes\nePimlico.Node.pas',
  nePimlico.LoadBalancer.Types in '..\SourceCode\Common\LoadBalancers\nePimlico.LoadBalancer.Types.pas',
  nePimlico.LoadBalancer.Default in '..\SourceCode\Common\LoadBalancers\nePimlico.LoadBalancer.Default.pas';

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
