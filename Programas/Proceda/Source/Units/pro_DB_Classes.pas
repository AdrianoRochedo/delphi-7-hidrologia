unit pro_DB_Classes;

interface
uses Classes, Contnrs, ComCTRLs, TreeViewUtils, ActnList, Controls, SysUtils,
     IniFiles, SysUtilsEx, DB, Dialogs, DateUtils,
     // {BDE}  DBTables,
     // {ZEOS} ZDbcIntfs, ZConnection, ZDataset, ZDatasetUtils,
     {ADO} ADODB,
     pro_Const,
     pro_BaseClasses,
     pro_DB_Interfaces;

type
  TIni = TMemIniFile;

  TDatabase       = class;
  TADO_Database   = class;
  TTable          = class;
  TDataset        = class;
  TDatabaseClass  = class of TDatabase;
  TTableClass     = class of TTable;

  TField = class(TNoObjeto)
  private
    FName: string;
    FType: TFieldType;
    FDS: TDataset;
    function getFullName: string;
  protected
    function ObterTextoDoNo(): string; override;
    function ObterIndiceDaImagem(): integer; override;
  public
    constructor Create(const aName: string; aType: TFieldType; aDS: TDataSet);

    // Retorna o nome do campo
    property FieldName : string read FName;

    // Retirna o nome completo do campo, isto é, Tablename.FieldName
    property FullName : string read getFullName;

    property FieldType  : TFieldType read FType;
    property Dataset    : TDataset   read FDS;
  end;

  TFields = class(TNoObjeto)
  private
    FList: TObjectList;
    function getCount: integer;
    function getItem(i: integer): TField;

    // root
    //  Campo 1
    //  Campo 2
    //  Campo n
    procedure ShowInTree(Tree: TTreeView; root: TTreeNode); override;
  public
    constructor Create();
    destructor Destroy(); override;

    procedure Add(Item: TField);

    property Count : integer read getCount;
    property Item[i: integer] : TField read getItem; default;
  end;

  TDataSet = class(TNoObjeto)
  private
    FDB: TDatabase;
    FFields: TFields;
    FName: string;
    function getFields: TFields; virtual;
    procedure ViewEvent(Sender: TObject);
  protected
    function ObterIndiceDaImagem(): integer; override;

    // Identificacao do Dataset
    //   Campo 1
    //   Campo 2
    //   Campo n
    procedure ShowInTree(Tree: TTreeView; root: TTreeNode); override;
  protected
    destructor Destroy(); override;

    // Responsável por criar a lista e ler os campos
    procedure LoadFields(); virtual;

    // Retorna o nome inteiro do arquivo quando o banco de dados é
    // baseado em diretório
    function getFullName(): string; virtual;

    // Visualizacao dos dados
    procedure ExecutarAcaoPadrao(); override;

    // Mostra outras informacoes sobre a tabela
    procedure ShowExtraProperties(Tree: TTreeView; RootNode: TTreeNode); virtual;
  public
    constructor Create(DB: TDatabase);

    // Mostra os campos da tabela em uma árvora
    procedure ShowProperties(Tree: TTreeView; RootNode: TTreeNode);

    // Mostra a tabela em uma janela
    procedure View(); virtual;

    // Banco de dados a que pertence
    property Database : TDatabase read FDB;

    // Campos
    property Fields : TFields read getFields;

    // Nome completo da tabela
    // Para alguns banco de dados é o Path + Name
    property FullName : string read getFullName;

    // Identificação da tabela
    property Name : string read FName;
  end;

  TTable = class(TDataSet)
  protected
    function getFields(): TFields; override;
    function ObterTextoDoNo(): string; override;
    function getFullName(): string; override;
    procedure ObterAcoesIndividuais(Acoes: TActionList); override;

    // Retorna o nome inteiro do arquivo quando o banco de dados é
    // baseado em diretório e é compatível com a sintaxe do SQL
    function getSQLFullName(): string; virtual;
  public
    constructor Create(DB: TDatabase; const Name: string);

    // Nome completo voltado para a sintaxe do SQL
    // Ex: result := '"C:\tmp\xx.DB"';
    property SQLFullName : string read getSQLFullName;
  end;

  TADO_Table = class(TTable)
  protected
    procedure LoadFields(); override;
  public
    procedure View(); override;
    function getDB(): TADO_Database;
  end;

  {
  Representa tabelas que possuem pelo menos os campos:
    - EstacaoCodigo
    - Data
    - Cota01..Cota31 ou Chuva01..Chuva31 ou Vazao01..Vazao31 ou Clima01..Clima31

  Estas tabelas podem ser exportadas para o proceda.
  ATENCAO: Nao troque o nome desta classe pois ela esta registrada no sistema e
           eh utilizada nos arquivos de padroes de banco de dados
  }
  TADO_Table_Hidro_Postos = class(TADO_Table)
  private
    FPostos: TObjectList;
    destructor Destroy(); override;
  protected
    procedure ShowExtraProperties(Tree: TTreeView; RootNode: TTreeNode); override;
  end;

  // Representa uma "casca" para um dos postos de uma tabela de postos do
  // banco de dados Hidro
  TADO_Hidro_Posto = class(TNoObjeto)
  private
    FDI: TDateTime;
    FDF: TDateTime;
    FNome: string;
    FTab: string;
    FDB: TDatabase;
    FCod: integer;
    FNC: integer;
  protected
    function ObterTextoDoNo(): string; override;
    function ObterIndiceDaImagem(): integer; override;
    procedure ObterAcoesColetivas(Acoes: TActionList); override;
  public
    constructor Create(Nome: string; NC: integer; DI, DF: TDateTime; TabelaPai: string; DB: TDatabase);

    property Nome                : string    read FNome;
    property Codigo              : integer   read FCod;
    property NivelDeConsistencia : integer   read FNC;
    property DataInicial         : TDateTime read FDI;
    property DataFinal           : TDateTime read FDF;
    property TabelaPai           : string    read FTab;
    property DB                  : TDatabase read FDB;
  end;

  TTables = class(TNoObjeto)
  private
    FList: TObjectList;
    destructor Destroy(); override;
    function getCount(): integer;
    function getItem(i: integer): TTable;
  protected
    function ObterIndiceDaImagem(): integer; override;
    function ObterTextoDoNo(): string; override;

    // root
    //   Tabelas
    //     Tab 1
    //     Tab 2
    //     Tab 3
    procedure ShowInTree(Tree: TTreeView; root: TTreeNode); override;
  public
    constructor Create();

    procedure Clear();
    procedure Add(item: TTable);

    property Count : integer read getCount;
    property Item[i: integer] : TTable read getItem; default;
  end;

  TDatabase = class(TNoObjeto, IDBControl)
  private
    //FPlugins: TPlugins;

    FTables: TTables;
    FName: string;
    FType: string;
    //FSQLs: TSQLs;
    FNode: TTreeNode;

    destructor Destroy(); override;
    procedure DisconnectEvent(Sender: TObject);
    procedure ExecuteSQLEvent(Sender: TObject);
    //procedure ImportEvent(Sender: TObject);
    //procedure ExportEvent(Sender: TObject);
    //procedure ShowGenericGraphicsEvent(Sender: TObject);
    //procedure RegisterPluginEvent(Sender: TObject);
  protected
    // begin IDBControl
     function idbc_GetDatabaseName(): string;
     function idbc_OpenTable (const Tablename: string): TObject; virtual;
     function idbc_ExecSQL (const SQL: string): string;
     function idbc_GetExtraInfo (const parameter: string): string; virtual;
    procedure idbc_CloseTable (t: TObject);
    procedure idbc_FreeTable (var t: TObject);
    procedure idbc_Append (t: TObject);
    procedure idbc_Insert (t: TObject);
    procedure idbc_Edit (t: TObject);
    procedure idbc_Post (t: TObject);
    procedure idbc_First (t: TObject);
    procedure idbc_Last (t: TObject);
    procedure idbc_Prior (t: TObject);
    procedure idbc_Next (t: TObject);
     function idbc_EOF (t: TObject): boolean;
     function idbc_BOF (t: TObject): boolean;
    procedure idbc_SetFieldAsString   (t: TObject; fi: integer; const value: string);
    procedure idbc_SetFieldAsFloat    (t: TObject; fi: integer; const value: real);
    procedure idbc_SetFieldAsInteger  (t: TObject; fi: integer; const value: integer);
    procedure idbc_SetFieldAsBoolean  (t: TObject; fi: integer; const value: boolean);
    procedure idbc_SetFieldAsDateTime (t: TObject; fi: integer; const value: TDateTime);
     function idbc_FieldIsNull        (t: TObject; fi: integer): boolean;
     function idbc_GetFieldAsString   (t: TObject; fi: integer): string;
     function idbc_GetFieldAsFloat    (t: TObject; fi: integer): real;
     function idbc_GetFieldAsInteger  (t: TObject; fi: integer): integer;
     function idbc_GetFieldAsBoolean  (t: TObject; fi: integer): boolean;
     function idbc_GetFieldAsDateTime (t: TObject; fi: integer): TDateTime;
     function idbc_GetFieldType (t: TObject; fi: integer): byte;
     function idbc_GetFieldName (t: TObject; fi: integer): string;
     function idbc_GetFieldCount(t: TObject): integer;
     function idbc_GetFieldIndex(t: TObject; const Name: string): integer;
     function idbc_GetRecordCount (t: TObject): integer;
    // end IDBControl

    // Erros
    function ResultSetSQLError(const SQL: string): string;

    // Responsável pela leitura das tabelas
    procedure LoadTables(); virtual; abstract;

    // Responsável pela leitura dos Procedimentos
    // Não é abstrato pois nem todos os DBs possuem StoredProcs
    procedure LoadStoredProcs(); virtual;

    // Salva as configurações em arquivo
    procedure SaveState(iniFile: TIni; Section: string); virtual;

    // Cria e carrega as configurações de um arquivo
    // Deverá existir um para cada descendente
    // Todo campo instanciado no "Create" também deverá ser instanciado aqui.
    constructor LoadState(iniFile: TIni; Section: string); virtual;

    function ObterTextoDoNo(): string; override;
    function ObterIndiceDaImagem(): integer; override;
    procedure ObterAcoesIndividuais(Acoes: TActionList); override;
  public
    // Todo campo instanciado aqui também deverá ser instanciado em "LoadState".
    constructor Create(const aName, aType: string);

    // Inicia o Banco de Dados
    procedure Init();

    // Fecha a conecção
    procedure Disconnect();

    // Mostra o Banco de dados em uma árvore
    procedure ShowInTree(Tree: TTreeView; Root: TTreeNode); override;

    // Atualiza a arvore principal
    procedure UpdateTree(Tree: TTreeView);

    // Executa um comando SQL e, quando existe um resultado, mostra este
    // em uma janela senão somente o executa.
    // Este método utiliza polimorficamente OpenSQL() e ExecSQL()
    function ExecuteSQL(const SQL: string; out ds: DB.TDataSet; out rowsAffected: integer): string;

    // Retorna um resultado se o SQL for um comando da categoria de "Select"
    function OpenSQL(const SQL: string; var Error: string): DB.TDataSet; virtual;

    // Executa um comando que não retorna resultado
    function ExecSQL(const SQL: string; var rowsAffected: integer): string; virtual;

    // Exporta uma tabela ou um resultado de um comando SQL
    procedure ExportDataset(DS: DB.TDataset);

    // Mostra uma tabela ou resultado de um comando SQL
    procedure ShowDataset(const Caption: string; Dataset: DB.TDataset);

    // Nome do Banco de Dados
    property Name: string read FName;

    // Tipo do Banco de Dados. Ex: MySQL, Oracle, Interbase
    property DBType: string read FType;

    // Conjunto de tabelas que forma o Banco de Dados
    property Tables: TTables read FTables;

    // Conjunto de comandos SQL
    //property SQLs: TSQLs read FSQLs;

    // Plugins que este Banco de dados registrou
    // property Plugins: TPlugins read FPlugins;
  end;

  TADO_Database = class(TDatabase)
  private
    FFilename: string;
    FConn: TADOConnection;
    FSP: TStrings;
    destructor Destroy; override;
    procedure get_STD_Tables(Tables: TStrings; out stdTables: TStrings; out TableClassName: string);
  protected
    function idbc_OpenTable (const Tablename: string): TObject; override;
    function OpenSQL(const SQL: string; var Error: string): DB.TDataSet; override;
    function ExecSQL(const SQL: string; var rowsAffected: integer): string; override;
    procedure LoadTables(); override;
    procedure LoadStoredProcs(); override;

    // root
    //   Tables ...
    //   SQLs ...
    //   Procedimentos
    //     Proc 1
    //     Proc n
    procedure ShowInTree(Tree: TTreeView; Root: TTreeNode); override;

    procedure SaveState(iniFile: TIni; Section: string); override;
  public
    constructor Create(const aName, aType, aFilename: string);
    constructor LoadState(iniFile: TIni; Section: string); override;

    property Connection : TADOConnection read FConn;
    property StoredProcs : TStrings read FSP;
  end;

  // Representa as bases de dados conectadas pela aplicação
  TDatabases = class(TNoObjeto)
  private
    FList: TObjectList;
    FClasses: TStrings;
    destructor Destroy(); override;
    function getCount: integer;
    function getItem(i: integer): TDatabase;
    //function createBDE_Connection(const DBType: string): TDatabase;
    //function createZEOS_Connection(const DBType: string): TDatabase;
    function createACCESS_Connection(const DBType: string): TDatabase;
  public
    constructor Create();

    // Cria uma conecção a um banco de dados
    // ConnType representa o tipo de conecção utilizada pelo banco de dados
    function CreateConnection(const DBType: string): TDatabase;

    // Fecha um banco de dados da aplicação
    procedure Disconnect(DB: TDatabase);

    // Adiciona um banco de dados na aplicação
    procedure Add(DB: TDatabase);

    // Salva as configurações em arquivo
    procedure SaveState(iniFile: TIni);

    // Carrega as configurações de um arquivo
    procedure LoadState(iniFile: TIni);

    // Registra uma classe no sistema
    procedure RegisterClass(aClass: TClass);

    // Retorna uma classe registrada no sistema
    function getClass(const ClassName: string): TClass;

    // Retorna o total de banco de dados conectados a aplicação
    property Count : integer read getCount;

    // Retorna um banco de dados
    property Item[i: integer] : TDatabase read getItem;
  end;

