unit pro_Application;

interface
uses  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, ComCtrls, ImgList,
      WinUtils, ActnList, Graphics, IniFiles,
      psBASE,
      psCORE,
      psScriptControl,
      MSXML4,
      wsMatrix,
      MessagesForm,
      Chart,
      Chart.GlobalSetup,
      Application_Class,
      pro_Const,
      pro_Interfaces,
      pro_Classes,
      pro_DB_Classes;

type
  TApplicMessages = class
  private
    FRE: TRichEdit;
  public
    constructor Create(RE: TRichEdit);

    procedure Clear();
    procedure ShowError(const aMessage: string);
    procedure ShowWarning(const aMessage: string);
    procedure ShowMessage(const aMessage: string); overload;
    procedure ShowMessage(const aMessage: string; const Pars: array of const); overload;
  end;

  TproApplication = class(TApplication, IProcedaControl)
  private
    FTree: TTreeView;
    FNoDS: TTreeNode;
    FNoDBs: TTreeNode;
    FNoSeries: TTreeNode;
    FNoScripts: TTreeNode;
    FErrors: TfoMessages;
    FScripts: TScripts;
    FMinDate: TDateTime;
    FMessages: TApplicMessages;
    FSB: TStatusBar;
    FDataUnits: TStrings;
    FDataTypes: TStrings;
    FBXML_PluginsDir: string;
    FDBs: TDatabases;
    FSeries: TSeries;
    FLib: TLib;
    FAS: TPascalScript;
    FScriptControl: TfoScriptControl;
    FChartSetup: TGlobalSetup;
    procedure setAS(const Value: TPascalScript);
    function getDataset(i: integer): TDSInfo;
    function getDatasets: integer;
  protected
    procedure CreateMainForm(); override;
    procedure ReadGlobalsOptions(ini: TIniFile); override;
    procedure SaveGlobalsOptions(ini: TIniFile); override;
    function AddSerieInTree(ParentNode: TTreeNode; Serie: TSerie): TTreeNode;
  public
    constructor Create(const Title, Version: string);
    destructor Destroy(); override;

    function CreateDataSet(const MinDate, MaxDate: TDateTime; const IntervalType: TTipoIntervalo; const StationCount: integer): TwsDataset;

    // IProcedaControl interface
    function  NewDataSet(const MinDate, MaxDate: TDateTime; const IntervalType: TTipoIntervalo; const StationCount: integer): IDataControl;
    procedure ShowMessage(const aMessage: string);
    procedure DoneImport(dc: IDataControl);

    procedure UpdateProperties(Info: TDSInfo);
    procedure ShowProperties(Info: TDSInfo; ParentNode: TTreeNode);
    procedure AddInTree(Obj: TObject);
    procedure AddDatabase(DB: TDatabase);
    function  IsOpen(const Filename: String): Boolean;
    function  IsProcedaFile(const Filename: String; out Info: TDSInfo): boolean;
    procedure LoadSeries(node: IXMLDomNode; Station: TStation; AddMethod: TAddSerieMethod);

    // Edita um conjunto de strings
    function EditStrings(Strings: TStrings): boolean;

    function EditDataTypes(): boolean;
    function EditDataUnits(): boolean;
    procedure ShowChartSetupDialog();
    procedure SetupChart(Chart: TChart);

    // Mostra os relatorios e destroi os parametros
    procedure ShowReports(files, titles: TStrings);
    procedure ShowReport(const Filename, Title: String);

    // Fornece tempo a outros processos
    procedure ProcessMessages();

    // Remove um objeto da aplicação
    procedure RemoveObject(Obj: TObject);

    // Adiciona uma serie na aplicacao
    procedure AdicionarSerie(s: TSerie);

    // Retorna o conjunto de postos dado sua identificacao
    function DatasetByName(const s: string): TDSInfo;

    // Visual Objects
    property Tree   : TTreeView   read FTree;
    property Errors : TfoMessages read FErrors;

    property DataTypes : TStrings read FDataTypes;
    property DataUnits : TStrings read FDataUnits;

    property BXML_PluginsDir : string read FBXML_PluginsDir;

    // Controle das Series autonomas criadas por operacoes especiais
    property Series: TSeries read FSeries;

    // Lista dos bancos de dados disponíveis
    property Databases: TDatabases read FDBs;

    // Retorna o numero de Datasets abertos
    property Datasets : integer read getDatasets;

    // Retorna o i-egimo Dataset aberto
    property Dataset[i: integer] : TDSInfo read getDataset;

    // Mensagens que aparecem na janela principal
    property Messages : TApplicMessages read FMessages;

    // Barra de status da aplicacao
    property StatusBar : TStatusBar read FSB;

    // Bibliotecas do Pascal Script
    property psLIB : TLib read FLib;

    // Scripts da aplicacao
    property Scripts : TScripts read FScripts;

    // Representa o script atual que esta sendo executado, pode ser nil
    property ActiveScript : TPascalScript read FAS write setAS;
  end;

  function Applic(): TproApplication;

