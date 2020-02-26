unit nePimlico.Types;

interface

uses
  nePimlico.Base.Types, System.SysUtils, nePimlico.mService.Types,
  System.Generics.Collections, nePimlico.Brokers.Types;

const
  PIMLICO_CONFIG_FILE = 'pimlico-services.conf';
  PIMLICO_PROFILE_ENDPOINT = '/profile';

  PIMLICO_AUTHENTICATE_ENDPOINT = '/authenticate';

  SCOPE_LOCAL = 'Local';
  SCOPE_REMOTE = 'Remote';

  SERVICE_ENABLED = 'Enabled';
  SERVICE_DISABLED = 'Disabled';   //FI:O803

  POLL_INTERVAL = 1000;

  PIMLICO_SERVICE_LOAD_CONFIGURATION = 'role: pimlico, cmd: load-configuration';

  PIMLICO_AUTODISCOVERY_CONFIG_FILE = '%s.conf';
  PIMLICO_SERVICE_AUTODISCOVERY_UPDATE_EXISTS = 'role: autodiscovery, cmd: update-exists';
  PIMLICO_SERVICE_AUTODISCOVERY_UPDATE = 'role: autodiscovery, cmd: update';
  PIMLICO_SERVICE_AUTODISCOVERY = 'role: pimlico, cmd: autodiscovery';


  PIMLICO_AUTODISCOVERY_UPDATE_EXISTS_ENDPOINT = '/updateExists?=%s';
  PIMLICO_AUTODISCOVERY_UPDATE_ENDPOINT = '/update?=%s';

type
  TActionType = (atSync, atAsync);
  TCallBackProc = reference to procedure (aStatus: TStatus);
  IPimlico = interface (IBaseInterface)
    ['{B9DCACE0-2B07-48AE-BD77-2C30C14A366E}']
    function add(const aPattern: string; const aService: ImService): IPimlico;
    procedure act(const aPattern: string; const aParameters: string;
                                          const aActionType: TActionType = atAsync;
                                          const aCallBack: TCallBackProc = nil);
    procedure remove (const aPattern: string);
    function find(const aPattern: string): TList<ImService>;
    function getExplicitPatterns(const aPattern: string): TList<string>;
    function unique(const aPattern: string): ImService;

    function start: IPimlico;
    function stop: IPimlico;
    procedure startAll;
    procedure stopAll;

    function service: ImService;
    function excludeFromStarting: IPimlico;

    function registerBroker(const aBroker: IPimlicoBroker): IPimlico;
    procedure loadConfiguration(const aPath: string;
                                const aReloadOnChange: Boolean = True;
                                const aInterval: Cardinal = POLL_INTERVAL);
    function autodiscovery: IPimlico;
  end;

{$I Version.inc}

implementation

end.
