unit Rochedo.Component;

interface
uses Types, Classes, Windows, Messages, Forms, SysUtils, ExtCtrls,
     Graphics, Controls, ComCtrls, Menus, Contnrs, ActnList,

     // Geral
     MSXML4,
     XML_Utils,
     XML_Interfaces,
     Plugin,
     Shapes,
     MessageManager,
     SysUtilsEx,
     Lists,
     MessagesForm,
     Application_Class,
     WinUtils,
     Rochedo.Component.Dialog;

var // Identificados das mensagens
  UM_ComponentPaint : integer;

type
  TMapPoint = record
     X, Y: Double;
  end;

  IDesigner = interface
    function pointToMapPoint(p: TPoint): TMapPoint;
    function mapPointToPoint(p: TMapPoint): TPoint;
    function getControl(): TWinControl;
    function getCanvas(): TCanvas;
    function getColor(): TColor;
    function getTableNames(): TStrings;
    function getMouseDownEvent(): TMouseEvent;
    function getMouseMoveEvent(): TMouseMoveEvent;
    function getMouseUpEvent(): TMouseEvent;
    function getMouseClickEvent(): TNotifyEvent;
    function getMouseDblClickEvent(): TNotifyEvent;
  end;

  IProject = interface
    // Retorna a instancia do objeto implementador
    function getInstance(): TObject;

    // Avisa quando houve uma modificacao
    procedure setModified(Value: boolean);

    // Se o arquivo existir, "Name" devera voltar com o nome completo do arquivo (path + name)
    function FileExists(var Name: string): boolean;

    // Avisa quando o nome do arquivo do projeto muda
    procedure FilenameChange(const Filename: string);
  end;

  TComponentClass = class of TComponent;

  TComponent = class(T_NRC_InterfacedObject, IMessageReceptor)
  private
    // Representam as posicoes dos objetos.
    // Sao do tipo reais para poderem armazenarem tanto
    // coordenadas de tela quanto coord. geo referenciadas.
    FPos: TMapPoint;

    // Lista de objetos conectados
    FObjList: TObjectList;

    // Utilizado para criacao de instancias que possuem codigo em plugins
    FFactory: IObjectFactory;

    // Propriedades salvas em arquivo
    FNome : String;
    FDescricao : String;
    FComentarios : TXML_StringList;

    FVisitado : Boolean;
    FModificado : Boolean;
    FProject : IProject;
    FBloqueado : Boolean;
    FTN : TStrings;
    FAvisarQueVaiSeDestruir : Boolean;

    // Utilizado na navegacao pelos nós quando lemos as informações
    // de um arquivo XML
    FNodeIndex : integer;
    FDesigner: IDesigner;

    procedure setModified(const Value: Boolean);
    procedure setNome(const Value: String);

    // Obtem a string que sera mostrada em um hint
    function getInternalHint(): string;

    // Estabelece um nome padrao para esta instancia
    function createName(): String;

    // Chama o metodo virtual de desenho para cada conencao
    procedure DrawConnections();

    // Eventos
    procedure EditEvent(Sender: TObject);
    function getComp(i: integer): TComponent;
    function getCompCount: integer;
  protected
    // Destruicao do componente
    destructor Destroy(); override;

    // Estabelece a posicao do objeto
    procedure setPos(const Value: TMapPoint); virtual;

    // Obtem a posicao do objeto em coordenados de tela
    function getScreenPos(): TPoint; virtual;

    // Retorna informacoes adicionais para serem mostradas no hint do componente
    function getHint(): string; virtual;

    // Atualiza o Hint do objeto
    procedure updateHint(); virtual;

    // salva as informações da instância
    procedure internalToXML(x: TXML_Writer); virtual;

    // IMessageReceptor Interface
    function receiveMessage(Const MSG: TadvMessage): Boolean; virtual;

    // Retorna o prefixo padrao para o nome do objeto
    function getPrefix(): string; virtual;

    // Retorna o nome da fabrica deste objeto quando este estiver em um plugin
    function getFactoryName(): string; virtual;

    // Comunicação com o usuário (Interface gráfica)
    function createDialog(): TComponentDialog; virtual;
    procedure getDialogData(d: TComponentDialog); virtual;
    procedure setDialogData(d: TComponentDialog); virtual;

    // Metodos de desenho
    procedure DrawConnection(Obj: TComponent); virtual;

    // Realiza as acoes pos-coneccao
    procedure AfterConnection(Obj: TComponent; Loading: boolean); virtual;
  public
    // Criacao do componente
    constructor Create(Designer: IDesigner); overload; virtual;

    // Criacao do componente
    constructor Create(Project: IProject; Designer: IDesigner;
                       const Pos: TMapPoint; Factory: IObjectFactory); overload; virtual;

    // Fornece as acoes que este objeto disponibiliza
    procedure getActions(Actions: TActionList); virtual;

    // Responsavel por desenhar a selecao do objeto
    procedure DrawSelection(Select: Boolean); virtual;

    // Utilizados para navegacao dos nós filhos de um nó
    function firstChild(no: IXMLDomNode): IXMLDomNode;
    function nextChild(no: IXMLDomNode): IXMLDomNode;

    // Retorna o objeto dado seu nome.
    // Este objeto eh procurado na tabela de nomes
    function ObjectByName(const Name: String): TObject;

    // Abre um dialogo para edicao dos dados desta instancia
    function Edit(): Integer;

    // Responsavel por aceitar ou nao uma coneccao
    function AcceptConnection(cc: TComponentClass): boolean; virtual;

    // Conecta este objeto a outro
    function Connect(Obj: TComponent; Loading: boolean): Integer;

    // Salvamento e leitura dos dados da instancia
    procedure toXML(x: TXML_Writer);
    procedure fromXML(no: IXMLDomNode); virtual;

    // Opcional
    // Representa o projeto a que este objeto pertence
    property Project : IProject read FProject write FProject;

    // Representa a area de projeto a que este objeto esta vinculado
    property Designer : IDesigner read FDesigner;

    // Indica se o objeto ja foi visitado em um algoritmo de percorrimento
    property Visited : Boolean read FVisitado write FVisitado;

    // Indica se o objeto teve suas propriedades alteradas
    property Modified : Boolean read FModificado write setModified;

    // Indica se o objeto esta bloqueado
    property Locked : Boolean read FBloqueado write FBloqueado;

    // Indica se o objeto deve enviar uma mensagem antes de sua destruicao
    // A mensagem enviada indicara que o objeto esta prestes a ser destruido
    property SendMessageBeforeDestruction: Boolean read  FAvisarQueVaiSeDestruir
                                                   write FAvisarQueVaiSeDestruir;
    // Identificacao do objeto, devera ser unica
    property Name : String read FNome write SetNome;

    // Descricao breve do objeto
    property Description : String read FDescricao write FDescricao;

    // Comentarios gerais
    property Comment : TXML_StringList read FComentarios;

    // Posicao real do objeto
    property Pos : TMapPoint read FPos write setPos;

    // Tabela de nomes do projeto que contem este objeto
    property TableNames : TStrings read FTN;

    // Retorna o numero de componentes conectados
    property ComponentCount : integer read getCompCount;

    // Retorna o i-egimo componente conectado
    property Component[i: integer] : TComponent read getComp;
  end;

  TSolidComponent = class(TComponent)
  private
    // Imagem que representa o componente
    FShape : TdrBaseShape;

    function getScreenArea(): TRect;
    procedure ShapeBeforeDestruction(Sender: TObject);
  protected
    // Estabelece a posicao do objeto
    procedure setPos(const Value: TMapPoint); override;

    // Obtem a posicao do objeto em coordenados de tela
    function getScreenPos(): TPoint; override;

    // Atualiza o Hint do objeto
    procedure updateHint(); override;

    // Responsavel por criar a imagem que representara o componente visualmente
    function createShape(Owner: Classes.TComponent): TdrBaseShape; virtual;

    // Responsavel por desenhar a selecao do objeto
    procedure DrawSelection(Select: Boolean); override;

    // Realiza as acoes pos-coneccao
    procedure AfterConnection(Obj: TComponent; Loading: boolean); override;

    // Destruicao do componente
    destructor Destroy(); override;
  public
    // Criacao do componente
    constructor Create(Project: IProject; Designer: IDesigner;
                       const Pos: TMapPoint; Factory: IObjectFactory); override;

    // Representa a posicao na tela
    property ScreenPos : TPoint read GetScreenPos;

    // Representa a area ocupada na tela
    property ScreenArea : TRect read getScreenArea;
  end;

  TSquare = class(TSolidComponent)
  protected
    function createShape(Owner: Classes.TComponent): TdrBaseShape; override;
  end;

  TEllipse = class(TSolidComponent)
  protected
    function createShape(Owner: Classes.TComponent): TdrBaseShape; override;
  end;

  TTriangle = class(TSolidComponent)
  protected
    function createShape(Owner: Classes.TComponent): TdrBaseShape; override;
  end;

  // Controle das classes registradas

  ComponentClasses = class
  public
    class procedure RegisterClass(aClass: TComponentClass);
    class function getClass(const aName: string): TComponentClass;
  end;

  // IDE ----------------------------------------------------------------------

