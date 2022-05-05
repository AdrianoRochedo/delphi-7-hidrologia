unit iphs1_Dialogo_Res_VisNivel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Extpanel,
  //iphs1_GaugeDoReservatorio_2,
  hidro_Tipos,
  iphs1_Classes,
  TeeProcs,
  TeEngine,
  Chart,
  Series,
  drEdit;

type
  Tfoiphs1_Dialogo_Res_VisNivel = class(TForm)
    Button1: TButton;
    laCotas: TLabel;
    Timer: TTimer;
    Chart: TChart;
    GroupBox1: TGroupBox;
    cbE: TCheckBox;
    cbS: TCheckBox;
    cbV: TCheckBox;
    GroupBox2: TGroupBox;
    Gauge: TTrackBar;
    btn1: TButton;
    Label1: TLabel;
    laDT: TLabel;
    Label2: TLabel;
    laC: TLabel;
    btnParar: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    tbV: TTrackBar;
    Label5: TLabel;
    GroupBox3: TGroupBox;
    cb3D: TCheckBox;
    Label6: TLabel;
    edPontos: TdrEdit;
    cbBP: TCheckBox;
    Panel4: TPanel;
    cbO: TCheckBox;
    Panel5: TPanel;
    chCotas: TChart;
    Label7: TLabel;
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbEClick(Sender: TObject);
    procedure cbSClick(Sender: TObject);
    procedure cbVClick(Sender: TObject);
    procedure btnPararClick(Sender: TObject);
    procedure tbVChange(Sender: TObject);
    procedure PPaint(Sender: TObject);
    procedure cb3DClick(Sender: TObject);
    procedure cbBPClick(Sender: TObject);
    procedure cbOClick(Sender: TObject);
  private
    //b: Tiphs1_ResGause;
    FRes: Tiphs1_PCR;
    QE, QS, QV, QO, QBP, Cotas, LOrif, LVert: TChartSeries;
    HE: TV;

    procedure updateImage();
    function CriarSerie(Cor: TColor; ParentChar: TChart; FastLine: boolean = false): TChartSeries;
  public
    constructor Create(Res: Tiphs1_PCR);
    destructor Destroy; override;
  end;

implementation
uses hidro_Variaveis;

{$R *.dfm}

constructor Tfoiphs1_Dialogo_Res_VisNivel.Create(Res: Tiphs1_PCR);
begin
  inherited Create(nil);
  FRes := Res;

  QE    := CriarSerie(clBLUE, Chart);
  QS    := CriarSerie(clRED, Chart);
  QV    := CriarSerie(clYELLOW, Chart); // Vert
  QO    := CriarSerie(clBLACK, Chart); // Orif
  QBP   := CriarSerie(clGREEN, Chart);
  
  Cotas := CriarSerie(clBLUE, chCotas);
  LOrif := CriarSerie(clBLACK, chCotas, true);
  LVert := CriarSerie(clYELLOW, chCotas, true);

  TFastLineSeries(LOrif).LinePen.Width := 2;
  TFastLineSeries(LVert).LinePen.Width := 2;

{
  b := Tiphs1_ResGause.Create;
  b.LoadFromFile(gExePath + 'imagens\Res.bmp');
  b.Percent := 0;
}
  HE := FRes.ObterHidrogramaDeEntrada();
end;

destructor Tfoiphs1_Dialogo_Res_VisNivel.Destroy;
begin
  //b.Free;
  HE.Free;
  inherited;
end;

procedure Tfoiphs1_Dialogo_Res_VisNivel.FormShow(Sender: TObject);
begin
  Chart.Title.Text.Clear();
  Chart.Legend.Visible := False;

  chCotas.Title.Text.Clear();
  chCotas.Legend.Visible := False;

  Gauge.Min := 1;
  Gauge.Max := Tiphs1_Projeto(FRes.Projeto).NIT;
  Caption := Caption + ' - ' + FRes.Projeto.Nome + ': ' + FRes.Nome;

  laCotas.Caption := 'Cota Máxima (m): ' + FloatToStr(FRes.TCV_CMR);

  if FRes.TemVertedor then
     laCotas.Caption := laCotas.Caption + '     Cota do Vertedor (m): ' + FloatToStr(FRes.Vert_CC);

  if FRes.TemOrificio then
     laCotas.Caption := laCotas.Caption + '     Cota do Orifício (m): ' + FloatToStr(FRes.Orif_C);

  cbV.Enabled := FRes.TemVertedor;
  cbO.Enabled := FRes.TemOrificio;

  if not cbV.Enabled then cbV.Checked := False;
  if not cbO.Enabled then cbO.Checked := False;

  updateImage();
end;

procedure Tfoiphs1_Dialogo_Res_VisNivel.updateImage();
begin
  //p.Canvas.Draw(0, 0, b);
