unit iphs1_AreaDeProjeto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ComCtrls, Menus,
  AreaDeProjeto_base,
  Hidro_Classes,
  iphs1_Classes, StdCtrls, ExtCtrls;

type
  Tiphs1_Form_AreaDeProjeto = class(TForm_AreaDeProjeto_base)
    Menu_PC: TPopupMenu;
    Menu_SB: TPopupMenu;
    Menu_PCR: TPopupMenu;
    Menu_SB_HidroRes: TMenuItem;
    Menu_PCR_HidroRes: TMenuItem;
    Menu_PC_HidroRes: TMenuItem;
    Menu_Der: TPopupMenu;
    Menu_Der_HidroRes: TMenuItem;
    Menu_TD: TPopupMenu;
    Menu_TD_HidroRes: TMenuItem;
    Menu_PC_MostrarHR_DosObjConectados: TMenuItem;
    Menu_PCR_MostrarHidrogramaResultanteDosObjetosConectados: TMenuItem;
    MenuSB_PlotarTabPrecip: TMenuItem;
    N6: TMenuItem;
    Menu_PC_ClonarObjeto: TMenuItem;
    Menu_PCR_ClonarObjeto: TMenuItem;
    N7: TMenuItem;
    Menu_PC_CopiarDados: TMenuItem;
    Menu_PCR_CopiarDados: TMenuItem;
    N8: TMenuItem;
    Menu_SB_CopiarDados: TMenuItem;
    N9: TMenuItem;
    Menu_DER_CopiarDados: TMenuItem;
    N10: TMenuItem;
    Menu_TD_CopiarDados: TMenuItem;
    Menu_PCR_VNA: TMenuItem;
    N2: TMenuItem;
    Menu_PCR_VerCotas: TMenuItem;
    Menu_PCR_PlotarCotas: TMenuItem;
    Menu_TD_PlotarCotas: TMenuItem;
    N1: TMenuItem;
    Menu_TD_VisCotas: TMenuItem;
    Menu_PC_PlotarVC: TMenuItem;
    PlotarVazoControlada1: TMenuItem;
    PlotarVazoControlada2: TMenuItem;
    PlotarVazoControlada3: TMenuItem;
    PlotarQRua1: TMenuItem;

    procedure Menu_SB_TabPrecip_Click(Sender: TObject);
    procedure Menu_SBPopup(Sender: TObject);
    procedure Menu_HidroRes_Click(Sender: TObject);
    procedure Menu_PC_Popup(Sender: TObject);
    procedure Menu_PCRPopup(Sender: TObject);
    procedure Menu_DerPopup(Sender: TObject);
    procedure Menu_TDPopup(Sender: TObject);
    procedure Menu_Perdas_x_PrecEfetivaClick(Sender: TObject);
    procedure Menu_PC_MostrarHR_DosObjConectadosClick(Sender: TObject);
    procedure MenuSB_PlotarTabPrecipClick(Sender: TObject);
    procedure Menu_MostrarHidrogramaResultanteClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Menu_PC_ClonarObjetoClick(Sender: TObject);
    procedure Menu_PCR_ClonarObjetoClick(Sender: TObject);
    procedure Menu_PC_CopiarDadosClick(Sender: TObject);
    procedure Menu_PCR_CopiarDadosClick(Sender: TObject);
    procedure Menu_SB_CopiarDadosClick(Sender: TObject);
    procedure Menu_DER_CopiarDadosClick(Sender: TObject);
    procedure Menu_TD_CopiarDadosClick(Sender: TObject);
    procedure Menu_PCR_VNAClick(Sender: TObject);
    procedure Menu_PCR_VerCotasClick(Sender: TObject);
    procedure Menu_PCR_PlotarCotasClick(Sender: TObject);
    procedure Menu_TD_PlotarCotasClick(Sender: TObject);
    procedure Menu_TD_VisCotasClick(Sender: TObject);
    procedure Menu_PlotarVC_Click(Sender: TObject);
    procedure PlotarQRua1Click(Sender: TObject);
  private
    procedure AtualizacaoVisualDoUsuario; override;
    function CriarProjeto(TN: TStrings): TProjeto; override;
    function CriarSubBaciaNoPC(Pos: TPoint; PC: TPC): TSubBacia; override;
    procedure ExecutarClick(Sender: TObject; p: TPoint; Obj: THidroComponente); override;
    function DesenharFrame(obj: THidroComponente): boolean; override;
    function CriarDerivacaoNoPC(PC: Tiphs1_PC): Tiphs1_Derivacao;
    function CriarSubBaciaNoTD(TD: Tiphs1_TrechoDagua): Tiphs1_SubBacia;
    procedure ConfigurarPC(PC: TPC);
  public
    function CriarPC(Pos: TPoint): TPC; override;
    function CriarReservatorio(Pos: TPoint): TPC; override;
    procedure PC_TO_RES(PC: Tiphs1_PC);
    procedure RES_TO_PC(RES: Tiphs1_PCR);

    // Retorna o trecho-dagua que possui o centro está próximo de p
    function AcharTrechoMaisProximo(const p: TPoint): Tiphs1_TrechoDagua;
  end;

