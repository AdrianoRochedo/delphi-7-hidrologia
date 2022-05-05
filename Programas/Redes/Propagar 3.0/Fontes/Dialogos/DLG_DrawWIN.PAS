unit DLG_DrawWIN;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls, ActnList, ComCtrls, Menus,
     Dialogs,
     MSXML4,
     XML_Utils,
     pr_Application,
     pr_Classes,
     pr_Const,
     pr_Tipos,
     pr_Vars,
     pr_Dialogo_Projeto,
     pr_Monitor;

type                                   
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
    Menu_CenarioDemanda: TPopupMenu;
    procedure Form_Close(Sender: TObject; var Action: TCloseAction);
    procedure Form_Click(Sender: TObject);
    procedure Form_Dbl_Click(Sender: TObject);
    procedure Form_MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Form_MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Form_MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Form_Create(Sender: TObject);
    procedure Form_Destroy(Sender: TObject);
    procedure Form_Paint(Sender: TObject);
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
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Menu_PCP_MostrarDemandasClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Menu_CenarioDemandaPopup(Sender: TObject);
  private
    FProjeto             : TprProjetoOtimizavel;
    gOldPos              : TPoint;
    gDesloc              : TPoint;
    Arrastando           : Boolean;
    Fpc1                 : TprPC;
    FSB                  : TprSubBacia;
    FIni                 : TIF;      // Usado no armazenamento/recuperação de informações
    FObjSel              : THidroComponente;
    FTN                  : TStrings;
    FPerguntar_TemCerteza: Boolean;
    FFechando            : Boolean;
    FBloqueado           : Boolean;
    FMT                  : Boolean;
    FMF                  : Boolean;
    FMD                  : Boolean;   // Mostra ou não as demandas dos PCs
    FLendo               : Boolean;
    sem_AtualizarTela    : Boolean;   // Semáforo de atualização de tela

    FMonitor             : TDLG_Monitor;

    {$IFDEF DEBUG}
    i_AtualizaTela       : Integer;
    {$ENDIF}

    // Acoes dinamicas dos menus dos plugins
    FAcoes: TActionList;

    function CriarMenu(Acao: TBasicAction): TMenuItem;
    function CriarItemDeMenu(Raiz: TMenuItem; Texto: String; Evento: TNotifyEvent = nil): TMenuItem; overload;
    function CriarItemDeMenu(Raiz: TMenuItem; Acao: TBasicAction): TMenuItem; overload;
    function CriarSubMenus(Raiz: TMenuItem; Acao: TBasicAction; CriarItem: boolean): TMenuItem;

    function  CriaSubBacia(Pos: TPoint; Projeto: TprProjeto; PC: TObject): TprSubBacia;
    function  CriaDemanda(Pos: TPoint; Projeto: TprProjeto; Obj: THidroComponente): TprDemanda;
    function  CriarCenario(Pos: TPoint; Projeto: TprProjeto; Obj: THidroComponente): TprCenarioDeDemanda;
    function  ObterObjetoAssociado(Sender: TObject): THidroComponente;
    procedure DesenharSelecao(Selecionar: Boolean);
    procedure SetObjSel(const Value: THidroComponente);
    procedure SelecionarObjeto(sender: TObject);
    procedure SetMD(const Value: Boolean);

    procedure beginSave();
    procedure endSave();
  public
    procedure DesenharFundoDeTela();
    procedure AtualizacaoVisualDaSimulacao();

    procedure RemoverObjeto(Obj: THidroComponente);
    procedure DesenharRede();

    procedure Salvar();
    procedure SalvarEmArquivo(Ini: TIF);
    procedure LerDoArquivo(Ini: TIF);

    procedure toXML();
    procedure fromXML(no: IXMLDomNode);

    procedure PC_TO_RES(PC: TprPCP);
    procedure RES_TO_PC(RES: TprPCPR);

    property  Perguntar_TemCerteza: Boolean read FPerguntar_TemCerteza
                                           write FPerguntar_TemCerteza;

    property  MostrarFundo       : Boolean                read FMF          write FMF;
    property  MostrarTrechos     : Boolean                read FMT          write FMT;
    property  MostrarDemandas    : Boolean                read FMD          write SetMD;

    property  Bloqueado          : Boolean                read FBloqueado   write FBloqueado;
    property  ObjetoSelecionado  : THidroComponente       read FObjSel      write SetObjSel;
    property  TabelaDeNomes      : TStrings               read FTN;
    property  Projeto            : TprProjetoOtimizavel   read FProjeto;
    property  Monitor            : TDLG_Monitor           read FMonitor;

    // Avisa que a área de projeto está em processo de leitura
    property  Lendo : Boolean read FLendo write FLendo;
  end;

