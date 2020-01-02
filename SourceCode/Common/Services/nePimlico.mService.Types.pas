unit nePimlico.mService.Types;

interface

uses
  nePimlico.Base.Types,
  System.SysUtils;

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

    function getSLL: boolean;
    procedure setSLL(const Value: boolean);

    // Methods
    procedure invoke(const aParameters: string);
    procedure start;
    procedure stop;
    procedure setup;
    procedure cleanup;

    // Properties
    property Description: string read getDescription;
    property Enabled: boolean read getEnabled write setEnabled;
    property ID: string read getID;
    property Status: TStatus read getStatus;
    property Version: string read getVersion;
    property &Type: TServiceType read getType write setType;

    // Properties - Remote
    property Address: string read getAddress write setAddress;
    property Port: string read getPort write setPort;
    property SLL: boolean read getSLL write setSLL;
  end;

const
  ACTION_START = 'action: start';
  ACTION_STOP = 'action: stop';

implementation

end.
