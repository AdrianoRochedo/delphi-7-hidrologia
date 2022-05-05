unit ETP;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, gridx32, drEdit, CH_Const, CH_Tipos;

type
  TDLG_ETP = class(TForm)
    L_IntComp: TLabel;
    cbIntComp: TComboBox;
    Bevel1: TBevel;
    Label2: TLabel;
    Grid: TdrStringAlignGrid;
    Panel1: TPanel;
    Bevel2: TBevel;
    Open: TOpenDialog;
    Save: TSaveDialog;
    btnFechar: TBitBtn;
    Bevel3: TBevel;
    btnSalvar: TBitBtn;
    btnCarregar: TBitBtn;
    btnLimpar: TBitBtn;
    btnGerar: TBitBtn;
    Label4: TLabel;
    L1: TLabel;
    edNumAnos: TdrEdit;
    R1: TRadioButton;
    R2: TRadioButton;
    edArquivo: TEdit;
    L2: TLabel;
    SaveETP: TSaveDialog;
    btnImprimir: TBitBtn;
    Painel: TPanel;
    Label3: TLabel;
    Label5: TLabel;
    btnDiario: TButton;
    cbIntSim: TComboBox;
    edAnoBase: TdrEdit;
    procedure FormShow(Sender: TObject);
    procedure cbIntSimChange(Sender: TObject);
    procedure btnDiarioClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCarregarClick(Sender: TObject);
    Procedure SaveToFile(Const Name: String);
    Procedure LoadFromFile(Const Name: String);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure cbIntCompChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
  private
    Finfo     : TDSInfo;
    slInicial : TStrings;
    slFinal   : TStrings;
    IS_Antigo : Integer;
    FTipo     : String;
    procedure ClearGrid;
    procedure AtualizaTela;
    Function VerificaDados: Boolean;
    Function Ajusta(Linha, Ini, Fim: Integer): String;
  public
    constructor Create(Info: TDSInfo; const Tipo: String);
    property Tipo: String read FTipo write FTipo;    // ETP/RET
  end;

implementation
uses ETP_Media, SysUtilsEx, wsOutPut, ch_Procs, ErrosDLG, stDate, WinUtils;

{$R *.DFM}

Const
  cIntervalos: Array[1..5, 1..6] of string[7] =
    (
      ('1 a 5','6 a 10','11 a 15','16 a 20','21 a 25','26 a 31'),
      ('1 a 7','8 a 14','15 a 21','22 a 31','',''),
      ('1 a 10','11 a 20','21 a 31','','',''),
      ('1 a 15','16 a 31','','','',''),
      ('1 a 31','','','','','')
    );

  MSG_Local_1 = 'Atenção. Cuidado com a utilização de arquivos %s.'#13 +
                'Podem ocorrer incoerências! Verifique.';

constructor TDLG_ETP.Create(Info: TDSInfo; const Tipo: String);
begin
  Inherited Create(nil);
  FInfo := Info;
  FTipo := Tipo;
end;

procedure TDLG_ETP.FormShow(Sender: TObject);
var i             : Integer;
    Ano, Mes, Dia : Word;