const

  IDE_st_USER_CONST    = 2000;

  IDE_st_None          = 0;
  IDE_st_CreateObject  = 1;
  IDE_st_SelectObject  = 2;
  IDE_st_MoveObject    = 3;

type

  IIDE = interface
    function getSelectComponentClass(): TComponentClass;
    function getActiveObjectFactory(): IObjectFactory;
    function getStatus(): integer;
  end;

  // IDE ----------------------------------------------------------------------

implementation
uses Rochedo.MessageIDs;

{ TComponent }

constructor TComponent.Create(Designer: IDesigner);
var p: TMapPoint;
begin
  Create(nil, Designer, p, nil);
end;

constructor TComponent.Create(Project: IProject; Designer: IDesigner;
                              const Pos: TMapPoint; Factory: IObjectFactory);
begin
  inherited Create;

  FProject      := Project;
  FDesigner     := Designer;
  FFactory      := Factory;
  FTN           := FDesigner.getTableNames();
  FNome         := CreateName();
  FComentarios  := TXML_StringList.Create();
  FObjList      := TObjectList.Create(false);

  FAvisarQueVaiSeDestruir := true;

  GetMessageManager.RegisterMessage(UM_DELETING_OBJECT, self);
  GetMessageManager.RegisterMessage(UM_GET_OBJECT, self);
  GetMessageManager.RegisterMessage(UM_RESET_VISIT, self);
  GetMessageManager.RegisterMessage(UM_LOCK_OBJECT, self);
  GetMessageManager.RegisterMessage(UM_ComponentPaint, self);

  if FTN <> nil then FTN.AddObject(FNome, self);
  updateHint();
