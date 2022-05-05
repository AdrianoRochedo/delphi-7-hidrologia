unit JanelaPrincipal;

  // Modifique o método CreateMDIChild para a correta instanciação da Área de Projeto.

interface

uses
  // Delphi
  Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, FileCtrl, Mask, ExtDlgs,

  // Geral
  SysUtilsEx,
  MessageManager,

  // Projeto
  hidro_Classes,
  hidro_AreaDeProjeto;

type
  TPrincipal = class(TForm, IMessageReceptor)
    MainMenu1: TMainMenu;
    Menu_Arquivo: TMenuItem;
    Menu_Arquivo_Novo: TMenuItem;
    Menu_Arquivo_Abrir: TMenuItem;
    Menu_Arquivo_Fechar: TMenuItem;
    Menu_Janelas: TMenuItem;
    N1: TMenuItem;
    Menu_Arquivo_Sair: TMenuItem;
    Menu_Janelas_Cascata: TMenuItem;
    Menu_Janelas_Horizontal: TMenuItem;
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
    Panel3: TPanel;
    Mensagem: TMemo;
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
    OpenLayer: TOpenPictureDialog;
    btnImagem: TSpeedButton;
    btnParar: TSpeedButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    MenuProjeto_RemoverObjeto: TMenuItem;
    N7: TMenuItem;
    MenuProjeto_Editar: TMenuItem;
    btnAssistente: TSpeedButton;
    Bevel6: TBevel;
    Menu_Projeto_Assistente: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Menu_Projeto_Zoom100: TMenuItem;
    MenuProjeto_AddLayer: TMenuItem;
    sbSel: TSpeedButton;
    procedure NovoArquivo_Click(Sender: TObject);
    procedure AbrirArquivo_Click(Sender: TObject);
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
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Menu_Ver_MensagensClick(Sender: TObject);
    procedure btnBloqueadoClick(Sender: TObject);
    procedure btnMTClick(Sender: TObject);
    procedure Menu_LimparImagemClick(Sender: TObject);
    procedure btnImagemClick(Sender: TObject);
    procedure Menu_Mostrar_VariaveisGlobaisClick(Sender: TObject);
    procedure btnPararClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure MenuProjeto_EditarClick(Sender: TObject);
    procedure btnAssistenteClick(Sender: TObject);
    procedure Menu_Projeto_Zoom100Click(Sender: TObject);
    procedure MenuProjeto_AddLayerClick(Sender: TObject);
  private
    // Tratamento dos eventos proviniente da área de projeto
    procedure TrataMensagemDaAreaDeProjeto(const ID: String; Objeto: TObject);
    function  TrataStatusDoBotaoDaAreaDeProjeto(const ID_Botao: String): boolean;
    procedure TrataAvisoDaAreaDeProjeto(const Aviso: String);

    procedure ShowMessage(const aMessage: String);
    function  GetProjetoAtivo: THidroAreaDeProjeto;
    procedure AtualizaBtnBloqueado;
    procedure FormChange(Sender: TObject);

    procedure WMDROPFILES(var Message: TWMDROPFILES); message WM_DROPFILES;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean;
  public
    procedure CreateMDIChild(const Name: string; Novo, Max: Boolean);
    procedure AtualizarMenus(Obj: THidroComponente);
    property  ProjetoAtivo: THidroAreaDeProjeto read GetProjetoAtivo;
  end;

implementation
uses // Geral
     IniFiles,
     ShellAPI,
     WinUtils,
     MapObjects,

     // Projeto
     Hidro_Constantes,
     Hidro_Variaveis,
     xx_AreaDeProjeto;

{$R *.DFM}
{$R IMAGENS.RES}

procedure TPrincipal.TrataAvisoDaAreaDeProjeto(const Aviso: String);
begin
  Mensagem.Text := Aviso;
end;

