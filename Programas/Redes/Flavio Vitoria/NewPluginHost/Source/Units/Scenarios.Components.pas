unit Scenarios.Components;

interface
uses Classes, Types, ActnList, MSXML4, Shapes, pr_Interfaces, Plugin, XML_Utils, WinUtils,
     Rochedo.Component,
     Rochedo.Component.Dialog;

type
  TPC = class(TSquare)
  private
    FNextPC: TPC;
  protected
    procedure DrawConnection(Obj: TComponent); override;
    procedure AfterConnection(Obj: TComponent; Loading: boolean); override;
    function getPrefix(): string; override;
  public
    property NextPC : TPC read FNextPC;
  end;

  TScenario = Class(TSolidComponent, ICenarioDemanda)
  private
    FDI: ICenarioDemanda;
    FFactoryName: string;

    function ToString(): wideString;
    procedure Release();
    procedure ipr_setExePath(const ExePath: string);
    procedure ipr_setObjectName(const Name: string);
    procedure ipr_setProjectPath(const ProjectPath: string);
    function  ihc_TemErros(): boolean;
    procedure ihc_ObterErros(var Erros: TStrings);
    procedure ihc_ObterAcoesDeMenu(Acoes: TActionList);
    procedure ihc_Simular();
    procedure ihc_toXML(Buffer: TStrings; Ident: integer);
    procedure ihc_fromXML(no: IXMLDOMNode);
    function  ihc_getXMLVersion(): integer;
    function icd_ObterValoresUnitarios(): TObject;
    function icd_ObterValorFloat(const Propriedade: string): real;
    function icd_ObterValorString(const Propriedade: string): string;
  protected
    function createShape(Owner: Classes.TComponent): TdrBaseShape; override;
    function getFactoryName(): string; override;
    procedure getActions(Actions: TActionList); override;
    procedure fromXML(no: IXMLDomNode); override;
    procedure internalToXML(x: TXML_Writer); override;
    function getPrefix(): string; override;
    destructor Destroy(); override;
  public
    constructor Create(Project: IProject; Designer: IDesigner;
                       const Pos: TMapPoint; Factory: IObjectFactory); override;

    function getPropAsFloat(const Prop: string): real;
    function getPropAsString(const Prop: string): string;
  end;

  TProject = class(TComponent, IProject)
  private
    FFilename: string;
    FScripts: TStrings;
    FPCs: TList;

    function getInstance(): TObject;
    procedure setModified(Value: boolean);
    function FileExists(var Name: string): boolean;
    function getPrefix(): string; override;
    function createDialog(): TComponentDialog; override;
    procedure getDialogData(d: TComponentDialog); override;
    procedure setDialogData(d: TComponentDialog); override;
    procedure fromXML(no: IXMLDomNode); override;
    procedure internalToXML(x: TXML_Writer); override;
    procedure FilenameChange(const Filename: string);
    destructor Destroy(); override;
    function getPC(i: integer): TPC;
    function getPCs: integer;
  public
    constructor Create(Designer: IDesigner); override;
    function getObjectByName(const Name: string): TObject;
    function VerifyPath(var Filename: String): Boolean;
    procedure getRelativePath(var Filename: String);
    procedure AddPC(PC: TPC);
    property Scripts: TStrings read FScripts;
    property PCs : integer read getPCs;
    property PC[i: integer]: TPC read getPC;
  end;

implementation
uses Graphics, GraphicUtils, SysUtils, SysUtilsEx, MessageManager,
     Rochedo.MessageIDs,
     Scenarios.Application,
     Scenarios.Dialogs.Project;

{ TPC }

procedure TPC.AfterConnection(Obj: TComponent; Loading: boolean);
begin
  if Obj is TPC then
     begin
     FNextPC := TPC(Obj);
     if not Loading then DrawConnection(Obj);
     end
  else
     inherited AfterConnection(Obj, Loading);
end;

