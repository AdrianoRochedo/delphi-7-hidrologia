unit mh_GerenteDeProjeto;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, ImgList,
  Forms, Dialogs, ExtCtrls, StdCtrls, Buttons, Grids, Menus, ComCtrls,
  XML_Interfaces,
  TreeViewUtils,
  mh_TCs,
  wsMatrix,
  mh_Classes;

type
  TDLG_Gerente = class(TForm, IXMLtoTree_Factory)
    PanelInfo: TPanel;
    Save: TSaveDialog;
    Pai: TPanel;
    Painel_SubBacia: TPanel;
    sb_SubBacia_Executar: TSpeedButton;
    Painel_DataSet: TPanel;
    sb_DataSet_Plotar: TSpeedButton;
    Painel_Gerente: TPanel;
    sb_DataSet_Salvar: TSpeedButton;
    sb_DataSet_Imprimir: TSpeedButton;
    sb_SubBacia_Salvar: TSpeedButton;
    sb_SubBacia_Remover: TSpeedButton;
    sb_Gerente_Salvar: TSpeedButton;
    sb_Gerente_Opcoes: TSpeedButton;
    sb_DataSet_Remover: TSpeedButton;
    sb_DataSet_Plotar2: TSpeedButton;
    sb_Dataset_Opcoes: TSpeedButton;
    sb_SubBacia_Parametros: TSpeedButton;
    sb_SubBacia_Historico: TSpeedButton;
    sb_DataSet_Plotar_CP: TSpeedButton;
    Tree: TTreeView;
    Images: TImageList;
    SpeedButton1: TSpeedButton;
    procedure Tree_DblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Tree_Click(Sender: TObject);
    procedure sb_DataSet_PlotarClick(Sender: TObject);
    procedure sb_DataSet_SalvarClick(Sender: TObject);
    procedure sb_DataSet_ImprimirClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sb_SubBacia_ExecutarClick(Sender: TObject);
    procedure sb_SubBacia_SalvarClick(Sender: TObject);
    procedure sb_SubBacia_RemoverClick(Sender: TObject);
    procedure sb_Gerente_OpcoesClick(Sender: TObject);
    procedure sb_Gerente_SalvarClick(Sender: TObject);
    procedure sb_DataSet_RemoverClick(Sender: TObject);
    procedure sb_Dataset_OpcoesClick(Sender: TObject);
    procedure sb_DataSet_Plotar2Click(Sender: TObject);
    procedure Tree_MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Tree_MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sb_SubBacia_ParametrosClick(Sender: TObject);
    procedure sb_SubBacia_HistoricoClick(Sender: TObject);
    procedure Menu_EvolucaoClick(Sender: TObject);
    procedure MenuCopiarClick(Sender: TObject);
    procedure MenuColarClick(Sender: TObject);
    procedure sb_DataSet_Plotar_CP_Click(Sender: TObject);
    procedure Menu_InformacoesGeraisClick(Sender: TObject);
    procedure Menu_ParametrosClick(Sender: TObject);
  private
    Arrastando   : Boolean;
    ItemEmArrasto: TTreeNode;
    FpDadosBacia : pTDadosDaBacia;  {Quando eu clicar numa sub-bacia}
    FSBCount     : integer; // Número de sub-bacias do projeto

    Procedure EscondePaineis;
    Procedure DataSet_Plotar(DataSetNode: TmhDataSetNode);
    Procedure DataSet_Plotar_II(DataSetNode: TmhDataSetNode);
    Procedure DataSet_Plotar_CP(DataSetNode: TmhDataSetNode);
    Function  GetNumSubBacias: Integer;
    Function  SaveSubBacias: Boolean;
    Procedure WMSubBacDataChange(Var MSG: TMessage); Message WM_SubBacDataChange;
    Procedure WMDataSetChange(Var MSG: TMessage); Message WM_DataSetChange;
    function  GetProject(): TmhProject;

    // IXMLtoTree_Factory
    function CreateObject(const ClassName: String; Node: TTreeNode): IFromXML;
  public
    SubBaciaNode : TmhSubBaciaNode;  {Sub-Bacia atualmente Selecionada, se alguma está}
    DataSetNode  : TmhDataSetNode; {DataSet atualmente Selecionado, se algum está}

    constructor Create(const Title: String);
    destructor Destroy; override;

    Procedure SaveProject();
    Procedure SaveProjectAs();
    procedure LoadFromFile(Const Name: String);
    Function  SaveToFile(Const Name: String): Boolean;
    Function  SaveSubBacia(SBN: TmhSubBaciaNode): Boolean;
    function  CloseProject: Integer;
    Procedure Update();

    Procedure AddDataSet(Atual: Boolean; DS: TwsDataSet);
    Procedure AddSubBacia(Atual: Boolean; Pos: Integer; SB: TmhSubBacia;
                          SW: Boolean; Const aTitulo, Filename: String);

    Procedure RemoveSubBacia (SBN: TmhSubBaciaNode);
    Procedure RemoveDataSet  (DSN: TmhDataSetNode);

    Property  NumSubBacias : Integer Read GetNumSubBacias;

    property Project : TmhProject read GetProject;
  end;

