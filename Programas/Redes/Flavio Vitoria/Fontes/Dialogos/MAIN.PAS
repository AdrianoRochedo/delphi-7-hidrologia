unit Main;

interface
uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
     StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
     ActnList, ToolWin, ImgList, FileCtrl, Mask, ExtDlgs, AppEvnts,
     DiretivasDeCompilacao,
     SysUtilsEx,
     MessageManager,
     pr_Classes,
     pr_Form_AreaDeProjeto_Base,
     pr_Application;

type
  TprDialogo_Principal = class(TForm, IMessageReceptor)
    MainMenu: TMainMenu;
    Menu_Arquivo: TMenuItem;
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
    sbCriarTrecho: TSpeedButton;
    sbInserirPCEntre: TSpeedButton;
    sbRemoverObjeto: TSpeedButton;
    Panel1: TPanel;
    Panel2: TPanel;
    StatusBar: TStatusBar;
    Leds: TImage;
    Menu_Projeto: TMenuItem;
    GerarArquivos: TSaveDialog;
    sbRemoverTrecho: TSpeedButton;
    Menu_Gerenciador: TMenuItem;
    PainelPrincipal: TPanel;
    btnNovo: TSpeedButton;
    btnAbrir: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnGerente: TSpeedButton;
    btnCascata: TSpeedButton;
    btnHor: TSpeedButton;
    btnVert: TSpeedButton;
    PS: TPanel;
    Menu_Ver_Mensagens: TMenuItem;
    btnBloqueado: TSpeedButton;
    btnMT: TSpeedButton;
    Menu_LerFundo: TMenuItem;
    OpenBitmap: TOpenPictureDialog;
    Menu_LimparImagem: TMenuItem;
    btnImagem: TSpeedButton;
    Eventos: TApplicationEvents;
    Menu_Projeto_Visualizar_Demendas: TMenuItem;
    Menu_Mostrar_VariaveisGlobais: TMenuItem;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Menu_ExecutarScript: TMenuItem;
    cbScripts: TComboBox;
    btnExecutarScript: TSpeedButton;
    btnPararScript: TSpeedButton;
    btnEditarScript: TSpeedButton;
    Menu_Ajuda_Historico: TMenuItem;
    StatusBar2: TStatusBar;
    Label1: TLabel;
    N2: TMenuItem;
    Menu_Projeto_Visualizar_TD: TMenuItem;
    Menu_Projeto_Visualizar_Imagem: TMenuItem;
    Menu_Projeto_Visualizar: TMenuItem;
    N7: TMenuItem;
    Menu_Projeto_Bloquear: TMenuItem;
    N8: TMenuItem;
    Menu_Projeto_PG: TMenuItem;
    Bevel6: TBevel;
    btnOpcoesProjeto: TSpeedButton;
    sbCriarCenarioDemanda: TSpeedButton;
    MenuFecharTodos: TMenuItem;
    N11: TMenuItem;
    Menu_Mensagens: TMenuItem;
    N9: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    MenuCenarios: TPopupMenu;
    sbCriarQA: TSpeedButton;
    Menu_ProjetoSimples: TMenuItem;
    Menu_ProjetoZoom: TMenuItem;
    Menu_Arquivo_Novo: TMenuItem;
    procedure NovoArquivo_Click(Sender: TObject);
    procedure AbrirArquivo_Click(Sender: TObject);
    procedure HelpAbout_Click(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure sbRemoveObjeto_Click(Sender: TObject);
    procedure Ferramentas_Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Menu_Arquivo_SalvarComoClick(Sender: TObject);
    procedure Cascata_Click(Sender: TObject);
    procedure Horizontal_Click(Sender: TObject);
    procedure Vertical_Click(Sender: TObject);
    procedure SalvarArquivo_Click(Sender: TObject);
    procedure Menu_Arquivo_FecharClick(Sender: TObject);
    procedure sbRemoverTrechoClick(Sender: TObject);
    procedure MostrarGerenciador_Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Help_Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Menu_Ver_MensagensClick(Sender: TObject);
    procedure btnBloqueadoClick(Sender: TObject);
    procedure btnMTClick(Sender: TObject);
    procedure Menu_LerFundoClick(Sender: TObject);
    procedure Menu_LimparImagemClick(Sender: TObject);
    procedure btnImagemClick(Sender: TObject);
    procedure MessageEvent(var Msg: tagMSG; var Handled: Boolean);
    procedure Menu_Mostrar_VariaveisGlobaisClick(Sender: TObject);
    procedure Menu_ExecutarScriptClick(Sender: TObject);
    procedure btnExecutarScriptClick(Sender: TObject);
    procedure Menu_Ajuda_HistoricoClick(Sender: TObject);
    procedure Menu_Projeto_PGClick(Sender: TObject);
    procedure MenuCenariosPopup(Sender: TObject);
    procedure sbCriarCenarioDemandaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuFecharTodosClick(Sender: TObject);
    procedure Menu_MensagensClick(Sender: TObject);
  private
    MC: TSharedMem;

    procedure MenuCenarioClick(Sender: TObject);
    procedure DescreverObjeto(HC: TComponente);
    function  ObtemAreaDeProjetoAtiva: TfoAreaDeProjeto_Base;
    procedure AtualizaBtnBloqueado;
    procedure FecharProjetos();
    procedure FormChange(Sender: TObject);

    procedure WMDROPFILES(var Message: TWMDROPFILES); message WM_DROPFILES;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean;

    // Tratamento dos eventos proviniente da área de projeto
    procedure TrataMensagemDaAreaDeProjeto(const ID: String; Objeto: TObject);
    function  TrataStatusDoBotaoDaAreaDeProjeto(const ID_Botao: String): boolean;
    procedure TrataAvisoDaAreaDeProjeto(const Aviso: String);
  public
    function  CreateMDIChild(const Name: string; Novo, Max: Boolean; TipoNovo: integer): TfoAreaDeProjeto_Base;
    procedure AtualizarMenus(Obj: TComponente);
    property  AreaDeProjeto: TfoAreaDeProjeto_Base read ObtemAreaDeProjetoAtiva;
  end;

var
  MainForm: TprDialogo_Principal;

implementation
uses pr_Const,
     pr_Tipos,
     pr_Vars,
     ShellAPI,
     OutPut,
     Plugin,
     WinUtils,
     pr_Funcoes,
     AboutForm,
     pr_Gerenciador,
     Form_Chart,
     psEditor,
     psBASE,
     psCORE,
     Lib_GlobalObjects_ShowDialog,
     Historico,

     // Areas de Projeto
     pr_Form_AreaDeProjeto_BMP,
     pr_Form_AreaDeProjeto_Zoom;

{$R *.DFM}
{$R IMAGENS.RES}

function TprDialogo_Principal.CreateMDIChild(const Name: string; Novo, Max: Boolean; TipoNovo: integer): TfoAreaDeProjeto_Base;
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
       if Max then Result.WindowState := wsMaximized;
     finally
       Result.Enabled := true;
       StopWait;
     end;

  AtualizarMenus(nil);
end;

procedure TprDialogo_Principal.NovoArquivo_Click(Sender: TObject);
begin
  CreateMDIChild('PROJETO ' + IntToStr(MDIChildCount + 1), True, False, TMenuItem(Sender).Tag);
end;

procedure TprDialogo_Principal.AbrirArquivo_Click(Sender: TObject);
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

procedure TprDialogo_Principal.sbRemoveObjeto_Click(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     begin
     AreaDeProjeto.RemoverObjeto(AreaDeProjeto.ObjetoSelecionado);
     sbArrastar.Down := True;
     end;
end;

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
        if sb.Name = 'sbCriarDescarga'  then Applic.ShowMessage(cMsgAjuda10) else
        if sb.Name = 'sbCriarQA'        then Applic.ShowMessage(cMsgAjuda11) else
        if sb.Name = 'sbCriarDemanda'   then Applic.ShowMessage(cMsgAjuda07) ;

        Applic.ShowMessageForm();
        end;
end;

procedure TprDialogo_Principal.FormChange(Sender: TObject);
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

procedure TprDialogo_Principal.FormCreate(Sender: TObject);
begin
  GetMessageManager.RegisterMessage(UM_CLICK_GERENTE, self);
  GetMessageManager.RegisterMessage(UM_COMENTARIO_OBJETO_MUDOU, self);
  GetMessageManager.RegisterMessage(UM_DESCRICAO_OBJETO_MUDOU, self);
  GetMessageManager.RegisterMessage(UM_NOME_OBJETO_MUDOU, self);

  MC := TSharedMem.Create('MC_PROGRAMA_PROPAGAR', 1024);

  Screen.OnActiveFormChange := FormChange;
  btnBloqueado.Glyph.LoadFromResourceName(HInstance, 'CADEADO_ABERTO');

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

procedure TprDialogo_Principal.AtualizarMenus(Obj: TComponente);
var b : Boolean;
begin
  b := (AreaDeProjeto <> nil);

  Menu_Janelas.Enabled := (MDIChildCount > 0);

  if b then
     begin
     Applic.WriteStatus(['Active Project: ' + AreaDeProjeto.Projeto.Nome], false);
     if not AreaDeProjeto.Projeto.Scripts.Equals(cbScripts.Items) then
        begin
        cbScripts.Items.Assign(AreaDeProjeto.Projeto.Scripts);
        btnExecutarScript.Enabled := (cbScripts.Items.Count > 0);
        btnEditarScript.Enabled := btnExecutarScript.Enabled;
        if btnExecutarScript.Enabled then cbScripts.ItemIndex := 0;
        end;
     end
  else
     begin
     Applic.WriteStatus([''], false);
     Gerenciador.AreaDeProjeto := nil;
     cbScripts.Clear;
     btnExecutarScript.Enabled := False;
     btnPararScript.Enabled := False;
     btnEditarScript.Enabled := False;
     end;

  // Menus
  Menu_Projeto.Enabled := b;
  Menu_Arquivo_SalvarComo.Enabled := b;
  Menu_Arquivo_Salvar.Enabled := b;
  Menu_Arquivo_Fechar.Enabled := b;
  Menu_Mostrar_VariaveisGlobais.Enabled := b;

  // Botões
  btnImagem.Enabled := b;
  btnMT.Enabled := b;
  btnSalvar.Enabled := b;
  btnBloqueado.Enabled := b;
  btnOpcoesProjeto.Enabled := b;
  AtualizaBtnBloqueado();

  // ATENCAO: Classes de demanda sao removidas por menu

  sbRemoverObjeto.Enabled   := (Obj is TprPC) or
                               (Obj is TprCenarioDeDemanda);

  sbRemoverTrecho.Enabled   := (Obj is TprPC) and
                               (TprPC(Obj).TrechoDagua <> nil) and
                               (TprPC(Obj).TrechoDagua.PC_aJusante <> nil);
end;

function TprDialogo_Principal.ObtemAreaDeProjetoAtiva: TfoAreaDeProjeto_Base;
begin
  if ActiveMDIChild is TfoAreaDeProjeto_Base then
     Result := TfoAreaDeProjeto_Base(ActiveMDIChild)
  else
     Result := nil;
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

procedure TprDialogo_Principal.sbRemoverTrechoClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     begin
     if AreaDeProjeto.ObjetoSelecionado is TprPC then
        TprPC(AreaDeProjeto.ObjetoSelecionado).RemoverTrecho();

     AreaDeProjeto.Atualizar();
     AreaDeProjeto.Projeto.Modificado := True;
     sbArrastar.Down := True;
     AtualizarMenus(AreaDeProjeto.ObjetoSelecionado);
     end;
end;

procedure TprDialogo_Principal.MostrarGerenciador_Click(Sender: TObject);
begin
  Gerenciador.Show();
end;

procedure TprDialogo_Principal.Help_Click(Sender: TObject);
begin
  HelpAbout_Click(Sender);
end;

procedure TprDialogo_Principal.FormShow(Sender: TObject);
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

procedure TprDialogo_Principal.Menu_Ver_MensagensClick(Sender: TObject);
begin
  gErros.Show;
end;

procedure TprDialogo_Principal.btnBloqueadoClick(Sender: TObject);
begin
  if AreaDeProjeto <> nil then
     begin
     AreaDeProjeto.Bloqueado := not AreaDeProjeto.Bloqueado;
     AtualizaBtnBloqueado();
     end;
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
  {$ifndef VERSAO_LIMITADA}
  if AreaDeProjeto <> nil then
     if OpenBitmap.Execute then
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

procedure TprDialogo_Principal.AtualizaBtnBloqueado;
begin
  if AreaDeProjeto <> nil then
     if AreaDeProjeto.Bloqueado then
        btnBloqueado.Glyph.LoadFromResourceName(HInstance, 'CADEADO_FECHADO')
     else
        btnBloqueado.Glyph.LoadFromResourceName(HInstance, 'CADEADO_ABERTO');
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
      CreateMDIChild(s, False, False, -1);
      if Msg.message = AM_ABRIR_APAGAR_ARQUIVO then DeleteFile(s);
      end;
  end;
end;

procedure TprDialogo_Principal.Menu_Mostrar_VariaveisGlobaisClick(Sender: TObject);
var d: TGlobalObjects_ShowDialog;
begin
  if AreaDeProjeto = nil then Exit;
  d := TGlobalObjects_ShowDialog.Create(nil);
  d.Mostrar(AreaDeProjeto.Projeto.GlobalObjects, AreaDeProjeto.Projeto.Nome);
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
    CreateMDIChild(buffer, False, False, -1);
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

function TprDialogo_Principal.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_CLICK_GERENTE then
     AtualizarMenus(MSG.ParamAsPointer(0))
  else
  if (MSG.ID = UM_COMENTARIO_OBJETO_MUDOU) or
     (MSG.ID = UM_DESCRICAO_OBJETO_MUDOU) or
     (MSG.ID = UM_NOME_OBJETO_MUDOU) then
     DescreverObjeto( TComponente(MSG.ParamAsObject(0)) )
  else
end;

procedure TprDialogo_Principal.Menu_Projeto_PGClick(Sender: TObject);
begin
  AreaDeProjeto.Projeto.Editar();
end;

procedure TprDialogo_Principal.MenuCenariosPopup(Sender: TObject);
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

procedure TprDialogo_Principal.MenuCenarioClick(Sender: TObject);
var m: TMenuItem;
begin
  m := TMenuItem(Sender);
  sbCriarCenarioDemanda.Hint := m.Hint;
  if m.Bitmap.Handle <> 0 then
     begin
     sbCriarCenarioDemanda.Caption := '';
     sbCriarCenarioDemanda.Glyph.Handle := m.Bitmap.Handle;
     end
  else
     sbCriarCenarioDemanda.Caption := 'C';

  Applic.Plugins.ActiveObjFactoryIndex := m.Tag;
end;

procedure TprDialogo_Principal.sbCriarCenarioDemandaClick(Sender: TObject);
var sb: TSpeedButton;
     p: TPoint;
begin
  Applic.ShowMessage(cMsgAjuda09);
  sb := TSpeedButton(Sender);
  if sb.Down then
     begin
     p := Ferramentas.ClientToScreen(Point(sb.Left, sb.Top));
     MenuCenarios.Popup(p.x, p.y);
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

procedure TprDialogo_Principal.TrataAvisoDaAreaDeProjeto(const Aviso: String);
begin
  Applic.ShowMessage(Aviso);
end;

procedure TprDialogo_Principal.TrataMensagemDaAreaDeProjeto(const ID: String; Objeto: TObject);
var HC: TComponente;
begin
  HC := TComponente(Objeto);

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
     if not (sbInfo.Down or sbSel.Down) then
        sbSel.Down := true;
     end
}
  else
end;

function TprDialogo_Principal.TrataStatusDoBotaoDaAreaDeProjeto(const ID_Botao: String): boolean;
begin
{TODO 1 -cGIS: sbSel}
{
  if CompareText(ID_Botao, 'Selecionar') = 0 then
     Result := sbSel.Down
  else
}
  if CompareText(ID_Botao, 'Arrastar') = 0 then
     Result := sbArrastar.Down
  else

{TODO 1 -cGIS: sbInfo}
{
  if CompareText(ID_Botao, 'Ver Registros') = 0 then
     Result := sbInfo.Down
  else
}

  if CompareText(ID_Botao, 'Criar Reservatorio') = 0 then
     Result := sbPCReservatorio.Down
  else
  if CompareText(ID_Botao, 'Criar PC') = 0 then
     Result := sbCriarPC.Down
  else
  if CompareText(ID_Botao, 'Criar TD') = 0 then
     Result := sbCriarTrecho.Down
  else
  if CompareText(ID_Botao, 'Inserir PC') = 0 then
     Result := sbInserirPCEntre.Down
  else
  if CompareText(ID_Botao, 'Criar Cenario de Demanda') = 0 then
     Result := sbCriarCenarioDemanda.Down
  else
     Result := False;
end;

procedure TprDialogo_Principal.DescreverObjeto(HC: TComponente);
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