implementation
uses DBUtils,
     WinUtils,
     pro_Actions,
     pro_Application,
     pro_fo_ViewDataSet,
     pro_fo_Access_Connection;

{ TField }

constructor TField.Create(const aName: string; aType: TFieldType; aDS: TDataset);
begin
  inherited Create();
  FName := aName;
  FType := aType;
  FDS  := aDS;
end;

function TField.getFullName: string;
begin
  if FDS is TTable then
     Result := TTable(FDS).Name + '.' + FName
  else
     Result := FName;
end;

function TField.ObterIndiceDaImagem(): integer;
begin
{
  TFieldType = (ftUnknown, , ftSmallint, ftInteger, ftWord,
    ftBoolean, ftFloat, ftCurrency, ftBCD, ,
    ftBytes, ftVarBytes, ftAutoInc, ftBlob, ftMemo, ftGraphic, ftFmtMemo,
    ftParadoxOle, ftDBaseOle, ftTypedBinary, ftCursor, ftFixedChar, ftWideString,
    ftLargeint, ftADT, ftArray, ftReference, ftDataSet, ftOraBlob, ftOraClob,
    ftVariant, ftInterface, ftIDispatch, ftGuid, ftTimeStamp, ftFMTBcd);
}
  case FType of
    ftUnknown:
      result := iiField;

    ftString, ftWideString:
      result := iiAlfaField;

    ftAutoInc:                                               
      result := iiNumericField_AutoInc;                      
                                                             
    ftSmallint, ftInteger, ftWord:                           
      result := iiNumericField_Integer;

    ftFloat:
      result := iiNumericField_Float;

    ftCurrency:
      result := iiNumericField_Currency;

    ftBoolean:
      result := iiBooleanField;  

    ftDate, ftDateTime, ftTimeStamp:
      result := iiDateField;

    ftTime:
      result := iiTimeField;

    ftMemo, ftFmtMemo:
      result := iiMemoField;

    ftGraphic:
      result := iiGraphicField;

    else
       result := iiField;
  end;
