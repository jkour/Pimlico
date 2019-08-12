program Demo.Basic;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Pimlico.Factory,
  Pimlico.mService.Types,
  Pimlico.mService.Factory,
  Pimlico.Core,
  Pimlico.Node.Types,
  Pimlico.Node,
  Pimlico.LoadBalancer.Types,
  Pimlico.LoadBalancer.Default,
  Pimlico.Types;

var
  mSLogin: ImService;
  balancer: ILoadBalancer;
  node: ImNode;

begin
  try
    mSLogin:=TmServiceFactory.createMService(stLocal);

    balancer:=TLoadBalancerDefault.Create;
    balancer.addMService('cmd: login', mSLogin);

    node:=TmNode.Create;
    node.add(balancer);

    pimlico4D.add('role:user-management', node);

    Writeln('Press Enter...');
    Readln;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
