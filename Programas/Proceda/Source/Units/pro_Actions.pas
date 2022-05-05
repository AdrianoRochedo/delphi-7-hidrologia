unit pro_Actions;

interface
uses Classes, menus, comCTRLs,
     SysUtilsEx,
     Skin,
     wsConstTypes,
     wsMatrix,
     pro_Interfaces,
     pro_DB_Interfaces,
     pro_BaseClasses,
     pro_Classes,
     pro_Application,
     wsBXML_Output;                

type
  Tch_ActionManager = class
  private
    FTV: TTreeView;

    // Campos privados que poderao ser utilizados apos a chamada de "CalculateCorrelation"
    // dependendo dos parametros passados.
    // Olhar o método "Corr_CreatedObjectHandler" para maiores detalhes
    FMatCorr: TwsSymmetric;
    FMatCorrTests: TwsGeneral;

    // Matriz criada no evento "ARL_CreatedObjectHandler" apos chamada de "FazerAnaliseDeRegressaoLinear"
    FCoefTable: TwsDataSet;

    // O calculo de correlacoes eh utilizado de duas maneiras:
    //   - Report <> nil: os resultados sao somente mostrados em um relatorio
    //   - Report  = nil: os resultados sao gerenciados pelo usuario e nenhum rel. eh mostrado
    procedure CalculateCorrelation(
                ds: TwsDataset;
                Vars: TStrings;
                Report: TwsBXML_Output;
                COE: TwsCreatedObject_Event);

    // Gerenciador do evento de "objetos criados" de "CalculateCorrelation()"
    procedure Corr_CreatedObjectHandler(Sender, Obj: TObject);

    // Gerenciador do evento de "objetos criados" de "FazerAnaliseDeRegressaoLinear()"
    procedure ARL_CreatedObjectHandler(Sender, Obj: TObject);

    procedure CalcularSerie(const Nome: String);
    procedure AdicionarSerie(Posto: TStation; Serie: TSerie; no: TTreeNode);
    procedure ShowDataset(ds: TwsDataset);
    procedure ImportarPostosDoBD();
    procedure DescEstats(ds: TwsDataset; Vars: TStrings);
    procedure FrequencyAnalisys(ds: TwsDataset; Vars: TStrings);

    function CriarDistrib(const Tipo: string): TSkin;

    // Verifica se todos os postos sao do mesmo tipo (diarios ou mensais)
    procedure VerifyStationTypes();

    // Verifica se todos os postos possuem o mesmo tamanho
    procedure VerifyStationsLength();

    // Verifica se as series da selecao possuem o mesmo tamanho, senao gera uma excecao.
    procedure VerifySeriesLength();

    // Verifica se as series iniciam e terminam na mesma data
    // Valido somente para series mensais
    procedure VerifyBeginEndOfMonthSeries();

    // Verifica se as series iniciam e terminam no mesmo ano
    // Valido somente para series anuais
    procedure VerifyBeginOfYearSeries();

    // Converte as series selecionadas na arvore para um dataset
    function SeriesToDataset(): TwsDataset;

    // Converte os postos selecionadas na arvore para um dataset
    function StationsToDataset(): TwsDataset;

    // Válido somente para séries mensais
    // Retorna um dataset onde cada coluna é formada por todos os meses "aMonth" de uma série
    function SeriesToDatasetOfOneMonth(aMonth: integer): TwsDataset;

    // Realiza uma analise de Regressao Linear
    // Retornam dois coeficientes: y = ax + b (a e b)
    // y e x sao as series
    procedure FazerAnaliseDeRegressaoLinear(ds: TwsDataset; Modelo: string; Report: TwsBXML_Output; out a, b: double);

    // Realiza um ajuste de distribuicies para as series selecionadas
    // Se "Mes" estiver entre 1 e 12 o ajuste somente sera feito neste mes
    // "Mes" soh tem relevancia para series mensais.
    procedure AjustarDistrib(Tipo: string; Mes: integer);
  public
    constructor Create(aTreeView: TTreeView);

    // Eventos de uma Dataset
    procedure DSInfo_Gantt (Sender: TObject);
    procedure DSInfo_Correl (Sender: TObject);
    procedure DSInfo_Fechar (Sender: TObject);
    procedure DSInfo_VisualizarComoPlanilha (Sender: TObject);
    procedure DSInfo_VisualizarComoHTML (Sender: TObject);

    // Eventos dos Postos
    procedure RemoveStation (Sender: TObject);
    procedure FulfilFault_RecursiveMean_Event(Sender: TObject);
    procedure AnalyzeFaults_Event(Sender: TObject);
    procedure FulfilFault_Const_Event(Sender: TObject);
    procedure ShowStation_Event(Sender: TObject);
    procedure ShowStation_Col_Event(Sender: TObject);
    procedure PlotStation_Event(Sender: TObject);
    procedure PlotStation_Col_Event(Sender: TObject);
    procedure Posto_GerarDS(Sender: TObject);
    procedure Posto_Unir(Sender: TObject);
    procedure Posto_Correlacoes(Sender: TObject);
    procedure Posto_EstatDesc(Sender: TObject);
    procedure ShowStationMM_Ind_Event(Sender: TObject);

    // Eventos individuais das Séries
    procedure SerieVetor_Ind_Fechar (Sender: TObject);
    procedure SerieVetor_Ind_CriarMaximosDiariosAnuais (Sender: TObject);
    procedure SerieVetor_Ind_CriarMinimosDiariosAnuais (Sender: TObject);
    procedure SerieVetor_Ind_TotaisAnuais (Sender: TObject);
    procedure SerieVetor_Ind_MediasAnuais (Sender: TObject);
    procedure SerieVetor_Ind_MinimasAnuais (Sender: TObject);
    procedure SerieVetor_Ind_TotaisMensais (Sender: TObject);
    procedure SerieVetor_Ind_MediasMensais (Sender: TObject);
    procedure SerieVetor_Ind_TotaisMensaisAnuais (Sender: TObject);
    procedure SerieVetor_Ind_MostrarEmPlanilha (Sender: TObject);
    procedure SerieVetor_Ind_MostrarEmPlanilha_Mes_a_Mes (Sender: TObject);
    procedure SerieVetor_Ind_Graficos (Sender: TObject);
    procedure SerieVetor_Ind_AjustDistrib (Sender: TObject);
    procedure SerieVetor_Ind_AdimMedia (Sender: TObject);
    procedure SerieVetor_Ind_ConvVals (Sender: TObject);
    procedure SerieVetor_Ind_LogNep (Sender: TObject);
    procedure SerieVetor_Ind_PostoAdmensionalizado (Sender: TObject);
    procedure SerieVetor_Ind_ValoresDoPosto (Sender: TObject);
    procedure SerieVetorMensal_Ind_AjustDistrib (Sender: TObject);
    procedure SerieVetorMensal_Ind_MediasMesais (Sender: TObject);
    procedure SerieVetorMensal_Ind_MediasAnuais (Sender: TObject);

    // Eventos individuais das Séries Parciais
    procedure SerieVetor_Ind_Parcial_Maximos_Diario (Sender: TObject);
    procedure SerieVetor_Ind_Parcial_Minimos_Diario (Sender: TObject);
    procedure SerieVetor_Ind_Parcial_Maximas_TotalMensal (Sender: TObject);
    procedure SerieVetor_Ind_Parcial_Minimas_TotalMensal (Sender: TObject);
    procedure SerieVetor_Ind_Parcial_Maximas_MediaMensal (Sender: TObject);
    procedure SerieVetor_Ind_Parcial_Minimas_MediaMensal (Sender: TObject);
    procedure SerieVetor_Ind_Parcial_MostrarEmPlanilha (Sender: TObject);

    // Eventos coletivos das Séries
    procedure SerieVetor_Col_Graficar (Sender: TObject);
    procedure SerieVetor_Col_MostrarEmPlanilha( Sender: TObject);
    procedure SerieVetor_Col_CurvaPerm( Sender: TObject);
    procedure SerieVetor_Col_DuplaMassa ( Sender: TObject);
    procedure SerieVetor_Col_CCC (Sender: TObject);
    procedure SerieVetor_Col_CCC_MM (Sender: TObject);
    procedure SerieVetor_Col_PF_MM (Sender: TObject);
    procedure SerieVetor_Col_EstDesc (Sender: TObject);
    procedure SerieVetor_Col_Frequency (Sender: TObject);
    procedure SerieVetor_Col_Histograma (Sender: TObject);
    procedure SerieVetor_Col_ConverterParaPostos (Sender: TObject);
    procedure SerieVetor_Col_MediaDasSeriesMensais (Sender: TObject);
    procedure SerieVetor_Col_PFA (Sender: TObject);

    // Eventos individuais dos Banco de Dados
    procedure Database_Disconnect (Sender: TObject);

    // Eventos individuais das Tabelas de Banco de Dados
    procedure Table_View (Sender: TObject);

    // Eventos dos postos de uma tabela do Banco de dados Hidro (Access - ADO)
    procedure ADO_Hidro_Posto_CP (Sender: TObject);

    // Scripts
    procedure Scripts_Adicionar (Sender: TObject);

    // Script
    procedure Script_Executar (Sender: TObject);
    procedure Script_Editar (Sender: TObject);
    procedure Script_Remover (Sender: TObject);
  end;

var
  ActionManager: Tch_ActionManager;

implementation
uses Controls,
     DateUtils,
     Forms,
     Graphics,
     Contnrs,
     TeEngine,
     Series,
     wsVec,
     wsgLib,
     wsGraficos,
     wsCorrelacoes,
     wsMasterModel,
     BXML_Viewer,
     Form_Chart,
     Dialogs,
     MonthDialog,
     SysUtils,
     WinUtils,
     GraphicUtils,
     TreeViewUtils,
     DialogUtils,
     SpreadSheetBook,
     GaugeFO,
     pro_DB_Classes,
     pro_GRP_Gantt,
     pro_Skins_Dist,
     pro_fo_DefineDates,
     pro_fo_Series_LinearModel,
     pro_fo_Series_DescEstats,
     pro_fo_Series_FrequencyAnalisys;
{
     GRF_ProbDist,
     GRF_Dist_WithParameters,
     GRF_Dist_OneParameter,
     GRF_Dist_TwoParameters,
     GRF_Dist_ThreeParameters;
}

{ Tch_ActionManager }

procedure Tch_ActionManager.VerifySeriesLength();
var i,t   : integer;
    Serie : TSerie;
begin
  t := TSerie(FTV.Selections[0].Data).Dados.Len;
  for i := FTV.SelectionCount-1 downto 1 do
    begin
    Serie := TSerie(FTV.Selections[i].Data);
    if Serie.Dados.Len <> t then
       raise Exception.Create('As séries precisam possuir o mesmo número de elementos');
    end;
end;

function Tch_ActionManager.SeriesToDataset(): TwsDataset;
var i,j,k,t : integer;
    Serie : TSerie;
