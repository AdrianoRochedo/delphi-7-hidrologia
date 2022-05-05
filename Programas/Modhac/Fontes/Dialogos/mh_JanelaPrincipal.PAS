unit mh_JanelaPrincipal;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms, Dialogs, Menus,
  wsTabelaDeSimbolos, ExtCtrls, Buttons, 
  mh_TCs,
  mh_GerenteDeProjeto;

type
  TDLG_Main = class(TForm)
    MainMenu1: TMainMenu;
    Menu_Arquivo: TMenuItem;
    Menu_Visualizar: TMenuItem;
    Arquivo_AbrirProjeto: TMenuItem;
    Arquivo_SalvarProjeto: TMenuItem;
    N1: TMenuItem;
    Visualizar_Editor: TMenuItem;
    Arquivo_NovoProjeto: TMenuItem;
    N2: TMenuItem;
    Sair2: TMenuItem;
    Arquivo_SalvarProjetoComo: TMenuItem;
    Arquivo_FecharProjeto: TMenuItem;
    N3: TMenuItem;
    Arquivo_SalvarSubBacia: TMenuItem;
    Arquivo_SalvarSubBaciaComo: TMenuItem;
    Arquivo_AdicionarSubBacia: TMenuItem;
    Arquivo_RemoverSubBacia: TMenuItem;
    Visualizar_Ger_De_Projeto: TMenuItem;
    Save: TSaveDialog;
    Load: TOpenDialog;
    Menu_ConjuntodeDados: TMenuItem;
    Menu_Ajuda: TMenuItem;
    Arquivo_NovaSubBacia: TMenuItem;
    Ajuda_Sobre: TMenuItem;
    Menu_Janela: TMenuItem;
    Menu_Janela_Cascata: TMenuItem;
    Menu_Horiz: TMenuItem;
    Menu_Ajuda_Help: TMenuItem;
    Menu_Projeto: TMenuItem;
    Projeto_Opcoes: TMenuItem;
    Projeto_SubBacia: TMenuItem;
    Projeto_Dados: TMenuItem;
    Projeto_SubBacia_Editar: TMenuItem;
    Projeto_SubBacia_Remover: TMenuItem;
    Projeto_SubBacia_Executar: TMenuItem;
    Projeto_Dados_Imprimir: TMenuItem;
    Projeto_Dados_Plotar: TMenuItem;
    Projeto_Dados_Remover: TMenuItem;
    Plotar_2: TMenuItem;
    Projeto_SubBacia_Historico: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    Projeto_SubBacia_GraficoParmetros: TMenuItem;
    Menu_Vert: TMenuItem;
    pa_Botoes: TPanel;
    btnSair: TSpeedButton;
    btnNew: TSpeedButton;
    btnOpen: TSpeedButton;
    btnAdicBac: TSpeedButton;
    btnVerProjeto: TSpeedButton;
    btnTile: TSpeedButton;
    btnCascata: TSpeedButton;
    btnAdicDataSet: TSpeedButton;
    Menu_CP: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Gerenciador_De_Projeto_Click(Sender: TObject);
    procedure Arquivo_SalvarSubBaciaComoClick(Sender: TObject);
    procedure Arquivo_AdicionarSubBaciaClick(Sender: TObject);
    procedure Menu_ConjuntodeDadosClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Sair2Click(Sender: TObject);
    procedure Arquivo_NovoProjetoClick(Sender: TObject);
    procedure Arquivo_SalvarProjetoClick(Sender: TObject);
    procedure Arquivo_SalvarProjetoComoClick(Sender: TObject);
    procedure Arquivo_FecharProjetoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Arquivo_RemoverSubBaciaClick(Sender: TObject);
    procedure Arquivo_SalvarSubBaciaClick(Sender: TObject);
    procedure Arquivo_NovaSubBaciaClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Arquivo_AbrirProjeto_Click(Sender: TObject);
    procedure Menu_Janela_CascataClick(Sender: TObject);
    procedure Menu_HorizClick(Sender: TObject);
    procedure Menu_Ajuda_HelpClick(Sender: TObject);
    procedure Ajuda_SobreClick(Sender: TObject);
    procedure Projeto_OpcoesClick(Sender: TObject);
    procedure Projeto_SubBacia_EditarClick(Sender: TObject);
    procedure Projeto_SubBacia_RemoverClick(Sender: TObject);
    procedure Projeto_SubBacia_ExecutarClick(Sender: TObject);
    procedure Projeto_Dados_ImprimirClick(Sender: TObject);
    procedure Projeto_Dados_PlotarClick(Sender: TObject);
    procedure Projeto_Dados_RemoverClick(Sender: TObject);
    procedure Menu_ProjetoClick(Sender: TObject);
    procedure Plotar_2Click(Sender: TObject);
    procedure Projeto_SubBacia_HistoricoClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure Projeto_SubBacia_GraficoParmetrosClick(Sender: TObject);
    procedure Menu_VertClick(Sender: TObject);
    procedure Menu_ArquivoClick(Sender: TObject);
    procedure Menu_CPClick(Sender: TObject);
  private
    Procedure WMSubBacClick (Var MSG: TMessage); Message WM_SubBacClick;
    Procedure WMDataSetClick(Var MSG: TMessage); Message WM_DataSetClick;
    Procedure WMOutrosClick (Var MSG: TMessage); Message WM_OutrosClick;
  public
    Projetos : TList;     {Lista de projetos}
    Procedure HabilitaMenus;
    procedure Open(const Arquivo: String);
    function ActiveProject: TDLG_Gerente;
  end;

