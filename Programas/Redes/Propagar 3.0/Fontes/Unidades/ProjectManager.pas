unit ProjectManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Contnrs, ExtCtrls, ActnList,
  Frame_TreeViewObjects,
  Application_Class,
  XML_Utils,
  MSXML4,
  DialogUtils,
  WinUtils,
  SysUtilsEx,
  TreeViewUtils;

type
  TProjectManager = class;
  TProject = class;

  // Armazena as coordenadas de uma regiao e a manipula
  TImageRegion = class
  private
    FHandle: HRGN;
    FCanvas: TCanvas;
    FSelected: boolean;
    destructor Destroy(); override;
    procedure CreateRegion(const Points: array of TPoint);
    procedure setSelected(const Value: boolean);
  public
    constructor Create(Canvas: TCanvas; const Filename: string); overload;
    constructor Create(Canvas: TCanvas; const Points: array of TPoint); overload;

    // Verifica se o ponto pertence a regiao
    function PointInRegion(X, Y: integer): boolean;

    // Seleciona ou nao uma regiao
    // Se true entao a regiao eh mostrada na tela
    property Selected : boolean read FSelected write setSelected;
  end;

  // Base para todas as classes que desejam interagir através
  // da TreeView da janela gerenciadora.
  TBase = class(T_NRC_InterfacedObject, ITreeNode)
  private
    function getRef(): TObject;
    procedure setNode(Node: TTreeNode);
    destructor Destroy(); override;
  protected
    // Eh estabelecido na criacao de cada objeto descendente
    // Aponta para o gerenciador de projetos que eh unico.
    PM: TProjectManager;

    // Cada vez que um objeto descendente de TBase eh adicionado
    // a TreeView, "Node" eh estabelecido automaticamente pelo
    // mecanismo atraves do metodo "setNode".
    Node: TTreeNode;

    // forca o no a se atualizar visualmente
    procedure UpdateNode();

    // Retorna um nome relativo
    function getFilename(const Filename: string): string;

    // Interfaces de ITreeNode que poderao ser sobre-escritas
    function getDescription(): string; virtual;
    function canEdit(): boolean; virtual;
    function getImageIndex(): integer; virtual;
    function getSelectedImageIndex(): integer; virtual;
    function getNodeText(): string; virtual;
    procedure executeDefaultAction(); virtual;
    procedure setEditedText(var Text: string); virtual;
    procedure getActions(Actions: TActionList); virtual;
  public
    constructor Create(aPM: TProjectManager);
  end;

  // Representa um cenario de um projeto
  TScenery = class(TBase)
  private
    FTitle: string;
    FFilename: string;
    FProject: TProject;

    procedure SaveToXML(x: TXML_Writer);
    procedure LoadFromXML(node: IXMLDomNode);

    // Eventos de Menu
    procedure RemoveEvent(Sender: TObject);
  protected
    procedure getActions(Actions: TActionList); override;
    function canEdit(): boolean; override;
    function getImageIndex(): integer; override;
    function getDescription(): string; override;
    procedure setEditedText(var Text: string); override;
    function getNodeText(): string; override;
    procedure executeDefaultAction(); override;
  public
    constructor Create(aPM: TProjectManager; aP: TProject; const Filename: string);

    // Titulo do cenario
    property Title : string read FTitle write FTitle;
  end;

  // Representa um projeto, cada projeto pode conter varios cenarios
  TProject = class(TBase)
  private
    FTitle: string;
    FImageRegionFile: string;
    FImageRegion: TImageRegion;
    FList: TObjectList;
    destructor Destroy(); override;
    procedure SaveToXML(x: TXML_Writer);
    procedure LoadFromXML(node: IXMLDomNode);

    // Eventos de Menu
    procedure AddSceneryEvent(Sender: TObject);
    procedure RemoveEvent(Sender: TObject);
    procedure DefineRegionEvent(Sender: TObject);
  protected
    procedure getActions(Actions: TActionList); override;
    function getImageIndex(): integer; override;
    function getDescription(): string; override;
    procedure setEditedText(var Text: string); override;
    function getNodeText(): string; override;
  public
    constructor Create(aPM: TProjectManager);

    // Cria um cenario via uma arquivo
    function AddScenery(const Filename: string): TScenery;

    // Estabelece a regiao na imagem de atuacão deste projeto .
    procedure setImageRegion(const Filename: string);

    // Seleciona ou nao a regiao estabelecida em uma imagem
    procedure SelectImageRegion(Select: boolean);

    // Verifica se o ponto pertence a regiao do projeto
    function PointInRegion(X, Y: integer): boolean;

    // Título do Projeto
    property Title : string read FTitle write FTitle;
  end;

  TImageClick = procedure (Sender: TObject; X, Y: Integer) of object;

  // Representacao visual do gerenciador de projetos
  TfoProjectManager = {private} class(TForm)
    frTreeView: TTreeViewObjects;
    Splitter: TSplitter;
    procedure FormPaint(Sender: TObject);
    procedure SplitterMoved(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FPM: TProjectManager;
    Bitmap: TBitmap;
    OnImageClick : TImageClick;
    constructor Create(aPM: TProjectManager);
    destructor Destroy(); override;
    function AddInTree(RootNode: TTreeNode; Obj: TObject): TTreeNode;
  end;

  // Gerenciador de projetos
  TProjectManager = class(TBase)
  private
    FList: TObjectList;
    FActiveProject: TProject;

    // "SelectEvent" somente tratara eventos quando o usuario selecionar
    // um no que contenha um objeto que implemente a interface "ITreeNode"
    procedure SelectEvent(Sender, aObject: TObject);

    // Ocorre quando o usuario clica na imagem
    procedure ImageClickEvent(Sender: TObject; X, Y: Integer);

    destructor Destroy(); override;
    procedure BeginUpdate();
    procedure EndUpdate();

    // Eventos de menu
    procedure LoadEvent(Sender: TObject);
    procedure SaveEvent(Sender: TObject);
    procedure ClearAllEvent(Sender: TObject);
    procedure CreateProjectEvent(Sender: TObject);
  protected
    Form: TfoProjectManager;
  protected
    function getDescription(): string; override;
    function getImageIndex(): integer; override;
    function getNodeText(): string; override;
    procedure getActions(Actions: TActionList); override;
  public
    constructor Create();
    procedure ShowManager();

    // Cria um novo projeto e estabelece seu titulo
    function AddProject(const Title: string): TProject;

    // Localiza um projeto por ser titulo senao retorna nil
    function LocateProject(const Title: string): TProject;

    // Le a imagem que será mostrada no gerenciador
    procedure LoadImage(const Filename: string);

    // Leitura e salvamento dos projetos ativos do gerenciador
    procedure LoadFromFile(const Filename: string; Merge: boolean);
    procedure SaveToFile(const Filename: string);

    // Limpa o gerenciador
    procedure Clear();

    // Retorna o projeto atualmente selecionado ou nil
    property ActiveProject : TProject read FActiveProject;
  end;

implementation
uses FileUtils,
     sm_Application;

{$R *.dfm}

const
  ciWorld   = 0;
  ciProject = 1;
  ciScenery = 2;

{ TBase }

function TBase.canEdit(): boolean;
begin
  result := false;
end;

constructor TBase.Create(aPM: TProjectManager);
begin
  inherited Create();
  PM := aPM;
end;

destructor TBase.Destroy();
begin
  // Torna os objetos imunes a erros gerados pela ordem
  // de destruicao dos objetos.
  if Node <> nil then Node.Data := nil;
  
  inherited Destroy();
end;

procedure TBase.executeDefaultAction();
begin

end;

procedure TBase.getActions(Actions: TActionList);
begin

end;

function TBase.getDescription(): string;
begin
  result := self.ClassName;
end;

function TBase.getFilename(const Filename: string): string;
begin
  result := Sysutils.ExtractRelativePath(
              Applic().AppDir + 'Cenarios\', Filename);
end;

function TBase.getImageIndex(): integer;
begin
  result := -1;
end;

function TBase.getNodeText(): string;
begin
  result := self.ClassName;
end;

function TBase.getRef(): TObject;
begin
  result := self;
end;

function TBase.getSelectedImageIndex(): integer;
begin
  result := getImageIndex();
end;

procedure TBase.setEditedText(var Text: string);
begin

end;

procedure TBase.setNode(Node: TTreeNode);
begin
  self.Node := Node;
end;

procedure TBase.UpdateNode();
begin
  Node.Text := getNodeText();
end;

{ TProjectManager }

constructor TProjectManager.Create();
begin
  inherited Create(self);

  Form := TfoProjectManager.Create(self);
  Form.AddInTree(nil, self);

  // Conecta o evento de selecao de um no da arvore em um tratador interno.
  // "SelectEvent" somente tratara eventos quando o usuario selecionar
  // um no que contenha um objeto que implemente a interface "ITreeNode"
  Form.frTreeView.OnSelect := SelectEvent;

  // Conecta o evento de mouse para que o objeto perceba o clique na imagem.
  Form.OnImageClick := ImageClickEvent;

  FList := TObjectList.Create(true);
end;

destructor TProjectManager.Destroy();
begin
  Form.Free();
  FList.Free();
  inherited;
end;

procedure TProjectManager.getActions(Actions: TActionList);
begin
  CreateAction(Actions, nil, 'Ler Projetos ...', false, LoadEvent, self);
  CreateAction(Actions, nil, 'Salvar Projetos ...', false, SaveEvent, self);
  CreateAction(Actions, nil, '-', false, nil, self);
  CreateAction(Actions, nil, 'Criar Projeto ...', false, CreateProjectEvent, self);
  CreateAction(Actions, nil, '-', false, nil, self);
  CreateAction(Actions, nil, 'Remover todos os projetos', false, ClearAllEvent, self);
end;

function TProjectManager.getDescription(): string;
begin
  result := 'Gerenciador de Projetos';
end;

function TProjectManager.getImageIndex(): integer;
begin
  result := ciWorld;
end;

function TProjectManager.getNodeText(): string;
begin
  result := 'Projetos';
end;

function TProjectManager.AddProject(const Title: string): TProject;
begin
  result := TProject.Create(self);
  FList.Add(result);
  result.Title := Title;
  Form.AddInTree(self.Node, result);
end;

procedure TProjectManager.ShowManager();
begin
  Form.Show();
  Node.Expand(false);
end;

procedure TProjectManager.LoadImage(const Filename: string);
begin
  Form.Bitmap.LoadFromFile(Filename);
  Form.ClientWidth := Form.frTreeView.Width + 3 + Form.Bitmap.Width;
  Form.ClientHeight := Form.Bitmap.Height;
end;

procedure TProjectManager.SelectEvent(Sender, aObject: TObject);
begin
  if (aObject is TProject) then
     begin
     // Somente seleciona um projeto por vez e sua respectiva regiao na imagem
     if FActiveProject <> nil then FActiveProject.SelectImageRegion(false);
     FActiveProject := TProject(aObject);
     FActiveProject.SelectImageRegion(true);
     Form.Invalidate();
     end
  else
     begin
     if FActiveProject <> nil then
        begin
        FActiveProject.SelectImageRegion(false);
        Form.Invalidate();
        end;
     FActiveProject := nil;
     end;
end;

procedure TProjectManager.ImageClickEvent(Sender: TObject; X, Y: Integer);
var i: Integer;
    p: TProject;
begin
  for i := 0 to FList.Count-1 do
    begin
    p := TProject(FList[i]);
    if p.PointInRegion(X, Y) then
       p.Node.Selected := true;
    end;
end;

procedure TProjectManager.Clear();
var i: Integer;
begin
  Node.DeleteChildren();
  FList.Clear();
end;

procedure TProjectManager.LoadFromFile(const Filename: string; Merge: boolean);
var doc: IXMLDOMDocument;
     no: IXMLDomNode;
      i: integer;
      p: TProject;
begin
  doc := OpenXMLDocument(Filename);
  if (doc.documentElement <> nil) and
     (doc.documentElement.tagName = 'projects') then
     try
       // Todos os arquivos de cenarios deverao ser relativos a este dir.
       SysUtils.SetCurrentDir(Applic().AppDir + 'Cenarios\');

       StartWait();
       BeginUpdate();
       if not Merge then Clear();
       for i := 0 to doc.documentElement.childNodes.length - 1 do
         begin
         no := doc.documentElement.childNodes.item[i];

         if not Merge then
            p := nil
         else
            p := LocateProject(no.attributes.item[0].text);

         if p = nil then p := AddProject('');
         p.LoadFromXML(no);
         end;
       Node.Expand(false);
     finally
       EndUpdate();
       StopWait();
     end
  else
     Applic.ShowError('Arquivo Inválido: ' + Filename);
end; 

procedure TProjectManager.SaveToFile(const Filename: string);
var x  : TXML_Writer;
    i  : integer;
    SL : TStrings;
begin
  SL := TStringList.Create();
  try
    x := Applic.getXMLWriter();
    x.Buffer := SL;

    x.WriteHeader('');

    x.beginTag('projects');
      x.BeginIdent();
      for i := 0 to FList.Count-1 do TProject(FList[i]).SaveToXML(x);
      x.EndIdent();
    x.endTag('projects');

    SL.SaveToFile(Filename);
  finally
    SL.Free();
  end;
end;

procedure TProjectManager.ClearAllEvent(Sender: TObject);
begin
  if MessageDLG('Tem Certeza ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     Clear();
end;

procedure TProjectManager.LoadEvent(Sender: TObject);
var Filename: string;
begin
  if DialogUtils.SelectFile(Filename, Applic().LastDir, 'Projetos|*.smf') then
     LoadFromFile(Filename, true);
end;

procedure TProjectManager.SaveEvent(Sender: TObject);
var Filename: string;
begin
  if DialogUtils.ChooseFilename(Filename, Applic().LastDir, 'smf', 'Projetos|*.smf') then
     SaveToFile(Filename);
end;

procedure TProjectManager.BeginUpdate();
begin
  Form.frTreeView.Tree.Items.BeginUpdate();
end;

procedure TProjectManager.EndUpdate();
begin
  Form.frTreeView.Tree.Items.EndUpdate();
end;

procedure TProjectManager.CreateProjectEvent(Sender: TObject);
var s: String;
begin
  s := Dialogs.InputBox(' Criar Projeto', 'Título:', '');
  if s <> '' then AddProject(s);
end;

function TProjectManager.LocateProject(const Title: string): TProject;
var i: Integer;
begin
  result := nil;
  for i := 0 to FList.Count-1 do
    if TProject(FList[i]).Title = Title then
       begin
       result := TProject(FList[i]);
       break;
       end;
end;

{ TfoProjectManager }

constructor TfoProjectManager.Create(aPM: TProjectManager);
begin
  inherited Create(nil);
  FPM := aPM;
  Bitmap := TBitmap.Create();
end;

function TfoProjectManager.AddInTree(RootNode: TTreeNode; Obj: TObject): TTreeNode;
begin
  result := frTreeView.Tree.Items.AddChildObject(RootNode, '', Obj);
end;

destructor TfoProjectManager.Destroy();
begin
  Bitmap.Free();
  inherited;
end;

procedure TfoProjectManager.FormPaint(Sender: TObject);
begin
  self.Canvas.Draw(frTreeView.Width + Splitter.Width, 0, Bitmap);
end;

procedure TfoProjectManager.SplitterMoved(Sender: TObject);
begin
  self.Invalidate();
end;

procedure TfoProjectManager.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if assigned(OnImageClick) then
     OnImageClick(Bitmap, X - frTreeView.Width - Splitter.Width, Y);
end;

{ TScenery }

function TScenery.canEdit: boolean;
begin
  result := true;
end;

constructor TScenery.Create(aPM: TProjectManager; aP: TProject; const Filename: string);
begin
  inherited Create(aPM);
  FProject := aP;
  FFilename := Filename;
  FTitle := SysUtils.ExtractFileName(Filename);
  FTitle := SysUtils.ChangeFileExt(FTitle, '');
end;

procedure TScenery.executeDefaultAction();
var s, outFile: String;
begin
  s := FFilename;
  if CompareText(ExtractFileExt(s), '.cript') = 0 then
     begin
     outFile := ChangeFileExt(s, '');
     FileUtils.DecryptFile(1803, s, outFile);
     try
       TSystem.getAppInstance().OpenFile(outFile);
       finally
       SysUtils.DeleteFile(outFile);
       end;
     end
  else
     TSystem.getAppInstance().OpenFile(s);
end;

procedure TScenery.getActions(Actions: TActionList);
begin
  CreateAction(Actions, nil, 'Remover', false, RemoveEvent, self);
end;

function TScenery.getDescription(): string;
begin
  result := getNodeText();
end;

function TScenery.getImageIndex(): integer;
begin
  result := ciScenery;
end;

function TScenery.getNodeText(): string;
begin
  result := FTitle;
end;

procedure TScenery.LoadFromXML(node: IXMLDomNode);
begin
  FTitle := node.Attributes.item[0].text;
  FFilename := Sysutils.ExpandFilename(node.childNodes.item[0].text);
  UpdateNode();
end;

procedure TScenery.RemoveEvent(Sender: TObject);
begin
  Node.Delete();
  FProject.FList.Remove(self);
end;

procedure TScenery.SaveToXML(x: TXML_Writer);
begin
  x.beginTag('scenery', ['title'], [FTitle]);
    x.beginIdent();
    x.Write('filename', getFilename(FFilename));
    x.endIdent();
  x.endTag('scenery');
end;

procedure TScenery.setEditedText(var Text: string);
begin
  FTitle := Text;
end;

{ TProject }

function TProject.AddScenery(const Filename: string): TScenery;
begin
  result := TScenery.Create(self.PM, self, Filename);
  FList.Add(result);
  self.PM.Form.AddInTree(self.Node, result);
end;

procedure TProject.AddSceneryEvent(Sender: TObject);
var Filename: string;
begin
  if DialogUtils.SelectFile(Filename, Applic().AppDir + 'Cenarios',
     'Cenários|*.cenario', true, 'Selecione um Cenário') then
     AddScenery(Filename);
end;

constructor TProject.Create(aPM: TProjectManager);
begin
  inherited Create(aPM);
  FList := TObjectList.Create(true);
end;

destructor TProject.Destroy();
begin
  FList.Free();
  FImageRegion.Free();
  inherited;
end;

procedure TProject.getActions(Actions: TActionList);
begin
  CreateAction(Actions, nil, 'Adicionar Cenário ...', false, AddSceneryEvent, self);
  CreateAction(Actions, nil, 'Definir Região da Imagem ...', false, DefineRegionEvent, self);
  CreateAction(Actions, nil, '-', false, nil, self);
  CreateAction(Actions, nil, 'Remover', false, RemoveEvent, self);
end;

function TProject.getDescription(): string;
begin
  result := '';
end;

function TProject.getImageIndex(): integer;
begin
  result := ciProject;
end;

function TProject.getNodeText(): string;
begin
  result := FTitle;
end;

function TProject.PointInRegion(X, Y: integer): boolean;
begin
  if FImageRegion <> nil then
     result := FImageRegion.PointInRegion(X, Y)
  else
     result := false;
end;

procedure TProject.LoadFromXML(node: IXMLDomNode);

   procedure LoadSceneries(node: IXMLDomNode);
   var i: Integer;
       s: TScenery;
   begin
     for i := 0 to node.childNodes.length-1 do
       begin
       s := self.AddScenery('');
       s.LoadFromXML(node.childNodes.item[i]);
       end;
   end;

begin
  FTitle := node.Attributes.item[0].text;
  setImageRegion(Sysutils.ExpandFilename(node.childNodes.item[0].text));
  LoadSceneries(node.childNodes.item[1]);
  UpdateNode();
end;

procedure TProject.SaveToXML(x: TXML_Writer);
var i: Integer;
begin
  x.beginTag('project', ['title'], [FTitle]);
    x.beginIdent();
    x.Write('ImageRegionFile', getFilename(FImageRegionFile));
    x.BeginTag('sceneries');
      x.beginIdent();
      for i := 0 to FList.Count-1 do TScenery(FList[i]).SaveToXML(x);
      x.endIdent();
    x.EndTag('sceneries');
    x.endIdent();
  x.endTag('project');
end;

procedure TProject.SelectImageRegion(Select: boolean);
begin
  if FImageRegion <> nil then
     FImageRegion.Selected := Select;
end;

procedure TProject.setEditedText(var Text: string);
begin
  FTitle := Text;
end;

procedure TProject.setImageRegion(const Filename: string);
begin
  FreeAndNil(FImageRegion);
  FImageRegion := TImageRegion.Create(PM.Form.Bitmap.Canvas, Filename);
  FImageRegionFile := Filename;
end;

procedure TProject.RemoveEvent(Sender: TObject);
begin
  Node.Delete();
  PM.FList.Remove(self);
end;

procedure TProject.DefineRegionEvent(Sender: TObject);
var Filename: string;
begin
  if DialogUtils.SelectFile(Filename, Applic().AppDir + 'Cenarios',
     'Região de Imagem|*.ImageRegion') then
     setImageRegion(Filename);
end;

{ TImageRegion }

constructor TImageRegion.Create(Canvas: TCanvas; const Filename: string);
var  p: array of TPoint;
    SL: TStrings;
     i: integer;
begin
  inherited Create();
  FCanvas := Canvas;

  if FileExists(Filename) then
     begin
     SL := SysUtilsEx.LoadTextFile(Filename);
     System.SetLength(p, SL.Count);
     for i := 0 to SL.Count-1 do
       p[i] := SysUtilsEx.toPoint(SL[i]);
     CreateRegion(p);
     end;
end;

constructor TImageRegion.Create(Canvas: TCanvas; const Points: array of TPoint);
begin
  inherited Create();
  FCanvas := Canvas;
  CreateRegion(Points);
end;

type
  PPoints = ^TPoints;
  TPoints = array[0..0] of TPoint;

procedure TImageRegion.CreateRegion(const Points: array of TPoint);
begin
  FHandle := Windows.CreatePolygonRgn(
    PPoints(@Points)^,  // ponteiro para o primeiro elemento do array de pontos
    Length(Points),    	// número de pontos
    ALTERNATE);         // modo de preenchimento
end;

destructor TImageRegion.Destroy();
begin
  if FHandle <> 0 then Windows.DeleteObject(FHandle);
  inherited;
end;

function TImageRegion.PointInRegion(X, Y: integer): boolean;
begin
  result := windows.PtInRegion(FHandle, X, Y);
end;

procedure TImageRegion.setSelected(const Value: boolean);
begin
  if Value <> FSelected then
     begin
     FSelected := Value;
     InvertRgn(FCanvas.Handle, FHandle);
     end;
end;

end.
