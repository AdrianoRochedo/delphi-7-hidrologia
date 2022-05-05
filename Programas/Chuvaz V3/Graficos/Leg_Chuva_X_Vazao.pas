unit Leg_Chuva_X_Vazao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TLeg_Chuva_X_Vazao_Form = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    PostosDeChuva : TStrings;
    PostosDeVazao : TStrings;
  end;

implementation
uses extctrls, WinUtils;

{$R *.DFM}

procedure TLeg_Chuva_X_Vazao_Form.FormPaint(Sender: TObject);
var i, dx, dy : Integer;
    OffsetX, OffsetY: Integer;
    AlturaX: Integer;
    r: TRect;
begin
  if PostosDeChuva.Count = 0 then Exit;
  AlturaX := Canvas.TextHeight('X');

  dx := 11;  OffsetX := 16;
  dy := 30;  OffsetY := 08;
  Canvas.Font.Color := clYellow;
  for i := 0 to PostosDeChuva.Count - 1 do
    begin
    r := Rect(dx, dy, dx + OffsetX, dy + OffsetY);
    Canvas.Brush.Color := TColor(PostosDeChuva.Objects[i]);
    Canvas.FillRect(r);
    Frame3D(Canvas, r, clWhite, clbtnShadow, 2);
    Canvas.Brush.Color := clBlack;
    Canvas.TextOut(dx + OffsetX + 6, dy-3, PostosDeChuva[i]);
    inc(dy, AlturaX + 3);
    end;

  dx := 117;  OffsetX := 16;
  dy :=  30;  OffsetY := 08;
  Canvas.Font.Color := clYellow;
  for i := 0 to PostosDeVazao.Count - 1 do
    begin
    r := Rect(dx, dy, dx + OffsetX, dy + OffsetY);
    Canvas.Brush.Color := TColor(PostosDeVazao.Objects[i]);
    Canvas.FillRect(r);
    Frame3D(Canvas, r, clWhite, clbtnShadow, 2);
    Canvas.Brush.Color := clBlack;
    Canvas.TextOut(dx + OffsetX + 6, dy-3, PostosDeVazao[i]);
    inc(dy, AlturaX + 3);
    end;
end;

procedure TLeg_Chuva_X_Vazao_Form.FormCreate(Sender: TObject);
begin
  AjustResolution(Self);
end;

end.
