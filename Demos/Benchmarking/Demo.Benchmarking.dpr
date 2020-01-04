program Demo.Benchmarking;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  nePimlico.Brokers.Types in '..\..\SourceCode\Common\Brokers\nePimlico.Brokers.Types.pas',
  nePimlico.Brokers.Local in '..\..\SourceCode\Common\Brokers\nePimlico.Brokers.Local.pas',
  nePimlico.Brokers.Base in '..\..\SourceCode\Common\Brokers\nePimlico.Brokers.Base.pas',
  nePimlico.REST.Types in '..\..\SourceCode\Common\REST\nePimlico.REST.Types.pas',
  nePimlico.REST.Indy in '..\..\SourceCode\Common\REST\nePimlico.REST.Indy.pas',
  nePimlico.mService.Types in '..\..\SourceCode\Common\Services\nePimlico.mService.Types.pas',
  nePimlico.mService.Remote.Profile in '..\..\SourceCode\Common\Services\nePimlico.mService.Remote.Profile.pas',
  nePimlico.mService.Remote in '..\..\SourceCode\Common\Services\nePimlico.mService.Remote.pas',
  nePimlico.mService.Pimlico.LoadConfiguration in '..\..\SourceCode\Common\Services\nePimlico.mService.Pimlico.LoadConfiguration.pas',
  nePimlico.mService.Base in '..\..\SourceCode\Common\Services\nePimlico.mService.Base.pas',
  nePimlico.Utils in '..\..\SourceCode\Common\nePimlico.Utils.pas',
  nePimlico.Types in '..\..\SourceCode\Common\nePimlico.Types.pas',
  nePimlico in '..\..\SourceCode\Common\nePimlico.pas',
  nePimlico.Globals in '..\..\SourceCode\Common\nePimlico.Globals.pas',
  nePimlico.Factory in '..\..\SourceCode\Common\nePimlico.Factory.pas',
  nePimlico.Base.Types in '..\..\SourceCode\Common\nePimlico.Base.Types.pas',
  Motif in '..\..\SourceCode\Third Party\Motif\SourceCode\Common\Motif.pas',
  flcUtils in '..\..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcUtils.pas',
  flcStrings in '..\..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcStrings.pas',
  flcStringPatternMatcher in '..\..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcStringPatternMatcher.pas',
  flcStdTypes in '..\..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcStdTypes.pas',
  flcASCII in '..\..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\flcASCII.pas',
  ArrayHelper in '..\..\SourceCode\Third Party\Motif\SourceCode\ThirdParty\ArrayHelper.pas',
  Quick.FileMonitor in '..\..\SourceCode\Third Party\Quick.FileMonitor.pas',
  Service.Mock in 'Service.Mock.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