end;

function TField.ObterTextoDoNo(): string;
begin
  result := FName;
end;

{ TFields }

constructor TFields.Create();
begin
  inherited Create();
  FList := TObjectList.Create(true);
end;

destructor TFields.Destroy();
begin
  FList.Free();
  inherited Destroy();
end;

procedure TFields.Add(Item: TField);
begin
  FList.Add(Item);
end;

function TFields.getCount(): integer;
begin
  Result := FList.Count;
end;

function TFields.getItem(i: integer): TField;
begin
  Result := TField(FList[i]);
end;

// root
//  Campo 1
//  Campo 2
//  Campo n
procedure TFields.ShowInTree(Tree: TTreeView; root: TTreeNode);
var n1: TTreeNode;
    i: integer;
    x: TField;
begin
  for i := 0 to getCount()-1 do
    begin
    x := getItem(i);
    n1 := Tree.Items.AddChildObject(root, x.FieldName, x);
    end;
end;

{ TDataSet }

constructor TDataSet.Create(DB: TDatabase);
begin
  inherited Create();
  FDB := DB;
end;

destructor TDataSet.Destroy();
begin
  FFields.Free();
  inherited;
end;

procedure TDataSet.ExecutarAcaoPadrao();
begin
  ViewEvent(nil);
end;

