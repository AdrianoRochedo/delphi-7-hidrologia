unit pro_Plugins;

interface
uses Windows, Classes, Contnrs, SysUtils, Forms,
     SysUtilsEx,
     FileUtils,
     pro_Interfaces;

const
  cDataImport = 'Data Import';     

type
  TProc_getPluginType              = function: string;
  TProc_getName                    = function: string;
  TProc_getFileFilter              = function: string;
  TProc_getDescription             = function: string;
  TProc_getVersion                 = function: string;
  TProc_getProperties              = procedure (Props: TStrings);
  TProc_setProperties              = procedure (Props: TStrings);
  TProc_setProcessControlInterface = procedure (const intf: IProcessControl);
  TProc_Import                     = function  (const Filename: string): boolean;

  TPluginType =
    (ptUnknown, ptAll, ptDataImport, ptDataExport, ptGraphics);

  TCommomPlugin = class
  private
    FFN: string;
    FDT: string;
    FPT: TPluginType;
    FDesc: string;
    FFF: string;
  protected
    destructor Destroy(); override;
  public
    Handle                     : THandle;
    getPluginType              : TProc_getPluginType;
    getName                    : TProc_getName;
    getFileFilter              : TProc_getFileFilter;
    getDescription             : TProc_getDescription;
    getVersion                 : TProc_getVersion;
    getProperties              : TProc_getProperties;
    setProperties              : TProc_setProperties;
    setProcessControlInterface : TProc_setProcessControlInterface;

    constructor Create();

    // Le a DLL e os enderecos se a DLL for valida
    function Load(): boolean;

    // Le os enderecos
    procedure LoadProcs(h: THandle); virtual;

    // Libera a DLL se nao existir mais objetos dependentes dela
    procedure Release();

    property PluginType  : TPluginType read FPT;
    property Filename    : string      read FFN;
    property DisplayText : string      read FDT;
    property Description : string      read FDesc;
    property FileFilter  : string      read FFF;
  end;

  TImportPlugin = class (TCommomPlugin)
  public
    Import : TProc_Import;
    constructor Create();
    procedure LoadProcs(h: THandle); override;
  end;

  // Representa todos os plugins encontrados para esta aplicacao
  // Os plugins soh sao carregados quando necessarios e descarregados
  // quando nao sao mais necessarios.
  TPlugins = class
  private
    FList: TObjectList;
    function getCount: integer;
    function getItem(i: integer): TCommomPlugin;
    function LoadDLL(const Filename: string; var p: TCommomPlugin): boolean;
  protected
    destructor Destroy(); override;
  public
    constructor Create(OwnsObjects: Boolean);

    // Le as informaçoes de cada plugin encontrado nos caminhos apropriados
    procedure Load();

    // Adiciona uma referencia a um Plugin
    procedure Add(Item: TCommomPlugin);

    // Remove uma referencia a um plugin
    procedure Remove(Item: TCommomPlugin);

    // Retorna o plugin dado um texto senão retorna nil
    function FindByDisplayText(const aText: string): TCommomPlugin;

    // Mostra os plugins em um TStrings
    procedure Show(aPlace: TStrings; aType: TPluginType);

    property Count : integer read getCount;
    property Item[i: integer] : TCommomPlugin read getItem; default;
  end;

implementation
uses ch_Tipos;

{ TPlugins }

constructor TPlugins.Create(OwnsObjects: Boolean);
begin
  inherited Create();
  FList := TObjectList.Create(OwnsObjects);
end;

destructor TPlugins.Destroy();
begin
  FList.Free();
  inherited Destroy();
end;

procedure TPlugins.Add(Item: TCommomPlugin);
begin
  FList.Add(Item);
end;

function TPlugins.getCount(): integer;
begin
  Result := FList.Count;
end;

function TPlugins.getItem(i: integer): TCommomPlugin;
begin
  Result := TCommomPlugin(FList[i]);
end;

function TPlugins.LoadDLL(const Filename: string; var p: TCommomPlugin): boolean;
var h: THandle;
    proc: TProc_getPluginType;
