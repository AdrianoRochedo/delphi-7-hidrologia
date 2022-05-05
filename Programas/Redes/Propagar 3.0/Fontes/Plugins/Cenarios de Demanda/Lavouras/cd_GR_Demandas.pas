unit cd_GR_Demandas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TeeProcs, TeEngine, Chart, Series, Menus,
  cd_ClassesBase, cd_Classes;

type
  TfoGR_Demandas = class(TForm)
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
    FRes: TManagement;
  public
    constructor Create(Res: TManagement);
  end;

implementation
uses ObjectListEx,
     MessageManager;

{$R *.dfm}

constructor TfoGR_Demandas.Create(Res: TManagement);
begin
  inherited Create(nil);
  FRes := Res;
  G.Title.Text.Clear();
  Caption := ' ' + FRes.Crop.Name + ' - Demands';
end;

procedure TfoGR_Demandas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  getMessageManager.SendMessage(OL_RemoveObject, [self]);
  Action := caFree;
end;

procedure TfoGR_Demandas.FormShow(Sender: TObject);
var i, j: Integer;
    s: TChartSeries;
begin
  if FRes.OneCivilYear then
     for i := 1 to FRes.Reqs.nRows do
       begin
       s := TLineSeries.Create(G);
       s.ParentChart := G;
       s.Title := FRes.Reqs.RowName[i];

       s.AddXY(FRes.FirstMonth - 1, 0);
       for j := FRes.FirstMonth to FRes.LastMonth do
         s.AddXY(j, FRes.Reqs[i, j]);
       s.AddXY(FRes.LastMonth + 1, 0);
       end
  else
     for i := 2 to FRes.Reqs.nRows do
       begin
       s := TLineSeries.Create(G);
       s.ParentChart := G;
       s.Title := FRes.Reqs.RowName[i-1];

       s.AddY(0, intToStr(FRes.FirstMonth - 1));
       for j := FRes.FirstMonth to 12 do s.AddY(FRes.Reqs[i-1, j], intToStr(j));
       for j := 1 to FRes.LastMonth do s.AddY(FRes.Reqs[i, j], intToStr(j));
       s.AddY(0, intToStr(FRes.LastMonth + 1));
       end
end;

procedure TfoGR_Demandas.Menu_3DClick(Sender: TObject);
begin
  G.View3D := not G.View3D;
  Menu_3D.Checked := G.View3D;
end;

procedure TfoGR_Demandas.Menu_CopiarClick(Sender: TObject);
begin
  G.CopyToClipboardBitmap();
end;

end.
