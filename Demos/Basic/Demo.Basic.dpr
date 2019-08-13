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
  balancerLogin: ILoadBalancer;
  balancerLogout: ILoadBalancer;
  node: ImNode;

begin
  try
    mSLogin:=TmServiceDefault.Create;
    mSLogin2:=TmServiceDefault.Create;

    mSLogout:=TmServiceDefault.Create;

    balancerLogin:=TLoadBalancerDefault.Create;
    balancerLogin.addService('role:user-management, cmd: login', mSLogin)
                 .addService('role:user-management, cmd: login', mSLogin2);

    balancerLogout:=TLoadBalancerDefault.Create;
    balancerLogout.addService('role:user-management, cmd: logout', mSLogout);

    node:=TmNode.Create;
    node.add(balancerLogin)
        .add(balancerLogout);

    Pimlico.add(node);
    Pimlico.act('role:user-management, cmd:login', 'username:john, pass:1234',
                      procedure (aStatus: TStatus)
                      begin
                        Writeln('Response: '+aStatus.Response);
                      end);

    // Pimlico.act('role:user-management, cmd:login, user-status:admin'

    Writeln('Press Enter...');
    Readln;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
