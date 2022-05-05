unit Rochedo.Designer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnList, MSXML4, XML_Utils, Rochedo.Component;

type
  TDesigner = class(TForm, IDesigner)
    procedure Form_Close(Sender: TObject; var Action: TCloseAction);
  private
    FProject: IProject;
    FLocked: boolean;
    FMovingObj: boolean;
    FActualPos, FOldPos: TPoint;
    FPopupMenu: TPopupMenu;
    FActions: TActionList;
    FFilename: string;
    FBackgroundFilename: string;

    function getTableNames(): TStrings;
    function getMouseDownEvent(): TMouseEvent;
    function getMouseMoveEvent(): TMouseMoveEvent;
    function getMouseUpEvent(): TMouseEvent;
    function getMouseClickEvent(): TNotifyEvent;
    function getMouseDblClickEvent(): TNotifyEvent;
    function getColor(): TColor;
    procedure internalSelectObject(Obj: TObject);
    procedure internalCreateObject(Sender: TObject);
    procedure DragComponent(Sender: TObject);

    // Gerenciamento dos Menus dos Objetos
    function CreateMenu(Action: TBasicAction): TMenuItem;
    function CreateMenuItem(Root: TMenuItem; Text: String; Event: TNotifyEvent = nil): TMenuItem; overload;
    function CreateMenuItem(Root: TMenuItem; Action: TBasicAction): TMenuItem; overload;
    function CreateSubMenus(Root: TMenuItem; Action: TBasicAction; CreateItem: boolean): TMenuItem;
    procedure ShowMenu(Obj: TComponent);
  protected
    ActiveObject: TObject;
    TableNames: TStrings;
    IDE: IIDE;

    // Obtem o componente associado ao objeto, se nao existir, retorna nil.
    function getComponent(Sender: TObject; out c: TComponent): boolean;

    // Estabelece a instancia implementadora de IProject
    procedure SetProject(Project: IProject);

    destructor Destroy(); override;
    procedure DoClick(Sender: TObject); virtual;
    procedure DoDblClick(Sender: TObject); virtual;
    procedure DoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure DoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer); virtual;
    procedure DoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure DoPaint(Sender: TObject); virtual;
    procedure SelectObject(var Obj: TObject); virtual;
    procedure DrawSelection(Obj: TObject; Select: boolean); virtual;
    procedure RepaintObjects(); virtual;
    procedure setEvents(); virtual;
    function pointToMapPoint(p: TPoint): TMapPoint; virtual;
    function mapPointToPoint(p: TMapPoint): TPoint; virtual;
    function getControl(): TWinControl; virtual;
    function getCanvas(): TCanvas; virtual;
    function getProject(): IProject; virtual;
    function CanCreateObjectDirectlyOnDesigner(cc: TComponentClass): boolean; virtual;
    procedure SaveUserData(x: TXML_Writer); virtual;
    procedure LoadUserData(no: IXMLDomNode); virtual;

    // Permite que os descendentes executem acoes nos componentes recem criados
    // Eh disparado tanto no modo "designer" quanto na leitura de componentes
    procedure DoComponentCreated(c: TComponent); virtual;
  public
    constructor Create(IDE: IIDE);

    procedure setBackgroundImage(const Filename: string); virtual;
    procedure SaveToFile(const Filename: string);
    procedure LoadFromFile(const Filename: string);

    property Filename : string read FFilename;
    property BackgroundFilename : string read FBackgroundFilename;
  end;

implementation
uses MessageManager, Shapes, WinUtils, SysUtilsEx, Application_Class, Plugin,
     Scenarios.Application;

{$R *.dfm}

const
  ERROR_BackgroundImageNotFound = 'Arquivo da image de fundo não encontrado'#13'%s'#13 +
                                  'Verifique o caminho dentro do arquivo do projeto.'#13 +
                                  'Sem a imagem de fundo não eh possível definir o sistema de coordenadas.';

  INFO_CanNotCreateInstance = 'Intâncias da classe selecionada não podem ser criadas'#13 +
                              'diretamente na área de projeto.';

// Eventos .....................................................................................

