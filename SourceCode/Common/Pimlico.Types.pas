unit Pimlico.Types;

interface

uses
  Pimlico.Base.Types, Pimlico.Node.Types, System.SysUtils;

type
  TMessageType = (mtSyncConsumed, mtSyncObserved, mtAsyncConsumed, mtAsyncObserved);
  IPimlico = interface (IBaseInterface)
    ['{B9DCACE0-2B07-48AE-BD77-2C30C14A366E}']
    function add(const aPattern: string; const aNode: ImNode): IPimlico;
    procedure act(const aRoot: string; const aParameters: string;
                    const aMessageType: TMessageType; const aCallBack: TProc);
  end;

implementation

end.