implementation
uses WinUtils,
     Form_Chart,
     GraphicUtils,
     hidro_Variaveis,
     hidro_procs,
     VisaoEmArvore_base,
     iphs1_Tipos,
     iphs1_EscolherPC,
     iphs1_EscolherPCR,
     iphs1_EscolherSB,
     iphs1_EscolherDER,
     iphs1_EscolherTD,
     iphs1_Dialogo_Res_VisNivel,
     iphs1_Dialogo_TD_VisNivel,
     Main,
     iphs1_Constantes,
     LanguageControl;

{$R *.DFM}

{ Tiphs1_Form_AreaDeProjeto }

procedure Tiphs1_Form_AreaDeProjeto.ConfigurarPC(PC: TPC);
begin
  if PC is Tiphs1_PCR then
     PC.Menu := Menu_PCR
  else
     PC.Menu := Menu_PC;

  Projeto.PCs.Adicionar(PC);
end;

procedure Tiphs1_Form_AreaDeProjeto.AtualizacaoVisualDoUsuario;
var i: Integer;
    p: TPoint;
    r: TRect;
    PC: Tiphs1_PC;
    TD: Tiphs1_TrechoDagua;
begin
  inherited;
  for i := 0 to Projeto.PCs.PCs-1  do
    begin
    if (Projeto.PCs[i] is Tiphs1_PC) then
       begin
       PC := Tiphs1_PC(Projeto.PCs[i]);
       if PC.Derivacao <> nil then
          begin
          Canvas.Pen.Width := 2;
          Canvas.Pen.Style := psSolid;
          Canvas.Pen.Color := clRed;
          DesenharSeta(Canvas, PC.Pos, PC.Derivacao.Pos, 10,
            DistanciaEntre2Pontos(PC.Pos, PC.Derivacao.Pos) div 2);
          end;
       end;

    if Projeto.PCs[i].TrechoDagua <> nil then
       begin
       TD := Tiphs1_TrechoDagua(Projeto.PCs[i].TrechoDagua);
       if TD.SubBacia <> nil then
          begin
          Canvas.Pen.Width := 1;
          Canvas.Pen.Style := psDot;
          Canvas.Pen.Color := clBlack;
          p := CentroDaReta(TD.PC_aMontante.Pos, TD.PC_aJusante.Pos);
          Canvas.MoveTo(p.x, p.y);
          Canvas.LineTo(TD.SubBacia.Pos.x, TD.SubBacia.Pos.y);
          end
       end
    end;
end;

function Tiphs1_Form_AreaDeProjeto.CriarPC(Pos: TPoint): TPC;
begin
  Result := Tiphs1_PC.Create(Pos, Projeto, Projeto.TabNomes);
  ConfigurarPC(Tiphs1_PC(Result));
end;

function Tiphs1_Form_AreaDeProjeto.CriarDerivacaoNoPC(PC: Tiphs1_PC): Tiphs1_Derivacao;
begin
  Result := Tiphs1_Derivacao.Create(Projeto, Projeto.TabNomes);
  Result.ImagemDoComponente.Left  := PC.Pos.x + 30;
  Result.ImagemDoComponente.Top   := PC.Pos.y - 30;
  Result.Modificado := True;
  Result.Menu := Menu_Der;
  PC.ConectarObjeto(Result);
end;

function Tiphs1_Form_AreaDeProjeto.CriarProjeto(TN: TStrings): TProjeto;
begin
  Result := Tiphs1_Projeto.Create(TN);
end;

function Tiphs1_Form_AreaDeProjeto.CriarReservatorio(Pos: TPoint): TPC;
begin
  Result := Tiphs1_PCR.Create(Pos, Projeto, Projeto.TabNomes);
  ConfigurarPC(Result);
