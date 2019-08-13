unit nePimlico.Node.Types;

interface

uses
  nePimlico.Base.Types, nePimlico.mService.Types, nePimlico.LoadBalancer.Types,
  System.Generics.Collections;

type
  ImNode = interface (IBaseInterface)
    ['{D7211EFE-9AF6-4BF6-A94B-64BBAD2845B6}']
    function add(const aLoadBalancer: ILoadBalancer): ImNode;
    procedure delete (const aLoadBalancer: ILoadBalancer);
    procedure getLoadBalancers (const aPattern: string; var list: TList<ILoadBalancer>);
  end;

implementation

end.
