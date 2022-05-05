unit pr_AreaDeProjeto;

interface

uses Windows, Types, Classes, Graphics, Forms, Controls, ExtCtrls,
     StdCtrls, ComCtrls, Dialogs, Menus, OleCtrls, RAScrollMax, Buttons,
     MapObjects,
     MapObjectsEx,
     pr_Classes,
     pr_Const,
     pr_Tipos,
     pr_Monitor,
     pr_Dialogo_Projeto,
     Frame_moLayer;

type                                   
  // Comunicação extra com outros objetos
  // ID: Identificação da Mensagem
  // Objeto: Objeto que está enviando a mensagem
  TEvento_Mensagem = procedure (const ID: String; Objeto: TObject) of Object;

  // Obtem o Status de um botão, isto é, se ele está precionado ou não
  TEvento_StatusDoBotao = function (const NomeBotao: String): boolean of Object;

  // Notificação de acontecimento
  TEvento_Aviso = procedure (const Aviso: String) of Object;

  TprDialogo_AreaDeProjeto = class(TForm)
    btnTeste01: TButton;
    SaveDialog: TSaveDialog;
    Progresso: TProgressBar;
    Menu_SubBacias: TPopupMenu;
    Menu_SB_Editar: TMenuItem;
    Menu_PCP: TPopupMenu;
    Menu_PCP_Editar: TMenuItem;
    Menu_PCPR: TPopupMenu;
    MenuItem2: TMenuItem;
    Menu_Demanda: TPopupMenu;
    Menu_DM_Editar: TMenuItem;
    N1: TMenuItem;
    Menu_SB_GraficarVazoes: TMenuItem;
    Menu_SB_GraficoDeBarras: TMenuItem;
    Menu_SB_GraficoDeLinhas: TMenuItem;
    N2: TMenuItem;
    Menu_PCP_Graficos: TMenuItem;
    N3: TMenuItem;
    Menu_PCP_Falhas: TMenuItem;
    N4: TMenuItem;
    Menu_SB_Mostrar_Tudo: TMenuItem;
    N6: TMenuItem;
    Menu_PCPR_Graficos: TMenuItem;
    N8: TMenuItem;
    Menu_PCPR_Falhas: TMenuItem;
    Menu_SB_Mostrar: TMenuItem;
    Menu_SB_Mostrar_Matricial: TMenuItem;
    Menu_PCP_Mostrar_: TMenuItem;
    Menu_PCP_Mostrar_ASB: TMenuItem;
    Menu_PCP_Mostrar_Tudo: TMenuItem;
    Menu_PCP_Mostrar_Deflu: TMenuItem;
    Menu_PCP_Mostrar_VzMon: TMenuItem;
    Menu_PCP_Mostrar_DA_: TMenuItem;
    Menu_PCP_Mostrar_DA_S: TMenuItem;
    Menu_PCP_Mostrar_DA_P: TMenuItem;
    Menu_PCP_Mostrar_DP_: TMenuItem;
    Menu_PCP_Mostrar_DT_: TMenuItem;
    Menu_PCP_Mostrar_DA_T: TMenuItem;
    Menu_PCP_Mostrar_DP_P: TMenuItem;
    Menu_PCP_Mostrar_DP_S: TMenuItem;
    Menu_PCP_Mostrar_DP_T: TMenuItem;
    Menu_PCP_Mostrar_DT_P: TMenuItem;
    Menu_PCP_Mostrar_DT_S: TMenuItem;
    Menu_PCP_Mostrar_DT_T: TMenuItem;
    Menu_PCPR_Mostrar_: TMenuItem;
    Menu_PCPR_Mostrar_DT: TMenuItem;
    Menu_PCPR_Mostrar_DT_T: TMenuItem;
    Menu_PCPR_Mostrar_DT_S: TMenuItem;
    Menu_PCPR_Mostrar_DT_P: TMenuItem;
    Menu_PCPR_Mostrar_DP: TMenuItem;
    Menu_PCPR_Mostrar_DP_T: TMenuItem;
    Menu_PCPR_Mostrar_DP_S: TMenuItem;
    Menu_PCPR_Mostrar_DP_P: TMenuItem;
    Menu_PCPR_Mostrar_DA: TMenuItem;
    Menu_PCPR_Mostrar_DA_T: TMenuItem;
    Menu_PCPR_Mostrar_DA_S: TMenuItem;
    Menu_PCPR_Mostrar_DA_P: TMenuItem;
    Menu_PCPR_Mostrar_VzMon: TMenuItem;
    Menu_PCPR_Mostrar_Deflu: TMenuItem;
    Menu_PCPR_Mostrar_SB: TMenuItem;
    Menu_PCPR_Mostrar_Tudo: TMenuItem;
    Menu_PCPR_Mostrar_Vol: TMenuItem;
    Menu_PCP_MostrarDemandas: TMenuItem;
    Menu_PCPR_MostrarDemandas: TMenuItem;
    EnergiaGerada1: TMenuItem;
    EnergiaGerada2: TMenuItem;
    StatusBar: TStatusBar;
    Map: TMapEx;
    mmMensagemInicial: TMemo;
    paLayers: TPanel;
    Panel1: TPanel;
    btnUp: TSpeedButton;
    btnDown: TSpeedButton;
    btnDel: TSpeedButton;
    Layers: TRAScrollMax;
    Splitter: TSplitter;
    procedure Form_Close(Sender: TObject; var Action: TCloseAction);
    procedure Map_Click(Sender: TObject);
    procedure Map_Dbl_Click(Sender: TObject);
    procedure Map_MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Map_MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Map_MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Form_Create(Sender: TObject);
    procedure Form_Destroy(Sender: TObject);
    procedure Form_Activate(Sender: TObject);
    procedure btnTeste01_Click(Sender: TObject);
    procedure ExecFail(Sender: TObject);
    procedure Menu_EditarClick(Sender: TObject);
    procedure Menu_SB_GraficarVazoesComBarras_Click(Sender: TObject);
    procedure Menu_SB_GraficarVazoesComLinhas_Click(Sender: TObject);
    procedure Menu_PCP_FalhasClick(Sender: TObject);
    procedure Menu_MostrarTudo_Click(Sender: TObject);
    procedure Menu_TodosClick(Sender: TObject);
    procedure Menu_SB_Mostrar_MatricialClick(Sender: TObject);
    procedure Menu_PCP_Mostrar_ASBClick(Sender: TObject);
    procedure Menu_PCP_Mostrar_DefluClick(Sender: TObject);
    procedure Menu_PCP_Mostrar_VzMonClick(Sender: TObject);
    procedure Menu_PCP_Mostrar_DA_PClick(Sender: TObject);
    procedure Menu_PCP_Mostrar_DA_SClick(Sender: TObject);
    procedure Menu_PCP_Mostrar_DA_TClick(Sender: TObject);
    procedure Menu_PCP_Mostrar_DP_PClick(Sender: TObject);
    procedure Menu_PCP_Mostrar_DP_SClick(Sender: TObject);
    procedure Menu_PCP_Mostrar_DP_TClick(Sender: TObject);
    procedure Menu_PCP_Mostrar_DT_PClick(Sender: TObject);
    procedure Menu_PCP_Mostrar_DT_SClick(Sender: TObject);
    procedure Menu_PCP_Mostrar_DT_TClick(Sender: TObject);
    procedure Menu_PCP_Mostrar_EGClick(Sender: TObject);
    procedure Menu_PCPR_Mostrar_VolClick(Sender: TObject);
    procedure Form_CloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Menu_PCP_MostrarDemandasClick(Sender: TObject);
    procedure Form_KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MapAfterLayerDraw(ASender: TObject; index: Smallint; canceled: WordBool; hDC: Cardinal);
    procedure MapBeforeLayerDraw(ASender: TObject; index: Smallint; hDC: Cardinal);
    procedure Form_Resize(Sender: TObject);
    procedure Form_Show(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
  private
    FProjeto             : TprProjeto_Rosen;
    gOldPos              : TPoint;
    gDesloc              : TPoint;
    DesenhandoRio        : Boolean;
    FArrastando          : Boolean;
    Fpc1                 : TprPCP;
    FSB                  : TprSubBacia;
    FIni                 : TIF;      // Usado no armazenamento/recuperação de informações
    FObjSel              : THidroComponente;
    FTN                  : TStrings;
    FGO_NA               : TSetByte;
    SaveCaption          : TCaption;
    FPerguntar_TemCerteza: Boolean;
    FFechando            : Boolean;
    FBloqueado           : Boolean;
    FMT                  : Boolean;
    FMD                  : Boolean;   // Mostra ou não as demandas dos PCs
    FLendo               : Boolean;
    sem_AtualizarTela    : Boolean;   // Semáforo de atualização de tela

    FMonitor             : TDLG_Monitor;
    FActiveLayer         : TFrame_moLayer;

    // Canvas
    FMapCanvas           : TControlCanvas;
    FPenColor            : TColor;
    FBrushColor          : TColor;
    FPenMode             : TPenMode;
    FLockCanvas          : Integer;

    // Eventos
    FOnMessage           : TEvento_Mensagem;
    FOnGetButtonStatus   : TEvento_StatusDoBotao;
    FOnShowMessage       : TEvento_Aviso;

    {$IFDEF DEBUG}
    i_AtualizaTela       : Integer;
    {$ENDIF}

    procedure SaveCanvas;
    procedure RestoreCanvas;

    function  ObterObjetoAssociado(Sender: TObject): THidroComponente;
    procedure SetObjSel(const Value: THidroComponente);

    // Este método nào faz distinçao entre um THidroComponente ou um
    // componente gráfico, se ele verifica que existe um HidroComponente
    // associado a um componente gráfico então este HC é selecionado
    // através de "SetObjSel()"
    procedure SelecionarObjeto(sender: TObject);

    // Desenha o Frame no objeto selecionado
    procedure DesenharSelecao(Selecionar: Boolean);

    procedure setMD(const Value: Boolean);
    procedure setLendo(const Value: Boolean);

    // Controle dos painel "Layers"
    procedure Layer_Click(Sender: TObject);
    procedure UpdateLayerButtons();
  protected
    // Verifica se o objeto permite o desenho de um "frame" ao seu redor
    function DesenharFrame(obj: THidroComponente): boolean;

    // Desenha as linhas de conexão entre os objetos
    // Conecta PCs a PCs e PCs a SubBacias
    procedure ConectarObjetos; virtual;

    // Dispara um evento de click em um dos objetos, inclusive a própria Área De Projeto
    procedure ExecutarClick(Sender: TObject; p: ImoPoint; Obj: THidroComponente); virtual;

    // Gerencia as regras de conecção dos objetos
    function ObjetoPodeSerConectadoEm(const ID: String; Objeto: THidroComponente): Boolean; virtual;

    // Responsável por criar a instância correta do projeto
    function CriarProjeto(TN: TStrings): TprProjeto; virtual;
  public
    procedure AtualizacaoVisualDoUsuario;
    procedure AtualizacaoVisualDaSimulacao;

    procedure RemoverObjeto(Obj: THidroComponente);
    procedure DesenharRede;

    procedure Salvar;
    procedure SalvarEmArquivo(Ini: TIF);
    procedure LerDoArquivo(Ini: TIF);

    procedure PC_TO_RES(PC: TprPCP);
    procedure RES_TO_PC(RES: TprPCPR);

    procedure AddLayer(Layer: Tmoec_Layer);
    procedure InvertLayers();

    property  Perguntar_TemCerteza: Boolean
         read FPerguntar_TemCerteza
        write FPerguntar_TemCerteza;

    property  MostrarTrechos     : Boolean                read FMT          write FMT;
    property  MostrarDemandas    : Boolean                read FMD          write SetMD;

    property  Bloqueado          : Boolean                read FBloqueado   write FBloqueado;
    property  ObjetoSelecionado  : THidroComponente       read FObjSel      write SetObjSel;
    property  TabelaDeNomes      : TStrings               read FTN;
    property  GO_NosAbertos      : TSetByte               read FGO_NA       write FGO_NA;
    property  Projeto            : TprProjeto_Rosen       read FProjeto;
    property  Monitor            : TDLG_Monitor           read FMonitor;

    // Avisa que a área de projeto está em processo de leitura
    property  Lendo : Boolean read FLendo write setLendo;

    // Eventos
    property Evento_Mensagem      : TEvento_Mensagem      read FOnMessage         write FOnMessage;
    property Evento_StatusDoBotao : TEvento_StatusDoBotao read FOnGetButtonStatus write FOnGetButtonStatus;
    property Evento_Aviso         : TEvento_Aviso         read FOnShowMessage     write FOnShowMessage;
  end;

implementation
uses SysUtils, WinUtils, GraphicUtils, FileCtrl,
     Shapes,
     MessageManager,
     pr_Funcoes,
     pr_Util,
     pr_Vars,
     pr_Gerenciador,
     Form_moRecordSet;

{$R *.DFM}

procedure TprDialogo_AreaDeProjeto.SelecionarObjeto(Sender: TObject);
var Obj: THidroComponente;
    p, c: TPoint;
    TD: TprTrechoDagua;
    i: Integer;
begin
  if Sender = nil then
     SetObjSel(nil)
  else
     if FOnGetButtonStatus('Selecionar') or FOnGetButtonStatus('Arrastar') then
        if Sender is TMap then
           begin
           // Pode ser um trecho-dágua
           p := Map.ScreenToClient(Mouse.CursorPos);
           for i := 0 to Projeto.PCs.PCs - 1 do
             if Projeto.PCs[i].TrechoDagua <> nil then
                begin
                TD := Projeto.PCs[i].TrechoDagua;
                c  := CentroDaReta(TD.PC_aMontante.ScreenPos, TD.PC_aJusante.ScreenPos);
                if DistanciaEntre2Pontos(p, c) < 20 {Pixels} then
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

procedure TprDialogo_AreaDeProjeto.Form_Close(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  //getMessageManager.SendMessage(UM_LM_UPDATE_LAYER, [Map, nil]);
  Gerenciador.AreaDeProjeto := nil;
end;

procedure TprDialogo_AreaDeProjeto.Map_Click(Sender: TObject);
var p: TPoint;
begin
(*
  GetCursorPos(p);
  p := Map.ScreenToClient(p);
  Obj := ObterObjetoAssociado(Sender);

  if not foMain.sbSB_em_PC.Down then FSB := nil;

//---------------- Clicks na Janela -------------------------------------------------

  if foMain.sbArrastar.Down then
     SelecionarObjeto(Self)
  else

  if FProjeto.Simulador <> nil then
     Exit
  else

  if foMain.sbCriarPC.Down then
     begin
     sem_AtualizarTela := False;
     Obj := FProjeto.PCs.CriaPC(i, p, FProjeto, FTN, Menu_PCP);
     Gerenciador.AdicionarObjeto(Obj);
     WriteStatus(gSB, ['Nome do PC criado: ' + Obj.Nome]);
     FProjeto.Modificado := True;
     sem_AtualizarTela := True;
     end else

  if foMain.sbPCReservatorio.Down then
     begin
     sem_AtualizarTela := False;
     Obj := FProjeto.PCs.CriaReservatorio(i, p, FProjeto, FTN, Menu_PCPR);
     Gerenciador.AdicionarObjeto(Obj);
     WriteStatus(gSB, ['Nome do PC criado: ' + Obj.Nome]);
     FProjeto.Modificado := True;
     sem_AtualizarTela := True;
     end else

//---------------- Clicks em um PC de Controle -----------------------------------

  if foMain.sbCriarSubBacia.Down and (Obj is TprPCP) then
     begin
     sem_AtualizarTela := False;
     Obj := CriaSubBacia(p, FProjeto, Obj);
     Gerenciador.AdicionarObjeto(Obj);
     WriteStatus(gSB, ['Nome da Sub-Bacia criada: ' + Obj.Nome]);
     FProjeto.Modificado := True;
     sem_AtualizarTela := True;
     DesenharRede;
     end else

  if foMain.sbCriarDemanda.Down and ( (Obj is TprPCP) or (Obj is TprSubBacia) ) then
     begin
     sem_AtualizarTela := False;
     Obj := CriaDemanda(p, FProjeto, Obj);
     if Obj <> nil then
        begin
        WriteStatus(gSB, ['Nome da Demanda criada: ' + Obj.Nome]);
        FProjeto.Modificado := True;
        end;
     sem_AtualizarTela := True;
     DesenharRede;
     end else

  if foMain.sbSB_em_PC.Down then
     begin
     if Obj is TprSubBacia then FSB := TprSubBacia(Obj);
     if (Obj is TprPCP) and (FSB <> nil) then
        begin
        TprPCP(Obj).AdicionaObjeto(FSB);
        DesenharRede;
        FSB := nil;
        FProjeto.Modificado := True;
        end;
     end else

  if foMain.sbCriarTrecho.Down and (Obj is TprPCP) then
     begin
     if Fpc1 = nil then
        begin
        Fpc1 := TprPCP(Obj);

        // verifica se o PC não possui conecção a frente
        if Fpc1.PC_aJusante = nil then
           begin
           WriteStatus(gSB, [Format(cMsgStatus02, [Fpc1.Nome]), cMsgStatus03]);
           ShowMessage(cMsgAjuda04);
           end
        else
           begin
           ShowMessage(cMsgErro05);
           Fpc1 := nil;
           end;
        end
     else
        if Obj <> Fpc1 then
           if not Fpc1.Eh_umPC_aMontante(Obj) then
              begin
              ShowMessage('Novamente.'#13 + cMsgAjuda01);
              WriteStatus(gSB, [Format(cMsgStatus01, [Fpc1.Nome, Obj.Nome])]);
              Fpc1.AdicionaObjeto(Obj);
              Gerenciador.AdicionarObjeto(Fpc1.TrechoDagua);
              DesenharRede;
              FProjeto.PCs.CalculaHierarquia;
              Fpc1 := nil;
              FProjeto.Modificado := True;
              end
           else
              begin
              ShowMessage(Format(cMsgErro06, [Obj.Nome, Fpc1.Nome]));
              Fpc1 := nil;
              end;
     end else

  if foMain.sbInserirPCEntre.Down and (Obj is TprPCP) then
     begin
     if (Fpc1 = nil) then
        begin
        Fpc1 := TprPCP(Obj);
        if Fpc1.TrechoDagua <> nil then
           begin
           ShowMessage(cMsgAjuda06);
           WriteStatus(gSB, [Format(cMsgStatus04, [Fpc1.Nome]), cMsgStatus05]);
           end
        else
           begin
           WriteStatus(gSB, [Format(cMsgErro02, [Fpc1.Nome])]);
           Fpc1 := nil;
           end;
        end
     else
        if Obj = Fpc1.PC_aJusante then
           begin
           ShowMessage('');
           WriteStatus(gSB, [Format(cMsgStatus06, [Fpc1.Nome, Obj.Nome])]);

           Gerenciador.RemoverObjeto(Fpc1.TrechoDagua);
           Fpc1.RemoveTrecho;

           p := Point( (Fpc1.Pos.x + Obj.Pos.x) div 2, (Fpc1.Pos.y + Obj.Pos.y) div 2);
           PC := FProjeto.PCs.CriaPC(i, p, FProjeto, FTN, Menu_PCP);
           Gerenciador.AdicionarObjeto(PC);

           Fpc1.AdicionaObjeto(PC); Gerenciador.AdicionarObjeto(Fpc1.TrechoDagua);
           PC.AdicionaObjeto(Obj);  Gerenciador.AdicionarObjeto(PC.TrechoDagua);

           DesenharRede;
           FProjeto.PCs.CalculaHierarquia;
           Fpc1 := nil;
           FProjeto.Modificado := True;
           end
        else
           WriteStatus(gSB,
             [
             Format(cMsgStatus04, [Fpc1.Nome]),
             Format(cMsgErro01, [Obj.Nome, Fpc1.Nome])
             ]);
     end;

  {$IFDEF DEBUG}
  gDebug.Write('Saindo: Form_Click');
  {$ENDIF}
*)
  if mmMensagemInicial <> nil then
     begin
     self.RemoveControl(mmMensagemInicial);
     mmMensagemInicial := nil;
     end;

  GetCursorPos(p);
  p := Map.ScreenToClient(p);

  ExecutarClick(Sender, FProjeto.PointTo_moPoint(p), ObterObjetoAssociado(Sender));
end;

procedure TprDialogo_AreaDeProjeto.Map_Dbl_Click(Sender: TObject);
var p, c : TPoint;
    i    : Integer;
    TD   : TprTrechoDagua;
    L    : IMoMapLayer;
    mop  : IMoPoint;
    Recs : IMoRecordset;
begin
  if FProjeto.Simulador <> nil then Exit;
  p := Map.ScreenToClient(Mouse.CursorPos);

  // Verifica se o Duplo clique foi em um Trecho Dagua
  if FOnGetButtonStatus('Selecionar') then
     begin
     for i := 0 to FProjeto.PCs.PCs - 1 do
       if FProjeto.PCs[i].TrechoDagua <> nil then
          begin
          TD := FProjeto.PCs[i].TrechoDagua;
          c  := CentroDaReta(TD.PC_aMontante.ScreenPos, TD.PC_aJusante.ScreenPos);
          if DistanciaEntre2Pontos(p, c) < 20 {Pixels} then
             begin
             TD.MostrarDialogo;
             Exit;
             end;
          end;
     // Se o clique não foi no Trecho Dagua é porque foi na janela
     FProjeto.MostrarDialogo;
     end
  else
  if FOnGetButtonStatus('Ver Registros') then
     begin
     if FActiveLayer <> nil then
        if FActiveLayer.Layer.IsMapLayer then
           begin
           L := FActiveLayer.Layer.AsMapLayer;

           mop := Map.ToMapPoint(p.x, p.y);

           // realiza a busca
           if L.ShapeType = moShapeTypePolygon then
              Recs := L.SearchShape(mop, moPointInPolygon, '')
           else
              Recs := L.SearchByDistance(mop, Map.ToMapDistance(10), '');

           // Se a busca retornou algo, mostra os registros encontrados
           if not Recs.EOF then
              TForm_moRecordSet.ShowRecordSet(L.Name, Recs, fsMDIChild);
           end
        else
           WriteStatus(gSB, [cMsgStatus07, cMsgStatus08], True)
     else
        WriteStatus(gSB, [cMsgStatus07, cMsgStatus09], True)
     end;
  // Notifica possível mudança de status
  if Assigned(FOnMessage) then FOnMessage('Atualizar Opcoes', self);
end;

procedure TprDialogo_AreaDeProjeto.Map_MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var p, c: TPoint;
    TD: TprTrechoDagua;
    i: Integer;
begin
  SaveCanvas;
  try
    if (Button = mbLeft) then
       begin
       if FOnGetButtonStatus('Selecionar') then
          begin
          SelecionarObjeto(Sender);
          if (Sender is TMap) then
             Map.Extent := Map.TrackRectangle
          end
       else
          if FOnGetButtonStatus('Arrastar') then
             begin
             SelecionarObjeto(Sender);
             FMapCanvas.Handle := Windows.GetDC(Map.Handle);
             if FBloqueado Then Exit;
             FArrastando := True;
             gOldPos := TControl(Sender).ScreenToClient(Types.Point(x,y));
             gDesloc := Types.Point(x, y);
             FMapCanvas.Pen.Mode := pmXor;
             Screen.Cursor := crHandPoint;
             end
       end
    else
       // Mostrar Menu
       if FOnGetButtonStatus('Selecionar') then
          begin
          if Sender is TMap then
             begin
             p := Types.Point(x, y);
             for i := 0 to Projeto.PCs.PCs - 1 do
               if Projeto.PCs[i].TrechoDagua <> nil then
                  begin
                  TD := Projeto.PCs[i].TrechoDagua;
                  c  := CentroDaReta(TD.PC_aMontante.ScreenPos, TD.PC_aJusante.ScreenPos);
                  if DistanciaEntre2Pontos(p, c) < 20 {Pixels} then
                     begin
                     SelecionarObjeto(TD);
                     TD.MostrarMenu(Mouse.CursorPos.x, Mouse.CursorPos.y);
                     Break;
                     end;
                  end;

              // Mostra o Menu da Janela se existir
             end
          else
             begin
             SelecionarObjeto(Sender);
             FObjSel.MostrarMenu;
             end;
          end;
  finally
    RestoreCanvas;
  end;
end;

procedure TprDialogo_AreaDeProjeto.Map_MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
var p: TPoint;
    c: Tcontrol;
    mo_Point: ImoPoint;
    s: String;
begin
  if FArrastando then
     if Sender is TMap then
        //...
     else
        begin
        c := TControl(Sender);
        p := Map.ScreenToClient(Mouse.CursorPos);
        FMapCanvas.Rectangle(gOldPos.x, gOldPos.y, gOldPos.x + c.Width, gOldPos.y + c.Height);

        dec(p.x, gDesloc.x); dec(p.y, gDesloc.y);
        if p.x < 2 then p.x := 2;
        if p.y < 2 then p.y := 2;

        gOldPos := p;
        FMapCanvas.Rectangle(gOldPos.x, gOldPos.y, gOldPos.x + c.Width, gOldPos.y + c.Height);
        end
  else
     if Sender is TMap then
        begin
        p := Map.ScreenToClient(Mouse.CursorPos);
        mo_Point := Projeto.PointTo_moPoint(p);
        s := FormatFloat('0.####', mo_Point.X) + '  ' + FormatFloat('0.####', mo_Point.Y);
        StatusBar.Panels.Items[3].Width := Canvas.TextWidth(s) + 15;
        StatusBar.Panels.Items[3].Text := s;
        end;
end;

procedure TprDialogo_AreaDeProjeto.Map_MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var p: TPoint;
begin
  if (Button = mbLeft) and not (Sender is TMap) and
     FOnGetButtonStatus('Arrastar') then
     begin
     if FBloqueado Then Exit;
     FArrastando := False;

     p := Map.ScreenToClient(Mouse.CursorPos);
     dec(p.x, gDesloc.x); dec(p.y, gDesloc.y);
     if p.x < 2 then p.x := 2;
     if p.y < 2 then p.y := 2;

     if (TControl(Sender).Left <> p.x) or (TControl(Sender).Top <> p.y) then
        begin
        FObjSel.Modificado := True;
        p := Types.Point(p.x + TControl(Sender).Width div 2,
                         p.y + TControl(Sender).Height div 2);
        FObjSel.Pos := FProjeto.PointTo_moPoint(p);
        end;

     Windows.ReleaseDC(Map.hWnd, FMapCanvas.Handle);

     FMapCanvas.Pen.Mode := pmCopy;
     Map.Refresh;
     end;

  Screen.Cursor := crDefault;
end;

procedure TprDialogo_AreaDeProjeto.Form_Create(Sender: TObject);
begin
  Caption  := ' SEM NOME';
  FMT      := True;
  FTN      := TStringList.Create;

  FProjeto := TprProjeto_Rosen(CriarProjeto(TabelaDeNomes));

  FMonitor := TDLG_Monitor.Create(Self);
  FMonitor.Projeto := FProjeto;

  FPerguntar_TemCerteza := True;
  sem_AtualizarTela     := True;

  FMapCanvas := TControlCanvas.Create;

  {$IFDEF DEBUG}
  btnTeste01.visible := true;
  i_AtualizaTela     := 0;
  {$ELSE}
  btnTeste01.visible := false;
  {$ENDIF}
end;

procedure TprDialogo_AreaDeProjeto.Form_Destroy(Sender: TObject);
var i : Integer;
begin
  WriteStatus(gSB, [''], False);  // limpa a barra de Status

  FProjeto.Free;
  FTN.Free;                // eliminar a tabela de nomes por último

  {É necessário eliminarmos todos os objetos do tipo TdrBaseShape da lista Controls
   que o formulário contém para que o Delphi não destrua os objetos. Os objetos tem
   que serem destruídos por aqueles que os criaram !!}
  i := 0;
  while i < ControlCount do
    begin
    if Controls[i] is TdrBaseShape then
       begin
       RemoveControl(Controls[i]);
       continue;
       end;
    inc(i);
    end;

  FMapCanvas.Free;
end;

procedure TprDialogo_AreaDeProjeto.DesenharRede;
begin
  if FLendo then Exit;

  SaveCanvas;

  // Desenha as Conecções
  ConectarObjetos;

  // Força o desenho de cada objeto
  GetMessageManager.SendMessage(UM_REPINTAR_OBJETO, [Self]);

  // Seleciona o Objeto;
  DesenharSelecao(True);

  // Desenho Extra
  AtualizacaoVisualDoUsuario;

  RestoreCanvas;
end;

{
function TprDialogo_AreaDeProjeto.CriaSubBacia(Pos: TPoint; Projeto: TprProjeto; PC: TObject): TprSubBacia;
begin
  inc(Pos.x, 20); dec(Pos.y, 20);
  Result := TprSubBacia.Create(Pos, Projeto, FTN);
  Result.Modificado := True;
  Result.Menu := Menu_SubBacias;
  TprPCP(PC).AdicionaObjeto(Result);
  DesenharRede;
end;

function TprDialogo_AreaDeProjeto.CriaDemanda(Pos: TPoint; Projeto: TprProjeto; Obj: THidroComponente): TprDemanda;
var OK: Boolean;
begin
  dec(Pos.x, 20); dec(Pos.y, 20);
  Result := TprDemanda.Create(Pos, Projeto, FTN);
  Result.Modificado := True;
  Result.Atribuir(Gerenciador.CD_Selecionada, True);


  gErros.Add(etInformation, 'Verifique os dados entrados na Classe de demanda.'#13 +
                            'Uma ou mais informações podem estar faltando.'#13 +
                            'A demanda ' + Result.Nome + ' somente poderá ser criada se todos'#13 +
                            'os dados de sua classe estiverem corretos.');

  OK := True;
  Result.ValidaDados(Ok, gErros, True);
  if Ok then
     begin
     Gerenciador.AdicionarObjeto(Result);
     Obj.AdicionaObjeto(Result);
     if Obj is TprPCP then Result.Visivel := (TprPCP(Obj).MostrarDemandas);
     end
  else
     begin
     FreeAndNil(Result);
     gErros.Show;
     end;
end;
}
function TprDialogo_AreaDeProjeto.ObterObjetoAssociado(Sender: TObject): THidroComponente;
begin
  Result := nil;
  if (Sender is TdrBaseShape) or (Sender is TImage) then
     Result := THidroComponente(TComponent(Sender).Tag)
  else
  if Sender is TprTrechoDagua then
     Result := TprTrechoDagua(Sender);
end;

procedure TprDialogo_AreaDeProjeto.Form_Activate(Sender: TObject);
begin
  if not FFechando then
     begin
     if Assigned(FOnMessage) then FOnMessage('Selecionar Botao Sel/Info', self);
     SetGlobalStatus(FProjeto.RealizarDiagnostico);
     Gerenciador.AreaDeProjeto := Self;
     end;
end;

// Leitura -----------------------------------------------------------------------------
procedure TprDialogo_AreaDeProjeto.LerDoArquivo(Ini: TIF);
var s: String;
begin
  s := 'Area de Projeto';

  FBloqueado  := Ini.ReadBool    (s, 'Bloqueado', False);
  Left        := Ini.ReadInteger (s, 'x', Left);
  Top         := Ini.ReadInteger (s, 'y', Top);
  Width       := Ini.ReadInteger (s, 'Largura', Width);
  Height      := Ini.ReadInteger (s, 'Altura', Height);
  FMD         := Ini.ReadBool    (s, 'Mostrar Demandas', True);
  FMT         := Ini.ReadBool    (s, 'Mostrar Trechos', True);
  Caption     := Ini.FileName;

  WindowState := TWindowState(Ini.ReadInteger (s, 'Estado Janela', ord(wsNormal)));
end;

// Salvamento --------------------------------------------------------------------------

procedure TprDialogo_AreaDeProjeto.SalvarEmArquivo(Ini: TIF);
var s: String;
begin
  s := 'Area de Projeto';

  HorzScrollBar.Position := 0;
  VertScrollBar.Position := 0;

  Ini.WriteBool   (s, 'Bloqueado', FBloqueado);
  Ini.WriteInteger(s, 'x', Left);
  Ini.WriteInteger(s, 'y', Top);
  Ini.WriteInteger(s, 'Largura', Width);
  Ini.WriteInteger(s, 'Altura', Height);
  Ini.WriteBool   (s, 'Mostrar Demandas', FMD);
  Ini.WriteBool   (s, 'Mostrar Trechos', FMT);
  Ini.WriteInteger(s, 'Estado Janela', ord(WindowState));
  Caption := ' ' + Ini.FileName;
end;

procedure TprDialogo_AreaDeProjeto.btnTeste01_Click(Sender: TObject);
var i : integer;
    x : TRec_prData;
begin
{$IFDEF DEBUG}
  gOutPut.FileName := '';
  gOutPut.BeginDoc;
  gOutPut.Write('Teste de Conversão:  Intervalo de Simulação --> Data (Mes/Ano)');
  gOutPut.Write;
  for i := 1 to FProjeto.Total_IntSim do
    begin
    FProjeto.DeltaT := i;
    x := FProjeto.Data;
    gOutPut.Write(Format('DeltaT = %4d --> Mes: %2d   Ano: %d', [i, x.Mes, x.Ano]));
    if i mod FProjeto.TotalAnual_IntSim = 0 then gOutPut.Write('');
    end;
  gOutPut.show;
{$ENDIF}
end;

procedure TprDialogo_AreaDeProjeto.ExecFail(Sender: TObject);
begin
  ShowMessage('Falha ao executar o Propagar DOS');
end;

procedure TprDialogo_AreaDeProjeto.Salvar;
begin
  SaveDialog.InitialDir := gDir;

  if FProjeto.NomeArquivo <> '' then
     FProjeto.SalvarEmArquivo(FProjeto.NomeArquivo)
  else
    if SaveDialog.Execute then
       begin
       gDir := ExtractFilePath(SaveDialog.FileName);
       FProjeto.SalvarEmArquivo(SaveDialog.FileName);
       end;
end;

function TprDialogo_AreaDeProjeto.DesenharFrame(obj: THidroComponente): boolean;
begin
  Result := (obj is TprPCP) or (obj is TprSubBacia) or (obj is TprDemanda);
end;

procedure TprDialogo_AreaDeProjeto.DesenharSelecao(Selecionar: Boolean);
var oldBrushColor: TColor;
    oldPenColor  : TColor;
    R            : TRect;
    TD           : TprTrechoDagua;
begin
  // desenha a seleção do obj. selecionado, se existe algum.
  if (FObjSel <> nil) then
     begin
     SaveCanvas;

     if DesenharFrame(FObjSel) then
        FObjSel.ImagemDoComponente.Selected := Selecionar
     else
        if (FObjSel is TprTrechoDagua) then
           begin
           if Selecionar then
              FMapCanvas.Pen.color := clRed
           else
              FMapCanvas.Pen.color := clBlue;

           FMapCanvas.Pen.Style := psSolid;
           TD := TprTrechoDagua(FObjSel);
           DesenhaSeta(FMapCanvas, TD.PC_aMontante.ScreenPos, TD.PC_aJusante.ScreenPos, 15,
              DistanciaEntre2Pontos(TD.PC_aMontante.ScreenPos, TD.PC_aJusante.ScreenPos) div 2);

           Map.Invalidate;   
           end;

     RestoreCanvas;
     end;
end;

procedure TprDialogo_AreaDeProjeto.SetObjSel(const Value: THidroComponente);
const S1 = 'Objeto selecionado: ';
var s: String;
begin
  DesenharSelecao(False);

  FObjSel := Value;
  Gerenciador.SelecionarObjeto(Value);

  if Value = nil then
     begin
     WriteStatus(gSB, [''], False);
     s := ' Obj: ';
     end
  else
     begin
     WriteStatus(gSB, [S1 + Value.Nome], False);
     if Assigned(FOnMessage) then FOnMessage('Descrever Objeto', Value);
     s := ' Obj: ' + Value.Nome;
     end;

  StatusBar.Panels.Items[0].Width := Canvas.TextWidth(s) + 15;
  StatusBar.Panels.Items[0].Text := s;

  if Assigned(FOnMessage) then FOnMessage('Atualizar Opcoes', Value);

  DesenharSelecao(True);
end;

procedure TprDialogo_AreaDeProjeto.RemoverObjeto(Obj: THidroComponente);
begin
  if (Obj <> nil) and
     (FProjeto.Simulador = nil) and
     (MessageDLG('Confirma remoção ?', mtConfirmation, [mbYES, mbNO], 0) = mrYES) then
     begin
     SetObjSel(nil);
     if Obj is TprPCP then
        if FProjeto.PCs.Remover(TprPCP(Obj)) then
           Gerenciador.ReconstroiArvore
        else
           Exit
     else
        begin
        Gerenciador.RemoverObjeto(Obj);
        Obj.Free;
        end;

     Repaint;
     FProjeto.Modificado := True;
     end;
end;

procedure TprDialogo_AreaDeProjeto.Menu_EditarClick(Sender: TObject);
begin
  FObjSel.MostrarDialogo;
end;

procedure TprDialogo_AreaDeProjeto.Menu_SB_GraficarVazoesComBarras_Click(Sender: TObject);
begin
  TprSubBacia(FObjSel).GraficarVazoes(tgBarras);
end;

procedure TprDialogo_AreaDeProjeto.Menu_SB_GraficarVazoesComLinhas_Click(Sender: TObject);
begin
  TprSubBacia(FObjSel).GraficarVazoes(tgLinhas);
end;

procedure TprDialogo_AreaDeProjeto.Menu_PCP_FalhasClick(Sender: TObject);
begin
  TprPCP(FObjSel).MostrarFalhas;
end;

procedure TprDialogo_AreaDeProjeto.Menu_MostrarTudo_Click(Sender: TObject);
begin
  THidroComponente(FObjSel).MostrarPlanilha;
end;

procedure TprDialogo_AreaDeProjeto.Menu_TodosClick(Sender: TObject);
begin
  TprPCP(FObjSel).GraficarTudo;
end;

procedure TprDialogo_AreaDeProjeto.Menu_SB_Mostrar_MatricialClick(Sender: TObject);
begin
  FObjSel.MostrarVariavel('Vazões');
end;

procedure TprDialogo_AreaDeProjeto.Menu_PCP_Mostrar_ASBClick(Sender: TObject);
begin
  FObjSel.MostrarVariavel('AfluenciaSB');
end;

procedure TprDialogo_AreaDeProjeto.Menu_PCP_Mostrar_DefluClick(Sender: TObject);
begin
  FObjSel.MostrarVariavel('Defluencia');
end;

procedure TprDialogo_AreaDeProjeto.Menu_PCP_Mostrar_VzMonClick(Sender: TObject);
begin
  FObjSel.MostrarVariavel('VazMontante');
end;

procedure TprDialogo_AreaDeProjeto.Menu_PCP_Mostrar_DA_PClick(Sender: TObject);
begin
  FObjSel.MostrarVariavel('DPA');
end;

procedure TprDialogo_AreaDeProjeto.Menu_PCP_Mostrar_DA_SClick(Sender: TObject);
begin
  FObjSel.MostrarVariavel('DSA');
end;

procedure TprDialogo_AreaDeProjeto.Menu_PCP_Mostrar_DA_TClick(Sender: TObject);
begin
  FObjSel.MostrarVariavel('DTA');
end;

procedure TprDialogo_AreaDeProjeto.Menu_PCP_Mostrar_DP_PClick(Sender: TObject);
begin
  FObjSel.MostrarVariavel('DPP');
end;

procedure TprDialogo_AreaDeProjeto.Menu_PCP_Mostrar_DP_SClick(Sender: TObject);
begin
  FObjSel.MostrarVariavel('DSP');
end;

procedure TprDialogo_AreaDeProjeto.Menu_PCP_Mostrar_DP_TClick(Sender: TObject);
begin
  FObjSel.MostrarVariavel('DTP');
end;

procedure TprDialogo_AreaDeProjeto.Menu_PCP_Mostrar_DT_PClick(Sender: TObject);
begin
  FObjSel.MostrarVariavel('DPT');
end;

procedure TprDialogo_AreaDeProjeto.Menu_PCP_Mostrar_DT_SClick(Sender: TObject);
begin
  FObjSel.MostrarVariavel('DST');
end;

procedure TprDialogo_AreaDeProjeto.Menu_PCP_Mostrar_DT_TClick(Sender: TObject);
begin
  FObjSel.MostrarVariavel('DTT');
end;

procedure TprDialogo_AreaDeProjeto.Menu_PCP_Mostrar_EGClick(Sender: TObject);
begin
  FObjSel.MostrarVariavel('Energia');
end;

procedure TprDialogo_AreaDeProjeto.Menu_PCPR_Mostrar_VolClick(Sender: TObject);
begin
  FObjSel.MostrarVariavel('Volume');
end;

procedure TprDialogo_AreaDeProjeto.Form_CloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := MessageDLG(Format('Fechar o projeto <%s> ?', [FProjeto.Nome]),
    mtConfirmation, [mbYes, mbNo], 0) = mrYes;

  if CanClose Then
     begin
     FFechando := True;
     if FProjeto.Modificado and
        (MessageDLG(Format('Salvar as modificações do projeto "%s"?', [FProjeto.Nome]),
        mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
        Salvar;
     end;
end;

procedure TprDialogo_AreaDeProjeto.PC_TO_RES(PC: TprPCP);
var R: TprPCPR;
begin
  Gerenciador.RemoverObjeto(PC);
  R := PC.MudarParaReservatorio(Menu_PCPR);
  Gerenciador.AdicionarObjeto(R);

  SetObjSel(nil);

  PC.AvisarQueVaiSeDestruir := False;
  FProjeto.PCs[FProjeto.PCs.IndiceDo(PC)] := R;
  PC.Free;

  SetObjSel(R);

  DesenharRede;

    // Notifica possível mudança de status
  if Assigned(FOnMessage) then FOnMessage('Atualizar Opcoes', FObjSel);

  FProjeto.Modificado := True;
end;

procedure TprDialogo_AreaDeProjeto.RES_TO_PC(RES: TprPCPR);
var PC: TprPCP;
begin
  Gerenciador.RemoverObjeto(RES);
  PC := RES.MudarParaPC(Menu_PCP);
  Gerenciador.AdicionarObjeto(PC);

  SetObjSel(nil);

  RES.AvisarQueVaiSeDestruir := False;
  FProjeto.PCs[FProjeto.PCs.IndiceDo(RES)] := PC;
  RES.Free;

  SetObjSel(PC);

  DesenharRede;

    // Notifica possível mudança de status
  if Assigned(FOnMessage) then FOnMessage('Atualizar Opcoes', FObjSel);

  FProjeto.Modificado := True;
end;

procedure TprDialogo_AreaDeProjeto.Menu_PCP_MostrarDemandasClick(Sender: TObject);
var M: TMenuItem;
begin
  M := TMenuItem(Sender);
  M.Checked := not M.Checked;
  TprPCP(FObjSel).MostrarDemandas := M.Checked;
  //DesenharRede;
  Map.Refresh;
end;

procedure TprDialogo_AreaDeProjeto.SetMD(const Value: Boolean);
var i: Integer;
begin
  FMD := Value;
  for i := 0 to FProjeto.PCs.PCs-1 do
    TprPCP(FProjeto.PCs[i]).MostrarDemandas := FMD;

  //DesenharRede;
  Map.Refresh;
end;

procedure TprDialogo_AreaDeProjeto.AtualizacaoVisualDoUsuario;
begin
end;

procedure TprDialogo_AreaDeProjeto.Form_KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
     RemoverObjeto(FObjSel);
end;

procedure TprDialogo_AreaDeProjeto.MapAfterLayerDraw(ASender: TObject; index: Smallint; canceled: WordBool; hDC: Cardinal);
begin
  if index = 0 then
     begin
     FMapCanvas.Handle := hDC;
     DesenharRede;
     end;
end;

procedure TprDialogo_AreaDeProjeto.MapBeforeLayerDraw(ASender: TObject; index: Smallint; hDC: Cardinal);
var ZoomFactor : Real;
    Scale      : Real;
    s          : String;
    i          : Integer;
    LEI        : Tmoec_Layer;
    L          : Variant;
begin
  if (index = Map.Layers.Count-1) then
     begin
     ZoomFactor := Map.FullExtent.Width / Map.Extent.Width;
     Scale := Projeto.Escala / ZoomFactor;

     if FObjSel <> nil then
        s := ' Obj: ' + FObjSel.Nome
     else
        s := ' Obj: ';

     StatusBar.Panels.Items[0].Width := Canvas.TextWidth(s) + 15;
     StatusBar.Panels.Items[0].Text := s;

     s := ' Zoom: ' + FormatFloat('0.####', ZoomFactor);
     StatusBar.Panels.Items[1].Width := Canvas.TextWidth(s) + 15;
     StatusBar.Panels.Items[1].Text := s;

     s := ' Escala: ' + FormatFloat('0.######', Scale);
     StatusBar.Panels.Items[2].Width := Canvas.TextWidth(s) + 15;
     StatusBar.Panels.Items[2].Text := s;

     // Visibilidade das camadas
     if Scale > 0 then
        for i := 0 to Map.Layers.Count-1 do
          begin
          LEI := Map.Layers[i];
          L := LEI.moLayer;
          if LEI.UseScaleForVisibility then
             L.Visible := ((Scale >= LEI.MaxScale) or (LEI.MaxScale = 0)) and
                          ((Scale <= LEI.MinScale) or (LEI.MinScale = 0));
          end;
     end;
end;

procedure TprDialogo_AreaDeProjeto.ExecutarClick(Sender: TObject; p: ImoPoint; Obj: THidroComponente);
var PC: TprPCP;
begin
  if not Assigned(FOnGetButtonStatus) then
     raise Exception.Create('Evento Obter Status não Associado');

  if FOnGetButtonStatus('Conectar SB em PC') then
     FSB := nil;
{
  if FOnGetButtonStatus('Conectar Derivacao em PC') then
     FDer := nil
  else
}
  //---------------- Clicks na Janela -------------------------------------------------


  if FProjeto.Simulador <> nil then
     Exit
  else

  if FOnGetButtonStatus('Criar PC') or FOnGetButtonStatus('Criar Reservatorio') then
     begin
     if FOnGetButtonStatus('Criar PC') then
        begin
        Obj := Projeto.CriarObjeto('PC', p);
        Obj.Menu := Menu_PCP;
        end
     else
        begin
        Obj := Projeto.CriarObjeto('Reservatorio', p);
        Obj.Menu := Menu_PCPR;
        end;

     FProjeto.PCs.Adicionar(TprPCP(Obj));
     Gerenciador.AdicionarObjeto(Obj);

     WriteStatus(gSB, ['PC criado: ' + Obj.Nome], False);
     FProjeto.Modificado := True;
     end
  else

//---------------- Clicks em um PC de Controle -----------------------------------

  if FOnGetButtonStatus('Criar SB') and (Obj is TprPCP) then
     begin
     PC := TprPCP(Obj);
     if ObjetoPodeSerConectadoEm('Sub-Bacia', PC) then
        begin
        Obj := Projeto.CriarObjeto('Sub-Bacia', PC.Pos);
        Obj.Menu := Menu_SubBacias;
        PC.ConectarObjeto(Obj);
        Gerenciador.AdicionarObjeto(Obj);
        WriteStatus(gSB, ['Sub-Bacia criada: ' + Obj.Nome], False);
        FProjeto.Modificado := True;
        Map.Refresh;
        end;
     end else

  if FOnGetButtonStatus('Criar Demanda') and (Obj is TprPCP) then
     begin
     PC := TprPCP(Obj);
     if ObjetoPodeSerConectadoEm('Demanda', PC) then
        begin
        Obj := Projeto.CriarObjeto('Demanda', PC.Pos);
        Obj.Menu := Menu_Demanda;

        // A associação com a classe de demanda é feita pelo gerenciador
        Gerenciador.AdicionarObjeto(Obj);

        // Conecta a demanda ao PC
        PC.ConectarObjeto(Obj);

        WriteStatus(gSB, ['Demanda criada: ' + Obj.Nome], False);
        FProjeto.Modificado := True;
        Map.Refresh;
        end;
     end else

  if FOnGetButtonStatus('Conectar SB em PC') then
     begin
     if Obj is TprSubBacia then FSB := TprSubBacia(Obj);
     if (Obj is TprPCP) and (FSB <> nil) then
        begin
        TprPCP(Obj).ConectarObjeto(FSB);
        Map.Refresh;
        FSB := nil;
        FProjeto.Modificado := True;
        end;
     end else
{
  if FOnGetButtonStatus('Conectar Derivacao em PC') then
     begin
     if Obj is TDerivacao then FDer := TDerivacao(Obj);
     if (Obj is TprPCP) and (FDer <> nil) then
        begin
        TprPCP(Obj).ConectarObjeto(FDer);
        Map.Refresh;
        FDer := nil;
        FProjeto.Modificado := True;
        end;
     end else
}
  if FOnGetButtonStatus('Criar TD') and (Obj is TprPCP) then
     begin
     if Fpc1 = nil then
        begin
        Fpc1 := TprPCP(Obj);

        // verifica se o PC não possui conecção a frente
        if Fpc1.PC_aJusante = nil then
           begin
           WriteStatus(gSB, [Format(cMsgStatus02, [Fpc1.Nome]), cMsgStatus03], False);
           if Assigned(FOnShowMessage) then FOnShowMessage(cMsgAjuda04);
           end
        else
           begin
           WriteStatus(gSB, ['Erro: ' + cMsgStatus03], True);
           Fpc1 := nil;
           end;
        end
     else
        if Obj <> Fpc1 then
           if not Fpc1.Eh_umPC_aMontante(Obj) then
              begin
              if Assigned(FOnShowMessage) then FOnShowMessage('Novamente.'#13 + cMsgAjuda01);
              WriteStatus(gSB, [Format(cMsgStatus01, [Fpc1.Nome, Obj.Nome])], False);
              Fpc1.ConectarObjeto(Obj);
              Gerenciador.AdicionarObjeto(Fpc1.TrechoDagua);
              Map.Refresh;
              FProjeto.PCs.CalcularHierarquia;
              Fpc1 := nil;
              FProjeto.Modificado := True;
              end
           else
              begin
              if Assigned(FOnShowMessage) then
                 FOnShowMessage(Format(cMsgErro06, [Obj.Nome, Fpc1.Nome]));
              Fpc1 := nil;
              end;
     end else

  if FOnGetButtonStatus('Inserir PC') and (Obj is TprPCP) then
     begin
     if (Fpc1 = nil) then
        begin
        Fpc1 := TprPCP(Obj);
        if Fpc1.TrechoDagua <> nil then
           begin
           if Assigned(FOnShowMessage) then FOnShowMessage(cMsgAjuda06);
           WriteStatus(gSB, [Format(cMsgStatus04, [Fpc1.Nome]), cMsgStatus05], False);
           end
        else
           begin
           WriteStatus(gSB, [Format(cMsgErro02, [Fpc1.Nome])], True);
           Fpc1 := nil;
           end;
        end
     else
        if Obj = Fpc1.PC_aJusante then
           begin
           if Assigned(FOnShowMessage) then FOnShowMessage('');
           WriteStatus(gSB, [Format(cMsgStatus06, [Fpc1.Nome, Obj.Nome])], False);

           Gerenciador.RemoverObjeto(Fpc1.TrechoDagua);
           Fpc1.RemoverTrecho;

           gmoPoint.X := (Fpc1.Pos.x + Obj.Pos.x) / 2;
           gmoPoint.Y := (Fpc1.Pos.y + Obj.Pos.y) / 2;

           PC := TprPCP(Projeto.CriarObjeto('PC', gmoPoint));
           Projeto.PCs.Adicionar(PC);
           Gerenciador.AdicionarObjeto(Obj);
           Fpc1.ConectarObjeto(PC);
           PC.ConectarObjeto(Obj);

           Map.Refresh;
           FProjeto.PCs.CalcularHierarquia;
           Fpc1 := nil;
           FProjeto.Modificado := True;
           end
        else
           WriteStatus(gSB,
             [Format(cMsgStatus04, [Fpc1.Nome]),
              Format(cMsgErro01, [Obj.Nome, Fpc1.Nome])], True);
     end;
end;

procedure TprDialogo_AreaDeProjeto.Form_Resize(Sender: TObject);
begin
  if mmMensagemInicial <> nil then
     begin
     mmMensagemInicial.Top := ClientHeight div 2 - mmMensagemInicial.Height div 2;
     mmMensagemInicial.Left := ClientWidth div 2 - mmMensagemInicial.Width div 2 + paLayers.Width div 2;
     end;
end;

procedure TprDialogo_AreaDeProjeto.Form_Show(Sender: TObject);
begin
  if Height < 265 then Height := 265;
  if Width < 308 then Width := 308;
  self.Resize;
end;

function TprDialogo_AreaDeProjeto.ObjetoPodeSerConectadoEm(const ID: String; Objeto: THidroComponente): Boolean;
begin
  Result := ((ID = 'Sub-Bacia') and (Objeto is TprPCP)) or
            ((ID = 'Demanda') and (Objeto is TprPCP));
end;

procedure TprDialogo_AreaDeProjeto.RestoreCanvas;
begin
  Dec(FLockCanvas);
  if FLockCanvas = 0 then
     begin
     FMapCanvas.Pen.Mode := FPenMode;
     FMapCanvas.Pen.Color := FPenColor;
     FMapCanvas.Brush.Color := FBrushColor;
     end;
end;

procedure TprDialogo_AreaDeProjeto.SaveCanvas;
begin
  inc(FLockCanvas);
  if FLockCanvas = 1 then
     begin
     FPenMode := FMapCanvas.Pen.Mode;
     FPenColor := FMapCanvas.Pen.Color;
     FBrushColor := FMapCanvas.Brush.Color;
     end;
end;

procedure TprDialogo_AreaDeProjeto.ConectarObjetos;
var i, j, k: Integer;
    pc_pos, ob_pos, ob2_pos: TPoint;
    Ob, Ob2: THidroComponente;
    PC: TprPCP;
begin
  SaveCanvas;

  for i := 0 to FProjeto.PCs.PCs - 1 do
    begin
    pc_pos := FProjeto.PCs[i].ScreenPos;

    // Liga o PC montante ao PC jusante
    PC := FProjeto.PCs[i].PC_aJusante;
    if (PC <> nil) and FMT then
       begin
       ob_pos := PC.ScreenPos;
       FMapCanvas.Pen.Style := psSolid;
       FMapCanvas.Pen.Color := clBlue;
       FMapCanvas.Pen.Width := 1;
       DesenhaSeta(
          FMapCanvas,
          FProjeto.PCs[i].ScreenPos,
          ob_pos,
          15,
          DistanciaEntre2Pontos(pc_pos, ob_pos) div 2
          );
       end;

    // Liga os objetos conectados ao PC com uma linha pontilhada
    FMapCanvas.Pen.Style := psDot;
    FMapCanvas.Pen.Color := clBlack;
    FMapCanvas.Pen.Width := 1;
    for j := 0 to FProjeto.PCs[i].SubBacias - 1 do
      begin
      Ob := FProjeto.PCs[i].SubBacia[j];
      ob_pos := Ob.ScreenPos;

      FMapCanvas.MoveTo(pc_pos.x, pc_pos.y);
      FMapCanvas.LineTo(ob_pos.x, ob_pos.y);

      // Liga esta SubBacia a todas as suas demandas
      if TprPCP(FProjeto.PCs[i]).MostrarDemandas then
         for k := 0 to TprSubBacia(ob).Demandas - 1 do
           begin
           Ob2 := TprSubBacia(ob).Demanda[k];
           ob2_pos := Ob2.ScreenPos;
           FMapCanvas.MoveTo(ob_pos.x, ob_pos.y);
           FMapCanvas.LineTo(ob2_pos.x, ob2_pos.y);
           end; //for k ... --> para todas as demandas
      end; // for j ... --> para todas as SubBacia

    if TprPCP(FProjeto.PCs[i]).MostrarDemandas then
       for j := 0 to FProjeto.PCs[i].Demandas - 1 do
         begin
         Ob := FProjeto.PCs[i].Demanda[j];
         ob_pos := Ob.ScreenPos;
         FMapCanvas.MoveTo(pc_pos.x, pc_pos.y);
         FMapCanvas.LineTo(ob_pos.x, ob_pos.y);
         end;
    end; // para todos os PCs

  RestoreCanvas;
end;

function TprDialogo_AreaDeProjeto.CriarProjeto(TN: TStrings): TprProjeto;
begin
  Result := TprProjeto_Rosen.Create(TN, Self);
end;

procedure TprDialogo_AreaDeProjeto.AtualizacaoVisualDaSimulacao;
var D: TRec_prData;
begin
  Progresso.Position := FProjeto.DeltaT;
  D := FProjeto.Data;

  if Projeto.Status = sOtimizando then
     Caption := Format(' %d Simulação %2d/%4d (%d) ...',
                [Projeto.IndiceSimulacao, D.Mes, D.Ano, FProjeto.DeltaT])
  else
     Caption := Format(' Simulando %2d/%4d (%d) ...',
                [D.Mes, D.Ano, FProjeto.DeltaT]);
end;

procedure TprDialogo_AreaDeProjeto.UpdateLayerButtons;
begin
  btnUp.Enabled := (FActiveLayer <> nil);
  btnDown.Enabled := btnUp.Enabled;
  btnDel.Enabled := btnUp.Enabled;
end;

procedure TprDialogo_AreaDeProjeto.Layer_Click(Sender: TObject);
begin
  if FActiveLayer <> nil then
     FActiveLayer.Color := clBtnFace;

  FActiveLayer := TFrame_moLayer(Sender);
  FActiveLayer.Color := clMoneyGreen;

  UpdateLayerButtons();
end;

procedure TprDialogo_AreaDeProjeto.AddLayer(Layer: Tmoec_Layer);
var b: TRAScrollMaxBand;
    f: TFrame_moLayer;
begin
  b := TRAScrollMaxBand.Create(Layers);
  f := TFrame_moLayer.Create(b, Layer);

  b.Height := f.Height + 27;
  b.Caption := Layer.AsVariant.Name;

  f.Align := alClient;
  f.OnClick := Layer_Click;
  f.RecordSetFormStyle := fsMDIChild;
  f.Parent := b;

  Layers.AddBand(b);
  b.Order := 0;
end;

procedure TprDialogo_AreaDeProjeto.setLendo(const Value: Boolean);
begin
  FLendo := Value;
  Map.Visible := not Value;
  Layers.Visible := not Value;
end;

procedure TprDialogo_AreaDeProjeto.InvertLayers;
var i, k: Integer;
begin
  k := 0;
  for i := Layers.BandCount-1 downto 0 do
    begin
    Layers.Bands[Layers.BandCount-1].Order := k;
    inc(k);
    end;
  Layers.Bands[0].Order := Layers.BandCount-1;  
end;

procedure TprDialogo_AreaDeProjeto.btnUpClick(Sender: TObject);
var b: TRAScrollMaxBand;
    i: Integer;
begin
  b := TRAScrollMaxBand(FActiveLayer.Parent);
  Map.Layers.MoveTo(b.Order, b.Order - 1);
  b.Order := b.Order - 1;
  Map.Refresh;
end;

procedure TprDialogo_AreaDeProjeto.btnDownClick(Sender: TObject);
var b: TRAScrollMaxBand;
    i: Integer;
begin
  b := TRAScrollMaxBand(FActiveLayer.Parent);
  Map.Layers.MoveTo(b.Order, b.Order + 1);
  b.Order := b.Order + 1;
  Map.Refresh;
end;

procedure TprDialogo_AreaDeProjeto.btnDelClick(Sender: TObject);
var b: TRAScrollMaxBand;
begin
  if MessageDLG('Tem certeza ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     begin
     b := TRAScrollMaxBand(FActiveLayer.Parent);
     Map.Layers.Remove(b.Order);
     b.Free;
     FActiveLayer := nil;
     UpdateLayerButtons();
     end;
end;

end.

