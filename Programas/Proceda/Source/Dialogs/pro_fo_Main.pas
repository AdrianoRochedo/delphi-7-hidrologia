unit pro_fo_Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, ComCtrls, Grids, StdCtrls, Buttons, ActnList,
  ImgList, FileCtrl, IniFiles, ToolWin, Contnrs, Execfile, ShellAPI,
  pro_Interfaces,
  pro_BaseClasses,
  pro_Classes,
  pro_Application, AppEvnts;

type
  TDLG_Principal = class(TForm)
    spArvore: TSplitter;
    paArvore: TPanel;
    Arvore: TTreeView;
    StatusBar: TStatusBar;
    Splitter1: TSplitter;
    ControlBar: TControlBar;
    Open: TOpenDialog;
    Save: TSaveDialog;
    MenuCampos: TPopupMenu;
    Ordenar1: TMenuItem;
    Menu_NaoOrdenar: TMenuItem;
    Menu_Crescente: TMenuItem;
    Menu_Decrescente: TMenuItem;
    Menu_Arvore: TPopupMenu;
    Menu_Arvore_AEsq: TMenuItem;
    Menu_Arvore_Acima: TMenuItem;
    imgListBF1: TImageList;
    imgListMenu: TImageList;
    ImgListGraf: TImageList;
    MenuPrincipal: TMainMenu;
    Menu_arquivo: TMenuItem;
    Menu_Abrir: TMenuItem;
    Menu_Salvar: TMenuItem;
    Menu_SalvarComo: TMenuItem;
    Menu_GerarArquivos: TMenuItem;
    MenuPrincipal00_03_01: TMenuItem;
    MenuPrincipal00_03_02: TMenuItem;
    MenuPrincipal00_03_03: TMenuItem;
    N5: TMenuItem;
    MenuPrincipal00_03_04: TMenuItem;
    MenuPrincipal00_03_05: TMenuItem;
    MenuPrincipal00_03_06: TMenuItem;
    N6: TMenuItem;
    MenuPrincipal00_03_07: TMenuItem;
    MenuPrincipal00_03_08: TMenuItem;
    N4: TMenuItem;
    Menu_Sair: TMenuItem;
    Menu_Analise: TMenuItem;
    Menu_AnalisePorAgrupamento: TMenuItem;
    Menu_AnaliseDePeriodos: TMenuItem;
    Menu_Graficos: TMenuItem;
    Menu_Graf_CV: TMenuItem;
    Menu_Graf_CP: TMenuItem;
    Menu_Graf_DM: TMenuItem;
    Menu_Graf_Gantt: TMenuItem;
    Menu_Janelas: TMenuItem;
    Menu_LLH: TMenuItem;
    Menu_Cascata: TMenuItem;
    Menu_ArranjarIcones: TMenuItem;
    Menu_Ajuda: TMenuItem;
    MenuPrincipal05_01: TMenuItem;
    Menu_Ajuda_Equipe: TMenuItem;
    MainToolBar: TToolBar;
    ToolButton1: TToolButton;
    ImgListTBar: TImageList;
    BtnSalvarComo: TToolButton;
    ToolButton3: TToolButton;
    btnVerDados: TToolButton;
    btnOperacoesPostos: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    Menu_CalcularPostos: TMenuItem;
    btnEstatisca: TToolButton;
    ToolButton6: TToolButton;
    btnGraf: TToolButton;
    ToolButton5: TToolButton;
    Menu_Importar: TMenuItem;
    Exec: TExecFile;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    Menu_ObjsDaArvore: TPopupMenu;
    N2: TMenuItem;
    Messages: TRichEdit;
    Splitter2: TSplitter;
    Menu_MessageBar: TPopupMenu;
    Visualisar1: TMenuItem;
    Menu_InserirPostos: TMenuItem;
    N3: TMenuItem;
    Menu_Exportar: TMenuItem;
    Menu_Editar: TMenuItem;
    Menu_Editar_Props: TMenuItem;
    Menu_Utils: TMenuItem;
    Menu_Evap56: TMenuItem;
    Menu_Conversor: TMenuItem;
    N7: TMenuItem;
    Menu_Ajuda_Manuais: TMenuItem;
    Menu_Help_Evap56: TMenuItem;
    Menu_Help_UtilizacaoGeral: TMenuItem;
    N8: TMenuItem;
    Menu_BancoDeDados: TMenuItem;
    Menu_CriarConeccao: TMenuItem;
    Images: TImageList;
    N1: TMenuItem;
    Menu_FecharTodasJanelas: TMenuItem;
    Menu_LLV: TMenuItem;
    N9: TMenuItem;
    Menu_Grafico_Configuracoes: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ArvoreClick(Sender: TObject);
    procedure MenuGeral_AbrirClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Menu_Arvore_AEsqClick(Sender: TObject);
    procedure Menu_Arvore_AcimaClick(Sender: TObject);
    procedure MenuPrincipal00_03_07Click(Sender: TObject);
    procedure Menu_AbrirClick(Sender: TObject);
    procedure Menu_SalvarComoClick(Sender: TObject);
    procedure Menu_SalvarClick(Sender: TObject);
    procedure MenuPrincipal00_03_01Click(Sender: TObject);
    procedure MenuPrincipal00_03_02Click(Sender: TObject);
    procedure MenuPrincipal00_03_03Click(Sender: TObject);
    procedure MenuPrincipal00_03_04Click(Sender: TObject);
    procedure MenuPrincipal00_03_05Click(Sender: TObject);
    procedure MenuPrincipal00_03_06Click(Sender: TObject);
    procedure MenuPrincipal00_03_08Click(Sender: TObject);
    procedure MenuPrincipal02_00_00Click(Sender: TObject);
    procedure MenuPrincipal02_00_01Click(Sender: TObject);
    procedure Menu_AnalisePorAgrupamentoClick(Sender: TObject);
    procedure Menu_Graf_CVClick(Sender: TObject);
    procedure Menu_Graf_CPClick(Sender: TObject);
    procedure Menu_Graf_DMClick(Sender: TObject);
    procedure Menu_Graf_GanttClick(Sender: TObject);
    procedure Menu_LLH_Click(Sender: TObject);
    procedure Menu_Cascata_Click(Sender: TObject);
    procedure Menu_ArranjarIcones_Click(Sender: TObject);
    procedure Menu_Ajuda_EquipeClick(Sender: TObject);
    procedure Menu_CalcularPostosClick(Sender: TObject);
    procedure Menu_SairClick(Sender: TObject);
    procedure Menu_ImportarClick(Sender: TObject);
    procedure Menu_Posto_MaxAnuaisClick(Sender: TObject);
    procedure Menu_ObjsDaArvorePopup(Sender: TObject);
    procedure Menu_Posto_MinAnuaisClick(Sender: TObject);
    procedure ArvoreChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure Menu_VisBarraMesClick(Sender: TObject);
    procedure Menu_VisBarMesClick(Sender: TObject);
    procedure Menu_InserirPostosClick(Sender: TObject);
    procedure Menu_ExportarClick(Sender: TObject);
    procedure Menu_Editar_Props_Click(Sender: TObject);
    procedure Menu_Evap56Click(Sender: TObject);
    procedure Menu_ConversorClick(Sender: TObject);
    procedure ArvoreEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure ArvoreEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure ArvoreGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure ArvoreGetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure ArvoreAddition(Sender: TObject; Node: TTreeNode);
    procedure Menu_Help_UtilizacaoGeralClick(Sender: TObject);
    procedure Menu_Help_Evap56Click(Sender: TObject);
    procedure Menu_CriarConeccaoClick(Sender: TObject);
    procedure ArvoreExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure btnVerDadosClick(Sender: TObject);
    procedure ArvoreMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Menu_FecharTodasJanelas_Click(Sender: TObject);
    procedure Menu_AnaliseDePeriodos_Click(Sender: TObject);
    procedure Menu_LLV_Click(Sender: TObject);
    procedure ArvoreDBLClick(Sender: TObject);
    procedure Menu_Grafico_ConfiguracoesClick(Sender: TObject);
  private
    FnoDS                 : TTreeNode;
    FClasseSel            : TClass; // classe do nó selecionado
    FAcoesIndObjsDaArvore : TActionList;
    FAcoesColObjsDaArvore : TActionList;
    FFechando             : boolean;

    procedure Sair();

    // Gerenciamento dos Menus Dinamicos
    function CriarMenu(Acao: TBasicAction): TMenuItem;
    function CriarItemDeMenu(Raiz: TMenuItem; Texto: String; Evento: TNotifyEvent = nil): TMenuItem; overload;
    function CriarItemDeMenu(Raiz: TMenuItem; Acao: TBasicAction): TMenuItem; overload;
    function CriarSubMenus(Raiz: TMenuItem; Acao: TBasicAction; CriarItem: boolean): TMenuItem;

    // Gerenciamento da árvore
    function  OsOutrosSaoDescendentesDe(ClassRef: TClass): Boolean;
    function  ObterClasseDosObjetos(Ref: Pointer): TClass;
    function  ObterClasseDoNo(Obj: TObject): String;

    function  getInfoSel(): TDSInfo;
    function  getActiveField(): TStation;
  public
    property InfoSel : TDSInfo read getInfoSel;
    property ActiveField : TStation read getActiveField;
  end;

