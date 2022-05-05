{$RANGECHECKS OFF}
unit mh_GRF_ChuvaVazao;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Extpanel, Buttons, Menus, ComCtrls,
  wsMatrix,
  mh_GRF_ChuvaVazao_Valores,
  mh_GRF_ChuvaVazao_Legenda,
  mh_GRF_ChuvaVazao_Estatisticas;

type

  TFunctionMode = (fmNull, fmClick, fmShowCalc);

  TDLG_Graphic_1 = class(TForm)
    Info: TPanel;
    Label1: TLabel;
    Suporte1: TPanel;
    H: TScrollBar;
    Escala: TExtPanel;
    Escala_X: TExtPanel;
    L1: TLabel;
    L2: TLabel;
    L_Delta_X1: TLabel;
    L_Delta_X2: TLabel;
    btnOpcoes: TSpeedButton;
    Menu: TPopupMenu;
    Menu_Estatisticas: TMenuItem;
    N1: TMenuItem;
    Menu_Fechar: TMenuItem;
    Menu_Valores: TMenuItem;
    Menu_Legenda: TMenuItem;
    N2: TMenuItem;
    Menu_Fixar_um_Ponto: TMenuItem;
    N3: TMenuItem;
    Menu_AutoReduzir: TMenuItem;
    Label2: TLabel;
    Lab_FO: TLabel;
    Menu_Copiar: TMenuItem;
    N4: TMenuItem;
    edZoom: TEdit;
    udZoom: TUpDown;
    procedure HChange(Sender: TObject);
    procedure edZoomChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure EscalaResize(Sender: TObject);
    procedure EscalaPaint(Sender: TObject);
    procedure Escala_XPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnLegClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnValoresClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure Menu_FecharClick(Sender: TObject);
    procedure Menu_EstatisticasClick(Sender: TObject);
    procedure Menu_Fixar_um_PontoClick(Sender: TObject);
    procedure Menu_AutoReduzirClick(Sender: TObject);
    procedure Menu_CopiarClick(Sender: TObject);
    procedure btnOpcoesClick(Sender: TObject);
    procedure edZoomKeyPress(Sender: TObject; var Key: Char);
    procedure udZoomChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
  private
    nPontos            : Integer;  {Número de linhas do DataSet}
    PontosNaTela       : Integer;
    MeioZoom           : Integer;
    Yi1, Yf1, Yi2, Yf2 : Integer;  {Coordenadas Reais}
    PMax1, PMax2       : Double;     {Valores virtuais máximos}
    Yv1                : Double;     {Valores virtuais a serem plotados}
    Yr2                : Integer;  {Coordenadas reais a serem plotadas}
    DXi, DXf           : Integer;  {Deslocamentos inicial e final}
    Pos_i, Pos_f       : Integer;
    FDS                : TwsDataSet;
    i_Clicks           : Byte;     {quantidades de clicks}
    i_X1, i_X2         : Integer;  {coordenadas X}
    b_FixaValores      : Boolean;  {Fixa a legenda}
    Leg                : TDLG_Leg;
    Vals               : TDLG_Vals;
    Estat              : TDLG_Estat;
    Procedure SetDados(DS: TwsDataSet);
    Function Calculo1(PAtual: Double): Integer;
    Function Calculo2(PAtual: Double): Integer;
    Function Media(X1, X2, Index: Integer): Double;
    Procedure DesenhaEscala_Y;
    Procedure DesenhaEscala_X(i, p: Integer);
    Procedure SetDeltas(x1, x2: Integer);
    Procedure Mostra_Delta (X: Longint);
    Procedure PlotaGrafico(Canvas: TCanvas; ToClipboard: Boolean);
  public
    Zoom: Integer;
    Property Dados: TwsDataset Read FDS Write SetDados;
  end;

implementation
Uses wsConstTypes,
     SysUtilsEx,
     mh_Procs,
     wsGLIB,
     mh_TCs,
     mh_Classes,
     Clipbrd;

{$R *.DFM}

Const DY = 16; {Separação entre os gráficos}

Function Max(DS: TwsDataSet; Col: Integer): Double;
var b: boolean;
Begin
  Result := wsMatrixMax(DS, Col, 1, DS.nRows, b);
End;

Function TDLG_Graphic_1.Media(X1, X2, Index: Integer): Double;
var b: boolean;
Begin
  Try
    Result := wsMatrixMean(FDS, Index, X1, X2, b);
  Except
    Result := -1;
  End;
End;

Procedure TDLG_Graphic_1.Mostra_Delta (X: Longint);
Var Chuva  : Double;
    ValObs : Double;
    ValCal : Double;
