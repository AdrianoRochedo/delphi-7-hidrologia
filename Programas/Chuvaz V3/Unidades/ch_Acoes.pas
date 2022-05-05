unit ch_Acoes;

interface
uses comCTRLs, ch_Tipos;

type
  Tch_ActionManager = class
  private
    FTV: TTreeView;
    procedure CalcularSerie(const Nome: String);
    procedure AdicionarSerieNaArvore(noPai: TTreeNode; Serie: TSerie);
    procedure AdicionarSerie(Posto: TPosto; Estat: TSerie; no: TTreeNode);
  public
    constructor Create(aTreeView: TTreeView);

    procedure DSInfo_Gantt (Sender: TObject);

    // Eventos das Séries
    procedure SerieVetor_Ind_Graficar (Sender: TObject);
    procedure SerieVetor_Ind_MostrarEmPlanilha (Sender: TObject);

    procedure SerieVetor_Col_Graficar (Sender: TObject);
    procedure SerieVetor_Col_MostrarEmPlanilha( Sender: TObject);
    procedure SerieVetor_Col_CoefCorrel (Sender: TObject);

    procedure SerieVetor_Ind_CriarMaximosDiariosAnuais (Sender: TObject);
    procedure SerieVetor_Ind_CriarMinimosDiariosAnuais (Sender: TObject);
    procedure SerieVetor_Ind_TotaisAnuais (Sender: TObject);
    procedure SerieVetor_Ind_MediasAnuais (Sender: TObject);
    procedure SerieVetor_Ind_TotaisMensaisAnuais (Sender: TObject);
    procedure SerieVetor_Ind_Parcial_Maximos_Diario (Sender: TObject);
    procedure SerieVetor_Ind_Parcial_Minimos_Diario (Sender: TObject);
    procedure SerieVetor_Ind_Parcial_Maximas_TotalMensal (Sender: TObject);
    procedure SerieVetor_Ind_Parcial_Minimas_TotalMensal (Sender: TObject);
    procedure SerieVetor_Ind_Parcial_Maximas_MediaMensal (Sender: TObject);
    procedure SerieVetor_Ind_Parcial_Minimas_MediaMensal (Sender: TObject);
    procedure SerieVetor_Ind_Parcial_MostrarEmPlanilha (Sender: TObject);
  end;

var
  ActionManager: Tch_ActionManager;

implementation
uses DateUtils,
     Forms,
     Graphics,
     wsVec,
     wsgLib,
     drPlanilha,
     Form_Chart,
     Dialogs,
     SysUtils,
     TreeViewUtils,
     GaugeFO,

     Graf_GANTT;


{ Tch_ActionManager }

procedure Tch_ActionManager.AdicionarSerie(Posto: TPosto; Estat: TSerie; no: TTreeNode);
begin
  Posto.Series.Adicionar(Estat);
  AdicionarSerieNaArvore(no, Estat);
end;

procedure Tch_ActionManager.AdicionarSerieNaArvore(noPai: TTreeNode; Serie: TSerie);
var NoTemp: TTreeNode;
begin
  noTemp := FTV.Items.AddChildObject(noPai, Serie.Nome, Serie);
  SetImageIndex(noTemp, 6);
end;

procedure Tch_ActionManager.CalcularSerie(const Nome: String);
var i         : Integer;
    Posto     : TPosto;
    no        : TTreeNode;
    gProgress : TDLG_Progress;
    ValorBase : Real;
    s         : String;