begin
  // Obtem o maior tamanho
  t := -1;
  for i := FTV.SelectionCount-1 downto 0 do
    begin
    Serie := TSerie(FTV.Selections[i].Data);
    if Serie.Dados.Len > t then t := Serie.Dados.Len;
    end;

  // Cria um conjunto de dimensão [t, FTV.SelectionCount] inicializado com MissValue
  result := TwsDataset.CreateNumeric('Series', t, FTV.SelectionCount);

  // Passa os dados das series para o conjunto
  k := 0;
  for i := FTV.SelectionCount-1 downto 0 do
    begin
    Serie := TSerie(FTV.Selections[i].Data);
    result.Struct.Cols[k] := char(65 + k);
    result.Struct.Col[k+1].Name := char(65 + k);
    result.Struct.Col[k+1].Lab := Serie.NomeCompleto;
    for j := 1 to Serie.Dados.Len do
      result[j, k+1] := Serie.Dados[j];
    inc(k);
    end;
end;

procedure Tch_ActionManager.AdicionarSerie(Posto: TStation; Serie: TSerie; no: TTreeNode);
begin
  Posto.AdicionarSerie(Serie);
  FTV.Items.AddChildObject(no, Serie.Nome, Serie);
  no.Expand(false);
end;

procedure Tch_ActionManager.CalcularSerie(const Nome: String);
var i          : Integer;
    Posto      : TStation;
    no         : TTreeNode;
    Progress   : TDLG_Progress;
    ValorBase  : Real;
    s          : String;
    SerieAnual : TSerie_Anual_Minimos;
    TamMedia   : integer;
    MesInicial : integer;
begin
  if System.pos('.Parc', Nome) > 0 then
     begin
     s := InputBox('Séries Parciais', 'Entre com um valor Base', '10');
     ValorBase := StrToFloatDef(s, 10);
     end;

  if System.pos('Anuais', Nome) > 0 then
     if not TMonthDialog.getMonth(MesInicial) then
        Exit;

  if (Nome = 'Minimos Anuais') then
     begin
     s := InputBox('Séries Anuais', 'Entre com o tamanho da média móvel (dias)', '7');
     TamMedia := StrToIntDef(s, 7);
     end;

  {$ifndef DEBUG}
  Progress := CreateProgress(-1, -1, FTV.SelectionCount, 'Gerando Séries ...');
  {$endif}
  try
    for i := 0 to FTV.SelectionCount-1 do
      begin
      no := FTV.Selections[i];
      Posto := TStation(no.Data);

      {$ifndef DEBUG}
      Progress.Msg := 'Gerando série de ' + Posto.Nome;
      Progress.Value := i+1;
      if Progress.Cancelar then Exit;
      {$endif}

      // Series Anuais

      if (Nome = 'Maximos Diarios Anuais') then
         AdicionarSerie(Posto, TSerie_Anual_Diaria_Maximos.Create(Posto, MesInicial), no)
      else

      if (Nome = 'Minimos Diarios Anuais') then
         AdicionarSerie(Posto, TSerie_Anual_Diaria_Minimos.Create(Posto, MesInicial), no)
      else

      if (Nome = 'Minimos Anuais') then
         begin
         SerieAnual := TSerie_Anual_Minimos.Create(Posto, MesInicial, TamMedia);
         AdicionarSerie(Posto, SerieAnual, no);
         end
      else

      if (Nome = 'Totais Anuais') then
         AdicionarSerie(Posto, TSerie_Anual_Agregada_Totais.Create(Posto, MesInicial), no)
      else

      if (Nome = 'Medias Anuais') then
         AdicionarSerie(Posto, TSerie_Anual_Agregada_Medias.Create(Posto, MesInicial), no)
      else

      if (Nome = 'Totais Mensais Anuais') then
         AdicionarSerie(Posto, TSerie_Anual_Mensal_AG_Total_Medias.Create(Posto, MesInicial), no)
      else

      // Series Mensais

      if (Nome = 'Totais Mensais') then
         AdicionarSerie(Posto, TSerie_Mensal_Total.Create(Posto), no)
      else

      if (Nome = 'Medias Mensais') then
         AdicionarSerie(Posto, TSerie_Mensal_Media.Create(Posto), no)
      else

      // Series Parciais

      if (Nome = 'Min.Dia.Parc') then
         AdicionarSerie(Posto, TSerie_Parcial_Diaria_Minimos.Create(Posto, 10), no)
      else

      if (Nome = 'Min.Tot.Mens.Parc') then
         AdicionarSerie(Posto, TSerie_Parcial_TotalMensal_Minimas.Create(Posto, 10), no)
      else

      if (Nome = 'Min.Med.Mens.Parc') then
         AdicionarSerie(Posto, TSerie_Parcial_MediaMensal_Minimas.Create(Posto, 10), no)
      else

      if (Nome = 'Max.Dia.Parc') then
         AdicionarSerie(Posto, TSerie_Parcial_Diaria_Maximos.Create(Posto, 10), no)
      else

      if (Nome = 'Max.Tot.Mens.Parc') then
         AdicionarSerie(Posto, TSerie_Parcial_TotalMensal_Maximas.Create(Posto, 10), no)
      else

      if (Nome = 'Max.Med.Mens.Parc') then
         AdicionarSerie(Posto, TSerie_Parcial_MediaMensal_Maximas.Create(Posto, 10), no)
      else

      // Outras Series

      if (Nome = 'Posto Admensionalizado') then
         AdicionarSerie(Posto, TSerie_PostoAdmensionalizado.Create(Posto), no)
      else

      if (Nome = 'Valores do Posto') then
         AdicionarSerie(Posto, TSerie_ValoresDoPosto.Create(Posto), no)
      else

      // ...
      end;
    finally
      {$ifndef DEBUG}
      Progress.Free;
      {$endif}
    end;
end;

constructor Tch_ActionManager.Create(aTreeView: TTreeView);
begin
  inherited Create;
  FTV := aTreeView;
end;     

procedure Tch_ActionManager.DSInfo_VisualizarComoHTML(Sender: TObject);
var i         : Integer;
    Info      : TDSInfo;
    Progress  : TDLG_Progress;
begin
  Progress := CreateProgress(-1, -1, FTV.SelectionCount, 'Gerando Planilhas ...');
  try
    for i := 0 to FTV.SelectionCount-1 do
      begin
      Info := TDSInfo(FTV.Selections[i].Data);
      Progress.Value := i+1;
      if Progress.Cancelar then Exit;
      Info.VisualizarComoHTML();
      end;
    finally
      Progress.Free;
    end;
end;

procedure Tch_ActionManager.DSInfo_VisualizarComoPlanilha(Sender: TObject);
var i         : Integer;
    Info      : TDSInfo;
    Progress  : TDLG_Progress;
begin
  Progress := CreateProgress(-1, -1, FTV.SelectionCount, 'Gerando Planilhas ...');
  try
    for i := 0 to FTV.SelectionCount-1 do
      begin
      Info := TDSInfo(FTV.Selections[i].Data);
      Progress.Value := i+1;
      if Progress.Cancelar then Exit;
      Info.VisualizarComoPlanilha();
      end;
    finally
      Progress.Free;
    end;
end;

procedure Tch_ActionManager.DSInfo_Gantt(Sender: TObject);
var i         : Integer;
    Info      : TDSInfo;
    Progress  : TDLG_Progress;
begin
  Progress := CreateProgress(-1, -1, FTV.SelectionCount, 'Gerando Gantts ...');
  try
    for i := 0 to FTV.SelectionCount-1 do
      begin
      Info := TDSInfo(FTV.Selections[i].Data);
      Progress.Value := i+1;
      if Progress.Cancelar then Exit;
      TGRF_Gantt.Create(Info).Show();
      end;
    finally
      Progress.Free;
    end;
end;

procedure Tch_ActionManager.FulfilFault_Const_Event(Sender: TObject);
var  i: integer;
    no: TTreeNode;
     x: real;
     s: string;
begin
  s := InputBox('Preenchimento de Falhas',
                'Valor que será utilizado para o Preenchimento',
                '0');

  x := strToFloat(s);
  for i := FTV.SelectionCount-1 downto 0 do
    begin
    no := FTV.Selections[i];
    TStation(no.Data).FulfilFault_Const(x);
    end;
end;

procedure Tch_ActionManager.FulfilFault_RecursiveMean_Event(Sender: TObject);
var  i: integer;
    no: TTreeNode;
begin
  for i := FTV.SelectionCount-1 downto 0 do
    begin
    no := FTV.Selections[i];
    TStation(no.Data).FulfilFault_RecursiveMean();
    end;
end;

procedure Tch_ActionManager.AnalyzeFaults_Event(Sender: TObject);
var i, k: integer;
    no: TTreeNode;
    Posto: TStation;
    p: TSpreadSheetBook;
begin
  p := TSpreadSheetBook.Create(' Análise de Falhas e Estatísticas Gerais', '');
  p.BeginUpdate();
  for i := 0 to FTV.SelectionCount-1 do
    begin
    no := FTV.Selections[i];
    Posto := TStation(no.Data);
    if i > 0 then p.NewSheet(Posto.Nome) else p.ActiveSheet.Caption := Posto.Nome;
    k := 1;
    Posto.AnalyzeFaults(p.ActiveSheet, k);
    Posto.CalculateEstatistics(p.ActiveSheet, k);
    end;
  p.EndUpdate();
  p.Show(fsMDIChild);
  Applic.ArrangeChildrens();
end;

procedure Tch_ActionManager.RemoveStation(Sender: TObject);
var  i: integer;
    no: TTreeNode;
begin
  for i := FTV.SelectionCount-1 downto 0 do
    begin
    no := FTV.Selections[i];
    TStation(no.Data).Delete();
    end;
end;

