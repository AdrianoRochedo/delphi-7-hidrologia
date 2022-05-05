unit Principal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, ComCtrls, Grids, StdCtrls, Buttons, ActnList,
  ImgList, FileCtrl, IniFiles, ToolWin, Contnrs, Execfile, 
  ch_Tipos;

type
  TDLG_Principal = class(TForm)
    spArvore: TSplitter;
    paArvore: TPanel;
    Arvore: TTreeView;
    StatusBar: TStatusBar;
    Splitter1: TSplitter;
    ControlBar1: TControlBar;
    TbMenu: TToolBar;
    Open: TOpenDialog;
    Save: TSaveDialog;
    MenuCampos: TPopupMenu;
    Ordenar1: TMenuItem;
    Menu_NaoOrdenar: TMenuItem;
    Menu_Crescente: TMenuItem;
    Menu_Decrescente: TMenuItem;
    Imagens: TImageList;
    Menu_Arvore: TPopupMenu;
    Menu_Arvore_AEsq: TMenuItem;
    Menu_Arvore_Acima: TMenuItem;
    imgListBF1: TImageList;
    imgListMenu: TImageList;
    ImgListGraf: TImageList;
    MenuPrincipal: TMainMenu;
    Menu_arquivo: TMenuItem;
    MenuPrincipal00_00: TMenuItem;
    MenuPrincipal00_01: TMenuItem;
    MenuPrincipal00_02: TMenuItem;
    MenuPrincipal00_03: TMenuItem;
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
    MenuPrincipal00_06: TMenuItem;
    MenuPrincipal01: TMenuItem;
    MenuPrincipal01_00: TMenuItem;
    MenuPrincipal01_03: TMenuItem;
    N7: TMenuItem;
    MenuPrincipal02: TMenuItem;
    MenuPrincipal02_00: TMenuItem;
    MenuPrincipal02_00_00: TMenuItem;
    MenuPrincipal02_00_01: TMenuItem;
    MenuPrincipal02_00_02: TMenuItem;
    MenuPrincipal02_01: TMenuItem;
    MenuPrincipal03: TMenuItem;
    MenuPrincipal03_00: TMenuItem;
    MenuPrincipal03_01: TMenuItem;
    MenuPrincipal03_02: TMenuItem;
    Menu_Graficos_Gantt: TMenuItem;
    MenuPrincipal04: TMenuItem;
    MenuPrincipal04_00: TMenuItem;
    MenuPrincipal04_01: TMenuItem;
    MenuPrincipal04_02: TMenuItem;
    MenuPrincipal04_03: TMenuItem;
    MenuPrincipal05: TMenuItem;
    MenuPrincipal05_00: TMenuItem;
    MenuPrincipal05_01: TMenuItem;
    MenuPrincipal05_02: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ImgListTBar: TImageList;
    BtnSalvarComo: TToolButton;
    ToolButton3: TToolButton;
    btnDados: TToolButton;
    btnOperacoesPostos: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    MenuPrincipal02_03: TMenuItem;
    btnEstatisca: TToolButton;
    ToolButton6: TToolButton;
    btnGraf: TToolButton;
    ToolButton5: TToolButton;
    MenuPrincipal01_04: TMenuItem;
    MenuPrincipal00_05: TMenuItem;
    ExecGerenteBd: TExecFile;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    N1: TMenuItem;
    Menu_ObjsDaArvore: TPopupMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ArvoreClick(Sender: TObject);
    procedure MenuGeral_AbrirClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Menu_Arvore_AEsqClick(Sender: TObject);
    procedure Menu_Arvore_AcimaClick(Sender: TObject);
    procedure Tile1Click(Sender: TObject);
    procedure Cascade1Click(Sender: TObject);
    procedure Arrangeicons1Click(Sender: TObject);
    procedure MenuPrincipal00_03_07Click(Sender: TObject);
    procedure MenuPrincipal00_00Click(Sender: TObject);
    procedure MenuPrincipal00_02Click(Sender: TObject);
    procedure MenuPrincipal00_01Click(Sender: TObject);
    procedure MenuPrincipal02_02Click(Sender: TObject);
    procedure MenuPrincipal00_03_01Click(Sender: TObject);
    procedure MenuPrincipal00_03_02Click(Sender: TObject);
    procedure MenuPrincipal00_03_03Click(Sender: TObject);
    procedure MenuPrincipal00_03_04Click(Sender: TObject);
    procedure MenuPrincipal00_03_05Click(
      Sender: TObject);
    procedure MenuPrincipal00_03_06Click(
      Sender: TObject);
    procedure MenuPrincipal00_03_08Click(Sender: TObject);
    procedure MenuPrincipal01_00Click(Sender: TObject);
    procedure MenuPrincipal01_01Click(Sender: TObject);
    procedure MenuPrincipal02_00_00Click(Sender: TObject);
    procedure MenuPrincipal02_00_01Click(Sender: TObject);
    procedure MenuPrincipal02_00_02Click(Sender: TObject);
    procedure MenuPrincipal02_01Click(Sender: TObject);
    procedure MenuPrincipal03_00Click(Sender: TObject);
    procedure MenuPrincipal03_01Click(Sender: TObject);
    procedure MenuPrincipal03_02Click(Sender: TObject);
    procedure Menu_Graficos_GanttClick(Sender: TObject);
    procedure MenuPrincipal04_00Click(Sender: TObject);
    procedure MenuPrincipal04_01Click(Sender: TObject);
    procedure MenuPrincipal04_02Click(Sender: TObject);
    procedure MenuPrincipal04_03Click(Sender: TObject);
    procedure MenuPrincipal05_02Click(Sender: TObject);
    procedure MenuPrincipal02_03Click(Sender: TObject);
    procedure MenuPrincipal00_06Click(Sender: TObject);
    procedure MenuPrincipal01_04Click(Sender: TObject);
    procedure MenuPrincipal00_05Click(Sender: TObject);
    procedure Menu_Posto_MaxAnuaisClick(Sender: TObject);
    procedure Menu_ObjsDaArvorePopup(Sender: TObject);
    procedure Menu_Posto_MinAnuaisClick(Sender: TObject);
    procedure ArvoreChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
    procedure FormDestroy(Sender: TObject);
  private
    FnoDS                 : TTreeNode;
    Ini                   : TIniFile;
    FClasseSel            : TClass; // classe do nó selecionado
    FAcoesIndObjsDaArvore : TActionList;
    FAcoesColObjsDaArvore : TActionList;

    procedure Sair;
    procedure CloseAllWindows;

    // Gerenciamento da árvore
    function  OsOutrosSaoDescendentesDe(ClassRef: TClass): Boolean;
    function  ObterClasseDosObjetos(Ref: Pointer): TClass;
    function  ObterClasseDoNo(Obj: TObject): String;
    procedure IncluirNaArvore(Info: TDSInfo);
    procedure AdicionarSerieNaArvore(noPai: TTreeNode; Serie: TSerie);
    procedure MostrarPropriedades(Info: TDSInfo; NoPai: TTreeNode);
    procedure AtualizarPropriedades(Info: TDSInfo);
    procedure Fechar(No: TTreeNode);

    function  EstaAberto(const NomeArq: String): Boolean;
    function  getInfoSel: TDSInfo;
  public
    property InfoSel : TDSInfo read getInfoSel;
  end;

