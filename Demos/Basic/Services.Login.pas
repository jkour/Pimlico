unit Services.Login;

interface

uses
  nePimlico.mService.Base;

type
  TServiceLogin = class (TmServiceBase)
  protected
    procedure invoke(const aParameters: string); override;
  end;

implementation

uses
  nePimlico.Base.Types;

{ TServiceLogin }

procedure TServiceLogin.invoke(const aParameters: string);
begin
  inherited;
  fStatus.Status:=ssRunning;
  fStatus.Response:='Logged in '+ID+'in with '+aParameters+' parameters';
end;

end.