begin
  cbIntComp.Visible := (Tipo = 'ETP');
  L_IntComp.Visible := cbIntComp.Visible;
  if cbIntComp.Visible then
     begin
     Caption := ' Criação do arquivo de Evapotranspiração Potencial (ETP)';
     Painel.Left := 144;
     cbIntComp.SetFocus;

     SaveETP.Filter := 'Arquivo ETP (*.ETP)|*.ETP' + cTodos;
     SaveETP.Title  := 'Gerar arquivo ETP';
     SaveETP.DefaultExt := 'ETP';

     Save.Filter := 'Definição de ETP (*.DFE)|*.DFE' + cTodos;
     Save.Title  := 'Salva o aquivo de definição de ETP';
     Save.DefaultExt := 'DFE';

     Open.Filter := 'Definição de ETP (*.DFE)|*.DFE|Definição de VZO (*.DFV)|*.DFV|Definição de PLU (*.DFP)|*.DFP' + cTodos;
     Open.Title  := 'Abertura do aquivo de definição de ETP';
     Open.DefaultExt := 'DFE';
     end
  else
     begin
     Caption := ' Criação do arquivo de Evapotranspiração sobre Reservatório (RET)';
     Painel.Left := 11;
     cbIntSim.SetFocus;

     SaveETP.Filter := 'Arquivo RET (*.RET)|*.RET' + cTodos;
     SaveETP.Title  := 'Gerar arquivo RET';
     SaveETP.DefaultExt := 'RET';

     Save.Filter := 'Definição de RET (*.DER)|*.DER' + cTodos;
     Save.Title  := 'Salva o aquivo de definição de RET';
     Save.DefaultExt := 'DER';

     Open.Filter := 'Definição de RET (*.DER)|*.DER' + cTodos;
     Open.Title  := 'Abertura do aquivo de definição de RET';
     Open.DefaultExt := 'DER';
     end;

  //pDados := gList[gIndexFile];
  slInicial := TStringList.Create;
  slFinal   := TStringList.Create;

  DecodeDate(Date, Ano, Mes, Dia);
  edAnoBase.AsInteger := Ano;
  //edAnoBase.RangeHi := IntToStr(Ano);

  Grid.AlignCol[0] := alLeft;
  cbIntComp.ItemIndex := cINTCOMP_DIARIO;
  cbIntSim.ItemIndex := 0;
  cbIntSimChange(Sender);
  IS_Antigo := 0;

  For i := 1 to 12 do
    Grid.Cells[0, i] := ' ' + LongMonthNames[i];
end;

procedure TDLG_ETP.cbIntSimChange(Sender: TObject);
var n, i: Integer;
begin
  btnDiario.Visible := (cbIntSim.ItemIndex = 0);

  Case cbIntSim.ItemIndex of
    0: n := 1;
    1: n := 5;
    2: n := 7;
    3: n := 10;
    4: n := 15;
    5: n := 31;
    End;

  if IS_Antigo = 0 then
     for i := 1 to 12 do
       Case n of
         5: begin
            Grid.Cells[1, i] := Ajusta(i, 1, 5);
            Grid.Cells[2, i] := Ajusta(i, 6, 10);
            Grid.Cells[3, i] := Ajusta(i, 11, 15);
            Grid.Cells[4, i] := Ajusta(i, 16, 20);
            Grid.Cells[5, i] := Ajusta(i, 21, 25);
            Grid.Cells[6, i] := Ajusta(i, 26, 31);
            end;

         7: begin
            Grid.Cells[1, i] := Ajusta(i, 1, 7);
            Grid.Cells[2, i] := Ajusta(i, 8, 14);
            Grid.Cells[3, i] := Ajusta(i, 15, 21);
            Grid.Cells[4, i] := Ajusta(i, 22, 31);
            end;

         10: begin
             Grid.Cells[1, i] := Ajusta(i, 1, 10);
             Grid.Cells[2, i] := Ajusta(i, 11, 20);
             Grid.Cells[3, i] := Ajusta(i, 21, 31);
             end;

         15: begin
             Grid.Cells[1, i] := Ajusta(i, 1, 15);
             Grid.Cells[2, i] := Ajusta(i, 16, 31);
             end;

         31: begin
             Grid.Cells[1, i] := Ajusta(i, 1, 31);
             end;
          end // case
  else
     if cbIntSim.ItemIndex <> IS_Antigo then
        MessageDLG('Cuidado !'#13 +
                   'Na mudança de um intervalo para outro, verifique'#13 +
                   'se a média ou soma está correta.',
                   mtWarning, [mbOK], 0);

  Grid.ColCount := 31 div n + 1;
  If Grid.ColCount <= 7 Then n := 0 Else n := GetSystemMetrics(SM_CYHSCROLL);

  Height := 475 + n;
  Panel1.Top := 365 + n;
  Grid.Height := 251 + n;

  ClearGrid;

  If cbIntSim.ItemIndex > 0 Then
     For n := 1 to Grid.ColCount - 1 do
       Grid.Cells[n, 0] := cIntervalos[cbIntSim.ItemIndex, n]
  Else
     For n := 1 to 31 do
       Grid.Cells[n, 0] := IntToStr(n);

  Grid.Col := 1; Grid.Row := 1;
  Grid.SetFocus;
  IS_Antigo := cbIntSim.ItemIndex;