implementation
uses WinUtils,
     SysUtilsEx,
     FileUtils,
     TreeViewUtils,
     drPlanilha,
     ObterPeriodosValidos,
     ch_Acoes,

     // Análise dos períodos
     AnaliseDasFalhas,
     AnaliseAnual,
     AnalisePorAgrupamento,

     //Edição
     OpcoesDeImpressao,

     // Operações
     CalculoDeNovosPostos,

     //CriarPosto,
     PLU,
     VZO,
     ETP,

     //Graficos
     Graf_CurvaDePermanencia_OPT,
     Graf_ChuvaXvazao_OPT,
     Graf_DuplaMassa_OPT,

     //About
     FormAbout, pro_fo_DataImport;

{$R *.DFM}

{ TDLG_Principal }

procedure TDLG_Principal.Fechar(No: TTreeNode);
var Info: TDSInfo;
    Res: Integer;
begin
  Info := TDSInfo(No.Data);
  if Info.DS.Modified then
     begin
     Res := MessageDLG(Info.NomeArq + #13'Dados modificados. Salvar as alterações ?',
            mtConfirmation, [mbYes, mbNo, mbCancel], 0);
     if Res = mrCancel then Exit;
     if Res = mrYes then Info.DS.SaveToFile(Info.NomeArq);
    end;
  Info.Free;
  No.Delete;
