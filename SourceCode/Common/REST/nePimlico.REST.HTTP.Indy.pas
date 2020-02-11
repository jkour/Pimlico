unit nePimlico.REST.HTTP.Indy;

interface

uses
  nePimlico.REST.HTTP.Types, IdHTTP;

type
  TRESTHTTPIndy = class (TInterfacedObject, IRESTHTTP)
  private
    fIdHTTP: TidHTTP;
{$REGION 'Interface'}
    function get(const aURL: string): string;
{$ENDREGION}
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

constructor TRESTHTTPIndy.Create;
begin
  inherited;
  fIdHTTP:=TIdHTTP.Create(nil);
end;

destructor TRESTHTTPIndy.Destroy;
begin
  fIdHTTP.Free;
  inherited;
end;

function TRESTHTTPIndy.get(const aURL: string): string;
begin
  result:=fIdHTTP.Get(aURL);
end;

end.