end;

destructor TComponent.Destroy();
var i: Integer;
begin
  FComentarios.Free();

  GetMessageManager.UnRegisterMessage(UM_DELETING_OBJECT, self);
  GetMessageManager.UnRegisterMessage(UM_GET_OBJECT, self);
  GetMessageManager.UnRegisterMessage(UM_RESET_VISIT, self);
  GetMessageManager.UnRegisterMessage(UM_LOCK_OBJECT, self);
  GetMessageManager.UnRegisterMessage(UM_ComponentPaint, self);

  i := FTN.IndexOf(FNome);
  if i > -1 then FTN.Delete(i);

  FObjList.Free();

  Inherited Destroy;
end;

procedure TComponent.setModified(const Value: Boolean);
begin
  FModificado := Value;
  if FProject <> nil then FProject.setModified(Value);
end;

function TComponent.ReceiveMessage(const MSG: TadvMessage): Boolean;
var i: Integer;
    s: String;
begin
  if MSG.ID = UM_ComponentPaint then
     begin
     DrawConnections();
     getScreenPos();
     end
  else

  if MSG.ID = UM_RESET_VISIT then
     Visited := False
  else

  if MSG.ID = UM_LOCK_OBJECT then
     if FProject <> nil then
        if MSG.ParamAsObject(1) = FProject.getInstance() then
           FBloqueado := Boolean(MSG.ParamAsInteger(0))
        else
           // Nada - Este objeto pertence a outro projeto
     else
        FBloqueado := Boolean(MSG.ParamAsInteger(0))
  else

  if MSG.ID = UM_GET_OBJECT then
     {Verifica se o Name do objeto atual bate com o parâmetro passado.
      Se opcionalmente um terceiro parâmetro for passado (projeto) verificamos
      se este objeto pertence a este projeto.}
     begin
     s := MSG.ParamAsString(0);
     if (CompareText(s, Name) = 0) then
        if MSG.ParamCount = 3 then
           if FProject <> nil then
              if MSG.ParamAsObject(2) = FProject.getInstance() then
                 pPointer(MSG.ParamAsPointer(1))^ := self
              else
                 // nada - Este objeto pertence a outro projeto
           else
              pPointer(MSG.ParamAsPointer(1))^ := self
        else
           pPointer(MSG.ParamAsPointer(1))^ := self;
     end
  else
     // ...
