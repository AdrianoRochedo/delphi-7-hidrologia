unit Graf_Chuva_X_vazao;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Extpanel, wsMatrix,
  {Estatist,} Buttons, Menus, ComCtrls,
  Leg_Chuva_X_Vazao,
  Valores_Chuva_X_Vazao;

type

  TFunctionMode = (fmNull, fmClick, fmShowCalc);

  TGraf_Chuva_X_Vazao_Form = class(TForm)
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
    N1: TMenuItem;
    Menu_Fechar: TMenuItem;
    Menu_Valores: TMenuItem;
    Menu_Legenda: TMenuItem;
    N2: TMenuItem;
    Menu_Fixar_um_Ponto: TMenuItem;
    N3: TMenuItem;
    Menu_AutoReduzir: TMenuItem;
    Menu_Copiar: TMenuItem;
    N4: TMenuItem;
    edZoom: TEdit;
    Zoom: TUpDown;
    Definir_Maximo: TMenuItem;
    N5: TMenuItem;
    Menu_PlotarMaximos: TMenuItem;
    procedure HChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure EscalaResize(Sender: TObject);
    procedure EscalaPaint(Sender: TObject);
    procedure Escala_XPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnLegClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnValoresClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure btnOpcoesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Menu_FecharClick(Sender: TObject);
    procedure Menu_EstatisticasClick(Sender: TObject);
    procedure Menu_Fixar_um_PontoClick(Sender: TObject);
    procedure Menu_AutoReduzirClick(Sender: TObject);
    procedure Menu_CopiarClick(Sender: TObject);
    procedure ZoomClick(Sender: TObject; Button: TUDBtnType);
    procedure edZoomKeyPress(Sender: TObject; var Key: Char);
    procedure Definir_MaximoClick(Sender: TObject);
    procedure Menu_PlotarMaximosClick(Sender: TObject);
  private
    nPontos            : Integer;  {Número de linhas do DataSet}
    PontosNaTela       : Integer;
    MeioZoom           : Integer;
    Yi1, Yf1, Yi2, Yf2 : Integer;  {Coordenadas Reais}
    PMax1, PMax2       : Double;     {Valores virtuais máximos}
    pMax1Original      : Double;
    Yv1, Yv2           : Double;     {Valores virtuais a serem plotados}
    Yr1, Yr2           : Integer;  {Coordenadas reais a serem plotadas}
    DXi, DXf           : Integer;  {Deslocamentos inicial e final}
    Pos_i, Pos_f       : Integer;
    FDS                : TwsDataSet;
    i_Clicks           : Byte;     {quantidades de clicks}
    i_X1, i_X2         : Integer;  {coordenadas X}
    b_FixaValores      : Boolean;  {Fixa a legenda}
    Leg                : TLeg_Chuva_X_Vazao_Form;
    Vals               : TValores_Chuva_X_Vazao_Form;
    //Estat              : TDLG_Estat;
    FPostosDeChuva: TStrings;
    FPostosDeVazao: TStrings;
    Procedure SetDados(DS: TwsDataSet);
    Function Calculo1(PAtual: Double): Integer;
    Function Calculo2(PAtual: Double): Integer;
    Function Media(X1, X2, Index: Integer): Double;
    Procedure DesenhaEscala_Y;
    Procedure DesenhaEscala_X(i, p: Integer);
    Procedure SetDeltas(x1, x2: Integer);
    Procedure PlotaGrafico(Canvas: TCanvas; ToClipboard: Boolean = False);
    procedure SetPostosDeChuva(const Value: TStrings);
    procedure SetPostosDeVazao(const Value: TStrings);
    procedure SpinChange;
  public
    aZoom : Integer;
    Property PostosDeChuva: TStrings Read FPostosDeChuva Write SetPostosDeChuva;
    Property PostosDeVazao: TStrings Read FPostosDeVazao Write SetPostosDeVazao;
    Property Dados: TwsDataset       Read FDS            Write SetDados;

    Constructor CriaGrafico_Chuva_X_Vazao(
       Dados: TwsDataSet;
       PostosDeChuva: TStrings;
       PostosDeVazao: TStrings
       );
  end;

implementation
Uses wsConstTypes, SysUtilsEx, wsGLIB, Clipbrd;

{$R *.DFM}

Const DY = 16; {Separação entre os gráficos}

Function Max(DS: TwsDataSet; Col: Integer): Double;
Begin
  Result := wsMatrixMax(DS, Col, 1, DS.nRows);
End;

