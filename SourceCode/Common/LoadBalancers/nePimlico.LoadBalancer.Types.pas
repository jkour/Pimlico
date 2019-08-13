unit nePimlico.LoadBalancer.Types;

interface

uses
  nePimlico.Base.Types, nePimlico.mService.Types, System.Generics.Collections;

type
  ILoadBalancer = interface (IBaseInterface)
    ['{96E020C0-35D1-47B4-9658-98FFBF91D625}']
    function addService (const aPattern: string; const amService: ImService):
                                                                ILoadBalancer;
    procedure deleteService (const amService: ImService);
    procedure distribute (const aCommand: string; const aParameters: string); overload;
    procedure distribute (const aCommand: string; const aParameters: string;
                                var aStatus: TStatus); overload;
    function getServices (const aCommand: string): TList<ImService>;
  end;

implementation

end.