implementation
uses Math, DateUtils, Series, GraphicUtils,
     wsBXML_Output,
     BXML_Viewer,
     StringsEditor,
     SysUtilsEx,
     TreeViewUtils,
     FileUtils,
     wsConstTypes,
     wsgLib,
     wsVec,
     foBook,

     // PascalScript
     Lib_System,
     Lib_Windows,
     Lib_Math,
     Lib_String,
     Lib_StringList,
     Lib_Listas,
     Lib_File,
     Lib_wsVec,
     Lib_wsMatrix,
     Lib_Chart,
     Lib_Sheet,
     Lib_SpreadSheet,
     pro_psLib,

     // Proceda
     pro_Procs,
     pro_Actions,

     // Dialogs
     pro_fo_Main;

function Applic(): TproApplication;
begin
  result := TproApplication( TSystem.getAppInstance() );
end;

{ TApplicMessages }

procedure TApplicMessages.Clear;
begin
  FRE.Clear();
end;

constructor TApplicMessages.Create(RE: TRichEdit);
begin
  inherited Create;
  FRE := RE;
end;

procedure TApplicMessages.ShowError(const aMessage: string);
begin
  FRE.SelAttributes.Color := clRED;
  FRE.SelAttributes.Style := [fsbold];
  FRE.Lines.Add('Erro: ' + aMessage);
end;

procedure TApplicMessages.ShowMessage(const aMessage: string);
begin
  FRE.Lines.Add(aMessage);
end;

procedure TApplicMessages.ShowMessage(const aMessage: string; const Pars: array of const);
begin
  FRE.Lines.Add(Format(aMessage, Pars));
end;

procedure TApplicMessages.ShowWarning(const aMessage: string);
begin
  FRE.SelAttributes.Color := clBLUE;
  FRE.SelAttributes.Style := [fsbold];
  FRE.Lines.Add('Atenção: ' + aMessage);
end;

{ TproApplication }

procedure TproApplication.CreateMainForm();
var Main: TDLG_Principal;
begin
  CreateForm(TDLG_Principal, Main);
  FMessages := TApplicMessages.Create(Main.Messages);

  // Bibliotecas do Pascal Script
  FLib := TLib.Create();
  with FLib do
    begin
    Functions.Economize := False;
    Procs.Economize := False;
    Classes.Economize := False;

    Include(Lib_System.API);
    Include(Lib_Windows.API);
    Include(Lib_Math.API);
    Include(Lib_String.API);
    Include(Lib_StringList.API);
    Include(Lib_Listas.API);
    Include(Lib_File.API);
    Include(Lib_wsVec.API);
    Include(Lib_wsMatrix.API);
    Include(Lib_Chart.API);
    Include(Lib_Sheet.API);
    Include(Lib_SpreadSheet.API);
    Include(pro_psLib.API);
    end;

  FSB := Main.StatusBar;
  FTree := Main.Arvore;
  FnoDS := FTree.Items[0];
  FNoSeries := FTree.Items[1];

  FNoScripts := FTree.Items[2];
  FScripts := TScripts.Create(FNoScripts);

  FNoDBs := FTree.Items[3];
  Main.Caption := ' ' + self.Title + ' - Versão ' + self.Version;
