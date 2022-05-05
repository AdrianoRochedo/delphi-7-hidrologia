unit pr_Form_AreaDeProjeto_BMP;

interface

uses
  Windows, StdCtrls, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs,
  pr_Form_AreaDeProjeto_Base,
  pr_Application,
  pr_Classes, ComCtrls, Menus;

type
  TScrollCanvas = class(TScrollBox)
  private
    FCanvas: TControlCanvas;
    FOnPaint: TNotifyEvent;
    function GetCanvas: TCanvas;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy(); override;

    property Canvas: TCanvas read GetCanvas;
    property OnPaint : TNotifyEvent read FOnPaint write FOnPaint;
  end;

  TfoAreaDeProjeto_BMP = class(TfoAreaDeProjeto_Base)
  private
    FScrollCanvas: TScrollCanvas;
    procedure PaintEvent(Sender: TObject);
  protected
    procedure BeginSave(); override;
    function CriarProjeto(TN: TStrings): TprProjetoOtimizavel; override;
    function ControleDaAreaDeDesenho(): TWinControl; override;
    function ClasseDaAreaDeDesenho(): TClass; override;
    function AreaDeDesenho(): TCanvas; override;
    procedure Atualizar(); override;
    procedure DesenharSelecao(Selecionar: Boolean); override;
    procedure DesenharRede(); override;
    procedure DesenharFundoDeTela(); override;
    procedure ExecutarDuploClick(Sender: TObject; Pos: TPoint); override;
    procedure ExecutarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure ExecutarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer); override;
    procedure ExecutarMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create();
    destructor Destroy(); override;
  end;

implementation
uses MessageManager,
     GraphicUtils,
     pr_Tipos,
     pr_Vars,
     pr_Const,
     pr_Funcoes,
     pr_Util;

{$R *.dfm}

{ TScrollCanvas }

constructor TScrollCanvas.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCanvas := TControlCanvas.Create;
  FCanvas.Control := Self;
end;

destructor TScrollCanvas.Destroy();
begin
  FCanvas.Free();
  inherited;
end;

procedure TScrollCanvas.WMPaint(var Message: TWMPaint);
begin
  inherited;
  if Assigned(FOnPaint) then FOnPaint(self);
end;

{ TfoAreaDeProjeto_BMP }

constructor TfoAreaDeProjeto_BMP.Create();
begin
  inherited Create();

  // Cria o "container" dos objetos visuais
  FScrollCanvas := TScrollCanvas.Create(nil);
  FScrollCanvas.Parent := self;
  FScrollCanvas.Align := alClient;
  FScrollCanvas.BorderStyle := bsNone;

  // Eventos
  FScrollCanvas.OnPaint := PaintEvent;
  FScrollCanvas.OnClick := Mouse_Click;
  FScrollCanvas.OnDblClick := Mouse_DuploClick;
  FScrollCanvas.OnMouseDown := Mouse_Down;
  FScrollCanvas.OnMouseMove := Mouse_Move;
  FScrollCanvas.OnMouseUp := Mouse_Up;
end;

destructor TfoAreaDeProjeto_BMP.Destroy();
begin
  // Remove sem destruir os componentes descendentes de "TdrBaseShape", isto
  // eh, remove os componentes que representam os elementos hidrologicos, se
  // estes componentes ficarem na tela, seu pai os destruirá automaticamente,
  // gerando um erro quando estes forem destruidos pelos objetos hidrologicos.
  RemoverComponentesVisuais();

  // Elimina o "container" criado manualmente.
  FScrollCanvas.Free();

  // Chama o anscendente
  inherited Destroy();
end;

// virtual
procedure TfoAreaDeProjeto_BMP.Atualizar();
begin
  DesenharRede();
end;

// virtual
function TfoAreaDeProjeto_BMP.AreaDeDesenho(): TCanvas;
begin
  result := FScrollCanvas.Canvas;
end;

// virtual
function TfoAreaDeProjeto_BMP.ClasseDaAreaDeDesenho(): TClass;
begin
  result := FScrollCanvas.ClassType;
end;

// virtual
function TfoAreaDeProjeto_BMP.ControleDaAreaDeDesenho(): TWinControl;
begin
  result := FScrollCanvas;
end;

// virtual
function TfoAreaDeProjeto_BMP.CriarProjeto(TN: TStrings): TprProjetoOtimizavel;
begin
  result := TprProjeto_ScrollCanvas.Create(TN);
end;

// virtual
procedure TfoAreaDeProjeto_BMP.DesenharFundoDeTela();
var c: TScrollCanvas;
    p: TprProjeto_ScrollCanvas;
begin
  p := TprProjeto_ScrollCanvas(Projeto);
  if p.Bmp <> nil then
     begin
     c := TScrollCanvas(ControleDaAreaDeDesenho);
     c.HorzScrollBar.Range := p.Bmp.Width;
     c.VertScrollBar.Range := p.Bmp.Height;
     AreaDeDesenho.Draw(-c.HorzScrollBar.Position,
                        -c.VertScrollBar.Position,
                         p.Bmp);
     end;
