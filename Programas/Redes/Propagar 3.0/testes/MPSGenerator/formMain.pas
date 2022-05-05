unit formMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    inMemo: TMemo;
    Button1: TButton;
    outMemo: TMemo;
    p1: TProgressBar;
    p2: TProgressBar;
    laProgresso: TLabel;
    cbOpt: TCheckBox;
    procedure Button1Click(Sender: TObject);
  private
    procedure Progress(ProgressID, Value: integer; const Text: string);
    procedure EndProcess(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses MPSConversor;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var x: TMPSConversor;
begin
  x := TMPSConversor.Create();
  x.OnProgress := Progress;
  x.inText := inMemo.Lines;
  x.outText := outMemo.Lines;
  x.Optimize := cbOpt.Checked;
  try
    x.Execute();
  finally
    EndProcess(self);
    x.Free();
  end;
end;

procedure TForm1.EndProcess(Sender: TObject);
begin
  p1.Position := 0;
  p2.Position := 0;
  laProgresso.caption := 'Progresso da operação:';
end;

procedure TForm1.Progress(ProgressID, Value: integer; const Text: string);
begin
  if Text <> '' then
     begin
     laProgresso.caption := Text;
     Application.ProcessMessages();
     end;

  if ProgressID = 1 then
     p1.Position := Value
  else
     p2.Position := Value
end;

end.

! teste
MIN
  FUNC) X + 123456789.12345 Y
ST
  E1) X <= 10
  E2) X - Y <= 5
  E3) A <= 7
END
  INTEGER X
  SUB Y 1  
