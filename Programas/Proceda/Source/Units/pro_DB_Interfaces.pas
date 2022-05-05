unit pro_DB_Interfaces;

interface

type

  // Interface para controle de um banco de dados
  IDBControl = interface
    ['{6233B6E0-1C89-4CAF-99E8-EF88900A4E3E}']

    // Retorna o nome do banco de dados
    function idbc_GetDatabaseName(): string;

    // Executa um comando SQL
    function idbc_ExecSQL (const SQL: string): string;

    // Abre uma tabela
    function idbc_OpenTable (const Tablename: string): TObject;

    // Fecha a tabela
    procedure idbc_CloseTable (t: TObject);

    // Libera o objeto tabela
    procedure idbc_FreeTable (var t: TObject);

    // Retorna informacoes extras
    function idbc_GetExtraInfo (const parameter: string): string;

    // Coloca a tabela em modo de adicao de registro
    procedure idbc_Append (t: TObject);

    // Coloca a tabela em modo de insercao de registro
    procedure idbc_Insert (t: TObject);

    // Coloca a tabela em modo de edicao de registro
    procedure idbc_Edit (t: TObject);

    // Atualiza a tabela
    procedure idbc_Post (t: TObject);

    // Vai para o primeiro registro da tabela
    procedure idbc_First (t: TObject);

    // Vai para o último registro da tabela
    procedure idbc_Last (t: TObject);

    // Vai para o registro anterior da tabela
    procedure idbc_Prior (t: TObject);

    // Vai para o proximo registro da tabela
    procedure idbc_Next (t: TObject);

    // Indica o final da tabela
    function idbc_EOF (t: TObject): boolean;

    // Indica o inicio da tabela
    function idbc_BOF (t: TObject): boolean;

    // Retorna o número de registros de uma tabela
    function idbc_GetRecordCount (t: TObject): integer;

    // Retorna o indice do campo ou -1 se não encontrado
    function idbc_GetFieldIndex (t: TObject; const Name: string): integer;

    // Retorna o número de campos de uma tabela
    function idbc_GetFieldCount (t: TObject): integer;

    // Obtem o tipo de um campo
    function idbc_GetFieldType (t: TObject; fi: integer): byte;

    // Obtem o nome de um campo
    function idbc_GetFieldName (t: TObject; fi: integer): string;

    // Estabele os valores dos campos da tabela
    procedure idbc_SetFieldAsString   (t: TObject; fi: integer; const value: string);
    procedure idbc_SetFieldAsFloat    (t: TObject; fi: integer; const value: real);
    procedure idbc_SetFieldAsInteger  (t: TObject; fi: integer; const value: integer);
    procedure idbc_SetFieldAsBoolean  (t: TObject; fi: integer; const value: boolean);
    procedure idbc_SetFieldAsDateTime (t: TObject; fi: integer; const value: TDateTime);

    // Obtem os valores dos campos da tabela
    function idbc_FieldIsNull        (t: TObject; fi: integer): boolean;
    function idbc_GetFieldAsString   (t: TObject; fi: integer): string;
    function idbc_GetFieldAsFloat    (t: TObject; fi: integer): real;
    function idbc_GetFieldAsInteger  (t: TObject; fi: integer): integer;
    function idbc_GetFieldAsBoolean  (t: TObject; fi: integer): boolean;
    function idbc_GetFieldAsDateTime (t: TObject; fi: integer): TDateTime;
  end;

  // Interface para controle de um processo
  IProcessControl = interface
    ['{F444178C-0C7A-414B-B96F-BD36081847C7}']
    procedure ipc_ShowMessage(const aMessage: string);
    procedure ipc_ShowError(const aError: string);
    procedure ipc_setMaxProgress(const aMax: integer);
    procedure ipc_setMinProgress(const aMin: integer);
    procedure ipc_setProgress(const aProgress: integer);
  end;

implementation

end.