function TDataSet.getFields: TFields;
begin
  result := FFields;
end;

function TDataSet.ObterIndiceDaImagem(): integer;
begin
  result := iiDataset;
end;

procedure TDataSet.LoadFields();
begin

end;

procedure TDataSet.ShowProperties(Tree: TTreeView; RootNode: TTreeNode);
var i: Integer;
    n: TTreeNode;
begin
  if FFields = nil then LoadFields();
  if FFields = nil then Exit;

  WinUtils.StartWait();
  Tree.Items.BeginUpdate();
  try
    RootNode.DeleteChildren();
    n := Tree.Items.AddChild(RootNode, 'Campos');
    for i := 0 to FFields.Count-1 do
      Tree.Items.AddChildObject(n, FFields[i].FieldName, FFields[i]);
    ShowExtraProperties(Tree, RootNode);
  finally
    Tree.Items.EndUpdate();
    WinUtils.StopWait();
  end;
end;

// Identificacao do Dataset
//   Campo 1
//   Campo 2
//   Campo n

procedure TDataSet.ShowInTree(Tree: TTreeView; root: TTreeNode);
var n1: TTreeNode;
begin
  n1 := Tree.Items.AddChildObject(root, self.Name, self);
  FFields.ShowInTree(Tree, n1);
end;

procedure TDataSet.View();
begin
  NotSuported('TDataSet.View()');
end;

procedure TDataset.ViewEvent(Sender: TObject);
begin
  View();
end;

function TDataSet.getFullName(): string;
begin
  self.NotSuported('getFullName()');
  result := '';
end;

procedure TDataSet.ShowExtraProperties(Tree: TTreeView; RootNode: TTreeNode);
begin
  // Nada
end;

{ TTable }

constructor TTable.Create(DB: TDatabase; const Name: string);
begin
  inherited Create(DB);
  FName := Name;
end;

function TTable.ObterTextoDoNo: string;
begin
  result := FName;
end;

function TTable.getFields(): TFields;
begin
  if FFields = nil then LoadFields();
  Result := FFields;
end;

function TTable.getFullName(): string;
begin
  result := FName;
end;

function TTable.getSQLFullName: string;
begin
  result := getFullName();
end;

procedure TTable.ObterAcoesIndividuais(Acoes: TActionList);
begin
  inherited ObterAcoesIndividuais(Acoes);
  CreateAction(Acoes, nil, 'Visualizar', false, ActionManager.Table_View, self);
end;

{ TADO_Table }

function TADO_Table.getDB: TADO_Database;
begin
  result := TADO_Database(FDB);
end;

procedure TADO_Table.LoadFields();
var i: Integer;
    t: TADODataSet;
begin
  FFields := TFields.Create();

  t := TADODataSet.Create(nil);
  t.Connection := getDB().Connection;
  t.CommandType := ADODB.cmdTableDirect;
  t.CommandText := FName;
  t.MaxRecords := 1;
  try
    t.Open();
    for i := 0 to t.FieldCount-1 do
      FFields.Add( TField.Create(t.Fields[i].FieldName, t.Fields[i].DataType, self) );
  finally
    t.Free();
  end;
end;

procedure TADO_Table.View();
var t: TADODataSet;
begin
(*
  t := TADODataSet.Create(nil);
  t.Connection := getDB().Connection;
  t.CommandType := ADODB.cmdTableDirect;
  t.CommandText := FName;
  try
    t.Open();
    FDB.ShowDataset(FDB.Name + '.' + ObterTextoDoNo(), t);
  except
    on E: Exception do
       begin
       Applic.Messages.ShowError(E.Message);
       t.Free();
       end;
  end;
*)
  t := TADODataSet(FDB.idbc_OpenTable(FName));
  FDB.ShowDataset(FDB.Name + '.' + ObterTextoDoNo(), t);
end;

{ TTables }

procedure TTables.Add(item: TTable);
begin
  FList.Add(item);
end;

procedure TTables.Clear();
begin
  FList.Clear();
end;

constructor TTables.Create();
begin
  inherited Create();
  FList := TObjectList.Create(true);
end;

destructor TTables.Destroy();
begin
  FList.Free();
  inherited;
end;

function TTables.getCount(): integer;
begin
  result := FList.Count;
end;

function TTables.ObterIndiceDaImagem(): integer;
begin
  result := iiTables;
end;

function TTables.getItem(i: integer): TTable;
begin
  result := TTable(FList[i]);
end;

// root
//   Tabelas
//     Tab 1
//     Tab 2
//     Tab 3
procedure TTables.ShowInTree(Tree: TTreeView; root: TTreeNode);
var i: Integer;
    n1, n2: TTreeNode;
begin
  n1 := Tree.Items.AddChildObject(root, 'Tabelas', self);
  for i := 0 to getCount()-1 do
    begin
    n2 := Tree.Items.AddChildObject(n1, getItem(i).Name, getItem(i));

    // Fields - Deixa para o evento de expansão o preenchimento dos campos
    Tree.Items.AddChildObject(n2, 'TableFields', n2.Data);
    end;
end;

function TTables.ObterTextoDoNo(): string;
begin
  result := 'Tabelas';
end;

{ TDatabase }

// Tudo feito aqui deve estar também em "LoadState" <<<<<<<<<<<<<<<<<<<<<<<<
constructor TDatabase.Create(const aName, aType: string);
begin
  inherited Create();
  FName := aName;
  FType := aType;
  FTables := TTables.Create();
  //FSQLs := TSQLs.Create(self);
  //FPlugins := TPlugins.Create(false);
end;

