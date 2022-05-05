unit cd_GR_Indices;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TeeProcs, TeEngine, Chart, Series, Menus,
  MessageManager, cd_ClassesBase, cd_Classes, TeeChartUtils;

type
  TfoGR_Indices = class(TForm, IMessageReceptor)
    G: TChart;
    Menu: TPopupMenu;
    Menu_3D: TMenuItem;
    N1: TMenuItem;
    Menu_Copiar: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Menu_3DClick(Sender: TObject);
    procedure Menu_CopiarClick(Sender: TObject);
  private
    FManejo: TManagementList;
    FTipo: TTipoGrafico;
    function ReceiveMessage(const MSG: TadvMessage): Boolean;
    procedure Add(s: TLineSeries; Year: Integer; const Value: real);
  public
    constructor Create(Manejo: TManagementList; Tipo: TTipoGrafico);
    destructor Destroy(); override;
  end;

implementation

{$R *.dfm}

procedure TfoGR_Indices.Add(s: TLineSeries; Year: Integer; const Value: real);
begin
  if Value > -1000000 then
     s.AddXY(Year, Value);
end;

constructor TfoGR_Indices.Create(Manejo: TManagementList; Tipo: TTipoGrafico);
begin
  inherited Create(nil);
  FManejo := Manejo;
  FTipo := Tipo;
  G.Title.Text.Clear();
  case FTipo of
    tiProdChuva:
      begin
      caption := 'Rain Water Productivity';
      G.LeftAxis.Title.Caption := 'kg/m3';
      end;

    tiIrrRainWaterProductivity:
      begin
      caption := 'Rain + Irrigation Water Productivity';
      G.LeftAxis.Title.Caption := 'kg/m3';
      end;

    tiIrrWaterProductivity_ETA:
      begin
      caption := 'Irrigation Water Productivity using ETA';
      G.LeftAxis.Title.Caption := 'kg/m3';
      end;

    tiIrrWaterProductivity_ID:
      begin
      caption := 'Irrigation Water Productivity using IrrDepth';
      G.LeftAxis.Title.Caption := 'kg/m3';
      end;

    tiRendPotCultNI:
      begin
      caption := 'Potential Rainfed Crop Yield';
      G.LeftAxis.Title.Caption := '$/ha';
      end;

    tiRendPotCultI:
      begin
      caption := 'Potential Irrigated Crop Yield';
      G.LeftAxis.Title.Caption := '$/ha';
      end;

    tiCoefChuvas:
      begin
      caption := 'Rainfall Coefficient';
      end;

    tiCoefConvReal:
      begin
      caption := 'Rainfall Actual Conversion Coefficient';
      end;

    tiCoefConvPot:
      begin
      caption := 'Rainfall Potential Conversion Coefficient';
      end;

    tiQ:
      begin
      caption := 'Yield Loss';
      G.LeftAxis.Title.Caption := 'Pencent (%)';
      end;

    tiChuva:
      begin
      caption := 'Rainfall During the Crop Cycle';
      G.LeftAxis.Title.Caption := 'mm';
      end;

    tiLIC:
      begin
      caption := 'Irrigation Depth';
      G.LeftAxis.Title.Caption := 'mm';
      end;

    tiMargemBruta:
      begin
      caption := 'Raw Gross Margin of Profit';
      G.LeftAxis.Title.Caption := '$/ha';
      end;

    tiVolTotAgua:
      begin
      caption := 'Gross Water Volume';
      G.LeftAxis.Title.Caption := 'm3';
      end;

    tiProdTotal:
      begin
      caption := 'Total Production';
      G.LeftAxis.Title.Caption := 'kg';
      end;

     tiCropYield:
      begin
      caption := 'Crop Yield';
      G.LeftAxis.Title.Caption := 'kg/ha';
      end;

     tiNWP:
      begin
      caption := 'Nutritional Water Productivity';
      G.LeftAxis.Title.Caption := 'Kcal/m3';
      end;

     tiEWP:
      begin
      caption := 'Economical Water Productivity';
      G.LeftAxis.Title.Caption := '$/m3';
      end;

     tiWaterCost:
      begin
      caption := 'Water Cost';
      G.LeftAxis.Title.Caption := '$/ha';
      end;

     tiEnergyCost:
      begin
      caption := 'Energy Cost';
      G.LeftAxis.Title.Caption := '$/ha';
      end;

     tiLiquidProfit:
      begin
      caption := 'Net Profit';
      G.LeftAxis.Title.Caption := '$/ha';
      end;

     tiRevenue:
      begin
      caption := 'Percent Net Profit';
      G.LeftAxis.Title.Caption := 'Percent (%)';
      end;

     tiTotalRawRevenue:
      begin
      caption := 'Total Raw Gross Revenue';
      G.LeftAxis.Title.Caption := '$';
      end;

     tiMarginalProductivity:
      begin
      caption := 'Marginal Productivity';
      G.LeftAxis.Title.Caption := 'Percent (%)';
      end;

     tiPracticableProductivity:
      begin
      caption := 'Practicable Productivity';
      G.LeftAxis.Title.Caption := 'kg/ha';
      end;
    end; // case

  if Manejo.Count > 0 then
     caption := ' ' + Manejo.Item[0].Crop.Name + ' - ' + caption;
     
  getMessageManager.RegisterMessage(UM_ObjectDestroy, self);