end;

function TproApplication.CreateDataSet(const MinDate, MaxDate: TDateTime; const IntervalType: TTipoIntervalo; const StationCount: integer): TwsDataset;
var i, i1, i2: Integer;
    v: TwsVec;
    d: TDateTime;
    aa, mm, dd: word;
    c2, c3, c4: TwsQualitative;
begin
  // Conjunto de dados
  result := TwsDataset.Create('Proceda');

  // 1.Col
  result.Struct.AddNumeric('DataAgregada', 'Representa o número de dias deste uma determinada data');

  // 2.Col
  result.Struct.AddQualitative('Dia', '');
  c2 := TwsQualitative(result.Struct.Col[2]);
  for i := 1 to 31 do c2.AddLevel(intToStr(i));

  // 3.Col
  result.Struct.AddQualitative('Mes', '');
  c3 := TwsQualitative(result.Struct.Col[3]);
  for i := 1 to 12 do c3.AddLevel(intToStr(i));

  // 4.Col
  result.Struct.AddQualitative('Ano', '');
  c4 := TwsQualitative(result.Struct.Col[4]);
  DecodeDate(MinDate, aa, mm, dd); i1 := aa;
  DecodeDate(MaxDate, aa, mm, dd); i2 := aa;
  for i := i1 to i2 do c4.AddLevel(intToStr(i));

  // 5.Col em diante
  for i := 1 to StationCount do
    result.Struct.AddNumeric('posto_' + SysUtilsEx.toString(i), '');

  d := MinDate;
  while d <= MaxDate do
    begin
    DecodeDate(d, aa, mm, dd);
    v := result.AddRow('');
    v[1] := d;
    v[2] := dd;
    v[3] := mm;
    v[4] := c4.LevelToIndex(intToStr(aa));

    if IntervalType = tiDiario then
       d := d + 1 {dia}
    else
    if IntervalType = tiMensal then
      d := d + DateUtils.DaysInAMonth(aa, mm);
    end;

  result.Tag_1 := ord(IntervalType);
end;

function TproApplication.NewDataSet(const MinDate, MaxDate: TDateTime; const IntervalType: TTipoIntervalo; const StationCount: integer): IDataControl;
var ds: TwsDataSet;
begin
  FMinDate := MinDate;
  ds := CreateDataSet(MinDate, MaxDate, IntervalType, StationCount);
  result := TDSInfo.Create(ds);
end;

procedure TproApplication.ShowProperties(Info: TDSInfo; ParentNode: TTreeNode);
var no2, no3, no4: TTreeNode;
    i, k: Integer;
    Posto: TStation;

    // Mostra as series recursivamente
    procedure ShowSeries(Series: TSeries; ParentNode: TTreeNode);
    var i: Integer;
        s: TSerie;
        no: TTreeNode;
    begin
      for i := 0 to Series.NumSeries-1 do
        begin
        s := Series[i];
        no := AddSerieInTree(ParentNode, s);
        ShowSeries(s.Series, no);
        end;
    end;

begin
  ParentNode.DeleteChildren();

  // Dados Temporais ..................................................

  no2 := FTree.Items.AddChild(ParentNode, 'Dados Temporais');
  SetImageIndex(no2, iiCloseFolder);

     for i := 0 to Info.NumPostos-1 do
       begin
       Posto := Info.getStationByIndex(i);
       no3 := FTree.Items.AddChildObject(no2, Posto.Nome, Posto);
       ShowSeries(Posto.Series, no3);
       end;

  // Propriedades ................................................

  no2 := FTree.Items.AddChild(ParentNode, 'Propriedades');
  SetImageIndex(no2, iiCloseFolder);

     no3 := FTree.Items.AddChild(no2, 'Registros: ' + IntToStr(Info.DS.nRows));
     SetImageIndex(no3, iiInformation);

     no3 := FTree.Items.AddChild(no2, 'Data Inicial: ' + DateToStr(Info.DataInicial));
     SetImageIndex(no3, iiInformation);

     no3 := FTree.Items.AddChild(no2, 'Data Final: ' + DateToStr(Info.DataFinal));
     SetImageIndex(no3, iiInformation);

     no3 := FTree.Items.AddChild(no2, 'Tipo de Intervalo: ' + TipoIntervaloToStr(Info.TipoIntervalo));
     SetImageIndex(no3, iiInformation);

  // Arquivos ..........................................................

  no2 := FTree.Items.AddChild(ParentNode, 'Arquivos Associados');
  SetImageIndex(no2, iiCloseFolder);

    no3 := FTree.Items.AddChild(no2, 'Dados Temporais: ' + Info.NomeArq);
    SetImageIndex(no3, iiInformation);

    no3 := FTree.Items.AddChild(no2, 'Dados Temporais Suplementares: ' + Info.NomeArq + '.Extra');
    SetImageIndex(no3, iiInformation);
