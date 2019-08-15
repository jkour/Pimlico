unit Services.Login;

interface

uses
  nePimlico.mService.Default;

type
  TServiceLogin = class (TmServiceDefault)
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
  Status.Status:=ssRunning;
  Status.Response:='Logged in '+Self.ID+'in with '+aParameters+' parameters';
end;

end.