procedure TDatabase.Disconnect();
begin
  Applic.Databases.Disconnect(self);
end;

procedure TDatabase.DisconnectEvent(Sender: TObject);
begin
  Disconnect();
end;

destructor TDatabase.Destroy();
begin
  //FPlugins.Free();
  FTables.Free();
  //FSQLs.Free();
  inherited Destroy();
end;

function TDatabase.ObterTextoDoNo(): string;
begin
  result := FName + ' (' + FType + ')';
end;

function TDatabase.ObterIndiceDaImagem(): integer;
begin
  result := iiDatabase;
end;

procedure TDatabase.Init();
begin
  FTables.Clear();
  LoadTables();
  LoadStoredProcs();
end;

function TDatabase.ExecuteSQL(const SQL: string; out ds: DB.TDataSet; out rowsAffected: integer): string;
var Error: string;
begin
  ds := nil;
  if IsResultSetSQL(SQL) then
     begin
     ds := OpenSQL(SQL, Error);
     if Error = '' then
        begin
        ShowDataset('SQL: ' + FName, ds);
        result := '';
        rowsAffected := -1;
        end
     else
        result := Error;
     end
  else
     result := ExecSQL(SQL, rowsAffected);
end;

procedure TDatabase.ExecuteSQLEvent(Sender: TObject);
begin
{
  with TfoSQLEditor.Create(self) do
    Show();
}    
end;

procedure TDatabase.ShowDataset(const Caption: string; Dataset: DB.TDataset);
begin
  TfoViewDataset.Create(Caption, Dataset);
end;

procedure TDatabase.ExportDataset(DS: DB.TDataset);
begin
  if DS <> nil then
     begin

     end
  else
     Applic.Messages.ShowError('Invalid dataset');
end;

procedure TDatabase.LoadStoredProcs();
begin
  // Nada
end;

function TDatabase.OpenSQL(const SQL: string; var Error: string): DB.TDataSet;
begin
  NotSuported('OpenSQL');
end;

function TDatabase.ExecSQL(const SQL: string; var rowsAffected: integer): string;
begin
  NotSuported('ExecSQL');
end;

function TDatabase.ResultSetSQLError(const SQL: string): string;
begin
  result := 'O Comando SQL:'#13 + SQL + #13 +
            'não retorna um conjunto de registros.';
end;

constructor TDatabase.LoadState(iniFile: TIni; Section: string);
var i: Integer;
    s: string;
    //p: TCommomPlugin;
begin
  FTables := TTables.Create();
  //FSQLs := TSQLs.Create(self);
  //FPlugins := TPlugins.Create(false);

  FName := iniFile.ReadString(Section, 'Name', '');
  FType := iniFile.ReadString(Section, 'Type', '');

(*
  // Plugins
  i := iniFile.ReadInteger(Section, 'Plugins', -1);
  for i := 1 to i do
    begin
    s := iniFile.ReadString(Section, 'Plugin ' + toString(i), '');
    if s <> '' then
       begin
       p := Applic.Plugins.FindByDisplayText(s);
       if p <> nil then
          FPlugins.Add(p);
       end;
    end;
*)    
end;

procedure TDatabase.SaveState(iniFile: TIni; Section: string);
var i: Integer;
begin
  iniFile.WriteString(Section, 'DBType', ClassName);
  iniFile.WriteString(Section, 'Name', FName);
  iniFile.WriteString(Section, 'Type', FType);
(*
  // Plugins
  iniFile.WriteInteger(Section, 'Plugins', FPlugins.Count);
  for i := 0 to FPlugins.Count-1 do
    iniFile.WriteString(Section, 'Plugin ' + toString(i+1), FPlugins[i].DisplayText);
*)    
end;

procedure TDatabase.idbc_Append(t: TObject);
begin
  DB.TDataset(t).Append();
end;

procedure TDatabase.idbc_CloseTable(t: TObject);
begin
  DB.TDataset(t).Close();
end;

procedure TDatabase.idbc_Edit(t: TObject);
begin
  DB.TDataset(t).Edit();
end;

function TDatabase.idbc_ExecSQL(const SQL: string): string;
var rowsAffected: integer;
begin
  result := self.ExecSQL(SQL, rowsAffected);
end;

procedure TDatabase.idbc_FreeTable(var t: TObject);
begin
  FreeAndNil(t);
end;

function TDatabase.idbc_GetExtraInfo(const parameter: string): string;
begin

end;

procedure TDatabase.idbc_Insert(t: TObject);
begin
  DB.TDataset(t).Insert();
end;

function TDatabase.idbc_OpenTable(const Tablename: string): TObject;
begin
  NotSuported('idbc_OpenTable');
end;

procedure TDatabase.idbc_Post(t: TObject);
begin
  DB.TDataset(t).Post();
end;

procedure TDatabase.idbc_SetFieldAsFloat(t: TObject; fi: integer; const value: real);
begin
  DB.TDataset(t).Fields[fi].AsFloat := value;
end;

procedure TDatabase.idbc_SetFieldAsInteger(t: TObject; fi: integer; const value: integer);
begin
  DB.TDataset(t).Fields[fi].AsInteger := value;
end;

procedure TDatabase.idbc_SetFieldAsBoolean(t: TObject; fi: integer; const value: boolean);
begin
  DB.TDataset(t).Fields[fi].AsBoolean := value;
end;

procedure TDatabase.idbc_SetFieldAsString(t: TObject; fi: integer; const value: string);
begin
  DB.TDataset(t).Fields[fi].AsString := value;
end;

procedure TDatabase.idbc_SetFieldAsDateTime(t: TObject; fi: integer; const value: TDateTime);
begin
  DB.TDataset(t).Fields[fi].AsDateTime := value;
