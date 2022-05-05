unit pro_fr_IntervalsOfStations;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, pro_fr_StationSelections, StdCtrls, ExtCtrls, TeeProcs,
  TeEngine, Chart, GanttCh, pro_Classes, pro_interfaces, Mask, Menus;

type
  TChangeEvent = procedure(Sender: TObject; L: TListaDePeriodos) of object;

  TfrIntervalsOfStations = class(TFrame)
    frPostos: TFrame_SelecaoDePostos;
    laI: TLabel;
    laIC: TLabel;
    GroupBox1: TGroupBox;
    rb1: TRadioButton;
    rb2: TRadioButton;
    g2: TChart;
    L1: TLabel;
    L2: TLabel;
    g1: TChart;
    Label1: TLabel;
    meDI: TMaskEdit;
    meDF: TMaskEdit;
    Label2: TLabel;
    procedure rb1Click(Sender: TObject);
    procedure Gantt_MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure Gantt_ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    FInfo: TDSInfo;
    FS1: TGanttSeries;
    FS2: TGanttSeries;
    FOnChange: TChangeEvent;
    procedure CheckChange(Sender: TObject);
    procedure setInfo(const Value: TDSInfo);
    procedure ShowSecondGantt();
    function GetPostosSel: TStrings;
    function getDF: string;
    function getDI: string;
    function getDF_DT: TDateTime;
    function getDI_DT: TDateTime;
  public
    constructor Create(AOwner: TComponent); override;

    procedure DoGanttMouseMove(serie: TGanttSeries; L: TLabel; x, y: integer);

    // conjunto de dados
    property Info: TDSInfo read FInfo write setInfo;

    // postos
    property PostosSel : TStrings read GetPostosSel;

    // Dadas
    property sDI : string read getDI;
    property sDF : string read getDF;
    property DI : TDateTime read getDI_DT;
    property DF : TDateTime read getDF_DT;

    // series
    property S1 : TGanttSeries read FS1;
    property S2 : TGanttSeries read FS2;

    // Eventos
    property OnChange : TChangeEvent read FOnChange write FOnChange;
  end;

implementation
uses pro_Procs;

{$R *.dfm}

constructor TfrIntervalsOfStations.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  rb2.Checked := true;

  FS2 := TGanttSeries.Create(self);
  FS2.ParentChart := g2;

  FS1 := TGanttSeries.Create(self);
  FS1.ParentChart := g1;

  L1.Caption := '';
  L2.Caption := '';

  frPostos.OnCheckChange := CheckChange;
end;

procedure TfrIntervalsOfStations.rb1Click(Sender: TObject);
begin
  laIC.Caption := TRadioButton(Sender).Caption + ':';

  // Monta um unico gantt em g2 com a combinacao dos periodos que
  // depende da opcao do usuario.
  if Finfo <> nil then ShowSecondGantt();
end;

// Monta um unico gantt em g2 com a combinacao dos periodos que
// depende da opcao do usuario.
procedure TfrIntervalsOfStations.ShowSecondGantt();
var L  : TListaDePeriodos;
    P  : TStrings;
    k  : integer;
    i  : integer;
    b  : boolean;
    s  : string;
    per: pRecDadosPeriodo;
begin
  // Lima o Gantt
  FS2.Clear();

  // Obtem os postos selecionados
  P := frPostos.PostosSel;

  // Mostra o 2. Gantt
  L := pro_Procs.ObtemPeriodos(FInfo, true, P);
  for k := 0 to L.NumPeriodos-1 do
    begin
    per := L[k];
    if rb1.Checked then
       FS2.AddGantt(per.DI, per.DF, 0, 'sub-intervalos')
    else
       begin
       // Somente adiciona no gantt um periodo que apareca em todos os postos
       s := pro_Procs.SetToPostos(per.Postos, FInfo);
       b := true;
       for i := 0 to P.Count-1 do
         if System.Pos(p[i], s) = 0 then
            begin
            b := false;
            break;
            end;
       if b then FS2.AddGantt(per.DI, per.DF, 0, 'sub-intervalos');
       end;
    end;
  if Assigned(FOnChange) then FOnChange(self, L);
  L.Free();

  // Estabelece a escala g2 igual a de g1
  g2.BottomAxis.SetMinMax(g1.BottomAxis.Minimum, g1.BottomAxis.Maximum);
