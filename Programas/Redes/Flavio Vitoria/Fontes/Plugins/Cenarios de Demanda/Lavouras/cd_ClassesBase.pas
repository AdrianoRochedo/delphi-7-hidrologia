unit cd_ClassesBase;

interface
uses Windows,
     Classes,
     ComCtrls,
     ActnList,
     SysUtils,
     Contnrs,
     Dialogs,
     BaseSpreadSheetBook,
     MessageManager,
     SysUtilsEx,
     TreeViewUtils;

var
  UM_FormDestroy   : integer;
  UM_ObjectDestroy : integer;
  UM_Get_Lavouras  : integer;

var
  sIsaregDLL: string = 'isareg.dll';

const
  IsaregDir = 'c:\temp\isareg';

// Imgens
const
  ciFolder       = 0;
  ciFarming      = 1;
  ciItem         = 2;
  ciProperty     = 3;
  ciFactory      = 4;
  ciYear         = 5;
  ciRB_Checked   = 6;
  ciRB_Unchecked = 7;
  ciClock        = 8;
  ciZoom         = 9;

type
  TIsaregDataType1 = array[0..163] of char;
  TIsaregDataType2 = char;

  TIsaregProc = procedure(var p1: TIsaregDataType1;
                          var p2: TIsaregDataType2); stdcall;

  TRendimentosAnuais = array of record
                                  Ano: integer;
                                  Val: real;
                                end;

  // Períods   Irrig   Excess    SETa   SETm   SPre  R(DR)   Sasc
  TFases = array of record
                      Irrigacao : single;
                      Excesso   : single;
                      Inicio    : string;
                      Fim       : string;
                      ETm       : single;
                      ETa       : single;
                      PRE       : single; // precipitacao
                      R         : single; // Variacao de umidade
                      ASC       : single; // Ascencao capilar
                    end;

  TBase = class(T_NRC_InterfacedObject, ITreeNode)
  protected
    TreeNode: TTreeNode;

    procedure DeleteTreeNode();

    // ITreeNode interface
    procedure setNode(Node: TTreeNode);
    function getRef(): TObject;
    function getSelectedImageIndex(): integer;
    function getImageIndex(): integer; virtual;
    function getDescription(): string; virtual;
    function canEdit(): boolean; virtual;
    function getNodeText(): string; virtual;
    procedure executeDefaultAction(); virtual;
    procedure setEditedText(var Text: string); virtual;
    procedure getActions(Actions: TActionList); virtual;
  end;

  TIsaregProcess = class
  private
    FExePath: string;
    FHandle: THandle;
    destructor Destroy(); override;
  public
    constructor Create(const ExePath: string);
    procedure Execute();
  end;

  // Indica o volume no solo (SoilVolume) em um determinado dia
  TSoilVolume = class
    Day       : Single;
    Volume    : Single;
    Indicator : integer;
  end;

  T3C = class
    c1: Single;
    c2: Single;
    c3: Single;
  end;

  T4C = class(T3C)
    c4: Single;
  end;

  T5C = class(T4C)
    c5: Single;
  end;

  T5C_List = class
  private
    FList: TObjectList;
    function getCount: integer;
    function getItem(i: integer): T5C;
  public
    constructor Create();
    destructor Destroy(); override;

    procedure Add(Item: T5C);
    procedure ShowInSheet(Sheet: TBaseSheet);

    property Count : integer read getCount;
    property Item[i: integer] : T5C read getItem;
  end;

  // Armazena uma sequencia de volumes
  TSoilVolume_List = class
  private
    FList: TObjectList;
    function getCount: integer;
    function getItem(i: integer): TSoilVolume;
  public
    constructor Create();
    destructor Destroy(); override;

    procedure Add(Item: TSoilVolume); 
    procedure ShowInSheet(Sheet: TBaseSheet);

    property Count : integer read getCount;
    property Item[i: integer] : TSoilVolume read getItem;
  end;

  // Indica a capacidade de campo (Field Capacity - FC) e o
  // Ponto de Rendimanto Otimo (Optimum Yield Point - OYP)
  // em um determinado dia
  TFC_OYP = class
    Day : Single;
    FC  : Single; // Field Capacity
    OYP : Single; // Optimum Yield Point
  end;

  // Armazena uma sequencia decapacidades de campo e
  // pontos otimos de rendimento
  TFC_OYP_List = class
  private
    FList: TObjectList;
    function getCount: integer;
    function getItem(i: integer): TFC_OYP;
  public
    constructor Create();
    destructor Destroy(); override;

    procedure Add(Item: TFC_OYP);
    procedure ShowInSheet(Sheet: TBaseSheet);

    property Count : integer read getCount;
    property Item[i: integer] : TFC_OYP read getItem;
  end;

implementation

{ TBase }

function TBase.canEdit(): boolean;
begin
  result := false;
end;

procedure TBase.DeleteTreeNode();
begin
  if TreeNode <> nil then TreeNode.Delete();
end;

procedure TBase.executeDefaultAction();
begin
  // Nada
end;

procedure TBase.getActions(Actions: TActionList);
begin
  // Nada
end;

function TBase.getDescription(): string;
begin
  result := '';
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
  // Nada
end;

procedure TBase.setNode(Node: TTreeNode);
begin
  TreeNode := Node;
end;

{ TSoilVolume_List }

constructor TSoilVolume_List.Create();
begin
  inherited Create();
  FList := TObjectList.Create(true);
end;

destructor TSoilVolume_List.Destroy();
begin
  FList.Free();
  inherited Destroy();
end;

