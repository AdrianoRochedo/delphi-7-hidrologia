unit mh_GRF_EvolucaoDosParametros;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, TeEngine, Series, ExtCtrls, TeeProcs, Chart, Gridx32,
  Extpanel, SheetWrapper;

type
  TDLG_GraphicPar = class(TForm)
    Chart: TChart;
    Leg: TExtPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ChartAfterDraw(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    Series1: TBarSeries;
  public
    Pai: Pointer;
    procedure Plotar_serie (G: TSheet);
    Function Max(Linha: Longint; G: TSheet): Double;
  end;

implementation
uses mh_Classes,
     mh_TCs,
     sysUtilsEx;

{$R *.DFM}

Function TDLG_GraphicPar.Max(Linha: Longint; G: TSheet): Double;
var  coluna  : Longint;
     Valor   : Double;
begin
 Result := -99999999;
 For coluna := 2 to G.ColCount do
   begin
   Valor := G.GetFloat(Linha, Coluna);
   if Valor > Result then Result := Valor;
   end;
 end;

procedure TDLG_GraphicPar.Plotar_serie (G : TSheet);
var Linha       : LongInt;
    X           : LongInt;
    Coluna      : LongInt;
    Y           : Double;
    Cor         : Tcolor;
    ValorAtual  : Double;
    ValorMaximo : Double;

const Cores : Array [0..13]  of TColor =
      (clRed, clBlue, clOlive, clPurple, clGreen, clSilver, clAqua,
       clRed, clBlue, clOlive, clPurple, clGreen, clSilver, clAqua);

begin
{calcula o valor de y (%) que sera plotado no grafico;
 a formula % = ((P1j - P1min)/(P1Max - P1min))+P1Media};

 x := 0;
 For Linha := 1 to 14 Do
   Begin
   ValorMaximo := Max(Linha, G);

   For Coluna := 2 to G.ColCount Do
     begin
     Application.ProcessMessages();

     ValorAtual := G.GetFloat(Linha, Coluna);
     If (X mod 6 = 0 ) Then
        cor := Cores [trunc(X / 6)];  {Vai modificar a cor da serie a cada 6 pontos plotados ????}

     Try
       Y := ((ValorAtual * 100) / (ValorMaximo));
     Except
       Y := 0;
       End;

     Series1.AddXY( X, Y, '', Cor);
     inc(X);
     end;
   End;
end;

procedure TDLG_GraphicPar.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TmhSubBacia(Pai).ParamsGraf := nil;
  Action := caFree;
end;

procedure TDLG_GraphicPar.ChartAfterDraw(Sender: TObject);
var dx, x, i: Integer;
begin
  x := 8;
  With Leg.Canvas Do
    Begin
    Font.Name := 'Arial';
    Font.Size := 10;
    dx := Leg.Width div NParametros;
    For i := 1 to NParametros do
      Begin
      TextOut(x, 2, ParamNames[i]);
      Inc(x, dx);
      End;
    End;
end;

{ChVzcVzo.CopyToClipboardBitmap;}

procedure TDLG_GraphicPar.FormCreate(Sender: TObject);
begin
   Series1 := TBarSeries.Create(nil);
   Series1.ParentChart := Chart;
end;

end.