end;

function TComponent.Edit(): Integer;
var i: Integer;
    FDialogo: TComponentDialog;
begin
  Result := mrNone;
  FDialogo := CreateDialog();
  i := FTN.IndexOf(FNome);
  if i <> -1 then FTN.Delete(i);
  Try
    setDialogData(FDialogo);
    FDialogo.Lock := FBloqueado;
    FDialogo.Hide();
    Result := FDialogo.ShowModal();
    if (Result = mrOk) and (not FBloqueado) then
       begin
       setModified(True);
       getDialogData(FDialogo);
       updateHint();
       end;
  Finally
    if i <> -1 then FTN.AddObject(FNome, self);
    FDialogo.Free();
    FDialogo := nil;
  End;
end;

procedure TComponent.setDialogData(d: TComponentDialog);
begin
  d.edNome.Text       := FNome;
  d.edDescricao.Text  := FDescricao;
  d.mComentarios.Text := FComentarios.Text;
end;

procedure TComponent.getDialogData(d: TComponentDialog);
var s: String;
begin
  if FDescricao <> d.edDescricao.Text then
     begin
     FDescricao := d.edDescricao.Text;
     GetMessageManager.SendMessage(UM_OBJECT_DESCRIPTION_CHANGE, [Self]);
     end;

  if FComentarios.Text <> d.mComentarios.Text then
     begin
     FComentarios.Text := d.mComentarios.Text;
     GetMessageManager.SendMessage(UM_OBJECT_COMMENT_CHANGE, [Self]);
     end;

  if FNome <> d.edNome.Text then
     begin
     s := FNome;
     FNome := d.edNome.Text;
     GetMessageManager.SendMessage(UM_OBJECT_NAME_CHANGE, [Self, @s, @FNome]);
     end;
end;

procedure TComponent.SetNome(const Value: String);
var i: Integer;
begin
  if (Value <> '') and (CompareText(Value, FNome) <> 0) then
     begin
     i := FTN.IndexOf(FNome);
     if i > -1 then FTN.Delete(i);
     FNome := Value;
     FTN.AddObject(FNome, self);
     end;
end;

function TComponent.CreateDialog(): TComponentDialog;
begin
  Result := TComponentDialog.Create(self, FTN);
end;

function TComponent.CreateName(): String;
var i: Integer;
    Prefixo: String;
begin
  if FTN <> nil then
     begin
     i := 0;
     Prefixo := GetPrefix();
     repeat
       inc(i);
       Result := Prefixo + IntToStr(i);
       until FTN.IndexOf(Result) = -1
     end;
end;

function TComponent.GetPrefix(): String;
begin
  Result := 'Component_';
end;