end;

destructor TfoGR_Indices.Destroy();
begin
  getMessageManager.UnregisterMessage(UM_ObjectDestroy, self);
  inherited;
end;

procedure TfoGR_Indices.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  getMessageManager.SendMessage(UM_FormDestroy, [self]);
  Action := caFree;
end;

procedure TfoGR_Indices.FormShow(Sender: TObject);
var i, j: Integer;
    s: TLineSeries;
    Ano: TYear;
begin
  for i := 0 to FManejo.Count-1 do
    begin
    s := TLineSeries.Create(G);
    s.ParentChart := G;
    s.Title := FManejo.Item[i].Description;

    for j := 0 to FManejo.Item[i].Years.Count-1 do
      begin
      Ano := FManejo.Item[i].Years.Item[j];
      case FTipo of
        tiProdChuva:
          Add(s, Ano.Year, Ano.RainProductivity);

        tiIrrRainWaterProductivity:
          // Plota todos os manejos, incluindo o nao irrigado
          Add(s, Ano.Year, Ano.IrrRainWaterProductivity);

        tiIrrWaterProductivity_ETA:
          // Plota todos os manejos, incluindo o nao irrigado
          Add(s, Ano.Year, Ano.IrrWaterProd);

        tiIrrWaterProductivity_ID:
          // Plota todos os manejos, incluindo o nao irrigado
          Add(s, Ano.Year, Ano.IrrWaterProd_IrrDepth);

        tiRendPotCultNI           : Add(s, Ano.Year, Ano.RCPY);
        tiRendPotCultI            : Add(s, Ano.Year, Ano.ICPY);
        tiCoefChuvas              : Add(s, Ano.Year, Ano.RC);
        tiCoefConvReal            : Add(s, Ano.Year, Ano.RACC);
        tiCoefConvPot             : Add(s, Ano.Year, Ano.RPCC);
        tiQ                       : Add(s, Ano.Year, Ano.YieldLoss);
        tiChuva                   : Add(s, Ano.Year, Ano.Precipitation);
        tiLIC                     : Add(s, Ano.Year, Ano.IrrDepth);
        tiMargemBruta             : Add(s, Ano.Year, Ano.RawGrossMarginOfProfit);
        tiVolTotAgua              : Add(s, Ano.Year, Ano.TotalWaterVol);
        tiProdTotal               : Add(s, Ano.Year, Ano.TotalProduction);
        tiCropYield               : Add(s, Ano.Year, Ano.CropYield);
        tiNWP                     : Add(s, Ano.Year, Ano.NWP);
        tiEWP                     : Add(s, Ano.Year, Ano.EWP);
        tiWaterCost               : Add(s, Ano.Year, Ano.WaterCost);
        tiEnergyCost              : Add(s, Ano.Year, Ano.EnergyCost);
        tiLiquidProfit            : Add(s, Ano.Year, Ano.LiquidNetProfit);
        tiRevenue                 : Add(s, Ano.Year, Ano.NetProfit);
        tiTotalRawRevenue         : Add(s, Ano.Year, Ano.TotalRawGrossRevenue);
        tiMarginalProductivity    : Add(s, Ano.Year, Ano.MarginalProductivity);
        tiPracticableProductivity : Add(s, Ano.Year, Ano.PracticableProductivity);
        end
      end; // for j (anos)

    if FTipo = tiProdChuva then
       break; // Plota somente o manejo nao irrigado.
    end; // for i (manejos)

  TeeChartUtils.InsertUpDownValues(G, 20);  
end;

procedure TfoGR_Indices.Menu_3DClick(Sender: TObject);
begin
  G.View3D := not G.View3D;
  Menu_3D.Checked := G.View3D;
end;

procedure TfoGR_Indices.Menu_CopiarClick(Sender: TObject);
begin
  G.CopyToClipboardBitmap();
end;

function TfoGR_Indices.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_ObjectDestroy then
     close();
end;

end.