implementation
uses WinUtils,
     SysUtilsEx,
     FileUtils,
     TreeViewUtils,

     // Gerais
     pro_fo_getValidIntervals,
     pro_fo_ConnectionType,
     pro_Actions,
     pro_DB_Classes,

     // Análise dos períodos
     //pro_fo_FaultAnalysis,
     //pro_fo_YearAnalysis,
     pro_fo_AnalysisOfIntervals,
     pro_fo_GroupAnalysis,

     // Operações
     pro_fo_GenerateNewStations,
     pro_fo_InsertStation,
     pro_fo_DataImport,
     pro_fo_DataExport,

     // Edicoes
     pro_fo_Station_EditExtraData,

     //Geracao de arquivos,
     pro_fo_PLU_Generation,
     pro_fo_VZO_Generation,
     pro_fo_ETP_Generation,

     //Graficos
     pro_fo_PermanentCurve,
     pro_fo_PLU_VZO,
     pro_fo_DoubleMass,

     // Testes
     //Test_Frame,

     //About
     pro_fo_Abount;

{$R *.DFM}

{ TDLG_Principal }

procedure TDLG_Principal.FormCreate(Sender: TObject);
begin
  FnoDS := Arvore.Items[0];

  btnEstatisca.Enabled := False;
  btnGraf.Enabled      := False;

  // Acoes
  FAcoesIndObjsDaArvore := TActionList.Create(nil);
  FAcoesColObjsDaArvore := TActionList.Create(nil);
