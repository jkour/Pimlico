unit Service.Mock;

interface

uses
  nePimlico.mService.Base;

type
  TServiceMock = class (TmServiceBase)
  protected
    procedure invoke(const aParameters: string); override;
  end;

implementation

{ TServiceMock }

procedure TServiceMock.invoke(const aParameters: string);
var
  num: Integer;
  x: Integer;
begin
  inherited;
  x:=0;
  for num := 0 to 1000 do
    Inc(x + num);
end;

end.
