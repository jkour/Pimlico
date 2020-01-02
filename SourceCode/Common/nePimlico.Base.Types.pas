unit nePimlico.Base.Types;

interface

type
  IBaseInterface = interface (IInvokable)
    ['{33775D99-FB2D-4409-B976-6213E484A227}']
  end;

  TBaseInterfacedObject = class (TInterfacedObject, IBaseInterface)

  end;

  TServiceStatus = (ssIdle, ssError, ssRunning, ssStarted, ssStopped);

  TStatus = record
    Status: TServiceStatus;
    ErrorMsg: string;
    Response: string;
  end;

implementation

end.
