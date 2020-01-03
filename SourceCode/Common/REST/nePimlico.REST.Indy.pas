unit nePimlico.REST.Indy;

interface

uses
  nePimlico.REST.Types, nePimlico.mService.Types, IdHTTP;

type
  TPimlicoRESTIndy = class (TInterfacedObject, IPimlicoRESTBase)
  private
    fIndy: TidHTTP;
  public
{$REGION 'Interface'}
    function request(const aService: ImService; const aParameters: string): string;
{$ENDREGION}
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils, nePimlico.Types;

constructor TPimlicoRESTIndy.Create;
begin
  inherited;
  fIndy:=TIdHTTP.Create(nil);
end;

destructor TPimlicoRESTIndy.Destroy;
begin
  fIndy.Free;
  inherited;
end;

{ TPimlicoRESTIndy }

function TPimlicoRESTIndy.request(const aService: ImService; const aParameters:
    string): string;
var
  url: string;
begin
  url:=aService.Address;
  if url.StartsWith('https', true) then
    url:=url.Substring(Length('https'));
  if url.StartsWith('http', true) then
    url:=url.Substring(Length('http'));

  if aService.Authenticate and (not url.Contains(PIMLICO_PROFILE_ENDPOINT)) and
      (not url.Contains(PIMLICO_AUTHENTICATE_ENDPOINT)) then
    fIndy.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + aService.Token;

  if aService.SSL then
  begin
    url:=url.Insert(0, 'https');
    // need to fix this
    raise Exception.Create('No setup for Indy HTTPS');
  end
  else
    url:=url.Insert(0, 'http');
  try
    result:=fIndy.Get(url);
  except
    on E: Exception do
    begin
      result:='ERROR:' + E.Message;
    end;
  end;

end;

end.
