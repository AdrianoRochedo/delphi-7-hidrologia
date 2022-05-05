unit mh_GRF_ChuvaVazao_Valores;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TDLG_Vals = class(TForm)
    Panel1: TPanel;
    Nome1: TLabel;
    Lab_Y: TLabel;
    Label1: TLabel;
    LabVO: TLabel;
    LabCA: TLabel;
    L_DeltaT: TLabel;
    btnClose: TSpeedButton;
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnFecharClick(Sender: TObject);
  private
    Movendo : Boolean;
    DX,DY   : Integer;
  public
    { Public declarations }
  end;

var
  DLG_Vals: TDLG_Vals;

implementation

{$R *.DFM}

procedure TDLG_Vals.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DX := X + TGraphicControl(Sender).Left;
  DY := Y + TGraphicControl(Sender).Top;
  Movendo := true;
end;

procedure TDLG_Vals.FormCreate(Sender: TObject);
begin
  Movendo := False;
  Lab_Y.Caption := '';
  {Lab_X.Caption := '';}
end;

procedure TDLG_Vals.MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
Var Atual: TPoint;
begin
  GetCursorPos(Atual);
  If Movendo Then
     Begin
     Left := Atual.X - DX;
     Top  := Atual.Y - DY;
     End;
end;

procedure TDLG_Vals.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Movendo := False;
end;

procedure TDLG_Vals.btnFecharClick(Sender: TObject);
begin
  Close;
end;

end.