procedure TSoilVolume_List.Add(Item: TSoilVolume);
begin
  FList.Add(Item);
end;

function TSoilVolume_List.getCount(): integer;
begin
  Result := FList.Count;
end;

function TSoilVolume_List.getItem(i: integer): TSoilVolume;
begin
  Result := TSoilVolume(FList[i]);
end;

procedure TSoilVolume_List.ShowInSheet(Sheet: TBaseSheet);
var i: Integer;
    x: TSoilVolume;
begin
  // Titulo
  Sheet.WriteCenter(1, 1, 'Soil Volume');
  Sheet.BoldRow(1);

  // Cabecalho
  Sheet.WriteCenter(3, 1, 'Day');
  Sheet.WriteCenter(3, 2, 'Volume');
  Sheet.WriteCenter(3, 3, 'Indicator');
  Sheet.BoldRow(3);

  // Dados
  for i := 0 to getCount()-1 do
    begin
    x := getItem(i);
    Sheet.WriteCenter(i+4, 1, x.Day);
    Sheet.WriteCenter(i+4, 2, x.Volume);
    Sheet.WriteCenter(i+4, 3, x.Indicator);
    end;
end;

{ TFC_OYP_List }

constructor TFC_OYP_List.Create();
begin
  inherited Create();
  FList := TObjectList.Create(true);
end;

destructor TFC_OYP_List.Destroy();
begin
  FList.Free();
  inherited Destroy();
end;

procedure TFC_OYP_List.Add(Item: TFC_OYP);
begin
  FList.Add(Item);
end;

function TFC_OYP_List.getCount(): integer;
begin
  Result := FList.Count;
end;

function TFC_OYP_List.getItem(i: integer): TFC_OYP;
begin
  Result := TFC_OYP(FList[i]);
end;

procedure TFC_OYP_List.ShowInSheet(Sheet: TBaseSheet);
var i: Integer;
    x: TFC_OYP;
begin
  // Titulo
  Sheet.WriteCenter(1, 1, 'Field Capacity and Optimum Yield Line');
  Sheet.BoldRow(1);

  // Cabecalho
  Sheet.WriteCenter(3, 1, 'Day');
  Sheet.WriteCenter(3, 2, 'FC');
  Sheet.WriteCenter(3, 3, 'OYL');
  Sheet.BoldRow(3);

  // Dados
  for i := 0 to getCount()-1 do
    begin
    x := getItem(i);
    Sheet.WriteCenter(i+4, 1, x.Day);
    Sheet.WriteCenter(i+4, 2, x.FC);
    Sheet.WriteCenter(i+4, 3, x.OYP);
    end;
end;

{ TIsaregProcess }

constructor TIsaregProcess.Create(const ExePath: string);
begin
  FExePath := ExePath;

  FHandle := Windows.LoadLibrary(pChar(FExePath + sIsaregDLL));
  if FHandle = 0 then
     raise Exception.Create('Isareg.DLL not found');
end;

destructor TIsaregProcess.Destroy();
begin
  if FHandle <> 0 then Windows.FreeLibrary(FHandle);
  inherited;
end;

procedure TIsaregProcess.Execute();
var p: TIsaregProc;
    t1: TIsaregDataType1;
    t2: TIsaregDataType2;
begin
  fillChar(t1, sizeof(t1), #0);
  t1 := 'c:\temp\isareg';
  t2 := '0';

  @p := Windows.GetProcAddress(FHandle, 'isareg');
  if @p <> nil then
     begin
     SysUtils.SetCurrentDir(FExePath);
     try p(t1, t2) except {nada} end;
     end
  else
     raise Exception.Create('Isareg.DLL entry point not found');
end;

{ T5C_List }

procedure T5C_List.Add(Item: T5C);
begin
  FList.Add(Item);
end;

constructor T5C_List.Create();
begin
  inherited Create();
  FList := TObjectList.Create(true);
end;

destructor T5C_List.Destroy();
begin
  FList.Free();
  inherited Free();
end;

function T5C_List.getCount(): integer;
begin
  result := FList.Count;
end;

function T5C_List.getItem(i: integer): T5C;
begin
  result := T5C(FList[i]);
end;

procedure T5C_List.ShowInSheet(Sheet: TBaseSheet);
var i: Integer;
    x: T5C;
begin
  // Titulo
  Sheet.WriteCenter(1, 1, 'Noname');
  Sheet.BoldRow(1);

  // Cabecalho
  Sheet.WriteCenter(3, 1, 'Day');
  Sheet.WriteCenter(3, 2, 'Teor Asc.');
  Sheet.WriteCenter(3, 3, 'ETa');
  Sheet.WriteCenter(3, 4, 'Ratio');
  Sheet.WriteCenter(3, 5, 'ETa/ETm');
  Sheet.BoldRow(3);

  // Dados
  for i := 0 to getCount()-1 do
    begin
    x := getItem(i);
    Sheet.WriteCenter(i+4, 1, x.c1);
    Sheet.WriteCenter(i+4, 2, x.c2);
    Sheet.WriteCenter(i+4, 3, x.c3);
    Sheet.WriteCenter(i+4, 4, x.c4);
    Sheet.WriteCenter(i+4, 5, x.c5);
    end;
end;

initialization
  UM_FormDestroy   := getMessageManager.RegisterMessageID('UM_FormDestroy');
  UM_ObjectDestroy := getMessageManager.RegisterMessageID('UM_ObjectDestroy');
  UM_Get_Lavouras  := getMessageManager.RegisterMessageID('UM_Get_Lavouras');

end.
