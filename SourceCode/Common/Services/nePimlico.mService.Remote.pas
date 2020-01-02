unit nePimlico.mService.Remote;

interface

uses
  nePimlico.mService.Base;

type
  TmServiceRemote = class (TmServiceBase)
  public
    constructor Create;
  end;

implementation

uses
  nePimlico.mService.Types;

constructor TmServiceRemote.Create;
begin
  inherited;
  &Type:=stRemote;
end;

end.
