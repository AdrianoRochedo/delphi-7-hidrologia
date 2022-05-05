unit pr_Form_AreaDeProjeto_Base;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     ActnList, Menus, ExtCtrls, FileCtrl,
     MSXML4,
     XML_Utils,
     pr_Application,
     pr_Classes,
     pr_Const,
     pr_Tipos,
     pr_Vars,
     pr_Dialogo_Projeto,
     pr_Monitor, StdCtrls, ComCtrls;

type
  // Comunicação extra com outros objetos
  // ID: Identificação da Mensagem
  // Objeto: Objeto que está enviando a mensagem
  TEvento_Mensagem = procedure (const ID: String; Objeto: TObject) of Object;

  // Obtem o Status de um botão, isto é, se ele está precionado ou não
  TEvento_StatusDoBotao = function (const NomeBotao: String): boolean of Object;

  // Notificação de acontecimento
  TEvento_Aviso = procedure (const Aviso: String) of Object;

  TfoAreaDeProjeto_Base = class(TForm)
    SaveDialog: TSaveDialog;
    mmMensagemInicial: TMemo;
    StatusBar: TStatusBar;
    Progresso: TProgressBar;
    ObjectMenu: TPopupMenu;
    procedure Mouse_Click(Sender: TObject);
    procedure Mouse_DuploClick(Sender: TObject);
    procedure Mouse_Down(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Mouse_Move(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Mouse_Up(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Form_Activate(Sender: TObject);
    procedure Form_CloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Form_KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Form_Close(Sender: TObject; var Action: TCloseAction);
  private
    FProjeto: TprProjetoOtimizavel;
    FObjSel: THidroComponente;

    FMonitor: TDLG_Monitor;
    FMT: Boolean;
    FMD: Boolean;
    FTN: TStrings;
    FBloqueado: Boolean;
    FPerguntar_TemCerteza: Boolean;
    FFechando: Boolean;
    FSB: TprSubBacia;
    FPC: TprPC;

    // Acoes dinamicas dos menus dos plugins
    FAcoes: TActionList;
    FMF: Boolean;

    function CriarMenu(Acao: TBasicAction): TMenuItem;
    function CriarItemDeMenu(Raiz: TMenuItem; Texto: String; Evento: TNotifyEvent = nil): TMenuItem; overload;
    function CriarItemDeMenu(Raiz: TMenuItem; Acao: TBasicAction): TMenuItem; overload;
    function CriarSubMenus(Raiz: TMenuItem; Acao: TBasicAction; CriarItem: boolean): TMenuItem;

    procedure NaoImplementado(const Item: string);
    procedure SetObjSel(const Value: THidroComponente);
    procedure SetMD(const Value: Boolean);
    function ObterObjetoAssociado(Sender: TObject): THidroComponente;
    function ValidateDemand(Obj2: THidroComponente): boolean;
  protected
    // Eventos
    FOnShowMessage     : TEvento_Aviso;
    FOnMessage         : TEvento_Mensagem;
    FOnGetButtonStatus : TEvento_StatusDoBotao;

    // Utilizado na movimentacao dos componentes
    FArrastando: Boolean;
    FPosAnterior: TPoint;
    FDeslocamento: TPoint;

    // Semáforo de atualização de tela
    sem_AtualizarTela: Boolean;

    // Indica quando o objeto esta em processo de leitura
    FLendo: Boolean;

    // Remove os componentes criados manualmente para que o formulario
    // nao os destrua automaticamente.
    // ATENCAO: Deverá ser chamedo em alguns casos pelos descendentes
    procedure RemoverComponentesVisuais(); // nao virtual

    // Mostra um menu com os eventos exportados pelo objeto
    procedure MostrarMenu(Obj: THidroComponente); // nao virtual

    // Desenha o deslocamento do componente quando este esta sendo arrastado
    procedure DesenharDeslocamentoDoComponente(Sender: TObject); // nao virtual

    // Gerencia as regras de conecção dos objetos
    function ObjetoPodeSerConectadoEm(const ID: String; Objeto: THidroComponente): Boolean;

    // Seleciona um objeto
    procedure SelecionarObjeto(Sender: TObject);

    // Verifica se um frame pode ser desenhado ao redor do objeto
    function DesenharFrame(Obj: TObject): boolean;

    // Tem a funcao de criar a instancia correta que representa o Projeto
    function CriarProjeto(TN: TStrings): TprProjetoOtimizavel; virtual;

    // Retorna a classe do componente que representa a area de desenho
    function ClasseDaAreaDeDesenho(): TClass; virtual;

    // Retorna a area de desenho real
    function AreaDeDesenho(): TCanvas; virtual;

    // Desenha a representacao de um objeto selecionado
    procedure DesenharSelecao(Selecionar: Boolean); virtual;

    // Responsavel pelo desenho da rede na janela
    procedure DesenharRede(); virtual;

    // Responsavel pelo desenho de fundo
    procedure DesenharFundoDeTela(); virtual;

    // Disparado antes do salvamento das informacoes
    procedure BeginSave(); virtual;

    // Disparado apos o salvamento das informacoes
    procedure EndSave(); virtual;

    // Recebe eventos de Click
    procedure ExecutarClick(Sender: TObject; Pos: TMapPoint; Obj: THidroComponente); virtual;

    // Recebe eventos de Duplo-Click
    procedure ExecutarDuploClick(Sender: TObject; Pos: TPoint); virtual;

    // Recebe eventos de precionamento do botão do mouse
    procedure ExecutarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;

    // Recebe eventos de movimentacao do mouse
    procedure ExecutarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer); virtual;

    // Recebe eventos de liberacao do botao do mouse
    procedure ExecutarMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
  public
    constructor Create();
    destructor Destroy(); override;

    // Realiza uma atualizacao na tela
    procedure Atualizar(); virtual;

    // Retorna o controle que representa a area de desenho, ou seja, o
    // componente que contem os componentes hidrologicos.
    function ControleDaAreaDeDesenho(): TWinControl; virtual;

    // Metodos para gravacao e leitura de dados em XML
    procedure toXML(); virtual;
    procedure fromXML(no: IXMLDomNode); virtual;

    // Responde por eventos de progresso de uma simulacao
    procedure TratarProgressoDaSimulacao();

    // Bloqueia ou desbloqueia o desenho da rede
    procedure BloquearDesenhoDaRede(Bloquear: Boolean);

    // Remove um objeto da rede
    procedure RemoverObjeto(Obj: THidroComponente);

    // Salva o Projeto
    procedure Salvar();

    // Converte um PC para Reservatorio
    procedure PC_To_RES(PC: TprPCP);

    // Converte um Reservatorio para PC
    procedure RES_To_PC(RES: TprPCPR);

    // Representa o projeto ativo
    property Projeto : TprProjetoOtimizavel read FProjeto;

    // Usado para certificar que cada onjeto possua um nome unico
    property TabelaDeNomes : TStrings read FTN;

    // Representa o objeto atualmente selecionado retornando nil se nenhum esta.
    property ObjetoSelecionado : THidroComponente read FObjSel write SetObjSel;

    // Monitorador de propriedades do projeto
    property Monitor : TDLG_Monitor read FMonitor;

    // Mostra ou nao a imagem de fundo
    // Não vale para todos os descendentes
    property MostrarFundo : Boolean read FMF write FMF;

    // Mostra ou nao os trechos-daguas
    property MostrarTrechos : Boolean read FMT write FMT;

    // Mostra ou nao as demandas
    property MostrarDemandas : Boolean read FMD write SetMD;

    // Bloqueia ou Libera a movimentacao de objetos na rede
    property Bloqueado : Boolean read FBloqueado write FBloqueado;

    property Perguntar_TemCerteza: Boolean read FPerguntar_TemCerteza
                                          write FPerguntar_TemCerteza;

    // Eventos
    property Evento_Mensagem      : TEvento_Mensagem      read FOnMessage         write FOnMessage;
    property Evento_StatusDoBotao : TEvento_StatusDoBotao read FOnGetButtonStatus write FOnGetButtonStatus;
    property Evento_Aviso         : TEvento_Aviso         read FOnShowMessage     write FOnShowMessage;
  end;

implementation
uses WinUtils, GraphicUtils, Rochedo.Simulators.Shapes, MessageManager,
     Plugin,
     SysUtilsEx,
     pr_Funcoes,
     pr_Util,
     MessagesForm,
     pr_Gerenciador;

{$R *.dfm}

{ TfoAreaDeProjeto_Base }

constructor TfoAreaDeProjeto_Base.Create();
begin
  FTN := TStringList.Create;
  TStringList(FTN).Sorted := true;

  FProjeto := CriarProjeto(FTN);
  FProjeto.AreaDeProjeto := Self;

  FMonitor := TDLG_Monitor.Create(Self);
  FMonitor.Projeto := FProjeto;

  // A chamada de "create" do ancestral gera varios eventos, ainda mais porque
  // esta janela eh uma "MDIChild", e nestes eventos sao acessados algumas
  // propriedades tais como "Projeto" e por isso temos que criar estes objetos
  // antes.
  inherited Create(nil);

  Caption  := ' SEM NOME';
  FMT := True;

  FPerguntar_TemCerteza := True;
  sem_AtualizarTela     := True;
end;

destructor TfoAreaDeProjeto_Base.Destroy();
begin
  //Applic.WriteStatus([''], False);
  FMonitor.Free();
  FProjeto.Free();
  FTN.Free();
  FAcoes.Free();
  inherited Destroy();
end;

// private
procedure TfoAreaDeProjeto_Base.NaoImplementado(const Item: string);
begin
  raise Exception.Create('O método ' + Item + ' não foi implementado em ' + ClassName);
end;

// virtual
function TfoAreaDeProjeto_Base.CriarProjeto(TN: TStrings): TprProjetoOtimizavel;
begin
  NaoImplementado('CriarProjeto()');
end;

// public
procedure TfoAreaDeProjeto_Base.RemoverObjeto(Obj: THidroComponente);
begin
  if (Obj <> nil) and
     (FProjeto.Simulador = nil) and
     (MessageDLG('Confirma a remoção do objeto ?', mtConfirmation, [mbYES, mbNO], 0) = mrYES) then
     begin
     SetObjSel(nil);
     if Obj is TprPCP then
        if FProjeto.PCs.Remover(TprPCP(Obj)) then
           Gerenciador.ReconstroiArvore()
        else
           Exit
     else
        begin
        Gerenciador.RemoverObjeto(Obj);
        Obj.Free();
        end;

     Atualizar();
     FProjeto.Modificado := True;
     end;
end;

// private
procedure TfoAreaDeProjeto_Base.SetObjSel(const Value: THidroComponente);
const S1 = 'Objeto selecionado: ';
var s: String;
begin
  DesenharSelecao(False);

  FObjSel := Value;
  Gerenciador.SelecionarObjeto(Value);

  if Value = nil then
     s := ' Obj: '
  else
     begin
     if Assigned(FOnMessage) then FOnMessage('Descrever Objeto', Value);
     s := ' Obj: ' + Value.Nome;
     end;

  WinUtils.WriteStatus(StatusBar, [s], false);

  if Assigned(FOnMessage) then
     FOnMessage('Atualizar Opcoes', Value);

  DesenharSelecao(True);
end;

// virtual
procedure TfoAreaDeProjeto_Base.DesenharSelecao(Selecionar: Boolean);
begin
  NaoImplementado('DesenharSelecao()');
end;

// public
procedure TfoAreaDeProjeto_Base.PC_To_RES(PC: TprPCP);
var R: TprPCPR;
begin
  Gerenciador.RemoverObjeto(PC);
  R := PC.MudarParaReservatorio();
  Gerenciador.AdicionarObjeto(R);

  SetObjSel(nil);

  PC.AvisarQueVaiSeDestruir := False;
  FProjeto.PCs[FProjeto.PCs.IndiceDo(PC)] := R;
  PC.Free();

  SetObjSel(R);

  Atualizar();

  // Notifica possível mudança de status
  if Assigned(FOnMessage) then
     FOnMessage('Atualizar Opcoes', FObjSel);

  FProjeto.Modificado := True;
end;

// public
procedure TfoAreaDeProjeto_Base.RES_To_PC(RES: TprPCPR);
var PC: TprPCP;
begin
  Gerenciador.RemoverObjeto(RES);
  PC := RES.MudarParaPC();
  Gerenciador.AdicionarObjeto(PC);

  SetObjSel(nil);

  RES.AvisarQueVaiSeDestruir := False;
  FProjeto.PCs[FProjeto.PCs.IndiceDo(RES)] := PC;
  RES.Free;

  SetObjSel(PC);

  Atualizar();

    // Notifica possível mudança de status
  if Assigned(FOnMessage) then
     FOnMessage('Atualizar Opcoes', FObjSel);

  FProjeto.Modificado := True;
end;

// virtual
procedure TfoAreaDeProjeto_Base.DesenharRede();
begin
  NaoImplementado('DesenharRede()');
end;

procedure TfoAreaDeProjeto_Base.Salvar();
begin
  SaveDialog.InitialDir := Applic.LastDir;

  if FProjeto.NomeArquivo <> '' then
     begin
     if ExtractFileExt(FProjeto.NomeArquivo) = '.prg' then
        FProjeto.NomeArquivo := changeFileExt(FProjeto.NomeArquivo, '.propagar');

     FProjeto.SaveToXML(FProjeto.NomeArquivo);
     end
  else
    if SaveDialog.Execute() then
       begin
       Applic.LastDir := ExtractFilePath(SaveDialog.FileName);
       FProjeto.SaveToXML(SaveDialog.FileName);
       end;
end;

// virtual
procedure TfoAreaDeProjeto_Base.BeginSave();
begin
  // opcional
end;

// virtual
procedure TfoAreaDeProjeto_Base.EndSave();
begin
  Caption := ' ' + FProjeto.NomeArquivo;
end;

// public
procedure TfoAreaDeProjeto_Base.fromXML(no: IXMLDomNode);
begin
  FBloqueado  := strToBoolean(FProjeto.NextChild(no).text);
  FMD         := strToBoolean(FProjeto.NextChild(no).text);
  FMF         := strToBoolean(FProjeto.NextChild(no).text);
  FMT         := strToBoolean(FProjeto.NextChild(no).text);

  // Ignora o próximo nó: WindowState
  FProjeto.NextChild(no);

  Caption := FProjeto.NomeArquivo;
end;

// public
procedure TfoAreaDeProjeto_Base.toXML();
var x: TXML_Writer;
begin
  beginSave();
  x := Applic.getXMLWriter();

  x.Write('Locked', FBloqueado);
  x.Write('ViewDemands', FMD);
  x.Write('ViewBackground', FMF);
  x.Write('ViewWaterCourses', FMT);
  x.Write('WindowState', ord(WindowState));

  endSave();
end;

procedure TfoAreaDeProjeto_Base.SetMD(const Value: Boolean);
var i: Integer;
begin
  FMD := Value;
  for i := 0 to FProjeto.PCs.PCs-1 do
    TprPCP(FProjeto.PCs[i]).MostrarDemandas := FMD;

  Atualizar();
end;

// Virtual publico
procedure TfoAreaDeProjeto_Base.Atualizar();
begin
  NaoImplementado('Atualizar()');
  // Map.Refresh;
end;

// nao virtual protegido
procedure TfoAreaDeProjeto_Base.SelecionarObjeto(Sender: TObject);
var p, c: TPoint;
    TD: TprTrechoDagua;
    i: Integer;
begin
  if Sender = nil then
     SetObjSel(nil)
  else
     if FOnGetButtonStatus('Selecionar') or
        FOnGetButtonStatus('Arrastar') then
        if Sender = ControleDaAreaDeDesenho() then
           begin
           // Pode ser um trecho-dágua
           p := ControleDaAreaDeDesenho.ScreenToClient(Mouse.CursorPos);
           for i := 0 to Projeto.PCs.PCs - 1 do
             if FProjeto.PCs[i].TrechoDagua <> nil then
                begin
                TD := FProjeto.PCs[i].TrechoDagua;
                c  := CentroDaReta(TD.PC_aMontante.ScreenPos, TD.PC_aJusante.ScreenPos);
                if DistanciaEntre2Pontos(p, c) < 05 {Pixels} then
                   begin
                   SelecionarObjeto(TD);
                   Exit;
                   end;
                end;

           // Senão é a própria janela
           SetObjSel(FProjeto);
           end
        else
           SetObjSel(ObterObjetoAssociado(Sender));
end;

function TfoAreaDeProjeto_Base.ObjetoPodeSerConectadoEm(const ID: String; Objeto: THidroComponente): Boolean;
begin
  {TODO 1 -cProgramacao: Descarga: ObjetoPodeSerConectadoEm}
  Result := ((ID = 'Sub-Bacia') and (Objeto is TprPCP)) or
            ((ID = 'QA') and (Objeto is TprPCP) and (TprPCP(Objeto).QualidadeDaAgua = nil)) or
            ((ID = 'Descarga') and (Objeto is TprPCP)) or
            ((ID = 'Demanda') and (Objeto is TprPCP)) or
            ((ID = 'Demanda') and (Objeto is TprSubBacia));
end;

// Virtual
procedure TfoAreaDeProjeto_Base.ExecutarClick(Sender: TObject; Pos: TMapPoint; Obj: THidroComponente);
var Obj2: THidroComponente;
begin
  if not Assigned(FOnGetButtonStatus) then
     raise Exception.Create('Evento Obter Status não Associado');

  if FOnGetButtonStatus('Conectar SB em PC') then
     FSB := nil;

  //---------------- Clicks na Janela -------------------------------------------------

  if FProjeto.Simulador <> nil then
     Exit
  else

  if FOnGetButtonStatus('Criar PC') or
     FOnGetButtonStatus('Criar Reservatorio') then
     begin
     {$ifdef VERSAO_LIMITADA}
     if FProjeto.PCs.PCs >= 10 then
        begin
        Applic.ShowLightMessage('Somente 5 PCs são permitidos');
        Exit;
        end;
     {$endif}
     if FOnGetButtonStatus('Criar PC') then
        Obj := Projeto.CriarObjeto('PC', Pos)
     else
        Obj := Projeto.CriarObjeto('Reservatorio', Pos);

     FProjeto.PCs.Adicionar(TprPCP(Obj));
     Gerenciador.AdicionarObjeto(Obj);

     WinUtils.WriteStatus(StatusBar, ['PC criado: ' + Obj.Nome], false);
     FProjeto.Modificado := True;
     end
  else

//-------------------- Click em uma Demanda -------------------------------------------

  if FOnGetButtonStatus('Criar Cenario de Demanda') and (Obj is TprDemanda) then
     begin
     {
     if (TprDemanda(Obj).NumCenarios = 1) then
        raise Exception.Create('A demanda já possui um cenário');
     }
     sem_AtualizarTela := False;
     Obj2 := FProjeto.CriarObjeto('Cenario de Demanda', Obj.Pos);
     Obj.ConectarObjeto(Obj2);
     Gerenciador.AdicionarObjeto(Obj2);
     WinUtils.WriteStatus(StatusBar, ['Nome do Cenário criado: ' + Obj2.Nome], false);
     FProjeto.Modificado := True;
     sem_AtualizarTela := True;
     Atualizar();
     end else

//---------------- Clicks em um PC de Controle -----------------------------------

  if FOnGetButtonStatus('Criar SB') and (Obj is TprPCP) then
     begin
     Obj2 := Obj;
     if ObjetoPodeSerConectadoEm('Sub-Bacia', Obj2) then
        begin
       {$ifdef VERSAO_LIMITADA}
       if TprPCP(Obj).SubBacias >= 1 then
          begin
          Applic.ShowLightMessage('Somente uma Sub-Bacia por PC é permitido');
          Exit;
          end;
       {$endif}
        Obj := FProjeto.CriarObjeto('Sub-Bacia', Obj2.Pos);
        Obj2.ConectarObjeto(Obj);
        Gerenciador.AdicionarObjeto(Obj);
        WinUtils.WriteStatus(StatusBar, ['Sub-Bacia criada: ' + Obj.Nome], false);
        FProjeto.Modificado := True;
        Atualizar();
        end;
     end
  else

  if FOnGetButtonStatus('Criar Descarga') and (Obj is TprPCP) then
     begin
     Obj2 := Obj;
     if ObjetoPodeSerConectadoEm('Descarga', Obj2) then
        begin
(*
       {$ifdef VERSAO_LIMITADA}
       if TprPCP(Obj).Descargass >= 1 then
          begin
          Applic.ShowLightMessage('Somente uma Descarga por PC é permitida');
          Exit;
          end;
       {$endif}
*)
        Obj := FProjeto.CriarObjeto('Descarga', Obj2.Pos);
        Obj2.ConectarObjeto(Obj);
        Gerenciador.AdicionarObjeto(Obj);
        WinUtils.WriteStatus(StatusBar, ['Descarga criada: ' + Obj.Nome], false);
        FProjeto.Modificado := True;
        Atualizar();
        end;
     end
  else

  if FOnGetButtonStatus('Criar QA') and (Obj is TprPC) then
     begin
     Obj2 := Obj;
     if ObjetoPodeSerConectadoEm('QA', Obj2) then
        begin
        Obj := FProjeto.CriarObjeto('QA', Obj2.Pos);
        Obj2.ConectarObjeto(Obj);
        Gerenciador.AdicionarObjeto(Obj);
        WinUtils.WriteStatus(StatusBar, ['Qualidade da Água criada: ' + Obj.Nome], false);
        FProjeto.Modificado := True;
        Atualizar();
        end;
     end
  else

  if FOnGetButtonStatus('Criar Demanda') and
     ((Obj is TprPCP) or (Obj is TprSubBacia)) then
     begin
     if ObjetoPodeSerConectadoEm('Demanda', Obj) then
        begin
       {$ifdef VERSAO_LIMITADA}
       if (Obj is TprPCP) then
          begin
          if TprPCP(Obj).Demandas >= 3 then
             begin
             Applic.ShowLightMessage('Somente 3 demandas por PC são permitidas');
             Exit;
             end;
          end
       else
          if TprSubBacia(Obj).Demandas >= 2 then
             begin
             Applic.ShowLightMessage('Somente 2 demandas por Sub-Bacia são permitidas');
             Exit;
             end;
       {$endif}

        Obj2 := FProjeto.CriarObjeto('Demanda', Obj.Pos);

        if ValidateDemand(Obj2) then
           begin
           // A associação com a classe de demanda é feita pelo gerenciador
           Gerenciador.AdicionarObjeto(Obj2);

           // Conecta a demanda ao PC ou a sub-Bacia
           Obj.ConectarObjeto(Obj2);

           // Verifica a opcao de visibilidade
           if Obj is TprPCP then
              TprDemanda(Obj2).Visivel := TprPCP(Obj).MostrarDemandas;

           WinUtils.WriteStatus(StatusBar, ['Demanda criada: ' + Obj2.Nome], false);
           FProjeto.Modificado := True;
           Atualizar();
           end;
        end;
     end
  else

  if FOnGetButtonStatus('Conectar SB em PC') then
     begin
     if Obj is TprSubBacia then FSB := TprSubBacia(Obj);
     if (Obj is TprPCP) and (FSB <> nil) then
        begin
        FProjeto.Modificado := True;
        TprPCP(Obj).ConectarObjeto(FSB);
        Atualizar();
        FSB := nil;
        end;
     end
  else

  if FOnGetButtonStatus('Criar TD') and (Obj is TprPCP) then
     begin
     if FPC = nil then
        begin
        FPC := TprPCP(Obj);

        // verifica se o PC não possui conecção a frente
        if FPC.PC_aJusante = nil then
           begin
           WinUtils.WriteStatus(StatusBar, [Format(cMsgStatus02, [FPC.Nome]), cMsgStatus03], false);
           if Assigned(FOnShowMessage) then FOnShowMessage(cMsgAjuda04);
           end
        else
           begin
           FPC := nil;
           WinUtils.WriteStatus(StatusBar, ['Erro: ' + cMsgErro05], false);
           end;
        end
     else
        if Obj <> FPC then
           if not FPC.Eh_umPC_aMontante(Obj) then
              begin
              if Assigned(FOnShowMessage) then FOnShowMessage('Novamente.'#13 + cMsgAjuda01);
              WinUtils.WriteStatus(StatusBar, [Format(cMsgStatus01, [FPC.Nome, Obj.Nome])], false);
              FPC.ConectarObjeto(Obj);
              Gerenciador.AdicionarObjeto(FPC.TrechoDagua);
              FPC := nil;
              FProjeto.PCs.CalcularHierarquia();
              FProjeto.Modificado := True;
              Atualizar();
              end
           else
              begin
              FPC := nil;
              if Assigned(FOnShowMessage) then
                 FOnShowMessage(Format(cMsgErro06, [Obj.Nome, FPC.Nome]));
              end;
     end
  else

  if FOnGetButtonStatus('Inserir PC') and (Obj is TprPCP) then
     begin
     if (FPC = nil) then
        begin
        FPC := TprPCP(Obj);
        if FPC.TrechoDagua <> nil then
           begin
           if Assigned(FOnShowMessage) then FOnShowMessage(cMsgAjuda06);
           WinUtils.WriteStatus(StatusBar, [Format(cMsgStatus04, [FPC.Nome]), cMsgStatus05], false);
           end
        else
           begin
           WinUtils.WriteStatus(StatusBar, [Format(cMsgErro02, [FPC.Nome])], true);
           FPC := nil;
           end;
        end
     else
        if Obj = FPC.PC_aJusante then
           begin
           if Assigned(FOnShowMessage) then FOnShowMessage('');
           WinUtils.WriteStatus(StatusBar, [Format(cMsgStatus06, [FPC.Nome, Obj.Nome])], false);

           Gerenciador.RemoverObjeto(FPC.TrechoDagua);
           FPC.RemoverTrecho();

           Pos.X := (FPC.Pos.x + Obj.Pos.x) / 2;
           Pos.Y := (FPC.Pos.y + Obj.Pos.y) / 2;

           Obj2 := Projeto.CriarObjeto('PC', Pos);
           Projeto.PCs.Adicionar(TprPC(Obj2));
           Gerenciador.AdicionarObjeto(Obj);
           FPC.ConectarObjeto(Obj2);
           Obj2.ConectarObjeto(Obj);

           FProjeto.PCs.CalcularHierarquia();
           FPC := nil;
           FProjeto.Modificado := True;
           Atualizar();
           end
        else
           WinUtils.WriteStatus(StatusBar,
              [Format(cMsgStatus04, [FPC.Nome]),
               Format(cMsgErro01, [Obj.Nome, FPC.Nome])], true);
     end;
end;

// Virtual publico
function TfoAreaDeProjeto_Base.ControleDaAreaDeDesenho(): TWinControl;
begin
  NaoImplementado('ControleDaAreaDeDesenho()');
end;

// Virtual
function TfoAreaDeProjeto_Base.AreaDeDesenho(): TCanvas;
begin
  NaoImplementado('AreaDeDesenho()');
end;

procedure TfoAreaDeProjeto_Base.Mouse_Click(Sender: TObject);
var p: TPoint;
begin
  if mmMensagemInicial <> nil then
     begin
     self.RemoveControl(mmMensagemInicial);
     mmMensagemInicial := nil;
     end;

  p := ControleDaAreaDeDesenho.ScreenToClient(Mouse.CursorPos);
  ExecutarClick(Sender, FProjeto.PointToMapPoint(p), ObterObjetoAssociado(Sender));
end;

// Virtual
procedure TfoAreaDeProjeto_Base.ExecutarDuploClick(Sender: TObject; Pos: TPoint);
begin
  NaoImplementado('ExecutarDuploClick()');
end;

procedure TfoAreaDeProjeto_Base.Mouse_DuploClick(Sender: TObject);
var p: TPoint;
begin
  if FProjeto.Simulador = nil then
     begin
     p := ControleDaAreaDeDesenho.ScreenToClient(Mouse.CursorPos);
     ExecutarDuploClick(Sender, p);
     end;
end;

// Virtual
procedure TfoAreaDeProjeto_Base.ExecutarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  NaoImplementado('ExecutarMouseDown()');
end;

procedure TfoAreaDeProjeto_Base.Mouse_Down(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ExecutarMouseDown(Sender, Button, Shift, X, Y);
end;

// Nao virtual protegido
procedure TfoAreaDeProjeto_Base.DesenharDeslocamentoDoComponente(Sender: TObject);
var p: TPoint;
    c: TControl;
begin
  c := TControl(Sender);
  p := ControleDaAreaDeDesenho.ScreenToClient(Mouse.CursorPos);
  AreaDeDesenho.Rectangle(FPosAnterior.x,
                          FPosAnterior.y,
                          FPosAnterior.x + c.Width,
                          FPosAnterior.y + c.Height);

  dec(p.x, FDeslocamento.x);
  dec(p.y, FDeslocamento.y);
  if p.x < 2 then p.x := 2;
  if p.y < 2 then p.y := 2;

  FPosAnterior := p;
  AreaDeDesenho.Rectangle(FPosAnterior.x,
                          FPosAnterior.y,
                          FPosAnterior.x + c.Width,
                          FPosAnterior.y + c.Height);
end;

// virtual
procedure TfoAreaDeProjeto_Base.ExecutarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  NaoImplementado('ExecutarMouseMove()');
end;

procedure TfoAreaDeProjeto_Base.Mouse_Move(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ExecutarMouseMove(Sender, Shift, X, Y);
end;

// Virtual
procedure TfoAreaDeProjeto_Base.ExecutarMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  NaoImplementado('ExecutarMouseUp()');
end;

procedure TfoAreaDeProjeto_Base.Mouse_Up(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ExecutarMouseUp(Sender, Button, Shift, X, Y);
end;

// virtual
procedure TfoAreaDeProjeto_Base.DesenharFundoDeTela();
begin
  NaoImplementado('DesenharFundoDeTela()');
end;

// privado
function TfoAreaDeProjeto_Base.ObterObjetoAssociado(Sender: TObject): THidroComponente;
begin
  Result := nil;
  if (Sender is TdrBaseShape) or (Sender is TImage) then
     Result := THidroComponente(TComponent(Sender).Tag)
  else
     if Sender is TprTrechoDagua then
        Result := TprTrechoDagua(Sender);
end;

procedure TfoAreaDeProjeto_Base.Form_Activate(Sender: TObject);
begin
  if not FFechando then
     begin
     if Assigned(FOnMessage) then FOnMessage('Selecionar Botao Sel/Info', self);
     Applic.SetGlobalStatus( FProjeto.RealizarDiagnostico() );
     Gerenciador.AreaDeProjeto := Self;
     end;
end;

procedure TfoAreaDeProjeto_Base.Form_CloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := MessageDLG(Format('Fechar o projeto <%s> ?', [FProjeto.Nome]),
    mtConfirmation, [mbYes, mbNo], 0) = mrYes;

  if CanClose Then
     begin
     FFechando := True;
     if FProjeto.Modificado and
        (MessageDLG(Format('Salvar as modificações do projeto "%s"?', [FProjeto.Nome]),
        mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
        Salvar();
     end;
end;

// publico
procedure TfoAreaDeProjeto_Base.TratarProgressoDaSimulacao();
var D: TRec_prData;
begin
  if FProjeto.Intervalo <= FProjeto.Total_IntSim then
     begin
     Progresso.Position := FProjeto.Intervalo;
     D := FProjeto.IntervaloParaData(FProjeto.Intervalo);

     if Projeto.Status = sOtimizando then
        Caption := Format(' %d Simulação %2d/%4d (%d) ...',
                   [Projeto.IndiceSimulacao, D.Mes, D.Ano, FProjeto.Intervalo])
     else
        Caption := Format(' Simulando %2d/%4d (%d) ...',
                   [D.Mes, D.Ano, FProjeto.Intervalo]);
     end;              
end;

procedure TfoAreaDeProjeto_Base.Form_KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
     RemoverObjeto(FObjSel);
end;

function TfoAreaDeProjeto_Base.CriarItemDeMenu(Raiz: TMenuItem; Texto: String; Evento: TNotifyEvent): TMenuItem;
begin
  Result := TMenuItem.Create(nil);
  Result.AutoHotkeys := maManual;
  Result.Caption := Texto;
  Result.OnClick := Evento;
  Raiz.Add(Result);
end;

function TfoAreaDeProjeto_Base.CriarItemDeMenu(Raiz: TMenuItem; Acao: TBasicAction): TMenuItem;
begin
  Result := CriarMenu(Acao);
  Raiz.Add(Result);
end;

function TfoAreaDeProjeto_Base.CriarMenu(Acao: TBasicAction): TMenuItem;
begin
  Result := TMenuItem.Create(nil);
  Result.AutoHotkeys := maManual;
  Result.Caption := TAction(Acao).Caption;
  Result.OnClick := TAction(Acao).OnExecute;
  Result.Tag := TAction(Acao).Tag;
  Result.Checked := TAction(Acao).Checked;
end;

function TfoAreaDeProjeto_Base.CriarSubMenus(Raiz: TMenuItem; Acao: TBasicAction; CriarItem: boolean): TMenuItem;
var i: Integer;
begin
  if CriarItem then
     begin
     Result := CriarMenu(Acao);
     Raiz.Add(Result);
     end
  else
     Result := Raiz;

  for i := 0 to Acao.ComponentCount-1 do
    CriarSubMenus(Result, TAction(Acao.Components[i]), true)
end;

procedure TfoAreaDeProjeto_Base.BloquearDesenhoDaRede(Bloquear: Boolean);
begin
  FLendo := Bloquear;
end;

procedure TfoAreaDeProjeto_Base.Form_Close(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

function TfoAreaDeProjeto_Base.ClasseDaAreaDeDesenho(): TClass;
begin
  NaoImplementado('ClasseDaAreaDeDesenho()');
end;

function TfoAreaDeProjeto_Base.ValidateDemand(Obj2: THidroComponente): boolean;
var d: TprDemanda;
begin
  d := TprDemanda(Obj2);
  d.Copiar(Gerenciador.CD_Selecionada, true, nil);

  gErros.Clear();
  gErros.Add(etInformation, 'Verifique os dados entrados na Classe de demanda.'#13 +
                            'Uma ou mais informações podem estar faltando.'#13 +
                            'A demanda ' + d.Nome + ' somente poderá ser criada se todos'#13 +
                            'os dados de sua classe estiverem corretos.');

  result := True;
  d.ValidarDados(result, gErros, True);
  if not result then
     begin
     d.Free();
     gErros.Show();
     end;
end;

procedure TfoAreaDeProjeto_Base.MostrarMenu(Obj: THidroComponente);
var Menu : TMenuItem;
     act : TContainedAction;
       i : Integer;
begin
  if Obj <> nil then
     begin
     ObjectMenu.Items.Clear();
     FAcoes.Free();
     FAcoes := TActionList.Create(nil);
     Obj.getActions(FAcoes);
     for i := 0 to FAcoes.ActionCount-1 do
       begin
       act := FAcoes[i];
       Menu := CriarItemDeMenu(ObjectMenu.Items, act);
       CriarSubMenus(Menu, act, false);
       end;
     ObjectMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
     end;
end;

// Remove sem destruir os componentes descendentes de "TdrBaseShape", isto
// eh, remove os componentes que representam os elementos hidrologicos, se
// estes componentes ficarem na tela, seu pai os destruirá automaticamente,
// gerando um erro quando estes forem destruidos pelos objetos hidrologicos.
procedure TfoAreaDeProjeto_Base.RemoverComponentesVisuais();
var i: Integer;
    c: TWinControl;
begin
  i := 0;
  c := ControleDaAreaDeDesenho();
  while i < c.ControlCount do
    begin
    if c.Controls[i] is TdrBaseShape then
       begin
       c.RemoveControl(c.Controls[i]);
       continue;
       end;
    inc(i);
    end;
end;

function TfoAreaDeProjeto_Base.DesenharFrame(Obj: TObject): boolean;
begin
  result := (Obj is TprPC) or
            (Obj is TprSubBacia) or
            (Obj is TprDemanda) or
            (Obj is TprDescarga) or
            (Obj is TprQualidadeDaAgua) or
            (Obj is TprCenarioDeDemanda);
end;

end.