var
  DLG_Main: TDLG_Main;

implementation
uses SysUtilsEx,
     wsMatrix,
     // Edit,
     mh_Classes,
     mh_About;

{$R *.DFM}

Procedure TDLG_Main.WMSubBacClick(Var MSG: TMessage);
var B: Boolean;
Begin
  B := (Projetos.Count > 0);
  Menu_ConjuntoDeDados.Enabled := B;
  Arquivo_AdicionarSubBacia.Enabled := B;
  Arquivo_NovaSubBacia.Enabled := B;

  B := B and (ActiveProject.SubBaciaNode is TmhSubBaciaNode);
  Arquivo_SalvarSubBaciaComo.Enabled := B;
  Arquivo_SalvarSubBacia.Enabled := B;
  Projeto_SubBacia.Enabled := B;
  Arquivo_RemoverSubBacia.Enabled := B;
End;

Procedure TDLG_Main.WMDataSetClick(Var MSG: TMessage);
Begin
  Projeto_Dados.Enabled := True;
End;

Procedure TDLG_Main.WMOutrosClick(Var MSG: TMessage);
Begin
  Arquivo_SalvarSubBaciaComo.Enabled := False;
  Projeto_SubBacia.Enabled := False;
  Projeto_Dados.Enabled := False;
End;

Procedure TDLG_Main.HabilitaMenus;
Begin
  Arquivo_AdicionarSubBacia.Enabled  := (Projetos.Count > 0);
  btnAdicBac.Enabled                 := Arquivo_AdicionarSubBacia.Enabled;
  Menu_Projeto.Enabled               := Arquivo_AdicionarSubBacia.Enabled;
  btnVerProjeto.Enabled              := Arquivo_AdicionarSubBacia.Enabled;
  Arquivo_NovaSubBacia.Enabled       := Arquivo_AdicionarSubBacia.Enabled;
  Arquivo_SalvarProjeto.Enabled      := Arquivo_AdicionarSubBacia.Enabled;
  Arquivo_SalvarProjetoComo.Enabled  := Arquivo_AdicionarSubBacia.Enabled;
  Arquivo_FecharProjeto.Enabled      := Arquivo_AdicionarSubBacia.Enabled;
  Visualizar_Ger_De_Projeto.Enabled  := Arquivo_AdicionarSubBacia.Enabled;
  Menu_ConjuntodeDados.Enabled       := Arquivo_AdicionarSubBacia.Enabled;

  If Arquivo_AdicionarSubBacia.Enabled Then
     Begin
     Arquivo_SalvarSubBaciaComo.Enabled := ActiveProject.NumSubBacias > 0;
     Arquivo_RemoverSubBacia.Enabled    := Arquivo_SalvarSubBaciaComo.Enabled;
     Arquivo_SalvarSubBacia.Enabled     := Arquivo_SalvarSubBaciaComo.Enabled;
     End
  Else
     Begin
     Arquivo_SalvarSubBaciaComo.Enabled := False;
     Arquivo_RemoverSubBacia.Enabled    := False;
     Arquivo_SalvarSubBacia.Enabled     := False;
     End;
End;

procedure TDLG_Main.FormCreate(Sender: TObject);
begin
  Projetos := TList.Create;
end;

procedure TDLG_Main.Gerenciador_De_Projeto_Click(Sender: TObject);
begin
  ActiveProject.WindowState := wsNormal;
  ActiveProject.Show;
end;

procedure TDLG_Main.Arquivo_SalvarSubBaciaComoClick(Sender: TObject);
begin
  {$ifdef DEMO}
  mhApplication.ShowDemoMessage();
  {$else}
  {SB := Bacia atual;}
  Save.DefaultExt := 'xbac';
  Save.Filter     := 'Bacia (*.xbac)|*.xbac';
  Save.FileName   := '*.xbac' {SB.FileName};
  Save.Title      := ' Salvar Bacia Como';
  Save.InitialDir := mhApplication.LastPath;

  If Save.Execute Then
     Begin
     mhApplication.LastPath := ExtractFilePath(Save.FileName);
     ActiveProject.SubBaciaNode.SaveToFile(Save.FileName);
     ActiveProject.Update();
     End;
  {$endif}