end;

function Tiphs1_Form_AreaDeProjeto.CriarSubBaciaNoPC(Pos: TPoint; PC: TPC): TSubBacia;
begin
  inc(Pos.x, 20); dec(Pos.y, 20);
  Result := Tiphs1_SubBacia.Create(Pos, Projeto, Projeto.TabNomes);
  Result.Modificado := True;
  Result.Menu := Menu_SB;
  PC.ConectarObjeto(Result);
end;

// Retorna o trecho-dagua que possui o centro mais próximo de p
function Tiphs1_Form_AreaDeProjeto.AcharTrechoMaisProximo(const p: TPoint): Tiphs1_TrechoDagua;
var i: Integer;
    c: TPoint;        // Centro da reta formada pelos dois PCs
    PCM: TPC;         // PC a Montante
    PCJ: TPC;         // PC a Jusante
    d1, d2: Integer;  // Distancias entre o centro da reta e o ponto Passado
begin
  d1 := 1000000;
  Result := nil;
  for i := 0 to Projeto.PCs.PCs - 1 do
    begin
    PCM := Projeto.PCs[i];
    if PCM.TrechoDagua <> nil then
       begin
       PCJ := PCM.TrechoDagua.PC_aJusante;
       c   := CentroDaReta(PCM.Pos, PCJ.Pos);
       d2  := DistanciaEntre2Pontos(c, p);
       if d2 < d1 then
          begin
          d1 := d2;
          Result := Tiphs1_TrechoDagua(PCM.TrechoDagua);
          end;
       end;
    end;
end;

procedure Tiphs1_Form_AreaDeProjeto.ExecutarClick(Sender: TObject; p: TPoint; Obj: THidroComponente);
var i: Integer;
    b: Boolean;
    TD: Tiphs1_TrechoDagua;
begin
  if Projeto.Simulador <> nil then
     Exit
  else

  // ------ DERIVACOES -------------------------------------------------------------------

  if MainForm.sbCriarDerivacao.Down and (Obj is Tiphs1_PC) then
     if Tiphs1_PC(Obj).Derivacao = nil then
        //if Tiphs1_PC(Obj).TrechoDagua = nil then
           begin
           AtualizandoTela(True);
           Obj := CriarDerivacaoNoPC(Tiphs1_PC(Obj));
           Gerenciador.AdicionarObjeto(Obj);
           WriteStatus(gSB, [LanguageManager.GetMessage(cMesID_IPH, 7){'Nome da Derivação criada: '} + Obj.Nome], false);
           Projeto.Modificado := True;
           AtualizandoTela(False);
           AtualizarTela();
           end
        //else
           //MessageDLG('Desculpe.'#13 +
             //         'Ainda não é permitida a criação de uma Derivação intermediária', mtInformation, [mbOk], 0)
     else
        MessageDLG(LanguageManager.GetMessage(cMesID_IPH, 8){'Já existe uma Derivação neste PC'}, mtInformation, [mbOK], 0)
  else

  // ------  SUB-BACIAS -------------------------------------------------------------------

  if MainForm.sbCriarSubBacia.Down and (Obj = nil) then
     begin
     TD := AcharTrechoMaisProximo(p);
     if TD <> nil then
        if TD.SubBacia = nil then
           begin
           AtualizandoTela(True);
           Obj := CriarSubBaciaNoTD(TD);
           Gerenciador.AdicionarObjeto(Obj);
           WriteStatus(gSB, [LanguageManager.GetMessage(cMesID_IPH, 9){'Nome da Sub-Bacia criada: '} + Obj.Nome], false);
           Projeto.Modificado := True;
           AtualizandoTela(False);
           AtualizarTela;
           end
        else
           MessageDLG(LanguageManager.GetMessage(cMesID_IPH, 10){'Já existe uma Sub-Bacia conectada a este Trecho-Dágua'}, mtInformation, [mbOK], 0)
     else
        MessageDLG(LanguageManager.GetMessage(cMesID_IPH, 11){
                   'Uma Sub-Bacia independente só pode ser'#13 +
                   'conectada a um Trecho-Dágua. Como não existem'#13 +
                   'Trechos-Dágua neste projeto foi impossível criar o Objeto.'},
                   mtInformation, [mbOK], 0);
     end
  else
     inherited;
end;

function Tiphs1_Form_AreaDeProjeto.DesenharFrame(obj: THidroComponente): boolean;
begin
  Result := obj is Tiphs1_Derivacao;
  if not Result then Result := Inherited DesenharFrame(obj);