end;

procedure TproApplication.AddInTree(Obj: TObject);
var no: TTreeNode;
    s: string;
    Info: TDSInfo;
    db: TDatabase;
begin
  if Obj is TDSInfo then
     begin
     Info := TDSInfo(Obj);

     if Info.DS.MLab <> '' then
        s := Info.DS.MLab
     else
        if Info.NomeArq <> '' then
           s := ExtractFileName(Info.NomeArq)
        else
           s := 'Sem Título';

     no := FTree.Items.AddChildObject(FnoDS, s, Info);
     SetImageIndex(no, iiDatabase);
     ShowProperties(Info, no);
     FnoDS.Expand(False);
     no.Selected := true;
     end
  else

  if Obj is TDatabase then
     begin
     db := TDatabase(Obj);
     no := FTree.Items.AddChildObject(FNoDBs, db.Name, db);
     SetImageIndex(no, iiDatabase);
     db.ShowInTree(FTree, no);
     end;
end;

procedure TproApplication.UpdateProperties(Info: TDSInfo);
var no: TTreeNode;
begin
  no := FindNode(FNoDS, Info);
  ShowProperties(Info, no);
  no.Expand(false);
end;

function TproApplication.AddSerieInTree(ParentNode: TTreeNode; Serie: TSerie): TTreeNode;
begin
  result := FTree.Items.AddChildObject(ParentNode, Serie.Nome, Serie);
  SetImageIndex(result, 6);
end;

function TproApplication.IsOpen(const Filename: String): Boolean;
var i: Integer;
begin
  Result := False;
  for i := 0 to FnoDS.Count-1 do
    if CompareText(FnoDS[i].Text, Filename) = 0 then
       begin
       Result := True;
       Break;
       end;
end;

function TproApplication.IsProcedaFile(const Filename: String; out Info: TDSInfo): boolean;
var DS: TwsDataset;
begin
  try
    DS := TwsDataSet(TwsDataSet.LoadFromFile(Filename));
  except
    result := false;
  end;

  result := (DS.Struct.Col[1].ColType = dtNumeric) and
            (DS.Struct.Col[2].ColType = dtQualit) and
            (DS.Struct.Col[3].ColType = dtQualit) and
            (DS.Struct.Col[4].ColType = dtQualit) and
            (DS.Struct.Col[5].ColType = dtNumeric);

  if result then
     begin
     Info := TDSInfo.Create(DS);
     Info.LoadFromFile(Filename);
     end
  else
     begin
     Info := nil;
     DS.Free();
     end;
end;

