unit Main;

interface
uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
     StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
     ActnList, ToolWin, ImgList, FileCtrl, Mask, ExtDlgs, AppEvnts,
     DiretivasDeCompilacao,
     SysUtilsEx,
     MessageManager,
     Optimizer_Base,
     pr_Classes,
     pr_Form_AreaDeProjeto_Base,
     pr_Application;

type
  TprDialogo_Principal = class(TForm, IMessageReceptor)
    MainMenu: TMainMenu;
    Menu_Arquivo: TMenuItem;
    Menu_Arquivo_Fechar: TMenuItem;
    Menu_Janelas: TMenuItem;
    Menu_Ajuda: TMenuItem;
    N1: TMenuItem;
    Menu_Arquivo_Sair: TMenuItem;
    Menu_Janelas_Cascata: TMenuItem;
    Menu_Janelas_Horizontal: TMenuItem;
    Menu_Ajuda_Sobre: TMenuItem;
    OpenDialog: TOpenDialog;
    Menu_Janelas_Vertical: TMenuItem;
    LI: TImageList;
    Menu_Editar_Visualizar: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    StatusBar: TStatusBar;
    Leds: TImage;
    Menu_Projeto: TMenuItem;
    Menu_Projeto_Simular: TMenuItem;
    GerarArquivos: TSaveDialog;
    Menu_Editar_Editor: TMenuItem;
    Menu_Gerenciador: TMenuItem;
    N3: TMenuItem;
    Menu_MatrizContrib: TMenuItem;
    Menu_Falhas: TMenuItem;
    Menu_Intervalos: TMenuItem;
    PainelPrincipal: TPanel;
    btnGerente: TSpeedButton;
    btnEditor: TSpeedButton;
    btnCascata: TSpeedButton;
    btnHor: TSpeedButton;
    btnVert: TSpeedButton;
    btnHelp: TSpeedButton;
    btnExecutar: TSpeedButton;
    PS: TPanel;
    Menu_Ver_Mensagens: TMenuItem;
    btnMT: TSpeedButton;
    OpenBitmap: TOpenPictureDialog;
    btnImagem: TSpeedButton;
    Eventos: TApplicationEvents;
    Menu_Projeto_Visualizar_Demendas: TMenuItem;
    Menu_Mostrar_VariaveisGlobais: TMenuItem;
    btnParar: TSpeedButton;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Menu_ExecutarScript: TMenuItem;
    Menu_Mostrar_PC: TMenuItem;
    Menu_Projeto_Otimizar_Rosen: TMenuItem;
    cbScripts: TComboBox;
    btnExecutarScript: TSpeedButton;
    btnPararScript: TSpeedButton;
    btnEditarScript: TSpeedButton;
    StatusBar2: TStatusBar;
    Label1: TLabel;
    Menu_Projeto_Monitorar: TMenuItem;
    Menu_Projeto_Visualizar_TD: TMenuItem;
    Menu_Projeto_Visualizar_Imagem: TMenuItem;
    Menu_Projeto_Visualizar: TMenuItem;
    N7: TMenuItem;
    btnOtimizar: TSpeedButton;
    N8: TMenuItem;
    Menu_Projeto_PG: TMenuItem;     
    Bevel6: TBevel;
    btnOpcoesProjeto: TSpeedButton;
    MenuFecharTodos: TMenuItem;
    N10: TMenuItem;
    Menu_Projeto_Otimizar: TMenuItem;
    Menu_Projeto_Otimizar_Genetic: TMenuItem;
    Menu_Projeto_Otimizar_GeneticMO: TMenuItem;
    Menu_Mensagens: TMenuItem;
    N9: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    procedure NovoArquivo_Click(Sender: TObject);
    procedure AbrirArquivo_Click(Sender: TObject);
    procedure HelpAbout_Click(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure Ferramentas_Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Menu_Arquivo_SalvarComoClick(Sender: TObject);
    procedure Menu_Projeto_SimularClick(Sender: TObject);
    procedure Cascata_Click(Sender: TObject);
    procedure Horizontal_Click(Sender: TObject);
    procedure Vertical_Click(Sender: TObject);
    procedure SalvarArquivo_Click(Sender: TObject);
    procedure Menu_Arquivo_FecharClick(Sender: TObject);
    procedure MostrarEditor_Click(Sender: TObject);
    procedure MostrarGerenciador_Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Menu_MatrizContribClick(Sender: TObject);
    procedure Menu_FalhasClick(Sender: TObject);
    procedure Menu_IntervalosClick(Sender: TObject);
    procedure Help_Click(Sender: TObject);
    procedure Menu_CD_TabelaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Menu_Ver_MensagensClick(Sender: TObject);
    procedure btnMTClick(Sender: TObject);
    procedure Menu_LerFundoClick(Sender: TObject);
    procedure Menu_LimparImagemClick(Sender: TObject);
    procedure btnImagemClick(Sender: TObject);
    procedure MessageEvent(var Msg: tagMSG; var Handled: Boolean);
    procedure Menu_Projeto_Visualizar_DemendasClick(Sender: TObject);
    procedure Menu_ProjetoClick(Sender: TObject);
    procedure Menu_Mostrar_VariaveisGlobaisClick(Sender: TObject);
    procedure btnPararClick(Sender: TObject);
    procedure Menu_ExecutarScriptClick(Sender: TObject);
    procedure Menu_Mostrar_PCClick(Sender: TObject);
    procedure btnExecutarScriptClick(Sender: TObject);
    procedure Menu_Ajuda_HistoricoClick(Sender: TObject);
    procedure Menu_Projeto_MonitorarClick(Sender: TObject);
    procedure Menu_Projeto_PGClick(Sender: TObject);
    procedure Menu_Demanda_DDClick(Sender: TObject);
    procedure Menu_Projeto_GerarEquacoesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuFecharTodosClick(Sender: TObject);
    procedure btnOtimizarClick(Sender: TObject);
    procedure Menu_Projeto_Otimizar_RosenClick(Sender: TObject);
    procedure Menu_Projeto_Otimizar_GeneticClick(Sender: TObject);
    procedure Menu_Projeto_Otimizar_GeneticMOClick(Sender: TObject);
    procedure Menu_MensagensClick(Sender: TObject);
  private
    MC: TSharedMem;

    procedure DescreverObjeto(HC: THidroComponente);
    function  ObtemAreaDeProjetoAtiva: TfoAreaDeProjeto_Base;
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
    // function  CreateMDIChild(const Name: string; Novo, Max: Boolean): TprDialogo_AreaDeProjeto;
    function  CreateMDIChild(const Name: string; Novo, Max: Boolean): TfoAreaDeProjeto_Base;
    procedure AtualizarMenus(Obj: THidroComponente);
    property  AreaDeProjeto: TfoAreaDeProjeto_Base read ObtemAreaDeProjetoAtiva;
  end;

var
  MainForm: TprDialogo_Principal;

implementation
uses pr_Const, pr_Tipos, pr_Vars, ShellAPI, OutPut,
     Plugin,
     WinUtils,
     pr_Funcoes,
     AboutForm,
     pr_Gerenciador,
     //Edit,
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
     pr_Form_AreaDeProjeto_BMP;

{$R *.DFM}
{$R IMAGENS.RES}

function TprDialogo_Principal.CreateMDIChild(const Name: string; Novo, Max: Boolean): TfoAreaDeProjeto_Base;
begin
  Result := TfoAreaDeProjeto_BMP.Create();

  // Conecta os Eventos
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
       if Max then Result.WindowState := wsMaximized;
     finally
       Result.Enabled := true;
       StopWait;
     end;

  AtualizarMenus(nil);
end;

procedure TprDialogo_Principal.NovoArquivo_Click(Sender: TObject);
begin
  CreateMDIChild('PROJETO ' + IntToStr(MDIChildCount + 1), True, False);
end;

procedure TprDialogo_Principal.AbrirArquivo_Click(Sender: TObject);
var i: Integer;
begin
  OpenDialog.InitialDir := Applic.LastDir;
  if OpenDialog.Execute then
     for i := 0 to OpenDialog.Files.Count-1 do
       begin
       Applic.LastDir := ExtractFilePath(OpenDialog.Files[i]);
       CreateMDIChild(OpenDialog.Files[i], False, False);
       end;
end;

procedure TprDialogo_Principal.HelpAbout_Click(Sender: TObject);
var d: TprDialogo_About;
begin
  d := TprDialogo_About.Create(nil);
  d.ShowModal;
  d.Free;
end;

procedure TprDialogo_Principal.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

// Barra de ferramentas -----------------------------------------------------

procedure TprDialogo_Principal.Ferramentas_Click(Sender: TObject);
var sb: TSpeedButton;
begin
  sb := TSpeedButton(Sender);
  if sb.Down then
     if sb.Name = 'sbArrastar' then
        Applic.ShowMessage('')
     else
        begin
        if sb.Name = 'sbCriarPC'        then Applic.ShowMessage(cMsgAjuda03) else
        if sb.Name = 'sbCriarSubBacia'  then Applic.ShowMessage(cMsgAjuda02) else
        if sb.Name = 'sbCriarTrecho'    then Applic.ShowMessage(cMsgAjuda01) else
        if sb.Name = 'sbInserirPCEntre' then Applic.ShowMessage(cMsgAjuda05) else
        if sb.Name = 'sbPCReservatorio' then Applic.ShowMessage(cMsgAjuda08) else
        if sb.Name = 'sbCriarDemanda'   then Applic.ShowMessage(cMsgAjuda07) ;

        Applic.ShowMessageForm();
        end;
end;

procedure TprDialogo_Principal.FormChange(Sender: TObject);
begin
  if (self.MDIChildCount > 0) and not (csDestroying in self.ComponentState) then
     if AreaDeProjeto <> nil then
        AtualizarMenus(AreaDeProjeto.ObjetoSelecionado)
     else
        AtualizarMenus(nil);
end;

procedure TprDialogo_Principal.FormCreate(Sender: TObject);
begin
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

procedure TprDialogo_Principal.FormDestroy(Sender: TObject);
begin
  MC.Free();
  GetMessageManager.UnregisterMessage(UM_CLICK_GERENTE, self);
  GetMessageManager.UnregisterMessage(UM_COMENTARIO_OBJETO_MUDOU, self);
  GetMessageManager.UnregisterMessage(UM_DESCRICAO_OBJETO_MUDOU, self);
  GetMessageManager.UnregisterMessage(UM_NOME_OBJETO_MUDOU, self);
end;

procedure TprDialogo_Principal.Menu_Arquivo_SalvarComoClick(Sender: TObject);
var oldName : String;
begin
  if AreaDeProjeto = nil then Exit;
  oldName := AreaDeProjeto.Projeto.NomeArquivo;
  AreaDeProjeto.Projeto.NomeArquivo := '';
  AreaDeProjeto.Salvar();
  if AreaDeProjeto.Projeto.NomeArquivo = '' then
     AreaDeProjeto.Projeto.NomeArquivo := oldName;
end;

procedure TprDialogo_Principal.SalvarArquivo_Click(Sender: TObject);
begin
  if AreaDeProjeto = nil then Exit;
  try
    StartWait();
    AreaDeProjeto.Salvar();
  finally
    StopWait;
  end;
end;

procedure TprDialogo_Principal.AtualizarMenus(Obj: THidroComponente);
var b : Boolean;
begin
  b := (AreaDeProjeto <> nil);

  Menu_Janelas.Enabled := (MDIChildCount > 0);

  if b then
     if not AreaDeProjeto.Projeto.Scripts.Equals(cbScripts.Items) then
        begin
        cbScripts.Items.Assign(AreaDeProjeto.Projeto.Scripts);
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
  Menu_Arquivo_Fechar.Enabled := b;
  Menu_Mostrar_VariaveisGlobais.Enabled := b;

  Menu_Projeto_Monitorar.Enabled := b and (AreaDeProjeto.Projeto.TipoSimulacao = tsWIN);
  if b and AreaDeProjeto.Monitor.Visible and (AreaDeProjeto.Projeto.TipoSimulacao = tsDOS) then
     AreaDeProjeto.Monitor.Hide();

  // Botões
  btnImagem.Enabled := b;
  btnMT.Enabled := b;
  btnOpcoesProjeto.Enabled := b;

  btnExecutar.Enabled := (b and (AreaDeProjeto.Projeto.Status = sFazendoNada));
  btnOtimizar.Enabled := btnExecutar.Enabled;
end;

function TprDialogo_Principal.ObtemAreaDeProjetoAtiva(): TfoAreaDeProjeto_Base;
begin
  if ActiveMDIChild is TfoAreaDeProjeto_Base then
     Result := TfoAreaDeProjeto_Base(ActiveMDIChild)
  else
     Result := nil;
end;

procedure TprDialogo_Principal.Menu_Projeto_SimularClick(Sender: TObject);
Const Completo = True;
Var DS: Char;
begin
  if AreaDeProjeto = nil then Exit;
  if AreaDeProjeto.Projeto.RealizarDiagnostico(Completo) then
     begin
     btnExecutar.Enabled := False;
     btnParar.Enabled := True;
     DS := DecimalSeparator;
     DecimalSeparator := '.';
     Try
       if AreaDeProjeto.Projeto.TipoSimulacao = tsWIN then
          btnParar.Enabled := True;

       AreaDeProjeto.Projeto.Executar();
     Finally
       btnExecutar.Enabled := True;
       btnParar.Enabled := False;
       DecimalSeparator := DS;
       End;
     end
  else
     gErros.Show()
end;

procedure TprDialogo_Principal.Cascata_Click(Sender: TObject);
begin
  Self.Cascade;
end;

procedure TprDialogo_Principal.Horizontal_Click(Sender: TObject);
begin
  Self.TileMode := tbHorizontal;
  Self.Tile;
end;

procedure TprDialogo_Principal.Vertical_Click(Sender: TObject);
begin
  Self.TileMode := tbVertical;
  Self.Tile;
end;

procedure TprDialogo_Principal.Menu_Arquivo_FecharClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     AreaDeProjeto.Close();
end;

procedure TprDialogo_Principal.MostrarEditor_Click(Sender: TObject);
begin
  //gOutPut.Editor.Show;
end;

procedure TprDialogo_Principal.MostrarGerenciador_Click(Sender: TObject);
begin
  Gerenciador.Show();
end;

procedure TprDialogo_Principal.Menu_MatrizContribClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     AreaDeProjeto.Projeto.MostraMatrizDeContribuicao;
end;

procedure TprDialogo_Principal.Menu_FalhasClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     AreaDeProjeto.Projeto.MostraFalhasNoAtendimentoDasDemandas;
end;

procedure TprDialogo_Principal.Menu_IntervalosClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     AreaDeProjeto.Projeto.MostrarIntervalos;
end;

procedure TprDialogo_Principal.Help_Click(Sender: TObject);
begin
  HelpAbout_Click(Sender);
end;

procedure TprDialogo_Principal.Menu_CD_TabelaClick(Sender: TObject);
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


procedure TprDialogo_Principal.FormShow(Sender: TObject);
var i: Integer;
    s1, s2: String;
begin
  Applic.StatusBar := StatusBar;
  Applic.StatusLed := Leds;

  for i := 1 to ParamCount do
    if SubStrings('=', s1, s2, ParamStr(i)) > 0 then
       if CompareText(s1, 'ARQUIVO') = 0 then
          begin
          if FileExists(s2) then
             begin
             CreateMDIChild(s2, False, True);
             Applic.LastDir := ExtractFilePath(s2);
             end;
          end;
end;

procedure TprDialogo_Principal.Menu_Ver_MensagensClick(Sender: TObject);
begin
  gErros.Show;
end;

procedure TprDialogo_Principal.btnMTClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     begin
     AreaDeProjeto.MostrarTrechos := not AreaDeProjeto.MostrarTrechos;
     Menu_Projeto_Visualizar_TD.Checked := AreaDeProjeto.MostrarTrechos;
     AreaDeProjeto.Atualizar();
     AreaDeProjeto.Projeto.Modificado := True;
     end;
end;

procedure TprDialogo_Principal.Menu_LerFundoClick(Sender: TObject);
begin
  {$ifndef NAO_CARREGAR_IMAGEM_DE_FUNDO}
    {$if dir_NivelDeRestricao < 2}
    if AreaDeProjeto <> nil then
       if OpenBitmap.Execute then
          begin
          AreaDeProjeto.Projeto.ArqFundo := OpenBitmap.FileName;
          AreaDeProjeto.MostrarFundo := True;
          AreaDeProjeto.Atualizar();
          AreaDeProjeto.Projeto.Modificado := True;
          end;
    {$else}
    MessageDLG(mes_NivelDeRestricao, mtInformation, [mbOk], 0);
    {$ifend}
  {$else}
  MessageDLG('Função desabilitada', mtInformation, [mbOk], 0);
  {$endif}
end;

procedure TprDialogo_Principal.Menu_LimparImagemClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     AreaDeProjeto.Projeto.ArqFundo := '';
end;

procedure TprDialogo_Principal.btnImagemClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     begin
     AreaDeProjeto.MostrarFundo := not AreaDeProjeto.MostrarFundo;
     Menu_Projeto_Visualizar_Imagem.Checked := AreaDeProjeto.MostrarFundo;
     AreaDeProjeto.Atualizar();
     end;
end;

procedure TprDialogo_Principal.MessageEvent(var Msg: tagMSG; var Handled: Boolean);
var s: String;
begin
  case Msg.message of
    AM_ABRIR_ARQUIVO,
    AM_ABRIR_APAGAR_ARQUIVO:
      begin
      s := MC.AsString;
      CreateMDIChild(s, False, False);
      if Msg.message = AM_ABRIR_APAGAR_ARQUIVO then DeleteFile(s);
      end;
  end;
end;

procedure TprDialogo_Principal.Menu_Projeto_Visualizar_DemendasClick(Sender: TObject);
begin
  AreaDeProjeto.MostrarDemandas := not AreaDeProjeto.MostrarDemandas;
  Menu_Projeto_Visualizar_Demendas.Checked := AreaDeProjeto.MostrarDemandas;
  if AreaDeProjeto.MostrarDemandas then
     WriteStatus(StatusBar2, [' Demandas: Visíveis '], false)
  else
     WriteStatus(StatusBar2, [' Demandas: Não Visíveis '], false);
end;

procedure TprDialogo_Principal.Menu_ProjetoClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     begin
     Menu_Projeto_Visualizar_Demendas.Checked := AreaDeProjeto.MostrarDemandas;
     //Menu_Projeto_GerarEquacoes.Enabled := AreaDeProjeto.Projeto.ExecutouSimulacao;
     end;
end;

procedure TprDialogo_Principal.Menu_Mostrar_VariaveisGlobaisClick(Sender: TObject);
var d: TGlobalObjects_ShowDialog;
begin
  if AreaDeProjeto = nil then Exit;
  d := TGlobalObjects_ShowDialog.Create(nil);
  d.Mostrar(AreaDeProjeto.Projeto.GlobalObjects, AreaDeProjeto.Projeto.Nome);
end;

procedure TprDialogo_Principal.btnPararClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     if AreaDeProjeto.Projeto.Status = sSimulando then
        AreaDeProjeto.Projeto.TerminarSimulacao
     else
        AreaDeProjeto.Projeto.TerminarOtimizacao();
end;

procedure TprDialogo_Principal.Menu_ExecutarScriptClick(Sender: TObject);
var s: String;
    p: TprProjeto;
    v: TVariable;
begin
  if AreaDeProjeto <> nil then
     begin
     p := TprProjeto(AreaDeProjeto.Projeto);
     s := cbScripts.Items[cbScripts.ItemIndex];
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

procedure TprDialogo_Principal.Menu_Mostrar_PCClick(Sender: TObject);
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

procedure TprDialogo_Principal.btnExecutarScriptClick(Sender: TObject);
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

  s := cbScripts.Items[cbScripts.ItemIndex];
  p.VerificaCaminho(s);

  x := TPascalScript.Create;
  try
    x.Text.LoadFromFile(s);
    x.Variables.AddVar(v);
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

procedure TprDialogo_Principal.WMDROPFILES(var Message: TWMDROPFILES);
var NumFiles : longint;
    i : longint;
    buffer : array[0..255] of char;
begin
  NumFiles := DragQueryFile(Message.Drop, $FFFFFFFF, nil, 0);
  for i := 0 to (NumFiles - 1) do
    begin
    DragQueryFile(Message.Drop, i, @buffer, sizeof(buffer));
    Applic.LastDir := ExtractFilePath(buffer);
    CreateMDIChild(buffer, False, False);
    end;
end;

procedure TprDialogo_Principal.Menu_Ajuda_HistoricoClick(Sender: TObject);
begin
  with TForm_Historico.Create(nil) do
    begin
    ShowModal;
    Free;
    end;
end;

procedure TprDialogo_Principal.Menu_Projeto_MonitorarClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     AreaDeProjeto.Monitor.Show;
end;

function TprDialogo_Principal.ReceiveMessage(const MSG: TadvMessage): Boolean;
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

procedure TprDialogo_Principal.Menu_Projeto_PGClick(Sender: TObject);
begin
  AreaDeProjeto.Projeto.Editar();
end;

procedure TprDialogo_Principal.Menu_Demanda_DDClick(Sender: TObject);
begin
  with TprDialogo_TVU_Distribuir.Create(nil) do
    begin
    Projeto := AreaDeProjeto.Projeto;
    ShowModal();
    Free();
    end;
end;

procedure TprDialogo_Principal.Menu_Projeto_GerarEquacoesClick(Sender: TObject);
begin
  with TprForm_Equacoes.Create(AreaDeProjeto.Projeto) do
    begin
    ShowModal();
    Free();
    end;
end;

procedure TprDialogo_Principal.FecharProjetos();
var i: Integer;
begin
  for i := Screen.FormCount-1 downto 0 do
    if Screen.Forms[i] is TfoAreaDeProjeto_Base then
       TfoAreaDeProjeto_Base(Screen.Forms[i]).Close();
end;

procedure TprDialogo_Principal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FecharProjetos();
end;

procedure TprDialogo_Principal.MenuFecharTodosClick(Sender: TObject);
begin
  FecharProjetos();
end;

procedure TprDialogo_Principal.FinalizarOtimizacao();
begin
  Menu_Projeto_Simular.Enabled := true;
  Menu_Projeto_Otimizar.Enabled := true;
  btnParar.Enabled := false;
  btnExecutar.Enabled := true;
  btnOtimizar.Enabled := true;
end;

procedure TprDialogo_Principal.IniciarOtimizacao();
begin
  btnExecutar.Enabled := false;
  btnOtimizar.Enabled := false;
  btnParar.Enabled := true;
  Menu_Projeto_Simular.Enabled := false;
  Menu_Projeto_Otimizar.Enabled := false;
end;

procedure TprDialogo_Principal.Otimizar(Otimizador: TOptimizer);
begin
  if AreaDeProjeto <> nil then
     try
       IniciarOtimizacao();
       Otimizador.Optimize(AreaDeProjeto.Projeto);
     finally
       FinalizarOtimizacao();
       Otimizador.Free;
     end;
end;

procedure TprDialogo_Principal.btnOtimizarClick(Sender: TObject);
begin
  if Menu_Projeto_Otimizar_Rosen.Checked then
     Otimizar( TRosenbrock.Create() )
  else
  if Menu_Projeto_Otimizar_Genetic.Checked then
     Otimizar( TGeneticOptimizer.Create() )
  else
     Otimizar( TGeneticMO_Optimizer.Create() );
end;

procedure TprDialogo_Principal.Menu_Projeto_Otimizar_RosenClick(Sender: TObject);
begin
  Menu_Projeto_Otimizar_Rosen.Checked := true;
end;

procedure TprDialogo_Principal.Menu_Projeto_Otimizar_GeneticClick(Sender: TObject);
begin
  Menu_Projeto_Otimizar_Genetic.Checked := true;
end;

procedure TprDialogo_Principal.Menu_Projeto_Otimizar_GeneticMOClick(Sender: TObject);
begin
  Menu_Projeto_Otimizar_GeneticMO.Checked := true;
end;

procedure TprDialogo_Principal.TrataAvisoDaAreaDeProjeto(const Aviso: String);
begin
  Applic.ShowMessage(Aviso);
end;

procedure TprDialogo_Principal.TrataMensagemDaAreaDeProjeto(const ID: String; Objeto: TObject);
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
end;

function TprDialogo_Principal.TrataStatusDoBotaoDaAreaDeProjeto(const ID_Botao: String): boolean;
begin
  // Engana os projetos fazendo-os pensar que estao sempre em status de "arrastar"
  result := CompareText(ID_Botao, 'Arrastar') = 0;
end;

procedure TprDialogo_Principal.DescreverObjeto(HC: THidroComponente);
begin
  if HC.Descricao <> '' then
     Applic.ShowMessage(HC.Descricao + #13 + HC.Comentarios.Text)
  else
     Applic.ShowMessage(HC.Comentarios.Text)
end;

procedure TprDialogo_Principal.Menu_MensagensClick(Sender: TObject);
begin
  Applic.ShowMessageForm();
end;

end.


