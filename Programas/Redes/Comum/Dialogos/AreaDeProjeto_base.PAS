unit AreaDeProjeto_base;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls, ComCtrls, Dialogs, Menus,
     Hidro_Classes,
     Hidro_Tipos,
     Dialogo_Projeto, ExtCtrls;

type
  TForm_AreaDeProjeto_base = class(TForm)
    SaveDialog: TSaveDialog;
    Progresso: TProgressBar;
    paMensagemInicial: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Image2: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Image3: TImage;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Image4: TImage;
    Label11: TLabel;
    Label12: TLabel;
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
    procedure Form_Deactivate(Sender: TObject);
    procedure Form_CloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Form_Resize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FProjeto             : TProjeto;
    gOldPos              : TPoint;
    gDesloc              : TPoint;
    Arrastando           : Boolean;
    Fpc1                 : TPC;
    FSB                  : TSubBacia;
    FObjSel              : THidroComponente;
    FTN                  : TStrings;
    FGO_NA               : TSetByte;
    FPerguntar_TemCerteza: Boolean;
    FFechando            : Boolean;
    FBloqueado           : Boolean;
    FMT                  : Boolean;
    FMF                  : Boolean;
    FLendo               : Boolean;
    sem_AtualizarTela    : Boolean;   // Semáforo de atualização de tela

    {$IFDEF DEBUG}
    i_AtualizarTela : Integer;
    FMD             : Boolean;
    {$ENDIF}

    function ObtemObjetoAssociado(Sender: TObject): THidroComponente;
    procedure SetObjSel(const Value: THidroComponente);
    procedure SelecionarObjeto(sender: TObject; Selecionar: Boolean = TRUE);

    // Desenha o Frame no objeto selecionado
    procedure DesenharSelecao(Selecionar: Boolean);
  protected
    // Torna possível a persoanalização da atualização da tela
    procedure AtualizacaoVisualDoUsuario; virtual;

    // Verifica se um Frame pode ser desenhado no objeto passado
    function DesenharFrame(obj: THidroComponente): boolean; virtual;

    // Desenha as linhas de conexão entre os objetos
    // Conecta PCs a PCs e PCs a SubBacias
    procedure ConectarObjetos; virtual;

    // Dispara um evento de click em um dos objetos, inclusive a própria Área De Projeto
    procedure ExecutarClick(Sender: TObject; p: TPoint; Obj: THidroComponente); virtual;

    // Cria os objetos abaixo, deverá ser sobreescrito em cada descendente
    function CriarProjeto(TN: TStrings): TProjeto; virtual; abstract;
    function CriarPC(Pos: TPoint): TPC; virtual; abstract;
    function CriarReservatorio(Pos: TPoint): TPC; virtual; abstract;
    function CriarSubBaciaNoPC(Pos: TPoint; PC: TPC): TSubBacia; virtual; abstract;
  public
    procedure AtualizarTela;
    procedure MostraFundo;
    procedure RemoverObjeto(Obj: THidroComponente);
    procedure AtualizandoTela(Atualizando: Boolean);

    procedure Salvar;

    // Salva e recupera as propriedades relativas as Área de Projeto
    procedure SalvarEmArquivo(Ini: TIF); virtual;
    procedure LerDoArquivo(Ini: TIF); virtual;

    property  Perguntar_TemCerteza: Boolean
         read FPerguntar_TemCerteza
        write FPerguntar_TemCerteza;

    property  MostrarFundo       : Boolean                read FMF          write FMF;
    property  MostrarTrechos     : Boolean                read FMT          write FMT;

    property  Bloqueado          : Boolean                read FBloqueado   write FBloqueado;
    property  ObjetoSelecionado  : THidroComponente       read FObjSel      write SetObjSel;
    property  TabelaDeNomes      : TStrings               read FTN;
    property  GO_NosAbertos      : TSetByte               read FGO_NA       write FGO_NA;
    property  Projeto            : TProjeto               read FProjeto;

    // Avisa que a área de projeto está em processo de leitura
    property  Lendo : Boolean read FLendo write FLendo;
  end;