procedure TDesigner.Form_Close(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

// Eventos .....................................................................................

constructor TDesigner.Create(IDE: IIDE);
begin
  inherited Create(nil);

  // Fields ...
  self.IDE := IDE;
  self.TableNames := TStringList.Create();
  self.FPopupMenu := TPopupMenu.Create(self);

  setEvents();
end;

destructor TDesigner.Destroy();
begin
  inherited Destroy();

  // Por causa da ordem de destruicao dos objetos, TableNames tem que ser
  // destruido por ultimo, pois os objetos descendentes de Rochedo.TComponent
  // utilizam TableNames em seus destructors.
  TableNames.Free();
  FActions.Free();
end;

procedure TDesigner.setEvents();
begin
  self.OnClick := DoClick;
  self.OnDblClick := DoDblClick;
  self.OnMouseDown := DoMouseDown;
  self.OnMouseMove := DoMouseMove;
  self.OnMouseUp := DoMouseUp;
  self.OnPaint := DoPaint;
end;

function TDesigner.getComponent(Sender: TObject; out c: TComponent): boolean;
begin
  result := Sender is TdrBaseShape;
  if result then
     c := TComponent(TdrBaseShape(Sender).Tag)
  else
     c := nil;
end;

function TDesigner.getCanvas(): TCanvas;
begin
  result := self.Canvas;
end;

function TDesigner.getControl(): TWinControl;
begin
  result := self;
end;

function TDesigner.getMouseClickEvent(): TNotifyEvent;
begin
  result := DoClick;
end;

function TDesigner.getMouseDblClickEvent(): TNotifyEvent;
begin
  result := DoDblClick;
end;

function TDesigner.getMouseDownEvent(): TMouseEvent;
begin
  result := DoMouseDown;
end;

function TDesigner.getMouseMoveEvent(): TMouseMoveEvent;
begin
   result := DoMouseMove;
end;

function TDesigner.getMouseUpEvent(): TMouseEvent;
begin
  result := DoMouseUp;
end;

function TDesigner.mapPointToPoint(p: TMapPoint): TPoint;
begin
  result.X := trunc(p.X);
  result.Y := trunc(p.Y);
end;

function TDesigner.pointToMapPoint(p: TPoint): TMapPoint;
begin
  result.X := p.X;
  result.Y := p.Y;
end;

procedure TDesigner.DoClick(Sender: TObject);
begin
  case IDE.getStatus() of
    IDE_st_SelectObject: internalSelectObject(Sender);
    IDE_st_CreateObject: internalCreateObject(Sender);
    end;
end;

procedure TDesigner.DoDblClick(Sender: TObject);
var c: TComponent;
begin
  if getComponent(Sender, c) then
     c.Edit();
end;

procedure TDesigner.DoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
     if IDE.getStatus() = IDE_st_MoveObject then
        if Sender is TdrBaseShape then
           begin
           InternalSelectObject(Sender);
           if not FLocked then
              begin
              FActualPos := Point(X, Y);
              FMovingObj := True;
              FOldPos := TControl(Sender).ScreenToClient(FActualPos);
              getCanvas().Pen.Mode := pmXor;
              end
           end
        else
           // nada
     else
       //nada
  else
     if Sender is TdrBaseShape then
        begin
        InternalSelectObject(Sender);
        ShowMenu( TComponent(ActiveObject) );
        end;
end;

procedure TDesigner.DoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if FMovingObj and (Sender <> getControl()) then
     DragComponent(Sender);
end;

procedure TDesigner.DoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var sp: TPoint;
begin
  if Button = mbLeft then
     begin
     if IDE.getStatus() = IDE_st_MoveObject then
        if (Sender <> getControl()) and not FLocked then
           begin
           FMovingObj := False;
           getCanvas().Pen.Mode := pmCopy;
           sp := getControl().ScreenToClient(Mouse.CursorPos);
           if sp.x < 2 then sp.x := 2;
           if sp.y < 2 then sp.y := 2;
           TComponent(ActiveObject).Pos := PointToMapPoint(sp);
           getControl().Invalidate();
           end;
     end;
end;

procedure TDesigner.DoPaint(Sender: TObject);
begin
  RepaintObjects();
  DrawSelection(ActiveObject, true);
end;

function TDesigner.getTableNames(): TStrings;
begin
  result := TableNames;
end;

function TDesigner.getProject(): IProject;
begin
  result := FProject;
end;

procedure TDesigner.SelectObject(var Obj: TObject);
begin
  // nada
end;

procedure TDesigner.DrawSelection(Obj: TObject; Select: boolean);
begin
  if Obj is TComponent then
     TComponent(Obj).DrawSelection(Select);
end;

procedure TDesigner.internalCreateObject(Sender: TObject);
var cc: TComponentClass;
    c1: TComponent;
    c2: TComponent;
     p: TMapPoint;
     f: IObjectFactory;
begin
  cc := IDE.getSelectComponentClass();
  f  := IDE.getActiveObjectFactory();

  if cc <> nil then
     if Sender = getControl() then
        if CanCreateObjectDirectlyOnDesigner(cc) then
           begin
           p := PointToMapPoint( getControl().ScreenToClient(Mouse.CursorPos) );
           c1 := cc.Create(getProject(), self, p, f);
           internalSelectObject(c1);
           DoComponentCreated(c1);
           end
        else
           MessageDLG(INFO_CanNotCreateInstance, mtInformation, [mbOk], 0)
     else
        if getComponent(Sender, c1) then
           if c1.AcceptConnection(cc) then
              begin
              p.X := 0; p.Y := 0;
              c2 := cc.Create(getProject(), self, p, f);
              c1.Connect(c2, false);
              internalSelectObject(c2);
              DoComponentCreated(c2);
              end;
end;

procedure TDesigner.internalSelectObject(Obj: TObject);
begin
  // Apaga a selecao antiga
  DrawSelection(ActiveObject, false);

  if Obj = nil then
     ActiveObject := nil
  else
     if Obj = getControl() then
        begin
        SelectObject({var} Obj);
        ActiveObject := Obj;
        end
     else
        if Obj is TdrBaseShape then
           ActiveObject := TComponent( TdrBaseShape(Obj).Tag )
        else
           if Obj is TComponent then
              ActiveObject := Obj
           else
              ActiveObject := nil;

  // Desenha a nova selecao
  DrawSelection(ActiveObject, true);
end;

function TDesigner.getColor(): TColor;
begin
  result := self.Color;
end;

procedure TDesigner.DragComponent(Sender: TObject);
var p: TPoint;
    c: TControl;
begin
  c := TControl(Sender);
  p := getControl().ScreenToClient(Mouse.CursorPos);

  getCanvas().Rectangle(FOldPos.x,
                        FOldPos.y,
                        FOldPos.x + c.Width,
                        FOldPos.y + c.Height);

  dec(p.x, FActualPos.x);
  dec(p.y, FActualPos.y);
  if p.x < 2 then p.x := 2;
  if p.y < 2 then p.y := 2;

  FOldPos := p;
  getCanvas().Rectangle(FOldPos.x,
                        FOldPos.y,
                        FOldPos.x + c.Width,
                        FOldPos.y + c.Height);
end;

procedure TDesigner.RepaintObjects();
begin
  getMessageManager().SendMessage(UM_ComponentPaint, []);
end;

function TDesigner.CreateMenu(Action: TBasicAction): TMenuItem;
begin
  Result := TMenuItem.Create(nil);
  Result.AutoHotkeys := maManual;
  Result.Caption := TAction(Action).Caption;
  Result.OnClick := TAction(Action).OnExecute;
  Result.Tag := TAction(Action).Tag;
  Result.Checked := TAction(Action).Checked;
end;

function TDesigner.CreateMenuItem(Root: TMenuItem; Text: String; Event: TNotifyEvent): TMenuItem;
begin
  Result := TMenuItem.Create(nil);
  Result.AutoHotkeys := maManual;
  Result.Caption := Text;
  Result.OnClick := Event;
  Root.Add(Result);
end;

function TDesigner.CreateMenuItem(Root: TMenuItem; Action: TBasicAction): TMenuItem;
begin
  Result := CreateMenu(Action);
  Root.Add(Result);
end;

function TDesigner.CreateSubMenus(Root: TMenuItem; Action: TBasicAction; CreateItem: boolean): TMenuItem;
var i: Integer;
begin
  if CreateItem then
     begin
     Result := CreateMenu(Action);
     Root.Add(Result);
     end
  else
     Result := Root;

  for i := 0 to Action.ComponentCount-1 do
    CreateSubMenus(Result, TAction(Action.Components[i]), true)
end;

procedure TDesigner.ShowMenu(Obj: TComponent);
var Menu : TMenuItem;
     act : TContainedAction;
       i : Integer;
begin
  if Obj <> nil then
     begin
     FPopupMenu.Items.Clear();
     FActions.Free();
     FActions := TActionList.Create(nil);
     Obj.getActions(FActions);
     for i := 0 to FActions.ActionCount-1 do
       begin
       act := FActions[i];
       Menu := CreateMenuItem(FPopupMenu.Items, act);
       CreateSubMenus(Menu, act, false);
       end;
     FPopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
     end;
end;

procedure TDesigner.setBackgroundImage(const Filename: string);
begin
  FBackgroundFilename := Filename;
end;

procedure TDesigner.SaveToFile(const Filename: string);
var x: TXML_Writer;
    SL: TStrings;

    // Dados que influen na leitura devem ser colocados nesta seção
    procedure SaveGeralData();
    begin
      x.BeginTag('general');
        x.BeginIdent();
        x.Write('DecimalSeparator', SysUtils.DecimalSeparator);
        x.Write('BackgroundFilename', ExtractRelativePath(Filename, FBackgroundFilename));
        x.beginTag('UserData');
          SaveUserData(x);
        x.EndTag('UserData');  
        x.EndIdent();
      x.EndTag('general');
    end;

    procedure SaveObjects();
    var i: Integer;
        c: TControl;
    begin
      x.beginTag('objects');

      // Dados do Projeto
      //self.ToXML(); {TODO 1 -cProgramacao: Pensar}

      for i := 0 to getControl().ControlCount-1 do
        begin
        c := getControl().Controls[i];
        if c is TdrBaseShape then
           TComponent(c.tag).ToXML(x);
        end;

      x.endTag('objects');
    end; // proc SaveObjects

    procedure writeRelationship(C1, C2: TComponent);
    begin
      x.beginIdent();
      x.Write('rel', ['obj1', 'obj2'], [C1.Name, C2.Name], '');
      x.endIdent();
    end;

    procedure SaveRelationships();
    var i, j: Integer;
        ct: TControl;
        cp: TComponent;
    begin
      x.beginTag('relationships');

      for i := 0 to getControl().ControlCount-1 do
        begin
        ct := getControl().Controls[i];
        if ct is TdrBaseShape then
           begin
           cp := TComponent(ct.tag);
           for j := 0 to cp.ComponentCount - 1 do
             writeRelationship(cp, cp.Component[j]);
           end
        end;

      x.endTag('relationships');
    end; // proc SaveRelationship

begin
  FFilename := Filename; // manter em primeiro lugar
  SysUtilsEx.SaveDecimalSeparator();
  StartWait();
  SL := TStringList.Create();
  x := TXML_Writer.Create(SL);
  try
    x.Buffer := SL;

    x.WriteHeader('', []);
    x.BeginTag('designer');
      x.BeginIdent();

      SaveGeralData();
      SaveObjects();
      SaveRelationships();              

      x.EndIdent();
    x.EndTag('designer');

    SL.SaveToFile(Filename);
    if FProject <> nil then
       begin
       FProject.setModified(False);
       FProject.FilenameChange(Filename);
       end;
  finally
    SysUtilsEx.RestoreDecimalSeparator();
    StopWait();
    SL.Free();
    x.Free();
  end;
end;

procedure TDesigner.LoadFromFile(const Filename: string);
var
  // Armazena os objetos lidos em uma lista ordenada para após a leitura
  // auxiliar na conecção entre eles.
  Objects: TStringList;

  procedure LoadGeralData(no: IXMLDomNode);
  var s: string;
  begin
    // Separedor decimal
    s := no.childNodes.item[0].text;
    if System.Length(s) = 1 then
       SysUtils.DecimalSeparator := s[1];

    // Imagem de fundo
    s := ExpandFilename(no.childNodes.item[1].text);
    if FileExists(s) then
       self.setBackgroundImage(s)
    else
       raise Exception.CreateFmt(ERROR_BackgroundImageNotFound, [s]);

    // User Data
    LoadUserData(no.childNodes.item[2]);
  end;

  procedure LoadObject(no: IXMLDomNode);
  var sClass, sName, sFactory: string;
      C: TComponent;
      CC: TComponentClass;
      Factory: IObjectFactory;
      X, Y: Integer;
      Pos: TMapPoint;
  begin
    C := nil;

    // Identificacao geral
    sClass := no.attributes.item[0].text;
    sName := no.attributes.item[1].text;

    // Coordenadas de tela (sx, sy)
    X := toInt(no.attributes.item[2].text);
    Y := toInt(no.attributes.item[3].text);

    // Identificacao da fabrica de objetos
    sFactory := no.attributes.item[4].text;

    // Coordenadas reais (rx, ry)
    Pos.X := toFloat(no.attributes.item[5].text);
    Pos.Y := toFloat(no.attributes.item[6].text);

    CC := ComponentClasses.getClass(sClass);
    if CC <> nil then
       begin
       if sFactory <> '' then Factory := Applic.Plugins.getFactoryByName(sFactory) else Factory := nil;
       C := CC.Create(FProject, self, Pos, Factory);
       C.fromXML(no);
       Objects.AddObject(C.Name, C);
       DoComponentCreated(C);
       end;
  end;

  // no 0: Dados do Projeto
  // no 1..n-1: Objetos da rede
  procedure LoadObjects(no: IXMLDomNode);
  var i: Integer;
  begin
    // Le o projeto
    //self.fromXML(no.childNodes.item[0]);

    // ATENCAO: CUIDADO COM OS INDICES !!!!

    // Le os objetos
    for i := 0 to no.childNodes.length-1 do
      LoadObject(no.childNodes.item[i]);
  end;

  procedure ConnectObjects(no: IXMLDomNode);
  var C1, C2: TComponent;
      i: integer;
  begin
    i := Objects.IndexOf(no.attributes.item[0].text);
    C1 := TComponent(Objects.Objects[i]);

    i := Objects.IndexOf(no.attributes.item[1].text);
    C2 := TComponent(Objects.Objects[i]);

    C1.Connect(C2, true);
  end;

  procedure LoadRelationships(no: IXMLDomNode);
  var i: Integer;
  begin
    for i := 0 to no.childNodes.length-1 do
      ConnectObjects(no.childNodes.item[i]);
  end;

var doc: IXMLDOMDocument;
     no: IXMLDomNode;
begin
  doc := OpenXMLDocument(Filename);
  no := doc.documentElement;

  if (no <> nil) and (no.nodeName = 'designer') then
     begin
     SetCurrentDir(Filename);
     FFilename := Filename; // manter em primeiro lugar
     //AP(AreaDeProjeto).BloquearDesenhoDaRede(true);

     Objects := TStringList.Create();
     Objects.Sorted := true;

     SysUtilsEx.SaveDecimalSeparator();
     StartWait();
     try
       LoadGeralData     (no.childNodes.item[0]);
       LoadObjects       (no.childNodes.item[1]);
       LoadRelationships (no.childNodes.item[2]);

       if FProject <> nil then
          begin
          FProject.setModified(False);
          FProject.FilenameChange(Filename);
          end;
     finally
       SysUtilsEx.RestoreDecimalSeparator();
       StopWait();
       Objects.Free();
       //AP(AreaDeProjeto).BloquearDesenhoDaRede(false);
       end;
     end
  else
     Applic.ShowError('Arquivo Inválido: ' + Filename);
end; // LoadFromFile()

function TDesigner.CanCreateObjectDirectlyOnDesigner(cc: TComponentClass): boolean;
begin
  result := true;
end;

procedure TDesigner.SetProject(Project: IProject);
begin
  FProject := Project;
end;

procedure TDesigner.LoadUserData(no: IXMLDomNode);
begin
  // Nada
end;

procedure TDesigner.SaveUserData(x: TXML_Writer);
begin
  // Nada
end;

procedure TDesigner.DoComponentCreated(c: TComponent);
begin
  // Nada
end;

end.