end;

function Tiphs1_Form_AreaDeProjeto.CriarSubBaciaNoTD(TD: Tiphs1_TrechoDagua): Tiphs1_SubBacia;
var p: TPoint;
begin
  p := CentroDaReta(TD.PC_aMontante.Pos, TD.PC_aJusante.Pos);
  inc(p.x, 30); inc(p.y, 30);
  Result := Tiphs1_SubBacia.Create(p, Projeto, Projeto.TabNomes);
  Result.Menu := Menu_SB;
  TD.ConectarObjeto(Result);
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_SB_TabPrecip_Click(Sender: TObject);
begin
  Tiphs1_SubBacia(ObjetoSelecionado).MostrarTabPrecipitacao;
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_SBPopup(Sender: TObject);
var SB: Tiphs1_SubBacia;
begin
  SB := Tiphs1_SubBacia(ObjetoSelecionado);
  Menu_SB_HidroRes.Enabled := (SB.HidroRes <> nil);
  MenuSB_PlotarTabPrecip.Enabled := (SB.IB.Oper = coTCV) and (SB.TabPrecip <> nil);
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_HidroRes_Click(Sender: TObject);
begin
  ObjetoSelecionado.PlotarHidrogramaResultante();
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_PC_Popup(Sender: TObject);
begin
  Menu_PC_HidroRes.Enabled := (ObjetoSelecionado.HidroRes <> nil);
  Menu_PC_MostrarHR_DosObjConectados.Enabled := Menu_PC_HidroRes.Enabled;
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_PCRPopup(Sender: TObject);
begin
  Menu_PCR_HidroRes.Enabled := (ObjetoSelecionado.HidroRes <> nil);
  Menu_PCR_MostrarHidrogramaResultanteDosObjetosConectados.Enabled := Menu_PCR_HidroRes.Enabled;
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_DerPopup(Sender: TObject);
begin
  Menu_Der_HidroRes.Enabled := (ObjetoSelecionado.HidroRes <> nil);
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_TDPopup(Sender: TObject);
begin
  Menu_TD_HidroRes.Enabled := (ObjetoSelecionado.HidroRes <> nil);
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_Perdas_x_PrecEfetivaClick(Sender: TObject);
begin
  Tiphs1_SubBacia(ObjetoSelecionado).PlotarGrafico_Perdas_X_Efetiva;
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_PC_MostrarHR_DosObjConectadosClick(Sender: TObject);
begin
  Tiphs1_PC_Base(ObjetoSelecionado).PlotarHidrogramaResultanteDosObjConectados();
end;

procedure Tiphs1_Form_AreaDeProjeto.MenuSB_PlotarTabPrecipClick(Sender: TObject);
begin
  Tiphs1_SubBacia(ObjetoSelecionado).PlotarTabelaDePrecipitacoes;
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_MostrarHidrogramaResultanteClick(Sender: TObject);
begin
  ObjetoSelecionado.MostrarHidrogramaResultante;
end;

procedure Tiphs1_Form_AreaDeProjeto.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If key = VK_F1 then
     MostrarHTML('CriandoOperacoesHidrologicas.htm')
  else
  if (Key = VK_DELETE) and (ObjetoSelecionado <> nil) and
     (MessageDLG(LanguageManager.GetMessage(cMesID_IPH, 47){'Confirma a remoção ?'}, mtConfirmation, [mbYES, mbNO], 0) = mrYES) then
     RemoverObjeto(ObjetoSelecionado);
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_PC_ClonarObjetoClick(Sender: TObject);
var PC: Tiphs1_PC;
begin
  PC := Tiphs1_PC(ObjetoSelecionado.Clonar);
  ConfigurarPC(PC);
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_PCR_ClonarObjetoClick(Sender: TObject);
var PC: Tiphs1_PCR;
begin
  PC := Tiphs1_PCR(ObjetoSelecionado.Clonar);
  ConfigurarPC(PC);
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_PC_CopiarDadosClick(Sender: TObject);
var d: Tiphs1_Form_EscolherPC;
begin
  d := Tiphs1_Form_EscolherPC.Create(Projeto);
  if d.ShowModal = mrOK then
     if d.Temselecionado then
        d.Selecionado.CopiarDadosPara(ObjetoSelecionado);
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_PCR_CopiarDadosClick(Sender: TObject);
var d: Tiphs1_Form_EscolherPCR;
begin
  d := Tiphs1_Form_EscolherPCR.Create(Projeto);
  if d.ShowModal = mrOK then
     if d.TemSelecionado then
        d.Selecionado.CopiarDadosPara(ObjetoSelecionado);
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_SB_CopiarDadosClick(Sender: TObject);
var d: Tiphs1_Form_EscolherSB;
begin
  d := Tiphs1_Form_EscolherSB.Create(Projeto);
  if d.ShowModal = mrOK then
     if d.TemSelecionado then
        d.Selecionado.CopiarDadosPara(ObjetoSelecionado);
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_DER_CopiarDadosClick(Sender: TObject);
var d: Tiphs1_Form_EscolherDER;
begin
  d := Tiphs1_Form_EscolherDER.Create(Projeto);
  if d.ShowModal = mrOK then
     if d.TemSelecionado then
        d.Selecionado.CopiarDadosPara(ObjetoSelecionado);
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_TD_CopiarDadosClick(Sender: TObject);
var d: Tiphs1_Form_EscolherTD;
begin
  d := Tiphs1_Form_EscolherTD.Create(Projeto);
  if d.ShowModal = mrOK then
     if d.TemSelecionado then
        d.Selecionado.CopiarDadosPara(ObjetoSelecionado);
