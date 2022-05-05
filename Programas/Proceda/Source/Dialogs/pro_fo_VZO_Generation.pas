unit pro_fo_VZO_Generation;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, DB, DBTables, gridx32, Mask,
  pro_Const,
  pro_Interfaces,
  pro_Classes,
  pro_fo_Memo,
  pro_Application;

type
  TDLG_VZO = class(TForm)
    Grid: TdrStringAlignGrid;
    btnEditar: TBitBtn;
    btnAdicionar: TBitBtn;
    btnRemover: TBitBtn;
    Bevel1: TBevel;
    Header: THeader;
    btnFechar: TBitBtn;
    btnOk: TBitBtn;
    cbIntComp: TComboBox;
    L_IntComp: TLabel;
    BtnSave: TBitBtn;
    BtnLoad: TBitBtn;
    Save: TSaveDialog;
    Open: TOpenDialog;
    SaveVZO: TSaveDialog;
    btnImprimir: TBitBtn;
    Painel: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    LCM: TLabel;
    Label1: TLabel;
    cbIntSim: TComboBox;
    cbPosto: TComboBox;
    cbCM: TCheckBox;
    CM: TEdit;
    procedure btnEditarClick(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure SaveToFile(Const Name: String);
    procedure LoadFromFile(Const Name: String);
    procedure BtnLoadClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure GeraVzo(Const Name: String);
    procedure btnFecharClick(Sender: TObject);
    procedure cbIntCompChange(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbCMClick(Sender: TObject);
    procedure CMExit(Sender: TObject);
    procedure CMKeyPress(Sender: TObject; var Key: Char);
    procedure cbIntSimChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
  private
    Finfo    : TDSInfo;
    Linhas   : Integer;
    Postos   : TStrings;
    FTipo    : String;
    m        : TfoMemo;

    Function ValidadaDataDaGrid: Boolean;
    procedure Atualiza;
  public
    constructor Create(Info: TDSInfo; const Tipo: String);
    property Tipo: String read FTipo write FTipo;   // VZO/VZC/RVZ
  end;

implementation
uses pro_fo_getInterval, pro_Procs, StDate, wsMatrix, wsGlib,
     SysUtilsEx, MessagesForm, WinUtils;

{$R *.DFM}

constructor TDLG_VZO.Create(Info: TDSInfo; const Tipo: String);
begin
  Inherited Create(nil);
  FInfo := Info;
  FTipo := Tipo;
end;

procedure TDLG_VZO.btnEditarClick(Sender: TObject);
var D                : TDLG_ObterPeriodo;
    L, Mes, Ano, Dia : Word;
begin
  D := TDLG_ObterPeriodo.Create(FInfo);
  D.DI.EditMask := cMMYYYY; D.DI.Hint := csMMYYYY;
  D.DF.EditMask := cMMYYYY; D.DF.Hint := csMMYYYY;
  Try
  L := Grid.Row;
  D.DI.Text := Grid.Cells[0,L];
  D.DF.Text := Grid.Cells[1,L];

  If D.ShowModal = mrOk Then
     Begin
     Grid.Cells[0,L] := '01/' + D.DI.Text;
     DecodeDate(strToDate('01/' + D.DF.Text), Ano, Mes, Dia);
     Grid.Cells[1, Linhas] := IntToStr(DaysInMonth(Mes, Ano, Ano))+ '/' + D.DF.Text;;
     End;
  Finally
     D.Free;
  End;
end;

procedure TDLG_VZO.btnAdicionarClick(Sender: TObject);
var D            : TDLG_ObterPeriodo;
    Mes,Ano,Dia  : Word;
begin
  D := TDLG_ObterPeriodo.Create(FInfo);
  D.DI.EditMask := cMMYYYY; D.DI.Hint := csMMYYYY;
  D.DF.EditMask := cMMYYYY; D.DF.Hint := csMMYYYY;
  Try
  If D.ShowModal = mrOk Then
     Begin
     Inc(Linhas);
     If Linhas > 0 Then Grid.RowCount := Linhas + 1;

     btnRemover.Enabled := True;
     btnEditar .Enabled := True;
     Grid.Cells[0, Linhas] := '01/' + D.DI.Text;

     DecodeDate(StrToDate('01/' + D.DF.Text), Ano, Mes, Dia);
     Grid.Cells[1, Linhas] := IntToStr(DaysInMonth(Mes, Ano, Ano))+ '/' + D.DF.Text;
     End;
  Finally
    D.Free;
  End;
end;

procedure TDLG_VZO.btnRemoverClick(Sender: TObject);
begin
  Dec(Linhas);
  If Linhas > -1 Then
     Grid.RemoveRows(Grid.Row, 1)
  Else
     Begin
     Grid.Clear(False);
     btnRemover.Enabled := False;
     btnEditar .Enabled := False;
     End;
end;

procedure TDLG_VZO.FormShow(Sender: TObject);
begin
  cbIntComp.Visible := (Tipo = 'VZO');
  L_IntComp.Visible := cbIntComp.Visible;
  if cbIntComp.Visible then
     begin
     Caption := ' Criação do arquivo de Vazões (VZO)';
     Painel.Top := 56;

     SaveVZO.Filter := 'Arquivos VZO (*.VZO)|*.VZO' + cTodos;
     SaveVZO.Title  := 'Gerar arquivo VZO';
     SaveVZO.DefaultExt := 'VZO';

     Save.Filter := 'Definição de VZO (*.DFV)|*.DFV' + cTodos;
     Save.Title  := 'Salva o aquivo de definição de VZO';
     Save.DefaultExt := 'DFV';

     Open.Filter := 'Definição de VZO (*.DFV)|*.DFV|Definição de PLU (*.DFP)|*.DFP' + cTodos;
     Open.Title  := 'Abertura do aquivo de definição de VZO';
     Open.DefaultExt := 'DFV';
     end
  else
     begin
     if Tipo = 'VZC' then
        begin
        Caption := ' Vazão incremental de uma sub-bacia ligada a um PC (VZC)';

        SaveVZO.Filter := 'Arquivos VZC (*.VZC)|*.VZC' + cTodos;
        SaveVZO.Title  := 'Gerar arquivo VZC';
        SaveVZO.DefaultExt := 'VZC';

        Save.Filter := 'Definição de VZC (*.DVR)|*.DVR' + cTodos;
        Save.Title  := 'Salva o aquivo de definição de VZC';
        Save.DefaultExt := 'DVR';

        Open.Filter := 'Definição de VZC (*.DVR)|*.DVR' + cTodos;
        Open.Title  := 'Abertura do aquivo de definição de VZC';
        Open.DefaultExt := 'DVR';
        end
     else
        begin
        Caption := ' Vazão na seção do reservatório (RVZ)';

        SaveVZO.Filter := 'Arquivos RVZ (*.RVZ)|*.RVZ' + cTodos;
        SaveVZO.Title  := 'Gerar arquivo RVZ';
        SaveVZO.DefaultExt := 'RVZ';

        Save.Filter := 'Definição de RVZ (*.DVS)|*.DVS' + cTodos;
        Save.Title  := 'Salva o aquivo de definição de RVZ';
        Save.DefaultExt := 'DVS';

        Open.Filter := 'Definição de RVZ (*.DVS)|*.DVS' + cTodos;
        Open.Title  := 'Abertura do aquivo de definição de RVZ';
        Open.DefaultExt := 'DVS';
        end;

     Painel.Top := 6;
     end;

  FInfo.GetStationNames(cbPosto.Items);
  //pTGlobalDataRec(pDados)^.Lockeds := pTGlobalDataRec(pDados)^.Lockeds + 1;
end;

procedure TDLG_VZO.GridDblClick(Sender: TObject);
begin
  If Grid.Cells[0, Grid.Row] <> '' Then
     btnEditarClick(Sender);
end;

procedure TDLG_VZO.FormHide(Sender: TObject);
begin
//  If Not gFechando Then
  //   pTGlobalDataRec(pDados)^.Lockeds := pTGlobalDataRec(pDados)^.Lockeds - 1;
end;

Procedure TDLG_VZO.SaveToFile(Const Name: String);
var F            : File;
    i,j          : Word;
    aByte        : Byte;
    aDouble      : Double;
    aInteger     : Integer;
    aString30    : String[30];
    aString12    : String[12];
Begin
  aString12 := 'Arquivo VZO';
  Try
    AssignFile(F, Name);
    ReWrite(F, 1);

    {Assinatura}
    BlockWrite(F, aString12, SizeOf(aString12));

    {Numero de linhas}
    aInteger := Grid.RowCount;
    BlockWrite(F, aInteger, SizeOf(aInteger));

    {Intervalo de Computacao}
    aByte := cbIntComp.ItemIndex;
    BlockWrite(F, aByte, SizeOf(aByte));

    {Intervalo de Simulação}
    aByte := cbIntSim.ItemIndex;
    BlockWrite(F, aByte, SizeOf(aByte));

    {Posto}
    aString30 := cbPosto.Items[cbPosto.ItemIndex];
    BlockWrite(F, aString30, SizeOf(aString30));

    {Dados da grade}
    For i := 0 to 1 do
      For j := 0 to Grid.RowCount - 1 do
        begin
        aDouble := StrToDate(Grid.Cells[i,j]);
        BlockWrite(F, aDouble, SizeOf(aDouble));
        end;

    {Multiplicador}
    Try
      aDouble := strToFloat(cm.Text);
    except
      aDouble := 1;
    end;
    BlockWrite(F, aDouble, SizeOf(aDouble));

    {Usar Multiplicador}
    aByte := Ord(cbCM.Checked);
    BlockWrite(F, aByte, SizeOf(aByte));

    CloseFile(F);
  Except
    Raise Exception.CreateHelp(cSaveError, 0);
  End;
End;


Procedure TDLG_VZO.LoadFromFile(Const Name: String);
var F            : File;
    i,j,k        : Integer;
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
    If aString12 = 'Arquivo VZO' Then
       Begin
       Rec_VZO := Load_VZODEF(F);

       Grid.RowCount := Rec_VZO.nIntervalos;
       cbIntComp.ItemIndex := Rec_VZO.IntComp;
       cbIntSim.ItemIndex  := Rec_VZO.IntSim;

       i := cbPosto.Items.IndexOf(Rec_VZO.Posto);
       if i <> -1 Then
          cbPosto.ItemIndex := i
       else
          begin
          Applic.Errors.Add(etWarning, 'Criação de arquivos de Vazões'#13 +
          'Atenção: Posto ' + Rec_VZO.Posto + ' não encontrado');
          Applic.Errors.Show();
          end;

      {Dados da grade}
       For j := 0 to Grid.RowCount - 1 do
         begin
         Grid.Cells[0,j] := Rec_VZO.InterIni[j];
         Grid.Cells[1,j] := Rec_VZO.InterFin[j];
         end;

       {Multiplicador}
       Try
         CM.Text := FloatToStr(Rec_VZO.Multiplic);
       Except
         CM.Text := '1';
         end;

       {Usar Multiplicador}
       cbCM.Checked := Rec_VZO.UsarMultiplic;
       End Else

    If (aString12 = 'Arquivo PLU') or (aString12 = 'Arq. PLU-V2') Then
       begin
       Rec_PLU := Load_PLUDEF(F);

       cbIntComp.ItemIndex := Rec_PLU.IntComp;
       cbIntSim.ItemIndex := Rec_PLU.IntSim;

       if aString12 = 'Arq. PLU-V2' then Deslocamento := 1 else Deslocamento := 0;

       {Número de intervalos}
       Grid.RowCount  := Rec_PLU.Colunas - 1 - Deslocamento;

       k := 0;
       For i := 0 to Rec_PLU.Colunas - 1 do
         For j := 0 to Rec_PLU.Linhas - 1 do
           begin
           If (j < 2) and (i > Deslocamento) Then Grid.Cells[j, i-1-Deslocamento] := Rec_PLU.Valores[k];
           Inc(k);
           end;

       UnLoad_PLUDEF(Rec_PLU);
       end
    Else
       Raise Exception.CreateFmtHelp(cMSG3, [Name], 0);
   Finally
     CloseFile(F);
   End;
End;

procedure TDLG_VZO.BtnSaveClick(Sender: TObject);
begin
  Save.InitialDir := Applic.LastDir;
  If Save.Execute Then
     Begin
     SaveToFile(Save.FileName);
     Open.FileName := Save.FileName;
     Applic.LastDir := ExtractFilePath(Save.FileName);
     End;
end;

procedure TDLG_VZO.BtnLoadClick(Sender: TObject);
begin
  Open.InitialDir := Applic.LastDir;
  If Open.Execute Then
     Begin
     LoadFromFile(Open.FileName);
     Save.FileName := Open.FileName;
     Applic.LastDir := ExtractFilePath(Open.FileName);
     Linhas := Grid.RowCount - 1;
     Atualiza;
     End;
end;

procedure TDLG_VZO.GeraVzo(Const Name: String);
var i,k:              Longint;
    cont:             Longint;
    LinhaInic:        Longint;
    LinhaFim:         Longint;
    SB:               TwsMatrix;
    Divisao:          Longint;
    IntSimulacao:     Integer;
    IntComputacao:    Integer;
    DaysInPeriod:     Integer;
    DataIni:          TDateTime;
    Soma,Dado:        Double;
    ExisteVZo:        Boolean;
    IndexCol:         Integer;
    Posto:            String[30];
    f_CM:             Real;
    VV:               Boolean; //Valor Válido de vazão, isto é, diferente de MissValue;
Begin
  Posto := cbPosto.Items[cbPosto.ItemIndex];
  m.Buffer.Clear();

  For k := 0 to Grid.RowCount-1 do
    begin
    {Criacao da SubMatriz}
    DataIni   := StrToDate(Grid.Cells[0, k]);
    LinhaInic := FInfo.IndiceDaData(DataIni);
    LinhaFim  := FInfo.IndiceDaData(Grid.Cells[1, k]);

    {Retorna o índice da coluna referente ao posto no DataSet}
    IndexCol  := FInfo.DS.Struct.IndexOf(GetValidID(Posto));

    SB := FInfo.DS.SubMatrix(LinhaInic, LinhaFim - LinhaInic + 1, IndexCol, 1);
    Try
      if FInfo.TipoIntervalo = tiDiario then
         begin {Gera as Médias}
         Cont := 0;
         soma := 0;
         Divisao   := 0;
         ExisteVZO := False;
         DaysInPeriod := DiasNoPeriodo(cbIntSim.ItemIndex, DataIni);
         IntSimulacao := DiasQueFaltamParaO_UltimoDiaDoPeriodo(DataIni, DaysInPeriod) + 1;

         f_CM := strToFloatDef(CM.Text, 1);

         For i := 1 to SB.nRows do
           begin
           Dado := SB[i,1];

           VV := not isMissValue(Dado);
           If VV then
             begin
             soma := soma + Dado;
             inc(divisao);
             ExisteVZO := True;   {onde ele retorna }
             end;

           if cbIntSim.ItemIndex = cINTSIM_DIARIO Then

              if VV then {Escreve dado}
                 if cbCM.Checked and (F_CM <> 1) then
                    m.Write(ChangeChar(FloatToStrF(Dado * F_CM, ffFixed, 8, 2), ',', '.'))
                 else
                    m.Write(ChangeChar(FloatToStrF(Dado, ffFixed, 8, 2), ',', '.'))
              else
                 m.Write('-999.0')
           else
              begin
              inc(Cont);
              If Cont = IntSimulacao Then
                 begin
                 If Not ExisteVZO Then
                   Soma := -999.0
                 else
                   Soma := Soma / divisao;

                 {Escreve a média no editor}
                 if cbCM.Checked and (F_CM <> 1) then
                    m.Write(ChangeChar(FloatToStrF(Soma * F_CM, ffFixed, 8, 2), ',', '.'))
                 else
                    m.Write(ChangeChar(FloatToStrF(Soma, ffFixed, 8, 2), ',', '.'));

                 ExisteVZO := False;  {onde ele retorna }
                 If cbIntSim.ItemIndex = cINTSIM_MENSAL Then
                    DaysInPeriod := DiasNoPeriodo(cbIntSim.ItemIndex, DataIni + i);

                 {Pega quantos dias faltam para o último dia de qualquer periodo para o dia seguinte}
                 {EX: Dia Atual 07/11/90, vou passar para a funcao 08/11/90 e ela irá me retornar 6 (dias)}
                 {08/11/90 + 6 (dias) = 14/11/90 (ultimo dia da segunda semana se o período for semanal)}
                 IntSimulacao := DiasQueFaltamParaO_UltimoDiaDoPeriodo(DataIni+i, DaysInPeriod) + 1;
                 divisao := 0;
                 Cont := 0;
                 Soma := 0;
                 end;
              end;
           end; // For i
         end // Tipo = tiDiario
      else
         begin
         f_CM := strToFloatDef(CM.Text, 1);

         For i := 1 to SB.nRows do
           begin
           Dado := SB[i,1];
           if isMissValue(Dado) then Dado := -999.0;

           {Escreve a média no editor}
           if cbCM.Checked and (F_CM <> 1) then
              m.Write(ChangeChar(FloatToStrF(Dado * F_CM, ffFixed, 8, 2), ',', '.'))
           else
              m.Write(ChangeChar(FloatToStrF(Dado, ffFixed, 8, 2), ',', '.'));
           end; //for i
         end; // if tiMensal
    Finally
      SB.Free;
      End;
    end;

  If Save.FileName <> '' Then
     SaveVZO.FileName := ChangeFileExt(Save.FileName, '');

  If SaveVZO.Execute Then
     m.Buffer.SaveToFile(SaveVZO.FileName);
end;

procedure TDLG_VZO.btnOkClick(Sender: TObject);
begin
  CMExit(Sender); // Simulo uma saída no Multiplicador
  if Linhas > -1 then
     If ValidadaDataDaGrid then
        try
          WinUtils.StartWait();
          m.Hide();
          Application.ProcessMessages();
          GeraVZO(Save.FileName);
          m.Show();
        finally
          WinUtils.StopWait();
        end;
end;

procedure TDLG_VZO.btnFecharClick(Sender: TObject);
begin
  close;
end;

procedure TDLG_VZO.cbIntCompChange(Sender: TObject);
begin
  cbIntSim.Enabled := (cbIntComp.ItemIndex  <> cINTCOMP_MENSAL);
  if cbIntComp.ItemIndex  = cINTCOMP_MENSAL Then
     cbIntSim .ItemIndex := cINTSIM_MENSAL;

  Atualiza;
end;

Function  TDLG_VZO.ValidadaDataDaGrid: Boolean;
var Validade : Boolean;
    i        : Integer;
begin
  Result := True;
  For i := 0 to Grid.RowCount-2  Do
    begin
    Validade := ValidaDataFinal(StrToDateTime(Grid.Cells[1, i]),StrToDateTime(Grid.Cells[0, i+1]));
    if not Validade then
       begin
       Result := False;
       break;
       end;
    end;
end;

procedure TDLG_VZO.btnImprimirClick(Sender: TObject);
var i: Integer;
    s: String;
    m: TfoMemo;
Const Tam = 18;
begin
  m := TfoMemo.Create(' VZO');

  m.Write('Arquivo de Definição VZO' + IntToStr(cbIntComp.ItemIndex));
  m.Write;

  m.Write('Intervalo de Computação : ' + IntToStr(cbIntComp.ItemIndex));
  m.Write('Intervalo de Simulação  : ' + IntToStr(cbIntSim.ItemIndex));
  m.Write('Posto : ' + cbPosto.Items[cbPosto.ItemIndex]);
  if cbCM.Checked then m.Write('Multiplicador: ' + AllTrim(CM.Text));
  m.Write;

  s := LeftStr('Datas Iniciais', Tam) + LeftStr('Datas Finais', Tam);
  m.Write(s);
  For i := 0 to Grid.RowCount - 1 do
    begin
    s := LeftStr(Grid.Cells[0, i], Tam) + LeftStr(Grid.Cells[1, i], Tam);
    m.Write(s);
    end;

  m.FormStyle := fsMDIChild;
  m.Show();
  Applic.ArrangeChildrens();
end;

procedure TDLG_VZO.FormCreate(Sender: TObject);
begin
  Linhas := -1;
  CM.Text := Format('1%s00', [DecimalSeparator]);
  AjustResolution(Self);
  m := TfoMemo.Create(' Dados de vazões gerados');
  m.BorderIcons := [];
  m.FormStyle := fsStayOnTop;
end;

procedure TDLG_VZO.cbCMClick(Sender: TObject);
begin
  LCM.Enabled := cbCM.Checked;
  CM.Enabled  := LCM.Enabled;
end;

procedure TDLG_VZO.CMExit(Sender: TObject);
var s : String;
    PD: Char;
begin
  Try
    if DecimalSeparator = '.' then PD := ',' Else PD := '.';
    CM.Text := AllTrim(ChangeChar(CM.Text, PD, DecimalSeparator));
    strToFloat(CM.Text);
  Except
    s := Format('1%s00', [DecimalSeparator]);
    Applic.Errors.Add(etWarning,
      'Criação de arquivos de Vazões'#13 +
      'Atenção: Multiplicador < ' + CM.Text + ' > inválido.'#13 +
      'Substituido por ' + s);
    Applic.Errors.Show();
    CM.Text := s;
  End;
end;

procedure TDLG_VZO.CMKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = '.') or (Key = ',') then
     Key := DecimalSeparator
  else
     Case Key of
       '0'..'9', #8 : ; //Nada
       Else begin Key := #0; SysUtils.Beep; end;
       end;
end;

procedure TDLG_VZO.Atualiza;
begin
  if FInfo.TipoIntervalo = tiMensal then
     btnOK.Enabled := (cbIntSim .ItemIndex = cINTSIM_MENSAL);
end;

procedure TDLG_VZO.cbIntSimChange(Sender: TObject);
begin
  Atualiza;
end;

procedure TDLG_VZO.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDLG_VZO.GridKeyPress(Sender: TObject; var Key: Char);
begin
  // Permite a digitação de números reais
  if Key in ['.', ','] then Key := DecimalSeparator;
  Key := ValidateChar(Key, [Digitos, Controles, Virgula, Ponto], True);
end;

procedure TDLG_VZO.FormDestroy(Sender: TObject);
begin
  m.Free();
end;

end.
