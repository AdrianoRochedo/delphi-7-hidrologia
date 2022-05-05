unit EstatisticasPorAgrupamentos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,
  drPlanilha,
  wsVec,
  wsMatrix,
  pro_Classes,
  pro_fr_getValidIntervals,
  pro_fr_StationSelections;

type
  TDLG_EstatisticasPorAgrupamentos = class(TForm)
    GroupBox1: TGroupBox;
    rbMedias: TRadioButton;
    rbTotais: TRadioButton;
    Label1: TLabel;
    cbPeriodo: TComboBox;
    btnOk: TButton;
    btnCancel: TButton;
    F_PerVal: TFrame_PeriodosValidos;
    F_SelPostos: TFrame_SelecaoDePostos;
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
  private
    // Para controle dos dados
    FDSO        : TwsDataSet; // Dados dos Postos
    FvIndPostos : TwsLIVec;   // Índice dos postos escolhidos

    // Auxiliares para as estatísticas
    FValValidos         : Integer;
    FMed, FDSP, FCV     : Double;
    FTemValPerdido      : TwsSIVec;
    FTemValPerdidoNaCol : TwsSIVec;

    // Para controle da Planilha
    Fp      : TPlanilha; // Planilha atual que está sendo criada
    FpLinha : Integer;   // Indica qual linha está em uso

    FInfo: TDSInfo;

    procedure ColocaLinhaNaPlanilha(const Titulo: String; v: TwsVec);
    procedure CalculaEstatisticasParaColunas;
    procedure CalculaEstatisticasParaLinha(v: TwsVec);
    procedure PreparaCabecalho;
  public
    constructor Create(Info: TDSInfo);
  end;

implementation
uses pro_Procs, wsgLib, SysUtilsEx, Form_Chart,
     Series, GraphicUtils, WinUtils, wsConstTypes, pro_Const;

{$R *.DFM}

procedure TDLG_EstatisticasPorAgrupamentos.PreparaCabecalho;
var i: Integer;
begin
  i := FvIndPostos.Len;
  fp.ColText[i+2] := 'MED';
  fp.ColText[i+3] := 'DSP';
  fp.ColText[i+4] := 'CV';
  for i := 1 to FvIndPostos.Len do
    fp.ColText[i+1] := FDSO.Struct.Col[FvIndPostos[i]].Name;

  // Escreve os nomes também na primeira linha (para permitir cópia para a clipboard)
  FDSO.ColNamesToSheet(FvIndPostos, Fp);

  Fp.SetCellFont(1, FvIndPostos.Len + 2, 'Arial', 10, clBlack, True);
  Fp.SetCellFont(1, FvIndPostos.Len + 3, 'Arial', 10, clBlack, True);
  Fp.SetCellFont(1, FvIndPostos.Len + 4, 'Arial', 10, clBlack, True);
  Fp.WriteCenter(1, FvIndPostos.Len + 2, 'MED');
  Fp.WriteCenter(1, FvIndPostos.Len + 3, 'DSP');
  Fp.WriteCenter(1, FvIndPostos.Len + 4, 'CV');
  Fp.Caption := ' AGRUPAMENTO: ';

  if rbTotais.Checked then
     Fp.Caption := Fp.Caption + 'Total'
  else
     Fp.Caption := Fp.Caption + 'Média';

  Fp.Caption := Fp.Caption + '    INTERVALO: ' + cbPeriodo.Items[cbPeriodo.ItemIndex];
end;

procedure TDLG_EstatisticasPorAgrupamentos.CalculaEstatisticasParaColunas;
var Stats : TwsLIVec;
    Estatisticas : TwsGeneral;
    i: Integer;
    v: TwsVec;
    Cor: TColor;