procedure TPC.DrawConnection(Obj: TComponent);
var p1, p2: TPoint;
begin
  if Obj is TPC then
     begin
     p1 := self.ScreenPos;
     p2 := TPC(Obj).ScreenPos;
     Designer.getCanvas().Pen.Style := psSolid;
     DesenharSeta(Designer.getCanvas(), p1, p2, 10, DistanciaEntre2Pontos(p1, p2) div 2);
     end
  else
     inherited DrawConnection(Obj);
end;

function TPC.getPrefix(): string;
begin
  result := 'ControlPoint_';
end;

{ TScenario }

constructor TScenario.Create(Project: IProject; Designer: IDesigner;
                             const Pos: TMapPoint; Factory: IObjectFactory);
var o: TObject;
begin
  inherited Create(Project, Designer, Pos, Factory);

  FFactoryName := Factory.getName();
  o := Factory.CreateObject('');
  o.GetInterface(ICenarioDemanda, FDI);

  ipr_setExePath(Applic.appDir);
  //ipr_setProjectPath(Projeto.CaminhoArquivo);
  ipr_setObjectName(Name);
end;

function TScenario.createShape(Owner: Classes.TComponent): TdrBaseShape;
begin
  Result := TdrBitmap.Create(nil, 'CENARIO_10X10');
  Result.Width := 12;
  Result.Height := 13;
  TdrBitmap(Result).DrawFrame := True;
end;

destructor TScenario.Destroy();
begin
  Release();
  inherited Destroy();
end;

procedure TScenario.fromXML(no: IXMLDomNode);
begin
  inherited fromXML(no);
  ihc_fromXML( nextChild(no) );
  ipr_setObjectName(Name);
end;

procedure TScenario.getActions(Actions: TActionList);
begin
  inherited getActions(Actions);
  CreateAction(Actions, nil, '-', false, nil, self);
  ihc_ObterAcoesDeMenu(Actions);
end;

function TScenario.getFactoryName(): string;
begin
  result := FFactoryName;
end;

function TScenario.getPrefix(): string;
begin
  result := 'Scenario_';
end;

function TScenario.getPropAsFloat(const Prop: string): real;
begin
  result := icd_ObterValorFloat(Prop);
end;

function TScenario.getPropAsString(const Prop: string): string;
begin
  result := icd_ObterValorString(Prop);
end;

function TScenario.icd_ObterValoresUnitarios(): TObject;
begin
  Result := FDI.icd_ObterValoresUnitarios();
end;

function TScenario.icd_ObterValorFloat(const Propriedade: string): real;
begin
  result := FDI.icd_ObterValorFloat(Propriedade);
end;

function TScenario.icd_ObterValorString(const Propriedade: string): string;
begin
  result := FDI.icd_ObterValorString(Propriedade);
end;

procedure TScenario.ihc_fromXML(no: IXMLDOMNode);
begin
  FDI.ihc_fromXML(no);
end;

function TScenario.ihc_getXMLVersion(): integer;
begin
  result := FDI.ihc_getXMLVersion();
end;

procedure TScenario.ihc_ObterAcoesDeMenu(Acoes: TActionList);
begin
  FDI.ihc_ObterAcoesDeMenu(Acoes);
end;

procedure TScenario.ihc_ObterErros(var Erros: TStrings);
begin
  FDI.ihc_ObterErros(Erros);
end;

procedure TScenario.ihc_Simular();
begin
  FDI.ihc_Simular();
end;

function TScenario.ihc_TemErros(): boolean;
begin
  Result := FDI.ihc_TemErros();
end;

procedure TScenario.ihc_toXML(Buffer: TStrings; Ident: integer);
begin
  FDI.ihc_toXML(Buffer, Ident);
end;

procedure TScenario.internalToXML(x: TXML_Writer);
begin
  inherited internalToXML(x);
  x.beginTag('pluginData', ['Version'], [ ihc_getXMLVersion() ]);
    x.beginIdent();
    ihc_toXML(x.Buffer, x.IdentSize);
    x.endIdent();
  x.endTag('pluginData');
end;

procedure TScenario.ipr_setExePath(const ExePath: string);
begin
  FDI.ipr_setExePath(ExePath);
end;

procedure TScenario.ipr_setObjectName(const Name: string);
begin
  FDI.ipr_setObjectName(Name);