(*
procedure Tch_ActionManager.SerieVetor_Col_CoefCorrel(Sender: TObject);
var i, ii, j, k: Integer;
    p: TSpreadSheetBook;
    V1, V2: TwsVec;
    bi, bf: Integer; // inicio e final de um bloco
    cr: real;
    Linha: Integer;
    TemFalha: Boolean;
    Serie: TSerie_Anual;
begin
  { Para todos os blocos contínuos de X --> b
      Para os outros vetores --> V
        Verificar a correspondencia do bloco b
        Realizar a correlação Parcial do dos dados do bloco b entre X e V
  }

  // Obtém o vetor base para os cálculos
  // O último é o primeiro selecionado
  Serie := TSerie_Anual(FTV.Selections[FTV.SelectionCount-1].Data);
  V1 := Serie.Dados;

  p := TSpreadSheetBook.Create('', 'Correlações');
  p.Caption := 'Correlações entre ' + Serie.Nome + ' (' + Serie.Posto.Nome + ') e ...';

  // Escreve o cabeçalho
  k := 4;
  p.ActiveSheet.BoldCell(1, 2); p.ActiveSheet.Write(1, 2, 'Ano Inicial');
  p.ActiveSheet.BoldCell(1, 3); p.ActiveSheet.Write(1, 3, 'Ano Final');
  for j := FTV.SelectionCount-2 downTo 0 do
    begin
    Serie := TSerie_Anual(FTV.Selections[j].Data);
    p.ActiveSheet.BoldCell(1, k); p.ActiveSheet.Write(1, k, Serie.Nome);
    p.ActiveSheet.BoldCell(2, k); p.ActiveSheet.Write(2, k, Serie.Posto.Nome);
    inc(k);
    end;

  // para os blocos de V1
  Linha := 3;
  bi := 0; bf := 0;
  for i := 1 to V1.Len do
    begin
    // acho o inicio do bloco i
    if (bi = 0) and not IsMissValue(V1[i]) then
       bi := i;

    // acho o fim do bloco i
    if (bi > 0) then
       if IsMissValue(V1[i]) then
          bf := i-1
       else
          if i = V1.Len then
             bf := i;

    if bf > 0 then // bloco encontrado
       begin
       p.ActiveSheet.BoldCell(Linha, 1);
       p.ActiveSheet.Write(Linha, 1, 'b' + IntToStr(Linha-2)); // --> b1 .. b2 ...
       p.ActiveSheet.Write(Linha, 2, Serie.AnoInicial + bi - 1);
       p.ActiveSheet.Write(Linha, 3, Serie.AnoInicial + bf - 1);

       // Para os outros vetores
       k := 4;
       for j := FTV.SelectionCount-2 downTo 0 do
         begin
         Serie := TSerie_Anual(FTV.Selections[j].Data);
         V2 := Serie.Dados;

         // Verifica a correspondência do bloco
         TemFalha := False;
         for ii := bi to bf do
           if IsMissValue(V2[ii]) then
              begin
              TemFalha := True;
              Break;
              end;

         if not TemFalha then
            begin
            cr := PartialCorrelation(V1, V2, bi, bf);
            p.ActiveSheet.Write(Linha, k, cr);
            end;

         inc(k);
         end; // for j

       bi := 0;
       bf := 0;
       inc(Linha);
       end; // if bf > 0 ...

    end; // for i

  p.Show(fsMDIChild);
  fsMDIChild
  Applic.ArrangeChildrens();
end;
*)

procedure Tch_ActionManager.SerieVetor_Col_Graficar(Sender: TObject);
var g     : TfoChart;
    no    : TTreeNode;
    i     : Integer;
    Serie : TSerie;
begin
  g := TfoChart.Create('Séries');

  for i := 0 to FTV.SelectionCount-1 do
    begin
    no := FTV.Selections[i];
    Serie := TSerie(no.Data);
    Serie.Plotar(g, i);
    end;

  if g.Series.Count = 1 then
     begin
     g.Series[0].ShowInLegend := False;
     g.Caption := Serie.NomeCompleto;
     end;

  Applic.SetupChart(g.Chart);
  g.Show(fsMDIChild);

  Applic.ArrangeChildrens();
end;

procedure Tch_ActionManager.SerieVetor_Col_CurvaPerm(Sender: TObject);
var g : TfoChart;
    i : Integer;
    j : Integer;
    s : TPointSeries;
    u : TSerie;
    v : TwsVec;
    x : double;
begin
  g := TfoChart.Create(' Curvas de Permanencia');

  for i := FTV.SelectionCount-1 downto 0 do
    begin
    u := TSerie(FTV.Selections[i].Data);
    v := u.Dados.Sort(true, false);
    s := g.Series.AddPointSerie(u.NomeCompleto, SelectColor(i));
    for j := 1 to v.Len do
      if not v.IsMissValue(j, x) then
         s.AddXY(j/v.Len*100, x);
    v.Free();
    end;

  g.Show(Forms.fsMDIChild);
  Applic.ArrangeChildrens();
end;

procedure Tch_ActionManager.SerieVetor_Col_MediaDasSeriesMensais(Sender: TObject);
var i: integer;
    sm: TSerie_Mensal_Medias;
    s: array of TSerie_Mensal;
begin
  // Verifica o tamanho das series selecionadas na arvore
  VerifySeriesLength();

  // Verifica se as series iniciam e terminam na mesma data
  VerifyBeginEndOfMonthSeries();

  // Dimensiona e preenche o vetor das series mensais
  System.SetLength(s, FTV.SelectionCount);
  for i := FTV.SelectionCount-1 downto 0 do
    s[i] := TSerie_Mensal(FTV.Selections[i].Data);

  // Cria a serie
  sm := TSerie_Mensal_Medias.Create(s);
  Applic.AdicionarSerie(sm);
end;

procedure Tch_ActionManager.SerieVetor_Col_DuplaMassa(Sender: TObject);
var g       : TfoChart;
    i,j, k  : Integer;
    s       : string;
    p       : TPointSeries;
    SerieY  : TSerie;
    SeriesX : array of TSerie;
    Y, X    : TwsVec;
    v       : double;
begin
  // As series precisam ter as mesmas dimensoes
  VerifySeriesLength();

  // A primerira serie selecionada sera o eixo Y
  SerieY := TSerie(FTV.Selections[FTV.SelectionCount-1].Data);
  Y := SerieY.Dados.Accum(true);

  // Cria o grafico
  g := TfoChart.Create(' Dupla-Massa de ' + SerieY.NomeCompleto);

  // As outras serao o X ...

  // Dimensiona os dados
  X := TwsDFVec.Create(Y.Len);
  SetLength(SeriesX, FTV.SelectionCount-1);

  // Pega as series
  s := '';
  for i := FTV.SelectionCount-2 downto 0 do
    begin
    SeriesX[i] := TSerie(FTV.Selections[i].Data);
    s := s + SeriesX[i].NomeCompleto + ' ';
    end;

  // Estabelece como nome do eixo X os nomes das series X
  g.Chart.BottomAxis.Title.Caption := s;

  // Calcula a média das series X e joga eno vetor X
  for i := 1 to Y.Len do
    begin
    k := 0;
    X[i] := 0;

    for j := 0 to High(SeriesX) do
      if not SeriesX[j].Dados.IsMissValue(i, v) then
         begin
         inc(k);
         X[i] := X[i] + v;
         end;

    if k > 0 then
       X[i] := X[i] / k;
    end;

  // Acumula o vetor X
  X.Accum(false);

  // Mostra o grafico
  g.Series.AddPointSerie(SerieY.NomeCompleto, clRED, X, Y);
  g.Show(Forms.fsMDIChild);
  Applic.ArrangeChildrens();

  // Libera os vetores criados
  Y.Free();
  X.Free();
end;

procedure Tch_ActionManager.SerieVetor_Col_MostrarEmPlanilha(Sender: TObject);
var p     : TSpreadSheetBook;
    i, k  : Integer;
    Serie : TSerie_Anual;
begin
  StartWait();
  p := TSpreadSheetBook.Create('Series', '');
  p.BeginUpdate();

  // Mostra o cabelhado da primeira serie selecionada
  Serie := TSerie_Anual(FTV.Selections[FTV.SelectionCount-1].Data);
  Serie.MostrarCabecalhoEmPlanilha(p, 1);

  // Mostra os dados das series
  for i := FTV.SelectionCount-1 downto 0 do
    begin
    Serie := TSerie_Anual(FTV.Selections[i].Data);
    Serie.MostrarDadosEmPlanilha(p, i+2);
    end;

  p.EndUpdate();
  p.Show(fsMDIChild);
  Applic.ArrangeChildrens();
  StopWait();
end;

procedure Tch_ActionManager.SerieVetor_Ind_CriarMaximosDiariosAnuais(Sender: TObject);
begin
  CalcularSerie('Maximos Diarios Anuais');
end;

procedure Tch_ActionManager.SerieVetor_Ind_CriarMinimosDiariosAnuais(Sender: TObject);
begin
  CalcularSerie('Minimos Diarios Anuais');
end;

procedure Tch_ActionManager.SerieVetor_Ind_ConvVals(Sender: TObject);
var S, NS : TSerie;
    i : integer;
    x : double;
    f : string;
begin
  f := toString(1.0);
  if Dialogs.InputQuery(' Conversão de Valores', 'Fator de conversão:', f) then
     begin
     x := toFloat(f, 0.0);
     if x <> 0.0 then
        for i := 0 to FTV.SelectionCount-1 do
          begin
          S := TSerie(FTV.Selections[i].Data);
          NS := S.Clone();
          NS.Nome := NS.Nome + ' (F.Conv.: ' + f + ')';
          S.AdicionarSerie(NS);
          FTV.Items.AddChildObject(S.No, '', NS);
          NS.ConverterDados(x);
          end
     else
        Dialogs.MessageDLG('Fator de conversão inválido', mtError, [mbOk], 0);
     end;
end;

procedure Tch_ActionManager.SerieVetor_Ind_LogNep(Sender: TObject);
var S, NS : TSerie;
    i : integer;
    x : double;
    f : string;
begin
  for i := 0 to FTV.SelectionCount-1 do
    begin
    S := TSerie(FTV.Selections[i].Data);
    NS := S.Clone();
    NS.Nome := NS.Nome + ' (Log.Nep.)';
    S.AdicionarSerie(NS);
    FTV.Items.AddChildObject(S.No, '', NS);
    NS.Ln();
    end
end;

procedure Tch_ActionManager.SerieVetor_Ind_AdimMedia(Sender: TObject);
var S, NS : TSerie;
    i : integer;
begin
  for i := 0 to FTV.SelectionCount-1 do
    begin
    S := TSerie(FTV.Selections[i].Data);
    NS := S.Clone();
    S.AdicionarSerie(NS);
    FTV.Items.AddChildObject(S.No, '', NS);
    NS.Admensionalizar();
    end;
end;

procedure Tch_ActionManager.SerieVetorMensal_Ind_MediasMesais(Sender: TObject);
var S  : TSerie_Mensal;
    MM : TSerie_Mensal_MediaMensais;
    i  : integer;
begin
  for i := 0 to FTV.SelectionCount-1 do
    begin
    S := TSerie_Mensal(FTV.Selections[i].Data);
    MM := TSerie_Mensal_MediaMensais.Create(S);
    S.AdicionarSerie(MM);
    FTV.Items.AddChildObject(S.No, '', MM);
    end;
end;

procedure Tch_ActionManager.SerieVetorMensal_Ind_MediasAnuais(Sender: TObject);
var S  : TSerie_Mensal;
    MA : TSerie_Mensal_MediaAnuais;
    i  : integer;
begin
  for i := 0 to FTV.SelectionCount-1 do
    begin
    S := TSerie_Mensal(FTV.Selections[i].Data);
    MA := TSerie_Mensal_MediaAnuais.Create(S);
    S.AdicionarSerie(MA);
    FTV.Items.AddChildObject(S.No, '', MA);
    end;
end;

procedure Tch_ActionManager.SerieVetor_Col_Histograma(Sender: TObject);
var Serie: TSerie_Mensal_MediaMensais;
    i: integer;
    g: TfoChart;
begin
  g := TfoChart.Create('Histograma');
  g.Chart.View3D := false;
  for i := 0 to FTV.SelectionCount-1 do
    begin
    Serie := TSerie_Mensal_MediaMensais(FTV.Selections[i].Data);
    Serie.PlotarHistograma(g);
    end;

  Applic.SetupChart(g.Chart);
  g.Show(fsMDIChild);

  Applic.ArrangeChildrens();
