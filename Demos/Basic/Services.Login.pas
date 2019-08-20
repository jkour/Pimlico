unit Services.Login;

interface

uses
  nePimlico.mService.Base;

type
  TServiceLogin = class (TmServiceBase)
  protected
    procedure invoke(const aParameters: string); override;
  end;

var
  Tag: string;

implementation

uses
  nePimlico.Base.Types,
  System.SysUtils;

{ TServiceLogin }

procedure TServiceLogin.invoke(const aParameters: string);
begin
  Tag:='beginning';
  inherited;
  if not continueInvoke(aParameters) then
    Exit;
  Status.Response:='Logged in '+Self.ID+'in with '+aParameters+' parameters';
  Tag:='Invoke';
end;

end.