Function TGraf_Chuva_X_Vazao_Form.Media(X1, X2, Index: Integer): Double;
Begin
  Try
    Result := wsMatrixMean(FDS, Index, X1, X2);
  Except
    Result := -1;
  End;
End;

Procedure TGraf_Chuva_X_Vazao_Form.SetDeltas(x1, x2: Integer);
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

  If FDS <> Nil Then HChange(nil);

  b_FixaValores := (X1 = X2) and (X1 > -1);
  If b_FixaValores Then
     Begin
     {Estat.Hide;}
     Vals.Show;
     End;
End;

Procedure TGraf_Chuva_X_Vazao_Form.SetDados(DS: TwsDataSet);
Var aux: Double;
Begin
  FDS := DS;
  If (DS.nRows > 0) and (DS.nCols > 0) Then
     nPontos := DS.nRows
  Else
     Raise Exception.Create('Dados inválidos');
End;

{Gráfico de linhas}
Function TGraf_Chuva_X_Vazao_Form.Calculo1(PAtual: Double): Integer;
Begin
  {Calculo do ponto a ser plotado}
  If (PAtual <> wscMissValue) Then
     Begin
     Yv1 := PAtual * (Yf2 - Yi2) / PMax1;
     Result := Trunc(Yf2 - Yv1);
     if (Result < Yi2) then
        if not Menu_PlotarMaximos.Checked then
           Result := Yf2 + 10 {Não é para ser plotado}
        else
           Result := Yi2;
     End
  Else
     Result := Yf2 + 10; {Não é para ser plotado}
End;

{Gráfico de barras}
Function TGraf_Chuva_X_Vazao_Form.Calculo2(PAtual: Double): Integer;
Begin
  {Calculo do ponto a ser plotado}
  If (PAtual <> wscMissValue) Then
     Result := Trunc(PAtual * Yf1 / PMax2)
  Else
     Result := -1; {Não é para ser plotado}
End;

Procedure TGraf_Chuva_X_Vazao_Form.DesenhaEscala_Y;
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

Procedure TGraf_Chuva_X_Vazao_Form.DesenhaEscala_X(i, p: Integer);
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

procedure TGraf_Chuva_X_Vazao_Form.HChange(Sender: TObject);
begin
  PlotaGrafico(Self.Canvas);
end;

procedure TGraf_Chuva_X_Vazao_Form.FormResize(Sender: TObject);
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

  SpinChange;
end;

procedure TGraf_Chuva_X_Vazao_Form.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TGraf_Chuva_X_Vazao_Form.FormPaint(Sender: TObject);
begin
  HChange(nil);
end;

procedure TGraf_Chuva_X_Vazao_Form.EscalaResize(Sender: TObject);
begin
  DesenhaEscala_Y;
end;

procedure TGraf_Chuva_X_Vazao_Form.EscalaPaint(Sender: TObject);
begin
  DesenhaEscala_Y;
end;

procedure TGraf_Chuva_X_Vazao_Form.Escala_XPaint(Sender: TObject);
begin
  DesenhaEscala_X(Pos_i, Pos_f);
end;

procedure TGraf_Chuva_X_Vazao_Form.FormShow(Sender: TObject);
var i,i2: Integer;
begin
  If Not Assigned(FDS) Then
     Raise Exception.Create('Não há dados a serem analisados');

  Canvas.brush.color := clBlack;
  Canvas.Pen.color := clgreen;

  //SpinChange; {inicializa parametros}
  FormResize(Sender);
end;

procedure TGraf_Chuva_X_Vazao_Form.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TGraf_Chuva_X_Vazao_Form.FormDestroy(Sender: TObject);
begin
  Leg.Free;
  Vals.Free;
  FPostosDeVazao.Free;
  FPostosDeChuva.Free;
end;

procedure TGraf_Chuva_X_Vazao_Form.btnLegClick(Sender: TObject);
begin
  Leg.Show;
end;

procedure TGraf_Chuva_X_Vazao_Form.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var S      : String[30];
    Yc     : Double;
    DeltaT : Integer;
begin
  S := '';
  DeltaT := Pos_i + ((X + MeioZoom) div aZoom);
  If (Not b_FixaValores) and (Vals.Visible) Then Vals.Delta := DeltaT;
end;

procedure TGraf_Chuva_X_Vazao_Form.btnValoresClick(Sender: TObject);
begin
  Vals.Show;
end;

procedure TGraf_Chuva_X_Vazao_Form.FormClick(Sender: TObject);
var XAtual  : Integer;
    P       : TPoint;
