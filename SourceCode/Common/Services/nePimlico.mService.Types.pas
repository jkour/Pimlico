unit nePimlico.mService.Types;

interface

uses
  nePimlico.Base.Types,
  System.SysUtils, nePimlico.mService.Remote.Profile;

type
  TServiceType = (stLocal, stRemote);
  ImService = interface (IBaseInterface)
    ['{1BCECA56-A4AD-476D-AFF3-5A0F70C7723A}']
    // Getters/Setters
    function getID: string;
    function getStatus: TStatus;
    function getDescription: string;
    function getVersion: string;

    function getEnabled: boolean;
    procedure setEnabled(const Value: boolean);

    function getType: TServiceType;
    procedure setType(const Value: TServiceType);

    function getAddress: string;
    procedure setAddress(const Value: string);

    function getPort: string;
    procedure setPort(const Value: string);

    function getSSL: boolean;
    procedure setSSL(const Value: boolean);

    function getProfileAddress: string;
    procedure setProfileAddress(const Value: string);

    function getAuthenticate: boolean;
    procedure setAuthenticate(const Value: boolean);

    function getToken: string;
    procedure setToken(const Value: string);
    // Methods
    procedure invoke(const aParameters: string);
    procedure start;
    procedure stop;
    procedure setup;
    procedure cleanup;
    procedure setProfile (const aProfile: TmServiceRemoteProfile);


    // Properties
    property Description: string read getDescription;
    property Enabled: boolean read getEnabled write setEnabled;
    property ID: string read getID;
    property Status: TStatus read getStatus;
    property Version: string read getVersion;
    property &Type: TServiceType read getType write setType;

    // Properties - Remote
    property Address: string read getAddress write setAddress;
    property Authenticate: boolean read getAuthenticate write setAuthenticate;
    property Port: string read getPort write setPort;
    property ProfileAddress: string read getProfileAddress write setProfileAddress;
    property SSL: boolean read getSSL write setSSL;
    property Token: string read getToken write setToken;
  end;

const
  ACTION_START = 'action: start';
  ACTION_STOP = 'action: stop';

implementation

end.