end;
{
procedure TDatabase.ImportEvent(Sender: TObject);
begin
  with TfoDataImport.Create(self) do
    begin
    ShowModal();
    Release();
    end;
end;
}
{
procedure TDatabase.RegisterPluginEvent(Sender: TObject);
begin
  with TfoRegisterPlugin.Create(self) do
    begin
    ShowModal();
    Release();
    end;
end;
}
{
procedure TDatabase.ExportEvent(Sender: TObject);
begin
  with TfoDataExport.Create(self) do
    begin
    ShowModal();
    Release();
    end;
end;
}
function TDatabase.idbc_BOF(t: TObject): boolean;
begin
  result := DB.TDataset(t).BOF;
end;

function TDatabase.idbc_EOF(t: TObject): boolean;
begin
  result := DB.TDataset(t).EOF;
end;

procedure TDatabase.idbc_First(t: TObject);
begin
  DB.TDataset(t).First;
end;

function TDatabase.idbc_GetFieldAsBoolean(t: TObject; fi: integer): boolean;
begin
  result := DB.TDataset(t).Fields[fi].AsBoolean;
end;

function TDatabase.idbc_GetFieldAsDateTime(t: TObject; fi: integer): TDateTime;
begin
  result := DB.TDataset(t).Fields[fi].AsDateTime;
end;

function TDatabase.idbc_GetFieldAsFloat(t: TObject; fi: integer): real;
begin
  result := DB.TDataset(t).Fields[fi].AsFloat;
end;

function TDatabase.idbc_GetFieldAsInteger(t: TObject; fi: integer): integer;
begin
  result := DB.TDataset(t).Fields[fi].AsInteger;
end;

function TDatabase.idbc_FieldIsNull(t: TObject; fi: integer): boolean;
begin
  result := DB.TDataset(t).Fields[fi].IsNull;
end;

function TDatabase.idbc_GetFieldAsString(t: TObject; fi: integer): string;
begin
  result := DB.TDataset(t).Fields[fi].AsString;
end;

procedure TDatabase.idbc_Last(t: TObject);
begin
  DB.TDataset(t).Last();
end;

procedure TDatabase.idbc_Next(t: TObject);
begin
  DB.TDataset(t).Next();
end;

procedure TDatabase.idbc_Prior(t: TObject);
begin
  DB.TDataset(t).Prior();
end;

function TDatabase.idbc_GetFieldName(t: TObject; fi: integer): string;
begin
  result := DB.TDataset(t).Fields[fi].FieldName;
end;

function TDatabase.idbc_GetFieldType(t: TObject; fi: integer): byte;
begin
  result := ord(DB.TDataset(t).Fields[fi].DataType);
end;

function TDatabase.idbc_GetFieldIndex(t: TObject; const Name: string): integer;
var f: DB.TField;
begin
  try
    f := DB.TDataset(t).Fields.FieldByName(Name);
    if f <> nil then
       result := f.Index
    else
       result := -1;
  except
    result := -1;
  end;
end;

function TDatabase.idbc_GetFieldCount(t: TObject): integer;
begin
  result := DB.TDataset(t).FieldCount;
end;

function TDatabase.idbc_GetRecordCount(t: TObject): integer;
begin
  result := DB.TDataset(t).RecordCount;
end;

{
procedure TDatabase.ShowGenericGraphicsEvent(Sender: TObject);
begin
  with TfoGraphics.Create(self) do
    begin
    ShowModal();
    Release();
    end;
end;
}

function TDatabase.idbc_GetDatabaseName(): string;
begin
  result := self.FName;
end;

procedure TDatabase.UpdateTree(Tree: TTreeView);
begin
  FNode.DeleteChildren();
  self.ShowInTree(Tree, FNode);
end;

procedure TDatabase.ShowInTree(Tree: TTreeView; Root: TTreeNode);
begin
  if Root <> nil then
     FNode := Root;
end;

procedure TDatabase.ObterAcoesIndividuais(Acoes: TActionList);
begin
  inherited ObterAcoesIndividuais(Acoes);
  CreateAction(Acoes, nil, 'Desconectar', false, ActionManager.Database_Disconnect, self);
end;

{ TADO_Database }

const cConnectionString = 'Provider=Microsoft.Jet.OLEDB.4.0;' +
                          'Data Source=%s;' +
                          'Persist Security Info=False';

constructor TADO_Database.Create(const aName, aType, aFilename: string);
begin
  inherited Create(aName, aType);
  FFilename := aFilename;
  FConn := TADOConnection.Create(nil);
  FConn.ConnectionString := Format(cConnectionString, [FFilename]);
  FConn.Open();
  Init();
  
end;

constructor TADO_Database.LoadState(iniFile: TIni; Section: string);
begin
  inherited LoadState(iniFile, Section);
  FFilename := iniFile.ReadString(Section, 'Filename', '');
  FConn := TADOConnection.Create(nil);
  FConn.ConnectionString := Format(cConnectionString, [FFilename]);
  FConn.Open();
  Init();
end;

procedure TADO_Database.SaveState(iniFile: TIni; Section: string);
begin
  inherited SaveState(iniFile, Section);
  iniFile.WriteString(Section, 'Filename', FFilename);
end;

destructor TADO_Database.Destroy();
begin
  FSP.Free();
  FConn.Free();
  inherited;
end;

function TADO_Database.ExecSQL(const SQL: string; var rowsAffected: integer): string;
var q: TADOQuery;
begin
  q := TADOQuery.Create(nil);
  q.Connection := FConn;
  q.SQL.Text := SQL;
  try
    try
      rowsAffected := q.ExecSQL();
      result := '';
    except
      on E: Exception do
         begin
         result := E.Message;
         rowsAffected := 0;
         end;
    end
  finally
    q.Free()
  end;
end;

function TADO_Database.OpenSQL(const SQL: string; var Error: string): DB.TDataSet;
var q: TADOQuery;
    b: boolean;