end;

procedure Tch_ActionManager.SerieVetor_Ind_Graficos(Sender: TObject);
var Serie : TSerie;
    ds    : TwsDataset;
    Tipo  : string;
    g     : TfoChart;
    no    : TTreeNode;
    i     : Integer;
    Vars  : TStrings;
begin
  Tipo := TMenuItem(sender).caption;
  for i := 0 to FTV.SelectionCount-1 do
    begin
    no := FTV.Selections[i];
    Serie := TSerie(no.Data);

    if Tipo = 'Linhas' then
       begin
       g := TfoChart.Create('Séries');
       Serie.Plotar(g, i);
       g.Series[0].ShowInLegend := False;
       g.Caption := Serie.NomeCompleto;
       Applic.SetupChart(g.Chart);
       g.Show(fsMDIChild);
       end
    else
    if Tipo = 'Histograma' then
       begin
       g := TfoChart.Create('Séries');
       g.Chart.View3D := false;
       TSerie_Mensal_MediaMensais(Serie).PlotarHistograma(g);
       g.Caption := Serie.NomeCompleto;
       Applic.SetupChart(g.Chart);
       g.Show(fsMDIChild);
       end
    else
    if Tipo = 'Diferença da Média Acumulada' then
       begin
       g := TfoChart.Create('Séries');
       Serie.PlotarDMA(g, i);
       g.Series[0].ShowInLegend := False;
       g.Caption := Tipo + ': ' + Serie.NomeCompleto;
       Applic.SetupChart(g.Chart);
       g.Show(fsMDIChild);
       end
    else
       begin
       ds := Serie.ConverterParaDataset();

       if Tipo = 'Dispersão Univariada' then
          begin
          Vars := TStringList.CreateFrom(['Dados']);
          g := ws_ScatterPlot(ds, Vars);
          g.Caption := Format('Diagrama de Dispersão Univariado (%s): ', [Serie.NomeCompleto]);
          Vars.Free();
          end
       else
       if Tipo = 'Índice' then
          begin
          g := ws_ScatterPlotIndex(ds, 'Dados');
          g.Caption := Format('Valores Contra Índices (%s): ', [Serie.NomeCompleto]);
          end
       else
       if Tipo = 'Quantis' then
          begin
          g := GraphQuantil(ds, 'Dados');
          g.Caption := Format('Quantis (%s): ', [Serie.NomeCompleto]);
          g.Chart.Legend.Visible := false;
          end
       else
       if Tipo = 'Simetria' then
          begin
          g := SymmetryPlot(ds, 'Dados');
          g.Caption := Format('Verificação de Simetria (%s): ', [Serie.NomeCompleto]);
          end;

       Applic.SetupChart(g.Chart);
       g.Show(fsMDIChild);
       ds.Free();
       end;
    end;
  Applic.ArrangeChildrens();
end;

function Tch_ActionManager.CriarDistrib(const Tipo: string): TSkin;
begin
(*
  if Tipo = 'Exponencial'                   then result := TwsDist_Exponential .Create(Tipo) else
  if Tipo = 'Exponencial (Dois Parâmetros)' then result := TwsDist_Exponential2.Create(Tipo) else
  if Tipo = 'Gama'                          then result := TwsDist_Gamma       .Create(Tipo) else
  if Tipo = 'Gama (Dois Parâmetros)'        then result := TwsDist_Gamma2      .Create(Tipo) else
  if Tipo = 'Gama (Três Parâmetros)'        then result := TwsDist_Gamma3      .Create(Tipo) else
  if Tipo = 'Gumbel Padronizada'            then result := TwsDist_StdGumbel   .Create(Tipo) else
  if Tipo = 'Normal Padrão'                 then result := TwsDist_StdNormal   .Create(Tipo) else
  if Tipo = 'Semi-Normal'                   then result := TwsDist_HalfNormal  .Create(Tipo) else
  if Tipo = 'Qui quadrado'                  then result := TwsDist_ChiSqr      .Create(Tipo) else
  if Tipo = 'Uniforme'                      then result := TwsDist_Uniforme    .Create(Tipo) else
  if Tipo = 'Weibull Padronizada'           then result := TwsDist_StdWeibull  .Create(Tipo) else
  if Tipo = 'Weibull (Dois Parâmetros)'     then result := TwsDist_Weibull     .Create(Tipo) else
  if Tipo = 'Weibull (Três Parâmetros)'     then result := TwsDist_Weibull3    .Create(Tipo) else
*)
  if Tipo = 'Normal'                        then result := TSkinDist_Normal      .Create(Tipo) else
  if Tipo = 'LogNormal (Dois Parâmetros)'   then result := TSkinDist_LogNormal2  .Create(Tipo) else
  if Tipo = 'LogNormal (Três Parâmetros)'   then result := TSkinDist_LogNormal3  .Create(Tipo) else
  if Tipo = 'Log-Pearson Tipo III'          then result := TSkinDist_LogPearson3 .Create(Tipo) else
  if Tipo = 'Gumbel (Dois Parâmetros)'      then result := TSkinDist_Gumbel      .Create(Tipo)
  else
     result := nil;
end;

procedure Tch_ActionManager.AjustarDistrib(Tipo: string; Mes: integer);
var Serie  : TSerie;
    i      : Integer;
    skin   : TSkinDist_Base;
    files  : TStrings;
    titles : TStrings;
    Report : TwsBXML_Output;

    function ObterDados(Serie: TSerie): TwsDFVec;
    begin
      if Mes in [1..12] then
         result := TSerie_Mensal(Serie).getMonthVector(Mes)
      else
         result := Serie.Dados;
    end;

begin
  skin := TSkinDist_Base(CriarDistrib(Tipo));

  if skin = nil then
     raise Exception.Create('Método de Ajuste de Distribuição desconhecido: ' + Tipo);

  files := TStringList.Create();
  titles := TStringList.Create();
  Report := TwsBXML_Output.Create();
  skin.Report := Report;
  try
    if skin.ShowDialog() = mrOk then
       begin
       // Cria o grafico que ira conter todas as distribuicoes
       skin.Chart := TfoChart.Create(' Distribuições');
       skin.Chart.Chart.View3D := false;

       for i := 0 to FTV.SelectionCount-1 do
         begin
         Report.Clear();
         Serie := TSerie(FTV.Selections[i].Data);
         skin.Serie := Serie;
         skin.Vector := ObterDados(Serie);
         skin.Execute();
         if skin.Ok then
            begin
            files.Add(Report.SaveToTempFile());
            titles.Add('Ajustamento de Distribuição (' + Serie.NomeCompleto + ')');
            end;
         if Mes in [1..12] then
            skin.Vector.Free();
         end; // for i

       // Mostra o grafico das distribuicoes se houverem pelo menos tres series
       if skin.Chart.Series.Count > 2 then
          begin
          Applic.SetupChart(skin.Chart.Chart);
          skin.Chart.Show(fsMDIChild);
          Applic.ArrangeChildrens();
          end
       else
          skin.Chart.Free();

       end;
    Applic.ShowReports(files, titles); // os pars. sao destruidos automaticamente
  finally
    skin.Free();
    Report.Free();
  end;
end;

procedure Tch_ActionManager.SerieVetorMensal_Ind_AjustDistrib(Sender: TObject);
var Tipo: string;
    Mes: integer;
begin
  Tipo := TMenuItem(sender).caption;
  if TMonthDialog.getMonth({out} Mes) then
     AjustarDistrib(Tipo, Mes);
end;

procedure Tch_ActionManager.SerieVetor_Ind_AjustDistrib(Sender: TObject);
var Tipo: string;
begin
  Tipo := TMenuItem(sender).caption;
  AjustarDistrib(Tipo, 0 {para toda a serie});
end;

procedure Tch_ActionManager.SerieVetor_Ind_MinimasAnuais(Sender: TObject);
begin
  CalcularSerie('Minimos Anuais');
end;

procedure Tch_ActionManager.SerieVetor_Ind_MediasAnuais(Sender: TObject);
begin
  CalcularSerie('Medias Anuais');
end;

procedure Tch_ActionManager.SerieVetor_Ind_MostrarEmPlanilha(Sender: TObject);
var p     : TSpreadSheetBook;
    i     : Integer;
    Serie : TSerie;
begin
  StartWait();
  for i := FTV.SelectionCount-1 downto 0 do
    begin
    Serie := TSerie(FTV.Selections[i].Data);
    p := TSpreadSheetBook.Create(Serie.NomeCompleto, '');
    Serie.MostrarCabecalhoEmPlanilha(p, 1);
    Serie.MostrarDadosEmPlanilha(p, 2);
    p.Show(fsMDIChild);
    end;
  StopWait();
  Applic.ArrangeChildrens();
end;

procedure Tch_ActionManager.SerieVetor_Ind_MostrarEmPlanilha_Mes_a_Mes(Sender: TObject);
var p     : TSpreadSheetBook;
    i     : Integer;
    Serie : TSerie_Mensal;
begin
  StartWait();
  for i := FTV.SelectionCount-1 downto 0 do
    begin
    Serie := TSerie_Mensal(FTV.Selections[i].Data);
    p := TSpreadSheetBook.Create(Serie.NomeCompleto, '');
    Serie.MostrarDadosEmPlanilha_Mes_a_Mes(p);
    p.Show(fsMDIChild);
    end;
  StopWait();
  Applic.ArrangeChildrens();
end;

procedure Tch_ActionManager.SerieVetor_Ind_Parcial_Maximas_MediaMensal(Sender: TObject);
begin
  CalcularSerie('Max.Med.Mens.Parc');
end;

procedure Tch_ActionManager.SerieVetor_Ind_Parcial_Maximas_TotalMensal(Sender: TObject);
begin
  CalcularSerie('Max.Tot.Mens.Parc');
end;

procedure Tch_ActionManager.SerieVetor_Ind_Parcial_Maximos_Diario(Sender: TObject);
begin
  CalcularSerie('Max.Dia.Parc');
end;

procedure Tch_ActionManager.SerieVetor_Ind_Parcial_Minimas_MediaMensal(Sender: TObject);
begin
  CalcularSerie('Min.Med.Mens.Parc');
end;

procedure Tch_ActionManager.SerieVetor_Ind_Parcial_Minimas_TotalMensal(Sender: TObject);
begin
  CalcularSerie('Min.Tot.Mens.Parc');
end;

procedure Tch_ActionManager.SerieVetor_Ind_Parcial_Minimos_Diario(Sender: TObject);
begin
  CalcularSerie('Min.Dia.Parc');
end;

procedure Tch_ActionManager.SerieVetor_Ind_Parcial_MostrarEmPlanilha(Sender: TObject);
var p     : TSpreadSheetBook;
    i     : Integer;
    Serie : TSerie_Anual;
begin
  StartWait();
  for i := FTV.SelectionCount-1 downto 0 do
    begin
    Serie := TSerie_Anual(FTV.Selections[i].Data);
    p := TSpreadSheetBook.Create(Serie.NomeCompleto, '');
    Serie.MostrarCabecalhoEmPlanilha(p, 1);
    Serie.MostrarDadosEmPlanilha(p, 2);
    p.Show(fsMDIChild);
    end;
  StopWait();
  Applic.ArrangeChildrens();
