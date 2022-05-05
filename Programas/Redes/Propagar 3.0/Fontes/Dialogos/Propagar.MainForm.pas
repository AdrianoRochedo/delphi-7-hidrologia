unit Propagar.MainForm;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, TB2Dock, TBX, Menus, ComCtrls, ExtCtrls, TB2Item, TB2Toolbar,
     ImgList, TB2ExtItems, TBXExtItems,
     DiretivasDeCompilacao,
     SysUtilsEx,
     MessageManager,
     Optimizer_Base,
     pr_Classes,
     pr_Form_AreaDeProjeto_Base,
     pr_Application, AppEvnts, ExtDlgs;

type
  TMainForm = class(TForm, IMessageReceptor)
    TopDock: TTBXDock;
    LeftDock: TTBXDock;
    RightDock: TTBXDock;
    BottonPanel: TPanel;
    Panel2: TPanel;
    Leds: TImage;
    StatusBar: TStatusBar;
    StatusBar2: TStatusBar;
    MainMenu: TMainMenu;
    Menu_Arquivo: TMenuItem;
    Menu_Arquivo_Novo: TMenuItem;
    Menu_ProjetoSimples: TMenuItem;
    Menu_ProjetoZoom: TMenuItem;
    Menu_Arquivo_Abrir: TMenuItem;
    Menu_Arquivo_Salvar: TMenuItem;
    Menu_Arquivo_SalvarComo: TMenuItem;
    N11: TMenuItem;
    Menu_Arquivo_Fechar: TMenuItem;
    MenuFecharTodos: TMenuItem;
    N1: TMenuItem;
    Menu_Arquivo_Sair: TMenuItem;
    Menu_Editar_Visualizar: TMenuItem;
    Menu_ExecutarScript: TMenuItem;
    N13: TMenuItem;
    Menu_Gerenciador: TMenuItem;
    N9: TMenuItem;
    Menu_Mensagens: TMenuItem;
    Menu_Ver_Mensagens: TMenuItem;
    N12: TMenuItem;
    Menu_Mostrar_VariaveisGlobais: TMenuItem;
    Menu_Projeto: TMenuItem;
    Menu_Projeto_PG: TMenuItem;
    N8: TMenuItem;
    Menu_Projeto_Visualizar: TMenuItem;
    Menu_Projeto_Visualizar_Demendas: TMenuItem;
    Menu_Projeto_Visualizar_TD: TMenuItem;
    Menu_Projeto_Visualizar_Imagem: TMenuItem;
    N7: TMenuItem;
    Menu_Projeto_Bloquear: TMenuItem;
    N2: TMenuItem;
    Menu_LerFundo: TMenuItem;
    Menu_LimparImagem: TMenuItem;
    N6: TMenuItem;
    Menu_RealizarDiagnostico: TMenuItem;
    Menu_Projeto_Simular: TMenuItem;
    Menu_Projeto_Monitorar: TMenuItem;
    Menu_Mostrar_PC: TMenuItem;
    N10: TMenuItem;
    Menu_Projeto_Otimizar: TMenuItem;
    Menu_Projeto_Otimizar_Rosen: TMenuItem;
    Menu_Projeto_Otimizar_Genetic: TMenuItem;
    Menu_Projeto_Otimizar_GeneticMO: TMenuItem;
    N3: TMenuItem;
    Menu_Intervalos: TMenuItem;
    Menu_MatrizContrib: TMenuItem;
    Menu_Falhas: TMenuItem;
    N4: TMenuItem;
    Menu_Projeto_GerarEquacoes: TMenuItem;
    Menu_Demandas: TMenuItem;
    Menu_ClassesDemanda: TMenuItem;
    CD_Criar: TMenuItem;
    CD_Editar: TMenuItem;
    CD_Remover: TMenuItem;
    N5: TMenuItem;
    Menu_CD_Tabela: TMenuItem;
    DistribuirDemandas1: TMenuItem;
    Menu_Ferramentas: TMenuItem;
    Menu_Solvers: TMenuItem;
    Menu_MWSolver: TMenuItem;
    Menu_LPSolverIDE: TMenuItem;
    N14: TMenuItem;
    Menu_AbrirUltPastaAcessada: TMenuItem;
    Menu_Janelas: TMenuItem;
    Menu_Janelas_Cascata: TMenuItem;
    Menu_Janelas_Horizontal: TMenuItem;
    Menu_Janelas_Vertical: TMenuItem;
    Menu_Ajuda: TMenuItem;
    Menu_Ajuda_Sobre: TMenuItem;
    Menu_Ajuda_Historico: TMenuItem;
    MainToolbar: TTBXToolbar;
    btnAbrir: TTBXItem;
    btnSalvar: TTBXItem;
    btnBloqueado: TTBXItem;
    btnMT: TTBXItem;
    btnImagem: TTBXItem;
    btnGerente: TTBXItem;
    btnOpcoesProjeto: TTBXItem;
    btnDiagnostico: TTBXItem;
    btnExecutar: TTBXItem;
    btnOtimizar: TTBXItem;
    btnParar: TTBXItem;
    btnCascata: TTBXItem;
    btnHor: TTBXItem;
    btnVart: TTBXItem;
    btnHelp: TTBXItem;
    MainToolBar_IL: TImageList;
    TBXSeparatorItem1: TTBXSeparatorItem;
    TBXSeparatorItem2: TTBXSeparatorItem;
    TBXSeparatorItem3: TTBXSeparatorItem;
    TBXSeparatorItem4: TTBXSeparatorItem;
    TBXSeparatorItem5: TTBXSeparatorItem;
    TBXSeparatorItem6: TTBXSeparatorItem;
    MainToolbar_Scripts: TTBXToolbar;
    laScripts: TTBXLabelItem;
    btnEditarScript: TTBXItem;
    btnPararScript: TTBXItem;
    btnExecutarScript: TTBXItem;
    LeftToolBar_IL_I: TImageList;
    LeftToolbar_I: TTBXToolbar;
    sbRemoverObjeto: TTBXItem;
    sbCriarQA: TTBXItem;
    sbCriarDescarga: TTBXItem;
    sbCriarCenarioDemanda: TTBXItem;
    sbCriarDemanda: TTBXItem;
    sbCriarSubBacia: TTBXItem;
    sbPCReservatorio: TTBXItem;
    sbCriarPC: TTBXItem;
    sbArrastar: TTBXItem;
    TBXSeparatorItem7: TTBXSeparatorItem;
    LeftToolBar_IL_II: TImageList;
    TBXSeparatorItem10: TTBXSeparatorItem;
    GerarArquivos: TSaveDialog;
    OpenDialog: TOpenDialog;
    OpenBitmap: TOpenPictureDialog;
    Eventos: TApplicationEvents;
    MenuCenarios: TPopupMenu;
    Menu_IL: TImageList;
    TBXSeparatorItem11: TTBXSeparatorItem;
    sbCriarTrecho: TTBXItem;
    sbSB_em_PC: TTBXItem;
    TBXSeparatorItem8: TTBXSeparatorItem;
    sbInserirPCEntre: TTBXItem;
    sbRemoverTrecho: TTBXItem;
    TBXSeparatorItem9: TTBXSeparatorItem;
    sbPC_TO_RES: TTBXItem;
    sbRES_TO_PC: TTBXItem;
    cbScripts: TTBXComboBoxItem;
    procedure Menu_ProjetoSimplesClick(Sender: TObject);
    procedure Menu_ProjetoZoomClick(Sender: TObject);
    procedure Menu_Arquivo_AbrirClick(Sender: TObject);
    procedure Menu_Arquivo_SalvarClick(Sender: TObject);
    procedure Menu_Arquivo_SalvarComoClick(Sender: TObject);
    procedure Menu_Arquivo_FecharClick(Sender: TObject);
    procedure MenuFecharTodosClick(Sender: TObject);
    procedure Menu_Arquivo_SairClick(Sender: TObject);
    procedure Menu_ExecutarScriptClick(Sender: TObject);
    procedure Menu_GerenciadorClick(Sender: TObject);
    procedure Menu_MensagensClick(Sender: TObject);
    procedure Menu_Ver_MensagensClick(Sender: TObject);
    procedure Menu_Mostrar_VariaveisGlobaisClick(Sender: TObject);
    procedure Menu_Projeto_PGClick(Sender: TObject);
    procedure Menu_ProjetoClick(Sender: TObject);
    procedure Menu_Projeto_Visualizar_DemendasClick(Sender: TObject);
    procedure Menu_Projeto_Visualizar_TDClick(Sender: TObject);
    procedure Menu_Projeto_Visualizar_ImagemClick(Sender: TObject);
    procedure Menu_Projeto_BloquearClick(Sender: TObject);
    procedure Menu_LerFundoClick(Sender: TObject);
    procedure Menu_LimparImagemClick(Sender: TObject);
    procedure Menu_RealizarDiagnosticoClick(Sender: TObject);
    procedure Menu_Projeto_SimularClick(Sender: TObject);
    procedure Menu_Projeto_MonitorarClick(Sender: TObject);
    procedure Menu_Mostrar_PCClick(Sender: TObject);
    procedure Menu_Projeto_Otimizar_RosenClick(Sender: TObject);
    procedure Menu_Projeto_Otimizar_GeneticClick(Sender: TObject);
    procedure Menu_Projeto_Otimizar_GeneticMOClick(Sender: TObject);
    procedure Menu_IntervalosClick(Sender: TObject);
    procedure Menu_MatrizContribClick(Sender: TObject);
    procedure Menu_FalhasClick(Sender: TObject);
    procedure Menu_Projeto_GerarEquacoesClick(Sender: TObject);
    procedure CD_CriarClick(Sender: TObject);
    procedure CD_EditarClick(Sender: TObject);
    procedure CD_RemoverClick(Sender: TObject);
    procedure Menu_CD_TabelaClick(Sender: TObject);
    procedure DistribuirDemandas1Click(Sender: TObject);
    procedure Menu_MWSolverClick(Sender: TObject);
    procedure Menu_LPSolverIDEClick(Sender: TObject);
    procedure Menu_AbrirUltPastaAcessadaClick(Sender: TObject);
    procedure Menu_Janelas_CascataClick(Sender: TObject);
    procedure Menu_Janelas_HorizontalClick(Sender: TObject);
    procedure Menu_Janelas_VerticalClick(Sender: TObject);
    procedure Menu_Ajuda_SobreClick(Sender: TObject);
    procedure Menu_Ajuda_HistoricoClick(Sender: TObject);
    procedure btnBloqueadoClick(Sender: TObject);
    procedure btnMTClick(Sender: TObject);
    procedure btnImagemClick(Sender: TObject);
    procedure btnGerenteClick(Sender: TObject);
    procedure btnOtimizarClick(Sender: TObject);
    procedure btnPararClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnExecutarScriptClick(Sender: TObject);
    procedure btnEditarScriptClick(Sender: TObject);
    procedure Ferramentas_Click(Sender: TObject);
    procedure sbCriarCenarioDemandaClick(Sender: TObject);
    procedure sbRemoverObjetoClick(Sender: TObject);
    procedure sbRemoverTrechoClick(Sender: TObject);
    procedure sbPC_TO_RESClick(Sender: TObject);
    procedure sbRES_TO_PCClick(Sender: TObject);
    procedure MenuCenariosPopup(Sender: TObject);
    procedure EventosMessage(var Msg: tagMSG; var Handled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    MC: TSharedMem;

    procedure MenuCenarioClick(Sender: TObject);
    procedure DescreverObjeto(HC: THidroComponente);
    function  ObtemAreaDeProjetoAtiva: TfoAreaDeProjeto_Base;
    procedure AtualizaBtnBloqueado();
    procedure FecharProjetos();
    procedure FormChange(Sender: TObject);

    procedure WMDROPFILES(var Message: TWMDROPFILES); message WM_DROPFILES;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean;

    procedure Otimizar(Otimizador: TOptimizer);
    procedure IniciarOtimizacao();
    procedure FinalizarOtimizacao();

    // Tratamento dos eventos proviniente da área de projeto
    procedure TrataMensagemDaAreaDeProjeto(const ID: String; Objeto: TObject);
    function  TrataStatusDoBotaoDaAreaDeProjeto(const ID_Botao: String): boolean;
    procedure TrataAvisoDaAreaDeProjeto(const Aviso: String);
  public
    function  CreateMDIChild(const Name: string; Novo, Max: Boolean; TipoNovo: integer): TfoAreaDeProjeto_Base;
    procedure AtualizarMenus(Obj: THidroComponente);
    property  AreaDeProjeto: TfoAreaDeProjeto_Base read ObtemAreaDeProjetoAtiva;
  end;

var
  MainForm: TMainForm;

implementation
uses pr_Const, pr_Tipos, pr_Vars, ShellAPI, OutPut,
     Plugin,
     WinUtils,
     pr_Funcoes,
     AboutForm,
     pr_Gerenciador,
     Form_Chart,
     psEditor,
     psBASE,
     psCORE,
     pr_Dialogo_Demanda_TVU_Distribuir,
     prDialogo_Planilha_DemandasDeUmaClasse,
     prDialogo_EscolherClasseDemanda,
     Lib_GlobalObjects_ShowDialog,
     prForm_Equacoes,
     Historico,
     Rosenbrock_Optimizer,
     Genetic_Optimizer,
     GeneticMO_Optimizer,

     // Areas de Projeto
     pr_Form_AreaDeProjeto_BMP,
     pr_Form_AreaDeProjeto_Zoom;

{$R *.DFM}

{ ------------------------ Menus ---------------------- }

procedure TMainForm.Menu_ProjetoSimplesClick(Sender: TObject);
begin
  CreateMDIChild('PROJETO ' + IntToStr(MDIChildCount + 1), True, False, TMenuItem(Sender).Tag);
end;

procedure TMainForm.Menu_ProjetoZoomClick(Sender: TObject);
begin
  CreateMDIChild('PROJETO ' + IntToStr(MDIChildCount + 1), True, False, TMenuItem(Sender).Tag);
end;

procedure TMainForm.Menu_Arquivo_AbrirClick(Sender: TObject);
var i: Integer;
begin
  OpenDialog.InitialDir := Applic.LastDir;
  if OpenDialog.Execute() then
     for i := 0 to OpenDialog.Files.Count-1 do
       begin
       Applic.LastDir := ExtractFilePath(OpenDialog.Files[i]);
       CreateMDIChild(OpenDialog.Files[i], False, False, -1);
       end;
end;

procedure TMainForm.Menu_Arquivo_SalvarClick(Sender: TObject);
begin
  if AreaDeProjeto = nil then Exit;
  try
    StartWait();
    AreaDeProjeto.Salvar();
  finally
    StopWait();
  end;
end;

procedure TMainForm.Menu_Arquivo_SalvarComoClick(Sender: TObject);
var oldName : String;
begin
  if AreaDeProjeto = nil then Exit;
  oldName := AreaDeProjeto.Projeto.NomeArquivo;
  AreaDeProjeto.Projeto.NomeArquivo := '';
  AreaDeProjeto.Salvar();
  if AreaDeProjeto.Projeto.NomeArquivo = '' then
     AreaDeProjeto.Projeto.NomeArquivo := oldName;
end;

procedure TMainForm.Menu_Arquivo_FecharClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     AreaDeProjeto.Close();
end;

procedure TMainForm.MenuFecharTodosClick(Sender: TObject);
begin
  FecharProjetos();
end;

procedure TMainForm.Menu_Arquivo_SairClick(Sender: TObject);
begin
  Close();
end;

procedure TMainForm.Menu_ExecutarScriptClick(Sender: TObject);
var s: String;
    p: TprProjeto;
    v: TVariable;
begin
  if AreaDeProjeto <> nil then
     begin
     p := TprProjeto(AreaDeProjeto.Projeto);
     s := cbScripts.Text;
     p.VerificaCaminho(s);
     end
  else
     begin
     p := nil;
     s := '';
     end;

  if p <> nil then
     begin
     v := TVariable.Create('Projeto', pvtObject, Integer(p), p.ClassType, True);
     RunScript(g_psLib, s, Applic.LastDir, nil, [v], p.GlobalObjects, False);
     end;
end;

procedure TMainForm.Menu_GerenciadorClick(Sender: TObject);
begin
  Gerenciador.Show();
end;

procedure TMainForm.Menu_MensagensClick(Sender: TObject);
begin
  Applic.ShowMessageForm();
end;

procedure TMainForm.Menu_Ver_MensagensClick(Sender: TObject);
begin
  gErros.Show();
end;

procedure TMainForm.Menu_Mostrar_VariaveisGlobaisClick(Sender: TObject);
var d: TGlobalObjects_ShowDialog;
begin
  if AreaDeProjeto = nil then Exit;
  d := TGlobalObjects_ShowDialog.Create(nil);
  d.Mostrar(AreaDeProjeto.Projeto.GlobalObjects, AreaDeProjeto.Projeto.Nome);
end;

procedure TMainForm.Menu_Projeto_PGClick(Sender: TObject);
begin
  AreaDeProjeto.Projeto.Editar();
end;

procedure TMainForm.Menu_ProjetoClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     begin
     Menu_Projeto_Visualizar_Demendas.Checked := AreaDeProjeto.MostrarDemandas;
     end;
end;

procedure TMainForm.Menu_Projeto_Visualizar_DemendasClick(Sender: TObject);
begin
  AreaDeProjeto.MostrarDemandas := not AreaDeProjeto.MostrarDemandas;
  Menu_Projeto_Visualizar_Demendas.Checked := AreaDeProjeto.MostrarDemandas;
  if AreaDeProjeto.MostrarDemandas then
     WriteStatus(StatusBar2, [' Demands: Visible '], false)
  else
     WriteStatus(StatusBar2, [' Demands: Not Visible '], false);
end;

procedure TMainForm.Menu_Projeto_Visualizar_TDClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     begin
     AreaDeProjeto.MostrarTrechos := not AreaDeProjeto.MostrarTrechos;
     Menu_Projeto_Visualizar_TD.Checked := AreaDeProjeto.MostrarTrechos;
     AreaDeProjeto.Atualizar();
     AreaDeProjeto.Projeto.Modificado := True;
     end;
end;

procedure TMainForm.Menu_Projeto_Visualizar_ImagemClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     begin
     AreaDeProjeto.MostrarFundo := not AreaDeProjeto.MostrarFundo;
     Menu_Projeto_Visualizar_Imagem.Checked := AreaDeProjeto.MostrarFundo;
     AreaDeProjeto.Atualizar();
     end;
end;

procedure TMainForm.Menu_Projeto_BloquearClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     begin
     AreaDeProjeto.Bloqueado := not AreaDeProjeto.Bloqueado;
     AtualizaBtnBloqueado();
     end;
end;

procedure TMainForm.Menu_LerFundoClick(Sender: TObject);
begin
  {$ifndef VERSAO_LIMITADA}
  if AreaDeProjeto <> nil then
     if OpenBitmap.Execute() then
        begin
        AreaDeProjeto.Projeto.ArqFundo := OpenBitmap.FileName;
        AreaDeProjeto.MostrarFundo := True;
        AreaDeProjeto.Atualizar();
        AreaDeProjeto.Projeto.Modificado := True;
        end;
  {$else}
  Applic.ShowLightMessage('Função desabilitada');
  {$endif}
end;

procedure TMainForm.Menu_LimparImagemClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     AreaDeProjeto.Projeto.ArqFundo := '';
end;

procedure TMainForm.Menu_RealizarDiagnosticoClick(Sender: TObject);
var b: Boolean;
begin
  if AreaDeProjeto = nil then Exit;
  b := AreaDeProjeto.Projeto.RealizarDiagnostico(True);
  Applic.SetGlobalStatus(b);

  if b then
     Applic.ShowMessage('Diagnóstico: Ok')
  else
     gErros.Show;
end;

procedure TMainForm.Menu_Projeto_SimularClick(Sender: TObject);
Const Completo = True;
begin
  if AreaDeProjeto = nil then
     Exit;
     
  if AreaDeProjeto.Projeto.RealizarDiagnostico(Completo) then
     begin
     {$ifdef VERSAO_LIMITADA}
     if AreaDeProjeto.Projeto.PCs.PCs >= 5 then
        begin
        Applic.ShowLightMessage('Somente uma rede com 5 PCs ou menos pode ser simulada');
        Exit;
        end;
     {$endif}

     btnExecutar.Enabled := False;
     btnParar.Enabled := True;
     SysUtilsEx.SaveDecimalSeparator();
     Try
       if AreaDeProjeto.Projeto.TipoSimulacao = tsWIN then
          btnParar.Enabled := True;

       AreaDeProjeto.Projeto.Executar();

       {$ifdef DEBUG}
       Applic.Debug.Clear();
       {$endif}
     Finally
       btnExecutar.Enabled := True;
       btnParar.Enabled := False;
       SysUtilsEx.RestoreDecimalSeparator()

       {$ifdef DEBUG}
       Applic.Debug.ShowModal();
       if MessageDLG('Deseja salvar o Resultado do Debug ?',
          mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          Applic.Debug.SaveToXmlFile(Applic.AppDir + '\Propagar.debug.xml');
       Applic.Debug.Clear();
       {$endif}
       End;
     end
  else
     gErros.Show()
end;

procedure TMainForm.Menu_Projeto_MonitorarClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     AreaDeProjeto.Monitor.Show;
end;

procedure TMainForm.Menu_Mostrar_PCClick(Sender: TObject);
var s: String;
begin
  if AreaDeProjeto = nil then Exit;
  s := 'Executando: ';
  if AreaDeProjeto.Projeto.ExecucaoCorrente <> '' then
     s := s + AreaDeProjeto.Projeto.ExecucaoCorrente
  else
     s := s + 'Indefinido';

  MessageDLG(s, mtInformation, [mbOK], 0);
end;

procedure TMainForm.Menu_Projeto_Otimizar_RosenClick(Sender: TObject);
begin
  Menu_Projeto_Otimizar_Rosen.Checked := true;
end;

procedure TMainForm.Menu_Projeto_Otimizar_GeneticClick(Sender: TObject);
begin
  Menu_Projeto_Otimizar_Genetic.Checked := true;
end;

procedure TMainForm.Menu_Projeto_Otimizar_GeneticMOClick(Sender: TObject);
begin
  Menu_Projeto_Otimizar_GeneticMO.Checked := true;
end;

procedure TMainForm.Menu_IntervalosClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     AreaDeProjeto.Projeto.MostrarIntervalos();
end;

procedure TMainForm.Menu_MatrizContribClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     AreaDeProjeto.Projeto.MostraMatrizDeContribuicao();
end;

procedure TMainForm.Menu_FalhasClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     AreaDeProjeto.Projeto.MostraFalhasNoAtendimentoDasDemandas();
end;

procedure TMainForm.Menu_Projeto_GerarEquacoesClick(Sender: TObject);
begin
  {$ifdef VERSAO_LIMITADA}
  Applic.ShowLightMessage('A geração de equações lineares não é permitido nesta versão');
  Exit;
  {$endif}
  
  with TprForm_Equacoes.Create(AreaDeProjeto.Projeto) do
    begin
    ShowModal();
    Free();
    end;
end;

procedure TMainForm.CD_CriarClick(Sender: TObject);
var DM: TprClasseDemanda;
     p: TMapPoint;
begin
  if AreaDeProjeto <> nil then
     begin
     {$ifdef VERSAO_LIMITADA}
     if AreaDeProjeto.Projeto.ClassesDeDemanda.Classes >= 5 then
        begin
        Applic.ShowLightMessage('Somente 5 Classes de Demanda são permitidas');
        Exit;
        end;
     {$endif}
     p.X := -99;
     DM := TprClasseDemanda.Create(p, AreaDeProjeto.Projeto, AreaDeProjeto.TabelaDeNomes);
     if DM.Editar() = mrOk then
        begin
        AreaDeProjeto.Projeto.ClassesDeDemanda.Adicionar(DM);
        Gerenciador.AdicionarObjeto(DM);
        end
     else
        DM.Free();
     end;
end;

procedure TMainForm.CD_EditarClick(Sender: TObject);
var DM  : TprDemanda;
begin
  DM := Gerenciador.CD_Selecionada;
  if (DM <> nil) then DM.Editar();
end;

procedure TMainForm.CD_RemoverClick(Sender: TObject);
var DM: TprDemanda;
begin
  if AreaDeProjeto = nil then Exit;
  DM := Gerenciador.CD_Selecionada;
  if DM <> nil then
     AreaDeProjeto.Projeto.ClassesDeDemanda.Remover(DM);
end;

procedure TMainForm.Menu_CD_TabelaClick(Sender: TObject);
var D: TprDialogoEscolherClasseDemanda;
    T: TprDialogoPlanilha_DemandasDeUmaClasse;
begin
  if AreaDeProjeto = nil then Exit;                     
  D := TprDialogoEscolherClasseDemanda.Create(self);
  D.Classes := AreaDeProjeto.Projeto.ClassesDeDemanda;
  Try
    if D.ShowModal = mrOk then
       begin
       T := TprDialogoPlanilha_DemandasDeUmaClasse.Create(self);
       T.Classe  := D.Classe;
       T.AreaDeProjeto := AreaDeProjeto;
       T.Show;
       end;
  Finally
    D.Release;
    End;
end;

procedure TMainForm.DistribuirDemandas1Click(Sender: TObject);
begin
  with TprDialogo_TVU_Distribuir.Create(nil) do
    begin
    Projeto := AreaDeProjeto.Projeto;
    ShowModal();
    Free();
    end;
end;

procedure TMainForm.Menu_MWSolverClick(Sender: TObject);
var r: Cardinal;
begin
  r := ShellExecute(Handle,
                    'Open',
                    pChar(Applic.AppDir + cTOOL_MWFoloder),
                    '',
                    pChar(Applic.AppDir + cPATH_MWFoloder),
                    SW_SHOWNORMAL);

  WinUtils.ShowShellExecuteError(r);
end;

procedure TMainForm.Menu_LPSolverIDEClick(Sender: TObject);
var r: Cardinal;
begin
  r := ShellExecute(Handle,
                    'Open',
                    pChar(Applic.AppDir + cTOOL_LPSolveIDE),
                    nil,
                    pChar(Applic.AppDir + cPATH_LPSolveIDE),
                    SW_SHOWNORMAL);

  WinUtils.ShowShellExecuteError(r);
end;

procedure TMainForm.Menu_AbrirUltPastaAcessadaClick(Sender: TObject);
var r: Cardinal;
begin
  r := ShellExecute(Handle, 'explore', pChar(Applic.LastDir), nil, nil, SW_SHOWNORMAL);
  WinUtils.ShowShellExecuteError(r);
end;

procedure TMainForm.Menu_Janelas_CascataClick(Sender: TObject);
begin
  Self.Cascade();
end;

procedure TMainForm.Menu_Janelas_HorizontalClick(Sender: TObject);
begin
  Self.TileMode := tbHorizontal;
  Self.Tile();
end;

procedure TMainForm.Menu_Janelas_VerticalClick(Sender: TObject);
begin
  Self.TileMode := tbVertical;
  Self.Tile();
end;

procedure TMainForm.Menu_Ajuda_SobreClick(Sender: TObject);
var d: TprDialogo_About;
begin
  d := TprDialogo_About.Create(nil);
  d.ShowModal();
  d.Free();
end;

procedure TMainForm.Menu_Ajuda_HistoricoClick(Sender: TObject);
begin
  with TForm_Historico.Create(nil) do
    begin
    ShowModal();
    Free();
    end;
end;

{ ------------------------- Botoes -----------------------}

procedure TMainForm.btnBloqueadoClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     begin
     AreaDeProjeto.Bloqueado := not AreaDeProjeto.Bloqueado;
     AtualizaBtnBloqueado();
     end;
end;

procedure TMainForm.btnMTClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     begin
     AreaDeProjeto.MostrarTrechos := not AreaDeProjeto.MostrarTrechos;
     Menu_Projeto_Visualizar_TD.Checked := AreaDeProjeto.MostrarTrechos;
     AreaDeProjeto.Atualizar();
     AreaDeProjeto.Projeto.Modificado := True;
     end;
end;

procedure TMainForm.btnImagemClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     begin
     AreaDeProjeto.MostrarFundo := not AreaDeProjeto.MostrarFundo;
     Menu_Projeto_Visualizar_Imagem.Checked := AreaDeProjeto.MostrarFundo;
     AreaDeProjeto.Atualizar();
     end;
end;

procedure TMainForm.btnGerenteClick(Sender: TObject);
begin
  Gerenciador.Show();
end;

procedure TMainForm.btnOtimizarClick(Sender: TObject);
begin
  if Menu_Projeto_Otimizar_Rosen.Checked then
     Otimizar( TRosenbrock.Create() )
  else
  if Menu_Projeto_Otimizar_Genetic.Checked then
     Otimizar( TGeneticOptimizer.Create() )
  else
     Otimizar( TGeneticMO_Optimizer.Create() );
end;

procedure TMainForm.btnPararClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     if AreaDeProjeto.Projeto.Status = sSimulando then
        AreaDeProjeto.Projeto.TerminarSimulacao
     else
        AreaDeProjeto.Projeto.TerminarOtimizacao();
end;

procedure TMainForm.btnHelpClick(Sender: TObject);
begin
  Menu_Ajuda_SobreClick(Sender);
end;

procedure TMainForm.btnExecutarScriptClick(Sender: TObject);
var p: TprProjeto;
    v: TVariable;
    x: TPascalScript;
    s: String;
begin
  if AreaDeProjeto = nil then Exit;

  p := TprProjeto(AreaDeProjeto.Projeto);
  if p <> nil then
     v := TVariable.Create('Projeto', pvtObject, Integer(p), p.ClassType, True);

  btnExecutarScript.Enabled := False;
  btnPararScript.Enabled := True;

  s := cbScripts.Text;
  p.VerificaCaminho(s);

  x := TPascalScript.Create;
  try
    x.Code.LoadFromFile(s);
    x.Variables.AddVar(v);
    x.GlobalObjects := p.GlobalObjects;
    x.AssignLib(g_psLib);
    if x.Compile() then
       x.Execute()
    else
       Dialogs.ShowMessage(x.Errors.Text);
  finally
    btnExecutarScript.Enabled := True;
    btnPararScript.Enabled := False;
    x.Free();
  end;
end;

procedure TMainForm.btnEditarScriptClick(Sender: TObject);
var s: String;
    p: TprProjeto;
    v: TVariable;
begin
  if AreaDeProjeto <> nil then
     begin
     p := TprProjeto(AreaDeProjeto.Projeto);
     s := cbScripts.Text;
     p.VerificaCaminho(s);
     end
  else
     begin
     p := nil;
     s := '';
     end;

  if p <> nil then
     begin
     v := TVariable.Create('Projeto', pvtObject, Integer(p), p.ClassType, True);
     RunScript(g_psLib, s, Applic.LastDir, nil, [v], p.GlobalObjects, False);
     end;
end;

procedure TMainForm.Ferramentas_Click(Sender: TObject);
var sb: TTBXItem;
begin
  sb := TTBXItem(Sender);
  if sb.Checked then
     if sb.Name = 'sbArrastar' then
        Applic.ShowMessage('')
     else
        begin
        if sb.Name = 'sbCriarPC'        then Applic.ShowMessage(cMsgAjuda03) else
        if sb.Name = 'sbCriarSubBacia'  then Applic.ShowMessage(cMsgAjuda02) else
        if sb.Name = 'sbCriarTrecho'    then Applic.ShowMessage(cMsgAjuda01) else
        if sb.Name = 'sbInserirPCEntre' then Applic.ShowMessage(cMsgAjuda05) else
        if sb.Name = 'sbPCReservatorio' then Applic.ShowMessage(cMsgAjuda08) else
        if sb.Name = 'sbCriarDescarga'  then Applic.ShowMessage(cMsgAjuda10) else
        if sb.Name = 'sbCriarQA'        then Applic.ShowMessage(cMsgAjuda11) else
        if sb.Name = 'sbCriarDemanda'   then Applic.ShowMessage(cMsgAjuda07) ;

        Applic.ShowMessageForm();
        end;
end;

procedure TMainForm.sbCriarCenarioDemandaClick(Sender: TObject);
var sb: TTBXItem;
begin
  Applic.ShowMessage(cMsgAjuda09);
  sb := TTBXItem(Sender);
  if sb.Checked then
     begin
     MenuCenarios.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
     end;
end;

procedure TMainForm.sbRemoverObjetoClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     begin
     AreaDeProjeto.RemoverObjeto(AreaDeProjeto.ObjetoSelecionado);
     sbArrastar.Checked := True;
     end;
end;

procedure TMainForm.sbRemoverTrechoClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     begin
     if AreaDeProjeto.ObjetoSelecionado is TprPC then
        TprPC(AreaDeProjeto.ObjetoSelecionado).RemoverTrecho();

     AreaDeProjeto.Atualizar();
     AreaDeProjeto.Projeto.Modificado := True;
     sbArrastar.Checked := True;
     AtualizarMenus(AreaDeProjeto.ObjetoSelecionado);
     end;
end;

procedure TMainForm.sbPC_TO_RESClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     begin
     AreaDeProjeto.PC_TO_RES(TprPCP(AreaDeProjeto.ObjetoSelecionado));
     sbArrastar.Checked := True;
     end;
end;

procedure TMainForm.sbRES_TO_PCClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     begin
     AreaDeProjeto.RES_TO_PC(TprPCPR(AreaDeProjeto.ObjetoSelecionado));
     sbArrastar.Checked := True;
     end;
end;

{ ------------------------- outros eventos -------------------------}

procedure TMainForm.MenuCenariosPopup(Sender: TObject);
var i: Integer;
    m: TMenuItem;
    p: TPlugin;
    b: TBitmap;
begin
  MenuCenarios.Items.Clear();
  for i := 0 to Applic.Plugins.Count-1 do
    begin
    p := Applic.Plugins.Item[i];
    m := TMenuItem.Create(nil);

    m.Tag := i;
    m.Caption := p.Factory.ToString();
    m.OnClick := MenuCenarioClick;

    b := p.Factory.getBitmap('');
    if b <> nil then
       m.Bitmap.Handle := b.Handle;

    MenuCenarios.Items.Add(m);
    end;
end;

procedure TMainForm.EventosMessage(var Msg: tagMSG; var Handled: Boolean);
var s: String;
begin
  case Msg.message of
    AM_ABRIR_ARQUIVO,
    AM_ABRIR_APAGAR_ARQUIVO:
      begin
      s := MC.AsString;
      CreateMDIChild(s, False, False, -1);
      if Msg.message = AM_ABRIR_APAGAR_ARQUIVO then DeleteFile(s);
      end;
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FecharProjetos();
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  GetMessageManager.RegisterMessage(UM_CLICK_GERENTE, self);
  GetMessageManager.RegisterMessage(UM_COMENTARIO_OBJETO_MUDOU, self);
  GetMessageManager.RegisterMessage(UM_DESCRICAO_OBJETO_MUDOU, self);
  GetMessageManager.RegisterMessage(UM_NOME_OBJETO_MUDOU, self);

  MC := TSharedMem.Create('MC_PROGRAMA_PROPAGAR', 1024);
  Screen.OnActiveFormChange := FormChange;
  ShellAPI.DragAcceptFiles(Handle, True);

  //btnBloqueado.Glyph.LoadFromResourceName(HInstance, 'CADEADO_ABERTO');

  //btnEditarScript.Left   := PainelPrincipal.Width - btnEditarScript.Width - 3;
  //btnPararScript.Left    := btnEditarScript.Left - btnPararScript.Width - 1;
  //btnExecutarScript.Left := btnPararScript.Left - btnExecutarScript.Width;
  //cbScripts.Width        := PainelPrincipal.Width - 3 * btnExecutarScript.Width - cbScripts.Left - 6;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  MC.Free();
  GetMessageManager.UnregisterMessage(UM_CLICK_GERENTE, self);
  GetMessageManager.UnregisterMessage(UM_COMENTARIO_OBJETO_MUDOU, self);
  GetMessageManager.UnregisterMessage(UM_DESCRICAO_OBJETO_MUDOU, self);
  GetMessageManager.UnregisterMessage(UM_NOME_OBJETO_MUDOU, self);
end;

procedure TMainForm.FormShow(Sender: TObject);
var i: Integer;
    s1, s2: String;
begin
  Applic.StatusBar := StatusBar;
  Applic.StatusLed := Leds;
{
  Menu_Arquivo_Abrir.Enabled := not gBloqueado;
  Menu_Arquivo_Novo.Enabled  := not gBloqueado;
  btnNovo.Enabled            := not gBloqueado;
  btnAbrir.Enabled           := not gBloqueado;
  sbCriarPC.Enabled          := not gBloqueado;
  sbCriarSubBacia.Enabled    := not gBloqueado;
  sbCriarDescarga.Enabled    := not gBloqueado;
  sbCriarQA.Enabled          := not gBloqueado;
  sbPCReservatorio.Enabled   := not gBloqueado;
  sbRemoverTrecho.Enabled    := not gBloqueado;
  sbCriarTrecho.Enabled      := not gBloqueado;
  sbSB_em_PC.Enabled         := not gBloqueado;
  sbInserirPCEntre.Enabled   := not gBloqueado;
  sbPC_To_Res.Enabled        := not gBloqueado;
  sbRes_To_PC.Enabled        := not gBloqueado;
}
  for i := 1 to ParamCount do
    if SubStrings('=', s1, s2, ParamStr(i)) > 0 then
       if CompareText(s1, 'ARQUIVO') = 0 then
          begin
          if FileExists(s2) then
             begin
             CreateMDIChild(s2, False, True, -1);
             Applic.LastDir := ExtractFilePath(s2);
             end;
          end
       else
{
       if CompareText(s1, 'MODO') = 0 then
          begin
          end
       else
       if (CompareText(s1, 'SENHA') = 0) and gBloqueado then
          begin
          gBloqueado := not (s2 = intToStr(1803));
          end;
}
end;

{ ------------------------- Metodos ------------------------}

procedure TMainForm.AtualizaBtnBloqueado();
begin
  if AreaDeProjeto <> nil then
     if AreaDeProjeto.Bloqueado then
        btnBloqueado.ImageIndex := 3
     else
        btnBloqueado.ImageIndex := 2;
end;

procedure TMainForm.DescreverObjeto(HC: THidroComponente);
begin
  if HC.Descricao <> '' then
     Applic.ShowMessage(HC.Descricao + #13 + HC.Comentarios.Text)
  else
     Applic.ShowMessage(HC.Comentarios.Text)
end;

procedure TMainForm.FecharProjetos();
var i: Integer;
begin
  for i := Screen.FormCount-1 downto 0 do
    if Screen.Forms[i] is TfoAreaDeProjeto_Base then
       TfoAreaDeProjeto_Base(Screen.Forms[i]).Close();
end;

procedure TMainForm.FinalizarOtimizacao();
begin
  Menu_Projeto_Simular.Enabled := true;
  Menu_Projeto_Otimizar.Enabled := true;
  btnParar.Enabled := false;
  btnExecutar.Enabled := true;
  btnOtimizar.Enabled := true;
end;

procedure TMainForm.FormChange(Sender: TObject);
begin
  if not (csDestroying in self.ComponentState) then
     if (self.MDIChildCount > 0) then
        if AreaDeProjeto <> nil then
           AtualizarMenus(AreaDeProjeto.ObjetoSelecionado)
        else
           AtualizarMenus(nil)
     else
        AtualizarMenus(nil);
end;

procedure TMainForm.IniciarOtimizacao();
begin
  btnExecutar.Enabled := false;
  btnOtimizar.Enabled := false;
  btnParar.Enabled := true;
  Menu_Projeto_Simular.Enabled := false;
  Menu_Projeto_Otimizar.Enabled := false;
end;

procedure TMainForm.MenuCenarioClick(Sender: TObject);
var m: TMenuItem;
begin
  m := TMenuItem(Sender);
  sbCriarCenarioDemanda.Hint := m.Hint;
  if m.Bitmap.Handle <> 0 then
     begin
     sbCriarCenarioDemanda.Caption := '';
     //sbCriarCenarioDemanda.Glyph.Handle := m.Bitmap.Handle;
     end
  else
     sbCriarCenarioDemanda.Caption := 'C';

  Applic.Plugins.ActiveObjFactoryIndex := m.Tag;
end;

function TMainForm.ObtemAreaDeProjetoAtiva(): TfoAreaDeProjeto_Base;
begin
  if ActiveMDIChild is TfoAreaDeProjeto_Base then
     Result := TfoAreaDeProjeto_Base(ActiveMDIChild)
  else
     Result := nil;
end;

procedure TMainForm.Otimizar(Otimizador: TOptimizer);
begin
  if AreaDeProjeto <> nil then
     try
       IniciarOtimizacao();
       Otimizador.Optimize(AreaDeProjeto.Projeto);
     finally
       FinalizarOtimizacao();
       Otimizador.Free();
     end;
end;

function TMainForm.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_CLICK_GERENTE then
     AtualizarMenus(MSG.ParamAsPointer(0))
  else
  if (MSG.ID = UM_COMENTARIO_OBJETO_MUDOU) or
     (MSG.ID = UM_DESCRICAO_OBJETO_MUDOU) or
     (MSG.ID = UM_NOME_OBJETO_MUDOU) then
     DescreverObjeto( THidroComponente(MSG.ParamAsObject(0)) )
  else
end;

procedure TMainForm.TrataAvisoDaAreaDeProjeto(const Aviso: String);
begin
  Applic.ShowMessage(Aviso);
end;

procedure TMainForm.TrataMensagemDaAreaDeProjeto(const ID: String; Objeto: TObject);
var HC: THidroComponente;
begin
  HC := THidroComponente(Objeto);

  if CompareText(ID, 'Descrever Objeto') = 0 then
     DescreverObjeto(HC)
  else

  if CompareText(ID, 'Atualizar Opcoes') = 0 then
     begin
     AtualizarMenus(HC);
     end
  else

  if CompareText(ID, 'Destruicao da Area de Projeto') = 0 then
     begin
     Applic.ClearMessages();
     end
{TODO 1 -cGIS: sbInfo}
{
  else
  if CompareText(ID, 'Selecionar Botao Sel/Info') = 0 then
     begin
     if not (sbInfo.Checked or sbSel.Checked) then
        sbSel.Checked := true;
     end
}
  else
end;

function TMainForm.TrataStatusDoBotaoDaAreaDeProjeto(const ID_Botao: String): boolean;
begin
{TODO 1 -cGIS: sbSel}
{
  if CompareText(ID_Botao, 'Selecionar') = 0 then
     Result := sbSel.Checked
  else
}
  if CompareText(ID_Botao, 'Arrastar') = 0 then
     Result := sbArrastar.Checked
  else

{TODO 1 -cGIS: sbInfo}
{
  if CompareText(ID_Botao, 'Ver Registros') = 0 then
     Result := sbInfo.Checked
  else
}

  if CompareText(ID_Botao, 'Conectar SB em PC') = 0 then
     Result := sbSB_em_PC.Checked
  else
  if CompareText(ID_Botao, 'Criar Reservatorio') = 0 then
     Result := sbPCReservatorio.Checked
  else
  if CompareText(ID_Botao, 'Criar PC') = 0 then
     Result := sbCriarPC.Checked
  else
  if CompareText(ID_Botao, 'Criar SB') = 0 then
     Result := sbCriarSubBacia.Checked
  else
  if CompareText(ID_Botao, 'Criar Descarga') = 0 then
     Result := sbCriarDescarga.Checked
  else
  if CompareText(ID_Botao, 'Criar QA') = 0 then
     Result := sbCriarQA.Checked
  else
  if CompareText(ID_Botao, 'Criar Demanda') = 0 then
     Result := sbCriarDemanda.Checked
  else
  if CompareText(ID_Botao, 'Criar TD') = 0 then
     Result := sbCriarTrecho.Checked
  else
  if CompareText(ID_Botao, 'Inserir PC') = 0 then
     Result := sbInserirPCEntre.Checked
  else
  if CompareText(ID_Botao, 'Criar Cenario de Demanda') = 0 then
     Result := sbCriarCenarioDemanda.Checked
  else
     Result := False;
end;

procedure TMainForm.WMDROPFILES(var Message: TWMDROPFILES);
var NumFiles : longint;
    i : longint;
    buffer : array[0..255] of char;
begin
  NumFiles := ShellAPI.DragQueryFile(Message.Drop, $FFFFFFFF, nil, 0);
  for i := 0 to (NumFiles - 1) do
    begin
    DragQueryFile(Message.Drop, i, @buffer, sizeof(buffer));
    Applic.LastDir := ExtractFilePath(buffer);
    CreateMDIChild(buffer, False, False, -1);
    end;
end;

procedure TMainForm.AtualizarMenus(Obj: THidroComponente);
var b: Boolean;
begin
  b := (AreaDeProjeto <> nil);

  Menu_Janelas.Enabled := (MDIChildCount > 0);

  if b then
     begin
     Applic.WriteStatus(['Active Project: ' + AreaDeProjeto.Projeto.Nome], false);

     if not AreaDeProjeto.Projeto.Scripts.Equals(cbScripts.Strings) then
        begin

        cbScripts.Strings.Assign(AreaDeProjeto.Projeto.Scripts);
        btnExecutarScript.Enabled := (cbScripts.Count > 0);
        btnEditarScript.Enabled := btnExecutarScript.Enabled;
        if btnExecutarScript.Enabled then cbScripts.ItemIndex := 0;
        end;
     end
  else
     begin
     Applic.WriteStatus([''], false);
     Gerenciador.AreaDeProjeto := nil;
     cbScripts.Clear();
     btnExecutarScript.Enabled := False;
     btnPararScript.Enabled := False;
     btnEditarScript.Enabled := False;
     end;

  // Menus
  Menu_Projeto.Enabled := b;
  Menu_Demandas.Enabled := b;
  Menu_Arquivo_SalvarComo.Enabled := b;
  Menu_Arquivo_Salvar.Enabled := b;
  Menu_Arquivo_Fechar.Enabled := b;
  Menu_Mostrar_VariaveisGlobais.Enabled := b;
  Menu_LimparImagem.Enabled := b and not (AreaDeProjeto is TfoAreaDeProjeto_Zoom);

  Menu_Projeto_Monitorar.Enabled := b and (AreaDeProjeto.Projeto.TipoSimulacao = tsWIN);
  if b and AreaDeProjeto.Monitor.Visible and (AreaDeProjeto.Projeto.TipoSimulacao = tsDOS) then
     AreaDeProjeto.Monitor.Hide();

  // Botões
  btnImagem.Enabled := Menu_LimparImagem.Enabled;
  btnMT.Enabled := b;
  btnSalvar.Enabled := b;
  btnDiagnostico.Enabled := b;
  btnBloqueado.Enabled := b;
  btnOpcoesProjeto.Enabled := b;
  AtualizaBtnBloqueado();

  btnExecutar.Enabled := (b and (AreaDeProjeto.Projeto.Status = sFazendoNada));
  btnOtimizar.Enabled := btnExecutar.Enabled;

  // ATENCAO: Classes de demanda sao removidas por menu

  sbRemoverObjeto.Enabled   := (Obj is TprPC) or
                               (Obj is TprSubBacia) or
                               (Obj is TprDemanda) or
                               (Obj is TprDescarga) or
                               (Obj is TprQualidadeDaAgua) or
                               (Obj is TprCenarioDeDemanda);

  sbRemoverTrecho.Enabled   := (Obj is TprPC) and
                               (TprPC(Obj).TrechoDagua <> nil) and
                               (TprPC(Obj).TrechoDagua.PC_aJusante <> nil);

  sbPC_TO_RES.Enabled       := (Obj is TprPC) and not (Obj is TprPCPR);

  sbRES_TO_PC.Enabled       := (Obj is TprPCPR);

  b := (Obj is TprClasseDemanda) and not (Obj is TprDemanda);
  CD_Editar.Enabled := b;
  CD_Remover.Enabled := b;
  sbCriarDemanda.Enabled := b;

  if b then
     sbCriarDemanda.Hint := Format(cMsgInfo03, [Obj.Nome]);
end;

function TMainForm.CreateMDIChild(const Name: string; Novo, Max: Boolean; TipoNovo: integer): TfoAreaDeProjeto_Base;
var sl: TStrings;
     s: string;
begin
  if Novo then
     case TipoNovo of
       0: s := cTP_ScrollCanvas;
       1: s := cTP_ZoomPanel;
       end
  else
     begin
     sl := SysUtilsEx.LoadTextFile(Name);

     if (sl.Count > 2) and (System.Pos('Project Type:', sl[2]) > 0) then
        s := SysUtilsEx.SubString(sl[2], '[', ']')
     else
        s := cTP_ScrollCanvas;

     sl.Free();
     end;

  // Criacao do projeto ..................................

  if s = cTP_ScrollCanvas then
     Result := TfoAreaDeProjeto_BMP.Create() else

  if s = cTP_ZoomPanel then
     Result := TfoAreaDeProjeto_Zoom.Create()
  else
     raise Exception.Create('Tipo de projeto não conhecido: ' + s);

  // Coneccao dos Eventos gerais .........................

  Result.Evento_Mensagem      := TrataMensagemDaAreaDeProjeto;
  Result.Evento_StatusDoBotao := TrataStatusDoBotaoDaAreaDeProjeto;
  Result.Evento_Aviso         := TrataAvisoDaAreaDeProjeto;

  if Novo then
     Result.Projeto.Modificado := True
  else
     try
       StartWait;
       Result.Enabled := false;
       Result.Projeto.LoadFromXML(Name);
       if s = cTP_ZoomPanel then TfoAreaDeProjeto_Zoom(Result).Fit();
       if Max then Result.WindowState := wsMaximized;
     finally
       Result.Enabled := true;
       StopWait;
     end;

  AtualizarMenus(nil);
end;

end.
