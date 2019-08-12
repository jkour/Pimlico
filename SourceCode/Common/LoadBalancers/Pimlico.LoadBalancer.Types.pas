unit Pimlico.LoadBalancer.Types;

interface

uses
  Pimlico.Base.Types, Pimlico.mService.Types, System.Generics.Collections;

type
  ILoadBalancer = interface (IBaseInterface)
    ['{96E020C0-35D1-47B4-9658-98FFBF91D625}']
    function addMService (const aPattern: string; const amService: ImService):
                                                                ILoadBalancer;
    procedure deleteMService (const amService: ImService);
    procedure distribute (const aPattern: string; const aParameters: string);
    function getMServices (const aPattern: string): TList<ImService>;
  end;

implementation

end.