end;
                       
procedure Tch_ActionManager.SerieVetor_Ind_TotaisAnuais(Sender: TObject);
begin
  CalcularSerie('Totais Anuais');
end;

procedure Tch_ActionManager.SerieVetor_Ind_MediasMensais(Sender: TObject);
begin
  CalcularSerie('Medias Mensais');
end;

procedure Tch_ActionManager.SerieVetor_Ind_TotaisMensais(Sender: TObject);
begin
  CalcularSerie('Totais Mensais');
end;

procedure Tch_ActionManager.SerieVetor_Ind_TotaisMensaisAnuais(Sender: TObject);
begin
  CalcularSerie('Totais Mensais Anuais');
end;

procedure Tch_ActionManager.SerieVetor_Ind_PostoAdmensionalizado(Sender: TObject);
begin
  CalcularSerie('Posto Admensionalizado');
end;

procedure Tch_ActionManager.SerieVetor_Ind_ValoresDoPosto(Sender: TObject);
begin
  CalcularSerie('Valores do Posto');
end;

procedure Tch_ActionManager.ShowStation_Col_Event(Sender: TObject);
var  i: integer;
    no: TTreeNode;
     p: TSpreadSheetBook;
begin
  WinUtils.StartWait();
  try
    p := TSpreadSheetBook.Create('Postos', '');
    p.BeginUpdate();
    for i := FTV.SelectionCount-1 downto 0 do
      begin
      no := FTV.Selections[i];
      TStation(no.Data).ShowInSheet(p.ActiveSheet, i+1, false);
      end;
    p.EndUpdate();
    p.Show(fsMDIChild);
    Applic.ArrangeChildrens();
  finally
    WinUtils.StopWait();
  end;
end;

procedure Tch_ActionManager.ShowStation_Event(Sender: TObject);
var  i: integer;
    no: TTreeNode;
     p: TSpreadSheetBook;
begin
  WinUtils.StartWait();
  try
    for i := FTV.SelectionCount-1 downto 0 do
      begin
      no := FTV.Selections[i];
      p := TSpreadSheetBook.Create(TStation(no.Data).Nome, '');
      p.BeginUpdate();
      TStation(no.Data).ShowInSheet(p.ActiveSheet, 1, true);
      p.EndUpdate();
      p.Show(fsMDIChild);
      Applic.ProcessMessages();
      end;
  finally
    WinUtils.StopWait();
    Applic.ArrangeChildrens();
  end;
end;

procedure Tch_ActionManager.PlotStation_Event(Sender: TObject);
var  i: integer;
    no: TTreeNode;
     g: TfoChart;
begin
  WinUtils.StartWait();
  try
    for i := FTV.SelectionCount-1 downto 0 do
      begin
      no := FTV.Selections[i];
      g := TfoChart.Create(TStation(no.Data).Nome);
      g.Chart.Legend.Visible := false;
      TStation(no.Data).Plot(g, clRED);
      Applic.SetupChart(g.Chart);
      g.Show(fsMDIChild);
      Applic.ProcessMessages();
      end;
  finally
    WinUtils.StopWait();
    Applic.ArrangeChildrens();
  end;
end;

procedure Tch_ActionManager.VerifyStationTypes();
var i     : integer;
    t     : TTipoIntervalo;
    Posto : TStation;
begin
  t := TStation(FTV.Selections[0].Data).Info.TipoIntervalo;
  for i := FTV.SelectionCount-1 downto 1 do
    begin
    Posto := TStation(FTV.Selections[i].Data);
    if Posto.Info.TipoIntervalo <> t then
       raise Exception.Create('Os postos precisam possuir os mesmos tipos de intervalo');
    end;
end;

procedure Tch_ActionManager.VerifyStationsLength();
var i     : integer;
    t     : integer;
    Posto : TStation;
begin
  t := TStation(FTV.Selections[0].Data).Info.DS.nRows;
  for i := FTV.SelectionCount-1 downto 1 do
    begin
    Posto := TStation(FTV.Selections[i].Data);
    if Posto.Info.DS.nRows <> t then
       raise Exception.Create('Os postos precisam possuir os mesmos tamanhos');
    end;
end;

function Tch_ActionManager.StationsToDataset(): TwsDataset;
var i,j,k,t : integer;
    Posto : TStation;
begin
  // Obtem o tamanho do posto
  t := TStation(FTV.Selections[0].Data).Info.DS.nRows;

  // Cria um conjunto de dimensão [t, FTV.SelectionCount] inicializado com MissValue
  result := TwsDataset.CreateNumeric('Postos', t, FTV.SelectionCount);

  // Passa os dados dos postos para o conjunto
  k := 0;
  for i := FTV.SelectionCount-1 downto 0 do
    begin
    Posto := TStation(FTV.Selections[i].Data);
    result.Struct.Cols[k] := {char(65 + k)} Posto.Nome;
    result.Struct.Col[k+1].Name := {char(65 + k)} Posto.Nome;
    result.Struct.Col[k+1].Lab := {Posto.Nome} '';
    for j := 1 to t do
      result[j, k+1] := Posto.Info.DS[j, Posto.IndiceCol];
    inc(k);
    end;
end;

procedure Tch_ActionManager.Posto_EstatDesc(Sender: TObject);
var ds : TwsDataset;
begin
  // Converte as series selecionadas na arvore para um dataset
  ds := StationsToDataset();

  // Calcula a correlacao entre todas as colunas
  try
    DescEstats(ds, ds.CName);
  finally
    ds.Free();
  end;
end;

procedure Tch_ActionManager.Posto_Correlacoes(Sender: TObject);
var ds : TwsDataset;
     i : integer;
    Report : TwsBXML_Output;
begin
  // Precisamos de no minimo duas series selecionadas
  if FTV.SelectionCount < 2 then
     raise Exception.Create('São necessários pelo menos dois postos para o cálculo das correlações');

  // Verifica o tamanho das series selecionadas na arvore
  VerifyStationTypes();

  // Verifica se todos os postos possuem o mesmo tamanho
  VerifyStationsLength();

  // Converte as series selecionadas na arvore para um dataset
  ds := StationsToDataset();

  // Relatorio
  Report := TwsBXML_Output.Create();
  Report.BeginText();
  Report.WriteTitle(2, 'Análise de Correlações');
  Report.NewLine();
  for i := 1 to ds.nCols do
    Report.WritePropValue(ds.Struct.Col[i].Name + ':', ds.Struct.Col[i].Lab);
  Report.EndText();

  // Calcula a correlacao entre todas as colunas
  try
    CalculateCorrelation(ds, ds.CName, Report, nil);
    Applic.ShowReport(Report.SaveToTempFile(), 'Coeficientes de Correlação dos Postos');
  finally
    ds.Free();
    Report.Free();
  end;
end;

// Os postos 2, 3, ..., N serao unidos ao 1. se no 1. houverem valores perdidos
procedure Tch_ActionManager.Posto_Unir(Sender: TObject);
var Posto, Pi: TStation;
    i, k, j: integer;
begin
  StartWait();
  try
    // Posto a ser preenchido om os valores dos outros
    Posto := TStation(FTV.Selections[FTV.SelectionCount-1].Data);

    // Passa os valores para o 1. posto
    for i := FTV.SelectionCount-2 downto 0 do
      begin
      Pi := TStation(FTV.Selections[i].Data);
      for k := 1 to Posto.Count do
        if Posto.Nulo(k) then
           begin
           j := Pi.IndiceDaData( Posto.Data[k] );
           if (j <> -1) and not Pi.Nulo(j) then
              Posto.Valor[k] := Pi.Valor[j];
           end;
      end;
  finally
    StopWait();
  end;
end;

procedure Tch_ActionManager.Posto_GerarDS(Sender: TObject);
var i, j, k, ii, kk: integer;
    x: double;
    s, Erro: string;
    p: TStation;
    d, di, df: TDateTime;
    pc: IProcedaControl;
    dc: IDataControl;
begin
  // Verifica se todos os postos sao do mesmo tipo de intervalo (diarios ou mensais)
  VerifyStationTypes();

  WinUtils.StartWait();
  try
    // Obtem a maior e a menor data dos conjuntos
    di := 1000000000;
    df := 0000000001;
    for i := FTV.SelectionCount-1 downto 0 do
      begin
      p := TStation(FTV.Selections[i].Data);
      if p.Info.DataInicial < di then di := p.Info.DataInicial;
      if p.Info.DataFinal > df then df := p.Info.DataFinal;
      end;

    // Pede um intervalo para o usuario
    if not TfoDefineDates.getDates({in/out} di, {in/out} df, {out} Erro) then
       begin
       if Erro <> '' then MessageDLG(Erro, mtError, [mbOk], 0);
       Exit;
       end;

    // Applic implementa IProcedaControl
    pc := Applic;

    // Cria o Dataset
    dc := pc.NewDataSet(di, df, p.Info.TipoIntervalo, FTV.SelectionCount);
    dc.setTitle('Sem Nome');

    // Passa os dados dos postos para o DS inclusive dados extras
    for i := FTV.SelectionCount-1 downto 0 do
      begin
      p := TStation(FTV.Selections[i].Data);

      // Propriedades do Posto
      dc.setStationName(i, p.Nome);
      dc.setStationType(i, p.DataType);
      dc.setStationUnit(i, p.DataUnit);
      dc.setStationDesc(i, p.Comment.Text);
      for j := 0 to p.ExtraData.Count-1 do
        begin
        s := p.ExtraData.Names[j];
        dc.defineStationProp(i, s, p.ExtraData.Values[s]);
        end;

      // Valores do Posto
      p.FindLimitIndexs(j, k);
      for ii := j to k do
        begin
        d := p.Info.DS.AsDateTime[ii, 1];
        if (d >= di) and (d <= df) then
           begin
           x := p.Info.DS[ii, p.IndiceCol];
           dc.setStationValue(d, i, x);
           end;
        end;
      end;

    // Termina o processo
    pc.DoneImport(dc);
  finally
    WinUtils.StopWait();
  end;
end;

procedure Tch_ActionManager.PlotStation_Col_Event(Sender: TObject);
var  i: integer;
    no: TTreeNode;
     g: TfoChart;
begin
  WinUtils.StartWait();
  try
    g := TfoChart.Create(' Dados');
    for i := FTV.SelectionCount-1 downto 0 do
      begin
      no := FTV.Selections[i];
      TStation(no.Data).Plot(g, SelectColor(i));
      end;
    Applic.SetupChart(g.Chart);
    g.Show(fsMDIChild);
    Applic.ArrangeChildrens();
  finally
    WinUtils.StopWait();
  end;
end;

// Gerenciador do evento de "objetos criados" de "CalculateCorrelation()"
procedure Tch_ActionManager.Corr_CreatedObjectHandler(Sender, Obj: TObject);
begin
  if FMatCorr = nil then
     FMatCorr := TwsSymmetric(Obj)
  else
     if FMatCorrTests = nil then
        FMatCorrTests := TwsGeneral(Obj);