end;

procedure Tiphs1_Form_AreaDeProjeto.PC_TO_RES(PC: Tiphs1_PC);
var R: Tiphs1_PCR;
    Nome: String;
begin
  Nome := PC.Nome;
  Gerenciador.RemoverObjeto(PC);
  R := PC.MudarParaReservatorio(Menu_PCR);
  Gerenciador.AdicionarObjeto(R);

  ObjetoSelecionado := nil;

  PC.AvisarQueVaiSeDestruir := False;
  Projeto.PCs[Projeto.PCs.IndiceDo(PC)] := R;
  PC.Free;
  R.Nome := Nome;

  ObjetoSelecionado := R;

  AtualizarTela;
  MainForm.AtualizaMenus(ObjetoSelecionado);

  Projeto.Modificado := True;
end;

procedure Tiphs1_Form_AreaDeProjeto.RES_TO_PC(RES: Tiphs1_PCR);
var PC: Tiphs1_PC;
    Nome: String;
begin
  Nome := RES.Nome;
  Gerenciador.RemoverObjeto(RES);
  PC := RES.MudarParaPC(Menu_PC);
  Gerenciador.AdicionarObjeto(PC);

  ObjetoSelecionado := nil;

  RES.AvisarQueVaiSeDestruir := False;
  Projeto.PCs[Projeto.PCs.IndiceDo(RES)] := PC;
  RES.Free;
  PC.Nome := Nome;

  ObjetoSelecionado := PC;

  AtualizarTela;
  MainForm.AtualizaMenus(ObjetoSelecionado);

  Projeto.Modificado := True;
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_PCR_VNAClick(Sender: TObject);
begin
  if Tiphs1_PCR(ObjetoSelecionado).Cotas <> nil then
     with Tfoiphs1_Dialogo_Res_VisNivel.Create(Tiphs1_PCR(ObjetoSelecionado)) do
       begin
       ShowModal;
       Release;
       end;
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_PCR_VerCotasClick(Sender: TObject);
begin
  Tiphs1_PCR(ObjetoSelecionado).MostrarCotas;
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_PCR_PlotarCotasClick(Sender: TObject);
begin
  Tiphs1_PCR(ObjetoSelecionado).PlotarCotas();
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_TD_PlotarCotasClick(Sender: TObject);
begin
  Tiphs1_TrechoDagua(ObjetoSelecionado).PlotarCotas();
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_TD_VisCotasClick(Sender: TObject);
begin
  if Tiphs1_TrechoDagua(ObjetoSelecionado).Cotas <> nil then
     with Tfoiphs1_Dialogo_TD_VisNivel.Create(Tiphs1_TrechoDagua(ObjetoSelecionado)) do
       begin
       ShowModal;
       Release;
       end;
end;

procedure Tiphs1_Form_AreaDeProjeto.Menu_PlotarVC_Click(Sender: TObject);
begin
  ObjetoSelecionado.PlotarVazaoControlada;
end;

procedure Tiphs1_Form_AreaDeProjeto.PlotarQRua1Click(Sender: TObject);
begin
  Tiphs1_TrechoDagua(ObjetoSelecionado).PlotarQRua;
end;

end.