procedure TPrincipal.TrataMensagemDaAreaDeProjeto(const ID: String; Objeto: TObject);
var HC: THidroComponente;
begin
  HC := THidroComponente(Objeto);

  if CompareText(ID, 'Descrever Objeto') = 0 then
     begin
     mmNome.Text := HC.Nome;
     Mensagem.Lines.Assign(HC.Comentarios);
     end
  else
  if CompareText(ID, 'Atualizar Opcoes') = 0 then
     begin
     AtualizarMenus(HC);
     end
  else
  if CompareText(ID, 'Destruicao da Area de Projeto') = 0 then
     begin
     mmNome.Clear;
     Mensagem.Clear;
     end
  else
  if CompareText(ID, 'Selecionar Botao Selecionar') = 0 then
     begin
     sbSel.Down := true;
     end
  else
end;

function TPrincipal.TrataStatusDoBotaoDaAreaDeProjeto(const ID_Botao: String): boolean;
begin
  if CompareText(ID_Botao, 'Selecionar') = 0 then
     Result := sbSel.Down
  else
  if CompareText(ID_Botao, 'Arrastar') = 0 then
     Result := sbArrastar.Down
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
  if CompareText(ID_Botao, 'Criar Derivacao') = 0 then
     Result := sbCriarDerivacao.Down
  else
  if CompareText(ID_Botao, 'Criar SB') = 0 then
     Result := sbCriarSubBacia.Down
  else
  if CompareText(ID_Botao, 'Criar TD') = 0 then
     Result := sbCriarTrecho.Down
  else
  if CompareText(ID_Botao, 'Inserir PC') = 0 then
     Result := sbInserirPCEntre.Down
  else
     Result := False;
end;

procedure TPrincipal.CreateMDIChild(const Name: string; Novo, Max: Boolean);
var Result: TxxAreaDeProjeto;
    GCS: ImoGeoCoordSys;
     ML: ImoMapLayer;
      U: ImoUnit;
      v: Variant;
begin
  Result := TxxAreaDeProjeto.Create(Application);

  // Conecta os Eventos
  Result.Evento_Mensagem      := TrataMensagemDaAreaDeProjeto;
  Result.Evento_StatusDoBotao := TrataStatusDoBotaoDaAreaDeProjeto;
  Result.Evento_Aviso         := TrataAvisoDaAreaDeProjeto;

  if Novo then
     begin
     Result.Projeto.Modificado := True;
     Result.mmMensagemInicial.Visible := True;

     // teste <<<
     Result.Map.Visible := False;

     //Result.Projeto.DirTrab := '';
     Result.Projeto.AddLayer('F:\Projetos\Hidrologia\Programas\Prototipos\Redes\Nivel 3\Camadas\Teste\pt_vazio.shp');
{
     GCS := CoGeoCoordSys.Create;
     GCS.Type_ := moGEOCS_WGS1984;
}
     //ML := coMapLayer.Create;
     //ML.CoordinateSystem := GCS;

     //Result.Map.Layers.Add(ML);

     Result.Map.Visible := True;
     // teste <<<

     end
  else
     try
       StartWait;
       Result.Projeto.LerDoArquivo(Name);
       if Max then Result.WindowState := wsMaximized;
     finally
       StopWait;
     end;

  AtualizarMenus(nil);
end;

procedure TPrincipal.NovoArquivo_Click(Sender: TObject);
begin
  CreateMDIChild('PROJETO ' + IntToStr(MDIChildCount + 1), True, False);
end;

procedure TPrincipal.AbrirArquivo_Click(Sender: TObject);
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

procedure TPrincipal.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

// Barra de ferramentas -----------------------------------------------------