end;

function TDLG_Principal.ObterClasseDoNo(Obj: TObject): String;
begin
  if Obj is TDSInfo then Result := '' else
  if Obj is TStation  then Result := 'Posto' else
  //if Obj is TSerie then Result := TSerie(Obj).Classe;
end;

procedure TDLG_Principal.ArvoreChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
begin
  AllowChange := (Node.Data <> nil);
end;

function TDLG_Principal.OsOutrosSaoDescendentesDe(ClassRef: TClass): Boolean;
var i: Integer;
    o: TObject;
begin
  Result := True;
  for i := 1 to Arvore.SelectionCount-1 do
    begin
    o := TObject(Arvore.Selections[i].Data);
    if o = nil then Continue;
    if not o.InheritsFrom(ClassRef) then
       begin
       Result := False;
       Break;
       end;
    end;
end;

function TDLG_Principal.ObterClasseDosObjetos(Ref: Pointer): TClass;
var ob: TnoObjeto;

  function ClassesIguais(): Boolean;
  var i: Integer;
      o: TObject;
  begin
    Result := True;
    for i := 1 to Arvore.SelectionCount-1 do
      begin
      o := TObject(Arvore.Selections[i].Data);
      if (o = nil) or (o.ClassType <> ob.ClassType) then
         begin
         Result := False;
         Break;
         end;
      end;
  end;

begin
  ob := TnoObjeto(Ref);
  if ClassesIguais() then
     Result := ob.ClassType
  else
     begin // Obtém uma classe comum a todos
     Result := ob.ClassParent;
     while (Result <> nil) and not OsOutrosSaoDescendentesDe(Result) do
       Result := Result.ClassParent;
     end;
end;