var
  DLG_Gerente: TDLG_Gerente;

implementation
uses FileCtrl,
     WinUtils,
     SysUtilsEx,
     Assist,
     SpreadSheetBook,
     MessagesForm,
     mh_GRF_ChuvaVazao,
     mh_GRF_VZCxVZO,
     mh_JanelaPrincipal,
     mh_OpcoesGerais,
     mh_OPC_GRF_CurvaDePermanencia;

{$R *.DFM}

Procedure TDLG_Gerente.WMSubBacDataChange(Var MSG: TMessage);
var no: TTreeNode;
    SBN: TmhSubBaciaNode;
Begin
  SBN := Pointer(MSG.LParam);
  no := TreeViewUtils.FindNode(Tree.Items[0], SBN);
  no.Text := SBN.SubBacia.Dados.InfoGerais.Titulo1;
  sb_SubBacia_Executar.Enabled := (SBN.SubBacia.Dados.N999PLU <> 0);
End;

Procedure TDLG_Gerente.WMDataSetChange(Var MSG: TMessage);
var no: TTreeNode;
Begin
  no := TreeViewUtils.FindNode(Tree.Items[0], Pointer(MSG.LParam));
  no.Text := TmhDataSetNode(MSG.LParam).DataSet.MLab;
End;

Function TDLG_Gerente.GetNumSubBacias: Integer;
var CurItem: TTreeNode;
begin
  Result := 0;
  CurItem := Tree.Items[0];
  while CurItem <> nil do
    begin
    if TObject(CurItem.Data) is TmhSubBaciaNode then inc(Result);
    CurItem := CurItem.GetNext;
    end;
end;

procedure TDLG_Gerente.LoadFromFile(Const Name: String);
var SL : TStrings;
Begin
  FSBCount := 0;
  SetCurrentDir(ExtractFilePath(Name));
  XMLToTree(Name, Tree, Self);
  Tree.FullExpand();
  getProject.Modified := False;
  getProject.Path := ExtractFilePath(Name); // Notifica mudança de diretório base
  Caption := 'Gerenciador de projeto: ' + Name;
  {$ifdef VERSAO_LIMITADA}
  if FSBCount > 2 then
     begin
     Free();
     raise Exception.Create('Versão Limitada.'#13 +
                            'Projetos com mais de duas sub-bacias não podem ser carregados.');
     end;
  {$endif}
End;

Function TDLG_Gerente.SaveToFile(Const Name: String): Boolean;
Begin
  Result := True;
  Try
    getProject.Path := ExtractFilePath(Name); // Notifica mudança de diretório base
    TreeToXML(Name, Tree);
    getProject.Modified := False;
    Caption := 'Gerenciador de projeto: ' + Name;
  Except
    Result := False;
  End;
End;