implementation
uses SysUtils, WinUtils, Rochedo.Simulators.Shapes, FileCtrl
     ,{$IFDEF DEBUG} uDEBUG, {$ENDIF}
     MessageManager,
     Hidro_Constantes,
     Hidro_Variaveis,
     Hidro_Procs,
     iphs1_Procs,
     MAIN,
     GraphicUtils,
     MessagesForm,
     VisaoEmArvore_base;

{$R *.DFM}

procedure TForm_AreaDeProjeto_base.SelecionarObjeto(Sender: TObject; Selecionar: Boolean = TRUE);
var Obj: THidroComponente;
    p, c: TPoint;
    TD: TTrechoDagua;
    i: Integer;
begin
  if Sender = nil then
     ObjetoSelecionado := nil
  else
     begin
     //??? implementar interface nas MainForms --> BotaoEstaPrecionado(nomeBotao)
     if MainForm.sbCriarTrecho.Down or
        MainForm.sbCriarPC.Down or
        MainForm.sbCriarSubBacia.Down then Exit;

     if Sender is TForm then
        begin
        p := ScreenToClient(Mouse.CursorPos);
        for i := 0 to Projeto.PCs.PCs - 1 do
          if Projeto.PCs[i].TrechoDagua <> nil then
             begin
             TD := Projeto.PCs[i].TrechoDagua;
             c  := CentroDaReta(TD.PC_aMontante.Pos, TD.PC_aJusante.Pos);
             if DistanciaEntre2Pontos(p, c) < 20 {Pixels} then
                begin
                SelecionarObjeto(TD, True);
                Gerenciador.SelecionarObjeto(TD);
                Exit;
                end;
             end;

        ObjetoSelecionado := nil;
        WriteStatus(gSB, ['Objeto selecionado: Janela de Projeto'], false);
        gMemo.Text := FProjeto.Comentarios.Text;
        gDesc.Text := FProjeto.Descricao;
        gNome.Text := FProjeto.Nome;
        end
     else
        if Selecionar then
           begin
           ObjetoSelecionado := ObtemObjetoAssociado(Sender);
           Gerenciador.SelecionarObjeto(ObjetoSelecionado);
           end;
     end;
{
  ???
  if not MainForm.sbCriarDemanda.Down then
     Gerenciador.SelecionarObjeto(ObjetoSelecionado);
}
end;