constructor TproApplication.Create(const Title, Version: string);
begin
  inherited Create(Title, Version);

  // Lista dos banco de dados
  FDBs := TDatabases.Create();

  // Registra os banco de dados reconhecidos pelo sistema
  FDBs.RegisterClass(TADO_Database);
  //FDBs.RegisterClass(TBDE_Database);
  //FDBs.RegisterClass(TZEOS_Database);

  // Registra os tipos especiais de tabelas
  FDBs.RegisterClass(TADO_Table_Hidro_Postos);

  // Registra algumas classes importantes para a aplicacao
  {TODO 0 -cLEMBRETE: Sempre registrar series instanciaveis}
  self.RegisterClass(TSerie_Anual_Minimos);
  self.RegisterClass(TSerie_Anual_Diaria_Maximos);
  self.RegisterClass(TSerie_Anual_Diaria_Minimos);
  self.RegisterClass(TSerie_Anual_Agregada_Totais);
  self.RegisterClass(TSerie_Anual_Agregada_Medias);
  self.RegisterClass(TSerie_Anual_Preenchida);
  self.RegisterClass(TSerie_Mensal_Total);
  self.RegisterClass(TSerie_Mensal_Media);
  self.RegisterClass(TSerie_Anual_Mensal_AG_Total_Medias);
  self.RegisterClass(TSerie_Parcial_Diaria_Minimos);
  self.RegisterClass(TSerie_Parcial_TotalMensal_Minimas);
  self.RegisterClass(TSerie_Parcial_MediaMensal_Minimas);
  self.RegisterClass(TSerie_Parcial_Diaria_Maximos);
  self.RegisterClass(TSerie_Parcial_TotalMensal_Maximas);
  self.RegisterClass(TSerie_Parcial_MediaMensal_Maximas);
  self.RegisterClass(TSerie_Mensal_Preenchida);
  self.RegisterClass(TSerie_Mensal_MediaAnuais);
  self.RegisterClass(TSerie_Mensal_MediaMensais);
  self.RegisterClass(TSerie_PostoAdmensionalizado);

  // Definicoes globais
  SysUtils.ShortDateFormat := 'dd/mm/yyyy';
  SysUtils.DecimalSeparator := '.';
  WinUtils.PixelsPerInch := 96;

  // Gerenciador de acoes
  ActionManager := Tch_ActionManager.Create(FTree);

  // Campos internos
  FErrors := TfoMessages.Create();
  FDataUnits := TStringList.Create();
  FDataTypes := TStringList.Create();

  // Lista de series
  FSeries := TSeries.Create();

  // Definicao do diretorio onde estao os plugins do BXML
  FBXML_PluginsDir := self.AppDir + 'BXML Plugins\';

  // Gerenciador de scripts
  FScriptControl := TfoScriptControl.Create();
  FScriptControl.FormStyle := fsStayOnTop;

  // Configurador de graficos
  FChartSetup := TGlobalSetup.Create(' Configuração Geral dos Gráficos');
end;

destructor TproApplication.Destroy();
begin
  FChartSetup.Free();
  FScriptControl.Free();
  FSeries.Free();
  FDataUnits.Free();
  FDataTypes.Free();
  FErrors.Free();
  ActionManager.Free();
  FDBs.Free();
  psLib.Free();

  inherited Destroy(); 
end;

procedure TproApplication.ReadGlobalsOptions(ini: TIniFile);
var i: Integer;
begin
  inherited ReadGlobalsOptions(ini);

  with ini do
    begin
    i := readInteger('Data Types', 'Count', -1);
    for i := 1 to i do
      FDataTypes.Add(readString('Data Types', 'DT' + intToStr(i), ''));

    i := readInteger('Data Units', 'Count', -1);
    for i := 1 to i do
      FDataUnits.Add(readString('Data Units', 'DT' + intToStr(i), ''));

    i := readInteger('Scripts', 'Count', -1);
    for i := 1 to i do
      FScripts.Add(readString('Scripts', 'Item' + intToStr(i), ''));
    end;
end;

procedure TproApplication.SaveGlobalsOptions(ini: TIniFile);
var i: Integer;
begin
  with ini do
    begin
    writeInteger('Data Types', 'Count', FDataTypes.Count);
    for i := 0 to FDataTypes.Count-1 do
      writeString('Data Types', 'DT' + IntToStr(i+1), FDataTypes[i]);

    writeInteger('Data Units', 'Count', FDataUnits.Count);
    for i := 0 to FDataUnits.Count-1 do
      writeString('Data Units', 'DT' + IntToStr(i+1), FDataUnits[i]);

    writeInteger('Scripts', 'Count', FScripts.Count);
    for i := 0 to FScripts.Count-1 do
      writeString('Scripts', 'Item' + IntToStr(i+1), FScripts[i].Filename);
    end;

  inherited SaveGlobalsOptions(ini);