end;

procedure TDLG_Principal.AdicionarSerieNaArvore(noPai: TTreeNode; Serie: TSerie);
var NoTemp: TTreeNode;
begin
  noTemp := Arvore.Items.AddChildObject(noPai, Serie.Nome, Serie);
  SetImageIndex(noTemp, 6);
end;

procedure TDLG_Principal.MostrarPropriedades(Info: TDSInfo; NoPai: TTreeNode);
var no2, no3: TTreeNode;
    i, k: Integer;
    Posto: TPosto;
begin
  NoPai.DeleteChildren;

  no2 := Arvore.Items.AddChild(NoPai, 'Postos: ' + intToStr(Info.NumPostos));
  SetImageIndex(no2, 5);
  for i := 0 to Info.NumPostos-1 do
    begin
    Posto := Info.PostoPeloIndice(i);
    no3 := Arvore.Items.AddChildObject(no2, Posto.Nome, Posto);
    SetImageIndex(no3, 4);

    // Series do Posto i
    for k := 0 to Posto.Series.NumSeries-1 do
      AdicionarSerieNaArvore(no3, Posto.Series[k]);
    end;

  no2 := Arvore.Items.AddChild(NoPai, 'Arquivo: ');
  SetImageIndex(no2, 5);
  no2 := Arvore.Items.AddChild(no2, Info.NomeArq);
  SetImageIndex(no2, 5);

  no2 := Arvore.Items.AddChild(NoPai, 'Registros: ' + IntToStr(Info.DS.nRows));
  SetImageIndex(no2, 5);

  no2 := Arvore.Items.AddChild(NoPai, 'Data Inicial: ' + DateToStr(Info.DataInicial));
  SetImageIndex(no2, 5);

  no2 := Arvore.Items.AddChild(NoPai, 'Data Final: ' + DateToStr(Info.DataFinal));
  SetImageIndex(no2, 5);

  no2 := Arvore.Items.AddChild(NoPai, 'Tipo do Intervalo: ' + TipoIntervaloToStr(Info.TipoIntervalo));
  SetImageIndex(no2, 5);

  no2 := Arvore.Items.AddChild(NoPai, 'Tipo dos Dados: ' + TipoDadosToStr(Info.TipoDados));
  SetImageIndex(no2, 5);
end;


procedure TDLG_Principal.AtualizarPropriedades(Info: TDSInfo);
var no: TTreeNode;
begin
  no := FindNode(FNoDS, Info);
  MostrarPropriedades(Info, no);
  no.Expand(True);
end;

procedure TDLG_Principal.IncluirNaArvore(Info: TDSInfo);
var no: TTreeNode;
begin
  no := Arvore.Items.AddChildObject(FnoDS, ExtractFileName(Info.NomeArq), Info);
  SetImageIndex(no, 1);
  MostrarPropriedades(Info, no);
  FnoDS.Expand(False);
end;

function TDLG_Principal.EstaAberto(const NomeArq: String): Boolean;
var i: Integer;
begin
  Result := False;
  for i := 0 to FnoDS.Count-1 do
    if CompareText(FnoDS[i].Text, NomeArq) = 0 then
       begin
       Result := True;
       Break;
       end;
end;

procedure TDLG_Principal.FormCreate(Sender: TObject);
begin
  Ini   := TIniFile.Create('E:\Projetos\Hidrologia\Programas\Comum\Config\config.ini');
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
  if Obj is TPosto  then Result := 'Posto' else
  //if Obj is TSerie then Result := TSerie(Obj).Classe;