end;

// virtual
procedure TfoAreaDeProjeto_BMP.DesenharRede();
var i, j, k: Integer;
    p1, p2, p3, p4: TPoint;
    Ob1, Ob2: THidroComponente;
    PC: TprPC;
    c: TCanvas;

    procedure DrawLine(const p1, p2: TPoint);
    begin
      c.MoveTo(p1.x, p1.y);
      c.LineTo(p2.x, p2.y);
    end;

    procedure LigarDemandaAosCenarios(Obj: THidroComponente);
    var DM: TprDemanda;
        i: integer;
        p1, p2: TPoint;
    begin
      DM := TprDemanda(Obj);
      for i := 0 to DM.NumCenarios-1 do
        begin
        p1 := DM.ScreenPos;
        p2 := DM.Cenario[i].ScreenPos;
        DrawLine(p1, p2);
        end;
    end;

// DesenharRede
begin
  if not sem_AtualizarTela or FLendo then
     Exit;

  c := AreaDeDesenho;

  c.Pen.Color := clBlack;
  c.Brush.Color := Color;

  if (Projeto.ArqFundo <> '') and MostrarFundo then
     DesenharFundoDeTela()
  else
     c.FillRect(ControleDaAreaDeDesenho.ClientRect);

  for i := 0 to Projeto.PCs.PCs - 1 do
    begin
    c.Pen.Color := clBLACK;

    // Obtem a posicao na tela
    p1 := Projeto.PCs[i].ScreenPos;

    // Liga o PC montante ao PC jusante
    PC := Projeto.PCs[i].PC_aJusante;

    // Liga o ponto 1 ao ponto 2
    // Calcula o ponto 4 como sendo 15 unidades a frente do ponto 1
    if (PC <> nil) and MostrarTrechos then
       begin
       p2 := PC.ScreenPos;
       c.Pen.Style := psSolid;
       DesenhaSeta(c, p1, p2, 15, DistanciaEntre2Pontos(p1, p2) div 2);
       p4 := GraphicUtils.ObterPontoNaReta(p2, p1, 15);
       end;

    // Liga os objetos conectados ao PC com uma linha pontilhada
    c.Pen.Style := psDot;
    for j := 0 to Projeto.PCs[i].SubBacias - 1 do
      begin
      Ob1 := THidroComponente(Projeto.PCs[i].SubBacia[j]);
      if Ob1 <> nil then
         begin
         p2 := Ob1.ScreenPos;
         DrawLine(p1, p2);

         // Liga esta SubBacia a todas as suas demandas
         if TprPCP(Projeto.PCs[i]).MostrarDemandas then
            for k := 0 to TprSubBacia(ob1).Demandas - 1 do
              begin
              Ob2 := TprSubBacia(ob1).Demanda[k];
              if Ob2 <> nil then
                 begin
                 p3 := Ob2.ScreenPos;
                 DrawLine(p2, p3);
                 end;
              LigarDemandaAosCenarios(Ob2);
              end; //for k ... --> para todas as demandas
         end; //if ob1 <> nil ... --> ob1 = SubBacia
      end; // for j ... --> para todas as SubBacia

    // Conecta as demandas
    if TprPCP(Projeto.PCs[i]).MostrarDemandas then
       for j := 0 to Projeto.PCs[i].Demandas - 1 do
         begin
         Ob1 := THidroComponente(Projeto.PCs[i].Demanda[j]);
         if Ob1 <> nil then
            begin
            p2 := Ob1.ScreenPos;
            DrawLine(p1, p2);
            end;
         LigarDemandaAosCenarios(Ob1);
         end;

    // Conecta as descargas
    for j := 0 to Projeto.PCs[i].Descargas - 1 do
      begin
      Ob1 := THidroComponente(Projeto.PCs[i].Descarga[j]);
      if Ob1 <> nil then
         begin
         p2 := Ob1.ScreenPos;
         DrawLine(p1, p2);
         end;
      end;

    // Conecta as QAs
    Ob1 := THidroComponente(Projeto.PCs[i].QualidadeDaAgua);
    if Ob1 <> nil then
       begin
       p2 := Ob1.ScreenPos;
       c.Pen.Color := clRED;
       if (Projeto.PCs[i].PC_aJusante <> nil) and MostrarTrechos then
          begin
          DrawLine(p4, p2);
          c.Pen.Style := psSolid;
          c.Ellipse(p4.X - 3, p4.Y - 3, p4.X + 3, p4.Y + 3);
          end
       else
          DrawLine(p1, p2);
       end;
    end; // para todos os PCs

  DesenharSelecao(True);

  // Força o desenho de cada objeto
  GetMessageManager.SendMessage(UM_REPINTAR_OBJETO, [Self]);
