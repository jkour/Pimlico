unit nePimlico.Types;

interface

uses
  nePimlico.Base.Types, System.SysUtils, nePimlico.mService.Types;

type
  TActionType = (atSync, atAsync);
  TCallBackProc = reference to procedure (aStatus: TStatus);
  IPimlico = interface (IBaseInterface)
    ['{B9DCACE0-2B07-48AE-BD77-2C30C14A366E}']
    function add(const aPattern: string; const aService: ImService): IPimlico;
    procedure act(const aPattern: string; const aParameters: string;
                                          const aActionType: TActionType = atAsync;
                                          const aCallBack: TCallBackProc = nil);
    function start: IPimlico;
    function stop: IPimlico;
    procedure startAll;
    procedure stopAll;
    function service: ImService;
  end;

implementation

end.