end;

procedure TDLG_Principal.ArvoreChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
begin
  AllowChange := (Node.Data <> nil);
end;

function TDLG_Principal.OsOutrosSaoDescendentesDe(ClassRef: TClass): Boolean;
var i: Integer;
begin
  Result := True;
  for i := 1 to Arvore.SelectionCount-1 do
    if not TObject(Arvore.Selections[i].Data).InheritsFrom(ClassRef) then
       begin
       Result := False;
       Break;
       end;
end;

function TDLG_Principal.ObterClasseDosObjetos(Ref: Pointer): TClass;
var ob: TnoObjeto;

  function ClassesIguais: Boolean;
  var i: Integer;
  begin
    Result := True;
    for i := 1 to Arvore.SelectionCount-1 do
      if TObject(Arvore.Selections[i].Data).ClassType <> ob.ClassType then
         begin
         Result := False;
         Break;
         end;
  end;

begin
  ob := TnoObjeto(Ref);
  if ClassesIguais then
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
    with MenuPrincipal.Items[00] do
      begin
      Items[01].Enabled := Ok;
      Items[02].Enabled := Ok;
      for Index := 0 to Items[03].Count - 1 do
        Items[03].Items[Index].Enabled :=OK;
      end;

    with MenuPrincipal.Items[01] do
      begin
      Items[01].Enabled := OK;
      Items[02].Enabled := OK;
      end;

    //Menu02
    with MenuPrincipal.Items[02] do
      begin
      for Index := 0 to Items[00].Count - 1  do
        Items[00].Items[Index].Enabled := Ok;
      for Index := 1 to Count - 1 do
        Items[Index].Enabled := Ok;
      end;

    with MenuPrincipal.Items[03] do
      begin
      for Index := 0 to Count -1 do
        Items[Index].Enabled := Ok;
      end;
  end;

  procedure ToolBar_DataSetSel(Ok: boolean);
  begin
    BtnSalvarComo.Enabled := Ok;
    BtnEstatisca.Enabled := Ok;
    BtnGraf.Enabled := Ok;
    BtnDados.Enabled := Ok;
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
  if no = nil then exit;
  StatusBar.Panels.Clear;
  Obj := TNoObjeto(no.Data);

  NumSels := GerenciarMultiSelecao;
  if NumSels > 0 then
     begin
     Arvore.PopupMenu := Menu_ObjsDaArvore;

     if NumSels = 1 then
        WriteStatus(StatusBar, [Obj.ObterResumo], false)
     else
        WriteStatus(StatusBar, [IntToStr(NumSels) + ' objetos selecionados'], false);

     // Um dataset foi selecionado
     DS_Sel := (Obj is TDSInfo);
     Menu_DataSetSel(DS_Sel);
     ToolBar_DataSetSel(DS_Sel);

     // Um posto foi selecionado
     Posto_Sel := (Obj is TPosto);
     Menu_PostoSel(Posto_Sel);
     ToolBar_PostoSel(Posto_Sel);

     // Uma Serie foi selecionada
     Serie_Sel := (Obj is TSerie);
     Menu_serieSel(Serie_Sel);
     ToolBar_EstatSel(Serie_Sel);
     end;
end;

procedure TDLG_Principal.MenuGeral_AbrirClick(Sender: TObject);
var Info: TDSInfo;
    i: Integer;
