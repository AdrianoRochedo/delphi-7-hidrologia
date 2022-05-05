unit pro_fo_PLU_VZO_Values;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, wsMatrix;

type
  TValores_Chuva_X_Vazao_Form = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    L1: TLabel;
    L_Delta: TLabel;
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    ind_PostosDeVazao: Array of Integer;
    ind_PostosDeChuva: Array of Integer;
    FPostosDeChuva: TStrings;
    FPostosDeVazao: TStrings;
    FDelta: Integer;
    FMaxXc, FMaxXv: Integer;
    Procedure DesenhaValores;
    procedure SetPostosDeChuva(const Value: TStrings);
    procedure SetPostosDeVazao(const Value: TStrings);
    procedure SetDelta(const Value: Integer);
  public
    Dados: TwsDataSet;
    Property Delta         : Integer  read FDelta  write SetDelta;
    Property PostosDeChuva : TStrings Read FPostosDeChuva write SetPostosDeChuva;
    Property PostosDeVazao : TStrings read FPostosDeVazao write SetPostosDeVazao;
 end;

implementation
uses extctrls, SysUtilsEx, WinUtils, Math;

Const
  dxc     = 11;
  dxv     = 280;
  dy      = 45;
  OffsetX = 16;
  OffsetY = 06;
  espX    = 6;

{$R *.DFM}

procedure TValores_Chuva_X_Vazao_Form.DesenhaValores;
var i, y: Integer;
    AlturaX: Integer;
    r: TRect;
begin
  if (Delta < 1) or (Delta > Dados.NRows) then Exit;

  AlturaX := Canvas.TextHeight('X');
  Canvas.Font.Color := clYellow;
  Canvas.Brush.Color := clBlack;
  L_Delta.Caption := DateToStr(Dados.AsDateTime[Delta, 1]) + '  (' + toString(Delta) + ')';

  // escreve os valores dos postos de Chuva
  y := dy;
  Canvas.FillRect(
     Rect(FMaxXc, y-2,
          dxv-1, y + FPostosDeChuva.Count * (AlturaX + OffsetY) + 1));

  for i := 0 to FPostosDeChuva.Count - 1 do
    begin
    Canvas.TextOut(FMaxXc, y-3, Dados.AsTrimString[Delta, ind_PostosDeChuva[i]]);
    inc(y, AlturaX + OffsetY);
    end;

  // escreve os valores dos postos
  y := dy;
  Canvas.FillRect(
     Rect(FMaxXv, y-2,
          Width, y + FPostosDeVazao.Count * (AlturaX + OffsetY) + 1));

  for i := 0 to FPostosDeVazao.Count - 1 do
    begin
    Canvas.TextOut(FMaxXv, y-3, Dados.AsTrimString[Delta, ind_PostosDeVazao[i]]);
    inc(y, AlturaX + OffsetY);
    end;
end;

procedure TValores_Chuva_X_Vazao_Form.FormPaint(Sender: TObject);
var i: Integer;
    xx, y: Integer;
    AlturaX, MaxX: Integer;
    r: TRect;
    s: String;
begin
  AlturaX := Canvas.TextHeight('X');
  Canvas.Font.Color := clYellow;
{
  // desenha uma reta horizontal separando o delta do posto de chuva
  Canvas.Pen.Color := clWhite;
  Canvas.MoveTo(L1.Left, 26);
  Canvas.LineTo(Width - L1.Left * 2, 26);

  // escreve o nome do posto de chuva
  if FPC.Count > 0  then
     begin
     MaxX := xx + Canvas.TextWidth(FPC[0] + ':') + espX;
     if MaxX > gMaxX then gMaxX := MaxX;
     Canvas.TextOut(xx, 54, FPC[0] + ':');
     end;
}
  y  := dy;
  xx := dxc + OffsetX + espX;
  FMaxXc := 0;
  for i := 0 to FPostosDeChuva.Count - 1 do
    begin
    // desenha os retângulos coloridos
    r := Rect(dxc, y, dxc + OffsetX, y + OffsetY + 2);
    Canvas.Brush.Color := TColor(FPostosDeChuva.Objects[i]);
    Canvas.FillRect(r);
    Frame3D(Canvas, r, clWhite, clbtnShadow, 2);

    // escreve o nome dos postos de chuva
    Canvas.Brush.Color := clBlack;
    s := FPostosDeChuva[i] + ':';
    Canvas.TextOut(xx, y-3, s);
    MaxX := xx + Canvas.TextWidth(s) + espX;
    if MaxX > FMaxXc then FMaxXc := MaxX;
    inc(y, AlturaX + OffsetY);
    end;

  y  := dy;
  xx := dxv + OffsetX + espX;
  for i := 0 to FPostosDeVazao.Count - 1 do
    begin
    // desenha os retângulos coloridos
    r := Rect(dxv, y, dxv + OffsetX, y + OffsetY + 2);
    Canvas.Brush.Color := TColor(FPostosDeVazao.Objects[i]);
    Canvas.FillRect(r);
    Frame3D(Canvas, r, clWhite, clbtnShadow, 2);

    // escreve o nome dos postos de vazão
    Canvas.Brush.Color := clBlack;
    s := FPostosDeVazao[i] + ':';
    Canvas.TextOut(xx, y-3, s);
    MaxX := xx + Canvas.TextWidth(s) + espX;
    if MaxX > FMaxXv then FMaxXv := MaxX;
    inc(y, AlturaX + OffsetY);
    end;
  DesenhaValores;
end;

procedure TValores_Chuva_X_Vazao_Form.SetDelta(const Value: Integer);
begin
  FDelta := Value;
  DesenhaValores
end;

procedure TValores_Chuva_X_Vazao_Form.SetPostosDeChuva(const Value: TStrings);
var i: Integer;
begin
  FPostosDeChuva := Value;
  SetLength(ind_PostosDeChuva, FPostosDeChuva.Count);
  for i := 0 to FPostosDeChuva.Count - 1 do
    ind_PostosDeChuva[i] := Dados.Struct.IndexOf((GetValidID(FPostosDeChuva[i])));
end;

procedure TValores_Chuva_X_Vazao_Form.SetPostosDeVazao(const Value: TStrings);
var i: Integer;
begin
  FPostosDeVazao := Value;
  SetLength(ind_PostosDeVazao, FPostosDeVazao.Count);
  for i := 0 to FPostosDeVazao.Count - 1 do
    ind_PostosDeVazao[i] := Dados.Struct.IndexOf((GetValidID(FPostosDeVazao[i])));
end;

procedure TValores_Chuva_X_Vazao_Form.FormCreate(Sender: TObject);
begin
  AjustResolution(Self);
end;

end.