Begin
  If (X < 1) or (X > Dados.nRows) Then Exit;

  Chuva  := Dados[X, 1];
  ValObs := Dados[X, 2]; {Vazao Obs}
  ValCal := Dados[X, 3]; {Vazao Calc}

  Vals.Nome1.Caption := ' VALORES ';
  {Vals.Nome2.Caption := '';}

  Vals.L_DeltaT.Font.Color := clWhite;
  Vals.L_DeltaT.Caption := 't = ' + IntToStr(X) + ' ';

  Vals.Lab_Y.Font.Color := clRed;
  If Chuva <> wsConstTypes.wscMissValue Then
     Vals.Lab_Y.Caption := 'PLU = ' + FloatToStrF(Chuva, ffGeneral, 7,3) + ' '
  Else
     Vals.Lab_Y.Caption := 'PLU = N.Def';

  Vals.LabVO.Font.Color := clAqua;
  If ValObs <> wsConstTypes.wscMissValue Then
     Vals.LabVO.Caption := 'VZO = ' + FloatToStrF(ValObs, ffGeneral, 7,3) + ' '
  Else
     Vals.LabVO.Caption := 'VZO = N.Def';

  Vals.LabCA.Font.Color := clYellow;
  If ValCal <> wsConstTypes.wscMissValue Then
     Vals.LabCA.Caption := 'VZC = ' + FloatToStrF(ValCal, ffGeneral, 7,3) + ' '
   Else
     Vals.LabCA.Caption := 'VZC = N.Def';
End;

Procedure TDLG_Graphic_1.SetDeltas(x1, x2: Integer);
Begin
  If X1 < 0 Then
     Begin
     L1 .Visible        := False;
     L_Delta_X1.Visible := False;
     End
  Else
     Begin
     L1 .Visible        := True;
     L_Delta_X1.Visible := True;
     L_Delta_X1.Caption := IntToStr(x1);
     End;

  If X2 < 0 Then
     Begin
     L2 .Visible        := False;
     L_Delta_X2.Visible := False;
     End
  Else
     Begin
     L2 .Visible        := True;
     L_Delta_X2.Visible := True;
     L_Delta_X2.Caption := IntToStr(x2);
     End;

  Menu_Estatisticas.Enabled := (X1 > -1)  and (X2 > -1) and (X1 <> X2);
  {(FDS.Tag_2 <> cSimulacao)}

  If Not Menu_Estatisticas.Enabled Then Estat.Hide;

  If Estat.Visible Then
     Estat.ShowEstatistics(Dados, i_X1, i_X2);

  If FDS <> Nil Then HChange(nil);

  b_FixaValores := (X1 = X2) and (X1 > -1);
  If b_FixaValores Then
     Begin
     {Estat.Hide;}
     Vals.Show;
     End;
End;

Procedure TDLG_Graphic_1.SetDados(DS: TwsDataSet);
Var aux: Double;
Begin
  FDS := DS;
  If (DS.nRows > 0) Then
     If (DS.nCols > 2) and
        (DS.Struct.Col[1].ColType = dtNumeric) and
        (DS.Struct.Col[2].ColType = dtNumeric) and
        (DS.Struct.Col[3].ColType = dtNumeric) Then
        Begin
        nPontos := DS.nRows;
        PMax2 := Max(DS, 1);
        PMax1 := Max(DS, 2);
        aux   := Max(DS, 3);
        If aux > PMax1 Then PMax1 := aux;
        End
     Else
        Raise Exception.Create(eDSPlotError2)
  Else
     Raise Exception.Create(eDSPlotError1);
End;

{Gráfico de linhas}
Function TDLG_Graphic_1.Calculo1(PAtual: Double): Integer;
Begin
  {Calculo do ponto a ser plotado}
  If (PAtual > wsConstTypes.wscMissValue) Then
     Begin
     Yv1 := PAtual * (Yf2 - Yi2) / PMax1;
     Result := Trunc(Yf2 - Yv1);
     End
  Else
     Result := Yf2 + 2; {Não é para ser plotado}
End;

{Gráfico de barras}
Function TDLG_Graphic_1.Calculo2(PAtual: Double): Integer;
Begin
  {Calculo do ponto a ser plotado}
  If (PAtual <> wsConstTypes.wscMissValue) Then
     Result := Trunc(PAtual * Yf1 / PMax2)
  Else
     Result := -1; {Não é para ser plotado}
End;

