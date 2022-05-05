unit Main;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, FileCtrl, Mask, ExtDlgs, AppEvnts,
  SysUtilsEx,
  MessageManager,
  Hidro_Classes,
  iphs1_Classes,
  iphs1_AreaDeProjeto;

type
  Tiphs1_Dialogo_Principal = class(TForm, IMessageReceptor)
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
    Menu_Gerenciador: TMenuItem;
    N3: TMenuItem;
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
    btnCascata: TSpeedButton;
    btnHor: TSpeedButton;
    btnVert: TSpeedButton;
    btnHelp: TSpeedButton;
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
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Menu_ExecutarScript: TMenuItem;
    Menu_Mostrar_SimCorrente: TMenuItem;
    cbScripts: TComboBox;
    btnExecutarScript: TSpeedButton;
    btnPararScript: TSpeedButton;
    btnEditarScript: TSpeedButton;
    Menu_Ajuda_Histrico: TMenuItem;
    Menu_Projeto_PHR: TMenuItem;
    Menu_Projeto_MHR: TMenuItem;
    Ajuda1: TMenuItem;
    Menu_Linguagens: TMenuItem;
    Menu_Portugues: TMenuItem;
    Menu_Ingles: TMenuItem;
    Menu_Espanhol: TMenuItem;
    Menu_Utilitarios: TMenuItem;
    Menu_Util_IDF: TMenuItem;
    Menu_Util_CN: TMenuItem;
    N4: TMenuItem;
    MenuProjeto_RemoverObjeto: TMenuItem;
    MenuProjeto_PC_TO_RES: TMenuItem;
    MenuProjeto_RES_TO_PC: TMenuItem;
    N7: TMenuItem;
    MenuProjeto_Editar: TMenuItem;
    btnAssistente: TSpeedButton;
    Bevel6: TBevel;
    N5: TMenuItem;
    Menu_Projeto_Assistente: TMenuItem;
    Menu_Projeto_VA: TMenuItem;
    Menu_About_ARC: TMenuItem;
    N2: TMenuItem;
    N8: TMenuItem;
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
    procedure sbRemoverTrecho_Click(Sender: TObject);
    procedure MostrarGerenciador_Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbPC_TO_RES_Click(Sender: TObject);
    procedure sbRES_TO_PC_Click(Sender: TObject);
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
    procedure Menu_ExecutarScriptClick(Sender: TObject);
    procedure Menu_Mostrar_SimCorrenteClick(Sender: TObject);
    procedure Menu_OtimizarClick(Sender: TObject);
    procedure btnExecutarScriptClick(Sender: TObject);
    procedure Menu_Projeto_VisDadosPostosClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Menu_Ajuda_HistricoClick(Sender: TObject);
    procedure Menu_Projeto_PHRClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Menu_Linguagem_Click(Sender: TObject);
    procedure Menu_Util_IDFClick(Sender: TObject);
    procedure Menu_Util_CNClick(Sender: TObject);
    procedure MenuProjeto_EditarClick(Sender: TObject);
    procedure btnAssistenteClick(Sender: TObject);
    procedure Menu_Projeto_VAClick(Sender: TObject);
    procedure Menu_About_ARCClick(Sender: TObject);
  private
    MC: TSharedMem;

    function  GetProjetoAtivo: Tiphs1_Form_AreaDeProjeto;
    procedure AtualizaBtnBloqueado;
    procedure FormChange(Sender: TObject);
    procedure ConfigurarIdioma(const Sigla: String);

    procedure WMDROPFILES(var Message: TWMDROPFILES); message WM_DROPFILES;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean;
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
     FolderUtils,
     SpreadSheetBook,
     Hidro_Constantes,
     Hidro_Variaveis,
     hidro_Procs,
     iphs1_Procs,
     AboutForm,
     Form_Chart,
     psEditor,
     psBASE,
     psCORE,
     Lib_GlobalObjects_ShowDialog,
     VisaoEmArvore_base, Historico,
     iphs1_EscolherObjetos,
     iphs1_Constantes,
     iphs1_Dialogo_TD_Alagamentos, About_Rochedo;

{$R *.DFM}
{$R IMAGENS.RES}