end;

// O calculo de correlacoes eh utilizado de duas maneiras:
//   - COE <> nil: os resultados sao gerenciados pelo usuario
procedure Tch_ActionManager.CalculateCorrelation(ds: TwsDataset; Vars: TStrings; Report: TwsBXML_Output; COE: TwsCreatedObject_Event);
Var Corr   : TwsCorr;
    Erro,i : Integer;
    Opcoes : TBits;
    slNull : TStrings;
begin
  // Opcoes de armazenamento e relatorio
  Opcoes := TBits.Create();
  Opcoes.Size := 8;

  // Queremos somente a impressao em Rel. dos resultados
  Opcoes[cIMCorr] := (Report <> nil);
    //Opcoes[cIMStat] := (Report <> nil);

  // Queremos somente os resultados sem relatorio
  Opcoes[cAMCorr] := (@COE <> nil);

  // Campos privados que poderao ser utilizados pelo chamador
  // dependendo dos parametros passados.
  // Olhar o método "Corr_CreatedObjectHandler" acima para maiores detalhes
  FMatCorr := nil;
  FMatCorrTests := nil;

  slNull := TStringList.Create();
  try
    try
    // Se (Report = nil) e (COE <> nil) dois resultados serao gerados:
    //    - 1. Mat. de Correlacoes
    //    - 2. Mat. dos Testes
    Corr := TwsCorr.Create(ds,       // Conjunto de dados
                           slNull,   // Grupo
                           '',       // Condicao
                           '',       // Peso
                           Vars,     // Variaveis a analisar
                           slNull,   // Variaveis a Fixar
                           Erro,     // Retorno de erro
                           Opcoes,   // Opcoes
                           false,    // Não mostra o link de ajuda no relatorio
                           Report,   // Relatorio
                           COE);     // Gerenciador do evento de criacao de objetos
    except
      on E: Exception do
         begin
         Report.BeginText();
         Report.WriteTitle(3, '');
         Report.Warning('Desculpe, não foi possível calcular a correlação');
         Report.EndText();
         end;
    end
  finally
    Corr.Free();
    Opcoes.Free();
    slNull.Free();
  end;
end;

procedure Tch_ActionManager.DescEstats(ds: TwsDataset; Vars: TStrings);
var d: TfoSeries_DescEstats;
begin
  d := TfoSeries_DescEstats.Create(ds, Vars);
  d.ShowModal();
  d.Free();
end;

procedure Tch_ActionManager.SerieVetor_Col_EstDesc(Sender: TObject);
var ds : TwsDataset;
begin
  // Converte as series selecionadas na arvore para um dataset
  ds := SeriesToDataset();

  // Calcula a correlacao entre todas as colunas
  try
    DescEstats(ds, ds.CName);
  finally
    ds.Free();
  end;
end;

procedure Tch_ActionManager.SerieVetor_Col_CCC(Sender: TObject);
var ds : TwsDataset;
     i : integer;
    Report : TwsBXML_Output;
begin
  // Precisamos de no minimo duas series selecionadas
  if FTV.SelectionCount < 2 then
     raise Exception.Create('São necessários pelo menos duas séries para o cálculo das correlações');

  // Verifica o tamanho das series selecionadas na arvore
  VerifySeriesLength();

  // Converte as series selecionadas na arvore para um dataset
  ds := SeriesToDataset();

  // Relatorio
  Report := TwsBXML_Output.Create();
  Report.BeginText();
  Report.WriteTitle(2, 'Análise de Correlações');
  Report.NewLine();
  for i := 1 to ds.nCols do
    Report.WritePropValue(ds.Struct.Col[i].Name + ':', ds.Struct.Col[i].Lab);
  Report.EndText();

  // Calcula a correlacao entre todas as colunas
  try
    CalculateCorrelation(ds, ds.CName, Report, nil);
    Applic.ShowReport(Report.SaveToTempFile(), 'Coeficientes de Correlação das Séries');
  finally
    ds.Free();
    Report.Free();
  end;
end;

// Verifica se as series iniciam e terminam na mesma data
procedure Tch_ActionManager.VerifyBeginEndOfMonthSeries();
var Serie: TSerie_Mensal;
    i, j: integer;
    Mes1a, Ano1a, Mes2a, Ano2a: integer;
    Mes1b, Ano1b, Mes2b, Ano2b: integer;
begin
  Serie := TSerie_Mensal(FTV.Selections[0].Data);

  // Obtem as datas iniciais e finais da primeira serie
  Serie.BeginDate(Mes1a, Ano1a);
  Serie.EndDate(Mes2a, Ano2a);

  // Compara as datas acima com as outras series selecionadas
  for i := FTV.SelectionCount-1 downto 1 do
    begin
    Serie := TSerie_Mensal(FTV.Selections[i].Data);
    Serie.BeginDate(Mes1b, Ano1b);
    Serie.EndDate(Mes2b, Ano2b);
    if (Mes1a <> Mes1b) or (Mes2a <> Mes2b) or (Ano1a <> Ano1b) or (Ano2a <> Ano2b) then
       raise Exception.Create('Somente séries com as mesmas datas Iniciais e Finais podem ser selecionadas');
    end;
end;

function Tch_ActionManager.SeriesToDatasetOfOneMonth(aMonth: integer): TwsDataset;
var Serie: TSerie_Mensal;
    i, j, k, Ano: integer;
    v: TwsDFVec;
    vetores: array of TwsDFVec;
begin
  // Obtem os vetores mensais na ordem em que eles foram selecionados na arvore
  k := 0;
  setLength(vetores, FTV.SelectionCount);
  for i := FTV.SelectionCount-1 downto 0 do
    begin
    Serie := TSerie_Mensal(FTV.Selections[i].Data);
    if i = 0 then Ano := Serie.FirstYear(aMonth);
    vetores[k] := Serie.getMonthVector(aMonth);
    inc(k);
    end;

  // Cria um conjunto de dimensão [vetores[0].Len, FTV.SelectionCount] inicializado com MissValue
  result := TwsDataset.CreateNumeric(
    'Series_' + SysUtils.LongMonthNames[aMonth], vetores[0].Len, FTV.SelectionCount);

  result.ColIdentName := 'Ano';

  // Passa os dados das series para o conjunto respeitando a mudanca de ordem
  // realizada acima.
  k := 0;
  for i := FTV.SelectionCount-1 downto 0 do
    begin
    Serie := TSerie_Mensal(FTV.Selections[i].Data);
    result.Struct.Cols[k] := char(65 + k);
    result.Struct.Col[k+1].Name := char(65 + k);
    result.Struct.Col[k+1].Lab := Serie.NomeCompleto;
    for j := 1 to vetores[k].Len do
      begin
      result[j, k+1] := vetores[k][j];
      if k = 0 then result.RowName[j] := toString(Ano + j - 1);
      end;
    vetores[k].Free();
    inc(k);
    end;

  // Libera vetores
  setLength(vetores, 0);
end;

procedure Tch_ActionManager.SerieVetor_Col_CCC_MM(Sender: TObject);
var ds : TwsDataset;
     i : integer;
     Report : TwsBXML_Output;
begin
  // Verifica o tamanho das series selecionadas na arvore
  VerifySeriesLength();

  // Verifica se as series iniciam e terminam na mesma data
  VerifyBeginEndOfMonthSeries();

  // Relatorio
  Report := TwsBXML_Output.Create();
  Report.BeginText();
  Report.WriteTitle(2, 'Análise de Correlações Mês a Mês');
  Report.EndText();

  // Para cada mes de um ano
  for i := 1 to 12 do
    begin
    // Converte as series selecionadas na arvore para um dataset
    ds := SeriesToDatasetOfOneMonth(i);
    Report.Add(ds);
    CalculateCorrelation(ds, ds.CName, Report, nil);
    ds.Free();
    end;

  Applic.ShowReport(Report.SaveToTempFile(), 'Coeficientes de Correlação Mês a Mês das Séries');
  Report.Free();
end;

procedure Tch_ActionManager.ARL_CreatedObjectHandler(Sender, Obj: TObject);
begin
  FCoefTable := TwsDataset(Obj);
end;

procedure Tch_ActionManager.FazerAnaliseDeRegressaoLinear(ds: TwsDataset; Modelo: string; Report: TwsBXML_Output; out a, b: double);
var m: TwsLMManager;
begin
  m := TwsLMManager.Create(ds, Modelo, '', '', '');
  m.Output := Report;

  // Descricao do processo
  m.Output.BeginText();
  m.Output.CenterTitle(2, 'Análise de Regressão Linear');
  m.Output.EndText();

  // Opcoes gerais
  m.Options[ ord(cmIntercept) ] := true;
  m.Options[ ord(cmUnivar)    ] := true;
  m.Options[ ord(cmPrintCoef) ] := true;
  m.Options[ ord(cmSaveCoef)  ] := true;

  m.ObjectCreation_Event := ARL_CreatedObjectHandler;

  // Avaliacao do modelo e calculo dos coeficientes
  try
    m.EvalModel();
    if m.Error = 0 then
       begin
       FCoefTable := nil;

       // Retornara FCoefTable atraves do evento "ARL_CreatedObjectHandler"
       m.ExecReg(0 {complete});

       // Obtem os coeficientes
       b := FCoefTable[1, 1]; // intercept
       a := FCoefTable[2, 1];

       FCoefTable.Free();
       end;
  finally
    m.Free();
  end;
end;

procedure Tch_ActionManager.SerieVetor_Col_ConverterParaPostos(Sender: TObject);
var Serie: TSerie_Mensal;
    dc: IDataControl;
    i, k: integer;
    mi, mf, ai, af, a, m: integer;
    di, df: TDateTime;
begin
  // Obtem o maior intervalo entre as datas
  mi := 9999; mf := 0;
  ai := 9999; af := 0;
  for i := 0 to FTV.SelectionCount-1 do
    begin
    Serie := TSerie_Mensal(FTV.Selections[i].Data);

    // Mes e ano iniciais
    Serie.BeginDate(m, a);
    if m < mi then mi := m;
    if a < ai then ai := a;

    // Mes e ano finais
    Serie.EndDate(m, a);
    if m > mf then mf := m;
    if a > af then af := a;
    end;

  // Codifica as datas
  di := EncodeDate(ai, mi, 01);
  df := EncodeDate(af, mf, 01);

  // Gera o Dataset
  dc := Applic.NewDataSet(di, df, tiMensal, FTV.SelectionCount);

  // Passa os dados das series para o dataset
  for i := 0 to FTV.SelectionCount-1 do
    begin
    Serie := TSerie_Mensal(FTV.Selections[i].Data);
    dc.setStationName(i, Serie.Nome);
    for k := 1 to Serie.Dados.Len do
      begin
      Serie.DateOfValue(k, m, a);
      dc.setStationValue(EncodeDate(a, m, 01), i, Serie.Dados[k]);
      end;
    end;

  // Conclui o processo
  Applic.DoneImport(dc);  
end;