end;

procedure TDLG_ETP.ClearGrid;
var i,j: Integer;
begin
  For i := 1 to Grid.ColCount - 1 do
    For j := 1 to Grid.RowCount - 1 do
      If Grid.Cells[i,j] = '' Then
         Grid.Cells[i,j] := Format('0%s00', [DecimalSeparator]);
end;

procedure TDLG_ETP.btnDiarioClick(Sender: TObject);
var Dias          : Integer;
    Ano, Mes, Dia : Word;
    Col, Lin      : Integer;
    Cont          : Integer;
    d             : TDLG_ETP_Media;

    procedure NextDay;
    Begin
      Inc(Col);
      If Col > 31 Then
         Begin
         Inc(Lin);
         Col := 1;
         End;
    End;

begin
  d := TDLG_ETP_Media.Create(nil);
  d.AnoBase := edAnoBase.AsInteger;
  If (edAnoBase.AsInteger = 0) or (edAnoBase.AsInteger = 1900) Then
     begin
     DecodeDate(Date, Ano, Mes, Dia);
     d.AnoBase := Ano;
     end;

  If d.ShowModal = mrCancel Then Exit;
  Dias := Trunc(d.DataFim - d.DataIni);

  DecodeDate(d.DataIni, Ano, Mes, Dia);
  Col := Dia; Lin := Mes;

  cont := 0;
  While cont <= Dias do
    Begin
      Try
        EncodeDate(edAnoBase.AsInteger, Lin, Col);
      Except
        NextDay;
        Continue;
      End;
    Grid.Cells[Col, Lin] := AllTrim(d.Valor.Text);
    NextDay;
    inc(Cont);
    End;
  d.Free;
end;

Function TDLG_ETP.VerificaDados: Boolean;
var i,j: Integer;
    s: String;
    f: real;
begin
  Result := true;
  s := '';
  For j := 1 to Grid.RowCount - 1 do
    begin
    For i := 1 to DaysInMonth(j, edAnoBase.AsInteger, 0) do
        begin
          Try
            f := strToFloat(allTrim(Grid.Cells[i, j]));
          Except
            MessageDLG(Format('O valor < %s > na posição [Linha = %d, Coluna = %d] é inválido',
                       [Grid.Cells[i, j], j, i]), mtError, [mbOK], 0);
            Result := False;
            Exit;
            end;

          if f = 0.0 then
             begin
             MessageDLG(Format('Na posição [Linha = %d, Coluna = %d] existe um valor nulo.'#13 +
                               'Verifique também as outras posições.',
                        [j, i]), mtError, [mbOK], 0);
             result := False;
             exit;
             end;
        end;
    end;
End;

procedure TDLG_ETP.btnOkClick(Sender: TObject);

  // O arquivo escrito para o Modhac precisa ter ponto decimal = '.'
  Procedure EscreveDados(MesIni, MesFim: Integer);
  var s           : String;
      s2          : String[15];
      i,j         : Integer;
  begin
    For i := MesIni to MesFim do
      Begin
      s := '';
      For j := 1 to Grid.ColCount - 1 do
        Begin
        s2 := ChangeChar(DelSpaces(Grid.Cells[j, i]), ',', '.');
        If s2 = '.' Then s2 := '0.00';
        s2 := LeftStr(s2, 8);
        s := s + s2;
        End;
      Applic.OutPut.Editor.Write(Alltrim(s));
      End;
  end;

var i,j         : Integer;
    Ano         : Integer;
    AI, MI, Dia : Word;
    AF, MF      : Word;
begin
//  if Not VerificaDados then Exit;

  Applic.OutPut.Editor.NewPage;

  If slInicial.Count > 0 Then
     {Quando importamos de alguém (VZO/PLU)}
     begin