end;

procedure TfrIntervalsOfStations.setInfo(const Value: TDSInfo);
var sl: TStrings;
begin
  FInfo := Value;
  sl := TStringList.Create();
  FInfo.GetStationNames(sl);
  frPostos.setPostos(sl);
  sl.Free();
end;

procedure TfrIntervalsOfStations.DoGanttMouseMove(serie: TGanttSeries; L: TLabel; x, y: integer);
var s: String;
    t: Longint;
begin
  if FInfo.TipoIntervalo = tiMensal then
     s := 'mm/yyyy'
  else
     s := 'dd/mm/yyyy';

  t := serie.Clicked(x, y);
  if t > -1 then
     L.Caption := FormatDateTime(s, Serie.XValues[t]) + ' - ' +
                  FormatDateTime(s, Serie.EndValues[t])
  else
     L.Caption := '';
end;

procedure TfrIntervalsOfStations.Gantt_MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var serie: TGanttSeries;
    L: TLabel;
begin
  if Sender = g1 then
     begin
     serie := self.FS1;
     L := self.L1;
     end
  else
     begin
     serie := self.FS2;
     L := self.L2;
     end;

  DoGanttMouseMove(serie, L, x, y);
end;

procedure TfrIntervalsOfStations.Gantt_ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var s: string;  
begin
  if FInfo.TipoIntervalo = tiMensal then
     s := '01/mm/yyyy'
  else
     s := 'dd/mm/yyyy';

  if ValueIndex > -1 then
     begin
     meDI.Text := FormatDateTime(s, Series.XValues[ValueIndex]);
     meDF.Text := FormatDateTime(s, TGanttSeries(Series).EndValues[ValueIndex]);
     end;
end;

function TfrIntervalsOfStations.GetPostosSel(): TStrings;
begin
  result := frPostos.PostosSel;
end;

function TfrIntervalsOfStations.getDF(): string;
begin
  result := meDF.Text;
end;

function TfrIntervalsOfStations.getDI(): string;
begin
  result := meDI.Text;
end;

function TfrIntervalsOfStations.getDF_DT(): TDateTime;
begin
  result := StrToDate(getDF());
end;

function TfrIntervalsOfStations.getDI_DT(): TDateTime;
begin
  result := StrToDate(getDI());
end;

procedure TfrIntervalsOfStations.CheckChange(Sender: TObject);
var L  : TListaDePeriodos;
    P  : TStrings;
    PT : TStrings;
    i  : integer;
    k  : integer;
    per: pRecDadosPeriodo;
begin
  // Limpa as Datas
  meDI.Clear();
  meDF.Clear();

  // limpa o 1. Gantt
  FS1.Clear();

  // Obtem os postos selecionados
  P := frPostos.PostosSel;

  // Cria a lista temporaria que armazenara os postos
  PT := TStringList.Create();

  // Percorre os postos selecionados e monta o 1. Gantts com os periodos
  // de cada posto individualmente
  for i := 0 to P.Count-1 do
    begin
    // Obtem os periodos do posto i
    PT.Clear();
    PT.Add(P[i]);
    L := pro_Procs.ObtemPeriodos(FInfo, true, PT);

    // Monta o gantt do posto i
    for k := 0 to L.NumPeriodos-1 do
      begin
      per := L[k];
      FS1.AddGantt(per.DI, per.DF, i, p[i]);
      end;

    // Destroi a lista
    L.Free();
    end; // for i

  // Destroi a lista temporaria
  PT.Free();

  // recalcula os limites do eixo de baixo
  g1.BottomAxis.AdjustMaxMin();

  // Monta um unico gantt em g2 com a combinacao dos periodos que
  // depende da opcao do usuario.
  ShowSecondGantt();
end;

end.
