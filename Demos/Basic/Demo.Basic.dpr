program Demo.Basic;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  nePimlico.Factory,
  nePimlico.mService.Types,
  nePimlico.mService.Default,
  nePimlico,
  nePimlico.Node.Types,
  nePimlico.Node,
  nePimlico.LoadBalancer.Types,
  nePimlico.LoadBalancer.Default,
  nePimlico.Types,
  nePimlico.Base.Types;

var
  mSLogin: ImService;
  mSLogin2: ImService;
  mSLogout: ImService;
  balancer: ILoadBalancer;
  node: ImNode;

begin
  try
    mSLogin:=TmServiceDefault.Create;
    mSLogin2:=TmServiceDefault.Create;

    mSLogout:=TmServiceDefault.Create;

    balancer:=TLoadBalancerDefault.Create;
    balancer.addMService('cmd: login', mSLogin)
            .addMService('cmd: login', mSLogin2)
            .addMService('cmd: logout', mSLogout);

    node:=TmNode.Create;
    node.add(balancer);

    Pimlico.add('role:user-management', node);
    Pimlico.act('role:user-management, cmd:login', 'username:john, pass:1234',
                      procedure (aStatus: TStatus)
                      begin
                        Writeln('Response: '+aStatus.Response);
                      end);

    Writeln('Press Enter...');
    Readln;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