// Preenchimento de falhas coletivas em series mensais
procedure Tch_ActionManager.SerieVetor_Col_PF_MM(Sender: TObject);
var ds        : TwsDataset;
    j, k, y   : integer;
    indSer    : integer;
    Mes, Ano  : integer;
    MI, MF    : integer;
    AI, AF    : integer;
    a, b, x   : double;
    Calc      : boolean;
    s         : string;
    Report    : TwsBXML_Output;
    SerieO    : TSerie_Mensal;
    SerieP    : TSerie_Mensal_Preenchida;
    SubSeries : array[1..12] of TSerie_Mensal_Preenchida;
    SubSerIND : array[1..12] of integer;
begin
  // Verifica o tamanho das series selecionadas na arvore
  VerifySeriesLength();

  // Verifica se as series iniciam e terminam na mesma data
  VerifyBeginEndOfMonthSeries();

  // Serie a ser preenchida
  SerieO := TSerie_Mensal(FTV.Selections[FTV.SelectionCount-1].Data);

  // Inicializacoes
  FMatCorr := nil;
  FMatCorrTests := nil;

  // Relatorio
  Report := TwsBXML_Output.Create();
  Report.BeginText();
  Report.CenterTitle(1, 'Preenchimento de Falhas');
  Report.EndText();

  // Para cada mes de um ano
  for Mes := 1 to 12 do
    begin
    Report.BeginText();
    Report.WriteTitle(1, SysUtils.LongMonthNames[Mes]);
    Report.EndText();

    // Converte as series selecionadas na arvore para um dataset
    ds := SeriesToDatasetOfOneMonth(Mes);

    // Mostra o sub-dataset mensal
    Report.Add(ds);

    // Cria a sub-serie mensal temporaria
    SerieP := TSerie_Mensal_Preenchida.Create(SerieO.Posto, ds.nRows);

    // Salva esta serie no array mensal
    SubSeries[Mes] := SerieP;

    // Somente faz o preenchimento se houverem falhas no mes corrente da 1. serie
    if ds.HasMissValue(1) then
       begin
       // Duas matrizes serao criadas atraves do evento "Corr_CreatedObjectHandler":
       //   - FMatCorr - Contem as correlacoes
       //   - FMatCorrTests - Contem os testes mas nao eh utilizada
       CalculateCorrelation(ds, ds.CName, Report, Corr_CreatedObjectHandler);

       // Verifica se a correlacao ocorreu com sucesso
       if FMatCorr = nil then
          begin
          Report.BeginText();
          Report.CenterTitle(3, 'Erro na verificação de correlação !');
          Report.EndText();
          Continue;
          end;

       // Verifica na 1. linha da matriz "FMatCorr" a partir da 2. coluna qual o
       // menor coeficiente para podermos definir qual serie sera utilizada no prenchimento.
       // "indSer" guardara o indice da coluna a ser usada no preenchimento.
       x := -1;
       for j := 2 to FMatCorr.nCols do
         if FMatCorr[1, j] > x then
            begin
            x := FMatCorr[1, j];
            indSer := j;
            end;

       // Informa qual serie sera utilizada no preenchimento
       Report.BeginText();
       Report.WritePropValue('Série utilizada no preenchimento: ',
                             ds.Struct.Col[indSer].Name + ' (CC: ' + toString(x) + ')', 40);
       Report.EndText();

       // Monta o modelo na forma string e faz a analise
       s := ds.Struct.Col[1].Name + '~' + ds.Struct.Col[indSer].Name;
       FazerAnaliseDeRegressaoLinear({in} ds, {in} s, {in} Report, {out} a, {out} b);

       // Copia os valores realizando o preenchimento
       for k := 1 to ds.nRows do
         begin
         // Obtem o ano do valor
         Ano := toInt(ds.RowName[k]);

         // Gerencia o valor
         if ds.IsMissValue(k, 1, x) then
            // Se der, realiza o preenchimento
            if not ds.IsMissValue(k, indSer, x) then
               // Calcula a falha
               begin
               x := a * x + b;
               if x < 0 then x := wscMissValue;
               SerieP.Atribuir(k, x, Mes, Ano, true);
               end
            else
               // O preenchimento nao foi possivel
               SerieP.Atribuir(k, wscMissValue, Mes, Ano, false)
         else
            // Somente copia o dado
            SerieP.Atribuir(k, x, Mes, Ano, false);
         end; // for k

       // Destroi todos os objetos temporarios
       FreeAndNil(FMatCorr);
       FreeAndNil(FMatCorrTests);
       end
    else
       begin
       // Copia diretamente os valores para SerieP, pois nao ha falhas
       for k := 1 to ds.nRows do
         begin
         Ano := toInt(ds.RowName[k]);
         SerieP.Atribuir(k, ds[k, 1], Mes, Ano, false);
         end; // for k

       Report.BeginText();
       Report.CenterTitle(3, 'Não há falhas neste mês !');
       Report.EndText();
       end;

    ds.Free();
    end; // for Mes ...

  // Concatena as 12 sub-series em uma serie só ...

  SerieP := TSerie_Mensal_Preenchida.Create(SerieO.Posto, SerieO.Dados.Len);
  SerieP.Nome := SerieO.Nome + ' (preenchida)';

  // Inicializa o vetor com os indices das sub-series
  for Mes := 1 to 12 do SubSerIND[Mes] := 1;

  // Acesso a SerieP em ordem (1..N), isto eh, de MI/AI ate MF/AF ...

  k := 1;
  SerieO.BeginDate(MI, AI);
  SerieO.EndDate(MF, AF);

  // Primeiro ano
  for Mes := MI to 12 do
    begin
    SubSeries[Mes].Obter(SubSerIND[Mes], {out} x, {out} Mes, {out} Ano, {out} Calc);
    SerieP.Atribuir(k, x, Mes, Ano, Calc);
    inc(k);
    inc(SubSerIND[Mes]);
    end;

  // Anos intermediarios
  for y := (AI + 1) to (AF - 1) do
    for Mes := 1 to 12 do
      begin
      SubSeries[Mes].Obter(SubSerIND[Mes], {out} x, {out} Mes, {out} Ano, {out} Calc);
      SerieP.Atribuir(k, x, Mes, Ano, Calc);
      inc(k);
      inc(SubSerIND[Mes]);
      end;

  // Ultimo ano
  for Mes := 1 to MF do
    begin
    SubSeries[Mes].Obter(SubSerIND[Mes], {out} x, {out} Mes, {out} Ano, {out} Calc);
    SerieP.Atribuir(k, x, Mes, Ano, Calc);
    inc(k);
    inc(SubSerIND[Mes]);
    end;

  // Faz a serie preenchida filha de SerieO
  SerieO.AdicionarSerie(SerieP);
  FTV.Items.AddChildObject(SerieO.No, '', SerieP);

  // Destroi as Sub-Series
  for Mes := 1 to 12 do SubSeries[Mes].Free();

  // Mostra o relatorio
  Applic.ShowReport(Report.SaveToTempFile(), 'Preenchimento de Falhas');
  Report.Free();
end;

procedure Tch_ActionManager.ShowDataset(ds: TwsDataset);
var p: TSpreadSheetBook;
begin
  p := TSpreadSheetBook.Create();
  ds.ShowInSheet(p);
  p.Show(fsMDIChild);
  Applic.ArrangeChildrens();
end;

procedure Tch_ActionManager.DSInfo_Fechar(Sender: TObject);
var i: Integer;
    x: TDSInfo;
begin
  for i := FTV.SelectionCount-1 downto 0 do
    begin
    x := TDSInfo(FTV.Selections[i].Data);
    x.Fechar();
    end;
  Applic.StatusBar.Panels.Clear();
end;

procedure Tch_ActionManager.SerieVetor_Ind_Fechar(Sender: TObject);
var i: Integer;
    s: TSerie;
begin
  for i := FTV.SelectionCount-1 downto 0 do
    begin
    s := TSerie(FTV.Selections[i].Data);
    s.Pai.Remover(s);
    end;

  Applic.StatusBar.Panels.Clear();
end;

procedure Tch_ActionManager.DSInfo_Correl(Sender: TObject);
var i, j      : Integer;
    Info      : TDSInfo;
    Progress  : TDLG_Progress;
    Vars      : TStrings;
    Report    : TwsBXML_Output;
begin
  Progress := CreateProgress(-1, -1, FTV.SelectionCount, 'Calculando Correlações ...');
  Vars := TStringList.Create();
  try
    for i := 0 to FTV.SelectionCount-1 do
      begin
      Info := TDSInfo(FTV.Selections[i].Data);
      Progress.Value := i+1;
      if Progress.Cancelar then Exit;
      Info.GetStationNames(Vars);

      // Relatorio
      Report := TwsBXML_Output.Create();
      Report.BeginText();
      Report.WriteTitle(2, 'Análise de Correlações de um Conjunto de Dados');
      Report.NewLine();
      for j := 1 to Info.DS.nCols do
        Report.WritePropValue(Info.DS.Struct.Col[j].Name + ':', Info.DS.Struct.Col[j].Lab);
      Report.EndText();

      try
        CalculateCorrelation(Info.DS, Vars, Report, nil);
        Applic.ShowReport(Report.SaveToTempFile(), 'Coeficientes de Correlação de um Conjunto de Dados');
      finally
        Report.Free();
        end;

      end; // for i ...
    finally
      Progress.Free();
      Vars.Free();
    end;
end;

procedure Tch_ActionManager.FrequencyAnalisys(ds: TwsDataset; Vars: TStrings);
var d: TfoSeries_FrequencyAnalisys;
begin
  d := TfoSeries_FrequencyAnalisys.Create(ds, Vars);
  d.ShowModal();
  d.Free();
end;

procedure Tch_ActionManager.SerieVetor_Col_Frequency(Sender: TObject);
var ds : TwsDataset;
begin
  // Converte as series selecionadas na arvore para um dataset
  ds := SeriesToDataset();

  // Calcula a correlacao entre todas as colunas
  try
    FrequencyAnalisys(ds, ds.CName);
  finally
    ds.Free();
  end;
end;

procedure Tch_ActionManager.Database_Disconnect(Sender: TObject);
var DB: TDatabase;
    i: integer;