procedure TPrincipal.sbRemoveObjeto_Click(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     if MessageDLG('Confirma a remoção ?', mtConfirmation, [mbYES, mbNO], 0) = mrYES then
        begin
        ProjetoAtivo.RemoverObjeto(ProjetoAtivo.ObjetoSelecionado);
        sbArrastar.Down := True;
        end;
end;

procedure TPrincipal.Ferramentas_Click(Sender: TObject);
var sb: TSpeedButton;
begin
  sb := TSpeedButton(Sender);
  if not sb.Down then Exit;

  if sb.Name = 'sbArrastar' then
     begin
     ShowMessage('Arrastar Objeto');
     Screen.Cursor := crHandPoint;
     end
  else
     begin
     Screen.Cursor := crDefault;

     if sb.Name = 'sbSel'            then  ShowMessage('Selecionar Objeto') else
     if sb.Name = 'sbCriarPC'        then  ShowMessage(cMsgAjuda03) else
     if sb.Name = 'sbCriarSubBacia'  then  ShowMessage(cMsgAjuda02) else
     if sb.Name = 'sbCriarTrecho'    then  ShowMessage(cMsgAjuda01) else
     if sb.Name = 'sbInserirPCEntre' then  ShowMessage(cMsgAjuda05) else
     if sb.Name = 'sbPCReservatorio' then  ShowMessage(cMsgAjuda08) else
     if sb.Name = 'sbCriarDerivacao' then
        ShowMessage('Clique em um Ponto de Controle para criar uma Derivação');
     end;
end;

procedure TPrincipal.FormChange(Sender: TObject);
begin
  if not (csDestroying in self.ComponentState) then
     AtualizarMenus(nil);
end;

procedure TPrincipal.FormCreate(Sender: TObject);
var ini: TIniFile;
begin
  GetMessageManager.RegisterMessage(UM_COMENTARIO_OBJETO_MUDOU, self);
  GetMessageManager.RegisterMessage(UM_NOME_OBJETO_MUDOU, self);

  gSB   := StatusBar;
  gLeds := Leds;

  Screen.OnActiveFormChange := FormChange;
  btnBloqueado.Glyph.LoadFromResourceName(HInstance, 'CADEADO_ABERTO');

  DragAcceptFiles(Handle, True);
end;

procedure TPrincipal.FormDestroy(Sender: TObject);
begin
  GetMessageManager.UnRegisterMessage(UM_NOME_OBJETO_MUDOU, self);
  GetMessageManager.UnRegisterMessage(UM_COMENTARIO_OBJETO_MUDOU, self);
end;

procedure TPrincipal.Menu_Arquivo_SalvarComoClick(Sender: TObject);
var oldName : String;
begin
  oldName := ProjetoAtivo.Projeto.NomeArquivo;
  ProjetoAtivo.Projeto.NomeArquivo := '';
  ProjetoAtivo.Salvar;
  if ProjetoAtivo.Projeto.NomeArquivo = '' then
     ProjetoAtivo.Projeto.NomeArquivo := oldName;
end;

procedure TPrincipal.SalvarArquivo_Click(Sender: TObject);
begin
  try
    StartWait;
    ProjetoAtivo.Salvar;
  finally
    StopWait;
  end;
end;

procedure TPrincipal.AtualizarMenus(Obj: THidroComponente);
var b : Boolean;
begin
  b := (ProjetoAtivo <> nil);

  Menu_Janelas.Enabled := (MDIChildCount > 0);
  Menu_Arquivo_Fechar.Enabled := Menu_Janelas.Enabled;

  // Menus
  Menu_Projeto.Enabled := b;
  Menu_Arquivo_SalvarComo.Enabled := b;
  Menu_Arquivo_Salvar.Enabled := b;
  Menu_Arquivo_Fechar.Enabled := b;
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

  b := b and (ProjetoAtivo.Projeto.PCs.PCs > 0);

  sbRemoverObjeto.Enabled   := (Obj is TPC) or
                               (Obj is TSubBacia) or
                               //(Obj is TDerivacao) or
                               (Obj is TTrechoDagua);

  MenuProjeto_RemoverObjeto.Enabled := sbRemoverObjeto.Enabled;
end;

procedure TPrincipal.Diagnostico_Click(Sender: TObject);
var b: Boolean;
begin
  b := ProjetoAtivo.Projeto.RealizarDiagnostico(True);
  SetGlobalStatus(b);
  if b then
     ShowMessage('Diagnóstico: OK')
  else
     gErros.Show;
end;

function TPrincipal.GetProjetoAtivo: THidroAreaDeProjeto;
begin
  if ActiveMDIChild is THidroAreaDeProjeto then
     Result := THidroAreaDeProjeto(ActiveMDIChild)
  else
     Result := nil;
end;

procedure TPrincipal.Menu_ExecutarClick(Sender: TObject);
Const Completo = True;
Var DS: Char;
begin
  if ProjetoAtivo.Projeto.RealizarDiagnostico(Completo) then
     begin
     DS := DecimalSeparator;
     DecimalSeparator := '.';
     Try
       //Tiphs1_Projeto(ProjetoAtivo.Projeto).Executar;
     Finally
       btnParar.Enabled := False;
       DecimalSeparator := DS;
       End;
     end
  else
     gErros.Show
end;

procedure TPrincipal.Cascata_Click(Sender: TObject);
begin
  Self.Cascade;
end;

procedure TPrincipal.Horizontal_Click(Sender: TObject);
begin
  Self.TileMode := tbHorizontal;
  Self.Tile;
end;

procedure TPrincipal.Vertical_Click(Sender: TObject);
begin
  Self.TileMode := tbVertical;
  Self.Tile;
end;

procedure TPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TPrincipal.Menu_Arquivo_FecharClick(Sender: TObject);
begin
  ActiveMDIChild.Close;
end;

procedure TPrincipal.sbRemoverTrecho_Click(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     if ProjetoAtivo.ObjetoSelecionado is TPC then
        if MessageDLG('Tem Certeza que deseja remover este Trecho ?',
           mtConfirmation, [mbYes, mbNO], 0) = mrYes then
           begin
           TPC(ProjetoAtivo.ObjetoSelecionado).RemoverTrecho;
           ProjetoAtivo.DesenharRede;
           ProjetoAtivo.Projeto.Modificado := True;
           sbArrastar.Down := True;
           AtualizarMenus(ProjetoAtivo.ObjetoSelecionado);
           end;
end;

procedure TPrincipal.FormShow(Sender: TObject);
var i: Integer;
    s1, s2: String;
begin
  Application.Title := 'Genérico - ' + gVersao;
  Caption := Application.Title;

  {$ifdef FINAL}
  NovoArquivo_Click(nil);
  {$endif}

  for i := 1 to ParamCount do
    if getInfo('=', s1, s2, ParamStr(i)) > 0 then
       if CompareText(s1, 'ARQUIVO') = 0 then
          begin
          if FileExists(s2) then
             begin
             CreateMDIChild(s2, False, True);
             gDir := ExtractFilePath(s2);
             end;
          end;
end;

procedure TPrincipal.Menu_Ver_MensagensClick(Sender: TObject);
begin
  gErros.Show;
end;

procedure TPrincipal.btnBloqueadoClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     begin
     ProjetoAtivo.Bloqueado := not ProjetoAtivo.Bloqueado;
     AtualizaBtnBloqueado;
     end;
end;

procedure TPrincipal.btnMTClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     begin
     ProjetoAtivo.MostrarTrechos := not ProjetoAtivo.MostrarTrechos;
     ProjetoAtivo.DesenharRede;
     ProjetoAtivo.Projeto.Modificado := True;
     end;
end;

procedure TPrincipal.AtualizaBtnBloqueado;
var b: Boolean;
begin
  if ProjetoAtivo <> nil then
     begin
     b := ProjetoAtivo.Bloqueado;

     if b then
        btnBloqueado.Glyph.LoadFromResourceName(HInstance, 'CADEADO_FECHADO')
     else
        btnBloqueado.Glyph.LoadFromResourceName(HInstance, 'CADEADO_ABERTO');
     end;
end;

procedure TPrincipal.Menu_LimparImagemClick(Sender: TObject);
begin
  ProjetoAtivo.Projeto.NomeArqFundo := '';
  ProjetoAtivo.DesenharRede;
end;

procedure TPrincipal.btnImagemClick(Sender: TObject);
begin
  if ProjetoAtivo <> nil then
     begin
     ProjetoAtivo.MostrarImagemFundo := not ProjetoAtivo.MostrarImagemFundo;
     ProjetoAtivo.DesenharRede;
     end;
end;

procedure TPrincipal.Menu_Mostrar_VariaveisGlobaisClick(Sender: TObject);
//var d: TGlobalObjects_ShowDialog;
begin
  //d := TGlobalObjects_ShowDialog.Create(nil);
  //d.Mostrar(ProjetoAtivo.Projeto.ObjetosGlobais, ProjetoAtivo.Projeto.Nome);
end;

procedure TPrincipal.btnPararClick(Sender: TObject);
begin
  ProjetoAtivo.Projeto.TerminarSimulacao;
end;

procedure TPrincipal.WMDROPFILES(var Message: TWMDROPFILES);
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

procedure TPrincipal.FormActivate(Sender: TObject);
begin
  AtualizarMenus(nil);
end;

function TPrincipal.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_COMENTARIO_OBJETO_MUDOU then
     Mensagem.Lines.Assign(THidroComponente(MSG.ParamAsObject(0)).Comentarios) else

  if MSG.ID = UM_NOME_OBJETO_MUDOU then
     mmNome.Text := THidroComponente(MSG.ParamAsObject(0)).Nome;
end;

procedure TPrincipal.MenuProjeto_EditarClick(Sender: TObject);
begin
  ProjetoAtivo.Projeto.MostrarDialogo;
end;

procedure TPrincipal.btnAssistenteClick(Sender: TObject);
var r, i, j: Integer;
    p: TProjeto;
    t: TTrechoDagua;
    s, s2: String;
begin
  r := MessageDLG('O assistente pedirá os dados para cada objeto da rede'#13#10 +
                  'começando pelos dados do projeto, depois os PCs, etc...'#13#10 +
                  'Para sair do assistente utilize o botão "Cancelar" de qualquer diálogo."'#13#10 +
                  'Você deseja continuar ?',
                  mtConfirmation, [mbYes, mbNo], 0);

  p := TProjeto(ProjetoAtivo.Projeto);
  if r = mrYes then
     begin
     r := p.MostrarDialogo('Assistente: ' + p.Projeto.Nome);
     if r = mrOK then
        for i := 0 to p.PCs.PCs-1 do
          begin
          s := 'Assistente: ' + p.PCs[i].Nome;

          if p.PCs[i].MostrarDialogo(s) = mrCancel then Exit;

          // Para o trecho-dagua e suas sub-bacias
          t := TTrechoDagua(p.PCs[i].TrechoDagua);
          if t <> nil then
             begin
             s2 := s + '.' + t.Nome;
             if t.MostrarDialogo(s2) = mrCancel then Exit;
             //if t.SubBacia <> nil then
               // if t.SubBacia.MostrarDialogo(s2 + '.' + t.SubBacia.Nome) = mrCancel then Exit;
             end;

          // Para cada sub-bacia deste PC/Res
          for j := 0 to p.PCs[i].SubBacias-1 do
            begin
            s2 := s + '.' + p.PCs[i].SubBacia[j].Nome;
            if p.PCs[i].SubBacia[j].MostrarDialogo(s2) = mrCancel then Exit;
            end;
{
          // Para as derivações
          if TPC(p.PCs[i]).Derivacao <> nil then
             begin
             s2 := s + '.' + TPC(p.PCs[i]).Derivacao.Nome;
             if Tiphs1_PC(p.PCs[i]).Derivacao.MostrarDialogo(s2) = mrCancel then Exit;
             end;
}
          end;
     end;
end;

procedure TPrincipal.ShowMessage(const aMessage: String);
begin
  if aMessage <> '' then
     Mensagem.Text := aMessage
  else
     Mensagem.Clear;
end;

procedure TPrincipal.Menu_Projeto_Zoom100Click(Sender: TObject);
begin
  ProjetoAtivo.Map.Extent := ProjetoAtivo.Map.FullExtent;
end;

procedure TPrincipal.MenuProjeto_AddLayerClick(Sender: TObject);
begin
  if not DirectoryExists(ProjetoAtivo.Projeto.DirTrab) then
     raise Exception.Create('Diretório de Trabalho Inválido');
     
  OpenLayer.InitialDir := ProjetoAtivo.Projeto.DirTrab;
  if OpenLayer.Execute then
     ProjetoAtivo.Projeto.AddLayer(ExtractFileName(OpenLayer.FileName));
end;

end.


