unit Pimlico.Node.Types;

interface

uses
  Pimlico.Base.Types, Pimlico.mService.Types, Pimlico.LoadBalancer.Types;

type
  ImNode = interface (IBaseInterface)
    ['{D7211EFE-9AF6-4BF6-A94B-64BBAD2845B6}']
    function add(const aLoadBalancer: ILoadBalancer): ImNode;
    procedure delete (const aLoadBalancer: ILoadBalancer);
    procedure push(const aPattern: string; const aParameters: string);
  end;

implementation

end.