begin
  if System.pos('.Parc', Nome) > 0 then
     begin
     s := InputBox('Séries Parciais', 'Entre com um valor Base', '10');
     ValorBase := StrToFloatDef(s, 10);
     end;

  {$ifndef DEBUG}
  gProgress := CreateProgress(-1, -1, FTV.SelectionCount, 'Gerando Séries ...');
  {$endif}
  try
    for i := 0 to FTV.SelectionCount-1 do
      begin
      no := FTV.Selections[i];
      Posto := TPosto(no.Data);

      {$ifndef DEBUG}
      gProgress.Msg := 'Gerando série de ' + Posto.Nome;
      gProgress.Value := i+1;
      if gProgress.Cancelar then Exit;
      {$endif}

      if (Nome = 'Maximos Anuais') then
         AdicionarSerie(Posto, TSerie_Anual_Diaria_Maximos.Create(Posto), no)
      else

      if (Nome = 'Minimos Anuais') then
         AdicionarSerie(Posto, TSerie_Anual_Diaria_Minimos.Create(Posto), no)
      else

      if (Nome = 'Totais Anuais') then
         AdicionarSerie(Posto, TSerie_Anual_Agregada_Totais.Create(Posto), no)
      else

      if (Nome = 'Medias Anuais') then
         AdicionarSerie(Posto, TSerie_Anual_Agregada_Medias.Create(Posto), no)
      else

      if (Nome = 'Totais Mensais Anuais') then
         AdicionarSerie(Posto, TSerie_Anual_Mensal_AG_Total_Medias.Create(Posto), no)
      else

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

      // ...
      end;
    finally
      {$ifndef DEBUG}
      gProgress.Free;
      {$endif}
    end;
end;

constructor Tch_ActionManager.Create(aTreeView: TTreeView);
begin
  inherited Create;
  FTV := aTreeView;
end;     

procedure Tch_ActionManager.DSInfo_Gantt(Sender: TObject);
var i         : Integer;
    Info      : TDSInfo;
    gProgress : TDLG_Progress;
begin
  gProgress := CreateProgress(-1, -1, FTV.SelectionCount, 'Gerando Gantts ...');
  try
    for i := 0 to FTV.SelectionCount-1 do
      begin
      Info := TDSInfo(FTV.Selections[i].Data);
      gProgress.Value := i+1;
      if gProgress.Cancelar then Exit;
      TGRF_Gantt.Create(Info).Show;
      end;
    finally
      gProgress.Free;
    end;
end;

procedure Tch_ActionManager.SerieVetor_Col_CoefCorrel(Sender: TObject);
var i, ii, j, k: Integer;
    p: TPlanilha;
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
  V1 := Serie.Resultado;

  p := TPlanilha.Create;
  p.Caption := 'Correlações entre ' + Serie.Nome + ' (' + Serie.Posto.Nome + ') e ...';

  // Escreve o cabeçalho
  k := 4;
  p.SetCellFont(1, 2, 'arial', 10, clBlack, True);
  p.Write(1, 2, 'Ano Inicial');
  p.SetCellFont(1, 3, 'arial', 10, clBlack, True);
  p.Write(1, 3, 'Ano Final');
  for j := FTV.SelectionCount-2 downTo 0 do
    begin
    Serie := TSerie_Anual(FTV.Selections[j].Data);
    p.SetCellFont(1, k, 'arial', 10, clBlack, True);
    p.Write(1, k, Serie.Nome);
    p.SetCellFont(2, k, 'arial', 10, clBlack, True);
    p.Write(2, k, Serie.Posto.Nome);
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
       p.SetCellFont(Linha, 1, 'arial', 10, clBlack, True);
       p.Write(Linha, 1, 'b' + IntToStr(Linha-2)); // --> b1 .. b2 ...
       p.Write(Linha, 2, Serie.AnoInicial + bi - 1);
       p.Write(Linha, 3, Serie.AnoInicial + bf - 1);

       // Para os outros vetores
       k := 4;
       for j := FTV.SelectionCount-2 downTo 0 do
         begin
         Serie := TSerie_Anual(FTV.Selections[j].Data);
         V2 := Serie.Resultado;

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
            p.Write(Linha, k, cr);
            end;

         inc(k);
         end; // for j

       bi := 0;
       bf := 0;
       inc(Linha);
       end; // if bf > 0 ...

    end; // for i

  p.Show(fsMDIChild);
end;

procedure Tch_ActionManager.SerieVetor_Col_Graficar(Sender: TObject);
var g     : TfoChart;
    no    : TTreeNode;
    i     : Integer;
    Serie : TSerie_Anual;
begin
  g := TfoChart.Create('Séries');

  for i := 0 to FTV.SelectionCount-1 do
    begin
    no := FTV.Selections[i];
    Serie := TSerie_Anual(no.Data);
    Serie.Plotar(g, i);
    end;

  if g.Series.Count = 1 then
     begin
     g.Series[0].ShowInLegend := False;
     g.Caption := Serie.Nome + ' de ' + Serie.Posto.Nome;
     end;

  g.Show(fsMDIChild);
