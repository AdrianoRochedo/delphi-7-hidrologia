unit mh_GRF_ChuvaVazao_Legenda;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TDLG_Leg = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnClose: TSpeedButton;
    procedure btnFecharClick(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    Movendo : Boolean;
    DX,DY   : Integer;
  public
    { Public declarations }
  end;

var
  DLG_Leg: TDLG_Leg;

implementation

{$R *.DFM}

procedure TDLG_Leg.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TDLG_Leg.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DX := X; DY := Y;
  Movendo := true;
end;

procedure TDLG_Leg.FormCreate(Sender: TObject);
begin
  Movendo := False;
end;

procedure TDLG_Leg.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
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

procedure TDLG_Leg.Panel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Movendo := False;
end;

end.