begin
  p := nil;
  result := false;

  h := LoadLibrary(PChar(Filename));
  if h <> 0 then
     try
       proc := GetProcAddress(h, 'getPluginType');
       if Assigned(proc) then
          begin
          // Obtem o tipo do Plugin e cria a instancia correta
          if proc() = cDataImport then
             p := TImportPlugin.Create()
          else
             begin
             p := nil;
             Exit;
             end;

          // Guarda o nome do arquivo
          p.FFN := Filename;

          // Obtem as rotinas para leitura de algumas propriedads
          p.LoadProcs(h);

          // Obtem sua Descrição
          // Estas propriedades nao mudarao enquanto a aplicacao estiver rodando
          p.FDT := p.getName() + ' ' + p.getVersion();
          p.FDesc := p.getDescription();

          // Obtem o filtro para seus arquivos
          p.FFF := p.getFileFilter();

          result := true;
          end;
     finally
       // A DLL eh liberada ate ser necessaria
       FreeLibrary(h);
       if p <> nil then p.Handle := 0;
     end;
end;

procedure TPlugins.Load();
var i: integer;
    DLLs: TStrings;
    p: TCommomPlugin;
begin
  FList.Clear();
  DLLs := FileUtils.EnumerateFiles(['.DLL'], Applic.AppDir + 'Plugins', true);
  for i := 0 to DLLs.Count-1 do
    if LoadDLL(DLLs[i], p) then
       Add(p);
  DLLs.Free();
end;

procedure TPlugins.Show(aPlace: TStrings; aType: TPluginType);
var i: Integer;
    p: TCommomPlugin;
begin
  for i := 0 to self.Count-1 do
    begin
    p := getItem(i);
    if (aType = ptAll) or (p.PluginType = aType) then
       aPlace.AddObject(p.DisplayText, p);
    end;
end;

procedure TPlugins.Remove(Item: TCommomPlugin);
begin
  FList.Remove(Item);
end;

function TPlugins.FindByDisplayText(const aText: string): TCommomPlugin;
var i: Integer;
begin
  result := nil;
  for i := 0 to self.getCount()-1 do
    if self.getItem(i).DisplayText = aText then
       begin
       result := self.getItem(i);
       break;
       end;
end;

{ TCommomPlugin }

constructor TCommomPlugin.Create();
begin
  inherited Create();
end;

destructor TCommomPlugin.Destroy();
begin
  Release();
  inherited;
end;

procedure TCommomPlugin.Release();
begin
  if (Handle <> 0) then
     begin
     Windows.FreeLibrary(Handle);
     Handle := 0;
     end;
end;

procedure TCommomPlugin.LoadProcs(h: THandle);
begin
  Handle := h;

  if Handle <> 0 then
     begin
     getPluginType :=
       GetProcAddress(Handle, 'getPluginType');

     getName :=
       GetProcAddress(Handle, 'getName');

     getFileFilter :=
       GetProcAddress(Handle, 'getFileFilter');

     getDescription :=
       GetProcAddress(Handle, 'getDescription');

     getVersion :=
       GetProcAddress(Handle, 'getVersion');

     getProperties :=
       GetProcAddress(Handle, 'getProperties');

     setProperties :=
       GetProcAddress(Handle, 'setProperties');

     setProcessControlInterface :=
       GetProcAddress(Handle, 'setProcessControlInterface');
     end;
end;

function TCommomPlugin.Load(): boolean;
var h: THandle;
begin
  if Handle = 0 then
     if FileExists(FFN) then
        begin
        h := Windows.LoadLibrary( pChar(FFN) );
        if h <> 0 then
           begin
           LoadProcs(h);
           result := true;
           end
        else
           result := false;
        end
     else
        result := false
  else
     result := true;
end;

{ TImportPlugin }

constructor TImportPlugin.Create();
begin
  inherited Create();
  FPT := ptDataImport;
end;

procedure TImportPlugin.LoadProcs(h: THandle);
begin
  inherited LoadProcs (h);
  Import := GetProcAddress(Handle, 'Import');
end;

end.