Procedure TDLG_Gerente.EscondePaineis;
Begin
  Painel_SubBacia.Visible := False;
  Painel_DataSet.Visible  := False;
  Painel_Gerente.Visible  := False;
End;

Procedure TDLG_Gerente.SaveProjectAs;
Begin
  {$ifdef DEMO}
  mhApplication.ShowDemoMessage();
  {$else}
  Save.DefaultExt := 'wpr';
  Save.Filter := 'Projetos (*.wpr)|*.wpr';
  Save.Title := 'Salvar Projeto Como';
  Save.FileName := getProject.FileName;
  Save.Initialdir := mhApplication.LastPath;
  If Save.Execute Then
     Begin
     mhApplication.LastPath := ExtractFilePath(Save.FileName);
     getProject.FileName := Save.FileName;
     SaveProject();
     End;
  Update();
  {$endif}
End;

Procedure TDLG_Gerente.SaveProject();
Begin
  {$ifdef DEMO}
  mhApplication.ShowDemoMessage();
  {$else}
  if getProject.FileName <> '' then
     If SaveSubBacias() Then
        If Not SaveToFile(getProject.FileName) Then
           ShowMessage('Um erro ocorreu na tentativa de salvar o Projeto')
        Else
     Else
        ShowMessage('Aviso: Este projeto não foi atualizado pois'#13+
                    'um dos seus componentes não foi salvo.')
  else
     SaveProjectAs;
  {$endif}
End;

Procedure TDLG_Gerente.AddDataSet(Atual: Boolean; DS: TwsDataSet);
var Item: TTreeNode;
    DSN: TmhDatasetNode;
Begin
  If Atual Then
     Item := Tree.Selected
  else
     Item := Tree.Items[0];

  DSN := TmhDatasetNode.Create(getProject, DS);
  Item := Tree.Items.AddChildObject(Item, DS.MLab, DSN);
  TreeViewUtils.SetImageIndex(Item, 0);
  Tree.FullExpand();
End;

Procedure TDLG_Gerente.AddSubBacia(Atual: Boolean; Pos: Integer; SB: TmhSubBacia;
                                   SW: Boolean; Const aTitulo, Filename: String);
var i: Integer;
    Item: TTreeNode;
    SBN: TmhSubBaciaNode;
Begin
  {$ifdef VERSAO_LIMITADA}
  if FSBCount >= 2 then
     begin
     MessageDLG('Versão Limitada - Somente duas Sub-Bacias são permitidas',
                 mtInformation, [mbOk], 0);
     Exit;
     end;
  {$endif}

  If Atual Then
     Begin
     Item := Tree.Selected;
     if not Item.HasChildren Then Item := Item.Parent;
     End
  else
     Item := Tree.Items[0]; // No do projeto

  SBN := TmhSubBaciaNode.Create(getProject(), SB);
  SBN.Filename := Filename;
  SB.Node := SBN;

  With Tree do
    begin
    Item := Items.AddChildObject(Item, aTitulo, SBN);
    TreeViewUtils.SetImageIndex(Item, 2);
    Show();
    FullExpand();
    end;

  If SW Then
     SB.MostrarInfoGeral(Self.Handle);

  inc(FSBCount);
End;

Procedure TDLG_Gerente.RemoveSubBacia(SBN: TmhSubBaciaNode);
var no   : TTreeNode;
    iPai : Integer;