begin
  if Open.Execute then
     for i := 0 to open.Files.Count-1 do
        if not EstaAberto(open.Files[i]) then
           begin
           Info := TDSInfo.Create(open.Files[i]);
           IncluirNaArvore(Info);
           end
        else
           MessageDLG(open.Files[i] + #13'Arquivo já aberto !', mtInformation, [mbOK], 0);
end;

function TDLG_Principal.getInfoSel: TDSInfo;
begin
  Result := TDSInfo(Arvore.Selected.Data);
end;

procedure TDLG_Principal.Sair;
begin
  CloseAllWindows;
  Application.Terminate;
end;

procedure TDLG_Principal.CloseAllWindows;
var Index : integer;
begin
  for Index := FNoDS.Count-1 downto 0 do
    Fechar(FNoDS[Index]);
end;

procedure TDLG_Principal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Sair;
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

procedure TDLG_Principal.Tile1Click(Sender: TObject);
begin
  Tile;
end;

procedure TDLG_Principal.Cascade1Click(Sender: TObject);
begin
  Cascade;
end;

procedure TDLG_Principal.Arrangeicons1Click(Sender: TObject);
begin
  ArrangeIcons;
end;


procedure TDLG_Principal.MenuPrincipal00_03_07Click(
  Sender: TObject);
begin
  TDLG_PLU.Create(InfoSel, 'RPL').ShowModal;
end;

procedure TDLG_Principal.MenuPrincipal00_00Click(Sender: TObject);
var I    : Integer;
    Info : TDSInfo;
begin
  Open.InitialDir := Applic.LastDir;
  if Open.Execute then
     begin
     if open.Files.Count > 0 then
        Applic.LastDir := ExtractFilePath(Open.Files[0]);

     for i := 0 to open.Files.Count-1 do
        if not EstaAberto(open.Files[i]) then
           begin
           Info := TDSInfo.Create(open.Files[i]);
           IncluirNaArvore(Info);
           end
        else
           MessageDLG(open.Files[i] + #13'Arquivo já aberto !', mtInformation, [mbOK], 0);
     end;
end;

procedure TDLG_Principal.MenuPrincipal00_02Click(Sender: TObject);
begin
  if Save.Execute then
     begin
     InfoSel.DS.SaveToFile(Save.FileName);
     Ini.WriteString('DirBD','Save.InitialDir','C:\');
     end;
end;

procedure TDLG_Principal.MenuPrincipal00_01Click(Sender: TObject);
begin
  InfoSel.DS.SaveToFile(InfoSel.DS.FileName);
end;

procedure TDLG_Principal.MenuPrincipal02_02Click(Sender: TObject);
begin
{
  if TDLG_CriarPosto.Create(InfoSel).ShowModal = mrOk then
     AtualizarPropriedades(InfoSel);
}
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

procedure TDLG_Principal.MenuPrincipal01_00Click(Sender: TObject);
begin
  Applic.OutPut.Editor.Show();
end;

procedure TDLG_Principal.MenuPrincipal01_01Click(Sender: TObject);
var d: TDLG_OpcoesDeImpressao;
    SL: TStrings;
begin
(*
  d := TDLG_OpcoesDeImpressao.Create(nil);
  if d.ShowModal = mrCancel then
     begin
     d.Free;
     exit;
     end;

  InfoSel.DS.ImprimirPorData      := d.rbPorData.Checked;
  //InfoSel.DS.CalcularEstatisticas := d.cbEstatisticas.Checked; <<<<<
  InfoSel.DS.PrintOptions.Center  := d.rbCentralizado.Checked;

  d.Free;

  Applic.OutPut.Editor.NewPage;
  Screen.Cursor := crHourGlass;
  try
    SL := TStringList.Create;
    InfoSel.DS.Print(SL);
    Applic.OutPut.Editor.WriteStrings(SL);
    Applic.OutPut.Editor.Show;
    //InfoSel.DS.CalcularEstatisticas := False;
  finally
    Screen.Cursor := crDefault;
    SL.Free;
  end;
*)  
end;

procedure TDLG_Principal.MenuPrincipal02_00_00Click(Sender: TObject);
begin
  TDLG_AnaliseDeFalhas.Create(InfoSel).ShowModal;
end;

procedure TDLG_Principal.MenuPrincipal02_00_01Click(Sender: TObject);
begin
  TDLG_AnaliseAnual.Create(InfoSel).ShowModal;
end;

procedure TDLG_Principal.MenuPrincipal02_00_02Click(Sender: TObject);
begin
  TDLG_AnalisePorAgrupamento.Create(InfoSel).ShowModal;
end;

procedure TDLG_Principal.MenuPrincipal02_01Click(Sender: TObject);
begin
  TDLG_ObterPeriodosValidos.Create(InfoSel).ShowModal;
end;

procedure TDLG_Principal.MenuPrincipal03_00Click(Sender: TObject);
begin
  TGRF_chuvaXvazao.Create(InfoSel).ShowModal;
end;

procedure TDLG_Principal.MenuPrincipal03_01Click(Sender: TObject);
begin
  TGRF_CurvaDePermanencia.Create(InfoSel).ShowModal;
end;

procedure TDLG_Principal.MenuPrincipal03_02Click(Sender: TObject);
begin
  TGRF_DuplaMassa.Create(InfoSel).ShowModal;
end;

procedure TDLG_Principal.Menu_Graficos_GanttClick(Sender: TObject);
begin
  ActionManager.DSInfo_Gantt(Sender);
end;

procedure TDLG_Principal.MenuPrincipal04_00Click(Sender: TObject);
begin
  Tile;
end;

procedure TDLG_Principal.MenuPrincipal04_01Click(Sender: TObject);
begin
  Cascade;
end;

procedure TDLG_Principal.MenuPrincipal04_02Click(Sender: TObject);
begin
  ArrangeIcons;
end;

procedure TDLG_Principal.MenuPrincipal04_03Click(Sender: TObject);
begin
  CloseAllWindows;
end;

procedure TDLG_Principal.MenuPrincipal05_02Click(Sender: TObject);
begin
  Application.CreateForm(TFAbout,FAbout);
  FAbout.ShowModal;
  FAbout.Free;
end;

procedure TDLG_Principal.MenuPrincipal02_03Click(Sender: TObject);
begin
  if TDLG_CalcularNovosPostos.Create(InfoSel).ShowModal = mrOk then
     AtualizarPropriedades(InfoSel);
end;

procedure TDLG_Principal.MenuPrincipal00_06Click(Sender: TObject);
begin
  Sair;
end;

procedure TDLG_Principal.MenuPrincipal01_04Click(Sender: TObject);
var Ok : boolean;
begin
  Ok := MenuPrincipal01_04.Checked;
  ToolBar1.Visible := Ok;
  if Ok then
     ControlBar1.Height := 83
  else
     ControlBar1.Height := TbMenu.Height + 6;
end;

procedure TDLG_Principal.MenuPrincipal00_05Click(Sender: TObject);
begin
  with TfoDataImport.Create() do
    begin
    ShowModal();
    Release();
    end;
end;

procedure TDLG_Principal.Menu_ObjsDaArvorePopup(Sender: TObject);
var Menu      : TMenuItem;
    i         : Integer;
    Instancia : TNoObjeto;
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
  Instancia.FreeInstance;

  if FAcoesIndObjsDaArvore.ActionCount > 0 then
     begin
     Menu := TMenuItem.Create(nil);
     Menu.Caption := 'Ações Individuais';
     Menu_ObjsDaArvore.Items.Add(Menu); // --> Item 0 de Menu_ObjsDaArvore

     for i := 0 to FAcoesIndObjsDaArvore.ActionCount-1 do
       begin
       Menu := TMenuItem.Create(nil);
       Menu.Action := FAcoesIndObjsDaArvore[i];
       Menu_ObjsDaArvore.Items[0].Add(Menu);
       end;
     end;

  if (Arvore.SelectionCount > 1) and (FAcoesColObjsDaArvore.ActionCount > 0) then
     begin
     Menu := TMenuItem.Create(nil);
     Menu.Caption := 'Ações Coletivas';
     Menu_ObjsDaArvore.Items.Add(Menu); // --> Item 1 de Menu_ObjsDaArvore

     for i := 0 to FAcoesColObjsDaArvore.ActionCount-1 do
       begin
       Menu := TMenuItem.Create(nil);
       Menu.Action := FAcoesColObjsDaArvore[i];
       Menu_ObjsDaArvore.Items[1].Add(Menu);
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

end.
