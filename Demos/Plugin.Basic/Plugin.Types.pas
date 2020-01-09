unit Plugin.Types;

interface

uses
  System.Classes, nePimlico.mService.Base, nePimlico.mService.Types, FMX.Forms;

type
  IPluginBase = interface (ImService)
    ['{9F09ADB5-F174-48C9-A220-389324093342}']
  end;

  TPluginBase = class (TmServiceBase, IPluginBase)

  end;

  IPluginVisual = interface (IPluginBase)
    ['{14E1E5B1-B3CE-4FB6-9290-4E594397E500}']

  end;

  IPluginProjectOptions = interface (IPluginVisual)
    ['{99F4B80E-BBD6-4F36-BF21-492A7E9C9ADA}']
    function getHost: TForm;
    procedure setHost(const Value: TForm);

    property Host: TForm read getHost write setHost;
  end;

implementation

end.
