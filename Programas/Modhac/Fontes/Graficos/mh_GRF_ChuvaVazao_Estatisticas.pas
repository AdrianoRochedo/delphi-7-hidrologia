unit mh_GRF_ChuvaVazao_Estatisticas;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Buttons, wsMath, wsGlib,
  //wsCVec,
  wsMatrix;

type
  TDLG_Estat = class(TForm)
    Painel: TPanel;
    Nome1: TLabel;
    Lab_X: TLabel;
    LabVOMAX: TLabel;
    LabVOMIN: TLabel;
    L_DeltaT: TLabel;
    LabVCMAX: TLabel;
    LabVCMIN: TLabel;
    LabVOMED: TLabel;
    LabVODSV: TLabel;
    LabVCMED: TLabel;
    LabVCDSV: TLabel;
    LabVZCV: TLabel;
    LabVZVOL: TLabel;
    LabVCCV: TLabel;
    LabVCVOL: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label6: TLabel;
    foTIPO: TLabel;
    L1: TLabel;
    vzoMAX: TLabel;
    vzoMED: TLabel;
    vzoMIN: TLabel;
    vzcMAX: TLabel;
    vzcMED: TLabel;
    vzcMIN: TLabel;
    vzoDSV: TLabel;
    vzoCV: TLabel;
    vzcDSV: TLabel;
    vzcCV: TLabel;
    vzcVOL: TLabel;
    vzoVOL: TLabel;
    Delta_Ini: TLabel;
    Delta_Fim: TLabel;
    foValue: TLabel;
    btnClose: TSpeedButton;
    Bevel4: TBevel;
    labVZO: TLabel;
    labVZC: TLabel;
    Bevel5: TBevel;
    Label9: TLabel;
    Bevel6: TBevel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    pluMAX: TLabel;
    pluMED: TLabel;
    pluMIN: TLabel;
    pluDSV: TLabel;
    pluCV: TLabel;
    pluVOL: TLabel;
    labNome: TLabel;
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnFecharClick(Sender: TObject);
    procedure Medidas_Click(Sender: TObject);
  private
    Movendo  : Boolean;
    DX,DY    : Integer;
    //FShowPLU : Boolean;
    Procedure SetShowPLU(Value: Boolean);

    function  Modulacao       (X1,X2: Longint; DS: TwsDataset): Double;
    function  DesvioPadrao    (X1,X2: Longint; DS: TwsDataset): Double;
    function  MinimoQuadrados (X1,X2: Longint; DS: TwsDataset): Double;
    function  ValorAbsoluto   (X1,X2: Longint; DS: TwsDataset): Double;
    function  Logaritmica     (X1,X2: Longint; DS: TwsDataset): Double;
  public
    Procedure ShowEstatistics(DS: TwsDataSet; Ini, Fim: Longint);
    Property  ShowPLU: Boolean Write SetShowPLU;
  end;

implementation
uses wsConstTypes,
     Math,
     mh_TCs,
     mh_Procs;

{$R *.DFM}

Procedure TDLG_Estat.SetShowPLU(Value: Boolean);
Var Tam,i : Integer;
Begin
  (*
  FShowPLU := Value;
  If Value Then
     Tam := Label9.Left + Label9.Width + 20
  Else
     Tam := Label8.Left + Label8.Width + 20;

  Self.Width := Tam;
  btnClose.Left := Tam - btnClose.Width - 8;
  For i := 1 to 4 do
    TBevel(FindComponent('Bevel' + IntToStr(i))).Width := Tam - 20;
  *)
End;

Procedure TDLG_Estat.ShowEstatistics(DS: TwsDataSet; Ini, Fim: Longint);

  Procedure SetValue(L: TLabel; Value: Double);
  Begin
    If Value <> wsConstTypes.wscMissValue Then
       L.Caption := Format('%4.2f', [Value])
    Else
       L.Caption := 'N.Def';
  End;

var Somados: Longint;
    Aux: Double;
    FO, Unidade: Byte;
    b: boolean;
