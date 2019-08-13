unit nePimlico.Types;

interface

uses
  nePimlico.Base.Types, nePimlico.Node.Types, System.SysUtils;

type
  TCallBackProc = reference to procedure (aStatus: TStatus);
  IPimlico = interface (IBaseInterface)
    ['{B9DCACE0-2B07-48AE-BD77-2C30C14A366E}']
    function add(const aNode: ImNode): IPimlico;
    procedure act(const aPattern: string; const aParameters: string;
                                            const aCallBack: TCallBackProc = nil);
  end;

implementation

end.
