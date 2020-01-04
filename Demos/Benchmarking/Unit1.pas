unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.TMSFNCEdit, FMX.Controls.Presentation, FMX.StdCtrls, ArrayHelper,
  nePimlico.mService.Types, System.Diagnostics, System.Threading;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    efInvokes: TTMSFNCEdit;
    btnRun: TButton;
    efServices: TTMSFNCEdit;
    Label2: TLabel;
    pbProgress: TProgressBar;
    lbStatus: TLabel;
    Label3: TLabel;
    lbNormalCreation: TLabel;
    Label4: TLabel;
    lbNormalFinding: TLabel;
    efIterations: TTMSFNCEdit;
    Label5: TLabel;
    cbGUI: TCheckBox;
    Label6: TLabel;
    lbNormalInvoking: TLabel;
    btnStop: TButton;
    procedure btnRunClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    fArray: TArrayRecord<string>;
    fStopWatch: TStopWatch;
    fCreationTime: UInt64;
    fFindingTime: UInt64;
    fIterationsTime: UInt64;
    fTask: ITask;
    fShouldStop: Boolean;

    procedure cancelTask;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  Service.Mock, nePimlico.Factory;

{$R *.fmx}

procedure TForm1.btnRunClick(Sender: TObject);
begin
  btnRun.Enabled:=false;
  btnStop.Enabled:=true;
  fStopWatch:=TStopwatch.Create;
  fStopWatch.Reset;
  pbProgress.Max:=efServices.Text.ToInteger;
  pbProgress.Min:=0;
  pbProgress.Value:=0;
  lbNormalCreation.Text:='---';
  lbNormalFinding.Text:='---';
  lbNormalInvoking.Text:='---';
  fCreationTime:=0;
  fFindingTime:=0;
  fIterationsTime:=0;
  fShouldStop:=false;

  lbStatus.Text:='Running...';
  fTask:=TTask.Run(procedure
                  var
                    serv: ImService;
                    num: integer;
                    exNum: integer;
                    secNum: integer;
                    tag: string;
                  begin
                    //// Creating
                    fStopWatch.Start;
                    if cbGUI.IsChecked and (fTask.Status <> TTaskStatus.Canceled) then
                      TThread.Synchronize(nil, procedure
                                               begin
                                                 pbProgress.Max:= efServices.Text.ToInteger;
                                               end);
                    for exNum := 0 to efIterations.Text.ToInteger - 1 do
                    begin
                      if fShouldStop then
                      begin
                        cancelTask;
                        Exit;
                      end;
                      if cbGUI.IsChecked then
                          TThread.Synchronize(nil, procedure
                                                 begin
                                                   pbProgress.Value:=0;
                                                 end);
                      for num := 0 to efServices.Text.ToInteger - 1 do
                      begin
                        if fShouldStop then
                        begin
                          cancelTask;
                          Exit;
                        end;
                        serv:=TServiceMock.Create;
                        serv.Enabled:=True;
                        serv.start;
                        pimlico.add(num.ToString, serv);

                        if cbGUI.IsChecked then
                          TThread.Synchronize(nil, procedure
                                                 begin
                                                   lbStatus.Text:='Creating '+(num + 1).ToString +
                                                        '/'+efServices.Text+' service in ' +
                                                      (exNum + 1).ToString + ' of ' +
                                                        efIterations.Text +
                                                        ' iterations';
                                                   pbProgress.Value:=pbProgress.Value + 1;
                                                 end);
                        Pimlico.remove(num.ToString);
                      end;
                    end;
                    fStopWatch.Stop;
                    fCreationTime:= fStopWatch.ElapsedMilliseconds div
                                              efIterations.Text.ToInteger div
                                                 efServices.Text.ToInteger;
                    TThread.Synchronize(nil, procedure
                                             begin
                                               lbNormalCreation.Text:=
                                                  fCreationTime.ToString + ' ms';
                                             end);

                    //// Finding
                    fArray:=TArrayRecord<string>.Create(efServices.Text.ToInteger);
                    TThread.Synchronize(nil, procedure
                                             begin
                                               lbStatus.Text:='Setting up Finding...';
                                             end);

                    for num := 0 to efServices.Text.ToInteger - 1 do
                    begin
                      serv:=TServiceMock.Create;
                      serv.Enabled:=True;
                      fArray[num]:=num.ToString;
                      pimlico.add(num.ToString, serv);
                    end;

                    if cbGUI.IsChecked then
                      TThread.Synchronize(nil, procedure
                                               begin
                                                 pbProgress.Value:=0;
                                               end);

                    fStopWatch.Reset;
                    fStopWatch.Start;
                    fFindingTime:=0;

                    for exNum := 0 to efIterations.Text.ToInteger - 1 do
                    begin
                      if fShouldStop then
                      begin
                        cancelTask;
                        Exit;
                      end;
                      if cbGUI.IsChecked then
                          TThread.Synchronize(nil, procedure
                                                 begin
                                                   pbProgress.Value:=0;
                                                 end);
                      for num := 0 to efServices.Text.ToInteger - 1 do
                      begin
                        if fShouldStop then
                        begin
                          cancelTask;
                          Exit;
                        end;
                        serv:=pimlico.unique(fArray[num]);

                        if cbGUI.IsChecked then
                          TThread.Synchronize(nil, procedure
                                                 begin
                                                   lbStatus.Text:='Finding '+(num + 1).ToString +
                                                        '/'+efServices.Text+' service in ' +
                                                      (exNum + 1).ToString + ' of ' +
                                                        efIterations.Text +
                                                        ' iterations';
                                                   pbProgress.Value:=pbProgress.Value + 1;
                                                 end);
                      end;
                    end;
                    fStopWatch.Stop;
                    fFindingTime:= fStopWatch.ElapsedMilliseconds div
                                              efIterations.Text.ToInteger div
                                                 efServices.Text.ToInteger;
                    TThread.Synchronize(nil, procedure
                                             begin
                                               lbNormalFinding.Text:=
                                                  fFindingTime.ToString + ' ms';
                                             end);
                    //// Invoking
                    TThread.Synchronize(nil, procedure
                                             begin
                                               lbStatus.Text:='Setting up Invoking...';
                                               pbProgress.Value:=0;
                                               pbProgress.Max:=efInvokes.Text.ToInteger;
                                             end);
                    fStopWatch.Reset;
                    fStopWatch.Start;
                    fIterationsTime:=0;

                    for secNum := 0 to efIterations.Text.ToInteger - 1 do
                    begin
                      if fShouldStop then
                      begin
                        cancelTask;
                        Exit;
                      end;
                      for exNum := 0 to efServices.Text.ToInteger - 1 do
                      begin
                        if fShouldStop then
                        begin
                          cancelTask;
                          Exit;
                        end;
                        serv:=pimlico.unique(fArray[exNum]);
                        if cbGUI.IsChecked then
                            TThread.Synchronize(nil, procedure
                                                   begin
                                                     pbProgress.Value:=0;
                                                   end);
                        for num := 0 to efInvokes.Text.ToInteger - 1 do
                        begin
                          if fShouldStop then
                          begin
                            cancelTask;
                            Exit;
                          end;
                          serv.invoke('test');

                          if cbGUI.IsChecked then
                            TThread.Synchronize(nil, procedure
                                                   begin
                                         lbStatus.Text:='Invoking '+(num + 1).ToString +
                                              '/'+efInvokes.Text+' of service '+
                                                (exNum + 1).ToString + '/' +
                                                  efServices.Text +
                                                    ' in ' +
                                            (secNum + 1).ToString + ' of ' +
                                              efIterations.Text +
                                              ' iterations';
                                         pbProgress.Value:=pbProgress.Value + 1;
                                                   end);
                        end;
                      end;
                    end;
                    fStopWatch.Stop;
                    fIterationsTime:= fStopWatch.ElapsedMilliseconds div
                                              efIterations.Text.ToInteger div
                                                 efServices.Text.ToInteger div
                                                  efInvokes.Text.ToInteger;
                    TThread.Synchronize(nil, procedure
                                             begin
                                               lbNormalInvoking.Text:=
                                                  fIterationsTime.ToString + ' ms';
                                               lbStatus.Text:='Finished';
                                               btnRun.Enabled:=true;
                                               btnStop.Enabled:=false;
                                             end);
                  end);

end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
  lbStatus.Text:='Cancelling...';
  fShouldStop:=true;
end;

procedure TForm1.cancelTask;
begin
  btnRun.Enabled:=true;
  btnStop.Enabled:=false;
  pbProgress.Value:=0;
  lbStatus.Text:='Stopped';
end;

end.