(*
     For i := 0 to slInicial.Count-1 do {Para cada intervalo}
       begin
       {Pego Mes/Ano inicial e Mes/Ano Final}
       DecodeDate(strToDate(slInicial[i]), AI, MI, Dia);
       DecodeDate(strToDate(  slFinal[i]), AF, MF, Dia);

       {Escreve Dados no Arquivo}
       if AI = AF then
          EscreveDados(MI, MF)
       else
          begin
          EscreveDados(MI, 12);
          For j := 1 to (AF - AI - 1) do EscreveDados(1, 12);
          EscreveDados(1, MF);
          end;
       end;
*)
     i := 0; j := slFinal.Count-1;
     DecodeDate(strToDate(slInicial[i]), AI, MI, Dia);
     DecodeDate(strToDate(  slFinal[j]), AF, MF, Dia);
     EscreveDados(MI, 12);
     For j := 1 to (AF - AI - 1) do EscreveDados(1, 12);
     EscreveDados(1, MF);
     end
  Else
     For Ano := 1 to edNumAnos.AsInteger do
        EscreveDados(1, 12);

  If Save.FileName <> '' Then
     SaveETP.FileName := ChangeFileExt(Save.FileName, '');

  If SaveETP.Execute Then
     {$IFNDEF DEBUG}
     Applic.OutPut.Editor.ActiveDoc.SaveToFile(SaveETP.FileName);
     {$ENDIF}

  Applic.OutPut.Editor.Show;
end;

procedure TDLG_ETP.btnLimparClick(Sender: TObject);
var i,j: Integer;
begin
  For i := 1 to Grid.ColCount - 1 do
    For j := 1 to Grid.RowCount - 1 do
        Grid.Cells[i,j] := Format('0%s00', [DecimalSeparator]);
End;

Procedure TDLG_ETP.SaveToFile(Const Name: String);
var F            : File;
    aByte        : Byte;
    AnoBase, i,j : Word;
    Dado         : Single;
    S            : String[12];
Begin
  S := 'Arquivo ETP';
  Try
    AssignFile(F, Name);
    ReWrite(F, 1);

    {Assinatura}
    BlockWrite(F, S, SizeOf(S));

    {Intervalo de Simulação}
    aByte := cbIntSim.ItemIndex;
    BlockWrite(F, aByte, SizeOf(aByte));

    {Ano base}
    AnoBase := edAnoBase.AsInteger;
    BlockWrite(F, AnoBase, SizeOf(AnoBase));

    {Dados da grade}
    For i := 1 to Grid.ColCount-1 do
      For j := 1 to Grid.RowCount-1 do
        begin
        Dado := StrToFloat(Grid.Cells[i,j]);
        BlockWrite(F, Dado, SizeOf(Dado));
        end;

    {Intervalo de Computação}
    aByte := cbIntComp.ItemIndex;
    BlockWrite(F, aByte, SizeOf(aByte));

    CloseFile(F);
  Except
    Raise Exception.CreateHelp(cSaveError, 0);
  End;
End;

Procedure TDLG_ETP.LoadFromFile(Const Name: String);
var F            : File;
    aByte        : Byte;
    AnoBase      : Word;
    i,j,k        : Word;
    Dado         : Single;
    aString12    : String[12];
    Rec_VZO      : TRecVZO_DEF;
    Rec_PLU      : TRecPLU_DEF;
    Deslocamento : byte;