end;

function Tfoiphs1_Dialogo_Res_VisNivel.CriarSerie(Cor: TColor;
                                                  ParentChar: TChart;
                                                  FastLine: boolean = false): TChartSeries;
begin
  if FastLine then
     result := TFastLineSeries.Create(nil)
  else
     result := TLineSeries.Create(nil);

  result.ParentChart := ParentChar;
  result.SeriesColor := Cor;
end;

procedure Tfoiphs1_Dialogo_Res_VisNivel.btn1Click(Sender: TObject);
var Min, Max: Double;
begin
  QE.Clear();
  QS.Clear();
  QV.Clear();
  QO.Clear();
  QBP.Clear();
  Cotas.Clear();

  cbEClick(nil);
  cbSClick(nil);
  cbVClick(nil);
  cbOClick(nil);

  Gauge.Position := 1;
  Timer.Enabled := True;

  FRes.Cotas.ColExtrems(1, Min, Max);
  chCotas.LeftAxis.Minimum := Min - 0.5;
  chCotas.LeftAxis.Maximum := Max + 0.5;
end;

procedure Tfoiphs1_Dialogo_Res_VisNivel.TimerTimer(Sender: TObject);
var x: integer;
    Cota: real;
begin
  Gauge.Position := Gauge.Position + 1;
  x := Gauge.Position;

  laDT.Caption := intToStr(Gauge.Position);
  updateImage();

  QE.AddXY(x, HE[x]);
  if QE.Count > edPontos.AsInteger then QE.Delete(0);

  if Gauge.Position <= FRes.Cotas.NRows then
     begin
     Cota := FRes.Cotas[x, 1];
     //b.Percent := 100 * Cota / FRes.TCV_CMR;
     laC.Caption := FloatToStr(Cota);
     Cotas.AddXY(x, Cota);
     if Cotas.Count > edPontos.AsInteger then Cotas.Delete(0);

     QV.AddXY(x, FRes.Cotas[x, 2]);
     if QV.Count > edPontos.AsInteger then QV.Delete(0);

     QO.AddXY(x, FRes.Cotas[x, 3]);
     if QO.Count > edPontos.AsInteger then QO.Delete(0);

     QBP.AddXY(x, FRes.Cotas[x, 4]);
     if QBP.Count > edPontos.AsInteger then QBP.Delete(0);

     QS.AddXY(x, FRes.Cotas[x, 5]);
     if QS.Count > edPontos.AsInteger then QS.Delete(0);

     LOrif.Clear();
     LOrif.AddXY(chCotas.MinXValue(chCotas.BottomAxis), FRes.Orif_C);
     LOrif.AddXY(chCotas.MaxXValue(chCotas.BottomAxis), FRes.Orif_C);

     LVert.Clear();
     LVert.AddXY(chCotas.MinXValue(chCotas.BottomAxis), FRes.Vert_CC);
     LVert.AddXY(chCotas.MaxXValue(chCotas.BottomAxis), FRes.Vert_CC);
     end
  else
     begin
     //b.Percent := 0;
     laC.Caption := 'Não Def.';
     end;

  if Gauge.Position = Gauge.Max then
     btn1Click(nil);
end;

procedure Tfoiphs1_Dialogo_Res_VisNivel.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure Tfoiphs1_Dialogo_Res_VisNivel.cbEClick(Sender: TObject);
begin
  QE.Active := cbE.Checked;
end;

procedure Tfoiphs1_Dialogo_Res_VisNivel.cbSClick(Sender: TObject);
begin
  QS.Active := cbS.Checked;
end;

procedure Tfoiphs1_Dialogo_Res_VisNivel.cbVClick(Sender: TObject);
begin
  QV.Active := cbV.Checked;
end;

procedure Tfoiphs1_Dialogo_Res_VisNivel.btnPararClick(Sender: TObject);
begin
  Timer.Enabled := False;
end;

procedure Tfoiphs1_Dialogo_Res_VisNivel.tbVChange(Sender: TObject);
begin
  Timer.Interval := tbV.Position;
end;

procedure Tfoiphs1_Dialogo_Res_VisNivel.PPaint(Sender: TObject);
begin
  updateImage;
end;

procedure Tfoiphs1_Dialogo_Res_VisNivel.cb3DClick(Sender: TObject);
begin
  Chart.View3D := cb3D.Checked;
  chCotas.View3D := cb3D.Checked;
end;

procedure Tfoiphs1_Dialogo_Res_VisNivel.cbBPClick(Sender: TObject);
begin
  QBP.Active := cbBP.Checked;
end;

procedure Tfoiphs1_Dialogo_Res_VisNivel.cbOClick(Sender: TObject);
begin
  QO.Active := cbO.Checked;
end;

end.