procedure TForm_AreaDeProjeto_base.Form_Close(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TForm_AreaDeProjeto_base.Form_Click(Sender: TObject);
var p: TPoint;
begin
  {$IFDEF DEBUG}
  gDebug.Write('Entrando: Form_Click');
  {$ENDIF}

  if paMensagemInicial <> nil then
     begin
     self.RemoveControl(paMensagemInicial);
     paMensagemInicial := nil;
     end;

  FProjeto.VerificarSeSalvo();   

  GetCursorPos(p);
  p := ScreenToClient(p);

  ExecutarClick(Sender, p, ObtemObjetoAssociado(Sender));

  {$IFDEF DEBUG}
  gDebug.Write('Saindo: Form_Click');
  {$ENDIF}
end;

procedure TForm_AreaDeProjeto_base.Form_Dbl_Click(Sender: TObject);
var p, c : TPoint;
    i    : Integer;
    TD   : TTrechoDagua;
begin
  if FProjeto.Simulador <> nil then Exit;

  // Verifica se o Duplo clique foi em um Trecho Dagua
  p := ScreenToClient(Mouse.CursorPos);
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

procedure TForm_AreaDeProjeto_base.Form_MouseDown(Sender: TObject; Button: TMouseButton;
                                        Shift: TShiftState; X, Y: Integer);
var p, c: TPoint;
    TD: TTrechoDagua;
    i: Integer;
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
           SelecionarObjeto(Sender, False);
           Canvas.Pen.Width := 1;
           canvas.Pen.Mode := pmXor;
           end
     else
       //nada
  else
     if Sender is TForm then
        begin
        p := Point(x, y);
        for i := 0 to Projeto.PCs.PCs - 1 do
          if Projeto.PCs[i].TrechoDagua <> nil then
             begin
             TD := Projeto.PCs[i].TrechoDagua;
             c  := CentroDaReta(TD.PC_aMontante.Pos, TD.PC_aJusante.Pos);
             if DistanciaEntre2Pontos(p, c) < 20 {Pixels} then
                begin
                SelecionarObjeto(TD, True);
                Gerenciador.SelecionarObjeto(TD);
                TD.MostrarMenu(Mouse.CursorPos.x, Mouse.CursorPos.y);
                Exit;
                end;
             end;

         // Mostra o Menu da Janela se existir
        end
     else
        begin
        SelecionarObjeto(Sender, True);
        ObjetoSelecionado.MostrarMenu;
        end;
end;

procedure TForm_AreaDeProjeto_base.Form_MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
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

procedure TForm_AreaDeProjeto_base.Form_MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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
              ObjetoSelecionado.Modificado := True;
              TControl(Sender).Left := p.x;
              TControl(Sender).Top  := p.y;
              sem_AtualizarTela := True;
              end;

           canvas.Pen.Mode := pmCopy;
           AtualizarTela;
           end;
     end;
end;

procedure TForm_AreaDeProjeto_base.Form_Create(Sender: TObject);
begin
  Caption  := ' SEM NOME';
  FMT      := True;
  FMF      := True;

  FTN := TStringList.Create; // Tabela de Nomes
  TStringList(FTN).Sorted := true;

  FProjeto := CriarProjeto(FTN);
  FProjeto.AreaDeProjeto := Self;

  FPerguntar_TemCerteza := True;
  sem_AtualizarTela     := True;
end;

procedure TForm_AreaDeProjeto_base.Form_Destroy(Sender: TObject);
var i : Integer;
begin
  WriteStatus(gSB, [''], false); // limpa a barra de Status
  gMemo.Clear;            // limpa a barra de comentários
  gDesc.Clear;            // limpa a barra de descrição
  gNome.Clear;            // limpa a barra de nome

  FProjeto.Free;
  FTN.Free;               // eliminar a tabela de nomes por último

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
end;

procedure TForm_AreaDeProjeto_base.MostraFundo();
begin
  HorzScrollBar.Range := FProjeto.FundoBmp.Width;
  VertScrollBar.Range := FProjeto.FundoBmp.Height;
  Canvas.Draw(-HorzScrollBar.Position, -VertScrollBar.Position, FProjeto.FundoBmp)
end;

procedure TForm_AreaDeProjeto_base.AtualizarTela;
begin
  if not sem_AtualizarTela or FLendo then Exit;

  {$IFDEF DEBUG}
  gDebug.Write('AtualizarTela');
  {$ENDIF}

  Canvas.Pen.Width := 1;
  Canvas.Pen.Color := clBlack;
  Canvas.Brush.Color := Color;

  if (FProjeto.ArqFundo <> '') and FMF then
     MostraFundo
  else
     Canvas.FillRect(ClientRect);

  ConectarObjetos;
  AtualizacaoVisualDoUsuario;
  DesenharSelecao(True);

  // Força o desenho de cada objeto
  GetMessageManager.SendMessage(UM_REPINTAR_OBJETO, [Self]);
end;

procedure TForm_AreaDeProjeto_base.Form_Paint(Sender: TObject);
begin
  {$IFDEF DEBUG}
  gDebug.Write('PAINT');
  {$ENDIF}

  AtualizarTela;
end;

function TForm_AreaDeProjeto_base.ObtemObjetoAssociado(Sender: TObject): THidroComponente;
begin
  Result := nil;
  if (Sender is TdrBaseShape) or (Sender is TImage) then
     Result := THidroComponente(TComponent(Sender).Tag)
  else
  if Sender is TTrechoDagua then
     Result := TTrechoDagua(Sender);
end;

procedure TForm_AreaDeProjeto_base.Form_Activate(Sender: TObject);
begin
  if FFechando then Exit;
  MainForm.sbArrastar.Down := True;
  SetObjSel(FProjeto);
  Gerenciador.AreaDeProjeto := Self;
  SetGlobalStatus(FProjeto.RealizarDiagnostico);
end;

// Leitura -----------------------------------------------------------------------------
procedure TForm_AreaDeProjeto_base.LerDoArquivo(Ini: TIF);
var s: String;
begin
  s := 'Area de Projeto';
  FBloqueado := Ini.ReadBool    (s, 'Bloqueado', False);
  FMF        := Ini.ReadBool    (s, 'Mostrar Fundo', True);
  FMT        := Ini.ReadBool    (s, 'Mostrar Trechos', True);

  Caption := ' ' + Ini.FileName;
end;

// Salvamento --------------------------------------------------------------------------

procedure TForm_AreaDeProjeto_base.SalvarEmArquivo(Ini: TIF);
var s: String;
begin
  s := 'Area de Projeto';

  HorzScrollBar.Position := 0;
  VertScrollBar.Position := 0;

  Ini.WriteBool   (s, 'Bloqueado', FBloqueado);
  Ini.WriteBool   (s, 'Mostrar Fundo', FMF);
  Ini.WriteBool   (s, 'Mostrar Trechos', FMT);

  Caption := ' ' + Ini.FileName;
end;

procedure TForm_AreaDeProjeto_base.Salvar();
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

procedure TForm_AreaDeProjeto_base.DesenharSelecao(Selecionar: Boolean);
var oldBrushColor: TColor;
    oldPenColor  : TColor;
    R            : TRect;
    TD           : TTrechoDagua;
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

     if DesenharFrame(FObjSel) then
        begin
        R := THidroComponente(FObjSel).Regiao;
        InflateRect(R, 2, 2);
        Canvas.FrameRect(R);
        end
     else
        if (FObjSel is TTrechoDagua) then
           begin
           Canvas.Pen.Width := 1;
           Canvas.Pen.Style := psSolid;
           TD := TTrechoDagua(FObjSel);
           DesenharSeta(Canvas, TD.PC_aMontante.Pos, TD.PC_aJusante.Pos, 15,
              DistanciaEntre2Pontos(TD.PC_aMontante.Pos, TD.PC_aJusante.Pos) div 2);
           end;

     Canvas.Brush.color := oldBrushColor;
     Canvas.Pen.color   := oldPenColor;
     end
end;

procedure TForm_AreaDeProjeto_base.Form_Deactivate(Sender: TObject);
begin
  //MainForm.sbArrastar.Down := True;
end;

procedure TForm_AreaDeProjeto_base.SetObjSel(const Value: THidroComponente);
const S1 = 'Objeto selecionado: ';
begin
  DesenharSelecao(False);

  FObjSel := Value;
  if Value = nil then
     WriteStatus(gSB, [''], false)
  else
     begin
     WriteStatus(gSB, [S1 + Value.Nome], false);
     //??? implementar interface nas MainForms --> BotaoEstaPrecionado(nomeBotao)
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

procedure TForm_AreaDeProjeto_base.RemoverObjeto(Obj: THidroComponente);
begin
  if FProjeto.Simulador <> nil then Exit;

  ObjetoSelecionado := nil;

  if Obj is TPC then
     if FProjeto.PCs.Remover(TPC(Obj)) then
        Gerenciador.Atualizar
     else
        Exit
  else
     if Obj is TTrechoDagua then
        begin
        Gerenciador.RemoverObjeto(Obj);
        TTrechoDagua(obj).PC_aMontante.RemoverTrecho();
        end
  else
     begin
     getMessageManager.SendMessage(UM_OBJETO_SE_DESTRUINDO, [Obj]);
     Gerenciador.RemoverObjeto(Obj);
     Obj.Free;
     end;

  Repaint;
  FProjeto.Modificado := True;
end;

procedure TForm_AreaDeProjeto_base.Form_CloseQuery(Sender: TObject; var CanClose: Boolean);
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

function TForm_AreaDeProjeto_base.DesenharFrame(obj: THidroComponente): boolean;
begin
  Result := (obj is TPC) or (obj is TSubBacia);
end;

procedure TForm_AreaDeProjeto_base.ConectarObjetos;
var i, j, k: Integer;
    p1, p2: TPoint;
    Ob, Ob2: THidroComponente;
    PC: TPC;
begin
  for i := 0 to FProjeto.PCs.PCs - 1 do
    begin
    // Liga o PC montante ao PC jusante
    PC := FProjeto.PCs[i].PC_aJusante;

    if (PC <> nil) and FMT then
       begin
       Canvas.Pen.Width := 1;
       Canvas.Pen.Style := psSolid;
       DesenharSeta(
          Canvas,
          FProjeto.PCs[i].Pos,
          PC.Pos,
          15,
          DistanciaEntre2Pontos(FProjeto.PCs[i].Pos, PC.Pos) div 2
          );
       end;

    // Liga os objetos conectados ao PC com uma linha pontilhada
    Canvas.Pen.Width := 1;
    Canvas.Pen.Style := psDot;
    for j := 0 to FProjeto.PCs[i].SubBacias - 1 do
      begin
      Ob := THidroComponente(FProjeto.PCs[i].SubBacia[j]);
      if Ob <> nil then
         begin
         Canvas.MoveTo(FProjeto.PCs[i].Pos.x, FProjeto.PCs[i].Pos.y);
         Canvas.LineTo(Ob.Pos.x, Ob.Pos.y);
         end; //if ob <> nil ... --> ob = SubBacia
      end; // for j ... --> para todas as SubBacia
    end; // para todos os PCs
end;

procedure TForm_AreaDeProjeto_base.ExecutarClick(Sender: TObject; p: TPoint; Obj: THidroComponente);
var PC: TPC;
begin
  if not MainForm.sbSB_em_PC.Down then FSB := nil;

//---------------- Clicks na Janela -------------------------------------------------

  if MainForm.sbArrastar.Down then
     SelecionarObjeto(Self)
  else

  if FProjeto.Simulador <> nil then
     Exit
  else

  if MainForm.sbCriarPC.Down or MainForm.sbPCReservatorio.Down then
     begin
     sem_AtualizarTela := False;

     if MainForm.sbCriarPC.Down then
        Obj := CriarPC(p) //Obj := FProjeto.PCs.CriaPC(i, p, FProjeto, FTN, Menu_PCP);
     else
        Obj := CriarReservatorio(p); //Obj := FProjeto.PCs.CriaReservatorio(i, p, FProjeto, FTN, Menu_PCPR);

     Gerenciador.AdicionarObjeto(Obj);
     WriteStatus(gSB, ['Nome do PC criado: ' + Obj.Nome], false);
     FProjeto.Modificado := True;
     sem_AtualizarTela := True;
     end else

//---------------- Clicks em um PC de Controle -----------------------------------

  if MainForm.sbCriarSubBacia.Down and (Obj is TPC) then
     begin
     sem_AtualizarTela := False;
     Obj := CriarSubBaciaNoPC(p, TPC(Obj)); //Obj := CriaSubBacia(p, FProjeto, Obj);
     Gerenciador.AdicionarObjeto(Obj);
     WriteStatus(gSB, ['Nome da Sub-Bacia criada: ' + Obj.Nome], false);
     FProjeto.Modificado := True;
     sem_AtualizarTela := True;
     AtualizarTela;
     end else

  if MainForm.sbSB_em_PC.Down then
     begin
     if Obj is TSubBacia then FSB := TSubBacia(Obj);
     if (Obj is TPC) and (FSB <> nil) then
        begin
        TPC(Obj).ConectarObjeto(FSB);
        AtualizarTela;
        FSB := nil;
        FProjeto.Modificado := True;
        end;
     end else

  if MainForm.sbCriarTrecho.Down and (Obj is TPC) then
     begin
     if Fpc1 = nil then
        begin
        Fpc1 := TPC(Obj);

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
              Fpc1.ConectarObjeto(Obj);
              Gerenciador.AdicionarObjeto(Fpc1.TrechoDagua);
              AtualizarTela;
              FProjeto.PCs.CalcularHierarquia;
              Fpc1 := nil;
              FProjeto.Modificado := True;
              end
           else
              begin
              ShowMessage(Format(cMsgErro06, [Obj.Nome, Fpc1.Nome]));
              Fpc1 := nil;
              end;
     end else

  if MainForm.sbInserirPCEntre.Down and (Obj is TPC) then
     begin
     if (Fpc1 = nil) then
        begin
        Fpc1 := TPC(Obj);
        if Fpc1.TrechoDagua <> nil then
           begin
           ShowMessage(cMsgAjuda06);
           WriteStatus(gSB, [Format(cMsgStatus04, [Fpc1.Nome]), cMsgStatus05], false);
           end
        else
           begin
           WriteStatus(gSB, [Format(cMsgErro02, [Fpc1.Nome])], false);
           Fpc1 := nil;
           end;
        end
     else
        if Obj = Fpc1.PC_aJusante then
           begin
           ShowMessage('');
           WriteStatus(gSB, [Format(cMsgStatus06, [Fpc1.Nome, Obj.Nome])], false);

           Gerenciador.RemoverObjeto(Fpc1.TrechoDagua);
           Fpc1.RemoverTrecho;

           p := Point( (Fpc1.Pos.x + Obj.Pos.x) div 2, (Fpc1.Pos.y + Obj.Pos.y) div 2);
           PC := CriarPC(p); //PC := FProjeto.PCs.CriaPC(i, p, FProjeto, FTN, Menu_PCP);
           Gerenciador.AdicionarObjeto(PC);

           Fpc1.ConectarObjeto(PC); Gerenciador.AdicionarObjeto(Fpc1.TrechoDagua);
           PC.ConectarObjeto(Obj);  Gerenciador.AdicionarObjeto(PC.TrechoDagua);

           AtualizarTela;
           FProjeto.PCs.CalcularHierarquia;
           Fpc1 := nil;
           FProjeto.Modificado := True;
           end
        else
           WriteStatus(gSB,
             [
             Format(cMsgStatus04, [Fpc1.Nome]),
             Format(cMsgErro01, [Obj.Nome, Fpc1.Nome])
             ], false);
     end;
end;

procedure TForm_AreaDeProjeto_base.AtualizandoTela(Atualizando: Boolean);
begin
  sem_AtualizarTela := not Atualizando;
end;

procedure TForm_AreaDeProjeto_base.AtualizacaoVisualDoUsuario;
begin
  // Nada neste nível
end;

procedure TForm_AreaDeProjeto_base.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
     RemoverObjeto(FObjSel);
end;

procedure TForm_AreaDeProjeto_base.Form_Resize(Sender: TObject);
begin
  if paMensagemInicial <> nil then
     begin
     paMensagemInicial.Top := ClientHeight div 2 - paMensagemInicial.Height div 2;
     paMensagemInicial.Left := ClientWidth div 2 - paMensagemInicial.Width div 2;
     end;
end;

procedure TForm_AreaDeProjeto_base.FormShow(Sender: TObject);
begin
  if Height < 265 then Height := 265;
  if Width < 308 then Width := 308;
  Resize();
end;

end.

