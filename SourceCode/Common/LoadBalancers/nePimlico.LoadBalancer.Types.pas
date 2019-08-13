unit nePimlico.LoadBalancer.Types;

interface

uses
  nePimlico.Base.Types, nePimlico.mService.Types, System.Generics.Collections;

type
  ILoadBalancer = interface (IBaseInterface)
    ['{96E020C0-35D1-47B4-9658-98FFBF91D625}']
    function addMService (const aCommand: string; const amService: ImService):
                                                                ILoadBalancer;
    procedure deleteMService (const amService: ImService);
    procedure distribute (const aCommand: string; const aParameters: string); overload;
    procedure distribute (const aCommand: string; const aParameters: string;
                                var aStatus: TStatus); overload;
    function getMServices (const aCommand: string): TList<ImService>;
  end;

implementation

end.