end;

procedure TDLG_Main.Arquivo_AdicionarSubBaciaClick(Sender: TObject);
var F: File;
    Erro: Word;
    S: String[10];
    SB: TmhSubBacia;
    Index: Longint;
    i: integer;
begin
  Load.DefaultExt := 'xbac';
  Load.Filter     := 'Bacia (*.xbac)|*.xbac|Formato Antigo (*.bac)|*.bac';
  Load.FileName   := '*.xbac';
  Load.Title      := ' Leitura de Bacias Hidrográficas';
  Load.InitialDir := mhApplication.LastPath;

  If Load.Execute Then
     for i := 0 to Load.Files.Count-1 do
       Begin
       mhApplication.LastPath := ExtractFilePath(Load.Files[i]);
       SB := TmhSubBacia.Create();
       SB.LoadFromFile(Load.Files[i]);
       ActiveProject.AddSubBacia(False, 1, SB,
          False{não mostra a janela de edicão},
          SB.Dados.InfoGerais.Titulo1,
          Load.Files[i]);
       End;

  HabilitaMenus();
end;

procedure TDLG_Main.Menu_ConjuntodeDadosClick(Sender: TObject);
Var DS: TwsDataSet;
    i: Integer;
begin
  Load.DefaultExt := 'dst';
  Load.Filter     := 'Conjuntos (*.dst)|*.dst';
  Load.FileName   := '*.dst';
  Load.Title      := ' Leitura de conjuntos de dados';
  Load.InitialDir := mhApplication.LastPath;

  If Load.Execute() Then
     for i := 0 to Load.Files.Count - 1 do
       Try
         mhApplication.LastPath := ExtractFilePath(Load.Files[i]);
         DS := TwsDataSet(TwsDataSet.LoadFromFile(Load.Files[i]));

         // Verifica a assinatura
         if (DS.ExtraData[0] = 1) and (DS.ExtraData[1] = 5) and (DS.ExtraData[2] = 0) then
             begin
             ActiveProject.AddDataSet(True, DS);
             HabilitaMenus();
             end
         else
            begin
            ShowMessage('Assinatura do arquivo de dados não confere !');
            DS.Free();
            end;
       Except
         ShowMessage('Erro de Leitura');
       End;
end;