begin
  // Estatísticas que serão calculadas
  Stats := TwsLIVec.CreateFromArray([ord(teMedia), ord(teDPadr), ord(teCVar)]);
  Estatisticas := FDSO.DescStat(FvIndPostos, Stats);

  for i := 1 to Estatisticas.NRows do
    begin
    if Boolean(FTemValPerdidoNaCol[i]) then Cor := clRed else Cor := clBlue;
    Fp.SetCellFont(FpLinha+1, i+1, 'Arial', 10, Cor);
    Fp.SetCellFont(FpLinha+2, i+1, 'Arial', 10, Cor);
    Fp.SetCellFont(FpLinha+3, i+1, 'Arial', 10, Cor);
    Fp.Write(FpLinha+1, i+1, Estatisticas[i, 1]); // Media
    Fp.Write(FpLinha+2, i+1, Estatisticas[i, 2]); // Desv. Padrão
    Fp.Write(FpLinha+3, i+1, Estatisticas[i, 3]); // Coeficiente de variação
    end;

  Fp.SetCellFont(FpLinha+1, 1, 'Arial', 10, clBlack, True);
  Fp.SetCellFont(FpLinha+2, 1, 'Arial', 10, clBlack, True);
  Fp.SetCellFont(FpLinha+3, 1, 'Arial', 10, clBlack, True);
  Fp.Write(FpLinha+1, 1, 'MED');
  Fp.Write(FpLinha+2, 1, 'DSP');
  Fp.Write(FpLinha+3, 1, 'CV');

  // Calcula as médias das estatísticas das últimas tres linhas
  for i := 1 to Estatisticas.nCols do
    begin
    v := Estatisticas.CopyCol(i);
    Fp.Write(FpLinha+i, Estatisticas.nRows+2, v.Mean(FValValidos)); v.Free;
    Fp.SetCellFont(FpLinha+i, Estatisticas.nRows+2, 'Arial', 10, clBlue, True);
    end;

  Stats.Free;
  Estatisticas.Free;
end;

procedure TDLG_EstatisticasPorAgrupamentos.CalculaEstatisticasParaLinha(v: TwsVec);
begin
  v.PartialVec_Mean_DSP_CV(1, v.Len, FValValidos, FMed, FDSP, FCV);
  Fp.Write(FpLinha, v.Len + 2, FMed);
  Fp.Write(FpLinha, v.Len + 3, FDSP);
  Fp.Write(FpLinha, v.Len + 4, FCV);
end;

procedure TDLG_EstatisticasPorAgrupamentos.ColocaLinhaNaPlanilha(const Titulo: String; v: TwsVec);
var i: Integer;
begin
  Fp.Write(FpLinha, 1, Titulo); // Escreve o cabeçalho da linha na primeira coluna da planilha
  Fp.WriteVecInRow(v, FpLinha, 2);

  // Escreve em vermelho caso exista um valor perdino nos dados que foram agrupados
  for i := 1 to FTemValPerdido.Len do
    if Boolean(FTemValPerdido[i]) then
       begin
       Fp.SetCellFont(FpLinha, i+1, 'Arial', 10, clRed);
       FTemValPerdidoNaCol[i] := 1;
       end;
end;

procedure TDLG_EstatisticasPorAgrupamentos.btnOkClick(Sender: TObject);
var v             : TwsVec;
    i, j          : Integer;
    cont          : Integer;
    DaysInPeriod  : Integer;
    InterSim      : Integer;
    aux           : Double;
    DataIni       : TDate;
    DataAtual     : TDate;
    Ano, Mes, Dia : Word;
    ParteDoMes    : Byte;
    g             : TfoChart;
    Linha         : TLineSeries;
    s             : String;
    LI, LF        : Integer;
