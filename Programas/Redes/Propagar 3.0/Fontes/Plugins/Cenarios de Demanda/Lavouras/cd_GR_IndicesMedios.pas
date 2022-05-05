unit cd_GR_IndicesMedios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TeeProcs, TeEngine, Chart, Series, Menus,
  MessageManager, cd_ClassesBase, cd_Classes;

type
  TfoGR_IndicesMedios = class(TForm, IMessageReceptor)
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
    FManejos: TManagementList;
    FTipo: TTipoGrafico;
    function ReceiveMessage(const MSG: TadvMessage): Boolean;
    procedure Add(s: TLineSeries; const Value: real);
  public
    constructor Create(Manejos: TManagementList; Tipo: TTipoGrafico);
    destructor Destroy(); override;
  end;

implementation

{$R *.dfm}

procedure TfoGR_IndicesMedios.Add(s: TLineSeries; const Value: real);
begin
  if Value > -1000000 then
     s.AddY(Value);
end;

constructor TfoGR_IndicesMedios.Create(Manejos: TManagementList; Tipo: TTipoGrafico);
begin
  inherited Create(nil);
  FManejos := Manejos;
  FTipo := Tipo;
  G.Title.Text.Clear();
  case FTipo of
    ti_Med_PLIOL:
      begin
      caption := 'Average of Limite Prod. for Revenue';
      G.LeftAxis.Title.Caption := 'kg/ha';
      end;

    ti_Med_LL:
      begin
      caption := 'Average of Net Return';
      G.LeftAxis.Title.Caption := '$/ha';
      end;

    ti_STD_NetReturn:
      begin
      caption := 'Standard Deviation of Net Return';
      G.LeftAxis.Title.Caption := '$/ha';
      end;
    end; // case

  if Manejos.Count > 0 then
     caption := ' ' + Manejos.Item[0].Crop.Name + ' - ' + caption;

  getMessageManager.RegisterMessage(UM_ObjectDestroy, self);
end;

destructor TfoGR_IndicesMedios.Destroy();
begin
  getMessageManager.UnregisterMessage(UM_ObjectDestroy, self);
  inherited;
end;

procedure TfoGR_IndicesMedios.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  getMessageManager.SendMessage(UM_FormDestroy, [self]);
  Action := caFree;
end;

procedure TfoGR_IndicesMedios.FormShow(Sender: TObject);
var i, j: Integer;
    s: TLineSeries;
    m: TManagement;
begin
  s := TLineSeries.Create(G);
  s.ParentChart := G;
  s.ShowInLegend := false;
  for i := 0 to FManejos.Count-1 do
    begin
    m := FManejos.Item[i];
    case FTipo of
      ti_Med_PLIOL     : Add(s, m.Years.Mean('LimProdForRevenue'));
      ti_Med_LL        : Add(s, m.Years.Mean('LiquidNetProfit'));
      ti_STD_NetReturn : Add(s, m.Years.StdDev('LiquidNetProfit'));
      end
    end;
end;

procedure TfoGR_IndicesMedios.Menu_3DClick(Sender: TObject);
begin
  G.View3D := not G.View3D;
  Menu_3D.Checked := G.View3D;
end;

procedure TfoGR_IndicesMedios.Menu_CopiarClick(Sender: TObject);
begin
  G.CopyToClipboardBitmap();
end;

function TfoGR_IndicesMedios.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_ObjectDestroy then
     close();
end;

end.
