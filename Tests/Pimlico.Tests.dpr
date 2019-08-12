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
  Pimlico.Types in '..\SourceCode\Common\Pimlico.Types.pas',
  Pimlico.Globals in '..\SourceCode\Common\Pimlico.Globals.pas',
  Pimlico.Factory in '..\SourceCode\Common\Pimlico.Factory.pas',
  Pimlico.Core in '..\SourceCode\Common\Pimlico.Core.pas',
  Pimlico.Base.Types in '..\SourceCode\Common\Pimlico.Base.Types.pas',
  Pimlico.mService.Types in '..\SourceCode\Common\Services\Pimlico.mService.Types.pas',
  Pimlico.mService.Factory in '..\SourceCode\Common\Services\Pimlico.mService.Factory.pas',
  Pimlico.mService.Default in '..\SourceCode\Common\Services\Pimlico.mService.Default.pas',
  Pimlico.Node.Types in '..\SourceCode\Common\Nodes\Pimlico.Node.Types.pas',
  Pimlico.Node in '..\SourceCode\Common\Nodes\Pimlico.Node.pas',
  Pimlico.LoadBalancer.Types in '..\SourceCode\Common\LoadBalancers\Pimlico.LoadBalancer.Types.pas',
  Pimlico.LoadBalancer.Default in '..\SourceCode\Common\LoadBalancers\Pimlico.LoadBalancer.Default.pas';

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