Begin
  AssignFile(F, Name);
  Try
    Reset(F, 1);
  Except
    Raise Exception.CreateFmt(cLoadError, [Name]);
  End;

  Try
    BlockRead(F, aString12, SizeOf(aString12));
    If aString12 = 'Arquivo ETP' Then
       Begin
       R1.Checked := True;
       edArquivo.Text := '';

       {Intervalo de Simulação}
       BlockRead(F, aByte, SizeOf(aByte));
       cbIntSim.ItemIndex := aByte;
       cbIntSimChange(nil);

       {Ano base}
       BlockRead(F, AnoBase, SizeOf(AnoBase));
       edAnoBase.AsInteger := AnoBase;

       {Dados da grade}
       For i := 1 to Grid.ColCount-1 do
         For j := 1 to Grid.RowCount-1 do
           begin
           BlockRead(F, Dado, SizeOf(Dado));
           Grid.Cells[i,j] := Format('%2.2f', [Dado]);
           end;

       if not EOF(F) then
          begin
          {Intervalo de Computação}
          BlockRead(F, aByte, SizeOf(aByte));
          cbIntComp.ItemIndex := aByte;
          end
       else
          cbIntComp.ItemIndex := cINTCOMP_DIARIO;

       End Else

    If (aString12 = 'Arquivo PLU') or (aString12 = 'Arq. PLU-V2') Then
       begin
       R2.Checked := True;
       edArquivo.Text := Name;

       Rec_PLU := Load_PLUDEF(F);

       {Intervalo de Simulação}
       cbIntSim.ItemIndex  := Rec_PLU.IntSim;
       cbIntSimChange(nil);

       {Intervalo de Computação}
       cbIntComp.ItemIndex := Rec_PLU.IntComp;

       if aString12 = 'Arq. PLU-V2' then Deslocamento := 1 else Deslocamento := 0;

       {Leitura dos intervalos}
       k := 0;
       For i := 0 to Rec_PLU.Colunas - 1 do
         For j := 0 to Rec_PLU.Linhas - 1 do
           begin
           If (j < 2) and (i > Deslocamento) Then
              If j = 0 Then
                 slInicial.Add(Rec_PLU.Valores[k])
              Else
                 slFinal.Add(Rec_PLU.Valores[k]);
           Inc(k);
           end;

       UnLoad_PLUDEF(Rec_PLU);
       Applic.Errors.Add(etWarning, Format(MSG_Local_1, ['PLU']));
       Applic.Errors.Show();
       end
    Else If aString12 = 'Arquivo VZO' Then
       begin
       R2.Checked := True;
       edArquivo.Text := Name;

       Rec_VZO := Load_VZODEF(F);

       {Intervalo de Simulação}
       cbIntSim.ItemIndex  := Rec_VZO.IntSim;
       cbIntSimChange(nil);

       {Intervalo de Computação}
       cbIntComp.ItemIndex := Rec_VZO.IntComp;

       {Leitura dos intervalos}
       For i := 1 to Rec_VZO.nIntervalos do
         begin
         slInicial.Add(Rec_VZO.InterIni[i-1]);
         slFinal.Add(Rec_VZO.InterFin[i-1]);
         end;

       UnLoad_VZODEF(Rec_VZO);
       Applic.Errors.Add(etWarning, Format(MSG_Local_1, ['VZO']));
       Applic.Errors.Show();
       end
    Else
       Raise Exception.CreateFmtHelp(cMSG3, [Name], 0);
   Finally
     CloseFile(F);
   End;

   {$IFDEF DEBUG}
   Caption := 'Número de intervalos = ' + intToStr(slInicial.Count);
   {$ENDIF}
End;

procedure TDLG_ETP.btnSalvarClick(Sender: TObject);
begin
  Save.InitialDir := Applic.LastDir;
  If Save.Execute Then
     begin
     SaveToFile(Save.FileName);
     Open.FileName := Save.FileName;
     Applic.LastDir := ExtractFilePath(Save.FileName);
     end;
end;

procedure TDLG_ETP.btnCarregarClick(Sender: TObject);
begin
  Open.InitialDir := Applic.LastDir;
  If Open.Execute Then
     begin
     slInicial.Clear;
     slFinal.Clear;
     LoadFromFile(Open.FileName);
     Save.FileName := Open.FileName;
     AtualizaTela;
     Applic.LastDir := ExtractFilePath(Open.FileName);
     end;
end;

procedure TDLG_ETP.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  slInicial.Free;
  slFinal.Free;
  Action := caFree;
end;

procedure TDLG_ETP.RClick(Sender: TObject);
begin
  edArquivo.Enabled := R2.Checked;
  L2.Enabled := R2.Checked;
  L1.Enabled := R1.Checked;
  edNumAnos.Enabled := R1.Checked;
end;

procedure TDLG_ETP.AtualizaTela;
begin
  cbIntSimChange(nil);