end;

procedure Tch_ActionManager.SerieVetor_Col_MostrarEmPlanilha(Sender: TObject);
var p     : TPlanilha;
    i, k  : Integer;
    Serie : TSerie_Anual;
begin
  p := TPlanilha.Create;
  p.Caption := 'Series';
  Serie := TSerie_Anual(FTV.Selections[0].Data);

  // Escreve os anos
  k := 3;
  for i := Serie.AnoInicial to Serie.AnoFinal do
    begin
    p.Write(k, 1, intToStr(i));
    inc(k);
    end;

  for i := FTV.SelectionCount-1 downto 0 do
    begin
    Serie := TSerie_Anual(FTV.Selections[i].Data);
    Serie.MostrarEmPlanilha(p, i+2);
    end;

  p.Show(fsMDIChild);
end;

procedure Tch_ActionManager.SerieVetor_Ind_CriarMaximosDiariosAnuais(Sender: TObject);
begin
  CalcularSerie('Maximos Anuais');
end;

procedure Tch_ActionManager.SerieVetor_Ind_CriarMinimosDiariosAnuais(Sender: TObject);
begin
  CalcularSerie('Minimos Anuais');
end;

procedure Tch_ActionManager.SerieVetor_Ind_Graficar(Sender: TObject);
var g     : TfoChart;
    no    : TTreeNode;
    i     : Integer;
    Serie : TSerie_Anual;
begin
  for i := 0 to FTV.SelectionCount-1 do
    begin
    g := TfoChart.Create('Séries');
    no := FTV.Selections[i];
    Serie := TSerie_Anual(no.Data);
    Serie.Plotar(g, i);
    g.Series[0].ShowInLegend := False;
    g.Caption := Serie.Nome + ' de ' + Serie.Posto.Nome;
    g.Show(fsMDIChild);
    end;
end;

procedure Tch_ActionManager.SerieVetor_Ind_MediasAnuais(Sender: TObject);
begin
  CalcularSerie('Medias Anuais');
end;

procedure Tch_ActionManager.SerieVetor_Ind_MostrarEmPlanilha(Sender: TObject);
var p       : TPlanilha;
    i, k, j : Integer;
    Serie   : TSerie_Anual;
    DI      : TDateTime;
    DF      : TDateTime;
begin
  for i := FTV.SelectionCount-1 downto 0 do
    begin
    Serie := TSerie_Anual(FTV.Selections[i].Data);

    p := TPlanilha.Create;
    p.Caption := Serie.Nome + ' (' + Serie.Posto.Nome + ')';

    DI := Serie.Posto.Info.DataInicial;
    DF := Serie.Posto.Info.DataFinal;

    // Escreve os anos
    k := 3;
    for j := YearOF(DI) to YearOF(DF) do
      begin
      p.Write(k, 1, intToStr(j));
      inc(k);
      end;

    Serie.MostrarEmPlanilha(p, 2);
    p.Show(fsMDIChild);
    end;
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
var p       : TPlanilha;
    i, k, j : Integer;
    Serie   : TSerie_Anual;
    DI      : TDateTime;
    DF      : TDateTime;
begin
  for i := FTV.SelectionCount-1 downto 0 do
    begin
    Serie := TSerie_Anual(FTV.Selections[i].Data);
    p := TPlanilha.Create;
    p.Caption := Serie.Nome + ' de ' + Serie.Posto.Nome;
    for k := 1 to Serie.Resultado.Len do
      p.Write(k+2, 1, IntToStr(k));
    Serie.MostrarEmPlanilha(p, 2);
    p.Show(fsMDIChild);
    end;
end;
                       
procedure Tch_ActionManager.SerieVetor_Ind_TotaisAnuais(Sender: TObject);
begin
  CalcularSerie('Totais Anuais');
end;

procedure Tch_ActionManager.SerieVetor_Ind_TotaisMensaisAnuais(Sender: TObject);
begin
  CalcularSerie('Totais Mensais Anuais');
end;

end.