implementation
uses SysUtils, WinUtils, GraphicUtils, Shapes, MessageManager, ExtCtrls, FileCtrl
     ,{$IFDEF DEBUG} uDEBUG, {$ENDIF}
     MAIN,
     Plugin,
     SysUtilsEx,
     pr_Funcoes,
     pr_Util,
     Edit,
     MessagesForm,
     pr_Gerenciador;

{$R *.DFM}

procedure TprDialogo_AreaDeProjeto.SelecionarObjeto(Sender: TObject);
var Obj: THidroComponente;
    p, c: TPoint;
    TD: TprTrechoDagua;
    i: Integer;
begin
  if Sender = nil then
     setObjSel(nil)
  else
     begin
     if MainForm.sbCriarTrecho.Down or
        MainForm.sbCriarPC.Down or
        MainForm.sbCriarSubBacia.Down then Exit;

     if Sender is TForm then
        begin
        p := ScreenToClient(Mouse.CursorPos);

        for i := 0 to Projeto.PCs.PCs - 1 do
          if FProjeto.PCs[i].TrechoDagua <> nil then
             begin
             TD := FProjeto.PCs[i].TrechoDagua;
             c  := CentroDaReta(TD.PC_aMontante.Pos, TD.PC_aJusante.Pos);
             if DistanciaEntre2Pontos(p, c) < 20 {Pixels} then
                begin
                SelecionarObjeto(TD);
                Gerenciador.SelecionarObjeto(TD);
                Exit;
                end;
             end;

        setObjSel(nil);
        WriteStatus(gSB, ['Selected Object: Project Window'], false);
        gMemo.Text := FProjeto.Comentarios.Text;
        gDesc.Text := FProjeto.Descricao;
        gNome.Text := FProjeto.Nome;
        end
     else
        setObjSel(ObterObjetoAssociado(Sender));
     end;

  if not MainForm.sbCriarDemanda.Down then
     Gerenciador.SelecionarObjeto(FObjSel);
end;

