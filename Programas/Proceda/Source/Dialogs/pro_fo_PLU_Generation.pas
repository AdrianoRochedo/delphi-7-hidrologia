unit pro_fo_PLU_Generation;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Mask,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, wsVec, wsMatrix, gridx32,
  pro_fo_Memo,
  pro_Interfaces,
  pro_Const,
  pro_Classes,
  pro_Application,
  pro_fo_PLU_Generation_Options;

type
  TDLG_PLU = class(TForm)
    B1: TBevel;
    Label1: TLabel;
    btnFechar: TBitBtn;
    btnGerar: TBitBtn;
    P: TPanel;
    btnEditar: TBitBtn;
    btnAdicionar: TBitBtn;
    btnDeletar: TBitBtn;
    B2: TBevel;
    L_IntSim: TLabel;
    cbIntSim: TComboBox;
    L_IntComp: TLabel;
    cbIntComp: TComboBox;
    btnLer: TBitBtn;
    Grid: TdrCheckBoxGrid;
    Sum: TdrStringAlignGrid;
    btnSalvar: TBitBtn;
    Open: TOpenDialog;
    Save: TSaveDialog;
    btnOpcoes: TBitBtn;
    Label4: TLabel;
    SavePLU: TSaveDialog;
    btnImprimir: TBitBtn;
    btnAuto: TButton;
    edDataIni: TMaskEdit;
    btnImportar: TButton;
    Importar: TOpenDialog;
    btnSelPer: TButton;
    procedure btnEditarClick(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure GradesTopLeftChanged(Sender: TObject);
    procedure GridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridSetEditText(Sender: TObject; ACol, ARow: Longint;
      const Value: String);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLerClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnOpcoesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbIntCompChange(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
    procedure btnAutoClick(Sender: TObject);
    procedure btnGerarClick(Sender: TObject);
    procedure btnImportarClick(Sender: TObject);
    procedure btnSelPerClick(Sender: TObject);
  private
    FInfo     : TDSInfo;
    Colunas   : Integer;
    dlgOpcoes : TdlgPLU_Opcoes;

    // usado para o controle do número de colunas impressas
    FNum999s     : Integer;
    FnumVals     : Integer;
    FnumCols     : Integer;
    FBufferEditor: String;
    FTipo        : String;

    m: TfoMemo;

    procedure GerarPLU();
    procedure EscreveValor(m: TfoMemo; const Format: String; const Valor: Real);
    procedure EsvaziarBufferDoEditor(m: TfoMemo);

    Procedure SaveToFile(Const Name: String);
    Procedure LoadFromFile(Const Name: String);
    Procedure RealizaPreAnalise(SB: TwsMatrix; Ponderadares: TwsVec; Periodo: Integer);
    Function  ValidadaDatasDaGrid (Grid : TdrStringAlignGrid): Boolean;
    Procedure Atualizar();
    procedure LimparGrade();
    procedure AtualizarSomatorio();
  public
    constructor Create(Info: TDSInfo; const Tipo: String);
    property Tipo: String read FTipo write FTipo;   // PLU/RPL
  end;

implementation
uses wsConstTypes,
     pro_Procs, wsgLib, SysUtilsEx, stDate,
     Math,
     WinUtils,
     pro_fo_getInterval,
     pro_fo_PLU_SelPerCont;

{$R *.DFM}

const
  cSEP = -999999999999;

constructor TDLG_PLU.Create(Info: TDSInfo; const Tipo: String);
begin
  Inherited Create(nil);
  FInfo := Info;
  FTipo := Tipo;
end;

procedure TDLG_PLU.btnEditarClick(Sender: TObject);
var D: TDLG_ObterPeriodo;
begin
  D := TDLG_ObterPeriodo.Create(FInfo);
  D.DI.EditMask := cDDMMYYYY; D.DI.Hint := csDDMMYYYY;
  D.DF.EditMask := cDDMMYYYY; D.DF.Hint := csDDMMYYYY;
  Try
    D.DI.Text := Grid.Cells[Grid.Col,0];
    D.DF.Text := Grid.Cells[Grid.Col,1];

    If D.ShowModal = mrOk Then
       Begin
       Grid.Cells[Grid.Col,0] := D.DI.Text;
       Grid.Cells[Grid.Col,1] := D.DF.Text;
       End;
  Finally
     D.Free;
  End;

  Atualizar();
end;

procedure TDLG_PLU.btnAdicionarClick(Sender: TObject);
{$IFDEF TESTE_DE_INTERFACE}
var i: Integer;
{$ENDIF}
var D : TDLG_ObterPeriodo;
begin
  D := TDLG_ObterPeriodo.Create(FInfo);
  D.DI.EditMask := cDDMMYYYY; D.DI.Hint := csDDMMYYYY;
  D.DF.EditMask := cDDMMYYYY; D.DF.Hint := csDDMMYYYY;
  Try
    If Colunas = 1 Then
       D.DI.Text := '01/' + edDataIni.Text
    Else
       D.DI.Text := DateToStr(StrToDate(Grid.Cells[Colunas, 1]) + 1);

    If D.ShowModal = mrOk Then
       Begin
       Inc(Colunas);

       If Colunas > 1 Then
          Grid.ColCount := Colunas + 1;

       Grid.Cells[Colunas, 0] := D.DI.Text;
       Grid.Cells[Colunas, 1] := D.DF.Text;
       Sum.ColCount := Grid.ColCount - 1;
       btnDeletar.Enabled := True;
       btnEditar .Enabled := True;
       End;
     Finally
        D.Free;
     End;

  Atualizar();
end;

procedure TDLG_PLU.btnDeletarClick(Sender: TObject);
begin
  if Grid.Col < 2 then Exit;
  Dec(Colunas);
  If (Colunas > 0) Then
     Begin
     Grid.RemoveCols(Grid.Col, 1);
     Sum .RemoveCols(Grid.Col - 1, 1);
     End
  Else
     Begin
     Grid.Clear(False);
     Sum .Clear(False);
     End;

  Atualizar();
end;

procedure TDLG_PLU.FormShow(Sender: TObject);
var i: Integer;
begin
  cbIntComp.Visible := (Tipo = 'PLU');
  L_IntComp.Visible := cbIntComp.Visible;
  if cbIntComp.Visible then
     begin
     Caption := ' Criação do arquivo de Precipitações (PLU)';
     cbIntSim.Left := 266;
     L_IntSim.Left := 266;

     SavePLU.Filter := 'Arquivo PLU (*.PLU)|*.PLU' + pro_Const.cTodos;
     SavePLU.Title  := 'Gerar arquivo PLU';
     SavePLU.DefaultExt := 'PLU';

     Save.Filter := 'Definição de PLU (*.DFP)|*.DFP' + pro_Const.cTodos;
     Save.Title  := 'Salva o arquivo de definição de PLU';
     Save.DefaultExt := 'DFP';

     Open.Filter := 'Definição de PLU (*.DFP)|*.DFP|Definição de VZO (*.DFV)|*.DFV';
     Open.Title  := 'Abertura do arquivo de definição de PLU' + pro_Const.cTodos;
     Open.DefaultExt := 'DFP';
     end
  else
     begin
     Caption := ' Criação do arquivo de Chuva sobre Reservatório (RPL)';
     cbIntSim.Left := 105;
     L_IntSim.Left := 105;

     SavePLU.Filter := 'Arquivo RPL (*.RPL)|*.RPL' + pro_Const.cTodos;
     SavePLU.Title  := 'Gerar arquivo RPL';
     SavePLU.DefaultExt := 'RPL';

     Save.Filter := 'Definição de RPL (*.DRP)|*.DRP' + pro_Const.cTodos;
     Save.Title  := 'Salva o arquivo de definição de RPL';
     Save.DefaultExt := 'DRP';

     Open.Filter := 'Definição de RPL (*.DRP)|*.DRP' + pro_Const.cTodos;
     Open.Title  := 'Abertura do arquivo de definição de RLP';
     Open.DefaultExt := 'DRP';
     end;

  Colunas := 1;
  Grid.RowCount := 3;
  Grid.ColCount := 2;
  Sum.ColCount  := 1;

  Grid.Cells[1, 0] := 'Valores';
  Grid.Cells[1, 1] := 'Padrão';
  {
  Grid.Cells[0,0] := 'Data Inicial ->';
  Grid.Cells[0,1] := 'Data Final ->';
  }
  edDataIni.Text := DateToStr(FInfo.DataInicial);

  Grid.AlignCol[0] := alCenter;
  Grid.RowCount := FInfo.NumPostos + 2{Cabeçalho};
  For i := 0 to FInfo.NumPostos-1 do
    Grid.Cells[0, i + 2] := FInfo.Station[i].Nome;
end;

procedure TDLG_PLU.GridDblClick(Sender: TObject);
var Point: TPoint;
    Col, Row: Longint;
begin
  GetCursorPos(Point);
  Point := Grid.ScreenToClient(Point);
  Grid.MouseToCell(Point.X, Point.Y, Col, Row);
  If ((Row = 0) or (Row = 1)) and (Col > 1) and (Grid.Cells[Col, 0] <> '') Then
     Begin
     Grid.Col := Col;
     btnEditarClick(Sender);
     End;
end;

procedure TDLG_PLU.GradesTopLeftChanged(Sender: TObject);
begin
  If TdrStringGrid(Sender).Name = 'Sum' Then
     Grid.LeftCol := Sum.LeftCol + 1
  Else
     Sum.LeftCol := Grid.LeftCol - 1
end;

procedure TDLG_PLU.GridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  GridSetEditText(Sender, Grid.Col, Grid.Row, '');
end;

procedure TDLG_PLU.GridSetEditText(Sender: TObject; ACol, ARow: Longint; const Value: String);
var d: Extended;
    i: Integer;
begin
  //DecimalSeparator  := ','; Deixar por conta do usuário - Windows
  d := 0;
  Try
    For i := 2 to Grid.RowCount-1 do
      If Grid.Checked[aCol, i] Then
         d := d + StrToFloat(Grid.Cells[aCol, i]);

    Sum.Cells[aCol-1, 0] := format('%1.4f', [d]);
    If d > 1.0000001 Then Sum.Cells[aCol-1, 0] := Format('Soma > 1%s0', [DecimalSeparator]);
  Except
    Sum.Cells[aCol-1, 0] := 'N.Def';
  End;
end;

procedure TDLG_PLU.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDLG_PLU.btnLerClick(Sender: TObject);
begin
  Open.InitialDir := Applic.LastDir;
  If Open.Execute() Then
     begin
     LoadFromFile(Open.FileName);
     Save.FileName := Open.FileName;
     Applic.LastDir := ExtractFilePath(Open.FileName);
     Colunas := Sum.ColCount;
     Atualizar();
     end;
end;

procedure TDLG_PLU.btnSalvarClick(Sender: TObject);
begin
  Save.InitialDir := Applic.LastDir;
  If Save.Execute Then
     begin
     SaveToFile(Save.FileName);
     Open.FileName := Save.FileName;
     Applic.LastDir := ExtractFilePath(Save.FileName);
     end;
end;

Procedure TDLG_PLU.LoadFromFile(Const Name: String);
var F            : File;
    i,j,k        : Word;
    Rec_PLU      : TRecPLU_DEF;
    Rec_VZO      : TRecVZO_DEF;
    aString12    : String[12];
    Deslocamento : byte;
    s            : String;
    x            : Real;
Begin
  LimparGrade();

  AssignFile(F, Name);
  Try
    Reset(F, 1);
  Except
    Raise Exception.CreateFmt(cLoadError, [Name]);
  End;

  Try
    BlockRead(F, aString12, SizeOf(aString12));
    If (aString12 = 'Arquivo PLU') or (aString12 = 'Arq. PLU-V2') Then
       Begin
       Rec_PLU := Load_PLUDEF(F);

       {Data Inicial}
       edDataIni.Text := DateToStr(Rec_PLU.DataIni);

       {Intervalo de Computação}
       cbIntComp.ItemIndex := Rec_PLU.IntComp;

       {Intervalo de Simulação}
       cbIntSim.ItemIndex := Rec_PLU.IntSim;

       {Linhas}
       Grid.RowCount  := Rec_PLU.Linhas;
       Grid.FixedRows := 2;

       if aString12 = 'Arquivo PLU' then Deslocamento := 1 else Deslocamento := 0;

       {Colunas}
       Grid.ColCount  := Rec_PLU.Colunas + Deslocamento;
       Grid.FixedCols := 1;
       Sum.ColCount := Grid.ColCount - 1 + Deslocamento;

       {Dados da grade - Parte 1}
       k := 0;
       For i := 0 to Rec_PLU.Colunas - 1 do
         For j := 0 to Grid.RowCount - 1 do
           begin
           if (i > 0) and (j > 1) then
              begin
              x := StrToFloatDef(Rec_PLU.Valores[k], 0);
              s := FormatFloat('0.##', x);
              end
           else
              s := Rec_PLU.Valores[k];

           if i = 0 then
              Grid.Cells[0, j] := s
           else
              Grid.Cells[i+Deslocamento, j] := s;
           Inc(k);
           end;

       {Dados da grade - Parte 2}
       k := 0;
       For i := 1 to Rec_PLU.Colunas - 1 do
         For j := 2 to Grid.RowCount - 1 do
           begin
           if i = 0 then
              Grid.Checked[0, j] := (Rec_PLU.PostosSel[k] = '1')
           else
              Grid.Checked[i+Deslocamento, j] := (Rec_PLU.PostosSel[k] = '1');
           Inc(k);
           end;

       UnLoad_PLUDEF(Rec_PLU);

       AtualizarSomatorio();
       End
    Else If aString12 = 'Arquivo VZO' Then
       begin
       Rec_VZO := Load_VZODEF(F);

       {Intervalo de Computação}
       cbIntComp.ItemIndex := Rec_VZO.IntComp;

       {Intervalo de Simulação}
       cbIntSim.ItemIndex := Rec_VZO.IntSim;

       {Intervalos}
       Grid.ColCount  := Rec_VZO.nIntervalos + 1;

       For i := 1 to Rec_VZO.nIntervalos do
         begin
         Grid.Cells[i,0] := Rec_VZO.InterIni[i-1];
         Grid.Cells[i,1] := Rec_VZO.InterFin[i-1];
         end;

       UnLoad_VZODEF(Rec_VZO);
       end
    Else
       Raise Exception.CreateFmtHelp(cMSG3, [Name], 0);

  Finally
    CloseFile(F);
  End;
End;

Procedure TDLG_PLU.SaveToFile(Const Name: String);
var F            : File;
    i,j          : Word;
    aByte        : Byte;
    aWord        : Word;
    aDouble      : Double;
    aBoolean     : Boolean;
    aString12    : String[12];
    aString50    : String[50];
Begin
  aString12 := 'Arq. PLU-V2';
  Try
    AssignFile(F, Name);
    ReWrite(F, 1);

    {Assinatura}
    BlockWrite(F, aString12, SizeOf(aString12));

    {Intervalo de Computação}
    aByte := cbIntComp.ItemIndex;
    BlockWrite(F, aByte, SizeOf(aByte));

    {Intervalo de Simulação}
    aByte := cbIntSim.ItemIndex;
    BlockWrite(F, aByte, SizeOf(aByte));

    {Linhas}
    aWord := Grid.RowCount;
    BlockWrite(F, aWord, SizeOf(aWord));

    {Colunas}
    aWord := Grid.ColCount;
    BlockWrite(F, aWord, SizeOf(aWord));

    {Dados da grade - Parte 1}
    For i := 0 to Grid.ColCount - 1 do
      For j := 0 to Grid.RowCount - 1 do
        begin
        aString50 := Grid.Cells[i,j];
        BlockWrite(F, aString50, SizeOf(aString50));
        end;

    {Dados da grade - Parte 2}
    For i := 1 to Grid.ColCount - 1 do
      For j := 2 to Grid.RowCount - 1 do
        begin
        aBoolean := Grid.Checked[i,j];
        BlockWrite(F, aBoolean, SizeOf(aBoolean));
        end;

    {Data Inicial}
    aDouble := StrToDate('01/' + edDataIni.Text);
    BlockWrite(F, aDouble, SizeOf(aDouble));

    CloseFile(F);
  Except
    Raise Exception.CreateHelp(cSaveError, 0);
  End;
End;

procedure TDLG_PLU.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TDLG_PLU.btnOpcoesClick(Sender: TObject);
begin
  dlgOpcoes.ShowModal();
end;

  {
    DADOS

    Dado os seguintes dados obtidos da conversão prévia dos dados brutos em formato
    DB pela rotina DBtoDST:

    gDataSet      P1        P2       P3         P4      ...          <-- Postos

    01/01/91     x11       x12      x13        x14      ...
    02/01/91     x21       x22      x23        x24      ...
    03/01/91     x31        .        .          .       ...
    04/01/91      .         .        .          .       ...
    05/01/91      .         .        .          .        .
    06/01/91      .         .        .          .        .
    07/01/91                .        .          .        .
    08/01/91     x81       x82      x83        x84      ...
    ...

    E também fornecidos:
      - Intervalo de computação (Diário e Mensal)
      - Intervalo de simulação (Diário, Semanal, Quinzenal, etc)
      - Períodos
        - Postos e Coeficientes para ponderações

    EX:
      Intervalo de computação  :  Diário
      Intervalo de simulação   :  Semanal
      Períodos:
        01/01/91 - 31/12/91 : P1 (0,25) | P3 (0,75)
        01/01/92 - 31/04/92 : P1 (0,25) | P2 (0,75)
        01/05/92 - 31/12/93 : P1 (0,25) | P2 (0,75)

    RESULTADO
      x11 + x12 + x13 + x14 + ...
      x21 + x22 + x23 + x24 + ...
                .
                .
      x71 + x72 + x73 + x74 + ...
      SEP
      x81 + x82 + x83 + x84 + ...
                .
                .
      x14.1 + x14.2 + x14.3 + x14.4 + ...
      SEP
      x15.1 + x15.2 + x15.3 + x15.4 + ...

    ALGORÍTMO

    C <- 0
    Para cada intervalo
      Inicio
      <<<<<< Verificar diferança entre as datas >>>>>>
      Fazer Sub-Matriz do intervalo x Vetor de Ponderadores daquele intervalo
      Dado = 0
      Para cada dia do intervalo --> i
        Inicio
        <<<<<< Verificar diferança entre as datas >>>>>>
        C <- C + 1

        Para cada Posto --> j
          Dado = Dado + Xij

        Escreve Dado no PLU

        Se C = Intervalo de Simulação Então
           Inicio
           Escreve SEP no PLU
           C <- 0
           Fim
        Fim
      Fim
  }
Procedure TDLG_PLU.RealizaPreAnalise(SB: TwsMatrix; Ponderadares: TwsVec; Periodo: Integer);

   Procedure PreencheFalhas(j, Posto, Nulos: Longint);
   var k: Longint;
       x: Double;
       s: String;
       Postos: TStrings;
       DI, DF: String;
   begin
     If Nulos <= dlgOpcoes.Dias.AsInteger Then
        begin
        Case dlgOpcoes.ItemIndex of
          0:          {Atribui Zero} x := 0;
          1: {Menor valor Adjacente} x := Math.Min(SB[j-Nulos-1, Posto], SB[j, Posto]);
          2: {Maior valor Adjacente} x := Math.Max(SB[j-Nulos-1, Posto], SB[j, Posto]);
          3:     {Valor antecedente} x := SB[j-Nulos-1, Posto];
          4:     {Valor subsequente} x := SB[j, Posto];
          5:     {Media dos limites} x := Math.Mean([SB[j-Nulos-1, Posto], SB[j, Posto]]);
          6:        {Valor indicado} x := StrToFloat(dlgOpcoes.ValorIndicado.Text);
          End; {Case}
        For k := (j-Nulos) to (j-1) do SB[k, Posto] := x;
        end
     Else
        begin
        // Obtem as informacoes sobre o periodo dos dados deste posto
        Postos := FInfo.DS.Struct.Cols;
        k := Postos.IndexOf(Grid.Cells[0, Posto + 1]);

        DI := FInfo.DataDoPrimeiroValorValido(Postos[k]);
        DF := FInfo.DataDoUltimoValorValido(Postos[k]);

        s := '';
        if strToDate(Grid.Cells[Periodo, 0]) < strToDate(DI) then
           s := Format('ATENÇÃO:'#13 +
                       'Você definiu um inicio de período (%s) que é anterior'#13 +
                       'ao inicio (%s) dos dados do posto %s.'#13#13,
                       [Grid.Cells[Periodo, 0], DI, Grid.Cells[0, Posto + 1]]);

        if strToDate(Grid.Cells[Periodo, 1]) > strToDate(DF) then
           begin
           if s = '' then s := 'ATENÇÃO:'#13;
           s := s + Format('Você definiu um final de período (%s) que é posterior'#13 +
                           'ao fim (%s) dos dados do posto %s.'#13#13,
                           [Grid.Cells[Periodo, 1], DF, Grid.Cells[0, Posto + 1]]);
           end;

        s := s + 'Não posso construir o arquivo de Precipitações pois'#13 +
                 'o período compreendido entre %s e %s do Posto %s'#13 +
                 'possui falhas superiores a %d dias';

        Raise Exception.CreateFmt(s,
          [Grid.Cells[Periodo, 0],
           Grid.Cells[Periodo, 1],
           Grid.Cells[0, Posto + 1],
           Nulos-1]);
        end;
   end;

var x               : Double;
    Posto,j         : longint;
    Nulos           : longint;
    ValorInvalido   : Boolean;

begin
  For Posto := 1 to Ponderadares.Len do
    If Ponderadares[Posto] > 0.000001 Then
       begin
       Nulos := 0;
       ValorInvalido := False;

       For j := 1 to SB.nRows - 1 do
         begin
         x := SB[j, Posto];
         If (x = wscMissValue) and (not ValorInvalido) Then
            begin
            ValorInvalido := True;
            Nulos := 1;
            end
         Else If x = wscMissValue Then
            inc(Nulos)
         Else If ValorInvalido Then
            begin
            ValorInvalido := False;
            PreencheFalhas(j, Posto, Nulos);
            end;
         end;

         If SB.IsMissValue(SB.nRows, Posto, x) Then
            begin
            inc(Nulos);
            If ValorInvalido Then
               PreencheFalhas(SB.nRows, Posto, Nulos + 1)
            Else
               PreencheFalhas(SB.nRows, Posto, 1);
           end;
       end;
end;

procedure TDLG_PLU.GerarPLU();

   Function MyVecProd(v1, v2: TwsVec): Double;
   var i : Longint;
       b : Double;
   begin
     Result := 0;
     for i := 1 to v1.len do
       begin
       b := v2[i];
       If b <> 0 Then Result := Result + v1[i] * b;
       end
   end; { VecMult }

var i,k:              Longint;
    cont:             Longint;
    LinhaInic:        Longint;
    LinhaFim:         Longint;
    vecPonderadores:  TwsVec;
    SB:               TwsMatrix;
    x:                Double;
    SomaMes:          Double;
    InterSim:         Integer;
    DaysInPeriod:     Integer;
    DataIni:          TDateTime;
    FMensal:          Boolean;
    Mes:              String;
begin
  FnumVals := 0;
  FNum999s := 0;
  FnumCols := dlgOpcoes.edNVL.AsInteger;

  If ValidadaDatasDaGrid (Grid) then
     begin
     m.Buffer.Clear();

     {Para cada Intervalo}
     For k := 2 to Grid.ColCount-1 do
       begin
       {Cria o vetor dos ponderadores: Tamanho = Quantidade de Postos}
       vecPonderadores := TwsDFVec.Create(Grid.RowCount-2);
       For i := 2 to Grid.RowCount-1 do
         Try
           If Grid.Checked[k, i] Then
              vecPonderadores[i-1] := strToFloat(Grid.Cells[k, i])
           Else
              vecPonderadores[i-1] := 0.0;
         Except
           vecPonderadores[i-1] := 0.0;
         End;

       DataIni   := StrToDate(Grid.Cells[k, 0]);
       LinhaInic := FInfo.IndiceDaData(DataIni);
       LinhaFim  := FInfo.IndiceDaData(StrToDate(Grid.Cells[k, 1]));

       SB := FInfo.DS.SubMatrix(LinhaInic,
                                LinhaFim - LinhaInic + 1,
                                cPostos,
                                FInfo.NumPostos);

       Try
       if FInfo.TipoIntervalo = tiDiario then
          begin
          {Faz uma pré-análise dos dados tapando os buracos usando as regras de preenchimento
           definidas pelo usuário para períodos menores que seis dias.
           Se encontrar períodos com falhas superiores a cinco dias o processo é interrompido.}
           RealizaPreAnalise(SB, vecPonderadores, k);

           {Realiza uma multiplicação vetorial entre cada linha da matriz SB pelo
            respectivo vetor de ponderadores para aquele período e escreve o resultado
            no arquivo}
           Cont := 0;
           SomaMes := 0;
           DaysInPeriod := DiasNoPeriodo(cbIntSim.ItemIndex, DataIni);
           InterSim := DiasQueFaltamParaO_UltimoDiaDoPeriodo(DataIni, DaysInPeriod) + 1;

           For i := 1 to SB.nRows do
             begin
             x := MyVecProd(SB.Row[i], vecPonderadores);

             If (cbIntSim.ItemIndex = cINTSIM_DIARIO) Then
                begin
                EscreveValor(m, '0.00', x);
                if (Tipo = 'PLU') Then
                   begin
                   inc(FNum999s);
                   EscreveValor(m, '0.0', cSEP)
                   end;
                end
             Else
                begin
                If (cbIntComp.ItemIndex = cINTCOMP_MENSAL) or (Tipo = 'RPL') Then {Acumula o somatório do mes}
                   SomaMes := SomaMes + x
                Else
                   if Tipo = 'PLU' then
                      EscreveValor(m, '0.00', x);

                inc(Cont);

                If Cont = InterSim Then {Acabou um período}
                   begin
                   If (cbIntComp.ItemIndex = cINTCOMP_MENSAL) or (Tipo = 'RPL') Then
                      begin
                      EscreveValor(m, '0.00', SomaMes);
                      SomaMes := 0;
                      end;

                   if Tipo = 'PLU' then
                      begin
                      inc(FNum999s);
                      EscreveValor(m, '0.0', cSEP); {Sinalização de final de período}
                      end;

                   {Pega quantos dias faltam para o último dia de qualquer período para o dia seguinte}
                   {EX: Dia Atual 07/11/90, vou passar para a funcao 08/11/90 e ela irá me retornar 6 (dias)}
                   {08/11/90 + 6 (dias) = 14/11/90 (ultimo dia da segunda semana se o período for semanal)}
                   DaysInPeriod := DiasNoPeriodo(cbIntSim.ItemIndex, DataIni+i);
                   InterSim := DiasQueFaltamParaO_UltimoDiaDoPeriodo(DataIni+i, DaysInPeriod) + 1;

                   Cont := 0;
                   end;
                end;
             end; // for i
          end // if FInfo.TipoIntervalo = tiDiario
       else
          for i := 1 to SB.nRows do
            begin
            x := MyVecProd(SB.Row[i], vecPonderadores);
            EscreveValor(m, '0.00', x);
            EscreveValor(m, '0.0', cSEP);
            inc(FNum999s);
            end; // for i
       finally
         SB.Free();
         vecPonderadores.Free();
         end;
       end; // for k {Para cada Intervalo}

     EsvaziarBufferDoEditor(m);

     If Save.FileName <> '' Then
        SavePLU.FileName := ChangeFileExt(Save.FileName, '');

     Mes := 'Salvar %s: %d valores gerados';
     if Tipo = 'PLU' then
        Mes := Format(Mes + ' [%d Grupo(s)]', [Tipo, FNumVals, FNum999s])
     else
        Mes := Format(Mes, [Tipo, FNumVals]);

     SavePLU.Title := Mes;
     If SavePLU.Execute() Then
        m.Buffer.SaveToFile(SavePLU.FileName);
     end;
end;

procedure TDLG_PLU.FormCreate(Sender: TObject);
begin
  AjustResolution(Self);
  dlgOpcoes := TdlgPLU_Opcoes.Create(nil);
  m := TfoMemo.Create(' Dados de precipitação gerados');
  m.BorderIcons := [];
  m.FormStyle := fsStayOnTop;
end;

procedure TDLG_PLU.FormDestroy(Sender: TObject);
begin
  m.Free();
  dlgOpcoes.Free;
end;

procedure TDLG_PLU.cbIntCompChange(Sender: TObject);
begin
  cbIntSim.Enabled := (cbIntComp.ItemIndex  <> cINTCOMP_MENSAL);
  If cbIntComp.ItemIndex  = cINTCOMP_MENSAL Then
     cbIntSim .ItemIndex := cINTSIM_MENSAL;

  Atualizar();
end;

Procedure TDLG_PLU.Atualizar();
begin
  btnGerar.Enabled := (Colunas > 1);

  if FInfo.TipoIntervalo = tiMensal then
     btnGerar.Enabled := (cbIntComp.ItemIndex = cINTCOMP_MENSAL) and btnGerar.Enabled;

  //Grid.Enabled := btnGerar.Enabled;
  btnDeletar.Enabled := btnGerar.Enabled;
  btnEditar .Enabled := btnGerar.Enabled;
end;

{Esta Funcao indica se as datas fornecidas na grid sao validas - ou seja os intervalos devem
comecar no primeiro dia do mes e terminar no ultimo dia do mes final, caso seja valida a data,
a funcao retorna True}
Function  TDLG_PLU.ValidadaDatasDaGrid (Grid : TdrStringAlignGrid): Boolean;
var i         : Integer;
    Diferenca : TDateTime;
begin
  Result := True;
  if FInfo.TipoIntervalo = tiDiario then
     begin
     {Teste da primeira data}
     if Not Primeiro_dia_do_mes (StrToDateTime(Grid.Cells[2, 0])) then
        Result := False;

     if (StrToDateTime(Grid.Cells[2, 0]) < FInfo.DataInicial) then
        begin
        Result := False;
        MessageDlg( cMSG4, mtInformation, [mbOk], 0);
        exit;
        end;

     For i := 2 to Grid.ColCount-2  Do
       begin
       {Difenca: é a diferenca entra a primeira data do proximo periodo e a ultima data do periodo atual}
       Diferenca := StrToDateTime(Grid.Cells[i+1,0]) - StrToDateTime(Grid.Cells[i,1]);
       If Diferenca > 1 then
          begin
          if Not Ultimo_dia_do_mes(StrToDateTime(Grid.Cells[i,1])) then Result := False;
          if Not Primeiro_dia_do_mes (StrToDateTime(Grid.Cells[i+1, 0])) then Result := False;
          end;
       end;  {For ...}

     If Not Ultimo_dia_do_mes(StrToDateTime(Grid.Cells[Grid.ColCount-1, 1])) then Result := False;
     end;
end;

procedure TDLG_PLU.btnImprimirClick(Sender: TObject);
var s: String;
    i,j: Integer;
    m: TfoMemo;
begin
  m := TfoMemo.Create(' PLU');

  m.Write('Intervalo de Computação : ' + IntToStr(cbIntComp.ItemIndex));
  m.Write('Intervalo de Simulação  : ' + IntToStr(cbIntSim.ItemIndex));
  m.Write('Dados: ----------------------------------------------------');

  {Dados da grade - Parte 1}
  For i := 0 to Grid.RowCount - 1 do
    begin
    if i < 2 then
       if i = 0 then s := 'Datas Iniciais: ' else s := 'Datas Finais:   '
    else
       s := LeftStr(Grid.Cells[0, i], 17);

    For j := 2 to Grid.ColCount - 1 do
       s := s + LeftStr(Grid.Cells[j, i], 12);

    m.Write(s);
    end;

  m.FormStyle := fsMDIChild;
  m.Show();
  Applic.ArrangeChildrens();
end;

procedure TDLG_PLU.GridKeyPress(Sender: TObject; var Key: Char);
begin
  // Permite a digitação de números reais
  if Key in ['.', ','] then Key := DecimalSeparator;
  Key := ValidateChar(Key, [Digitos, Controles, Virgula, Ponto], True);
end;

procedure TDLG_PLU.btnAutoClick(Sender: TObject);
var L: TListaDePeriodos;
    i, j, ii, n: Integer;
    p: pRecDadosPeriodo;
    x, Soma: Real;
    PostosSel: TStrings;
begin
  // limpa a grade
  for i := 2 to Grid.ColCount-1 do
    for j := 2 to Grid.RowCount-1 do
      begin
      Grid.Cells[i, j] := '';
      Grid.Checked[i, j] := false;
      end;

  // Postos selecionados no processo automático
  PostosSel := TStringList.Create;
  for i := 2 to Grid.RowCount-1 do
    if Grid.Checked[1, i] then
       PostosSel.Add(GetValidID(AllTrim(Grid.Cells[0, i])));

  L := ObtemPeriodos(FInfo, True, PostosSel);
  PostosSel.Free;

  Grid.ColCount := L.NumPeriodos + 2;
  Sum.ColCount  := Grid.ColCount - 1;
  Colunas       := L.NumPeriodos + 1;

  for i := 0 to L.NumPeriodos-1 do
    begin
    p := L.Periodo[i];
    Grid.Cells[i+2,0] := DateToStr(p.DI);
    Grid.Cells[i+2,1] := DateToStr(p.DF);
    Soma := 0;
    for ii := 0 to FInfo.NumPostos-1 do
      if ii in p.Postos then
         begin
         Grid.Checked[i+2, ii+2] := True;
         Soma := Soma + StrToFloatDef(Grid.Cells[1, ii+2], 0)
         end;

    for ii := 0 to FInfo.NumPostos-1 do
      if ii in p.Postos then
         begin
         if Soma <> 0 then x := StrToFloatDef(Grid.Cells[1, ii+2], 0) / Soma else x := 0;
         Grid.Cells[i+2, ii+2] := FormatFloat('0.##', x);
         end;
    end;

  L.Free();
  Atualizar();
end;

procedure TDLG_PLU.EscreveValor(m: TfoMemo; const Format: String; const Valor: Real);
var sValor: String;
begin
  if FNumVals = 0 then FBufferEditor := '';
  inc(FNumVals);

  if Valor > cSEP then
     sValor := ChangeChar(FormatFloat(Format, Valor), ',', '.')
  else
     sValor := AllTrim(dlgOpcoes.edSep.Text);

  if sValor <> '' then
     if FNumCols > 1 then
        begin
        FBufferEditor := FBufferEditor + RightStr(sValor, 10) + ' ';
        if (FNumVals mod FNumCols) = 0 then
           begin
           m.Write(FBufferEditor);
           FBufferEditor := '';
           end;
        end
     else
        m.Write(sValor);
end;

procedure TDLG_PLU.EsvaziarBufferDoEditor(m: TfoMemo);
begin
  if FNumCols > 1 then
     begin
     m.Write(FBufferEditor);
     FBufferEditor := '';
     end;
end;

procedure TDLG_PLU.btnGerarClick(Sender: TObject);
begin
  WinUtils.StartWait();
  try
    m.Hide();
    Application.ProcessMessages();
    GerarPLU();
    m.Show();
  finally
    WinUtils.StopWait();
  end;
end;

procedure TDLG_PLU.btnImportarClick(Sender: TObject);

    function SelecionarPosto(Posto: string): boolean;
    var i: Integer;
    begin
      result := false;
      for i := 2 to Grid.RowCount-1 do
        if Grid.Cells[0, i] = Posto then
           begin
           Grid.Checked[1, i] := true;
           result := true;
           break;
           end;
    end;

    procedure EstabelecerValores(Valores: TStrings);
    var i, k: Integer;
    begin
      // Acha o posto
      for i := 2 to Grid.RowCount-1 do
        if Grid.Cells[0, i] = Valores[0] then
           begin
           k := i;
           break;
           end;

      // Estabelece os valores dos periodos
      for i := 2 to Grid.ColCount-1 do
        Grid.Cells[i, k] := Valores[i-1];
    end;

    procedure LoadFile(Filename: string);
    var arq, sl: TStrings;
        i, k: integer;
        s: string;
    begin
      sl := nil;
      arq := SysUtilsEx.LoadTextFile(Filename);
      try
        if arq.Count > 0 then
           begin
           // Seleciona na grade os postos do arquivo
           k := 0;
           for i := 1 to arq.Count-1 do
             begin
             // obtem o nome do posto
             s := System.Copy(arq[i], 1, System.Pos(';', arq[i]) - 1);
             if SelecionarPosto(s) then inc(k);
             end;

           // Verifica se houve pelo menos um posto selecionado
           if k = 0 then
              raise Exception.Create('Postos não encontrados');

           // Executa o auto-processamento para validacao do arquivo
           btnAutoClick(Sender);

           // A 1. linha devera ser o cabecalho
           SysUtilsEx.Split(arq[0], sl, [';']);

           // O numero de periodos no arquivo devera ser compativel com o numero
           // de periodos calculado internamente com os postos selecionados.
           if (sl.Count-1) <> (Grid.ColCount-2) then
              raise Exception.CreateFmt(
                'O número de periodos no arquivo (%d) é diferente do da grade (%d)',
                [sl.Count-1, Grid.ColCount-2]);

           // Obtem os valores
           for i := 1 to arq.Count-1 do
             begin
             SysUtilsEx.Split(arq[i], sl, [';']);
             EstabelecerValores(sl);
             end;

           // Atualiza a linha dos somatorios
           AtualizarSomatorio();
           end;
      finally
        arq.Free();
        sl.Free();
      end;
    end;

begin
  Importar.InitialDir := Applic.LastDir;
  If Importar.Execute() Then
     begin
     // Faz a leitura e validacao
     Applic.LastDir := ExtractFilePath(Importar.FileName);
     LoadFile(Importar.FileName);
     Atualizar();
     end;
end;

procedure TDLG_PLU.LimparGrade();
begin
  Grid.Clear(false);
  Grid.ColCount := 2;
end;

procedure TDLG_PLU.AtualizarSomatorio();
var i: Integer;
begin
  for i := 1 to Grid.ColCount - 1 do
    GridSetEditText(nil, i, -1, '');
end;

procedure TDLG_PLU.btnSelPerClick(Sender: TObject);
var d: TfoPLU_SelPerCont;
    i: integer;
    s: string;
    p1, p2: string;

    procedure Selecionar(p1, p2: string);
    var p1a, p2a: string;
        p1b, p2b: string;
        c1, c2, i: integer;
        y, m, d: word;
        b: boolean;
        s: string;
    begin
      SysUtilsEx.SubStrings('-', p1a, p1b, p1, true);
      SysUtilsEx.SubStrings('-', p2a, p2b, p2, true);

      // Acha a coluna do 1. intervalo
      for i := 2 to Grid.ColCount-1 do
        if Grid.Cells[i, 0] = p1a then
           begin
           c1 := i;
           break;
           end;

      // Acha a coluna do 2. intervalo
      for i := (c1 + 1) to Grid.ColCount-1 do
        if Grid.Cells[i, 0] = p2a then
           begin
           c2 := i;
           break;
           end;

      // Tenta achar um intervalo anual inteiro (pode ser de mais de um ano) ...

      // Acha o 1. intervalo a partir de c1 que inicie em 01/01/ano
      b := false;
      for i := c1 to c2 do
        begin
        p1 := Grid.Cells[i, 0];
        DecodeDate(strToDate(p1), y, m, d);
        if (d = 1) and (m = 1) then
           begin
           b := true;
           c1 := i;
           break;
           end;
        end; // for i

      if not b then
         raise Exception.Create('Não foi encontrado um período inicial que começasse em 01/01/ano');

      // Acha o 2. intervalo igual ou antes de c2 que termine em 31/12/ano
      b := false;
      for i := c2 downto c1 do
        begin
        p2 := Grid.Cells[i, 1];
        DecodeDate(strToDate(p2), y, m, d);
        if (d = 31) and (m = 12) then
           begin
           b := true;
           c2 := i;
           break;
           end;
        end; // for i

      if not b then
         raise Exception.Create('Não foi encontrado um período final que terminasse em 31/12/ano');

      // Remove os periodos inuteis se o usuario concordar
      s := Format('Período encontrado: %s (P%d) - %s (P%d)', [p1, c1-1, p2, c2-1]);
      s := s + #13 + 'Deseja eliminar os outros períodos ?';
      if MessageDLG(s, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
         begin
         Grid.RemoveCols(2, c1 - 2);
         c2 := c2 - (c1 - 2);
         Grid.ColCount := c2 + 1;
         Sum.ColCount := Grid.ColCount;
         end;
    end;

begin
  d := TfoPLU_SelPerCont.Create(nil);

  // Mostra os periodos no dialogo
  for i := 2 to Grid.ColCount-1 do
    begin
    s := Format('%3d: ( %s - %s )', [i-1, Grid.Cells[i, 0], Grid.Cells[i, 1]]);
    d.frPer.lbItems.AddItem(s, nil);
    end;

  if d.ShowModal = mrOk then
     begin
     p1 := SubString(d.frPer.ItemsSel[0], '(', ')');
     p2 := SubString(d.frPer.ItemsSel[1], '(', ')');
     Selecionar(p1, p2);
     end;

  d.Release();
end;

end.