function TComponent.getInternalHint(): string;
begin
  result := FNome;
  if alltrim(FDescricao) <> '' then result := result + ': ' + FDescricao;

  if getHint() <> '' then
     result := result + System.sLineBreak + getHint();

  if (FComentarios.Count > 0) and (FComentarios[FComentarios.Count-1] = '') then
     FComentarios.Delete(FComentarios.Count-1);

  if FComentarios.Count > 0 then
     result := result + System.sLineBreak + FComentarios.Text;

  if LastChar(result) in [#13, #10] then System.Delete(result, Length(result)-1, 2);
end;

procedure TComponent.updateHint();
begin
  // Nada
end;

function TComponent.objectByName(const Name: String): TObject;
var i: Integer;
begin
  i := FTN.IndexOf(Name);
  if i <> -1 then
     Result := FTN.Objects[i]
  else
     Result := nil;
end;

procedure TComponent.ToXML(x: TXML_Writer); // static
var p: TPoint;
begin
  Applic().ActiveObject := self;
  p := getScreenPos();

  x.BeginIdent();
  x.beginTag('object', ['class', 'name', 'sx', 'sy', 'Factory', 'rx', 'ry'],
                       [ClassName, FNome, p.X, p.Y, getFactoryName(), FPos.X, FPos.Y]);
    x.BeginIdent();
    internalToXML(x); // virtual
    x.EndIdent();
  x.endTag('object');
  x.EndIdent();
end;

procedure TComponent.internalToXML(x: TXML_Writer); // virtual
begin
  x.Write('description', FDescricao);
  FComentarios.ToXML('comments', x.Buffer, x.IdentSize);
end;

procedure TComponent.fromXML(no: IXMLDomNode); // virtual
begin
  Applic.ActiveObject := self;
  setNome(no.attributes.item[1].text);
  FDescricao := firstChild(no).text;
  FComentarios.FromXML(nextChild(no));
end;

function TComponent.firstChild(no: IXMLDomNode): IXMLDomNode;
begin
  FNodeIndex := 0;
  if no.hasChildNodes then
     result := no.childNodes.item[FNodeIndex]
  else
     result := nil;
end;

function TComponent.nextChild(no: IXMLDomNode): IXMLDomNode;
begin
  inc(FNodeIndex);
  if (no.hasChildNodes) and (FNodeIndex < no.childNodes.length) then
     result := no.childNodes.item[FNodeIndex]
  else
     result := nil;
end;

procedure TComponent.getActions(Actions: TActionList);
begin
  CreateAction(Actions, nil, 'Edit ...', false, EditEvent, self);
end;

procedure TComponent.EditEvent(Sender: TObject);
begin
  Edit();
end;

function TComponent.getHint(): string;
begin
  result := '';
end;

function TComponent.getFactoryName(): string;
begin
  if FFactory <> nil then
     result := FFactory.getName()
  else
     result := '';
end;

function TComponent.AcceptConnection(cc: TComponentClass): boolean;
begin
  result := true;
end;

function TComponent.Connect(Obj: TComponent; Loading: boolean): Integer;
begin
  result := FObjList.Add(Obj);

  // virtual
  AfterConnection(Obj, Loading);
end;

procedure TComponent.DrawSelection(Select: Boolean);
begin
  // Nada
end;

function TComponent.getScreenPos(): TPoint;
begin
  result := Point(0, 0);
end;

procedure TComponent.setPos(const Value: TMapPoint);
begin
  // Nada
end;

procedure TComponent.DrawConnection(Obj: TComponent);
var c: TCanvas;
    p: TPoint;
begin
  c := FDesigner.getCanvas();
  c.Pen.Style := psDot;
  c.Pen.Color := clBLACK;
  p := self.getScreenPos(); c.MoveTo(p.X, p.Y);
  p := Obj.getScreenPos(); c.LineTo(p.X, p.Y);
end;

procedure TComponent.DrawConnections();
var i: Integer;
begin
  for i := 0 to FObjList.Count-1 do
    DrawConnection( TComponent(FObjList[i]) );
end;

procedure TComponent.AfterConnection(Obj: TComponent; Loading: boolean);
begin
  // Nada
end;

function TComponent.getComp(i: integer): TComponent;
begin
  result := TComponent( FObjList[i] );
end;

function TComponent.getCompCount(): integer;
begin
  if FObjList = nil then
     result := 0
  else
     result := FObjList.Count;
end;

{ TSolidComponent }

constructor TSolidComponent.Create(Project: IProject; Designer: IDesigner;
                                   const Pos: TMapPoint; Factory: IObjectFactory);
begin
  inherited Create(Project, Designer, Pos, Factory);
  FShape := CreateShape(Designer.getControl());
  if FShape <> nil then
     begin
     FShape.Tag         := Integer(self);
     FShape.Parent      := Designer.getControl();
     FShape.OnMouseDown := Designer.getMouseDownEvent();
     FShape.OnMouseMove := Designer.getMouseMoveEvent();
     FShape.OnMouseUp   := Designer.getMouseUpEvent();
     FShape.OnClick     := Designer.getMouseClickEvent();
     FShape.OnDblClick  := Designer.getMouseDblClickEvent();

     // Como o componente que aparece no formulario eh o shape e nao este componente
     // precisamos de uma maneira de saber quando o componente visual foi destruido.
     FShape.OnBeforeDestruction := ShapeBeforeDestruction;

     // Estabele as coordenadas reais do componente
     setPos(Pos);
     end;
end;

function TSolidComponent.createShape(Owner: Classes.TComponent): TdrBaseShape;
begin
  SysUtilsEx.VirtualError(self, 'CreateShape');
end;

destructor TSolidComponent.Destroy();
begin
  if FShape <> nil then
     begin
     FShape.OnBeforeDestruction := nil;
     FShape.Free();
     end;

  inherited Destroy();
end;

procedure TSolidComponent.AfterConnection(Obj: TComponent; Loading: boolean);
var p: TMapPoint;
begin
  if not Loading then
     begin
     p.X := Pos.X + 2 * FShape.Width;
     p.Y := Pos.Y + 2 * FShape.Height;
     Obj.setPos(p);
     DrawConnection(Obj);
     end;
end;

procedure TSolidComponent.DrawSelection(Select: Boolean);
var oldBrushColor : TColor;
    oldPenColor : TColor;
    r : TRect;
    c : TCanvas;
begin
  r := getScreenArea();
  if (r.Top <> r.Bottom) then
     begin
     c := FDesigner.getCanvas();

     oldBrushColor := c.Brush.color;
     oldPenColor   := c.Pen.color;

     if Select Then
        begin
        c.Brush.color := clRed;
        c.Pen.color   := clRed;
        end
     else
        begin
        c.Brush.color := FDesigner.getColor();
        c.Pen.color   := clBlack;
        end;

     InflateRect(r, 2, 2);
     c.FrameRect(r);

     c.Brush.color := oldBrushColor;
     c.Pen.color   := oldPenColor;
     end;
end;

function TSolidComponent.getScreenArea(): TRect;
begin
  if FShape <> nil then
     with FShape do
        Result := Classes.Rect(Left, Top, Left + Width, Top + Height)
  else
     Result := Classes.Rect(0, 0, 0, 0);
end;

function TSolidComponent.getScreenPos(): TPoint;
var c: TPoint;
begin
  if FDesigner <> nil then
     begin
     Result := FDesigner.MapPointToPoint(FPos);
     if FShape <> nil then
        begin
        c := FShape.Center;
        if (Result.X <> c.X) or ((Result.Y <> c.Y)) then
           FShape.Center := Result;
        end;
     end
  else
     Result := Point(0, 0);
end;

procedure TSolidComponent.setPos(const Value: TMapPoint);
var p: TPoint;
begin
  if (FShape <> nil) and
     ( (Value.x <> FPos.x) or (Value.y <> FPos.y) ) then
     begin
     setModified(True);
     FPos := Value;

     p := getScreenPos();
     FShape.SetBounds( p.X - FShape.Width  div 2,
                       p.Y - FShape.Height div 2,
                       FShape.Width,
                       FShape.Height );
     end;
end;

procedure TSolidComponent.ShapeBeforeDestruction(Sender: TObject);
begin
  FShape := nil;
  Free();
end;

procedure TSolidComponent.updateHint();
begin
  if FShape <> nil then
     FShape.Hint := getInternalHint();
end;

{ TSquare }

function TSquare.createShape(Owner: Classes.TComponent): TdrBaseShape;
begin
  result := TdrRectangle.Create(Owner);
  result.SetBounds(0, 0, 10, 10);
end;

{ TEllipse }

function TEllipse.createShape(Owner: Classes.TComponent): TdrBaseShape;
begin
  result := TdrEllipse.Create(nil);
  result.SetBounds(0, 0, 30, 20);
end;

{ TTriangle }

function TTriangle.createShape(Owner: Classes.TComponent): TdrBaseShape;
begin
  result := TdrTriangle.Create(nil);
  result.SetBounds(0, 0, 20, 20);
end;

{ ComponentClasses }

var
  ClassList: TStrings = nil;

class function ComponentClasses.getClass(const aName: string): TComponentClass;
var i: integer;
begin
  if ClassList = nil then
     result := nil
  else
     begin
     i := ClassList.IndexOf(aName);
     if i > -1 then
        result := TComponentClass(ClassList.Objects[i])
     else
        result := nil;
     end;
end;

class procedure ComponentClasses.RegisterClass(aClass: TComponentClass);
begin
  if ClassList = nil then
     ClassList := TStringList.Create();

  ClassList.AddObject(aClass.ClassName, pointer(aClass));   
end;

initialization
  // Registro dos IDs das mensagens
  UM_ComponentPaint := getMessageManager().RegisterMessageID('UM_ComponentPaint');

  // Registro das classes
  ComponentClasses.RegisterClass(TSquare);
  ComponentClasses.RegisterClass(TEllipse);
  ComponentClasses.RegisterClass(TTriangle);
end.
