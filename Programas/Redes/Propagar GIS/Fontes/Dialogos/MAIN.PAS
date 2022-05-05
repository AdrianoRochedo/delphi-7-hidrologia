unit Main;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, pr_Classes, FileCtrl, Mask,
  pr_AreaDeProjeto, MessageManager, ExtDlgs, AppEvnts, SysUtilsEx,
  hidro_Form_LayersManager,
  hidro_Form_GlobalMessages;

type
  TfoMain = class(TForm, IMessageReceptor)
    Menu: TMainMenu;
    Menu_Arquivo: TMenuItem;
    Menu_Arquivo_Novo: TMenuItem;
    Menu_Arquivo_Abrir: TMenuItem;
    Menu_Arquivo_Fechar: TMenuItem;
    Menu_Janelas: TMenuItem;
    Menu_Ajuda: TMenuItem;
    N1: TMenuItem;
    Menu_Arquivo_Sair: TMenuItem;
    Menu_Janelas_Cascata: TMenuItem;
    Menu_Janelas_Horizontal: TMenuItem;
    Menu_Ajuda_Sobre: TMenuItem;
    OpenDialog: TOpenDialog;
    Menu_Arquivo_Salvar: TMenuItem;
    Menu_Arquivo_SalvarComo: TMenuItem;
    Menu_Janelas_Vertical: TMenuItem;
    LI: TImageList;
    Menu_Editar_Visualizar: TMenuItem;
    Ferramentas: TPanel;
    sbSel: TSpeedButton;
    sbCriarPC: TSpeedButton;
    sbCriarSubBacia: TSpeedButton;
    sbCriarTrecho: TSpeedButton;
    sbSB_em_PC: TSpeedButton;
    sbInserirPCEntre: TSpeedButton;
    sbCriarDemanda: TSpeedButton;
    sbRemoverObjeto: TSpeedButton;
    Panel1: TPanel;
    Panel2: TPanel;
    StatusBar: TStatusBar;
    Leds: TImage;
    Menu_Projeto: TMenuItem;
    Menu_RealizarDiagnostico: TMenuItem;
    Menu_ClassesDemanda: TMenuItem;
    CD_Criar: TMenuItem;
    CD_Editar: TMenuItem;
    CD_Remover: TMenuItem;
    Menu_Projeto_Simular: TMenuItem;
    GerarArquivos: TSaveDialog;
    sbRemoverTrecho: TSpeedButton;
    Menu_Editar_Editor: TMenuItem;
    Menu_Gerenciador: TMenuItem;
    N3: TMenuItem;
    Menu_MatrizContrib: TMenuItem;
    Menu_Falhas: TMenuItem;
    Menu_Intervalos: TMenuItem;
    sbPC_TO_RES: TSpeedButton;
    sbRES_TO_PC: TSpeedButton;
    Menu_RelatorioGeral: TMenuItem;
    PainelPrincipal: TPanel;
    btnNovo: TSpeedButton;
    btnAbrir: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnGerente: TSpeedButton;
    btnEditor: TSpeedButton;
    btnCascata: TSpeedButton;
    btnHor: TSpeedButton;
    btnVert: TSpeedButton;
    btnHelp: TSpeedButton;
    btnDiagnostico: TSpeedButton;
    btnExecutar: TSpeedButton;
    N5: TMenuItem;
    Menu_CD_Tabela: TMenuItem;
    PS: TPanel;
    Menu_Ver_MensagensErro: TMenuItem;
    btnZoom100: TSpeedButton;
    btnMT: TSpeedButton;
    btnEspecial_1: TButton;
    btnEspecial_2: TButton;
    btnEspecial_3: TButton;
    Eventos: TApplicationEvents;
    Menu_Projeto_Visualizar_Demendas: TMenuItem;
    Menu_Mostrar_VariaveisGlobais: TMenuItem;
    btnParar: TSpeedButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Menu_ExecutarScript: TMenuItem;
    Menu_Mostrar_PC: TMenuItem;
    Menu_Projeto_Otimizar: TMenuItem;
    cbScripts: TComboBox;
    btnExecutarScript: TSpeedButton;
    btnPararScript: TSpeedButton;
    btnEditarScript: TSpeedButton;
    Menu_Ajuda_Historico: TMenuItem;
    StatusBar2: TStatusBar;
    Label1: TLabel;
    Menu_Projeto_Monitorar: TMenuItem;
    N2: TMenuItem;
    Menu_Projeto_Visualizar_TD: TMenuItem;
    Menu_Projeto_Visualizar_Imagem: TMenuItem;
    Menu_Projeto_Visualizar: TMenuItem;
    N7: TMenuItem;
    Menu_Projeto_Bloquear: TMenuItem;
    btnOtimizar: TSpeedButton;
    N8: TMenuItem;
    Menu_Projeto_PG: TMenuItem;
    Bevel6: TBevel;
    btnOpcoesProjeto: TSpeedButton;
    sbArrastar: TSpeedButton;
    Menu_Projeto_AdicionarCamada: TMenuItem;
    N6: TMenuItem;
    Menu_Projeto_Zoom100: TMenuItem;
    N9: TMenuItem;
    OpenLayer: TOpenPictureDialog;
    N10: TMenuItem;
    N11: TMenuItem;
    Menu_Arquivo_Novo_Projeto: TMenuItem;
    Menu_Arquivo_Novo_ProjetoBranco: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    Menu_Importar: TMenuItem;
    Menu_Importar_rede: TMenuItem;
    N14: TMenuItem;
    Menu_Ver_Mensagens: TMenuItem;
    sbInfo: TSpeedButton;
    sbPCReservatorio: TSpeedButton;
    Menu_Demandas: TMenuItem;
    Menu_Demanda_DD: TMenuItem;
    procedure NovoArquivo_Click(Sender: TObject);
    procedure AbrirArquivo_Click(Sender: TObject);
    procedure HelpAbout_Click(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure sbRemoveObjeto_Click(Sender: TObject);
    procedure Ferramentas_Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Menu_Arquivo_SalvarComoClick(Sender: TObject);
    procedure Diagnostico_Click(Sender: TObject);
    procedure CD_CriarClick(Sender: TObject);
    procedure Editar_Click(Sender: TObject);
    procedure CD_RemoverClick(Sender: TObject);
    procedure Menu_Projeto_SimularClick(Sender: TObject);
    procedure Cascata_Click(Sender: TObject);
    procedure Horizontal_Click(Sender: TObject);
    procedure Vertical_Click(Sender: TObject);
    procedure SalvarArquivo_Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Menu_Arquivo_FecharClick(Sender: TObject);
    procedure sbRemoverTrechoClick(Sender: TObject);
    procedure MostrarEditor_Click(Sender: TObject);
    procedure MostrarGerenciador_Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Menu_MatrizContribClick(Sender: TObject);
    procedure GraficosSalvos_Click(Sender: TObject);
    procedure Menu_FalhasClick(Sender: TObject);
    procedure Menu_IntervalosClick(Sender: TObject);
    procedure sbPC_TO_RESClick(Sender: TObject);
    procedure sbRES_TO_PCClick(Sender: TObject);
    procedure RelatorioGeral_Click(Sender: TObject);
    procedure Help_Click(Sender: TObject);
    procedure Menu_CD_TabelaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Menu_Ver_MensagensErroClick(Sender: TObject);
    procedure btnMTClick(Sender: TObject);
    procedure EventosMessage(var Msg: tagMSG; var Handled: Boolean);
    procedure Menu_Projeto_Visualizar_DemendasClick(Sender: TObject);
    procedure Menu_ProjetoClick(Sender: TObject);
    procedure Menu_Mostrar_VariaveisGlobaisClick(Sender: TObject);
    procedure btnPararClick(Sender: TObject);
    procedure Menu_ExecutarScriptClick(Sender: TObject);
    procedure Menu_Mostrar_PCClick(Sender: TObject);
    procedure Menu_Projeto_OtimizarClick(Sender: TObject);
    procedure btnExecutarScriptClick(Sender: TObject);
    procedure Menu_Ajuda_HistoricoClick(Sender: TObject);
    procedure Menu_Projeto_MonitorarClick(Sender: TObject);
    procedure Menu_Projeto_PGClick(Sender: TObject);
    procedure Menu_Projeto_AdicionarCamada_Click(Sender: TObject);
    procedure Menu_Projeto_Zoom100_Click(Sender: TObject);
    procedure Menu_Arquivo_Novo_ProjetoBranco_Click(Sender: TObject);
    procedure Menu_Importar_redeClick(Sender: TObject);
    procedure Menu_Ver_MensagensClick(Sender: TObject);
    procedure Menu_Demanda_DD_Click(Sender: TObject);
  private
    MC       : TSharedMem;
    FGM      : ThidroForm_GlobalMessages;

    procedure DescreverObjeto(HC: THidroComponente);

    function  GetProjetoAtivo: TprDialogo_AreaDeProjeto;
    procedure FormChange(Sender: TObject);

    procedure WMDROPFILES(var Message: TWMDROPFILES); message WM_DROPFILES;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean;

    // Tratamento dos eventos proviniente da área de projeto
    procedure TrataMensagemDaAreaDeProjeto(const ID: String; Objeto: TObject);
    function  TrataStatusDoBotaoDaAreaDeProjeto(const ID_Botao: String): boolean;
    procedure TrataAvisoDaAreaDeProjeto(const Aviso: String);
  public
    // CCB - com camada em branco
    function CreateMDIChild(const Name: string; Novo, Max, CCB: Boolean): TprDialogo_AreaDeProjeto;

    // Execute um script
    procedure RunScript(const Name: String);

    procedure AtualizarMenus(Obj: THidroComponente);
    property  ProjetoAtivo: TprDialogo_AreaDeProjeto read GetProjetoAtivo;
  end;

  var
    foMain: TfoMain;

implementation
uses pr_Const, pr_Vars, pr_Tipos, ShellAPI,
     WinUtils,
     MapObjects,
     pr_Funcoes,
     AboutForm,
     pr_Gerenciador,
     Edit,
     drGraficos,
     psEditor,
     psBASE,
     psCORE,
     pr_Dialogo_Demanda_TVU_Distribuir,
     pr_Dialogo_Planilha_DemandasDeUmaClasse,
     pr_Dialogo_EscolherClasseDemanda,
     Lib_GlobalObjects_ShowDialog,
     Historico;

{$R *.DFM}
{$R IMAGENS.RES}

procedure TfoMain.TrataAvisoDaAreaDeProjeto(const Aviso: String);
begin
  FGM.Message := Aviso;
end;

procedure TfoMain.TrataMensagemDaAreaDeProjeto(const ID: String; Objeto: TObject);
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
     FGM.Clear;
     end
  else

  if CompareText(ID, 'Selecionar Botao Sel/Info') = 0 then
     begin
     if not (sbInfo.Down or sbSel.Down) then
        sbSel.Down := true;
     end
  else
end;

function TfoMain.TrataStatusDoBotaoDaAreaDeProjeto(const ID_Botao: String): boolean;
begin
  if CompareText(ID_Botao, 'Selecionar') = 0 then
     Result := sbSel.Down
  else
  if CompareText(ID_Botao, 'Arrastar') = 0 then
     Result := sbArrastar.Down
  else
  if CompareText(ID_Botao, 'Ver Registros') = 0 then
     Result := sbInfo.Down
  else
  if CompareText(ID_Botao, 'Conectar SB em PC') = 0 then
     Result := sbSB_em_PC.Down
  else
  if CompareText(ID_Botao, 'Criar Reservatorio') = 0 then
     Result := sbPCReservatorio.Down
  else
  if CompareText(ID_Botao, 'Criar PC') = 0 then
     Result := sbCriarPC.Down
  else
  if CompareText(ID_Botao, 'Criar SB') = 0 then
     Result := sbCriarSubBacia.Down
  else
  if CompareText(ID_Botao, 'Criar Demanda') = 0 then
     Result := sbCriarDemanda.Down
  else
  if CompareText(ID_Botao, 'Criar TD') = 0 then
     Result := sbCriarTrecho.Down
  else
  if CompareText(ID_Botao, 'Inserir PC') = 0 then
     Result := sbInserirPCEntre.Down
  else
     Result := False;
end;

// CCB - com vamada em branco
function TfoMain.CreateMDIChild
  (const Name: string; Novo, Max, CCB: Boolean): TprDialogo_AreaDeProjeto;
begin
  Result := TprDialogo_AreaDeProjeto.Create(Application);

  // Conecta os Eventos
  Result.Evento_Mensagem      := TrataMensagemDaAreaDeProjeto;
  Result.Evento_StatusDoBotao := TrataStatusDoBotaoDaAreaDeProjeto;
  Result.Evento_Aviso         := TrataAvisoDaAreaDeProjeto;

  if Novo then
     begin
     Result.Projeto.Modificado := True;
     Result.mmMensagemInicial.Visible := True;
     if CCB then
        begin
        Result.Map.Visible := False;
        Result.Projeto.AddLayer(gExePath + 'Null_Layer\Null_Layer.shp');
        Result.Map.Visible := True;
        end;
     end
  else
     try
       StartWait;
       Result.Projeto.LerDoArquivo(Name, False);
       if Max then Result.WindowState := wsMaximized;
     finally
       StopWait;
     end;

  AtualizarMenus(nil);
end;

procedure TfoMain.NovoArquivo_Click(Sender: TObject);
begin
  CreateMDIChild('PROJETO ' + IntToStr(MDIChildCount + 1), True, False, False);
end;

procedure TfoMain.Menu_Arquivo_Novo_ProjetoBranco_Click(Sender: TObject);
begin
  CreateMDIChild('PROJETO ' + IntToStr(MDIChildCount + 1), True, False, True);
end;

procedure TfoMain.AbrirArquivo_Click(Sender: TObject);
var i: Integer;
begin
  OpenDialog.InitialDir := gDir;
  if OpenDialog.Execute then
     for i := 0 to OpenDialog.Files.Count-1 do
       begin
       gDir := ExtractFilePath(OpenDialog.Files[i]);
       CreateMDIChild(OpenDialog.Files[i], False, False, False);
       end;
end;

procedure TfoMain.HelpAbout_Click(Sender: TObject);
var d: TprDialogo_About;
begin
  d := TprDialogo_About.Create(nil);
  d.ShowModal;
  d.Free;
end;

procedure TfoMain.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

// Barra de ferramentas -----------------------------------------------------

procedure TfoMain.sbRemoveObjeto_Click(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     begin
     ProjetoAtivo.RemoverObjeto(ProjetoAtivo.ObjetoSelecionado);
     sbArrastar.Down := True;
     end;
end;

procedure TfoMain.sbPC_TO_RESClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     begin
     ProjetoAtivo.PC_TO_RES(TprPCP(ProjetoAtivo.ObjetoSelecionado));
     sbArrastar.Down := True;
     end;
end;

procedure TfoMain.sbRES_TO_PCClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     begin
     ProjetoAtivo.RES_TO_PC(TprPCPR(ProjetoAtivo.ObjetoSelecionado));
     sbArrastar.Down := True;
     end;
end;

procedure TfoMain.Ferramentas_Click(Sender: TObject);
var sb: TSpeedButton;
begin                                                 
  sb := TSpeedButton(Sender);
  if not sb.Down then Exit;
  if sb.Name = 'sbArrastar'       then  ShowMessage('Arrastar Objeto') else
  if sb.Name = 'sbSelecionar'     then  ShowMessage('Selecionar Objeto') else
  if sb.Name = 'sbInfo'           then  ShowMessage('Mostrar Registros') else
  if sb.Name = 'sbCriarPC'        then  ShowMessage(cMsgAjuda03) else
  if sb.Name = 'sbCriarSubBacia'  then  ShowMessage(cMsgAjuda02) else
  if sb.Name = 'sbCriarTrecho'    then  ShowMessage(cMsgAjuda01) else
  if sb.Name = 'sbInserirPCEntre' then  ShowMessage(cMsgAjuda05) else
  if sb.Name = 'sbPCReservatorio' then  ShowMessage(cMsgAjuda08) else
  if sb.Name = 'sbCriarDemanda'   then  ShowMessage(cMsgAjuda07) else
end;

procedure TfoMain.FormChange(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     AtualizarMenus(ProjetoAtivo.ObjetoSelecionado)
  else
     AtualizarMenus(nil)
end;

procedure TfoMain.FormCreate(Sender: TObject);
begin
  gSB   := StatusBar;
  gLeds := Leds;

  FGM := ThidroForm_GlobalMessages.Create(nil);
  GlobalMessages := FGM;

  GetMessageManager.RegisterMessage(UM_CLICK_GERENTE, self);
  GetMessageManager.RegisterMessage(UM_COMENTARIO_OBJETO_MUDOU, self);
  GetMessageManager.RegisterMessage(UM_DESCRICAO_OBJETO_MUDOU, self);
  GetMessageManager.RegisterMessage(UM_NOME_OBJETO_MUDOU, self);

  MC := TSharedMem.Create('MC_PROGRAMA_PROPAGAR', 1024);

  Screen.OnActiveFormChange := FormChange;

  btnEditarScript.Left   := PainelPrincipal.Width - btnEditarScript.Width - 3;
  btnPararScript.Left    := btnEditarScript.Left - btnPararScript.Width - 1;
  btnExecutarScript.Left := btnPararScript.Left - btnExecutarScript.Width;
  cbScripts.Width        := PainelPrincipal.Width - 3 * btnExecutarScript.Width - cbScripts.Left - 6;

  DragAcceptFiles(Handle, True);
end;

procedure TfoMain.FormDestroy(Sender: TObject);
begin
  Screen.OnActiveFormChange := nil;
  MC.Free;
  FGM.Free;
  GetMessageManager.UnregisterMessage(UM_CLICK_GERENTE, self);
  GetMessageManager.UnregisterMessage(UM_COMENTARIO_OBJETO_MUDOU, self);
  GetMessageManager.UnregisterMessage(UM_DESCRICAO_OBJETO_MUDOU, self);
  GetMessageManager.UnregisterMessage(UM_NOME_OBJETO_MUDOU, self);
end;

procedure TfoMain.Menu_Arquivo_SalvarComoClick(Sender: TObject);
var oldName : String;
begin
  if ProjetoAtivo = nil then Exit;
  oldName := ProjetoAtivo.Projeto.NomeArquivo;
  ProjetoAtivo.Projeto.NomeArquivo := '';
  ProjetoAtivo.Salvar;
  if ProjetoAtivo.Projeto.NomeArquivo = '' then
     ProjetoAtivo.Projeto.NomeArquivo := oldName;
end;

procedure TfoMain.SalvarArquivo_Click(Sender: TObject);
begin
  if ProjetoAtivo = nil then Exit;
  try
    StartWait;
    ProjetoAtivo.Salvar;
  finally
    StopWait;
  end;
end;

procedure TfoMain.AtualizarMenus(Obj: THidroComponente);
var b : Boolean;
begin
  b := (ProjetoAtivo <> nil);

  Menu_Janelas.Enabled := (MDIChildCount > 0);

  if b then
     if not ProjetoAtivo.Projeto.Scripts.Equals(cbScripts.Items) then
        begin
        cbScripts.Items.Assign(ProjetoAtivo.Projeto.Scripts);
        btnExecutarScript.Enabled := (cbScripts.Items.Count > 0);
        btnEditarScript.Enabled := btnExecutarScript.Enabled;
        if btnExecutarScript.Enabled then cbScripts.ItemIndex := 0;
        end else
  else
     begin
     Gerenciador.AreaDeProjeto := nil;
     cbScripts.Clear;
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

  Menu_Projeto_Monitorar.Enabled := b and (ProjetoAtivo.Projeto.TipoSimulacao = tsWIN);
  if b and ProjetoAtivo.Monitor.Visible and (ProjetoAtivo.Projeto.TipoSimulacao = tsDOS) then
     ProjetoAtivo.Monitor.Hide;

  // Botões
  btnMT.Enabled := b;
  btnSalvar.Enabled := b;
  btnDiagnostico.Enabled := b;
  btnZoom100.Enabled := b;
  btnOpcoesProjeto.Enabled := b;

  btnExecutar.Enabled := (b and (ProjetoAtivo.Projeto.Status = sFazendoNada));
  btnOtimizar.Enabled := btnExecutar.Enabled;

  sbRemoverObjeto.Enabled   := (Obj is TprPC) or
                               (Obj is TprSubBacia) or
                               (Obj is TprDemanda);

  sbRemoverTrecho.Enabled   := (Obj is TprPC) and
                               (TprPC(Obj).TrechoDagua <> nil) and
                               (TprPC(Obj).TrechoDagua.PC_aJusante <> nil);

  sbPC_TO_RES.Enabled       := (Obj is TprPC) and not
                               (Obj is TprPCPR);

  sbRES_TO_PC.Enabled       := (Obj is TprPCPR);

  b := (Obj is TprClasseDemanda) and not (Obj is TprDemanda);
  CD_Editar.Enabled := b;
  CD_Remover.Enabled := b;
  sbCriarDemanda.Enabled := b;

  if b and (Obj <> nil) then
     sbCriarDemanda.Hint := Format(cMsgInfo03, [Obj.Nome]);
end;

procedure TfoMain.Diagnostico_Click(Sender: TObject);
var b: Boolean;
begin
  if ProjetoAtivo = nil then Exit;
  b := ProjetoAtivo.Projeto.RealizarDiagnostico(True);
  SetGlobalStatus(b);

  if b then
     ShowMessage('Tudo está em perfeita ordem neste projeto.')
  else
     gErros.Show;
end;

procedure TfoMain.CD_CriarClick(Sender: TObject);
var DM: TprClasseDemanda;
begin
  if ProjetoAtivo <> nil then
     begin
     DM := TprClasseDemanda.Create(gmoPoint, ProjetoAtivo.Projeto, ProjetoAtivo.TabelaDeNomes);
     if DM.MostrarDialogo = mrOk then
        begin
        ProjetoAtivo.Projeto.ClassesDeDemanda.Adicionar(DM);
        Gerenciador.AdicionarObjeto(DM);
        end
     else
        DM.Free;
     end;
end;

procedure TfoMain.Editar_Click(Sender: TObject);
var DM  : TprDemanda;
begin
  DM := Gerenciador.CD_Selecionada;
  if (DM <> nil) then DM.MostrarDialogo;
end;

procedure TfoMain.CD_RemoverClick(Sender: TObject);
var DM: TprDemanda;
begin
  if ProjetoAtivo = nil then Exit;
  DM := Gerenciador.CD_Selecionada;
  if DM <> nil then
     ProjetoAtivo.Projeto.ClassesDeDemanda.Remover(DM);
end;

function TfoMain.GetProjetoAtivo: TprDialogo_AreaDeProjeto;
begin
  if ActiveMDIChild is TprDialogo_AreaDeProjeto then
     Result := TprDialogo_AreaDeProjeto(ActiveMDIChild)
  else
     Result := nil;
end;

procedure TfoMain.Menu_Projeto_SimularClick(Sender: TObject);
Const Completo = True;
Var DS: Char;
begin
  if ProjetoAtivo = nil then Exit;
  if ProjetoAtivo.Projeto.RealizarDiagnostico(Completo) then
     begin
     btnExecutar.Enabled := False;
     btnParar.Enabled := True;
     DS := DecimalSeparator;
     DecimalSeparator := '.';
     Try
       if ProjetoAtivo.Projeto.TipoSimulacao = tsDOS then
          ProjetoAtivo.Projeto.GerarArquivoPropagarDOS
       else
          btnParar.Enabled := True;

       ProjetoAtivo.Projeto.Executar;
     Finally
       btnExecutar.Enabled := True;
       btnParar.Enabled := False;
       DecimalSeparator := DS;
       End;
     end
  else
     gErros.Show
end;

procedure TfoMain.Cascata_Click(Sender: TObject);
begin
  Self.Cascade;
end;

procedure TfoMain.Horizontal_Click(Sender: TObject);
begin
  Self.TileMode := tbHorizontal;
  Self.Tile;
end;

procedure TfoMain.Vertical_Click(Sender: TObject);
begin
  Self.TileMode := tbVertical;
  Self.Tile;
end;

procedure TfoMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfoMain.Menu_Arquivo_FecharClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     ProjetoAtivo.Close;
end;

procedure TfoMain.sbRemoverTrechoClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     begin
     if ProjetoAtivo.ObjetoSelecionado is TprPC then
        TprPC(ProjetoAtivo.ObjetoSelecionado).RemoveTrecho;

     ProjetoAtivo.Invalidate;
     ProjetoAtivo.Projeto.Modificado := True;
     sbArrastar.Down := True;
     AtualizarMenus(ProjetoAtivo.ObjetoSelecionado);
     end;
end;

procedure TfoMain.MostrarEditor_Click(Sender: TObject);
begin
  gOutPut.Editor.Show;
end;

procedure TfoMain.MostrarGerenciador_Click(Sender: TObject);
begin
  Gerenciador.Show;
end;

procedure TfoMain.Menu_MatrizContribClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     ProjetoAtivo.Projeto.MostrarMatrizDeContribuicao;
end;

procedure TfoMain.GraficosSalvos_Click(Sender: TObject);
begin
  //gWinMan.ShowManager;
end;

procedure TfoMain.Menu_FalhasClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     ProjetoAtivo.Projeto.MostrarFalhasNoAtendimentoDasDemandas;
end;

procedure TfoMain.Menu_IntervalosClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     ProjetoAtivo.Projeto.MostrarIntervalos;
end;

procedure TfoMain.RelatorioGeral_Click(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     ProjetoAtivo.Projeto.RelatorioGeral;
end;

procedure TfoMain.Help_Click(Sender: TObject);
begin
  MessageDLG('Sistema de ajuda ainda não implementado.', mtInformation, [mbOK], 0);
end;

procedure TfoMain.Menu_CD_TabelaClick(Sender: TObject);
var D: TprDialogo_EscolherClasseDemanda;
    T: TprDialogo_Planilha_DemandasDeUmaClasse;
begin
  if ProjetoAtivo = nil then Exit;
  D := TprDialogo_EscolherClasseDemanda.Create(self);
  D.Classes := ProjetoAtivo.Projeto.ClassesDeDemanda;
  Try
    if D.ShowModal = mrOk then
       begin
       T := TprDialogo_Planilha_DemandasDeUmaClasse.Create(self);
       T.Classe  := D.Classe;
       T.AreaDeProjeto := ProjetoAtivo;
       T.Show;
       end;
  Finally
    D.Release;
    End;
end;


procedure TfoMain.FormShow(Sender: TObject);
var i: Integer;
    s1, s2: String;
begin
  Application.Title := 'Propagar 2000 - ' + gVersao;
  Caption := Application.Title;

  Menu_Arquivo_Abrir.Enabled := not gBloqueado;
  Menu_Arquivo_Novo.Enabled  := not gBloqueado;
  btnNovo.Enabled            := not gBloqueado;
  btnAbrir.Enabled           := not gBloqueado;
  sbCriarPC.Enabled          := not gBloqueado;
  sbCriarSubBacia.Enabled    := not gBloqueado;
  sbPCReservatorio.Enabled   := not gBloqueado;
  sbRemoverTrecho.Enabled    := not gBloqueado;
  sbCriarTrecho.Enabled      := not gBloqueado;
  sbSB_em_PC.Enabled         := not gBloqueado;
  sbInserirPCEntre.Enabled   := not gBloqueado;
  sbPC_To_Res.Enabled        := not gBloqueado;
  sbRes_To_PC.Enabled        := not gBloqueado;

  for i := 1 to ParamCount do
    if SubStrings('=', s1, s2, ParamStr(i)) > 0 then
       if CompareText(s1, 'ARQUIVO') = 0 then
          begin
          if FileExists(s2) then
             begin
             CreateMDIChild(s2, False, True, False);
             gDir := ExtractFilePath(s2);
             end;
          end else
       if CompareText(s1, 'MODO') = 0 then
          begin
          {$IFNDEF BAHIA}
          btnEspecial_1.Visible := (CompareText(s2, 'ADM') = 0);
          btnEspecial_2.Visible := btnEspecial_1.Visible;
          btnEspecial_3.Visible := btnEspecial_1.Visible;
          {$ENDIF}
          end else
       if (CompareText(s1, 'SENHA') = 0) and gBloqueado then
          begin
          gBloqueado := not (s2 = intToStr(1803));
          end;
end;

procedure TfoMain.Menu_Ver_MensagensErroClick(Sender: TObject);
begin
  gErros.Show;
end;

procedure TfoMain.btnMTClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     begin
     ProjetoAtivo.MostrarTrechos := not ProjetoAtivo.MostrarTrechos;
     Menu_Projeto_Visualizar_TD.Checked := ProjetoAtivo.MostrarTrechos;
     ProjetoAtivo.Map.Refresh;
     ProjetoAtivo.Projeto.Modificado := True;
     end;
end;

procedure TfoMain.EventosMessage(var Msg: tagMSG; var Handled: Boolean);
var s: String;
begin
  case Msg.message of
    AM_ABRIR_ARQUIVO,
    AM_ABRIR_APAGAR_ARQUIVO:
      begin
      s := MC.AsString;
      CreateMDIChild(s, False, False, False);
      if Msg.message = AM_ABRIR_APAGAR_ARQUIVO then DeleteFile(s);
      end;
  end;
end;

procedure TfoMain.Menu_Projeto_Visualizar_DemendasClick(Sender: TObject);
begin
  ProjetoAtivo.MostrarDemandas := not ProjetoAtivo.MostrarDemandas;
  Menu_Projeto_Visualizar_Demendas.Checked := ProjetoAtivo.MostrarDemandas;
  if ProjetoAtivo.MostrarDemandas then
     WriteStatus(StatusBar2, [' Demandas: Visíveis '], False)
  else
     WriteStatus(StatusBar2, [' Demandas: Não Visíveis '], False)
end;

procedure TfoMain.Menu_ProjetoClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     Menu_Projeto_Visualizar_Demendas.Checked := ProjetoAtivo.MostrarDemandas;
end;

procedure TfoMain.Menu_Mostrar_VariaveisGlobaisClick(Sender: TObject);
var d: TGlobalObjects_ShowDialog;
begin
  if ProjetoAtivo = nil then Exit;
  d := TGlobalObjects_ShowDialog.Create(nil);
  d.Mostrar(ProjetoAtivo.Projeto.GlobalObjects, ProjetoAtivo.Projeto.Nome);
end;

procedure TfoMain.btnPararClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     if ProjetoAtivo.Projeto.Status = sSimulando then
        ProjetoAtivo.Projeto.TerminarSimulacao
     else
        ProjetoAtivo.Projeto.TerminarOtimizacao;
end;

procedure TfoMain.Menu_ExecutarScriptClick(Sender: TObject);
var s : String;
    p: TprProjeto;
    v1, v2: TVariable;
begin
  if ProjetoAtivo <> nil then
     begin
     p := TprProjeto(ProjetoAtivo.Projeto);
     s := cbScripts.Items[cbScripts.ItemIndex];
     p.VerificarCaminho(s);
     end
  else
     begin
     p := nil;
     s := '';
     end;

  v1 := TVariable.Create('Saida', pvtObject, Integer(gOutPut), gOutPut.ClassType, True);

  if p <> nil then
     begin
     v2 := TVariable.Create('Projeto', pvtObject, Integer(p), p.ClassType, True);
     psEditor.RunScript(g_psLib, s, gDir, nil, [v1, v2], p.GlobalObjects, False);
     end
  else
     psEditor.RunScript(g_psLib, s, gDir, nil, [v1], nil, False);
end;

procedure TfoMain.Menu_Mostrar_PCClick(Sender: TObject);
var s: String;
begin
  if ProjetoAtivo = nil then Exit;
  s := 'Executando: ';
  if ProjetoAtivo.Projeto.ExecucaoCorrente <> '' then
     s := s + ProjetoAtivo.Projeto.ExecucaoCorrente
  else
     s := s + 'Indefinido';

  MessageDLG(s, mtInformation, [mbOK], 0);
end;

procedure TfoMain.Menu_Projeto_OtimizarClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     try
       btnExecutar.Enabled := false;
       btnOtimizar.Enabled := false;
       btnParar.Enabled := true;
       Menu_Projeto_Simular.Enabled := false;
       Menu_Projeto_Otimizar.Enabled := false;

       ProjetoAtivo.Projeto.Otimizar;
     finally
       Menu_Projeto_Simular.Enabled := true;
       Menu_Projeto_Otimizar.Enabled := true;
       btnParar.Enabled := false;
       btnExecutar.Enabled := true;
       btnOtimizar.Enabled := true;
     end;
end;

procedure TfoMain.btnExecutarScriptClick(Sender: TObject);
var p: TprProjeto;
    v1, v2: TVariable;
    x: TPascalScript;
    s: String;
begin
  if ProjetoAtivo = nil then Exit;
  p := TprProjeto(ProjetoAtivo.Projeto);

  v1 := TVariable.Create('Saida', pvtObject, Integer(gOutPut), gOutPut.ClassType, True);
  v2 := TVariable.Create('Projeto', pvtObject, Integer(p), p.ClassType, True);

  btnExecutarScript.Enabled := False;
  btnPararScript.Enabled := True;

  s := cbScripts.Items[cbScripts.ItemIndex];
  p.VerificarCaminho(s);

  x := TPascalScript.Create;
  try
    x.Text.LoadFromFile(s);
    x.Variables.AddVar(v1);
    x.Variables.AddVar(v2);
    x.GlobalObjects := p.GlobalObjects;
    x.AssignLib(g_psLib);
    if x.Compile then
       x.Execute
    else
       Dialogs.ShowMessage(x.Errors.Text);
  finally
    btnExecutarScript.Enabled := True;
    btnPararScript.Enabled := False;
    x.Free;
  end;
end;

procedure TfoMain.WMDROPFILES(var Message: TWMDROPFILES);
var NumFiles : longint;
    i : longint;
    buffer : array[0..255] of char;
begin
  NumFiles := DragQueryFile(Message.Drop, $FFFFFFFF, nil, 0);
  for i := 0 to (NumFiles - 1) do
    begin
    DragQueryFile(Message.Drop, i, @buffer, sizeof(buffer));
    gDir := ExtractFilePath(buffer);
    CreateMDIChild(buffer, False, False, False);
    end;
end;

procedure TfoMain.Menu_Ajuda_HistoricoClick(Sender: TObject);
begin
  with TForm_Historico.Create(nil) do
    begin
    ShowModal;
    Free;
    end;
end;

procedure TfoMain.Menu_Projeto_MonitorarClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     ProjetoAtivo.Monitor.Show;
end;

function TfoMain.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_CLICK_GERENTE then
     AtualizarMenus(MSG.ParamAsPointer(0))
  else

  if (MSG.ID = UM_COMENTARIO_OBJETO_MUDOU) or
     (MSG.ID = UM_DESCRICAO_OBJETO_MUDOU) then
     DescreverObjeto(THidroComponente(MSG.ParamAsObject(0)));
end;

procedure TfoMain.Menu_Projeto_PGClick(Sender: TObject);
begin
  ProjetoAtivo.Projeto.MostrarDialogo;
end;

procedure TfoMain.DescreverObjeto(HC: THidroComponente);
begin
  if HC.Descricao <> '' then
     FGM.Message := HC.Descricao + #13 + HC.Comentarios.Text
  else
     FGM.Message := HC.Comentarios.Text;
end;

procedure TfoMain.Menu_Projeto_AdicionarCamada_Click(Sender: TObject);
begin
  if not DirectoryExists(ProjetoAtivo.Projeto.DirTrab) then
     raise Exception.Create('Diretório de Trabalho Inválido');
     
  OpenLayer.InitialDir := ProjetoAtivo.Projeto.DirTrab;
  if OpenLayer.Execute then
     ProjetoAtivo.Projeto.AddLayer(OpenLayer.FileName);
end;

procedure TfoMain.Menu_Projeto_Zoom100_Click(Sender: TObject);
begin
  ProjetoAtivo.Map.Extent := ProjetoAtivo.Map.FullExtent;
end;

procedure TfoMain.Menu_Importar_redeClick(Sender: TObject);
begin
  OpenDialog.InitialDir := gDir;
  if OpenDialog.Execute then
     begin
     gDir := ExtractFilePath(OpenDialog.FileName);
     ProjetoAtivo.Projeto.LerDoArquivo(OpenDialog.FileName, True);
     ProjetoAtivo.Projeto.Map.RefreshLayer(0);
     AtualizarMenus(nil);
     end;
end;

procedure TfoMain.Menu_Ver_MensagensClick(Sender: TObject);
begin
  FGM.Show;
end;

procedure TfoMain.Menu_Demanda_DD_Click(Sender: TObject);
begin
  with TprDialogo_TVU_Distribuir.Create(nil) do
    begin
    Projeto := ProjetoAtivo.Projeto;
    ShowModal();
    Free();
    end;
end;

procedure TfoMain.RunScript(const Name: String);
var x: TPascalScript;
begin
  if not FileExists(Name) then Exit;

  x := TPascalScript.Create;
  try
    x.Text.LoadFromFile(Name);
    x.AssignLib(g_psLib);
    if x.Compile then
       x.Execute
    else
       Dialogs.ShowMessage(x.Errors.Text);
  finally
    x.Free;
  end;
end;

end.


