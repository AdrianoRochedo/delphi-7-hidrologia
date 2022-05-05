unit pr_Plugins;

interface
uses Classes, SysUtils, SysUtilsEx, Plugin, Contnrs, Forms;

type
  TPluginList = class
  private
    FList: TObjectList;
    FPaths: TStrings;
    FHandleList: TList;
    FActiveObjFactoryIndex: integer;
    function getCount: integer;
    function getItem(i: integer): TPlugin;
    procedure LoadPlugins(const Path: string);
    procedure LoadPlugin(const Filename: string);
    function getActiveFactory: IObjectFactory;
  public
    constructor Create();
    destructor Destroy(); override;

    procedure AddPath(const Path: string);
    procedure Add(Item: TPlugin);

    procedure Load();
    procedure UnLoad();
    procedure ReLoad();

    function getFactoryByName(const FactoryName: string): IObjectFactory;

    property Count : integer read getCount;
    property Item[i: integer] : TPlugin read getItem;

    property ActiveObjFactoryIndex : integer read  FActiveObjFactoryIndex
                                             write FActiveObjFactoryIndex;

    property ActiveFactory : IObjectFactory read getActiveFactory;
  end;

implementation
uses Windows, FileUtils;

{ TLisTPlugin }

constructor TPluginList.Create();
begin
  inherited Create();
  FActiveObjFactoryIndex := -1;
  FList := TObjectList.Create(true);
  FPaths := TStringList.Create;
  FHandleList := TList.Create();
end;

destructor TPluginList.Destroy();
begin
  FPaths.Free();
  UnLoad();
  FList.Free();
  inherited Destroy();
end;

procedure TPluginList.UnLoad();
var i: integer;
begin
  FList.Clear();

  // as dlls so podem ser descarregadas depois da destruicao dos objetos
  for i := 0 to FHandleList.Count-1 do
    Windows.FreeLibrary(cardinal(FHandleList[i]));
end;

procedure TPluginList.Add(Item: TPlugin);
begin
  FList.Add(Item);
  FHandleList.Add(pointer(Item.DllHandle));
end;

function TPluginList.getCount(): integer;
begin
  Result := FList.Count;
end;

function TPluginList.getItem(i: integer): TPlugin;
begin
  Result := TPlugin(FList[i]);
end;

procedure TPluginList.AddPath(const Path: string);
begin
  FPaths.Add(Path);
end;

procedure TPluginList.Load;
var i: Integer;
begin
  for i := 0 to FPaths.Count-1 do
    LoadPlugins(FPaths[i]);
end;

procedure TPluginList.LoadPlugins(const Path: string);
var SL: TStrings;
     i: integer;
begin
  SL := FileUtils.EnumerateFiles(['.dll'], Path, true);
  for i := 0 to SL.Count-1 do
    LoadPlugin(SL[i]);
end;

procedure TPluginList.LoadPlugin(const Filename: string);
var Plugin: TPlugin;
begin
  Plugin := getPluginInstance(Filename);
  if Plugin <> nil then Add(Plugin);
end;

procedure TPluginList.ReLoad();
begin
  FList.Clear();
  Unload();
  Load();
end;

function TPluginList.getActiveFactory: IObjectFactory;
begin
  if FActiveObjFactoryIndex > -1 then
     Result := getItem(FActiveObjFactoryIndex).Factory
  else
     Result := nil;
end;

function TPluginList.getFactoryByName(const FactoryName: string): IObjectFactory;
var i: Integer;
begin
  Result := nil;
  for i := 0 to getCount()-1 do
    if FactoryName = getItem(i).Factory.getName() then
       begin
       Result := getItem(i).Factory;
       Break;
       end;
end;

end.