Begin
  Screen.Cursor := crHourGlass;
  Try
    labNome.Caption := ' Sub-Bacia: ' + DS.MLab;

    Delta_INI.Caption := IntToStr(Ini);
    Delta_FIM.Caption := IntToStr(Fim);

    Get_FO_Unidade(DS.Tag_1, FO, Unidade);

    If Unidade = cMM Then
       Begin
       labVZO.Caption := 'VAZÕES OBSERVADAS (mm)';
       labVZC.Caption := 'VAZÕES CALCULADAS (mm)';
       End
    Else
       Begin
       labVZO.Caption := 'VAZÕES OBSERVADAS (m3/s)';
       labVZC.Caption := 'VAZÕES CALCULADAS (m3/s)';
       End;

    If (DS.Tag_2 <> cSimulacao) Then
       Begin
       SetValue(vzoMAX, wsMatrixMax (DS, cVZO, Ini, Fim, b));
       SetValue(vzoMED, wsMatrixMean(DS, cVZO, Ini, Fim, b));
       Aux := wsMatrixMin (DS, cVZO, Ini, Fim, b);
       If (Aux < 0) and (Aux <> wsConstTypes.wscMissValue) Then Aux := 0;
       SetValue(vzoMIN, Aux);
       End;

    SetValue(vzcMAX, wsMatrixMax (DS, cVZC, Ini, Fim, b));
    SetValue(vzcMED, wsMatrixMean(DS, cVZC, Ini, Fim, b));
    Aux := wsMatrixMin (DS, cVZC, Ini, Fim, b);
    If (Aux < 0) and (Aux <> wsConstTypes.wscMissValue) Then Aux := 0;
    SetValue(vzcMIN, Aux);

    SetValue(pluMAX, wsMatrixMax (DS, cPLU, Ini, Fim, b));
    SetValue(pluMED, wsMatrixMean(DS, cPLU, Ini, Fim, b));
    Aux := wsMatrixMin (DS, cPLU, Ini, Fim, b);
    If (Aux < 0) and (Aux <> wsConstTypes.wscMissValue) Then Aux := 0;
    SetValue(pluMIN, Aux);

    If (DS.Tag_2 <> cSimulacao) Then
       Begin
       SetValue(vzoDSV, wsMatrixDSP (DS, cVZO, Ini, Fim, b));
       SetValue(vzoCV , wsMatrixCV  (DS, cVZO, Ini, Fim, b));
       SetValue(vzoVOL, wsMatrixSum (DS, cVZO, Ini, Fim, Somados, b));
       End;

    SetValue(vzcDSV, wsMatrixDSP (DS, cVZC, Ini, Fim, b));
    SetValue(vzcCV , wsMatrixCV  (DS, cVZC, Ini, Fim, b));
    SetValue(vzcVOL, wsMatrixSum (DS, cVZC, Ini, Fim, Somados, b));

    SetValue(pluDSV, wsMatrixDSP (DS, cPLU, Ini, Fim, b));
    SetValue(pluCV , wsMatrixCV  (DS, cPLU, Ini, Fim, b));
    SetValue(pluVOL, wsMatrixSum (DS, cPLU, Ini, Fim, Somados, b));

    {Seta o valor da Função Objetivo}
    foTIPO.Caption := CodToFObjetive(FO);
    L1.Left        := foTIPO.Width + foTIPO.Left + 10;
    foValue.Left   := L1.Width + L1.Left + 10;

    If FO = cLogaritmica Then
       SetValue(foValue, Logaritmica(Ini, Fim, DS))

    Else If FO = cValorABS Then
       SetValue(foValue, ValorAbsoluto(Ini, Fim, DS))

    Else If FO = cFatorModulacao Then
       SetValue(foValue, Modulacao(Ini, Fim, DS))

    Else If FO = cMinQuad Then
       SetValue(foValue, MinimoQuadrados(Ini, Fim, DS));

    Show;

  Finally
    Screen.Cursor := crDefault;
  End;
End; {ShowEstatistics}

procedure TDLG_Estat.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DX := X + TGraphicControl(Sender).Left;
  DY := Y + TGraphicControl(Sender).Top;
  Movendo := true;
end;

procedure TDLG_Estat.FormCreate(Sender: TObject);
begin
  Movendo := False;
  ShowPLU := True;
end;

