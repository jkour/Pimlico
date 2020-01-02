unit nePimlico.mService.Remote.Profile;

interface

type
  TmServiceRemoteProfile = class
  private
    fDescription: string;
    fID: string;
    fVersion: string;
  public
    constructor Create;

    property Description: string read fDescription write fDescription;
    property ID: string read fID write fID;
    property Version: string read fVersion write fVersion;
  end;

implementation

uses
  System.SysUtils;

constructor TmServiceRemoteProfile.Create;
begin
  inherited;
  fDescription:='Base Remote Service';
  fID:=TGUID.Empty.ToString;
  fVersion:='0.0.0';
end;


end.