function Tiphs1_Dialogo_Principal.CreateMDIChild
  (const Name: string; Novo, Max: Boolean): Tiphs1_Form_AreaDeProjeto;
begin
  Result := Tiphs1_Form_AreaDeProjeto.Create(Application);
  if Novo then
     begin
     Result.Projeto.Modificado := True;
     Result.paMensagemInicial.Visible := True;
     end
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
  CreateMDIChild(LanguageManager.GetMessage(cMesID_IPH, 46){'PROJETO '} +
                 IntToStr(MDIChildCount + 1), True, False);
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

procedure Tiphs1_Dialogo_Principal.sbPC_TO_RES_Click(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     if MessageDLG('Tem certeza ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
        ProjetoAtivo.PC_TO_RES(Tiphs1_PC(ProjetoAtivo.ObjetoSelecionado));
        sbArrastar.Down := True;
        end;
end;

procedure Tiphs1_Dialogo_Principal.sbRES_TO_PC_Click(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     if MessageDLG('Tem certeza ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
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
  if not (csDestroying in self.ComponentState) then
     AtualizaMenus(nil);
end;

procedure Tiphs1_Dialogo_Principal.FormCreate(Sender: TObject);
var ini: TIniFile;
begin
  GetMessageManager.RegisterMessage(UM_CLICK_GERENTE, self);
  GetMessageManager.RegisterMessage(UM_COMENTARIO_OBJETO_MUDOU, self);
  GetMessageManager.RegisterMessage(UM_DESCRICAO_OBJETO_MUDOU, self);
  GetMessageManager.RegisterMessage(UM_NOME_OBJETO_MUDOU, self);

  gMemo := Mensagem;
  gDesc := mmDesc;
  gNome := mmNome;
  gSB   := StatusBar;
  gLeds := Leds;

  MC := TSharedMem.Create('MC_PROGRAMA_IPHS1', 1024);

  Screen.OnActiveFormChange := FormChange;
  btnBloqueado.Glyph.LoadFromResourceName(HInstance, 'CADEADO_ABERTO');

  btnEditarScript.Left   := PainelPrincipal.Width - btnEditarScript.Width - 3;
  btnPararScript.Left    := btnEditarScript.Left - btnPararScript.Width - 1;
  btnExecutarScript.Left := btnPararScript.Left - btnExecutarScript.Width;
  cbScripts.Width        := PainelPrincipal.Width - 3 * btnExecutarScript.Width - 3;

  DragAcceptFiles(Handle, True);

  ini := TIniFile.Create(gExePath + 'IPHS1.ini');
  try
    ConfigurarIdioma(ini.ReadString('Geral', 'Idioma', 'br'));
    hidro_Variaveis.gIPHS1_DOS := ini.ReadString('Geral', 'IPHS1_DOS', 'IPHS1_DOS_210.exe');
  finally
    ini.Free;
  end;  
end;

procedure Tiphs1_Dialogo_Principal.FormDestroy(Sender: TObject);
begin
  GetMessageManager.UnRegisterMessage(UM_NOME_OBJETO_MUDOU, self);
  GetMessageManager.UnRegisterMessage(UM_DESCRICAO_OBJETO_MUDOU, self);
  GetMessageManager.UnRegisterMessage(UM_COMENTARIO_OBJETO_MUDOU, self);
  GetMessageManager.UnRegisterMessage(UM_CLICK_GERENTE, self);
  MC.Free;
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
  Menu_Projeto_Assistente.Enabled := b;

  // Botões
  btnImagem.Enabled := b;
  btnMT.Enabled := b;
  btnSalvar.Enabled := b;
  btnDiagnostico.Enabled := b;
  btnExecutar.Enabled := b;
  btnAssistente.Enabled := b;
  btnBloqueado.Enabled := b;
  AtualizaBtnBloqueado;

  b := b and
      (ProjetoAtivo.Projeto.PCs.PCs > 0) and
      (ProjetoAtivo.Projeto.PCs.PC[0].HidroRes <> nil);

  Menu_Projeto_PHR.Enabled := b;
  Menu_Projeto_MHR.Enabled := b;

  sbRemoverObjeto.Enabled   := (Obj is TPC) or
                               (Obj is TSubBacia) or
                               (Obj is Tiphs1_Derivacao) or
                               (Obj is TTrechoDagua);
  sbPC_TO_RES.Enabled       := (Obj is TPC) and not
                               (Obj is Tiphs1_PCR);

  sbRES_TO_PC.Enabled       := (Obj is Tiphs1_PCR);

  MenuProjeto_RemoverObjeto.Enabled := sbRemoverObjeto.Enabled;
  MenuProjeto_PC_TO_RES.Enabled := sbPC_TO_RES.Enabled;
  MenuProjeto_RES_TO_PC.Enabled := sbRES_TO_PC.Enabled;
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

function Tiphs1_Dialogo_Principal.GetProjetoAtivo(): Tiphs1_Form_AreaDeProjeto;
begin
  if ActiveMDIChild is Tiphs1_Form_AreaDeProjeto then
     Result := Tiphs1_Form_AreaDeProjeto(MainForm.ActiveMDIChild)
  else
     Result := nil;
end;

procedure Tiphs1_Dialogo_Principal.Menu_ExecutarClick(Sender: TObject);
Var DS: Char;
begin
  if (ProjetoAtivo <> nil) and ProjetoAtivo.Projeto.RealizarDiagnostico(true) then
     begin
     DS := DecimalSeparator;
     DecimalSeparator := '.';
     Try
       Tiphs1_Projeto(ProjetoAtivo.Projeto).Executar;
     Finally
       DecimalSeparator := DS;
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

procedure Tiphs1_Dialogo_Principal.sbRemoverTrecho_Click(Sender: TObject);
begin
(*
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
*)
end;

procedure Tiphs1_Dialogo_Principal.MostrarGerenciador_Click(Sender: TObject);
begin
  Gerenciador.Show;
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
  sbCriarTrecho.Enabled      := not gBloqueado;
  sbSB_em_PC.Enabled         := not gBloqueado;
  sbInserirPCEntre.Enabled   := not gBloqueado;
  sbPC_To_Res.Enabled        := not gBloqueado;
  sbRes_To_PC.Enabled        := not gBloqueado;

  {$ifdef FINAL}
  NovoArquivo_Click(nil);
  {$endif}

  for i := 1 to ParamCount do
    if subStrings('=', s1, s2, ParamStr(i)) > 0 then
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
     AtualizaBtnBloqueado;
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

procedure Tiphs1_Dialogo_Principal.AtualizaBtnBloqueado;
var b: Boolean;
begin
  if ProjetoAtivo <> nil then
     begin
     b := ProjetoAtivo.Bloqueado;

     Menu_LerFundo.Enabled     := not b;
     Menu_LimparImagem.Enabled := not b;

     if b then
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

procedure Tiphs1_Dialogo_Principal.Menu_ExecutarScriptClick(Sender: TObject);
var s : String;
    p: TProjeto;
    v1: TVariable;
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

  if p <> nil then
     begin
     v1 := TVariable.Create('Projeto', pvtObject, Integer(p), p.ClassType, True);
     RunScript(g_psLib, s, gDir, nil, [v1], p.ObjetosGlobais, False);
     end;
end;

procedure Tiphs1_Dialogo_Principal.Menu_Mostrar_SimCorrenteClick(Sender: TObject);
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
    v1: TVariable;
    x: TPascalScript;
    s: String;
begin
  p := TProjeto(ProjetoAtivo.Projeto);

  v1 := TVariable.Create('Projeto', pvtObject, Integer(p), p.ClassType, True);

  btnExecutarScript.Enabled := False;
  btnPararScript.Enabled := True;

  s := cbScripts.Items[cbScripts.ItemIndex];
  p.VerificaCaminho(s);

  x := TPascalScript.Create;
  try
    x.Code.LoadFromFile(s);
    x.Variables.AddVar(v1);
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
    Planilha: TSpreadSheetBook;
begin
  p := Tiphs1_Projeto(ProjetoAtivo.Projeto);
  if p.DadosPostos <> nil then
     try
       StartWait();
       Planilha := TSpreadSheetBook.Create(p.NomeArquivo, 'Postos');
       p.DadosPostos.ShowInSheet(Planilha);
       Planilha.Show(fsMDIChild);
     finally
       StopWait();
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
  ini := TIniFile.Create(FolderUtils.GetAppDataFolder() + 'IPHS1\IPHS1.ini');
  ini.WriteString('GERAL', 'Idioma', s);
  ini.Free;
end;

procedure Tiphs1_Dialogo_Principal.Menu_Util_IDFClick(Sender: TObject);
begin
  WinExec(pChar(gExePath + 'CurvasIDF.exe'), SW_SHOWNORMAL);
end;

procedure Tiphs1_Dialogo_Principal.Menu_Util_CNClick(Sender: TObject);
begin
  WinExec(pChar(gExePath + 'CN.exe'), SW_SHOWNORMAL);
end;

function Tiphs1_Dialogo_Principal.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_CLICK_GERENTE then
     MainForm.AtualizaMenus(THidroComponente(MSG.ParamAsObject(0))) else

  if MSG.ID = UM_COMENTARIO_OBJETO_MUDOU then
     gMemo.Lines.Assign(THidroComponente(MSG.ParamAsObject(0)).Comentarios) else

  if MSG.ID = UM_DESCRICAO_OBJETO_MUDOU then
     MainForm.mmDesc.Text := THidroComponente(MSG.ParamAsObject(0)).Descricao else

  if MSG.ID = UM_NOME_OBJETO_MUDOU then
     MainForm.mmNome.Text := THidroComponente(MSG.ParamAsObject(0)).Nome;
end;

procedure Tiphs1_Dialogo_Principal.MenuProjeto_EditarClick(Sender: TObject);
begin
  ProjetoAtivo.Projeto.MostrarDialogo;
end;

procedure Tiphs1_Dialogo_Principal.btnAssistenteClick(Sender: TObject);
var r, i, j: Integer;
    p: Tiphs1_Projeto;
    t: Tiphs1_TrechoDagua;
    s, s2: String;
begin
  r := MessageDLG('O assistente pedirá os dados para cada objeto da rede'#13#10 +
                  'começando pelos dados do projeto, depois os PCs, etc...'#13#10 +
                  'Para sair do assistente utilize o botão "Cancelar" de qualquer diálogo."'#13#10 +
                  'Você deseja continuar ?',
                  mtConfirmation, [mbYes, mbNo], 0);

  p := Tiphs1_Projeto(ProjetoAtivo.Projeto);
  if r = mrYes then
     begin
     r := p.MostrarDialogo('Assistente: ' + p.Projeto.Nome);
     if r = mrOK then
        for i := 0 to p.PCs.PCs-1 do
          begin
          s := 'Assistente: ' + p.PCs[i].Nome;

          if p.PCs[i].MostrarDialogo(s) = mrCancel then Exit;

          // Para o trecho-dagua e suas sub-bacias
          t := Tiphs1_TrechoDagua(p.PCs[i].TrechoDagua);
          if t <> nil then
             begin
             s2 := s + '.' + t.Nome;
             if t.MostrarDialogo(s2) = mrCancel then Exit;
             if t.SubBacia <> nil then
                if t.SubBacia.MostrarDialogo(s2 + '.' + t.SubBacia.Nome) = mrCancel then Exit;
             end;

          // Para cada sub-bacia deste PC/Res
          for j := 0 to p.PCs[i].SubBacias-1 do
            begin
            s2 := s + '.' + p.PCs[i].SubBacia[j].Nome;
            if p.PCs[i].SubBacia[j].MostrarDialogo(s2) = mrCancel then Exit;
            end;

          // Para as derivações
          if p.PCs[i] is Tiphs1_PC then
             if Tiphs1_PC(p.PCs[i]).Derivacao <> nil then
                begin
                s2 := s + '.' + Tiphs1_PC(p.PCs[i]).Derivacao.Nome;
                if Tiphs1_PC(p.PCs[i]).Derivacao.MostrarDialogo(s2) = mrCancel then Exit;
                end;
          end;
     end;
end;

procedure Tiphs1_Dialogo_Principal.Menu_Projeto_VAClick(Sender: TObject);
begin
  Tiphs1_fo_TD_Alagamentos.Create(Tiphs1_Projeto(ProjetoAtivo.Projeto));
end;

procedure Tiphs1_Dialogo_Principal.Menu_About_ARCClick(Sender: TObject);
begin
  with TfoAbout_Rochedo.Create(nil) do
    begin
    ShowModal;
    Free;
    end;
end;

end.