Procedure TDLG_Graphic_1.DesenhaEscala_Y;
var H, H1, H2, i: Integer;
Begin
  With Escala.Canvas do
    Begin
    Brush.Color := $00714D00;
    fillrect(Rect(0, 0, Escala.Width, Escala.Height));
    H := TextHeight('1');

    TextOut(5, 0, '0');
    TextOut(5, Yf1-H, Format('%4.0f', [PMax2]));

    Pen.Color := clWhite;
    MoveTo(0, Yf1 + (Dy div 2));
    LineTo(Escala.Width, Yf1 + (Dy div 2));

    TextOut(5, Yi2, Format('%4.0f', [PMax1]));
    TextOut(5, Yf2-H, '0');
    End;
End;

Procedure TDLG_Graphic_1.DesenhaEscala_X(i, p: Integer);
var s: String[10];
Begin
  With Escala_X.Canvas do
    Begin
    Brush.Color := $00714D00;
    fillrect(Rect(0, 0, Escala_X.Width, Escala_X.Height));
    TextOut(0, 5, IntToStr(i));

    S := IntToStr((p+i) div 2);
    If H.Visible Then
       TextOut((Self.Width - DXf) div 2 - TextWidth(S) div 2, 5, S)
    Else
       TextOut(p div 2 - TextWidth(S) div 2, 5, S);

    S := IntToStr(p);
    If H.Visible Then
       TextOut(Self.Width - DXf - TextWidth(S), 5, S)
    Else
       TextOut(p - TextWidth(S) div 2, 5, S)
    End;
End;

procedure TDLG_Graphic_1.HChange(Sender: TObject);
begin
  PlotaGrafico(Self.Canvas, False);
end;

procedure TDLG_Graphic_1.udZoomChangingEx(Sender: TObject; var AllowChange: Boolean;
                                          NewValue: Smallint; Direction: TUpDownDirection);
begin
  try Zoom := StrToInt(edZoom.Text) except Zoom := 1 end;
  case Direction of
    updUp   : If Zoom < 49 Then Inc(Zoom);
    updDown : If Zoom >  1 Then Dec(Zoom);
    end;
  MeioZoom := Zoom div 2;
  edZoom.Text := IntToStr(Zoom);

  edZoomChange(Nil)
end;

procedure TDLG_Graphic_1.edZoomChange(Sender: TObject);
var r: TRect;
begin
  try Zoom := StrToInt(edZoom.Text); except Zoom := 1; edZoom.Text := '1' end;
  if Zoom > 50 then
     begin
     Zoom := 50;
     edZoom.Text := IntToStr(Zoom);
     end;
  If Zoom < 1 Then Zoom := 1;

  r := ClientRect;
  PontosNaTela := (r.Right - DXi - DXf - 1) div Zoom;
  If nPontos > PontosNaTela Then
     Begin
     H.Visible := True;
     H.Max := nPontos - PontosNaTela;
     End
  Else
     Begin
     H.Visible := False;
     PontosNaTela := nPontos;
     End;
  HChange(nil);
end;

procedure TDLG_Graphic_1.FormResize(Sender: TObject);
begin
  {Posicionamento dos componentes}
  H.Width := Suporte1.Width - 4;

  {Inicialização das variáveis para auxilio na plotagem}
  Yi1 := 0;
  Yf1 := ((Escala_X.Top - 1) div 4) - (DY div 2);
  Yi2 := Yf1 + DY;
  Yf2 :=  (Escala_X.Top - 1);
  DXi := 0;
  DXf := Escala.Width;

  edZoomChange(nil);
end;

procedure TDLG_Graphic_1.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TDLG_Graphic_1.FormPaint(Sender: TObject);
begin
  HChange(nil);
end;

procedure TDLG_Graphic_1.EscalaResize(Sender: TObject);
begin
  DesenhaEscala_Y;
end;

procedure TDLG_Graphic_1.EscalaPaint(Sender: TObject);
begin
  DesenhaEscala_Y;
end;

procedure TDLG_Graphic_1.Escala_XPaint(Sender: TObject);
begin
  DesenhaEscala_X(Pos_i, Pos_f);
end;

procedure TDLG_Graphic_1.FormShow(Sender: TObject);
var i,i2: Integer;
begin
  If Not Assigned(FDS) Then
     Raise Exception.Create('Não há dados a serem analisados');

  Caption := ' ' + FDS.MLab + ' - Gráfico Vazões x Tempo';
  Lab_FO.Caption := CodToFObjetive(FDS.Tag_1);

  Canvas.brush.color := clBlack;
  Canvas.Pen.color := clgreen;

  Zoom := 1;
  MeioZoom := Zoom div 2;
  edZoomChange(nil); {inicializa parametros}
end;

