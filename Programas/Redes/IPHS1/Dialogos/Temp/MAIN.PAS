unit Main;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, FileCtrl, Mask, ExtDlgs, AppEvnts,
  SysUtilsEx,
  advClasses,
  Hidro_Classes,
  iphs1_Classes,
  iphs1_AreaDeProjeto;

type
  TReceptor_MainForm = class(TadvObject)
    Constructor Create;
    Destructor Destroy; override;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
  end;

  Tiphs1_Dialogo_Principal = class(TForm)
    MainMenu1: TMainMenu;
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
    sbArrastar: TSpeedButton;
    sbPCReservatorio: TSpeedButton;
    sbCriarPC: TSpeedButton;
    sbCriarSubBacia: TSpeedButton;
    sbCriarTrecho: TSpeedButton;
    sbSB_em_PC: TSpeedButton;
    sbInserirPCEntre: TSpeedButton;
    sbCriarDerivacao: TSpeedButton;
    sbRemoverObjeto: TSpeedButton;
    Panel1: TPanel;
    Panel2: TPanel;
    StatusBar: TStatusBar;
    Leds: TImage;
    Menu_Projeto: TMenuItem;
    Menu_RealizarDiagnostico: TMenuItem;
    Menu_Executar: TMenuItem;
    GerarArquivos: TSaveDialog;
    sbRemoverTrecho: TSpeedButton;
    Menu_Editar_Editor: TMenuItem;
    Menu_Gerenciador: TMenuItem;
    N3: TMenuItem;
    Menu_GJ: TMenuItem;
    sbPC_TO_RES: TSpeedButton;
    sbRES_TO_PC: TSpeedButton;
    Panel3: TPanel;
    Mensagem: TMemo;
    mmDesc: TMemo;
    mmNome: TMemo;
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
    btnGraficos: TSpeedButton;
    btnDiagnostico: TSpeedButton;
    btnExecutar: TSpeedButton;
    PS: TPanel;
    Menu_Ver_Mensagens: TMenuItem;
    btnBloqueado: TSpeedButton;
    btnMT: TSpeedButton;
    N6: TMenuItem;
    Menu_LerFundo: TMenuItem;
    OpenBitmap: TOpenPictureDialog;
    Menu_LimparImagem: TMenuItem;
    btnImagem: TSpeedButton;
    Eventos: TApplicationEvents;
    Menu_Mostrar_VariaveisGlobais: TMenuItem;
    btnParar: TSpeedButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Menu_ExecutarScript: TMenuItem;
    Menu_Mostrar_PC: TMenuItem;
    cbScripts: TComboBox;
    btnExecutarScript: TSpeedButton;
    btnPararScript: TSpeedButton;
    btnEditarScript: TSpeedButton;
    Menu_Projeto_VisDadosPostos: TMenuItem;
    Menu_Ajuda_Histrico: TMenuItem;
    N2: TMenuItem;
    Menu_Projeto_PHR: TMenuItem;
    Menu_Projeto_MHR: TMenuItem;
    Ajuda1: TMenuItem;
    Menu_Linguagens: TMenuItem;
    Menu_Portugues: TMenuItem;
    Menu_Ingles: TMenuItem;
    Menu_Espanhol: TMenuItem;
    procedure NovoArquivo_Click(Sender: TObject);
    procedure AbrirArquivo_Click(Sender: TObject);
    procedure HelpAbout_Click(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure sbRemoveObjeto_Click(Sender: TObject);
    procedure Ferramentas_Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Menu_Arquivo_SalvarComoClick(Sender: TObject);
    procedure Diagnostico_Click(Sender: TObject);
    procedure Menu_ExecutarClick(Sender: TObject);
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
    procedure GraficosSalvos_Click(Sender: TObject);
    procedure sbPC_TO_RESClick(Sender: TObject);
    procedure sbRES_TO_PCClick(Sender: TObject);
    procedure RelatorioGeral_Click(Sender: TObject);
    procedure Help_Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Menu_Ver_MensagensClick(Sender: TObject);
    procedure btnBloqueadoClick(Sender: TObject);
    procedure btnMTClick(Sender: TObject);
    procedure Menu_LerFundoClick(Sender: TObject);
    procedure Menu_LimparImagemClick(Sender: TObject);
    procedure btnImagemClick(Sender: TObject);
    procedure EventosMessage(var Msg: tagMSG; var Handled: Boolean);
    procedure Menu_Mostrar_VariaveisGlobaisClick(Sender: TObject);
    procedure btnPararClick(Sender: TObject);
    procedure Menu_ExecutarScriptClick(Sender: TObject);
    procedure Menu_Mostrar_PCClick(Sender: TObject);
    procedure Menu_OtimizarClick(Sender: TObject);
    procedure btnExecutarScriptClick(Sender: TObject);
    procedure Menu_Projeto_VisDadosPostosClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Menu_Ajuda_HistricoClick(Sender: TObject);
    procedure Menu_Projeto_PHRClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Menu_Linguagem_Click(Sender: TObject);
  private
    Receptor : TReceptor_MainForm;
    MC       : TSharedMem;

    function  GetProjetoAtivo: Tiphs1_Form_AreaDeProjeto;
    procedure AtualizaBtnBloqueado(Enabled: Boolean);
    procedure FormChange(Sender: TObject);
    procedure ConfigurarIdioma(const Sigla: String);

    procedure WMDROPFILES(var Message: TWMDROPFILES); message WM_DROPFILES;
  public
    function  CreateMDIChild(const Name: string; Novo, Max: Boolean): Tiphs1_Form_AreaDeProjeto;
    procedure AtualizaMenus(Obj: THidroComponente);
    property  ProjetoAtivo: Tiphs1_Form_AreaDeProjeto read GetProjetoAtivo;
  end;

var
  MainForm: Tiphs1_Dialogo_Principal;

implementation
uses IniFiles,
     LanguageControl,
     ShellAPI,
     WinUtils,
     drPlanilha,
     Hidro_Constantes,
     Hidro_Variaveis,
     hidro_Procs,
     iphs1_Procs,
     AboutForm,
     Edit,
     drGraficos,
     psEditor,
     psBASE,
     psCORE,
     Lib_GlobalObjects_ShowDialog,
     VisaoEmArvore_base, Historico,
     iphs1_EscolherObjetos,
     iphs1_Constantes;

{$R *.DFM}
{$R IMAGENS.RES}

function Tiphs1_Dialogo_Principal.CreateMDIChild
  (const Name: string; Novo, Max: Boolean): Tiphs1_Form_AreaDeProjeto;
begin
  Result := Tiphs1_Form_AreaDeProjeto.Create(Application);
  if Novo then
     Result.Projeto.Modificado := True
  else
     try
       StartWait;
       Result.Projeto.LerDoArquivo(Name);
       if Max then Result.WindowState := wsMaximized;
     finally
       StopWait;
     end;

  AtualizaMenus(nil);
end;

procedure Tiphs1_Dialogo_Principal.NovoArquivo_Click(Sender: TObject);
begin
  CreateMDIChild(LanguageManager.GetMessage(cMesID_IPH, 46){'PROJETO '} + IntToStr(MDIChildCount + 1), True, False);
end;

procedure Tiphs1_Dialogo_Principal.AbrirArquivo_Click(Sender: TObject);
var i: Integer;
begin
  OpenDialog.InitialDir := gDir;
  if OpenDialog.Execute then
     for i := 0 to OpenDialog.Files.Count-1 do
       begin
       gDir := ExtractFilePath(OpenDialog.Files[i]);
       CreateMDIChild(OpenDialog.Files[i], False, False);
       end;
end;

procedure Tiphs1_Dialogo_Principal.HelpAbout_Click(Sender: TObject);
var d: Tiphs1_Form_About;
begin
  d := Tiphs1_Form_About.Create(nil);
  d.ShowModal;
  d.Free;
end;

procedure Tiphs1_Dialogo_Principal.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

// Barra de ferramentas -----------------------------------------------------

procedure Tiphs1_Dialogo_Principal.sbRemoveObjeto_Click(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     if MessageDLG(LanguageManager.GetMessage(cMesID_IPH, 47){'Confirma a remoção ?'},
        mtConfirmation, [mbYES, mbNO], 0) = mrYES then
        begin
        ProjetoAtivo.RemoverObjeto(ProjetoAtivo.ObjetoSelecionado);
        sbArrastar.Down := True;
        end;
end;

procedure Tiphs1_Dialogo_Principal.sbPC_TO_RESClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     begin
     ProjetoAtivo.PC_TO_RES(Tiphs1_PC(ProjetoAtivo.ObjetoSelecionado));
     sbArrastar.Down := True;
     end;
end;

procedure Tiphs1_Dialogo_Principal.sbRES_TO_PCClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     begin
     ProjetoAtivo.RES_TO_PC(Tiphs1_PCR(ProjetoAtivo.ObjetoSelecionado));
     sbArrastar.Down := True;
     end;
end;

procedure Tiphs1_Dialogo_Principal.Ferramentas_Click(Sender: TObject);
var sb: TSpeedButton;
begin
  sb := TSpeedButton(Sender);
  if not sb.Down then Exit;
  if sb.Name = 'sbArrastar'       then  ShowMessage('') else
  if sb.Name = 'sbCriarPC'        then  ShowMessage(cMsgAjuda03) else
  if sb.Name = 'sbCriarSubBacia'  then  ShowMessage(cMsgAjuda02) else
  if sb.Name = 'sbCriarTrecho'    then  ShowMessage(cMsgAjuda01) else
  if sb.Name = 'sbInserirPCEntre' then  ShowMessage(cMsgAjuda05) else
  if sb.Name = 'sbPCReservatorio' then  ShowMessage(cMsgAjuda08) else
  if sb.Name = 'sbCriarDerivacao' then
     ShowMessage(LanguageManager.GetMessage(cMesID_IPH, 48){'Clique em um Ponto de Controle para criar uma Derivação'}) else
end;

procedure Tiphs1_Dialogo_Principal.FormChange(Sender: TObject);
begin
  if {(self.MDIChildCount > 0) and} not (csDestroying in self.ComponentState) then
     AtualizaMenus(nil);
end;

procedure Tiphs1_Dialogo_Principal.FormCreate(Sender: TObject);
var ini: TIniFile;
begin
  gMemo := Mensagem;
  gDesc := mmDesc;
  gNome := mmNome;
  gSB   := StatusBar;
  gLeds := Leds;

  Receptor := TReceptor_MainForm.Create;
  MC       := TSharedMem.Create('MC_PROGRAMA_IPHS1', 1024);

  Screen.OnActiveFormChange := FormChange;
  btnBloqueado.Glyph.LoadFromResourceName(HInstance, 'CADEADO_ABERTO');

  btnEditarScript.Left   := PainelPrincipal.Width - btnEditarScript.Width - 3;
  btnPararScript.Left    := btnEditarScript.Left - btnPararScript.Width - 1;
  btnExecutarScript.Left := btnPararScript.Left - btnExecutarScript.Width;
  cbScripts.Width        := PainelPrincipal.Width - 3 * btnExecutarScript.Width - 3;

  DragAcceptFiles(Handle, True);

  ini := TIniFile.Create(gExePath + 'IPHS1.ini');
  ConfigurarIdioma(ini.ReadString('GERAL', 'Idioma', 'br'));
  ini.Free;
end;

procedure Tiphs1_Dialogo_Principal.FormDestroy(Sender: TObject);
begin
  MC.Free;
  Receptor.Free;
end;

procedure Tiphs1_Dialogo_Principal.Menu_Arquivo_SalvarComoClick(Sender: TObject);
var oldName : String;
begin
  oldName := ProjetoAtivo.Projeto.NomeArquivo;
  ProjetoAtivo.Projeto.NomeArquivo := '';
  ProjetoAtivo.Salvar;
  if ProjetoAtivo.Projeto.NomeArquivo = '' then
     ProjetoAtivo.Projeto.NomeArquivo := oldName;
end;

procedure Tiphs1_Dialogo_Principal.SalvarArquivo_Click(Sender: TObject);
begin
  try
    StartWait;
    ProjetoAtivo.Salvar;
  finally
    StopWait;
  end;
end;

procedure Tiphs1_Dialogo_Principal.AtualizaMenus(Obj: THidroComponente);
var b : Boolean;
begin
  b := (ProjetoAtivo <> nil);

  Menu_Janelas.Enabled := (MDIChildCount > 0);
  Menu_Arquivo_Fechar.Enabled := Menu_Janelas.Enabled;

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
  //Menu_Editar.Enabled := b;
  Menu_Projeto.Enabled := b;
  Menu_Arquivo_SalvarComo.Enabled := b;
  Menu_Arquivo_Salvar.Enabled := b;
  Menu_Arquivo_Fechar.Enabled := b;
  Menu_Mostrar_VariaveisGlobais.Enabled := b;

  // Botões
  btnImagem.Enabled := b;
  btnMT.Enabled := b;
  btnSalvar.Enabled := b;
  btnDiagnostico.Enabled := b;
  btnExecutar.Enabled := b;
  btnBloqueado.Enabled := b;
  AtualizaBtnBloqueado(b);


  b := b and
      (ProjetoAtivo.Projeto.PCs.PCs > 0) and
      (ProjetoAtivo.Projeto.PCs.PC[0].HidroRes <> nil);

  Menu_Projeto_PHR.Enabled := b;
  Menu_Projeto_MHR.Enabled := b;

  sbRemoverObjeto.Enabled   := (Obj is TPC) or
                               (Obj is TSubBacia) or
                               (Obj is Tiphs1_Derivacao);

  sbRemoverTrecho.Enabled   := (Obj is TPC) and
                               (TPC(Obj).TrechoDagua <> nil) and
                               (TPC(Obj).TrechoDagua.PC_aJusante <> nil);

  sbPC_TO_RES.Enabled       := (Obj is TPC) and not
                               (Obj is Tiphs1_PCR);

  sbRES_TO_PC.Enabled       := (Obj is Tiphs1_PCR);
end;

procedure Tiphs1_Dialogo_Principal.Diagnostico_Click(Sender: TObject);
var b: Boolean;
begin
  b := ProjetoAtivo.Projeto.RealizarDiagnostico(True);
  SetGlobalStatus(b);

  if b then
     ShowMessage(LanguageManager.GetMessage(cMesID_IPH, 49){'Diagnóstico: OK'})
  else
     gErros.Show;
end;

function Tiphs1_Dialogo_Principal.GetProjetoAtivo: Tiphs1_Form_AreaDeProjeto;
begin
  if ActiveMDIChild is Tiphs1_Form_AreaDeProjeto then
     Result := Tiphs1_Form_AreaDeProjeto(MainForm.ActiveMDIChild)
  else
     Result := nil;
end;

procedure Tiphs1_Dialogo_Principal.Menu_ExecutarClick(Sender: TObject);
Const Completo = True;
Var DS: Char;
begin
  if ProjetoAtivo.Projeto.RealizarDiagnostico(Completo) then
     begin
     DS := DecimalSeparator;
     DecimalSeparator := '.';
     //OvcIntlSup.DecimalChar := DecimalSeparator;
     Try
       Tiphs1_Projeto(ProjetoAtivo.Projeto).Executar;
     Finally
       btnParar.Enabled := False;
       DecimalSeparator := DS;
       //OvcIntlSup.DecimalChar := DecimalSeparator;
       End;
     end
  else
     gErros.Show
end;

procedure Tiphs1_Dialogo_Principal.Cascata_Click(Sender: TObject);
begin
  Self.Cascade;
end;

procedure Tiphs1_Dialogo_Principal.Horizontal_Click(Sender: TObject);
begin
  Self.TileMode := tbHorizontal;
  Self.Tile;
end;

procedure Tiphs1_Dialogo_Principal.Vertical_Click(Sender: TObject);
begin
  Self.TileMode := tbVertical;
  Self.Tile;
end;

procedure Tiphs1_Dialogo_Principal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure Tiphs1_Dialogo_Principal.Menu_Arquivo_FecharClick(Sender: TObject);
begin
  ActiveMDIChild.Close;
end;

procedure Tiphs1_Dialogo_Principal.sbRemoverTrechoClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     if ProjetoAtivo.ObjetoSelecionado is TPC then
        if MessageDLG(LanguageManager.GetMessage(cMesID_IPH, 50){'Tem Certeza que deseja remover este Trecho ?'},
           mtConfirmation, [mbYes, mbNO], 0) = mrYes then
           begin
           TPC(ProjetoAtivo.ObjetoSelecionado).RemoverTrecho;
           ProjetoAtivo.AtualizarTela;
           ProjetoAtivo.Projeto.Modificado := True;
           sbArrastar.Down := True;
           AtualizaMenus(ProjetoAtivo.ObjetoSelecionado);
           end;
end;

procedure Tiphs1_Dialogo_Principal.MostrarEditor_Click(Sender: TObject);
begin
  gOutPut.Editor.Show;
end;

procedure Tiphs1_Dialogo_Principal.MostrarGerenciador_Click(Sender: TObject);
begin
  Gerenciador.Show;
end;

{ TReceptor_MainForm }

constructor TReceptor_MainForm.Create;
begin
  inherited Create;
  RegisterMessage(UM_CLICK_GERENTE);
  RegisterMessage(UM_COMENTARIO_OBJETO_MUDOU);
  RegisterMessage(UM_DESCRICAO_OBJETO_MUDOU);
  RegisterMessage(UM_NOME_OBJETO_MUDOU);
end;

destructor TReceptor_MainForm.Destroy;
begin
  UnRegisterMessage(UM_NOME_OBJETO_MUDOU);
  UnRegisterMessage(UM_DESCRICAO_OBJETO_MUDOU);
  UnRegisterMessage(UM_COMENTARIO_OBJETO_MUDOU);
  UnRegisterMessage(UM_CLICK_GERENTE);
  Inherited Destroy;
end;

function TReceptor_MainForm.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.Msg = UM_CLICK_GERENTE then
     MainForm.AtualizaMenus(THidroComponente(MSG.Params[0])) else

  if MSG.Msg = UM_COMENTARIO_OBJETO_MUDOU then
     gMemo.Lines.Assign(THidroComponente(MSG.Params[0]).Comentarios) else

  if MSG.Msg = UM_DESCRICAO_OBJETO_MUDOU then
     MainForm.mmDesc.Text := THidroComponente(MSG.Params[0]).Descricao else

  if MSG.Msg = UM_NOME_OBJETO_MUDOU then
     MainForm.mmNome.Text := THidroComponente(MSG.Params[0]).Nome;

  inherited ReceiveMessage(MSG);
end;

procedure Tiphs1_Dialogo_Principal.GraficosSalvos_Click(Sender: TObject);
begin
  gWinMan.ShowManager;
end;

procedure Tiphs1_Dialogo_Principal.RelatorioGeral_Click(Sender: TObject);
begin
  //ProjetoAtivo.Projeto.RelatorioGeral;
end;

procedure Tiphs1_Dialogo_Principal.Help_Click(Sender: TObject);
begin
  MostrarHTML('index.htm');
end;

procedure Tiphs1_Dialogo_Principal.FormShow(Sender: TObject);
var i: Integer;
    s1, s2: String;
begin
  Application.Title := 'IPHS1 - ' + gVersao;
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
    if getInfo('=', s1, s2, ParamStr(i)) > 0 then
       if CompareText(s1, 'ARQUIVO') = 0 then
          begin
          if FileExists(s2) then
             begin
             CreateMDIChild(s2, False, True);
             gDir := ExtractFilePath(s2);
             end;
          end else
       if (CompareText(s1, 'SENHA') = 0) and gBloqueado then
          begin
          gBloqueado := not (s2 = intToStr(1803));
          end;
end;

procedure Tiphs1_Dialogo_Principal.Menu_Ver_MensagensClick(Sender: TObject);
begin
  gErros.Show;
end;

procedure Tiphs1_Dialogo_Principal.btnBloqueadoClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     begin
     ProjetoAtivo.Bloqueado := not ProjetoAtivo.Bloqueado;
     AtualizaBtnBloqueado(True);
     end;
end;

procedure Tiphs1_Dialogo_Principal.btnMTClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     begin
     ProjetoAtivo.MostrarTrechos := not ProjetoAtivo.MostrarTrechos;
     ProjetoAtivo.AtualizarTela;
     ProjetoAtivo.Projeto.Modificado := True;
     end;
end;

procedure Tiphs1_Dialogo_Principal.Menu_LerFundoClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     if OpenBitmap.Execute then
        begin
        ProjetoAtivo.Projeto.ArqFundo := OpenBitmap.FileName;
        ProjetoAtivo.MostrarFundo := True;
        ProjetoAtivo.AtualizarTela;
        ProjetoAtivo.Projeto.Modificado := True;
        end;
end;

procedure Tiphs1_Dialogo_Principal.AtualizaBtnBloqueado(Enabled: Boolean);
begin
  if ProjetoAtivo <> nil then
     begin
     btnBloqueado.Enabled      := not ProjetoAtivo.Projeto.Bloqueado;
     Menu_LerFundo.Enabled     := btnBloqueado.Enabled;
     Menu_LimparImagem.Enabled := btnBloqueado.Enabled;

     if ProjetoAtivo.Bloqueado then
        btnBloqueado.Glyph.LoadFromResourceName(HInstance, 'CADEADO_FECHADO')
     else
        btnBloqueado.Glyph.LoadFromResourceName(HInstance, 'CADEADO_ABERTO');
     end;
end;

procedure Tiphs1_Dialogo_Principal.Menu_LimparImagemClick(Sender: TObject);
begin
  ProjetoAtivo.Projeto.ArqFundo := '';
  ProjetoAtivo.AtualizarTela;
end;

procedure Tiphs1_Dialogo_Principal.btnImagemClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     begin
     ProjetoAtivo.MostrarFundo := not ProjetoAtivo.MostrarFundo;
     ProjetoAtivo.AtualizarTela;
     end;
end;

procedure Tiphs1_Dialogo_Principal.EventosMessage(var Msg: tagMSG; var Handled: Boolean);
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

procedure Tiphs1_Dialogo_Principal.Menu_Mostrar_VariaveisGlobaisClick(Sender: TObject);
var d: TGlobalObjects_ShowDialog;
begin
  d := TGlobalObjects_ShowDialog.Create(nil);
  d.Mostrar(ProjetoAtivo.Projeto.ObjetosGlobais, ProjetoAtivo.Projeto.Nome);
end;

procedure Tiphs1_Dialogo_Principal.btnPararClick(Sender: TObject);
begin
  ProjetoAtivo.Projeto.TerminarSimulacao;
end;

procedure Tiphs1_Dialogo_Principal.Menu_ExecutarScriptClick(Sender: TObject);
var s : String;
    p: TProjeto;
    v1, v2: TVariable;
begin
  if ProjetoAtivo <> nil then
     begin
     p := TProjeto(ProjetoAtivo.Projeto);
     s := cbScripts.Items[cbScripts.ItemIndex];
     p.VerificaCaminho(s);
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
     RunScript(g_psLib, s, gDir, nil, [v1, v2], p.ObjetosGlobais, False);
     end
  else
     RunScript(g_psLib, s, gDir, nil, [v1], nil, False);
end;

procedure Tiphs1_Dialogo_Principal.Menu_Mostrar_PCClick(Sender: TObject);
var s: String;
begin
  s := LanguageManager.GetMessage(cMesID_IPH, 51){'Executando: '};
  if ProjetoAtivo.Projeto.ExecucaoCorrente <> '' then
     s := s + ProjetoAtivo.Projeto.ExecucaoCorrente
  else
     s := s + LanguageManager.GetMessage(cMesID_IPH, 52){'Indefinido'};

  MessageDLG(s, mtInformation, [mbOK], 0);
end;

procedure Tiphs1_Dialogo_Principal.Menu_OtimizarClick(Sender: TObject);
begin
  //ProjetoAtivo.Projeto.Otimizar;
end;

procedure Tiphs1_Dialogo_Principal.btnExecutarScriptClick(Sender: TObject);
var p: TProjeto;
    v1, v2: TVariable;
    x: TPascalScript;
    s: String;
begin
  p := TProjeto(ProjetoAtivo.Projeto);

  v1 := TVariable.Create('Saida', pvtObject, Integer(gOutPut), gOutPut.ClassType, True);
  v2 := TVariable.Create('Projeto', pvtObject, Integer(p), p.ClassType, True);

  btnExecutarScript.Enabled := False;
  btnPararScript.Enabled := True;

  s := cbScripts.Items[cbScripts.ItemIndex];
  p.VerificaCaminho(s);

  x := TPascalScript.Create;
  try
    x.Text.LoadFromFile(s);
    x.Variables.AddVar(v1);
    x.Variables.AddVar(v2);
    x.GlobalObjects := p.ObjetosGlobais;
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

procedure Tiphs1_Dialogo_Principal.WMDROPFILES(var Message: TWMDROPFILES);
var NumFiles : longint;
    i : longint;
    buffer : array[0..255] of char;
begin
  NumFiles := DragQueryFile(Message.Drop, $FFFFFFFF, nil, 0);
  for i := 0 to (NumFiles - 1) do
    begin
    DragQueryFile(Message.Drop, i, @buffer, sizeof(buffer));
    gDir := ExtractFilePath(buffer);
    CreateMDIChild(buffer, False, False);
    end;
end;

procedure Tiphs1_Dialogo_Principal.Menu_Projeto_VisDadosPostosClick(Sender: TObject);
var P: Tiphs1_Projeto;
    Planilha: TPlanilha;
begin
  p := Tiphs1_Projeto(ProjetoAtivo.Projeto.Projeto);
  if p.DadosPostos <> nil then
     try
       StartWait;
       Planilha := p.DadosPostos.ShowInSheet;
       Planilha.Window.FormStyle := fsMDIChild;
       Planilha.Caption := LanguageManager.GetMessage(cMesID_IPH, 53){'Dados dos Postos'};
     finally
       StopWait;
     end;
end;

procedure Tiphs1_Dialogo_Principal.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If key = VK_F1 then
     MostrarHTML('JanelaPrincipal.htm');
end;

procedure Tiphs1_Dialogo_Principal.Menu_Ajuda_HistricoClick(Sender: TObject);
begin
  with TForm_Historico.Create(nil) do
    begin
    ShowModal;
    Free;
    end;
end;

procedure Tiphs1_Dialogo_Principal.Menu_Projeto_PHRClick(Sender: TObject);
var i: Integer;
begin
  if ProjetoAtivo <> nil then
     with Tiphs1_Dialogo_EscolherObjetos.Create(ProjetoAtivo.Projeto) do
       try
       if ShowModal = mrOK then
          if TComponent(Sender).Tag = 0 then
             ProjetoAtivo.Projeto.PlotarHidrogramasResultantes(FO.ItemsSel)
          else
             ProjetoAtivo.Projeto.MostrarHidrogramasResultantes(FO.ItemsSel);
       finally
          Free;
       end;
end;

procedure Tiphs1_Dialogo_Principal.FormActivate(Sender: TObject);
begin
  AtualizaMenus(nil);
end;

procedure Tiphs1_Dialogo_Principal.ConfigurarIdioma(const Sigla: String);
begin
  LanguageManager.LanguagesPath := gExePath + 'Linguagens';
  LanguageManager.Load(Sigla);

  cMesID_IPH     := LanguageManager.IDs.IndexOf('iphs1');
  cMesID_SYSTEM  := LanguageManager.IDs.IndexOf('System');
  cMesID_HIDRO   := LanguageManager.IDs.IndexOf('hidro');
  cMesID_DIALOGS := LanguageManager.IDs.IndexOf('dialogs');

  Menu_Portugues.Checked := (Sigla = 'br');
  Menu_Ingles.Checked    := (Sigla = 'ing');
  Menu_Espanhol.Checked  := (Sigla = 'esp');
end;

procedure Tiphs1_Dialogo_Principal.Menu_Linguagem_Click(Sender: TObject);
var s: String;
    ini: TIniFile;
begin
  Case TComponent(Sender).Tag of
    1: s := 'br';
    2: s := 'ing';
    3: s := 'esp';
    end;
  ConfigurarIdioma(s);
  ini := TIniFile.Create(gExePath + 'IPHS1.ini');
  ini.WriteString('GERAL', 'Idioma', s);
  ini.Free;
end;

end.


