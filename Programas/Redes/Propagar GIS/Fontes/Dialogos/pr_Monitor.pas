unit pr_Monitor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, TeeProcs, TeEngine, Chart, ExtCtrls,
  pr_Classes, StdCtrls, drEdit, Menus;

type
  TDLG_Monitor = class(TForm)
    pa_Ferramentas: TPanel;
    Grafico: TChart;
    sbOpt: TSpeedButton;
    rbLinhas: TRadioButton;
    rbBarras: TRadioButton;
    cb3D: TCheckBox;
    Label1: TLabel;
    edPausa: TdrEdit;
    sbPausar: TSpeedButton;
    sbContinuar: TSpeedButton;
    Label2: TLabel;
    edPararEm: TdrEdit;
    sbParar: TSpeedButton;
    Menu: TPopupMenu;
    Menu_DefinirVariaveis: TMenuItem;
    N1: TMenuItem;
    Menu_Copiar: TMenuItem;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbDVClick(Sender: TObject);
    procedure cb3DClick(Sender: TObject);
    procedure sbPausarClick(Sender: TObject);
    procedure sbContinuarClick(Sender: TObject);
    procedure sbPararClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edPausaChange(Sender: TObject);
    procedure Menu_CopiarClick(Sender: TObject);
    procedure OpcoesClick(Sender: TObject);
  private
    FProjeto: TprProjeto;
    FVars: TStringList;
    procedure InicioSim(Sender: TObject);
    procedure FimSim(Sender: TObject);
  public
    procedure Monitorar(Sender: TObject; const Variavel: String; const Valor: Real);
    procedure Limpar;

    property  Projeto : TprProjeto read FProjeto write FProjeto;
  end;

implementation
uses Series,
     pr_Monitor_DefinirVariaveis,
     WinUtils;

{$R *.dfm}

procedure TDLG_Monitor.FormActivate(Sender: TObject);
begin
  Caption := ' Monitor de ' + FProjeto.Nome;
end;

procedure TDLG_Monitor.Monitorar(Sender: TObject; const Variavel: String; const Valor: Real);
var Obj: THidroComponente;
    i, PararEm  : Integer;
    Serie : TChartSeries;
begin
  Obj := THidroComponente(Sender);

  i := FVars.IndexOf(Obj.Nome + '.' + Variavel);
  if i = -1 then
     begin
     if rbLinhas.Checked then
        Serie := TFastLineSeries.Create(nil)
     else
        begin
        Serie := TBarSeries.Create(nil);
        Serie.AddY(0);
        TBarSeries(Serie).OffsetPercent := -40;
        end;

     Serie.ParentChart := Grafico;
     Serie.Title := Obj.Nome + '.' + Variavel;
     FVars.AddObject(Obj.Nome + '.' + Variavel, Serie)
     end
  else
     Serie := TChartSeries(FVars.Objects[i]);

  if rbLinhas.Checked then
     begin
     if Serie.Count > 100 then Serie.Delete(0);
     Serie.AddXY(Obj.Projeto.DeltaT, Valor);
     end
  else
     begin
     Serie.YValue[0] := Valor;
     end;

  PararEm := edPararEm.AsInteger;
  if (PararEm <> 0) and (PararEm = Obj.Projeto.DeltaT) then
     sbPausarClick(nil);
end;

procedure TDLG_Monitor.FormCreate(Sender: TObject);
begin
  FVars := TStringList.Create;
  FVars.Sorted := True;
  Grafico.Title.Text.Clear;
end;

procedure TDLG_Monitor.FormDestroy(Sender: TObject);
begin
  FVars.Free;
end;

procedure TDLG_Monitor.Limpar;
begin
  Grafico.SeriesList.Clear;
  FVars.Clear;
end;

procedure TDLG_Monitor.sbDVClick(Sender: TObject);
begin
  with TDLG_DefinirVariaveis.Create(Projeto) do
    begin
    ShowModal;
    Free;
    end;
end;

procedure TDLG_Monitor.cb3DClick(Sender: TObject);
begin
  Grafico.View3D := cb3D.Checked;
end;

procedure TDLG_Monitor.sbPausarClick(Sender: TObject);
begin
  if FProjeto.Simulador <> nil then
     begin
     FProjeto.Simulador.Pause;
     sbPausar.Enabled := False;
     sbContinuar.Enabled := True;
     end;
end;

procedure TDLG_Monitor.sbContinuarClick(Sender: TObject);
begin
  sbPausar.Enabled := True;
  sbContinuar.Enabled := False;
  sbParar.Enabled := True;

  if FProjeto.Simulador <> nil then
     FProjeto.Simulador.Continue
  else
     FProjeto.Executar;
end;

procedure TDLG_Monitor.sbPararClick(Sender: TObject);
begin
  FProjeto.TerminarSimulacao;
end;

procedure TDLG_Monitor.FimSim(Sender: TObject);
begin
  sbPausar.Enabled := False;
  sbContinuar.Enabled := True;
  sbParar.Enabled := False;
end;

procedure TDLG_Monitor.InicioSim(Sender: TObject);
var i: integer;
begin
  sbPausar.Enabled := True;
  sbContinuar.Enabled := False;
  sbParar.Enabled := True;
  edPausaChange(nil);
  for i := 0 to Grafico.SeriesCount-1 do
    Grafico.Series[i].Clear;
end;

procedure TDLG_Monitor.FormShow(Sender: TObject);
begin
  FProjeto.Evento_InicioSimulacao := InicioSim;
  FProjeto.Evento_FimSimulacao := FimSim;
end;

procedure TDLG_Monitor.edPausaChange(Sender: TObject);
begin
  if FProjeto.Simulador <> nil then
     FProjeto.Simulador.Delay := edPausa.AsInteger;
end;

procedure TDLG_Monitor.Menu_CopiarClick(Sender: TObject);
begin
  Grafico.CopyToClipboardBitmap;
end;

procedure TDLG_Monitor.OpcoesClick(Sender: TObject);
var P: TPoint;
begin
  P := Point(sbOpt.Left, sbOpt.Top);
  P := pa_Ferramentas.ClientToScreen(P);
  Menu.Popup(P.x, P.y);
end;

end.