begin
  Screen.Cursor := crHourGlass;
  FDSO := FInfo.DS;

  F_PerVal.ValidarDatas;

  FvIndPostos         := F_SelPostos.ObtemIndiceDosPostosSelecionados;
  FTemValPerdido      := TwsSIVec.Create(FvIndPostos.Len);
  FTemValPerdidoNaCol := TwsSIVec.Create(FvIndPostos.Len);

  FTemValPerdido.Fill(0);
  FTemValPerdidoNaCol.Fill(0);

  v := VecConst(0, FvIndPostos.Len);

  Try
    FpLinha := 1;
    Cont := 0;
    DataIni := Finfo.DataInicial;
    DaysInPeriod := DiasNoPeriodo(cbPeriodo.ItemIndex + 1, DataIni);
    InterSim := DiasQueFaltamParaO_UltimoDiaDoPeriodo(DataIni, DaysInPeriod) + 1;

    Fp := TPlanilha.Create;
    PreparaCabecalho;

    F_PerVal.ObtemIndiceDasDatas(LI, LF);

    For i := LI to LF Do
      begin
      inc(Cont);
      DataAtual := DataIni + i - 1;

      //calcula o somatorio dos valores
      for j := 1 to v.Len do
        begin
        aux := FDSO[i, FvIndPostos[j]];
        if IsMissValue(aux) then FTemValPerdido[j] := 1 else v[j] := v[j] + aux;
        end;

      If Cont = InterSim Then {Acabou um período}
         begin
         //calcula as média dos valores
         if rbMedias.Checked then
            for j := 1 to v.Len do
               if not IsMissValue(v[j]) then
                  v[j] := v[j] / Cont;

         DecodeDate(DataAtual, Ano, Mes, Dia);
         inc(ParteDoMes);
         case cbPeriodo.ItemIndex of
           0: begin
              s := Format('"%d. Quinq. de %s de %d"', [ParteDoMes, cNomeCurtoMes[Mes], Ano]);
              if ParteDoMes = 6 then ParteDoMes := 0;
              end;
           1: begin
              s := Format('"%d. Sem. de %s de %d"', [ParteDoMes, cNomeCurtoMes[Mes], Ano]);
              if ParteDoMes = 4 then ParteDoMes := 0;
              end;
           2: begin
              s := Format('"%d. Dec. de %s de %d"', [ParteDoMes, cNomeCurtoMes[Mes], Ano]);
              if ParteDoMes = 3 then ParteDoMes := 0;
              end;
           3: begin
              s := Format('"%d. Quinz. de %s de %d"', [ParteDoMes, cNomeCurtoMes[Mes], Ano]);
              if ParteDoMes = 2 then ParteDoMes := 0;
              end;
           4: s := '"' + cNomeCurtoMes[Mes] + ' de ' + intToStr(Ano) + '"';
           end;

         inc(FpLinha);

         ColocaLinhaNaPlanilha(s, v);
         CalculaEstatisticasParaLinha(v); // Calcula as estatísticas de cada linha

         // Prepara outro ciclo ...

         Cont := 0;
         v.Fill(0);
         FTemValPerdido.Fill(0);
         DaysInPeriod := DiasNoPeriodo(cbPeriodo.ItemIndex + 1, DataAtual + 1);

         {Pega quantos dias faltam para o último dia de qualquer período para o dia seguinte}
         {EX: Dia Atual 07/11/90, vou passar para a funcao 08/11/90 e ela irá me retornar 6 (dias)}
         {08/11/90 + 6 (dias) = 14/11/90 (ultimo dia da segunda semana se o período for semanal)}
         InterSim := DiasQueFaltamParaO_UltimoDiaDoPeriodo(DataIni+i, DaysInPeriod) + 1;
         end;
      end;

    CalculaEstatisticasParaColunas;
    Fp.Show(fsNormal);

    // Mostra um gráfico com os dados agrupados
    g := TfoChart.Create;
    g.FormStyle := fsNormal;
    for i := 1 to FvIndPostos.Len do
      begin
      Linha := g.Series.AddLineSerie(FDSO.Struct.Col[FvIndPostos[i]].Name, SelectColor(i));
      for j := 2 to FpLinha do
        Linha.Add(Fp.GetFloat(j, i+1));
      end;
    g.Left := 500;
    g.Top := 200;
    g.Show(fsMDIChild);

  Finally
    FTemValPerdido.Free;
    FTemValPerdidoNaCol.Free;
    FvIndPostos.Free;
    v.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure TDLG_EstatisticasPorAgrupamentos.FormShow(Sender: TObject);
begin
  cbPeriodo.ItemIndex := 4;
  FInfo.MostrarPostos(F_SelPostos.clPostos.Items);
  F_PerVal.Mostrar(FInfo);
end;

procedure TDLG_EstatisticasPorAgrupamentos.FormCreate(Sender: TObject);
begin
  AjustResolution(Self);
end;

procedure TDLG_EstatisticasPorAgrupamentos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDLG_EstatisticasPorAgrupamentos.btnCancelClick(Sender: TObject);
begin
  Close;
end;

constructor TDLG_EstatisticasPorAgrupamentos.Create(Info: TDSInfo);
begin
  Inherited Create(nil);
  FInfo := Info;
end;

end.