procedure TDLG_Graphic_1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDLG_Graphic_1.FormCreate(Sender: TObject);
begin
  Zoom := 1;
  i_Clicks := 0;
  Leg   := TDLG_Leg.Create(Self);
  Vals  := TDLG_Vals.Create(Self);
  Estat := TDLG_Estat.Create(Self);
  SetDeltas(-1, -1);
end;

procedure TDLG_Graphic_1.FormDestroy(Sender: TObject);
begin
  Leg.Free;
  Vals.Free;
  Estat.Free;
end;

procedure TDLG_Graphic_1.btnLegClick(Sender: TObject);
begin
  Leg.Show;
end;

procedure TDLG_Graphic_1.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var S      : String[30];
    Yc     : Double;
    DeltaT : Integer;
begin
  {If Not Vals.Visible or (Mode = fmShowCalc) Then Exit;}
  S := '';

  DeltaT := Pos_i + ((X + MeioZoom) div Zoom);
  If Not b_FixaValores Then Mostra_Delta (DeltaT);
end;

procedure TDLG_Graphic_1.btnValoresClick(Sender: TObject);
begin
  Vals.Show;
end;

procedure TDLG_Graphic_1.FormClick(Sender: TObject);
var XAtual  : Integer;
    P       : TPoint;
begin
  GetCursorPos(P);
  P := ScreenToClient(P);
  XAtual := Pos_i + (P.X div Zoom);
  If XAtual > Dados.nRows Then Exit;

  Inc(i_Clicks);
  Case i_Clicks of
    1: Begin
       i_X1 := XAtual;
       SetDeltas(i_X1, -1);
       End;

    2: Begin
       i_X2 := XAtual;
       If i_X2 < i_X1 Then Swap(i_X2, i_X1);
       SetDeltas(i_X1, i_X2);

       {Vals.Nome2.Caption := ' MÉDIAS ';}
       If FDS.Tag_2 = cCalibracao Then
          Vals.LabVO.Caption := 'VZO = ' + FloatToStrF(Media(i_X1, i_X2, 2), ffGeneral, 7,3);

       Vals.LabCA.Caption := 'VZC = '  + FloatToStrF(Media(i_X1, i_X2, 3), ffGeneral, 7,3);
       i_Clicks := 0;
       End;
    End;
end;

procedure TDLG_Graphic_1.Menu_FecharClick(Sender: TObject);
begin
  Close;
end;

procedure TDLG_Graphic_1.Menu_EstatisticasClick(Sender: TObject);
begin
  Estat.ShowEstatistics(Dados, i_X1, i_X2);
end;

procedure TDLG_Graphic_1.Menu_Fixar_um_PontoClick(Sender: TObject);
var s, s1: String;
    n    : Longint;
begin
  s1 := Format('Digite um número entre %d e %d', [1, Dados.nRows]);
  s  := InputBox('Para fixar um ponto...', s1, '0');
  Try
    n := StrToInt(s);
    If (n < 1) or (n > Dados.nRows) Then Raise Exception.Create('Erro');
    SetDeltas(n, n);
    b_FixaValores := False;
    Mostra_Delta(n);
    b_FixaValores := True;
  Except
    MessageDLG('Voce não digitou um valor válido', mtError, [mbOK], 0);
  End;
end;

procedure TDLG_Graphic_1.Menu_AutoReduzirClick(Sender: TObject);
const Menu_Name = '&Auto-Reduzir';
begin
  If Menu_AutoReduzir.Caption = Menu_Name Then
     Begin
     Height := 280;
     Width  := 270;
     Menu_AutoReduzir.Caption := '&Restaurar';
     End
  Else
     Begin
     Height := 350;
     Width  := 630;
     Menu_AutoReduzir.Caption := Menu_Name;
     End;
end;

procedure TDLG_Graphic_1.Menu_CopiarClick(Sender: TObject);
Const AL = 20;
var B: TBitmap;
begin
  {$ifdef DEMO}
  mhApplication.ShowDemoMessage();
  {$else}
  B  := TBitmap.Create;
  Try
    B.Width  := ClientRect.Right;
    B.Height := Suporte1.Top - 1 + AL;

    BitBlt(B.Canvas.Handle, 0,0, B.Width, B.Height - AL,
         Canvas.Handle, 0, 0, SRCCOPY);

    PlotaGrafico(B.Canvas, True);

    {Desenha Legenda na clipBoard}
    With B.Canvas Do
      Begin
      TextOut(5,  B.Height - AL + 2, 'PLU x ');

      If (FDS.Tag_2 = cCalibracao) Then
         Begin
         Pen.Style := psDot;
         MoveTo (60, B.Height - AL div 2); LineTo(80, B.Height - AL div 2);
         TextOut(90, B.Height - AL + 2, 'VZO');

         Pen.Style := psSolid;
         MoveTo (140, B.Height - AL div 2); LineTo(160, B.Height - AL div 2);
         TextOut(170, B.Height - AL + 2, 'VZC');
         End
      Else
         Begin
         Pen.Style := psSolid;
         MoveTo (60, B.Height - AL div 2); LineTo(160, B.Height - AL div 2);
         TextOut(90, B.Height - AL + 2, 'VZC');
         End;
      End;

    Clipboard.Assign(B);
  Finally
    B.Free;
  End;
  {$endif}
