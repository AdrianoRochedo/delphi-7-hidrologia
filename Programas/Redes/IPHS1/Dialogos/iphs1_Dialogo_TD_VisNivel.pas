unit iphs1_Dialogo_TD_VisNivel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Extpanel, hidro_Tipos,
  iphs1_GaugeDoCanal, iphs1_Classes, TeeProcs, TeEngine, Chart, Series;

type
  Tfoiphs1_Dialogo_TD_VisNivel = class(TForm)
    P: TExtPanel;
    Timer: TTimer;
    Chart: TChart;
    laCotas: TLabel;
    Button2: TButton;
    GroupBox1: TGroupBox;
    cbE: TCheckBox;
    cbS: TCheckBox;
    Panel1: TPanel;
    Panel2: TPanel;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    laDT: TLabel;
    Label2: TLabel;
    laC: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Gauge: TTrackBar;
    btn1: TButton;
    btnParar: TButton;
    tbV: TTrackBar;
    Label5: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GaugeChange(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure tbVChange(Sender: TObject);
    procedure cbSClick(Sender: TObject);
    procedure cbEClick(Sender: TObject);
    procedure btnPararClick(Sender: TObject);
    procedure PPaint(Sender: TObject);
  private
    b: Tiphs1_TD_Gause;
    FTD: Tiphs1_TrechoDagua;
    QE, QS: TPointSeries;
    HE: TV;
    procedure updateImage;
    function CriarSerie(Cor: TColor): TPointSeries;
  public
    constructor Create(TD: Tiphs1_TrechoDagua);
  end;

implementation
uses hidro_Variaveis;

{$R *.dfm}

procedure Tfoiphs1_Dialogo_TD_VisNivel.FormShow(Sender: TObject);
begin
  Chart.Title.Text.Clear;
  Chart.Legend.Visible := False;

  b := Tiphs1_TD_Gause.Create;
  b.LoadFromFile(gExePath + 'imagens\Canal.bmp');
  b.Percent := 0;

  Gauge.Min := 1;
  Gauge.Max := Tiphs1_Projeto(FTD.Projeto).NIT;
  Caption := Caption + ' - ' + FTD.Projeto.Nome + ': ' + FTD.Nome;
  //laCM.Caption := 'Cota Máxima (m): ' + FloatToStr(FRes.TCV_CMR);

  HE := FTD.ObterHidrogramaDeEntrada();
end;

procedure Tfoiphs1_Dialogo_TD_VisNivel.updateImage();
begin
  p.Canvas.Draw(55, 48, b);
end;

procedure Tfoiphs1_Dialogo_TD_VisNivel.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  b.Free;
  HE.Free;
end;

procedure Tfoiphs1_Dialogo_TD_VisNivel.GaugeChange(Sender: TObject);
var Cota: Real;
begin
  Cota := FTD.Cotas[Gauge.Position];
  b.Percent := {100 * Cota / 100} Gauge.Position;
  laDT.Caption := intToStr(Gauge.Position);
  laC.Caption := FloatToStr(Cota);
  updateImage();
end;

function Tfoiphs1_Dialogo_TD_VisNivel.CriarSerie(Cor: TColor): TPointSeries;
begin
  Result := TPointSeries.Create(nil);
  Result.ParentChart := Chart;
  Result.Pointer.HorizSize := 3;
  Result.Pointer.VertSize := 3;
  Result.Pointer.Style := psCircle;
  Result.SeriesColor := Cor;
end;

constructor Tfoiphs1_Dialogo_TD_VisNivel.Create(TD: Tiphs1_TrechoDagua);
begin
  inherited Create(nil);
  FTD := TD;
  QE := CriarSerie(clBLUE);
  QS := CriarSerie(clRED);
end;

procedure Tfoiphs1_Dialogo_TD_VisNivel.btn1Click(Sender: TObject);
begin
  QE.Clear;
  QS.Clear;
  cbEClick(nil);
  cbSClick(nil);
  Gauge.Position := 1;
  Timer.Enabled := True;
end;

procedure Tfoiphs1_Dialogo_TD_VisNivel.TimerTimer(Sender: TObject);
begin
  Gauge.Position := Gauge.Position + 1;

  QE.Add(HE[Gauge.Position]);
  if QE.Count > Gauge.Max then QE.Delete(0);

  QS.Add(FTD.HidroRes[Gauge.Position]);
  if QS.Count > Gauge.Max then QS.Delete(0);

  if Gauge.Position = Gauge.Max then
     begin
     Timer.Enabled := False;
     Gauge.Position := 1;
     end;
end;

procedure Tfoiphs1_Dialogo_TD_VisNivel.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure Tfoiphs1_Dialogo_TD_VisNivel.tbVChange(Sender: TObject);
begin
  Timer.Interval := tbV.Position;
end;

procedure Tfoiphs1_Dialogo_TD_VisNivel.cbSClick(Sender: TObject);
begin
  QS.Active := cbS.Checked;
end;

procedure Tfoiphs1_Dialogo_TD_VisNivel.cbEClick(Sender: TObject);
begin
  QE.Active := cbE.Checked;
end;

procedure Tfoiphs1_Dialogo_TD_VisNivel.btnPararClick(Sender: TObject);
begin
  Timer.Enabled := False;
end;

procedure Tfoiphs1_Dialogo_TD_VisNivel.PPaint(Sender: TObject);
begin
  updateImage;
end;

end.
