unit Plugin.Manager.Types;

interface

uses
  System.Generics.Collections, Plugin.Types;

type
  TPluginType = (ptInternal, ptExternal);
  TPluginProfile = class
    ID: string;
    Enabled: Boolean;
    Description: string;
    Pattern: string;
    &Type: TPluginType;
  end;

  IPluginManager = interface
    ['{911672EF-2758-4EA8-A78F-7A79BD3254FE}']
    function getAvailablePlugings: TObjectList<TPluginProfile>;

    procedure loadPlugins;
    procedure enablePlugin (const aID: string; const aStatus: boolean);
    procedure startPlugins (const aPattern: string);
    procedure stopPlugins (const aPattern: string);
    function find (const aPattern: string): TList<IPluginBase>;

    property AvailablePlugings: TObjectList<TPluginProfile> read
        getAvailablePlugings;
  end;

implementation

end.