begin
  for i := FTV.SelectionCount-1 downto 0 do
    begin
    DB := TDatabase(FTV.Selections[i].Data);
    if MessageDLG('Tem certeza que deseja se desconectar de ' + DB.Name + ' ?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes then
       DB.Disconnect();
    end;
end;

procedure Tch_ActionManager.Table_View(Sender: TObject);
var i: integer;
begin
  for i := FTV.SelectionCount-1 downto 0 do
    TTable(FTV.Selections[i].Data).View();
end;

procedure Tch_ActionManager.ImportarPostosDoBD();
var v: real;
    p: TADO_Hidro_Posto;
    t: TObject;
    di, df, d: TDateTime;
    pc: IProcedaControl;
    dc: IDataControl;
    db: IDBControl;
    TabelaAtual: string;
    dbAtual: string;
    sCampoValor01: string;
    DiasDoMes: integer;
    iCod, iDat, iVal, iNC, iPosto, kPosto, iCampo, iDia: integer;
begin
  // Obtencao da maior e menor data ...
  di := 1000000000;
  df := 0000000001;
  for iPosto := FTV.SelectionCount-1 downto 0 do
    begin
    p := TADO_Hidro_Posto(FTV.Selections[iPosto].Data);
    if p.DataInicial < di then di := p.DataInicial;
    if p.DataFinal > df then df := p.DataFinal;
    end;

  // Applic implementa IProcedaControl
  pc := Applic;
  pc.ShowMessage('Iniciando o processo de importação ...');

  // Cria o Dataset
  dc := pc.NewDataSet(di, df, tiDiario, FTV.SelectionCount);
  dc.setTitle('Sem Nome');

  // Passa os dados do BD para o Dataset ...

  t := nil;
  TabelaAtual := '';
  dbAtual := '';
  kPosto := 0; // utilizado para inverter o resultado da selecao
  for iPosto := FTV.SelectionCount-1 downto 0 do
    begin
    // Acessa o posto na ordem de selecao do usuario
    p := TADO_Hidro_Posto(FTV.Selections[iPosto].Data);

    pc.ShowMessage('Importando posto ' + p.Nome + '  NV: ' + toString(p.NivelDeConsistencia));
    dc.setStationName(kPosto, p.Nome + '_NC_' + toString(p.NivelDeConsistencia));
    dc.setStationDesc(kPosto, 'Posto obtido de ' + p.DB.Name + '.' + p.TabelaPai + '.' + p.Nome);

    // Obtem a interface de controle do banco de dados
    db := p.DB;

    // Estabelece os valores do posto ...

    if (p.TabelaPai <> TabelaAtual) or (db.idbc_GetDatabaseName() <> dbAtual) then
       begin
       if t <> nil then db.idbc_CloseTable(t);
       t := db.idbc_OpenTable(p.TabelaPai);
       TabelaAtual := p.TabelaPai;
       dbAtual := db.idbc_GetDatabaseName();

       if p.TabelaPai = 'Cotas'  then sCampoValor01 := 'Cota01'  else
       if p.TabelaPai = 'Vazoes' then sCampoValor01 := 'Vazao01' else
       if p.TabelaPai = 'Chuvas' then sCampoValor01 := 'Chuva01' else
       if p.TabelaPai = 'Clima'  then sCampoValor01 := 'Clima01';

       // Obtem os indices dos campos
       iCod := db.idbc_GetFieldIndex(t, 'EstacaoCodigo');
       iDat := db.idbc_GetFieldIndex(t, 'Data');
       iNC  := db.idbc_GetFieldIndex(t, 'NivelConsistencia');
       iVal := db.idbc_GetFieldIndex(t, sCampoValor01);
       end;

    // Acha o primeiro dado do Posto com o mesmo Nivel de Consistencia
    db.idbc_First(t);
    while
      not db.idbc_EOF(t) and
      (
        ( p.Codigo <> db.idbc_GetFieldAsInteger(t, iCod) ) or
        ( p.NivelDeConsistencia <> db.idbc_GetFieldAsInteger(t, iNC) )
      )
      do db.idbc_Next(t);

    // Percorre todos os registros dda tabela em busca do posto
    while not db.idbc_EOF(t) do
      begin
      if ((p.Codigo = db.idbc_GetFieldAsInteger(t, iCod)) and
          (p.NivelDeConsistencia = db.idbc_GetFieldAsInteger(t, iNC))) then
         begin
         // Obtem a data inicial do registro
         di := db.idbc_GetFieldAsDateTime(t, iDat);

         // Calcula quantos dias tem o mes corrente
         DiasDoMes := DateUtils.DaysInMonth(di);

         // Percorre os dias do registro
         for iDia := 1 to DiasDoMes do
           begin
           d := di + iDia - 1;
           iCampo := iVal + iDia - 1;
           if not db.idbc_FieldIsNull(t, iCampo) then
              begin
              v := db.idbc_GetFieldAsFloat(t, iCampo);
              dc.setStationValue(d, kPosto, v);
              end;
           end;
         end;
      // Vai para o proximo registro
      db.idbc_Next(t);
      end;

    System.inc(kPosto);
    end; // for iPosto

  // Fecha a ultima tabela aberta
  if t <> nil then db.idbc_CloseTable(t);

  // Termina o processo
  pc.DoneImport(dc);
  pc.ShowMessage('Postos importados com sucesso.');
end;

// Transforma os postos selecionados do BD do Hidro em um Dataset do Proceda
procedure Tch_ActionManager.ADO_Hidro_Posto_CP(Sender: TObject);
begin
  StartWait();
  try
    ImportarPostosDoBD();
  finally
    StopWait();
  end;
end;

procedure Tch_ActionManager.VerifyBeginOfYearSeries();
var Serie: TSerie_Anual;
    i: integer;
    AnoInicial: integer;
begin
  Serie := TSerie_Anual(FTV.Selections[0].Data);
  AnoInicial := Serie.AnoInicial;
  for i := FTV.SelectionCount-1 downto 1 do
    begin
    Serie := TSerie_Anual(FTV.Selections[i].Data);
    if (Serie.AnoInicial <> AnoInicial) then
       raise Exception.Create('Somente séries com os mesmos anos iniciais podem ser selecionadas');
    end;
end;

procedure Tch_ActionManager.SerieVetor_Col_PFA(Sender: TObject);
var ds        : TwsDataset;
    j, k, y   : integer;
    indSer    : integer;
    a, b, x   : double;
    Calc      : boolean;
    s         : string;
    Report    : TwsBXML_Output;
    SerieO    : TSerie_Anual;
    SerieP    : TSerie_Anual_Preenchida;
begin
  // Verifica o tamanho das series selecionadas na arvore
  VerifySeriesLength();

  // Verifica se as series iniciam e terminam na mesma data
  VerifyBeginOfYearSeries();

  // Serie a ser preenchida
  SerieO := TSerie_Anual(FTV.Selections[FTV.SelectionCount-1].Data);

  // Inicializacoes
  FMatCorr := nil;
  FMatCorrTests := nil;

  // Relatorio
  Report := TwsBXML_Output.Create();
  Report.BeginText();
  Report.CenterTitle(1, 'Preenchimento de Falhas em Séries Anuais');
  Report.EndText();

  // Converte a serie para um dadaset para ser operada
  ds := SeriesToDataset();

  // Faz o preenchimento se houverem falhas
  if ds.HasMissValue(1) then
     begin
     // Mostra o dataset
     Report.Add(ds);

     // Duas matrizes serao criadas atraves do evento "Corr_CreatedObjectHandler":
     //   - FMatCorr - Contem as correlacoes
     //   - FMatCorrTests - Contem os testes mas nao eh utilizada
     CalculateCorrelation(ds, ds.CName, Report, Corr_CreatedObjectHandler);

     // Verifica se a correlacao ocorreu com sucesso
     if FMatCorr = nil then
        begin
        Report.BeginText();
        Report.CenterTitle(3, 'Erro na verificação de correlação !');
        Report.EndText();
        end
     else
        begin
        // Verifica na 1. linha da matriz "FMatCorr" a partir da 2. coluna qual o
        // menor coeficiente para podermos definir qual serie sera utilizada no prenchimento.
        // "indSer" guardara o indice da coluna a ser usada no preenchimento.
        x := -1;
        for j := 2 to FMatCorr.nCols do
          if FMatCorr[1, j] > x then
             begin
             x := FMatCorr[1, j];
             indSer := j;
             end;

        // Informa qual serie sera utilizada no preenchimento
        Report.BeginText();
        Report.WritePropValue('Série utilizada no preenchimento: ',
                              ds.Struct.Col[indSer].Name + ' (CC: ' + toString(x) + ')', 40);
        Report.EndText();

        // Monta o modelo na forma string e faz a analise
        s := ds.Struct.Col[1].Name + '~' + ds.Struct.Col[indSer].Name;
        FazerAnaliseDeRegressaoLinear({in} ds, {in} s, {in} Report, {out} a, {out} b);

        // Cria a serie a ser preenchida
        SerieP := TSerie_Anual_Preenchida.Create(SerieO);

        // Faz a serie preenchida filha de SerieO
        SerieO.AdicionarSerie(SerieP);
        FTV.Items.AddChildObject(SerieO.No, '', SerieP);

        // Tenta preencher as falhas
        for k := 1 to ds.nRows do
          if ds.IsMissValue(k, 1, x) then
             // Se der, realiza o preenchimento
             if not ds.IsMissValue(k, indSer, x) then
                // Calcula a falha
                begin
                x := a * x + b;
                if x < 0 then x := wscMissValue;
                SerieP.Atribuir(k, x, true);
                end;

        // Destroi todos os objetos temporarios
        FreeAndNil(FMatCorr);
        FreeAndNil(FMatCorrTests);
        end;
     end
  else
     begin
     Report.BeginText();
     Report.CenterTitle(3, 'Não há falhas a serem preenchidas');
     Report.EndText();
     end;

  // Destroi o dataset temporario
  ds.Free();

  // Mostra o relatorio
  Applic.ShowReport(Report.SaveToTempFile(), 'Preenchimento de Falhas');
  Report.Free();
end;

procedure Tch_ActionManager.ShowStationMM_Ind_Event(Sender: TObject);
var  i: integer;
     k: integer;
    no: TTreeNode;
     p: TSpreadSheetBook;
begin
  k := 0;
  WinUtils.StartWait();
  try
    for i := FTV.SelectionCount-1 downto 0 do
      begin
      no := FTV.Selections[i];
      if TStation(no.Data).Info.TipoIntervalo = tiMensal then
         begin
         p := TSpreadSheetBook.Create('Posto ' + TStation(no.Data).Nome, '');
         p.BeginUpdate();
         TStation(no.Data).ShowInSheet_MM(p.ActiveSheet);
         p.EndUpdate();
         p.Show(fsMDIChild);
         inc(k);
         end;
      end;

    if k > 0 then
       Applic.ArrangeChildrens()
    else
       MessageDLG('Os postos devem ser Mensais.', mtinformation, [mbOk], 0);
  finally
    WinUtils.StopWait();
  end;
end;

procedure Tch_ActionManager.Scripts_Adicionar(Sender: TObject);
begin
  //if DialogUtils.SelectFile(s, Applic.LastDir, 'Scripts|*.pscript|Todos|*.*') then
     Applic.Scripts.Add('F:\Projetos\Arquivos de Trabalho\Proceda\script.pscript');
end;

procedure Tch_ActionManager.Script_Editar(Sender: TObject);
begin
  TScript(FTV.Selections[0].Data).Edit();
end;

procedure Tch_ActionManager.Script_Executar(Sender: TObject);
var i: Integer;
begin
  for i := FTV.SelectionCount-1 downto 0 do
    TScript(FTV.Selections[i].Data).Execute();
end;

procedure Tch_ActionManager.Script_Remover(Sender: TObject);
var i: Integer;
begin
  for i := FTV.SelectionCount-1 downto 0 do
    TScript(FTV.Selections[i].Data).Delete();
end;

end.