procedure TDLG_Estat.MouseMove(Sender: TObject; Shift: TShiftState; X,
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

procedure TDLG_Estat.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Movendo := False;
end;

procedure TDLG_Estat.btnFecharClick(Sender: TObject);
begin
  Close;
end;

{---------------------------------------------------------}

{OBS: Valores perdidos não entram nas estatísticas}

function TDLG_Estat.Modulacao (X1,X2 :Longint; DS: TwsDataset): Double;
Var i   : Longint;
    VZO : Double;
    VZC : Double;
begin
  Result := 0;
  For i := X1 to X2 do
    Begin
    VZO := DS[i, cVZO];
    VZC := DS[i, cVZC];
    If (VZO <> wsConstTypes.wscMissValue) and (VZC <> wsConstTypes.wscMissValue) Then
       Result := Result + ( SQR(VZO + VZC) / (VZO + VZC) ) / 2;
    End;
end;

function TDLG_Estat.DesvioPadrao (X1,X2 :Longint; DS: TwsDataset): Double;
var b: boolean;
begin
  Result := wsMatrixDSP(DS, cVZO, X1, X2, b);
end;

function TDLG_Estat.MinimoQuadrados (X1,X2 :Longint; DS: TwsDataset): Double;
Var i   : Longint;
    VZO, VZC : Double;
begin
  Result := 0;
  For i := X1 to X2 do
    Begin
    VZO := DS[i, cVZO];
    VZC := DS[i, cVZC];
    If (VZO <> wsConstTypes.wscMissValue) and (VZC <> wsConstTypes.wscMissValue) Then
       Result := (Result + ( SQR( VZO - VZC )));
    End;

  Try
    Result := 100 * (Result / DesvioPadrao (X1, X2, DS));
  Except
    Result := 0;
  End;
end;

function TDLG_Estat.ValorAbsoluto (X1,X2 :Longint; DS: TwsDataset): Double;
Var i   : Longint;
    DP  : Double;
    VZO, VZC : Double;
begin
  Result := 0;
  For i := X1 to X2 do
    Begin
    VZO := DS[i, cVZO];
    VZC := DS[i, cVZC];
    If (VZO <> wsConstTypes.wscMissValue) and (VZC <> wsConstTypes.wscMissValue) Then
       Result := Result + ABS( VZO - VZC );
    End;

  DP := DesvioPadrao (X1, X2, DS);
  If DP > 0 Then
     Result := Result / Sqrt( DP )
  Else
     Result := 0;
end;

function TDLG_Estat.Logaritmica (X1,X2 :Longint; DS: TwsDataset): Double;
Var i, ii        : Longint;
    Soma         : Double;
    L            : Double;
    mediaDosLogs : Double;
    VZO,VZC      : Double;
begin
  Result := 0;
  Soma   := 0;

  {Calcula a média dos Logs de VZO ------------------------}

  ii := 0;
  mediaDosLogs := 0;
  For i := X1 to X2 do
    Begin
    VZO := DS[i, cVZO];
    If VZO <> wsConstTypes.wscMissValue Then
       Begin
       Inc(ii);
       mediaDosLogs := mediaDosLogs + Log10(VZO); // ???? log10 ou log2
       End;
    End;

  If ii > 0 Then
     mediaDosLogs := mediaDosLogs / ii;

  {Fim do calculo da média dos Logs de VZO ------------------------}

  For i := X1 to X2 do
    begin
    VZO := DS[i, cVZO];
    VZC := DS[i, cVZC];
    If (VZO <> wsConstTypes.wscMissValue) and (VZC <> wsConstTypes.wscMissValue) Then
       Begin
       L := Log10(VZO); // ???? log10 ou log2
       Result := Result + sqr( L - Log10(VZC) );
       Soma   :=   Soma + sqr( L - mediaDosLogs );
       End;
    end;

  Try
    Result := 100 * (Result / Soma);
  Except
    Result := 0;
  End;
end;

procedure TDLG_Estat.Medidas_Click(Sender: TObject);
var i: Integer;
    f: Single;
begin
  For i := 0 to ComponentCount - 1 do
    If (Components[i] is TLabel) and
       ((TLabel(Components[i]).Name[1] = 'v') or (TLabel(Components[i]).Name[1] = 'p')) Then
       Try
         f := strToFloat(TLabel(Components[i]).Caption);
         If TRadioButton(Sender).Name = 'R1' Then
            TLabel(Components[i]).Caption := Format('%4.2f', [f + 100])
         Else
            TLabel(Components[i]).Caption := Format('%4.2f', [f - 100]);
       Except
         {Nada}
       End;
end;

end.