begin
  q := TADOQuery.Create(nil);
  q.Connection := FConn;
  q.SQL.Text := SQL;

  b := true;
  try
    try
      if IsResultSetSQL(SQL) then
         begin
         q.Open();
         b := false;
         Error := '';
         end
      else
         Error := ResultSetSQLError(SQL);
    except
      on E: Exception do
         Error := E.Message;
    end
  finally
    if b then FreeAndNil(q);
    result := q;
  end;
end;

procedure TADO_Database.LoadStoredProcs();
begin
  FSP := TStringList.Create();
  FConn.GetProcedureNames(FSP);
end;

procedure TADO_Database.LoadTables();
var Tabelas, TabelasPadrao: TStrings;
    i, j: integer;
    Nome, TableClassName: string;
    t: TTable;
    TC: TTableClass;
begin
  Tabelas := TStringList.Create();
  FConn.GetTableNames(Tabelas, false);

  // Compara as tabelas com os padroes existentes para ADO
  get_STD_Tables(Tabelas, TabelasPadrao, TableClassName);

  // Se o padao for encontrado retorna o tipo de classe a ser utilizado
  // para a criacao das tabelas
  if TabelasPadrao <> nil then
     TC := TTableClass(Applic.Databases.getClass(TableClassName));

  for i := 0 to Tabelas.Count-1 do
    begin
    Nome := Tabelas[i];

    if (TabelasPadrao = nil) or (TC = nil) or (TabelasPadrao.IndexOf(Nome) = -1) then
       // Cria a tabela padrao
       t := TADO_Table.Create(self, Nome)
    else
       // Cria a tabela especifica dependendo do padrao encontrado
       t := TC.Create(self, Nome);

    FTables.Add(t);
    end;
    
  Tabelas.Free();
  TabelasPadrao.Free();
end;

// root
//   Tables
//   SQLs
//   Procedimentos
//     Proc 1
//     Proc n
procedure TADO_Database.ShowInTree(Tree: TTreeView; Root: TTreeNode);
var i: Integer;
    n1, n2: TTreeNode;
begin
  inherited ShowInTree(Tree, Root);

  FTables.ShowInTree(Tree, Root);
  //FSQLs.ShowInTree(Tree, Root);

  // Stored Procs
  if FSP.Count > 0 then
     begin
     n1 := Tree.Items.AddChild(Root, 'Procedimentos');
     TreeViewUtils.SetImageIndex(n1, iiCloseFolder);
     for i := 0 to FSP.Count-1 do
       begin
       n2 := Tree.Items.AddChild(n1, FSP[i]);
       TreeViewUtils.SetImageIndex(n2, iiScript);
       end;
    end;
end;

procedure TADO_Database.get_STD_Tables(Tables: TStrings; out stdTables: TStrings; out TableClassName: string);
var sl: TStrings;
    i, j: integer;
    std: boolean;
    s: string;