Begin
  Project.Modified := True;
  no := FindNode(Tree.Items[0], SBN);

  If SBN.SubBacia.Modified Then
     If MessageDLG(Format(dlgSubBacChange, [SBN.SubBacia.Dados.InfoGerais.Titulo1]),
                   mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
                   SBN.SaveToFile(SBN.FileName);

  SBN.Free;
  no.Delete;
  Tree_Click(nil);
  dec(FSBCount);
End;

Procedure TDLG_Gerente.RemoveDataSet(DSN: TmhDataSetNode);
var no : TTreeNode;
Begin
  Project.Modified := True;
  no := FindNode(Tree.Items[0], DSN);
  DSN.Free;
  no.Delete;
  Tree_Click(nil);
End;

procedure TDLG_Gerente.Tree_Click(Sender: TObject);
var Obj: TObject;
    Item: TTreeNode;
    D: TDLG_Graphic_1;
    HMF: HWND;
begin
  SubBaciaNode := nil;
  Item := Tree.Selected;
  If Item = nil Then Exit;

  HMF := Application.MainForm.Handle;
  SendMessage(HMF, wm_OutrosClick, 0, 0);

  Obj := Item.Data;

  If (Obj is TmhProject) Then
     Begin
     EscondePaineis;
     Painel_Gerente.Visible := True;
     PanelInfo.Caption := gsNomeDoArq + Project.FileName;
     End
  Else
     Begin
     If (Obj is TmhSubBaciaNode) Then
        Begin
        If Not Painel_SubBacia.Visible Then
           Begin
           EscondePaineis;
           Painel_SubBacia.Visible := True;
           End;
        SubBaciaNode := (Obj as TmhSubBaciaNode);
        FpDadosBacia := SubBaciaNode.SubBacia.pDados;

        With FpDadosBacia^ do
          sb_SubBacia_Executar.Enabled := (N999PLU <> 0);

        PanelInfo.Caption := gsNomeDoArq + SubBaciaNode.FileName;
        SendMessage(HMF, wm_SubBacClick, 0, 0);
        End Else

     {DATASET}
     If (Obj is TmhDataSetNode) Then
        Begin
        If Not Painel_DataSet.Visible Then
           Begin
           EscondePaineis;
           Painel_DataSet.Visible := True;
           End;
        DataSetNode := Item.Data;
        PanelInfo.Caption := gsNomeDoArq + DataSetNode.DataSet.FileName;

        {Desabilita o botão no caso de ser <MODO = SIMULAÇÃO>}
        sb_DataSet_Plotar2.Enabled := (DataSetNode.DataSet.Tag_2 > 0) and
                                      (DataSetNode.DataSet.Tag_2 < 3);

        DLG_Main.Plotar_2.Enabled := sb_DataSet_Plotar2.Enabled;

        SendMessage(HMF, wm_DataSetClick, 0, 0);
        End;

     End;
end;

procedure TDLG_Gerente.Tree_DblClick(Sender: TObject);
var Obj: TObject;
    Item: TTreeNode;
begin
  Tree_Click(nil);
  Item := Tree.Selected;
  If Not Item.HasChildren and (Item.Level <> 0 {Projeto}) Then {É uma Folha}
     Begin
     Obj := Item.Data;
     If (Obj is TmhSubBaciaNode ) Then
        Begin
        SubBaciaNode.SubBacia.ExecDir := Project.Path;
        SubBaciaNode.SubBacia.MostrarInfoGeral(Self.Handle);
        End
     Else
        If (Obj is TmhDataSetNode) Then
           DataSet_Plotar(DataSetNode) Else
     End;
end;

Function TDLG_Gerente.SaveSubBacia(SBN: TmhSubBaciaNode): Boolean;
Begin
  Result := True;
  If SBN.SubBacia.Modified Then
     If SBN.FileName = '' Then
        If Save.Execute Then
           SBN.SaveToFile(Save.FileName)
        Else
           Result := False
     Else
        If MessageDLG(Format(dlgSubBacChange, [SBN.SubBacia.Dados.InfoGerais.Titulo1]),
           mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
           SBN.SaveToFile(SBN.FileName);
End;

Function TDLG_Gerente.SaveSubBacias(): Boolean;
var x: TmhSubBaciaNode;
    Res: Boolean;
    CurItem: TTreeNode;
begin
  Result := True;
  Save.DefaultExt := 'xbac';
  Save.Filter := 'Bacia (*.xbac)|*.xbac';
  Save.FileName := '*.xbac' {SB.FileName};

  CurItem := Tree.Items[0];
  while CurItem <> nil do
    begin
    if TObject(CurItem.Data) is TmhSubBaciaNode then
       begin
       x := TmhSubBaciaNode(CurItem.Data);
       Save.Title := Format('Salvar Bacia <%s> Como', [x.SubBacia.Dados.InfoGerais.Titulo1]);
       Res := SaveSubBacia(x);
       If Not Res Then Result := Res;
       end;
    CurItem := CurItem.GetNext;
    end;
end;

procedure TDLG_Gerente.FormActivate(Sender: TObject);
begin
  mhApplication.ActiveProject := Self;
end;

Procedure TDLG_Gerente.DataSet_Plotar(DataSetNode: TmhDataSetNode);
var D: TDLG_Graphic_1;
Begin
  D := TDLG_Graphic_1.Create(Self);
  Try
    D.Dados := DataSetNode.DataSet;
    D.FormStyle := fsMDIchild;
  Except
    D.Release;
    Raise;
  End;
End;

Procedure TDLG_Gerente.DataSet_Plotar_II(DataSetNode: TmhDataSetNode);
var D: TDLG_Graphic_2;
Begin
  D := TDLG_Graphic_2.Create(Self);
  Try
    D.Dados := DataSetNode.DataSet;
    D.FormStyle := fsMDIchild;
    D.Width := 344;
    D.Height := 268;
  Except
    D.Release;
    Raise;
  End;
End;

procedure TDLG_Gerente.DataSet_Plotar_CP(DataSetNode: TmhDataSetNode);
var D: TDLG_CurvaDePermanencia;
Begin
  D := TDLG_CurvaDePermanencia.Create(self);
  Try
    D.Dados := DataSetNode.DataSet;
    D.ShowModal;
  Finally
    D.Free;
  End;
end;

procedure TDLG_Gerente.sb_DataSet_PlotarClick(Sender: TObject);
begin
  DataSet_Plotar(DataSetNode);
end;

procedure TDLG_Gerente.sb_DataSet_Plotar2Click(Sender: TObject);
begin
  DataSet_Plotar_II(DataSetNode);
end;

procedure TDLG_Gerente.sb_DataSet_SalvarClick(Sender: TObject);
begin
  {$ifdef DEMO}
  mhApplication.ShowDemoMessage();
  {$else}
  Save.Title := 'Salvar Dados Como';
  Save.DefaultExt := 'dst';
  Save.Filter := 'DataSet (*.dst)|*.dst';
  Save.FileName := '*.dst';
  Save.InitialDir := ExtractFilePath(Application.ExeName);
  If Save.Execute Then
     DataSetNode.SaveToFile(Save.FileName);
  Update();
  {$endif}
end;

procedure TDLG_Gerente.sb_DataSet_ImprimirClick(Sender: TObject);
var p: TSpreadSheetBook;
begin
  StartWait();
  try
    p := TSpreadSheetBook.Create();
    DataSetNode.DataSet.ShowInSheet(p);
    p.Show(fsMDIChild);
  finally
    StopWait();
  end;
end;

procedure TDLG_Gerente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {$ifdef DEMO}
  CloseProject();
  Action := caFree;
  {$else}
  if CloseProject() <> mrCancel then
     Action := caFree
  else
     Action := caNone;
  {$endif}
end;

procedure TDLG_Gerente.sb_SubBacia_ExecutarClick(Sender: TObject);
var Arquivo: String;
begin
  Arquivo := SubBaciaNode.SubBacia.GetNameFiles(GetProject.Path + 'Saida\');

  If Arquivo <> '' Then
     Begin
     If MessageDLG(Format(
                'ATENÇÃO:'#13 +
                'Se tudo ocorrer bem, serão criados 3 arquivos:'#13 +
                '%s.SAI'#13 +
                '%s.DST'#13 +
                '%s.VZC'#13 +
                'no seguinte diretório: %s',
                [Arquivo, Arquivo, Arquivo, Project.Path + 'Saida\']),
                mtInformation, [mbOK, mbCancel], 0) = mrCancel Then
                Exit;

     If MessageDLG('ATENÇÃO:'#13 +
                'Não interrompa o programa em DOS senão os resultados serão invalidados !'#13 +
                'O programa será fechado automaticamente ao final da execução.'#13 +
                'Para examinar os dados em andamento tecle <PAUSE>.'#13 +
                'Para continuar tecle <ENTER>.',
                mtInformation, [mbOK, mbCancel], 0) = mrCancel Then Exit;

     SubBaciaNode.SubBacia.Executar(Project.Path,
                                    Arquivo,
                                    Project.DelOutPutFiles);
     End;
end;

procedure TDLG_Gerente.sb_SubBacia_SalvarClick(Sender: TObject);
begin
  {$ifdef DEMO}
  mhApplication.ShowDemoMessage();
  {$else}
  Save.DefaultExt := 'xbac';
  Save.Filter := 'Bacia (*.xbac)|*.xbac';
  Save.FileName := '*.xbac' {SB.FileName};
  If Save.Execute Then
     SubBaciaNode.SaveToFile(Save.FileName);
  Update();
  {$endif}
end;

procedure TDLG_Gerente.sb_SubBacia_RemoverClick(Sender: TObject);
begin
  If MessageDLG('Você tem certeza ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
     RemoveSubBacia(SubBaciaNode);
end;

procedure TDLG_Gerente.sb_Gerente_OpcoesClick(Sender: TObject);
var D: TDLG_OpcoesGerente;
    p: TmhProject;
begin
  p := getProject;
  D := TDLG_OpcoesGerente.Create(self);
  Try
    D.edProjectName.Text       := p.ProjectName;
    D.cbDelOutPutFiles.Checked := p.DelOutPutFiles;

    If D.ShowModal = mrOk Then
       Begin
       p.ProjectName    := D.edProjectName.Text;
       p.DelOutPutFiles := D.cbDelOutPutFiles.Checked;

       Tree.Items[0].Text := p.ProjectName;
       p.Modified := True;
       End;
  Finally
    D.Free;
    End;
end;

function TDLG_Gerente.CloseProject(): Integer;
Begin
  Result := -1;

  {$ifdef DEMO}
  DLG_Main.Projetos.Remove(Self);
  DLG_Main.HabilitaMenus();
  {$else}
  If Project.Modified Then
     Result := MessageDLG('O projeto <' + GetProject.ProjectName + '> foi modificado.'#13 +
               'Deseja salvá-lo ?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);

  If Result <> mrCancel Then
     Begin
     If Result = mrYes Then SaveProject();
     SaveSubBacias();
     DLG_Main.Projetos.Remove(Self);
     DLG_Main.HabilitaMenus();
     End;
  {$endif}
End;

procedure TDLG_Gerente.sb_Gerente_SalvarClick(Sender: TObject);
begin
  {$ifdef DEMO}
  mhApplication.ShowDemoMessage();
  {$else}
  If Project.FileName <> '' Then
     SaveProject()
  Else
     SaveProjectAs();
  {$endif}   
end;

procedure TDLG_Gerente.sb_DataSet_RemoverClick(Sender: TObject);
begin
  If MessageDLG('Você tem certeza ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
     RemoveDataSet(DataSetNode);
end;

procedure TDLG_Gerente.sb_Dataset_OpcoesClick(Sender: TObject);
begin
  DataSetNode.DataSet.MLab := InputBox('Caixa de Entrada', 'Rótulo: ', DataSetNode.DataSet.MLab);
  SendMessage(Handle, WM_DataSetChange, 0, Longint(DataSetNode));
end;

Procedure TDLG_Gerente.Update();
Begin
  Tree_Click(nil);
End;

{-------------------- // ------------------ // ---------------------}
{Regra para arrasto
   - Arrastados:                    - Soltos
     Um DataSet                       Em uma Sub-Bacia (pai)
     Uma Sub-Bacia (pai)
}

procedure TDLG_Gerente.Tree_MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Obj: TObject;
begin
(*
  Try
    ItemEmArrasto := Tree.Items[Tree.GetItem(X,Y)];
    Obj := ItemEmArrasto.Data;
    If (ItemEmArrasto.HasItems) {É um pai} or (Obj is TwsDataSet) Then
       Screen.Cursor := crDrag
    Else
       ItemEmArrasto := nil;
  Except
    ItemEmArrasto := nil;
  End;
*)
end;

procedure TDLG_Gerente.Tree_MouseUp(Sender: TObject; Button: TMouseButton;
                                     Shift: TShiftState; X, Y: Integer);
begin
(*
  Screen.Cursor := crDefault;
  Try
    Pai := Tree.Items[Tree.GetItem(X, Y)];
    If (ItemEmArrasto <> Nil) and (Pai.HasItems {É um pai verdadeiro}) Then
       Begin
       ItemEmArrasto.MoveTo(Pai.Index, oaAddChild);
       ItemEmArrasto := Nil;
       End;
  Except
    {Nada}
  End;
*)
end;

{-------------------- // ------------------ // ---------------------}

procedure TDLG_Gerente.sb_SubBacia_HistoricoClick(Sender: TObject);
begin
  SubBaciaNode.SubBacia.Historico.ShowModal;
end;

procedure TDLG_Gerente.sb_SubBacia_ParametrosClick(Sender: TObject);
var P: TPoint;
begin
  //P := Point(sb_SubBacia_Parametros.Left, sb_SubBacia_Parametros.Height);
  //P := ClientToScreen(P);
  //MenuParam.Popup(P.x, P.y);
end;

procedure TDLG_Gerente.Menu_EvolucaoClick(Sender: TObject);
begin
  SubBaciaNode.SubBacia.ShowParamsGraphics;
end;

procedure TDLG_Gerente.MenuCopiarClick(Sender: TObject);
begin
  SubBaciaNode.SubBacia.CopiarParametros;
end;

procedure TDLG_Gerente.MenuColarClick(Sender: TObject);
begin
  SubBaciaNode.SubBacia.ColarParametros;
end;

procedure TDLG_Gerente.sb_DataSet_Plotar_CP_Click(Sender: TObject);
begin
  DataSet_Plotar_CP(DataSetNode);
end;

constructor TDLG_Gerente.Create(const Title: String);
var no: TTreeNode;
    p: TmhProject;
begin
  inherited Create(Application);
  ItemEmArrasto := Nil;
  FormStyle := fsMDIChild;
  Caption := Caption + ' ' + 'Sem Nome';

  p := TmhProject.Create;
  p.ProjectName := Title;

  no := Tree.Items.AddChildObject(nil, p.ProjectName, p);
  TreeViewUtils.SetImageIndex(no, 1);
end;

destructor TDLG_Gerente.Destroy;
begin
  TreeViewUtils.FreeNodes(Tree.Items);
  inherited;
end;

function TDLG_Gerente.GetProject: TmhProject;
begin
  Result := TmhProject(Tree.Items[0].Data);
end;

function TDLG_Gerente.CreateObject(const ClassName: String; Node: TTreeNode): IFromXML;
begin
  if CompareText(ClassName, 'TmhProject') = 0 then
     Result := TmhProject.Create
  else
  if CompareText(ClassName, 'TmhSubBaciaNode') = 0 then
     begin
     Result := TmhSubBaciaNode.Create(getProject, nil);
     inc(FSBCount);
     end
  else
  if CompareText(ClassName, 'TmhDataSetNode') = 0 then
     Result := TmhDataSetNode.Create(getProject, nil)
end;

procedure TDLG_Gerente.Menu_InformacoesGeraisClick(Sender: TObject);
begin
  SubBaciaNode.SubBacia.ExecDir := getProject.Path;
  SubBaciaNode.SubBacia.MostrarInfoGeral(Self.Handle, False);
end;

procedure TDLG_Gerente.Menu_ParametrosClick(Sender: TObject);
begin
  SubBaciaNode.SubBacia.ExecDir := getProject.Path;
  SubBaciaNode.SubBacia.MostrarParametros;
end;

end.