begin
  GetCursorPos(P);
  P := ScreenToClient(P);
  XAtual := Pos_i + (P.X div aZoom);
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
       i_Clicks := 0;
       End;
    End;
end;

procedure TGraf_Chuva_X_Vazao_Form.btnOpcoesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var P: TPoint;
begin
  P := Point(btnOpcoes.Left, btnOpcoes.Top);
  P := Info.ClientToScreen(P);
  Menu.Popup(P.x, P.y);
end;

procedure TGraf_Chuva_X_Vazao_Form.Menu_FecharClick(Sender: TObject);
begin
  Close;
end;

procedure TGraf_Chuva_X_Vazao_Form.Menu_EstatisticasClick(Sender: TObject);
begin
  //Estat.ShowEstatistics(Dados, i_X1, i_X2);
end;

procedure TGraf_Chuva_X_Vazao_Form.Menu_Fixar_um_PontoClick(Sender: TObject);
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
    if Vals.Visible then Vals.Delta := n;
    b_FixaValores := True;
  Except
    MessageDLG('Voce não digitou um valor válido', mtError, [mbOK], 0);
  End;
end;

procedure TGraf_Chuva_X_Vazao_Form.Menu_AutoReduzirClick(Sender: TObject);
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

procedure TGraf_Chuva_X_Vazao_Form.Menu_CopiarClick(Sender: TObject);
Const AL = 20;
var B: TBitmap;
begin
  B  := TBitmap.Create;
  Try
    B.Width  := ClientRect.Right;
    B.Height := Suporte1.Top - 1 + AL;

    BitBlt(B.Canvas.Handle, 0,0, B.Width, B.Height - AL,
         Canvas.Handle, 0, 0, SRCCOPY);

    PlotaGrafico(B.Canvas, True);

    {Desenha Legenda na clipboard}
    With B.Canvas Do
      Begin
      TextOut(5,  B.Height - AL + 2, 'PLU x ');

      //If (FDS.Tag_2 = cCalibracao) Then
         Begin
         Pen.Style := psDot;
         MoveTo (60, B.Height - AL div 2); LineTo(80, B.Height - AL div 2);
         TextOut(90, B.Height - AL + 2, 'VZO');

         Pen.Style := psSolid;
         MoveTo (140, B.Height - AL div 2); LineTo(160, B.Height - AL div 2);
         TextOut(170, B.Height - AL + 2, 'VZC');
         End;
      //Else
{
         Begin
         Pen.Style := psSolid;
         MoveTo (60, B.Height - AL div 2); LineTo(160, B.Height - AL div 2);
         TextOut(90, B.Height - AL + 2, 'VZC');
         End;
}
      End;

    Clipboard.Assign(B);
  Finally
    B.Free;
  End;
end;

Procedure TGraf_Chuva_X_Vazao_Form.PlotaGrafico(Canvas: TCanvas; ToClipboard: Boolean = False);
var w, p, vw, i, j, x   : Integer;
    r                   : TRect;
    s                   : String[10];
    Col                 : Integer;
    Aux                 : Integer;
    ind_PostoDeChuva    : Integer;
    ind_PostoDeVazao    : Integer;
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

    inc(r.Bottom, 5);
    FillRect(r);

    {Desenha o gráfico de linhas para cada posto de Chuva}
    For Col := 0 To PostosDeVazao.Count - 1 do
      Begin
      ind_PostoDeVazao := FDS.Struct.IndexOf(GetValidID(FPostosDeVazao[Col]));
      x := DXi;  {Inicio Virtual}
      Pen.Style := psSolid;

      If ToClipboard Then
         Pen.Color := clBlack
      Else
         Pen.Color := TColor(FPostosDeVazao.Objects[Col]);

      moveto(x, Calculo1(Dados[p, ind_PostoDeVazao]));
      for i := 1 to Aux do
        Begin
        inc(x, aZoom);
        lineto( x, Calculo1(Dados[i + p, ind_PostoDeVazao]) );
        End;
      End; {For Col ...}

    {Desenha gráfico de barras}
    if FPostosDeChuva.Count > 0 then
       for j := 0 to FPostosDeChuva.Count-1 do
          begin
          ind_PostoDeChuva := FDS.Struct.IndexOf(GetValidID(FPostosDeChuva[j]));
          x := DXi; {Inicio Virtual}

          If ToClipboard Then
             Pen.Color := clBlack
          Else
             Pen.Color := TColor(FPostosDeChuva.Objects[j]);

          r.Top := 0;
          for i := 1 to Aux do
            Begin
            If aZoom > 2 Then  r.Left  := x + MeioZoom else r.Left  := x+1;
            inc(x, aZoom);
            If aZoom > 2 Then  r.Right := x + MeioZoom else r.Right := x+1;
            r.Bottom := Calculo2(FDS[i + p, ind_PostoDeChuva]);
            Rectangle(r.left, r.top, r.right, r.bottom);
            End;
          end;

    End; {With Canvas ...}

  Pos_i := p; Pos_f := i+p-1;
  If Not ToClipboard Then DesenhaEscala_X(Pos_i, Pos_f);
