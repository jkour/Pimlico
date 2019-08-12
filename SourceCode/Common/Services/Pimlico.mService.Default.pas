unit Pimlico.mService.Default;

interface

uses
  Pimlico.Base.Types, Pimlico.mService.Types;

type
  TmServiceDefault = class(TBaseInterfacedObject, ImService)
{$REGION 'Interface'}
    function getServiceType: TServiceType;
    function getResponse: string;
    function getErrorCode: TServiceErrorCode;
    function getErrorMsg: string;

    procedure invoke(const aParameters: string); virtual;
{$ENDREGION}
  protected
    ServiceType: TServiceType;
    ErrorCode: TServiceErrorCode;
    ErrorMsg: string;
    Response: string;
  public
    constructor Create;
  end;

implementation

constructor TmServiceDefault.Create;
begin
  inherited;
  ServiceType:=stLocal;
  ErrorCode:=secOK;
  ErrorMsg:='';
end;

function TmServiceDefault.getErrorCode: TServiceErrorCode;
begin
  Result:=ErrorCode;
end;

function TmServiceDefault.getErrorMsg: string;
begin
  Result:=ErrorMsg;
end;

function TmServiceDefault.getResponse: string;
begin
  Result:=Response;
end;

function TmServiceDefault.getServiceType: TServiceType;
begin
  Result:=ServiceType;
end;

procedure TmServiceDefault.invoke(const aParameters: string);
begin
  // DO NOT DELETE
end;

end.