procedure TDLG_Main.FormShow(Sender: TObject);
var i: Integer;
begin
  Caption := ' ' + Forms.Application.Title;
  
  for i := 1 to ParamCount do
     if System.pos('\', ParamStr(i)) > 0 then
        DLG_Main.Open(ParamStr(i));

  HabilitaMenus();
end;

procedure TDLG_Main.Sair2Click(Sender: TObject);
begin
  Close;
end;

procedure TDLG_Main.Arquivo_NovoProjetoClick(Sender: TObject);
var D: TDLG_Gerente;
begin
  D := TDLG_Gerente.Create('Novo Projeto ' + IntToStr(Projetos.Count + 1));
  Projetos.Add(D);
  HabilitaMenus;
  mhApplication.ActiveProject := D;
end;

procedure TDLG_Main.Arquivo_SalvarProjetoClick(Sender: TObject);
begin
  {$ifdef DEMO}
  mhApplication.ShowDemoMessage();
  {$else}
  ActiveProject.SaveProject();
  ActiveProject.Update();
  {$endif}
end;

procedure TDLG_Main.Arquivo_SalvarProjetoComoClick(Sender: TObject);
begin
  {$ifdef DEMO}
  mhApplication.ShowDemoMessage();
  {$else}
  ActiveProject.SaveProjectAs();
  {$endif}
end;

procedure TDLG_Main.Arquivo_FecharProjetoClick(Sender: TObject);
begin
  ActiveProject.Close;
  HabilitaMenus;
end;

procedure TDLG_Main.FormClose(Sender: TObject; var Action: TCloseAction);
var i: Integer;
    D: TDLG_Gerente;
begin
  while Projetos.Count > 0 do
    Begin
    D := TDLG_Gerente(Projetos[0]);
    D.CloseProject();
    D.Free();
    End;

  Projetos.Free();
  Action := caFree;
end;

procedure TDLG_Main.Arquivo_RemoverSubBaciaClick(Sender: TObject);
begin
  With ActiveProject do sb_SubBacia_RemoverClick(nil);
  HabilitaMenus;
end;

procedure TDLG_Main.Arquivo_SalvarSubBaciaClick(Sender: TObject);
begin
  {$ifdef DEMO}
  mhApplication.ShowDemoMessage();
  {$else}
  ActiveProject.SaveSubBacia(ActiveProject.SubBaciaNode);
  {$endif}
end;

procedure TDLG_Main.Arquivo_NovaSubBaciaClick(Sender: TObject);
var SB: TmhSubBacia;
    Index: Longint;
begin
  SB := TmhSubBacia.Create;
  SB.Modified := True;
  SB.pDados.InfoGerais.Titulo1 := 'Nova Sub-Bacia';
  ActiveProject.AddSubBacia(False, 1, SB, True {Mostra janela},
                            SB.Dados.InfoGerais.Titulo1, '');
  HabilitaMenus;
end;

procedure TDLG_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := MessageDLG(dlgConfirmClose + 'o ' + Application.Title + ' ?',
              mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

procedure TDLG_Main.Arquivo_AbrirProjeto_Click(Sender: TObject);
begin
  Load.DefaultExt := 'wpr';
  Load.Filter     := 'Projetos (*.wpr)|*.wpr';
  Load.FileName   := '*.wpr';
  Load.Title      := 'Abre um Projeto';
  Load.InitialDir := mhApplication.LastPath;

  If Load.Execute Then
     Open(Load.FileName);
end;

procedure TDLG_Main.Menu_Janela_CascataClick(Sender: TObject);
begin
  Cascade;
end;

procedure TDLG_Main.Menu_HorizClick(Sender: TObject);
begin
  TileMode := tbHorizontal;
  Tile;
end;

procedure TDLG_Main.Menu_Ajuda_HelpClick(Sender: TObject);
begin
  MessageDLG('Sistema de Ajuda ainda não implementado.', mtInformation, [mbOK], 0);
end;

procedure TDLG_Main.Ajuda_SobreClick(Sender: TObject);
Var D: TDLG_Info;
begin
  D := TDLG_Info.Create(Application);
  Try
    D.ShowModal;
  Finally
    D.Release;
  End;
end;

procedure TDLG_Main.Projeto_OpcoesClick(Sender: TObject);
begin
  ActiveProject.sb_Gerente_OpcoesClick(Nil);
end;

procedure TDLG_Main.Projeto_SubBacia_EditarClick(Sender: TObject);
begin
  ActiveProject.Menu_InformacoesGeraisClick(Nil);
end;

procedure TDLG_Main.Projeto_SubBacia_RemoverClick(Sender: TObject);
begin
  ActiveProject.sb_SubBacia_RemoverClick(Nil);
end;

procedure TDLG_Main.Projeto_SubBacia_ExecutarClick(Sender: TObject);
begin
  ActiveProject.sb_SubBacia_ExecutarClick(Nil);
end;

procedure TDLG_Main.Projeto_Dados_ImprimirClick(Sender: TObject);
begin
  ActiveProject.sb_DataSet_ImprimirClick(Nil);
end;

procedure TDLG_Main.Projeto_Dados_PlotarClick(Sender: TObject);
begin
  ActiveProject.sb_DataSet_PlotarClick(Nil);
end;

procedure TDLG_Main.Plotar_2Click(Sender: TObject);
begin
  ActiveProject.sb_DataSet_Plotar2Click(Nil);
end;

procedure TDLG_Main.Menu_CPClick(Sender: TObject);
begin
  ActiveProject.sb_DataSet_Plotar_CP_Click(Nil);
end;

procedure TDLG_Main.Projeto_Dados_RemoverClick(Sender: TObject);
begin
  ActiveProject.sb_DataSet_RemoverClick(Nil);
end;

procedure TDLG_Main.Menu_ProjetoClick(Sender: TObject);
begin
  ActiveProject.Show;
  ActiveProject.Tree_Click(Nil);
end;

procedure TDLG_Main.Projeto_SubBacia_HistoricoClick(Sender: TObject);
begin
  ActiveProject.SubBaciaNode.SubBacia.Historico.Show;
end;

procedure TDLG_Main.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TDLG_Main.Projeto_SubBacia_GraficoParmetrosClick(Sender: TObject);
begin
  ActiveProject.SubBaciaNode.SubBacia.ShowParamsGraphics;
end;

procedure TDLG_Main.Menu_VertClick(Sender: TObject);
begin
  TileMode := tbVertical;
  Tile;
end;                                       

procedure TDLG_Main.Menu_ArquivoClick(Sender: TObject);
var MSG: TMessage;
begin
  WMSubBacClick(MSG);
end;

procedure TDLG_Main.Open(const Arquivo: String);
var D: TDLG_Gerente;
begin
  mhApplication.LastPath := ExtractFilePath(Arquivo);
  D := TDLG_Gerente.Create('');
  D.LoadFromFile(Arquivo);
  Projetos.Add(D);
  HabilitaMenus;
  mhApplication.ActiveProject := D;
end;

function TDLG_Main.ActiveProject: TDLG_Gerente;
begin
  Result := TDLG_Gerente(mhApplication.ActiveProject);
end;

end.