end;

procedure TScenario.ipr_setProjectPath(const ProjectPath: string);
begin
  FDI.ipr_setProjectPath(ProjectPath);
end;

procedure TScenario.Release();
begin
  FDI.Release();

  // Desta maneira evitamos a chamada de "_intfClear()" e erros
  // que ocorreriam devido a incorreta liberacao da interface pelo Delphi
  Pointer(FDI) := nil;
end;

function TScenario.ToString(): wideString;
begin
  result := FDI.ToString();
end;

{ TProject }

constructor TProject.Create(Designer: IDesigner);
begin
  inherited Create(Designer);
  FScripts := TStringList.Create();
  FPCs := TList.Create();
end;

destructor TProject.Destroy();
begin
  FPCs.Free();
  FScripts.Free();
  inherited;
end;

function TProject.createDialog(): TComponentDialog;
begin
  Result := TProjectDialog.Create(self, TableNames);
end;

procedure TProject.AddPC(PC: TPC);
begin
  FPCs.Add(PC);
end;

function TProject.FileExists(var Name: string): boolean;
begin
  result := VerifyPath(Name);
end;

procedure TProject.FilenameChange(const Filename: string);
begin
  FFilename := Filename;
end;

procedure TProject.fromXML(no: IXMLDomNode);
var n: IXMLDomNode;
    i: integer;
begin
  inherited fromXML(no);
  n := nextChild(no);
  FScripts.Clear();
  for i := 0 to n.childNodes.length-1 do
    FScripts.Add(n.childNodes.item[i].text);
end;

procedure TProject.getDialogData(d: TComponentDialog);
begin
  inherited getDialogData(d);
  with (d as TProjectDialog) do
    begin
    FScripts.Assign(lbScripts.Items);
    end;
end;

function TProject.getInstance(): TObject;
begin
  result := self;
end;

function TProject.getObjectByName(const Name: string): TObject;
var p: pPointer;
begin
  p := nil;

  if Name <> '' then
     GetMessageManager.SendMessage(UM_GET_OBJECT, [@Name, @p, self]);

  result := TObject(p);
end;

function TProject.getPrefix(): string;
begin
  result := 'Project_';
end;

procedure TProject.getRelativePath(var Filename: String);
var s: String;
begin
  if System.Pos(':\', Filename) > 0 then
     begin
     s := ExtractFilePath(self.FFilename);
     if LastChar(s) = '\' then DeleteLastChar(s);

     if CompareText(s, Filename) = 0 then
        Filename := ''
     else
        Filename := ExtractRelativePath(s + '\', Filename);
     end;
end;

procedure TProject.internalToXML(x: TXML_Writer);
var i: Integer;
begin
  inherited internalToXML(x);
  x.beginTag('scripts');
    x.beginIdent();
    for i := 0 to FScripts.Count-1 do x.Write('UserScript', FScripts[i]);
    x.endIdent();
  x.endTag('scripts');
end;

procedure TProject.setDialogData(d: TComponentDialog);
begin
  inherited setDialogData(d);
  with (d as TProjectDialog) do
    begin
    lbScripts.Items.Assign(FScripts);
    end;
end;

procedure TProject.setModified(Value: boolean);
begin
  Modified := Value;
end;

function TProject.VerifyPath(var Filename: String): Boolean;
begin
  if Filename <> '' then
     begin
     if System.Pos(':\', Filename) = 0 then
        begin
        SetCurrentDir(Filename);
        Filename := ExpandFileName(Filename);
        end;
     Result := SysUtils.FileExists(Filename);
     end
  else
     Result := False;
end;

function TProject.getPC(i: integer): TPC;
begin
  if i < getPCs() then
     result := TPC(FPCs[i])
  else
     raise Exception.CreateFmt('Invalid PC index: %d', [i]);
end;

function TProject.getPCs(): integer;
begin
  result := FPCs.Count;
end;

initialization
  // Registro das classes
  ComponentClasses.RegisterClass(TPC);
  ComponentClasses.RegisterClass(TScenario);
end.