procedure TprDialogo_AreaDeProjeto.Form_Close(Sender: TObject; var Action: TCloseAction);
begin
  if FProjeto.Modificado and
     (MessageDLG(Format('Salva as modificações do projeto "%s"?', [FProjeto.Nome]),
     mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
     Salvar;

  Action := caFree;
end;

procedure TprDialogo_AreaDeProjeto.Form_Click(Sender: TObject);
var p: TPoint;
    i: Integer;
    Obj: THidroComponente;
    PC: TprPC;
begin
  GetCursorPos(p);
  p := ScreenToClient(p);
  Obj := ObterObjetoAssociado(Sender);

  if not MainForm.sbSB_em_PC.Down then FSB := nil;

//---------------- Clicks na Janela -------------------------------------------------

  if MainForm.sbArrastar.Down then
     SelecionarObjeto(Self)
  else

  if FProjeto.Simulador <> nil then
     Exit
  else

  if MainForm.sbCriarPC.Down then
     begin
     sem_AtualizarTela := False;
     Obj := FProjeto.PCs.CriaPC(i, p, FProjeto, FTN, Menu_PCP);
     Gerenciador.AdicionarObjeto(Obj);
     WriteStatus(gSB, ['Nome do PC criado: ' + Obj.Nome], false);
     FProjeto.Modificado := True;
     sem_AtualizarTela := True;
     end else

  if MainForm.sbPCReservatorio.Down then
     begin
     sem_AtualizarTela := False;
     Obj := FProjeto.PCs.CriaReservatorio(i, p, FProjeto, FTN, Menu_PCPR);
     Gerenciador.AdicionarObjeto(Obj);
     WriteStatus(gSB, ['Nome do PC criado: ' + Obj.Nome], false);
     FProjeto.Modificado := True;
     sem_AtualizarTela := True;
     end else

//-------------------- Click em uma Demanda -------------------------------------------

  if MainForm.sbCriarCenarioDemanda.Down and (Obj is TprDemanda) then
     begin
     {
     if (TprDemanda(Obj).NumCenarios = 1) then
        raise Exception.Create('A demanda já possui um cenário');
     }
     sem_AtualizarTela := False;
     Obj := CriarCenario(p, FProjeto, Obj);
     Gerenciador.AdicionarObjeto(Obj);
     WriteStatus(gSB, ['Nome do Cenário criado: ' + Obj.Nome], false);
     FProjeto.Modificado := True;
     sem_AtualizarTela := True;
     DesenharRede;
     end else

//---------------- Clicks em um PC de Controle ou em uma Sub-Bacias -------------------

  if MainForm.sbCriarSubBacia.Down and (Obj is TprPC) then
     begin
     sem_AtualizarTela := False;
     Obj := CriaSubBacia(p, FProjeto, Obj);
     Gerenciador.AdicionarObjeto(Obj);
     WriteStatus(gSB, ['Nome da Sub-Bacia criada: ' + Obj.Nome], false);
     FProjeto.Modificado := True;
     sem_AtualizarTela := True;
     DesenharRede;
     end else

  if MainForm.sbCriarDemanda.Down and ( (Obj is TprPC) or (Obj is TprSubBacia) ) then
     begin
     sem_AtualizarTela := False;
     Obj := CriaDemanda(p, FProjeto, Obj);
     if Obj <> nil then
        begin
        WriteStatus(gSB, ['Nome da Demanda criada: ' + Obj.Nome], false);
        FProjeto.Modificado := True;
        end;
     sem_AtualizarTela := True;
     DesenharRede;
     end else

  if MainForm.sbSB_em_PC.Down then
     begin
     if Obj is TprSubBacia then FSB := TprSubBacia(Obj);
     if (Obj is TprPC) and (FSB <> nil) then
        begin
        TprPC(Obj).AdicionarObjeto(FSB);
        DesenharRede;
        FSB := nil;
        FProjeto.Modificado := True;
        end;
     end else

  if MainForm.sbCriarTrecho.Down and (Obj is TprPC) then
     begin
     if Fpc1 = nil then
        begin
        Fpc1 := TprPC(Obj);

        // verifica se o PC não possui conecção a frente
        if Fpc1.PC_aJusante = nil then
           begin
           WriteStatus(gSB, [Format(cMsgStatus02, [Fpc1.Nome]), cMsgStatus03], false);
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
              WriteStatus(gSB, [Format(cMsgStatus01, [Fpc1.Nome, Obj.Nome])], false);
              Fpc1.AdicionarObjeto(Obj);
              Gerenciador.AdicionarObjeto(Fpc1.TrechoDagua);
              DesenharRede;
              FProjeto.PCs.CalcularHierarquia();
              Fpc1 := nil;
              FProjeto.Modificado := True;
              end
           else
              begin
              ShowMessage(Format(cMsgErro06, [Obj.Nome, Fpc1.Nome]));
              Fpc1 := nil;
              end;
     end else

  if MainForm.sbInserirPCEntre.Down and (Obj is TprPC) then
     begin
     if (Fpc1 = nil) then
        begin
        Fpc1 := TprPC(Obj);
        if Fpc1.TrechoDagua <> nil then
           begin
           ShowMessage(cMsgAjuda06);
           WriteStatus(gSB, [Format(cMsgStatus04, [Fpc1.Nome]), cMsgStatus05], false);
           end
        else
           begin
           WriteStatus(gSB, [Format(cMsgErro02, [Fpc1.Nome])], true);
           Fpc1 := nil;
           end;
        end
     else
        if Obj = Fpc1.PC_aJusante then
           begin
           ShowMessage('');
           WriteStatus(gSB, [Format(cMsgStatus06, [Fpc1.Nome, Obj.Nome])], false);

           Gerenciador.RemoverObjeto(Fpc1.TrechoDagua);
           Fpc1.RemoveTrecho;

           p := Point( (Fpc1.Pos.x + Obj.Pos.x) div 2, (Fpc1.Pos.y + Obj.Pos.y) div 2);
           PC := FProjeto.PCs.CriaPC(i, p, FProjeto, FTN, Menu_PCP);
           Gerenciador.AdicionarObjeto(PC);

           Fpc1.AdicionarObjeto(PC); Gerenciador.AdicionarObjeto(Fpc1.TrechoDagua);
           PC.AdicionarObjeto(Obj);  Gerenciador.AdicionarObjeto(PC.TrechoDagua);

           DesenharRede;
           FProjeto.PCs.CalcularHierarquia();
           Fpc1 := nil;
           FProjeto.Modificado := True;
           end
        else
           WriteStatus(gSB,
             [
             Format(cMsgStatus04, [Fpc1.Nome]),
             Format(cMsgErro01, [Obj.Nome, Fpc1.Nome])
             ], true);
     end;
end;

procedure TprDialogo_AreaDeProjeto.Form_Dbl_Click(Sender: TObject);
var p   : TPoint;
    PC  : TprPC;
    i   : Integer;
    c   : TPoint;
    TD  : TprTrechoDagua;
begin
  if FProjeto.Simulador <> nil then Exit;
  p := ScreenToClient(Mouse.CursorPos);

  // Verifica se o Duplo clique foi em um Trecho Dagua
  for i := 0 to FProjeto.PCs.PCs - 1 do
    if FProjeto.PCs[i].TrechoDagua <> nil then
       begin
       TD := FProjeto.PCs[i].TrechoDagua;
       c  := CentroDaReta(TD.PC_aMontante.Pos, TD.PC_aJusante.Pos);
       if DistanciaEntre2Pontos(p, c) < 20 {Pixels} then
          begin
          TD.MostrarDialogo;
          Exit;
          end;
       end;

  // Se o clique não foi no Trecho Dagua é porque foi na janela
  FProjeto.MostrarDialogo;
  MainForm.AtualizaMenus(nil);
end;

procedure TprDialogo_AreaDeProjeto.Form_MouseDown(Sender: TObject; Button: TMouseButton;
                                        Shift: TShiftState; X, Y: Integer);
var p: TPoint;
begin
  if Button = mbLeft then
     if MainForm.sbArrastar.Down then
        if Sender is TForm then
           //...
        else
           begin
           if FBloqueado Then Exit;
           Arrastando := True;
           gOldPos := TControl(Sender).ScreenToClient(Point(x,y));
           gDesloc := Point(x, y);
           canvas.Pen.Mode := pmXor;
           end
     else
       //nada
  else
     if Sender is TForm then
        //...
     else
        begin
        SelecionarObjeto(Sender);
        FObjSel.MostrarMenu();
        end;
end;

procedure TprDialogo_AreaDeProjeto.Form_MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
var p: TPoint;
    c: Tcontrol;
begin
  if Arrastando then
     if Sender is TForm then
        //...
     else
        begin
        c := TControl(Sender);
        p := ScreenToClient(Mouse.CursorPos);
        canvas.Rectangle(gOldPos.x, gOldPos.y, gOldPos.x + c.Width, gOldPos.y + c.Height);

        dec(p.x, gDesloc.x); dec(p.y, gDesloc.y);
        if p.x < 2 then p.x := 2;
        if p.y < 2 then p.y := 2;

        gOldPos := p;
        canvas.Rectangle(gOldPos.x, gOldPos.y, gOldPos.x + c.Width, gOldPos.y + c.Height);
        end;
end;

procedure TprDialogo_AreaDeProjeto.Form_MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var p: TPoint;
begin
  if Button = mbLeft then
     begin
     SelecionarObjeto(Sender);
     if MainForm.sbArrastar.Down then
        if not (Sender is TForm) then
           begin
           if FBloqueado Then Exit;
           Arrastando := False;

           p := ScreenToClient(Mouse.CursorPos);
           dec(p.x, gDesloc.x); dec(p.y, gDesloc.y);
           if p.x < 2 then p.x := 2;
           if p.y < 2 then p.y := 2;

           if (TControl(Sender).Left <> p.x) or (TControl(Sender).Top <> p.y) then
              begin
              sem_AtualizarTela := False;
              FObjSel.Modificado := True;
              TControl(Sender).Left := p.x;
              TControl(Sender).Top  := p.y;
              sem_AtualizarTela := True;
              end;

           canvas.Pen.Mode := pmCopy;
           DesenharRede;
           end;
     end;
end;

procedure TprDialogo_AreaDeProjeto.Form_Create(Sender: TObject);
begin
  Caption  := ' SEM NOME';
  FMT      := True;
  FMF      := True;

  // Tabela de nomes
  FTN := TStringList.Create;
  TStringList(FTN).Sorted := true;

  FProjeto := TprProjetoOtimizavel.Create(FTN);
  FProjeto.AreaDeProjeto := Self;

  FMonitor := TDLG_Monitor.Create(Self);
  FMonitor.Projeto := FProjeto;

  FPerguntar_TemCerteza := True;
  sem_AtualizarTela     := True;
end;

procedure TprDialogo_AreaDeProjeto.Form_Destroy(Sender: TObject);
var i : Integer;
begin
  WriteStatus(gSB, [''], false); // limpa a barra de Status
  
  gMemo.Clear;            // limpa a barra de comentários
  gDesc.Clear;            // limpa a barra de descrição
  gNome.Clear;            // limpa a barra de nome

  FProjeto.Free;
  FTN.Free;               // eliminar a tabela de nomes por último !

  FAcoes.Free;            // Elimina as acoes temporarias criadas por um menu

  {É necessário eliminarmos todos os objetos do tipo TdrBaseShape da lista Controls
   que o formulário contém para que o Delphi não destrua os objetos. Os objetos tem
   que serem destruídos por aqueles que os criaram !!}
  i := ControlCount-1;
  while i > -1 do
    begin
    if Controls[i] is TdrBaseShape then
       RemoveControl(Controls[i]);
    dec(i);
    end;
end;

procedure TprDialogo_AreaDeProjeto.DesenharFundoDeTela();
begin
  if FProjeto.FundoBmp <> nil then
     begin
     HorzScrollBar.Range := FProjeto.FundoBmp.Width;
     VertScrollBar.Range := FProjeto.FundoBmp.Height;
     Canvas.Draw(-HorzScrollBar.Position, -VertScrollBar.Position, FProjeto.FundoBmp)
     end;
end;

procedure TprDialogo_AreaDeProjeto.DesenharRede();
var i, j, k: Integer;
    p1, p2: TPoint;
    Ob, Ob2: THidroComponente;
    PC: TprPC;

    procedure LigarDemandaAosCenarios(Obj: THidroComponente);
    var DM: TprDemanda;
        i: integer;
    begin
      DM := TprDemanda(Obj);
      for i := 0 to DM.NumCenarios-1 do
        begin
        Canvas.MoveTo(DM.Pos.x, DM.Pos.y);
        Canvas.LineTo(DM.Cenario[i].Pos.x, DM.Cenario[i].Pos.y);
        end;
    end;

begin
  if not sem_AtualizarTela or FLendo then Exit;

  {$IFDEF DEBUG}
  gDebug.Write('DesenharRede');
  {$ENDIF}

  Canvas.Pen.Color := clBlack;
  Canvas.Brush.Color := Color;

  if (FProjeto.ArqFundo <> '') and FMF then
     DesenharFundoDeTela()
  else
     Canvas.FillRect(ClientRect);

  for i := 0 to FProjeto.PCs.PCs - 1 do
    begin
    // Liga o PC montante ao PC jusante
    PC := FProjeto.PCs[i].PC_aJusante;

    if (PC <> nil) and FMT then
       begin
       Canvas.Pen.Style := psSolid;
       DesenhaSeta(
          Canvas,
          FProjeto.PCs[i].Pos,
          PC.Pos,
          15,
          DistanciaEntre2Pontos(FProjeto.PCs[i].Pos, PC.Pos) div 2
          );
       end;

    // Liga os objetos conectados ao PC com uma linha pontilhada
    Canvas.Pen.Style := psDot;
    for j := 0 to FProjeto.PCs[i].SubBacias - 1 do
      begin
      Ob := THidroComponente(FProjeto.PCs[i].SubBacia[j]);
      if Ob <> nil then
         begin
         Canvas.MoveTo(FProjeto.PCs[i].Pos.x, FProjeto.PCs[i].Pos.y);
         Canvas.LineTo(Ob.Pos.x, Ob.Pos.y);

         // Liga esta SubBacia a todas as suas demandas
         if TprPCP(FProjeto.PCs[i]).MostrarDemandas then
            for k := 0 to TprSubBacia(ob).Demandas - 1 do
              begin
              Ob2 := TprSubBacia(ob).Demanda[k];
              if Ob2 <> nil then
                 begin
                 Canvas.MoveTo(ob.Pos.x, ob.Pos.y);
                 Canvas.LineTo(Ob2.Pos.x, Ob2.Pos.y);
                 end;
              LigarDemandaAosCenarios(Ob2);
              end; //for k ... --> para todas as demandas
         end; //if ob <> nil ... --> ob = SubBacia
      end; // for j ... --> para todas as SubBacia

    if TprPCP(FProjeto.PCs[i]).MostrarDemandas then
       for j := 0 to FProjeto.PCs[i].Demandas - 1 do
         begin
         Ob := THidroComponente(FProjeto.PCs[i].Demanda[j]);
         if Ob <> nil then
            begin
            Canvas.MoveTo(FProjeto.PCs[i].Pos.x, FProjeto.PCs[i].Pos.y);
            Canvas.LineTo(Ob.Pos.x, Ob.Pos.y);
            end;
         LigarDemandaAosCenarios(Ob);
         end;
    end; // para todos os PCs

  DesenharSelecao(True);

  // Força o desenho de cada objeto
  GetMessageManager.SendMessage(UM_REPINTAR_OBJETO, [Self]);
end;

procedure TprDialogo_AreaDeProjeto.Form_Paint(Sender: TObject);
begin
  DesenharRede();
end;

function TprDialogo_AreaDeProjeto.CriaSubBacia(Pos: TPoint; Projeto: TprProjeto; PC: TObject): TprSubBacia;
begin
  inc(Pos.x, 20); dec(Pos.y, 20);
  Result := TprSubBacia.Create(Pos, Projeto, FTN);
  Result.Modificado := True;
  Result.Menu := Menu_SubBacias;
  TprPC(PC).AdicionarObjeto(Result);
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
  Result.ValidarDados(Ok, gErros, True);
  if Ok then
     begin
     Gerenciador.AdicionarObjeto(Result);
     Obj.AdicionarObjeto(Result);
     if Obj is TprPCP then Result.Visivel := (TprPCP(Obj).MostrarDemandas);
     end
  else
     begin
     FreeAndNil(Result);
     gErros.Show;
     end;
end;

function TprDialogo_AreaDeProjeto.CriarCenario(Pos: TPoint; Projeto: TprProjeto; Obj: THidroComponente): TprCenarioDeDemanda;
begin
  if Applic.Plugins.ActiveFactory <> nil then
     begin
     dec(Pos.x, 20); dec(Pos.y, 20);
     Result := TprCenarioDeDemanda.Create(Pos, Projeto, FTN,
                                          Applic.Plugins.ActiveFactory);
     Result.Modificado := True;
     Result.Menu := Menu_CenarioDemanda;
     Obj.AdicionarObjeto(Result);
     DesenharRede;
     end
  else
     raise Exception.Create('Cenário de Demanda não selecionado');
end;

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
  if FFechando then Exit;
  MainForm.sbArrastar.Down := True;
  Gerenciador.AreaDeProjeto := Self;
  SetGlobalStatus(FProjeto.RealizaDiagnostico);
end;

// Leitura -----------------------------------------------------------------------------
procedure TprDialogo_AreaDeProjeto.LerDoArquivo(Ini: TIF);
var s: String;
begin
  s := 'Area de Projeto';

  FBloqueado  := Ini.ReadBool    (s, 'Bloqueado', False);
{
  Left        := Ini.ReadInteger (s, 'x', Left);
  Top         := Ini.ReadInteger (s, 'y', Top);
  Width       := Ini.ReadInteger (s, 'Largura', Width);
  Height      := Ini.ReadInteger (s, 'Altura', Height);
}
  FMD         := Ini.ReadBool    (s, 'Mostrar Demandas', True);
  FMF         := Ini.ReadBool    (s, 'Mostrar Fundo', True);
  FMT         := Ini.ReadBool    (s, 'Mostrar Trechos', True);
  Caption     := Ini.FileName;

//  WindowState := TWindowState(Ini.ReadInteger (s, 'Estado Janela', ord(wsNormal)));
end;

// Salvamento --------------------------------------------------------------------------

procedure TprDialogo_AreaDeProjeto.SalvarEmArquivo(Ini: TIF);
var s: String;
begin
  beginSave();

  s := 'Area de Projeto';
  Ini.WriteBool    (s, 'Bloqueado', FBloqueado);
  Ini.WriteInteger (s, 'x', Left);
  Ini.WriteInteger (s, 'y', Top);
  Ini.WriteInteger (s, 'Largura', Width);
  Ini.WriteInteger (s, 'Altura', Height);
  Ini.WriteBool    (s, 'Mostrar Demandas', FMD);
  Ini.WriteBool    (s, 'Mostrar Fundo', FMF);
  Ini.WriteBool    (s, 'Mostrar Trechos', FMT);
  Ini.WriteInteger (s, 'Estado Janela', ord(WindowState));

  endSave();
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

procedure TprDialogo_AreaDeProjeto.Salvar();
begin
  SaveDialog.InitialDir := Applic.LastDir;

  if FProjeto.NomeArquivo <> '' then
     begin
     if ExtractFileExt(FProjeto.NomeArquivo) = '.prg' then
        FProjeto.NomeArquivo := changeFileExt(FProjeto.NomeArquivo, '.propagar');

     FProjeto.SaveToXML(FProjeto.NomeArquivo);
     end
  else
    if SaveDialog.Execute then
       begin
       Applic.LastDir := ExtractFilePath(SaveDialog.FileName);
       FProjeto.SaveToXML(SaveDialog.FileName);
       end;
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
     oldBrushColor := Canvas.Brush.color;
     oldPenColor   := Canvas.Pen.color;

     if Selecionar Then
        begin
        Canvas.Brush.color := clRed;
        Canvas.Pen.color   := clRed;
        end
     else
        begin
        Canvas.Brush.color := Self.Color;
        Canvas.Pen.color   := clBlack;
        end;

     if (FObjSel is TprPC) or
        (FObjSel is TprSubBacia) or
        (FObjSel is TprDemanda) or
        (FObjSel is TprCenarioDeDemanda) then
        begin
        R := THidroComponente(FObjSel).Rect;
        InflateRect(R, 2, 2);
        Canvas.FrameRect(R);
        end
     else
        if (FObjSel is TprTrechoDagua) then
           begin
           Canvas.Pen.Style := psSolid;
           TD := TprTrechoDagua(FObjSel);
           DesenhaSeta(Canvas, TD.PC_aMontante.Pos, TD.PC_aJusante.Pos, 15,
              DistanciaEntre2Pontos(TD.PC_aMontante.Pos, TD.PC_aJusante.Pos) div 2);
           end;

     Canvas.Brush.color := oldBrushColor;
     Canvas.Pen.color   := oldPenColor;
     end
end;

procedure TprDialogo_AreaDeProjeto.SetObjSel(const Value: THidroComponente);
const S1 = 'Selected Object: ';
begin
  DesenharSelecao(False);

  FObjSel := Value;
  if Value = nil then
     WriteStatus(gSB, [''], false)
  else
     begin
     WriteStatus(gSB, [S1 + Value.Nome], false);
     if MainForm.sbArrastar.Down then
        begin
        gMemo.Lines.Assign(Value.Comentarios);
        gDesc.Text := Value.Descricao;
        gNome.Text := Value.Nome;
        end;
     end;
   MainForm.AtualizaMenus(Value);

  DesenharSelecao(True);
end;

procedure TprDialogo_AreaDeProjeto.RemoverObjeto(Obj: THidroComponente);
begin
  if (Obj <> nil) and
     (FProjeto.Simulador = nil) and
     (MessageDLG('Confirm delete ?', mtConfirmation, [mbYES, mbNO], 0) = mrYES) then
     begin
     setObjSel(nil);
     if Obj is TprPC then
        if FProjeto.PCs.RemovePC(TprPC(Obj)) then
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
  FObjSel.MostrarDialogo();
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
  THidroComponente(FObjSel).MostraPlanilha;
end;

procedure TprDialogo_AreaDeProjeto.Menu_TodosClick(Sender: TObject);
begin
  TprPCP(FObjSel).GraficarTudo();
end;

{ Este método só tem sentido se usado após o Propagar DOS pois este programa calculará:
    - Defluência de cada PC
    - Demandas atendidas primárias, secundárias e terciárias
    - Demandas planejadas primárias, secundárias e terciárias
    - Energia Gerada dos Reservatórios
    - Volumes dos Reservatórios
  Depois o BalancoHídrico completará com o cálculo de:
    - Demandas totais primárias, secundárias e terciárias em cada PC
    - Afluência das Sub-Bacias em cada PC
    - Vazões de Montante em cada PC
}

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

procedure TprDialogo_AreaDeProjeto.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FFechando then
     CanClose := true
  else
     begin
     CanClose := MessageDLG(Format('Fechar o projeto <%s> ?', [FProjeto.Nome]),
       mtConfirmation, [mbYes, mbNo], 0) = mrYes;

     if CanClose Then FFechando := True;
     end;
end;

procedure TprDialogo_AreaDeProjeto.PC_TO_RES(PC: TprPCP);
var R: TprPCPR;
begin
  Gerenciador.RemoverObjeto(PC);
  R := PC.MudarParaReservatorio(Menu_PCPR);
  Gerenciador.AdicionarObjeto(R);

  FObjSel := nil;

  PC.AvisarQueVaiSeDestruir := False;
  FProjeto.PCs[FProjeto.PCs.IndiceDoPC(PC)] := R;
  PC.Free;

  FObjSel := R;

  DesenharRede;
  MainForm.AtualizaMenus(FObjSel);

  FProjeto.Modificado := True;
end;

procedure TprDialogo_AreaDeProjeto.RES_TO_PC(RES: TprPCPR);
var PC: TprPCP;
begin
  Gerenciador.RemoverObjeto(RES);
  PC := RES.MudarParaPC(Menu_PCP);
  Gerenciador.AdicionarObjeto(PC);

  FObjSel := nil;

  RES.AvisarQueVaiSeDestruir := False;
  FProjeto.PCs[FProjeto.PCs.IndiceDoPC(RES)] := PC;
  RES.Free;

  FObjSel := PC;

  DesenharRede;
  MainForm.AtualizaMenus(FObjSel);

  FProjeto.Modificado := True;
end;

procedure TprDialogo_AreaDeProjeto.Menu_PCP_MostrarDemandasClick(Sender: TObject);
var M: TMenuItem;
begin
  M := TMenuItem(Sender);
  M.Checked := not M.Checked;
  TprPCP(FObjSel).MostrarDemandas := M.Checked;
  DesenharRede;
end;

procedure TprDialogo_AreaDeProjeto.SetMD(const Value: Boolean);
var i: Integer;
begin
  FMD := Value;
  for i := 0 to FProjeto.PCs.PCs-1 do
    TprPCP(FProjeto.PCs[i]).MostrarDemandas := FMD;

  DesenharRede();
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

procedure TprDialogo_AreaDeProjeto.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
     RemoverObjeto(FObjSel);
end;

function TprDialogo_AreaDeProjeto.CriarMenu(Acao: TBasicAction): TMenuItem;
begin
  Result := TMenuItem.Create(nil);
  Result.Caption := TAction(Acao).Caption;
  Result.OnClick := TAction(Acao).OnExecute;
  Result.Tag := TAction(Acao).Tag;
  Result.Checked := TAction(Acao).Checked;
end;

function TprDialogo_AreaDeProjeto.CriarItemDeMenu(Raiz: TMenuItem; Texto: String; Evento: TNotifyEvent = nil): TMenuItem;
begin
  Result := TMenuItem.Create(nil);
  Result.Caption := Texto;
  Result.OnClick := Evento;
  Raiz.Add(Result);
end;

function TprDialogo_AreaDeProjeto.CriarItemDeMenu(Raiz: TMenuItem; Acao: TBasicAction): TMenuItem;
begin
  Result := CriarMenu(Acao);
  Raiz.Add(Result);
end;

function TprDialogo_AreaDeProjeto.CriarSubMenus(Raiz: TMenuItem; Acao: TBasicAction; CriarItem: boolean): TMenuItem;
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

procedure TprDialogo_AreaDeProjeto.Menu_CenarioDemandaPopup(Sender: TObject);
var CD   : TprCenarioDeDemanda;
    i    : Integer;
    act  : TContainedAction;
    Menu : TMenuItem;
begin
  CD := TprCenarioDeDemanda(FObjSel);

  Menu_CenarioDemanda.Items.Clear();
  FAcoes.Free;
  FAcoes := TActionList.Create(nil);
  CD.ObterAcoesDeMenu(FAcoes);

  CriarItemDeMenu(Menu_CenarioDemanda.Items, 'Editar', Menu_EditarClick);
  CriarItemDeMenu(Menu_CenarioDemanda.Items, '-');
  for i := 0 to FAcoes.ActionCount-1 do
    begin
    act := FAcoes[i];
    Menu := CriarItemDeMenu(Menu_CenarioDemanda.Items, act);
    CriarSubMenus(Menu, act, false);
    end;
end;

procedure TprDialogo_AreaDeProjeto.beginSave();
begin
  HorzScrollBar.Position := 0;
  VertScrollBar.Position := 0;
end;

procedure TprDialogo_AreaDeProjeto.endSave();
begin
  Caption := ' ' + FProjeto.NomeArquivo;
end;

procedure TprDialogo_AreaDeProjeto.toXML();
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

procedure TprDialogo_AreaDeProjeto.fromXML(no: IXMLDomNode);
begin
  FBloqueado  := strToBoolean(FProjeto.NextChild(no).text);
  FMD         := strToBoolean(FProjeto.NextChild(no).text);
  FMF         := strToBoolean(FProjeto.NextChild(no).text);
  FMT         := strToBoolean(FProjeto.NextChild(no).text);

  // Ignora o próximo nó: WindowState
  FProjeto.NextChild(no);

  Caption := FProjeto.NomeArquivo;
  VertScrollBar.Range := ClientHeight;
  HorzScrollBar.Range := ClientWidth;
end;

end.