begin
  std := false;
  stdTables := nil;

  sl := SysUtilsEx.LoadTextFile(Applic.AppDir + 'Config\BDs Padrao ADO.txt');

  // Cada linha do arquivo aponta para um outro arquivo com o padrao do banco de dados
  for i := 0 to sl.Count-1 do
    begin
    stdTables.Free();
    stdTables := SysUtilsEx.LoadTextFile(Applic.AppDir + 'Config\' + sl[i] + '.txt');
    if stdTables.Count > 1 then
       begin
       std := true;
       TableClassName := stdTables[0];

       // Verifica se as tabelas passadas batem com algum padrao
       // "std" saira "true" se um padrao for encontrado
       for j := 1 to stdTables.Count-1 do
         begin
         s := stdTables[j];

         // Este recurso eh utilizado para que somente as tabelas que nao
         // estejam entre paranteses sejam consideradas como tabelas especiais no
         // chamador desta rotina.
         if (s <> '') and (s[1] = '(') then
            s := SysUtilsEx.SubString(s, '(', ')');

         if Tables.IndexOf(s) = -1 then
            begin
            std := false;
            stdTables.Delete(0);
            break;
            end;
         end;

       // Sai do laco de um padro foi encontrado
       if std then break;
       end;
    end;

  sl.Free();

  // Limpa os parametros se nenhum padrao for encontardo
  if not std then
     begin
     FreeAndNil(stdTables);
     TableClassName := '';
     end;
end;

function TADO_Database.idbc_OpenTable(const Tablename: string): TObject;
var t: TADODataSet;
begin
  t := TADODataSet.Create(nil);
  t.Connection := self.Connection;
  t.CommandType := ADODB.cmdTableDirect;
  t.CommandText := Tablename;
  try
    t.Open();
    result := t;
  except
    on E: Exception do
       begin
       result := nil;
       Applic.Messages.ShowError(E.Message);
       t.Free();
       end;
  end;
end;

{ TDatabases }

procedure TDatabases.Add(DB: TDatabase);
begin
  FList.Add(DB);
end;

constructor TDatabases.Create();
begin
  inherited Create();
  FList := TObjectList.Create(true);
  FClasses := TStringList.Create();
end;

function TDatabases.CreateConnection(const DBType: string): TDatabase;
begin
  StartWait();
  try
  {
    if (CompareText(DBType, 'Paradox\DBase') = 0) then
       result := createBDE_Connection(DBType) else

    if (CompareText(DBType, 'MySQL-3.23') = 0) then
       result := createZEOS_Connection(DBType) else
  }
    if (CompareText(DBType, 'Access') = 0) then
       result := createAccess_Connection(DBType);
  finally
    StopWait();
  end;
end;

procedure TDatabases.Disconnect(DB: TDatabase);
begin
  Applic.RemoveObject(DB);
  FList.Remove(DB);
end;

destructor TDatabases.Destroy();
begin
  FClasses.Free();
  FList.Free();
  inherited Destroy();
end;

function TDatabases.getCount(): integer;
begin
  Result := FList.Count;
end;

function TDatabases.getItem(i: integer): TDatabase;
begin
  Result := TDatabase(FList[i]);
end;

{
function TDatabases.createBDE_Connection(const DBType: string): TDatabase;
begin
  result := nil;
  with TfoParadoxDBase_Connection.Create(nil) do
    begin
    if ShowModal = mrOK then
       result := TBDE_Database.Create(ID, DBType, Folder);
    Release();
    end;
end;
}

function TDatabases.createACCESS_Connection(const DBType: string): TDatabase;
begin
  result := nil;
  with TfoAccess_Connection.Create(nil) do
    begin
    if ShowModal = mrOK then
       result := TADO_Database.Create(ID, DBType, Filename);
    Release();
    end;
end;

{
function TDatabases.createZEOS_Connection(const DBType: string): TDatabase;
begin
  result := nil;
  with TfoZEOS_Connection.Create(DBType) do
    begin
    if ShowModal = mrOK then
       result := TZEOS_Database.Create(ID, DBType, HostName);
    Release();
    end;
end;
}

procedure TDatabases.LoadState(iniFile: TIni);
var i: Integer;
    s, s2: string;
    DBClass: TDatabaseClass;
    DB: TDatabase;
begin
  s := 'DATABASES';
  i := iniFile.ReadInteger(s, 'count', -1);
  for i := 1 to i do
    begin
    s := 'DATABASE ' + toString(i);
    s2 := iniFile.ReadString(s, 'Name', '');
    if (s2 <> '') and
       (MessageDLG('Restaurar conecção para "' + s2 + '" ?',
                   mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
       begin
       DBClass := TDatabaseClass(getClass(iniFile.ReadString(s, 'DBType', '')));
       if DBClass <> nil then
          try
            DB := DBClass.LoadState(iniFile, s);
            Applic.AddDatabase(DB);
          except
            Continue;
          end;
       end;
    end;
end;

procedure TDatabases.SaveState(iniFile: TIni);
var i: Integer;
    s: string;
begin
  s := 'DATABASES';
  iniFile.WriteInteger(s, 'count', self.Count);
  for i := 0 to self.Count-1 do
    begin
    s := 'DATABASE ' + toString(i+1);
    self.getItem(i).SaveState(iniFile, s);
    end;
end;

function TDatabases.getClass(const ClassName: string): TClass;
var i: Integer;
begin
  i := FClasses.IndexOf(ClassName);
  if i > -1 then
     result := TClass(FClasses.Objects[i])
  else
     result := nil;
end;

procedure TDatabases.RegisterClass(aClass: TClass);
begin
  FClasses.AddObject(aClass.ClassName, pointer(aClass));
end;

{ TADO_Table_Hidro_Postos }

destructor TADO_Table_Hidro_Postos.Destroy();
begin
  FPostos.Free();
  inherited Destroy();
end;

procedure TADO_Table_Hidro_Postos.ShowExtraProperties(Tree: TTreeView; RootNode: TTreeNode);
var n1, n2, n3: TTreeNode;
    t: TObject;
    TabNome: string;
    d: TDateTime;
    p: TADO_Hidro_Posto;
begin
  n1 := Tree.Items.AddChild(RootNode, 'Postos');
  TreeViewUtils.SetImageIndex(n1, iiCloseFolder);

  Applic.ShowMessage('Procurando postos ...');

  // Pesquisa na tabela correta os postos de cada tabela
  t := Database.idbc_OpenTable('Series_' + self.Name);
  if t <> nil then
     begin
     Database.idbc_First(t);
     while not Database.idbc_EOF(t) do
       begin
       d := Database.idbc_GetFieldAsDateTime(t, 4);       // Data Final
       p := TADO_Hidro_Posto.Create(
                Database.idbc_GetFieldAsString(t, 1),     // Nome
                Database.idbc_GetFieldAsInteger(t, 2),    // Nivel de consistencia
                Database.idbc_GetFieldAsDateTime(t, 3),   // Data Inicial
                d + DateUtils.DaysInMonth(d) - 1,         // Data Final
                self.Name,                                // Tabela
                self.Database);                           // Banco de Dados

       // Guarda os postos para que eles sejam destruidos quando o Banco de Dados
       // for desconectado.
       if FPostos = nil then FPostos := TObjectList.Create(true);
       FPostos.Add(p);

       // Mostra o posto na árvore

       n2 := Tree.Items.AddChildObject(n1, p.Nome, p);
       TreeViewUtils.SetImageIndex(n2, iiItem);

       // Mostra algumas informacoes extras como nós filhos do Posto ...

       n3 := Tree.Items.AddChild(n2, 'Data Inicial: ' + DateToStr(p.DataInicial));
       TreeViewUtils.SetImageIndex(n3, iiInformation);

       n3 := Tree.Items.AddChild(n2, 'Data Final: ' + DateToStr(p.DataFinal));
       TreeViewUtils.SetImageIndex(n3, iiInformation);

       Database.idbc_Next(t);
       end;
     Database.idbc_CloseTable(t);
     end;

   Applic.ShowMessage('');  
end;

{ TADO_Hidro_Posto }

constructor TADO_Hidro_Posto.Create(Nome: string; NC: integer; DI, DF: TDateTime; TabelaPai: string; DB: TDatabase);
begin
  inherited Create();
  FNome := Nome;
  FCod := toInt(FNome);
  FNC := NC;
  FDI := DI;
  FDF := DF;
  FTab := TabelaPai;
  FDB := DB;
end;

procedure TADO_Hidro_Posto.ObterAcoesColetivas(Acoes: TActionList);
begin
  inherited ObterAcoesColetivas(Acoes);
  CreateAction(Acoes, nil, 'Converter para o Proceda ...' , false, ActionManager.ADO_Hidro_Posto_CP, self);
end;

function TADO_Hidro_Posto.ObterIndiceDaImagem(): integer;
begin
  result := iiField;
end;

function TADO_Hidro_Posto.ObterTextoDoNo(): string;
begin
  result := FNome + ' - NC: ' + toString(FNC) + ')';
end;

end.