end;

procedure TDLG_ETP.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TDLG_ETP.btnImprimirClick(Sender: TObject);
var i, j: Integer;
    s: String;
Const Tam = 12;
begin
  Applic.OutPut.Editor.NewPage;
  Applic.OutPut.Editor.Write(' Arquivo de Definição ETP');
  Applic.OutPut.Editor.Write;

  Applic.OutPut.Editor.Write(' Intervalo de Simulação  : ' + IntToStr(cbIntSim.ItemIndex));
  Applic.OutPut.Editor.Write(' Ano Base : ' + edAnoBase.AsString);
  Applic.OutPut.Editor.Write;

  Applic.OutPut.Editor.Write(' Dados: -------------------------------------------------------------');
  For i := 0 to Grid.RowCount - 1 do
    begin
    s := '';
    For j := 0 to Grid.ColCount - 1 do
      s := s + LeftStr(Grid.Cells[j, i], Tam);
    Applic.OutPut.Editor.Write(s);
    end;
  Applic.OutPut.Editor.Show;  
end;

procedure TDLG_ETP.cbIntCompChange(Sender: TObject);

  Procedure RealizaSomatorioParaCadaMes;
  var L, C: Integer;
      x: Real;
  Begin
    for L := 1 to Grid.RowCount - 1 do
      begin
      x := 0;
      for C := 1 to Grid.ColCount - 1 do
        try
          x := x + StrToFloat(Grid.Cells[C, L]);
        except
          continue;
        end;
      Grid.Cells[1, L] := FormatFloat('0.00', x);
      end;
  End;

var L: Integer;
begin
  If cbIntComp.ItemIndex  = cINTCOMP_MENSAL then
     if cbIntSim .ItemIndex  = cINTSIM_DIARIO Then
        begin
        if True {VerificaDados} then
           begin
           RealizaSomatorioParaCadaMes;
           cbIntSim .ItemIndex := cINTSIM_MENSAL;
           Grid.ColCount := 2;
           //cbIntSimChange(nil);
           end
        else
           cbIntComp.ItemIndex := cINTCOMP_DIARIO
        end
     else
        begin
        cbIntComp.ItemIndex := cINTCOMP_DIARIO;
        MessageDLG('Para utilizar o intervalo de computação MENSAL'#13 +
                   'você primeiro precisa definir os dados para o intervalo'#13 +
                   'de simulação DIÁRIO para que o somatório possa ser feito.',
                   mtInformation, [mbOK], 0);
        cbIntSim .ItemIndex := cINTSIM_DIARIO;
        cbIntSimChange(nil);
        end
  else
     begin
     cbIntSim .ItemIndex := cINTSIM_DIARIO;
     cbIntSimChange(nil);
     for L := 1 to Grid.RowCount - 1 do Grid.Cells[1, L] := Grid.Cells[2, L];
     Applic.Errors.Add(etWarning,
            'Atenção: Os valores do dia 2 foram copiados para o primeiro dia do mês.'#13 +
            'Isto foi feito pois não há sentido em se deixar o somatório para utilização.');
     Applic.Errors.Show();
     end;

  cbIntSim.Enabled := (cbIntComp.ItemIndex <> cINTCOMP_MENSAL);
end;

procedure TDLG_ETP.FormCreate(Sender: TObject);
begin
  AjustResolution(Self);
end;

function TDLG_ETP.Ajusta(Linha, Ini, Fim: Integer): String;
var x: Real;
    i: Integer;
begin
  x := 0;
  for i := Ini to Fim do
    try
      x := x + StrToFloat(Grid.Cells[i, Linha]);
    except
      // Nada
    end;

  if Tipo = 'ETP' then
     x := x / (Fim-Ini+1);

  Result := FormatFloat('0.00', x);
end;

procedure TDLG_ETP.GridKeyPress(Sender: TObject; var Key: Char);
begin
  // Permite a digitação de números reais
  if Key in ['.', ','] then Key := DecimalSeparator;
  Key := ValidateChar(Key, [Digitos, Controles, Virgula, Ponto], True);
end;

end.