end;

Procedure TDLG_Graphic_1.PlotaGrafico(Canvas: TCanvas; ToClipboard: Boolean);
var w, p, vw, i, x: Integer;
    r             : TRect;
    s             : String[10];
    Col           : Integer;
    Aux           : Integer;
Begin
  With Canvas, H Do
    Begin
    w  := self.Width;
    If H.Visible Then p  := Position Else p := 1;
    vw := w + p;

    {PontosNaTela = w div incremento}
    Aux := PontosNaTela - Byte(Not H.Visible);

    r := Self.ClientRect;
    r.Right  := Escala.Left - 1;
    r.Bottom := Escala_X.Top - 1;

    FillRect(r);

    {Desenha gráfico de linhas}
    For Col := 2 To 3 do
      Begin
      x := DXi;  {Inicio Virtual}
      Pen.Style := psSolid;

      Case Col Of
        cVZO :
          If ToClipboard Then
             Begin
             Pen.Style := psDot;
             Pen.Color := clBlack
             End
          Else
             Pen.Color := clAqua;

        cVZC :
          If ToClipboard Then
             Pen.Color := clBlue
          Else
             Pen.Color := clYellow;
        End;

      moveto(x, Calculo1(Dados[p, Col]));
      for i := 1 to Aux do
        Begin
        inc(x, Zoom);
        lineto( x, Calculo1(Dados[i + p, Col]) );
        End;
      End; {For Col ...}

    {Desenha gráfico de barras}
    x := DXi; {Inicio Virtual}
    If ToClipboard Then Pen.Color := clGreen Else Pen.Color := clRed;
    r.Top := 0;
    for i := 1 to Aux do
      Begin
      If Zoom > 2 Then  r.Left  := x + MeioZoom else r.Left  := x+1;
      inc(x, Zoom);
      If Zoom > 2 Then  r.Right := x + MeioZoom else r.Right := x+1;
      r.Bottom := Calculo2(FDS[i + p, 1]);
      Rectangle(r.left, r.top, r.right, r.bottom);
      End;
    End;

  Pos_i := p; Pos_f := i+p;
  If Not ToClipboard Then DesenhaEscala_X(Pos_i, Pos_f);

  {Desenha seleção}
  If Menu_Estatisticas.Enabled Then
     If (i_X2 < p) or ((Aux + p) < i_X1) Then
        {Seleção não visível}
     Else
        Begin
        r := Self.ClientRect;
        r.Right  := Escala.Left - 1;
        r.Bottom := Escala_X.Top - 1;

        If (i_X2 >= p) and (i_X2 <= (Aux + p)) Then
           Begin
           {Acha segundo x}
           x := DXi;
           for i := 1 to Aux do
               Begin
               inc(x, Zoom);
               If (i + p) = i_X2 Then
                  Begin
                  r.Right := x;
                  Break;
                  End;
               End;
           End;

        If (i_X1 >= p) and (i_X1 <= (Aux + p)) Then
           Begin
           {Acha o primeiro x}
           x := DXi;
           for i := 1 to Aux do
              Begin
              inc(x, Zoom);
              If (i + p) = i_X1 Then
                 Begin
                 r.Left := x;
                 Break;
                 End;
              End;
           End;

        Canvas.CopyMode := cmNotSrcCopy;
        Canvas.CopyRect(r, Canvas, r);
        Canvas.Pen.Mode := pmCopy;
        End;
End;

procedure TDLG_Graphic_1.btnOpcoesClick(Sender: TObject);
var P: TPoint;
begin
  P := Point(btnOpcoes.Left, btnOpcoes.Top);
  P := Info.ClientToScreen(P);
  Menu.Popup(P.x, P.y);
end;

procedure TDLG_Graphic_1.edZoomKeyPress(Sender: TObject; var Key: Char);
begin
  Case Key of
    '0'..'9', #8: {nada};
    else Key := #0;
    end;
end;

end.