end;

// virtual
procedure TfoAreaDeProjeto_BMP.DesenharSelecao(Selecionar: Boolean);
var oldBrushColor: TColor;
    oldPenColor  : TColor;
    R            : TRect;
    TD           : TprTrechoDagua;
    p1, p2       : TPoint;
    c            : TCanvas;
begin

  // desenha a seleção do obj. selecionado, se existe algum.
  if (ObjetoSelecionado <> nil) then
     begin
     c := AreaDeDesenho;

     oldBrushColor := c.Brush.color;
     oldPenColor   := c.Pen.color;

     if Selecionar Then
        begin
        c.Brush.color := clRed;
        c.Pen.color   := clRed;
        end
     else
        begin
        c.Brush.color := Self.Color;
        c.Pen.color   := clBlack;
        end;

     if DesenharFrame(ObjetoSelecionado) then
        begin
        R := THidroComponente(ObjetoSelecionado).ScreenArea;
        InflateRect(R, 2, 2);
        c.FrameRect(R);
        end
     else
        if (ObjetoSelecionado is TprTrechoDagua) then
           begin
           c.Pen.Style := psSolid;
           TD := TprTrechoDagua(ObjetoSelecionado);
           p1 := TD.PC_aMontante.ScreenPos;
           p2 := TD.PC_aJusante.ScreenPos;
           DesenhaSeta(c, p1, p2, 15, DistanciaEntre2Pontos(p1, p2) div 2);
           end;

     c.Brush.color := oldBrushColor;
     c.Pen.color   := oldPenColor;
     end;
end;

// virtual
procedure TfoAreaDeProjeto_BMP.ExecutarDuploClick(Sender: TObject; Pos: TPoint);
var i   : Integer;
    c   : TPoint;
    TD  : TprTrechoDagua;
begin
  // Verifica se o Duplo clique foi em um Trecho Dagua
  for i := 0 to Projeto.PCs.PCs - 1 do
    if Projeto.PCs[i].TrechoDagua <> nil then
       begin
       TD := Projeto.PCs[i].TrechoDagua;
       c := CentroDaReta(TD.PC_aMontante.ScreenPos, TD.PC_aJusante.ScreenPos);
       if DistanciaEntre2Pontos(Pos, c) < 05 {Pixels} then
          begin
          TD.Editar();
          Exit;
          end;
       end;

  // Se o clique não foi no Trecho Dagua é porque foi na janela
  Projeto.Editar();

  // Notifica possível mudança de status
  if Assigned(FOnMessage) then
     FOnMessage('Atualizar Opcoes', self);
end;

// virtual
procedure TfoAreaDeProjeto_BMP.ExecutarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
     if FOnGetButtonStatus('Arrastar') then
        if Sender = ControleDaAreaDeDesenho() then
           //...
        else
           if not Bloqueado then
              begin
              FDeslocamento := Point(X, Y);
              FArrastando := True;
              FPosAnterior := TControl(Sender).ScreenToClient(FDeslocamento);
              AreaDeDesenho.Pen.Mode := pmXor;
              end
           else
              // nada
     else
       //nada
  else
     if Sender = ControleDaAreaDeDesenho() then
        //...
     else
        begin
        SelecionarObjeto(Sender);
        MostrarMenu(ObjetoSelecionado);
        end;
end;

// virtual
procedure TfoAreaDeProjeto_BMP.ExecutarMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if FArrastando and (Sender <> ControleDaAreaDeDesenho()) then
     DesenharDeslocamentoDoComponente(Sender);
end;

// virtual
procedure TfoAreaDeProjeto_BMP.ExecutarMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var sp: TPoint;
begin
  if Button = mbLeft then
     begin
     SelecionarObjeto(Sender);
     if FOnGetButtonStatus('Arrastar') then
        if (Sender <> ControleDaAreaDeDesenho()) and not Bloqueado then
           begin
           FArrastando := False;
           AreaDeDesenho.Pen.Mode := pmCopy;
           sp := ControleDaAreaDeDesenho.ScreenToClient(Mouse.CursorPos);
           if sp.x < 2 then sp.x := 2;
           if sp.y < 2 then sp.y := 2;
           ObjetoSelecionado.Pos := Projeto.PointToMapPoint(sp);
           Atualizar();
           end;
     end;
end;

function TScrollCanvas.GetCanvas: TCanvas;
begin
  result := FCanvas;
end;

procedure TfoAreaDeProjeto_BMP.BeginSave();
var c: TScrollCanvas;
begin
  c := TScrollCanvas(ControleDaAreaDeDesenho);
  c.HorzScrollBar.Position := 0;
  c.VertScrollBar.Position := 0;
end;

procedure TfoAreaDeProjeto_BMP.PaintEvent(Sender: TObject);
begin
  Atualizar();
end;

end.