procedure TDLG_Principal.ArvoreClick(Sender: TObject);
var No  : TTreeNode;
    Obj : TNoObjeto;

  procedure Menu_DataSetSel(Ok : Boolean);
  var Index : integer;
  begin
    Menu_Salvar                .Enabled := Ok;
    Menu_SalvarComo            .Enabled := Ok;
    Menu_GerarArquivos         .Enabled := Ok;
    Menu_Exportar              .Enabled := Ok;
    Menu_Analise               .Enabled := Ok;
    Menu_InserirPostos         .Enabled := Ok;
    Menu_CalcularPostos        .Enabled := Ok;
    Menu_AnaliseDePeriodos     .Enabled := Ok;
    Menu_AnalisePorAgrupamento .Enabled := Ok;
    Menu_Graf_Gantt            .Enabled := Ok;
    Menu_Graf_CP               .Enabled := Ok;
    Menu_Graf_DM               .Enabled := Ok;
    Menu_Graf_CV               .Enabled := Ok;

    if Ok then
       Menu_AnalisePorAgrupamento.Enabled := (TDSInfo(Obj).TipoIntervalo = tiDiario);
  end;

  procedure ToolBar_DataSetSel(Ok: boolean);
  begin
    BtnSalvarComo.Enabled := Ok;
    BtnEstatisca.Enabled := Ok;
    BtnGraf.Enabled := Ok;
    BtnOperacoesPostos.Enabled := Ok;
  end;

  procedure Menu_PostoSel(Ok : Boolean);
  begin
  end;

  procedure ToolBar_PostoSel(Ok: boolean);
  begin
  end;

  procedure Menu_SerieSel(Ok : Boolean);
  var Serie: TSerie;
  begin
  end;

  procedure ToolBar_EstatSel(Ok: boolean);
  begin
  end;

  function GerenciarMultiSelecao: Integer;
  begin
    if Arvore.SelectionCount = 0 then
       Result := 0
    else
    if Arvore.SelectionCount = 1 then
       begin
       FClasseSel := Obj.ClassType;
       Result := 1;
       end
    else
       begin
       FClasseSel := ObterClasseDosObjetos(Arvore.Selections[0].Data);
       Result := Arvore.SelectionCount;
       end;
  end;

var DS_Sel    : boolean;
    Posto_Sel : boolean;
    Serie_Sel : boolean;
    NumSels   : integer;
begin // ArvoreClick
  Arvore.PopupMenu := Menu_Arvore;
  no := Arvore.Selected;

  if (no = nil) or (no.Data = nil) then
     Exit;

  StatusBar.Panels.Clear();
  Messages.Lines.Clear();
  Obj := TNoObjeto(no.Data);

  NumSels := GerenciarMultiSelecao();
  if NumSels > 0 then
     begin
     Arvore.PopupMenu := Menu_ObjsDaArvore;

     if NumSels = 1 then
        begin
        WriteStatus(StatusBar, [Obj.ObterResumo()], false);
        Messages.Lines.Text := Obj.ObterDescricao();
        Messages.Invalidate();
        end
     else
        WriteStatus(StatusBar, [IntToStr(NumSels) + ' objetos selecionados'], false);

     // Um dataset foi selecionado
     DS_Sel := (Obj is TDSInfo);
     Menu_DataSetSel(DS_Sel);
     ToolBar_DataSetSel(DS_Sel);

     // Um posto foi selecionado
     Posto_Sel := (Obj is TStation);
     Menu_PostoSel(Posto_Sel);
     ToolBar_PostoSel(Posto_Sel);

     // Uma Serie foi selecionada
     Serie_Sel := (Obj is TSerie);
     Menu_serieSel(Serie_Sel);
     ToolBar_EstatSel(Serie_Sel);

     Menu_Editar_Props.Enabled := SysUtils.Supports(Obj, IEditable);

     BtnVerDados.Enabled := SysUtils.Supports(Obj, IVisualizableInSheet) or
                           (Obj is TDataSet);
     end;
end;

// Emula a selecao de nos pelo botao direito
procedure TDLG_Principal.ArvoreMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var no: TTreeNode;
begin
  if Button = mbRight then
     begin
     no := Arvore.GetNodeAt(X, Y);
     if (no <> nil) and (no.Data <> nil) then no.Selected := true;
     ArvoreClick(Sender);
     end;
end;

procedure TDLG_Principal.MenuGeral_AbrirClick(Sender: TObject);
var Info: TDSInfo;
    i: Integer;