End;

procedure TGraf_Chuva_X_Vazao_Form.ZoomClick(Sender: TObject; Button: TUDBtnType);
begin
  SpinChange;
end;

procedure TGraf_Chuva_X_Vazao_Form.SetPostosDeChuva(const Value: TStrings);
var aux : Double;
    i   : Integer;
begin
  FPostosDeChuva.Assign(Value);

  // Obtém o valor máximo dos postos de vazão
  PMax2 := 0;
  if FPostosDeChuva.Count > 0 then
     for i := 0 to Value.Count - 1 do
       begin
       aux := Max(FDS, FDS.Struct.IndexOf(GetValidID(Value[i])));
       If aux > PMax2 Then PMax2 := aux;
       end;
end;

procedure TGraf_Chuva_X_Vazao_Form.SetPostosDeVazao(const Value: TStrings);
var aux : Double;
    i   : Integer;
begin
  FPostosDeVazao.Assign(Value);

  // Obtém o valor máximo dos postos de vazão
  PMax1 := 0;
  if FPostosDeVazao.Count > 0 then
     for i := 0 to Value.Count - 1 do
       begin
       aux := Max(FDS, FDS.Struct.IndexOf(GetValidID(Value[i])));
       If aux > PMax1 Then PMax1 := aux;
       end;
  pMax1Original := PMax1;
end;

constructor TGraf_Chuva_X_Vazao_Form.CriaGrafico_Chuva_X_Vazao(Dados: TwsDataSet;
  PostosDeChuva, PostosDeVazao: TStrings);
begin
  FPostosDeVazao := TStringList.Create;
  FPostosDeChuva := TStringList.Create;

  i_Clicks           := 0;
  Self.Dados         := Dados;
  Self.PostosDeChuva := PostosDeChuva;
  Self.PostosDeVazao := PostosDeVazao;

  Inherited Create(nil);

  Leg                := TLeg_Chuva_X_Vazao_Form.Create(Self);
  Leg.PostosDeChuva  := FPostosDeChuva;
  Leg.PostosDeVazao  := FPostosDeVazao;

  Vals               := TValores_Chuva_X_Vazao_Form.Create(Self);
  Vals.Dados         := Dados;
  Vals.PostosDeChuva := FPostosDeChuva;
  Vals.PostosDeVazao := FPostosDeVazao;

  //Estat := TDLG_Estat.Create(Self);
  SetDeltas(-1, -1);
end;

procedure TGraf_Chuva_X_Vazao_Form.SpinChange;
var r: TRect;
begin
  Try
    aZoom := StrToInt(edZoom.Text);
  except
    aZoom := Zoom.Position;
  end;

  MeioZoom := aZoom div 2;
  r := ClientRect;
  PontosNaTela := (r.Right - DXi - DXf - 1) div aZoom;
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

procedure TGraf_Chuva_X_Vazao_Form.edZoomKeyPress(Sender: TObject; var Key: Char);
begin
  Case Key of
    '0'..'9'    : {Nada} ;
    #08 {BACK}  : {Nada} ;
    #13 {ENTER} : SpinChange;
    Else          Key := #0;
    end;
end;

procedure TGraf_Chuva_X_Vazao_Form.Definir_MaximoClick(Sender: TObject);
var s, s1: String;
    n    : Double;
begin
  s1 := Format('Digite um número entre 0 e %.2f', [pMax1Original]);
  s  := InputBox('Para fornecer um novo valor máximo...', s1, FloatToStr(pMax1Original));
  Try
    n := StrToFloat(s);
    If (n < 0) or (n > pMax1Original) Then Raise Exception.Create('Erro');
    pMax1 := n;
    DesenhaEscala_Y;
    PlotaGrafico(Self.Canvas);
  Except
    MessageDLG('Voce não digitou um valor válido', mtError, [mbOK], 0);
  End;
end;

procedure TGraf_Chuva_X_Vazao_Form.Menu_PlotarMaximosClick(Sender: TObject);
begin
  Menu_PlotarMaximos.Checked := not Menu_PlotarMaximos.Checked;
  HChange(nil);
end;

end.