end;

function TproApplication.EditStrings(Strings: TStrings): boolean;
begin
  result := TfoStringsEditor.Edit(Strings);
end;

function TproApplication.EditDataTypes(): boolean;
begin
  result := EditStrings(FDataTypes);
end;

function TproApplication.EditDataUnits(): boolean;
begin
  result := EditStrings(FDataUnits);
end;

procedure TproApplication.DoneImport(dc: IDataControl);
begin
  AddInTree( TDSInfo(dc.getReference()) );
end;

procedure TproApplication.ShowReport(const Filename, Title: String);
var v: TBXML_Viewer;
begin
  v := TBXML_Viewer.Create(Filename, self.BXML_PluginsDir, '', True);
  v.Caption := ' ' + Title;
  v.ViewFileNames := False;
  v.Show();

  // Para controle dos arquivos temporários criados
  self.AddTempFile(v.FileName);
  self.AddTempFile(v.HTMLFile);
end;

procedure TproApplication.ShowReports(files, titles: TStrings);
var i: Integer;
begin
  try
    for i := 0 to files.Count-1 do
      ShowReport(files[i], titles[i]);
  finally
    files.Free();
    titles.Free();
  end;
end;

procedure TproApplication.ProcessMessages();
begin
  Application.ProcessMessages();
end;

procedure TproApplication.RemoveObject(Obj: TObject);
var no: TTreeNode;
begin
  no := TreeViewUtils.FindNode(FTree.Items[0], Obj);
  if no <> nil then
     no.Delete();
end;

procedure TproApplication.AddDatabase(DB: TDatabase);
var n1: TTreeNode;
begin
  // Adiciona na arvore
  AddInTree(DB);

  // Adiciona na lista de Banco de Dados
  FDBs.add(DB);
end;

procedure TproApplication.ShowMessage(const aMessage: string);
begin
  FMessages.ShowMessage(aMessage);
end;

procedure TproApplication.LoadSeries(node: IXMLDomNode; Station: TStation; AddMethod: TAddSerieMethod);
var i: Integer;
    s: TSerie;
    c: TSerieClass;
    n: IXMLDomNode;
begin
  i := node.childNodes.length;
  for i := 0 to i-1 do
    begin
    n := node.childNodes.item[i];
    c := TSerieClass(getClass(n.attributes.item[0].text));
    if c <> nil then
       begin
       s := c.Create(Station, false);
       s.fromXML(n);
       AddMethod(s);
       end
    else
       Applic.Messages.ShowWarning('Série não registrada: ' + n.attributes.item[0].text);
    end;
end;

procedure TproApplication.AdicionarSerie(s: TSerie);
begin
  FSeries.Adicionar(s);
  FTree.Items.AddChildObject(FNoSeries, s.Nome, s);
end;

procedure TproApplication.setAS(const Value: TPascalScript);
begin
  FAS := Value;
  FScriptControl.Script := FAS;
  FScriptControl.Visible := (FAS <> nil);
  if FAS <> nil then
     psBASE.setGlobalProgressBar(FScriptControl)
  else
     psBASE.setGlobalProgressBar(nil);
end;

function TproApplication.DatasetByName(const s: string): TDSInfo;
var i: Integer;
begin
  result := nil;
  for i := 0 to FNoDS.Count-1 do
    if FNoDS.Item[i].Text = s then
       begin
       result := getDataset(i);
       break;
       end
end;

function TproApplication.getDataset(i: integer): TDSInfo;
begin
  result := TDSInfo( FNoDS.Item[i].Data );
end;

function TproApplication.getDatasets(): integer;
begin
  result := FNoDS.Count;
end;

procedure TproApplication.ShowChartSetupDialog();
var s: string;
begin
  s := Applic.AppDataDir + 'ChartSetup.xml';
  if SysUtils.FileExists(s) then FChartSetup.LoadFromFile(s);
  if FChartSetup.Execute() = mrOK then
     FChartSetup.SaveToFile(s);
end;

procedure TproApplication.SetupChart(Chart: TChart);
begin
  FChartSetup.SetupChart(Chart);
end;

end.