begin
  if Open.Execute then
     for i := 0 to open.Files.Count-1 do
        if not Applic.IsOpen(open.Files[i]) then
           begin
           Info := TDSInfo.Create(open.Files[i]);
           Applic.AddInTree(Info);
           end
        else
           MessageDLG(open.Files[i] + #13'Arquivo já aberto !', mtInformation, [mbOK], 0);
end;

function TDLG_Principal.getInfoSel(): TDSInfo;
begin
  Result := TDSInfo(Arvore.Selected.Data);
end;

function TDLG_Principal.getActiveField(): TStation;
begin
  Result := TStation(Arvore.Selected.Data);
end;

procedure TDLG_Principal.Sair();
begin
  Application.Terminate();
end;

procedure TDLG_Principal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  FFechando := true;
  Sair();
end;

procedure TDLG_Principal.Menu_Arvore_AEsqClick(Sender: TObject);
begin
  Splitter1.Align := alLeft;
  paArvore.Align  := alLeft;
  paArvore.Width  := ClientWidth div 5;
  spArvore.Align  := alLeft;
  spArvore.Left   := paArvore.Left + paArvore.Width + 5;
  Arvore.Width    := 1;
end;

procedure TDLG_Principal.Menu_Arvore_AcimaClick(Sender: TObject);
begin
  paArvore.Align  := alTop;
  paArvore.Height := ClientHeight div 6;
  spArvore.Top    := paArvore.Top + paArvore.Height + 2;
  spArvore.Align  := alTop;
  Arvore.Height   := 1;
  Splitter1.Align := alTop;
end;

procedure TDLG_Principal.MenuPrincipal00_03_07Click(
  Sender: TObject);
begin
  TDLG_PLU.Create(InfoSel, 'RPL').ShowModal;
end;

procedure TDLG_Principal.Menu_AbrirClick(Sender: TObject);
var I    : Integer;
    Info : TDSInfo;
begin
  Open.InitialDir := Applic.LastDir;
  if Open.Execute() then
     begin
     if open.Files.Count > 0 then
        Applic.LastDir := ExtractFilePath(Open.Files[0]);

     for i := 0 to open.Files.Count-1 do
        if not Applic.IsOpen(open.Files[i]) and
               Applic.IsProcedaFile(open.Files[i], {out} Info) then
           Applic.AddInTree(Info)
        else
           MessageDLG(open.Files[i] + #13'Arquivo já aberto !', mtInformation, [mbOK], 0);
     end;
end;

procedure TDLG_Principal.Menu_SalvarComoClick(Sender: TObject);
begin
  Save.InitialDir := Applic.LastDir;
  if InfoSel.NomeArq <> '' then Save.FileName := InfoSel.NomeArq;
  if Save.Execute() then
     InfoSel.SaveToFile(Save.FileName);
end;

procedure TDLG_Principal.Menu_SalvarClick(Sender: TObject);
begin
  if InfoSel.NomeArq <> '' then
     InfoSel.SaveToFile(InfoSel.NomeArq)
  else
     Menu_SalvarComoClick(Sender);
end;

procedure TDLG_Principal.MenuPrincipal00_03_01Click(Sender: TObject);
begin
  TDLG_PLU.Create(InfoSel, 'PLU').ShowModal;
end;

procedure TDLG_Principal.MenuPrincipal00_03_02Click(Sender: TObject);
begin
  TDLG_VZO.Create(InfoSel, 'VZO').ShowModal;
end;

procedure TDLG_Principal.MenuPrincipal00_03_03Click(Sender: TObject);
begin
  TDLG_ETP.Create(InfoSel, 'ETP').ShowModal;
end;

procedure TDLG_Principal.MenuPrincipal00_03_04Click(
  Sender: TObject);
begin
  TDLG_PLU.Create(InfoSel, 'RPL').ShowModal;
end;

procedure TDLG_Principal.MenuPrincipal00_03_05Click(
  Sender: TObject);
begin
  TDLG_ETP.Create(InfoSel, 'RET').ShowModal;
end;

procedure TDLG_Principal.MenuPrincipal00_03_06Click(
  Sender: TObject);
begin
  TDLG_VZO.Create(InfoSel, 'VZC').ShowModal;
end;

procedure TDLG_Principal.MenuPrincipal00_03_08Click(
  Sender: TObject);
begin
  TDLG_VZO.Create(InfoSel, 'RVZ').ShowModal;
end;

procedure TDLG_Principal.MenuPrincipal02_00_00Click(Sender: TObject);
begin
  // Item Removido
  //TDLG_AnaliseDeFalhas.Create(InfoSel).ShowModal;
end;

procedure TDLG_Principal.MenuPrincipal02_00_01Click(Sender: TObject);
begin
  // Item Removido
  //TDLG_AnaliseAnual.Create(InfoSel).ShowModal;
end;

procedure TDLG_Principal.Menu_AnalisePorAgrupamentoClick(Sender: TObject);
begin
  TDLG_AnalisePorAgrupamento.Create(InfoSel).ShowModal;
end;

procedure TDLG_Principal.Menu_Graf_CVClick(Sender: TObject);
begin
  TGRF_chuvaXvazao.Create(InfoSel).ShowModal;
end;

procedure TDLG_Principal.Menu_Graf_CPClick(Sender: TObject);
begin
  TGRF_CurvaDePermanencia.Create(InfoSel).ShowModal();
end;

procedure TDLG_Principal.Menu_Graf_DMClick(Sender: TObject);
begin
  TGRF_DuplaMassa.Create(InfoSel).ShowModal;
end;

procedure TDLG_Principal.Menu_Graf_GanttClick(Sender: TObject);
begin
  ActionManager.DSInfo_Gantt(Sender);
end;

procedure TDLG_Principal.Menu_LLV_Click(Sender: TObject);
begin
  TileMode := tbVertical;
  Tile();
end;

procedure TDLG_Principal.Menu_LLH_Click(Sender: TObject);
begin
  TileMode := tbHorizontal;
  Tile();
end;

procedure TDLG_Principal.Menu_Cascata_Click(Sender: TObject);
begin
  Cascade();
end;

procedure TDLG_Principal.Menu_ArranjarIcones_Click(Sender: TObject);
begin
  ArrangeIcons();
end;

procedure TDLG_Principal.Menu_Ajuda_EquipeClick(Sender: TObject);
var About: TfoAbout;
begin
  Application.CreateForm(TfoAbout, About);
  About.ShowModal;
  About.Free;
end;

procedure TDLG_Principal.Menu_CalcularPostosClick(Sender: TObject);
begin
  if TDLG_CalcularNovosPostos.Create(InfoSel).ShowModal = mrOk then
     Applic.UpdateProperties(InfoSel);
end;

procedure TDLG_Principal.Menu_SairClick(Sender: TObject);
begin
  Sair();
end;

procedure TDLG_Principal.Menu_ImportarClick(Sender: TObject);
begin
  with TfoDataImport.Create() do
    begin
    ShowModal();
    Release();
    end;
end;

procedure TDLG_Principal.Menu_ObjsDaArvorePopup(Sender: TObject);
var Menu      : TMenuItem;
    i, k      : Integer;
    Instancia : TNoObjeto;
    act       : TContainedAction;
begin
  Menu_ObjsDaArvore.Items.Clear;

  FreeAndNil(FAcoesIndObjsDaArvore);
  FreeAndNil(FAcoesColObjsDaArvore);
  FAcoesIndObjsDaArvore := TActionList.Create(nil);
  FAcoesColObjsDaArvore := TActionList.Create(nil);

  // obtém uma instância da classe dos objetos selecionados
  Instancia := TNoObjeto(FClasseSel.NewInstance);
  Instancia.ObterAcoesIndividuais(FAcoesIndObjsDaArvore);
  Instancia.ObterAcoesColetivas(FAcoesColObjsDaArvore);
  Instancia.FreeInstance();

  k := 0;
  if FAcoesIndObjsDaArvore.ActionCount > 0 then
     begin
     Menu := TMenuItem.Create(nil);
     Menu.Caption := 'Ações Individuais';
     Menu_ObjsDaArvore.Items.Add(Menu); // --> Item 0 de Menu_ObjsDaArvore

     for i := 0 to FAcoesIndObjsDaArvore.ActionCount-1 do
       begin
       act := FAcoesIndObjsDaArvore[i];
       Menu := CriarItemDeMenu(Menu_ObjsDaArvore.Items[k], act);
       CriarSubMenus(Menu, act, false);
       end;

     inc(k);
     end;

  if {(Arvore.SelectionCount > 1) and} (FAcoesColObjsDaArvore.ActionCount > 0) then
     begin
     Menu := TMenuItem.Create(nil);
     Menu.Caption := 'Ações Coletivas';
     Menu_ObjsDaArvore.Items.Add(Menu); // --> Item 1 de Menu_ObjsDaArvore

     for i := 0 to FAcoesColObjsDaArvore.ActionCount-1 do
       begin
       act := FAcoesColObjsDaArvore[i];
       Menu := CriarItemDeMenu(Menu_ObjsDaArvore.Items[k], act);
       CriarSubMenus(Menu, act, false);
       end;
     end;
end;

// **************************** Series dos Postos *****************************

procedure TDLG_Principal.Menu_Posto_MaxAnuaisClick(Sender: TObject);
begin
  ActionManager.SerieVetor_Ind_CriarMaximosDiariosAnuais(Sender);
end;

procedure TDLG_Principal.Menu_Posto_MinAnuaisClick(Sender: TObject);
begin
  ActionManager.SerieVetor_Ind_CriarMinimosDiariosAnuais(Sender);
end;

procedure TDLG_Principal.FormDestroy(Sender: TObject);
begin
  FAcoesIndObjsDaArvore.Free;
  FAcoesColObjsDaArvore.Free;
end;

procedure TDLG_Principal.Menu_VisBarraMesClick(Sender: TObject);
begin
  Messages.Visible := true;
end;

procedure TDLG_Principal.Menu_VisBarMesClick(Sender: TObject);
begin
  Menu_VisBarraMesClick(nil);
end;

procedure TDLG_Principal.Menu_InserirPostosClick(Sender: TObject);
var d: TfoInsertStation;
begin
  d := TfoInsertStation.Create(InfoSel);
  d.ShowModal();
  d.Free();
end;

procedure TDLG_Principal.Menu_ExportarClick(Sender: TObject);
begin
  with TfoDataExport.Create(InfoSel) do
    begin
    ShowModal();
    Release()
    end;
end;

procedure TDLG_Principal.Menu_Editar_Props_Click(Sender: TObject);
var o: TObject;
    i: IEditable;
begin
  o := TObject(Arvore.Selected.Data);
  if SysUtils.Supports(o, IEditable, i) then
     i.Edit();
end;

procedure TDLG_Principal.Menu_Evap56Click(Sender: TObject);
begin
  Exec.CommandLine := Applic.AppDir + 'Tools\Evap 56\Evap56.exe';
  Exec.Execute();
end;                                                              

procedure TDLG_Principal.Menu_ConversorClick(Sender: TObject);
begin
  Exec.CommandLine := Applic.AppDir + 'Tools\Conversor\Chuvaz_to_Proceda.exe';
  Exec.Execute();
end;

function TDLG_Principal.CriarItemDeMenu(Raiz: TMenuItem; Texto: String; Evento: TNotifyEvent): TMenuItem;
begin
  Result := TMenuItem.Create(nil);
  Result.AutoHotkeys := maManual;
  Result.Caption := Texto;
  Result.OnClick := Evento;
  Raiz.Add(Result);
end;

function TDLG_Principal.CriarItemDeMenu(Raiz: TMenuItem; Acao: TBasicAction): TMenuItem;
begin
  Result := CriarMenu(Acao);
  Raiz.Add(Result);
end;

function TDLG_Principal.CriarMenu(Acao: TBasicAction): TMenuItem;
begin
  Result := TMenuItem.Create(nil);
  Result.AutoHotkeys := maManual;
  Result.Enabled := TAction(Acao).Enabled;
  Result.Caption := TAction(Acao).Caption;
  Result.OnClick := TAction(Acao).OnExecute;
  Result.Checked := TAction(Acao).Checked;
  Result.Tag := TAction(Acao).Tag;
end;

function TDLG_Principal.CriarSubMenus(Raiz: TMenuItem; Acao: TBasicAction; CriarItem: boolean): TMenuItem;
var i: Integer;
begin
  if CriarItem then
     begin
     Result := CriarMenu(Acao);
     Raiz.Add(Result);
     end
  else
     Result := Raiz;

  for i := 0 to Acao.ComponentCount-1 do
    CriarSubMenus(Result, TAction(Acao.Components[i]), true)
end;

procedure TDLG_Principal.ArvoreEditing(Sender: TObject; Node: TTreeNode; var AllowEdit: Boolean);
var o: TNoObjeto;
begin
  o := TNoObjeto(Node.Data);
  if o <> nil then
     AllowEdit := o.NoPodeSerEditado()
  else
     AllowEdit := false;
end;

procedure TDLG_Principal.ArvoreEdited(Sender: TObject; Node: TTreeNode; var S: String);
var o: TNoObjeto;
begin
  o := TNoObjeto(Node.Data);
  if o <> nil then
     o.TextoDoNoMudou(S);
end;

procedure TDLG_Principal.ArvoreGetImageIndex(Sender: TObject; Node: TTreeNode);
var o: TNoObjeto;
begin
  o := TNoObjeto(Node.Data);
  if not FFechando and (o <> nil) then
     Node.ImageIndex := o.ObterIndiceDaImagem();
end;

procedure TDLG_Principal.ArvoreGetSelectedIndex(Sender: TObject; Node: TTreeNode);
var o: TNoObjeto;
begin
  o := TNoObjeto(Node.Data);
  if not FFechando and (o <> nil) then
     Node.SelectedIndex := o.ObterIndiceDaImagemSelecionada();
end;

procedure TDLG_Principal.ArvoreAddition(Sender: TObject; Node: TTreeNode);
var o: TNoObjeto;
begin
  o := TNoObjeto(Node.Data);
  if o <> nil then
     begin
     o.EstabelecerNo(Node);
     Node.Text := o.ObterTextoDoNo();
     end;
end;

procedure TDLG_Principal.Menu_Help_UtilizacaoGeralClick(Sender: TObject);
var s: String;
begin
  s := Applic.AppDir + 'help\Mini-Manual de Utilizacao\Utilizacao Geral.html';
  ShellAPI.ShellExecute(self.Handle, 'OPEN', pChar(s), '', '', SW_SHOW);
end;

procedure TDLG_Principal.Menu_Help_Evap56Click(Sender: TObject);
var s: String;
begin
  s := Applic.AppDir + 'help\Mini-Manual - Interacao com o Programa Evap-56\Mini-Manual.html';
  ShellAPI.ShellExecute(self.Handle, 'OPEN', pChar(s), '', '', SW_SHOW);
end;

procedure TDLG_Principal.Menu_CriarConeccaoClick(Sender: TObject);
var db: TDatabase;
    ct: string;
begin
  ct := TfoConnectionType.getConnectionType();
  if ct <> '' then
     begin
     db := Applic.Databases.CreateConnection(ct);
     if db <> nil then
        begin
        Applic.AddDatabase(db);
        WriteStatus(StatusBar, ['Conecção criada com sucesso: ' + db.Name], false);
        end
     else
        Applic.Messages.ShowError('Conecção não realizada');
     end;
end;

procedure TDLG_Principal.ArvoreExpanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
begin
  if TObject(Node.Data) is TTable then
     TTable(Node.Data).ShowProperties(Arvore, Node);
end;

procedure TDLG_Principal.btnVerDadosClick(Sender: TObject);
var o: TObject;
    i: IVisualizableInSheet;
begin
  o := TObject(Arvore.Selected.Data);
  if SysUtils.Supports(o, IVisualizableInSheet, i) then
     i.ShowInSheet()
  else
     if o is TDataSet then
        TDataSet(o).View();
end;

procedure TDLG_Principal.Menu_FecharTodasJanelas_Click(Sender: TObject);
begin
  while self.MDIChildCount > 0 do
    begin
    self.MDIChildren[0].Close();
    Applic.ProcessMessages();
    end;
end;

procedure TDLG_Principal.Menu_AnaliseDePeriodos_Click(Sender: TObject);
var d: TfoAnaliseDePeriodos;
begin
  d := TfoAnaliseDePeriodos.Create(nil);
  d.frame.Info := getInfoSel();
  d.ShowModal();
  d.Release();
end;

procedure TDLG_Principal.ArvoreDBLClick(Sender: TObject);
var no: TTreeNode;
    Obj: TNoObjeto;
begin
  no := Arvore.Selected;
  if (no = nil) or (no.Data = nil) then Exit;
  Obj := TNoObjeto(no.Data);
  Obj.ExecutarAcaoPadrao();
end;

procedure TDLG_Principal.Menu_Grafico_ConfiguracoesClick(Sender: TObject);
begin
  Applic.ShowChartSetupDialog();
end;

end.
