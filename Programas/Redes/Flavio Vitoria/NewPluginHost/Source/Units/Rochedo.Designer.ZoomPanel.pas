unit Rochedo.Designer.ZoomPanel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Rochedo.Component, Rochedo.Designer, Rochedo.PanZoom, Buttons, ExtCtrls;

type
  TZoomPanelDesigner = class(TDesigner)
    TopPanel: TPanel;
    sbZoomOut: TSpeedButton;
    sbZoomIn: TSpeedButton;
    sbFitImage: TSpeedButton;
    ZoomPanel: TPanZoomPanel;
    SpeedButton1: TSpeedButton;
    procedure sbZoomOutClick(Sender: TObject);
    procedure sbZoomInClick(Sender: TObject);
    procedure sbZoom100_Click(Sender: TObject);
    procedure ZoomPanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; DeviceX, DeviceY: Integer; ActualX, ActualY: Double);
    procedure ZoomPanelMouseMove(Sender: TObject; Shift: TShiftState;
      DeviceX, DeviceY: Integer; ActualX, ActualY: Double);
    procedure ZoomPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; DeviceX, DeviceY: Integer; ActualX, ActualY: Double);
    procedure ZoomPanelClick(Sender: TObject);
    procedure ZoomPanelDblClick(Sender: TObject);
    procedure sbFitImageClick(Sender: TObject);
  protected
    function pointToMapPoint(p: TPoint): TMapPoint; override;
    function mapPointToPoint(p: TMapPoint): TPoint; override;
    function getControl(): TWinControl; override;
    function getCanvas(): TCanvas; override;
    procedure setEvents(); override;
  public
    procedure setBackgroundImage(const Filename: string); override;
  end;

implementation

{$R *.dfm}

procedure TZoomPanelDesigner.sbZoomOutClick(Sender: TObject);
begin
  ZoomPanel.ZoomOut(2);
end;

procedure TZoomPanelDesigner.sbZoomInClick(Sender: TObject);
begin
  ZoomPanel.ZoomIn(2);
end;

procedure TZoomPanelDesigner.sbZoom100_Click(Sender: TObject);
begin
  ZoomPanel.OneToOne();
end;

function TZoomPanelDesigner.getCanvas(): TCanvas;
begin
  result := ZoomPanel.PaintBoxCanvas;
end;

function TZoomPanelDesigner.getControl(): TWinControl;
begin
  result := ZoomPanel;
end;

function TZoomPanelDesigner.mapPointToPoint(p: TMapPoint): TPoint;
begin
  result := ZoomPanel.ActualToDevice(TDoublePoint(p));
end;

function TZoomPanelDesigner.pointToMapPoint(p: TPoint): TMapPoint;
begin
  result := TMapPoint(ZoomPanel.DeviceToActual(p));
end;

procedure TZoomPanelDesigner.ZoomPanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; DeviceX, DeviceY: Integer; ActualX, ActualY: Double);
begin
  DoMouseDown(Sender, Button, Shift, DeviceX, DeviceY);
end;

procedure TZoomPanelDesigner.ZoomPanelMouseMove(Sender: TObject;
  Shift: TShiftState; DeviceX, DeviceY: Integer; ActualX, ActualY: Double);
begin
  DoMouseMove(Sender, Shift, DeviceX, DeviceY);
end;

procedure TZoomPanelDesigner.ZoomPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; DeviceX, DeviceY: Integer; ActualX, ActualY: Double);
begin
  DoMouseUp(Sender, Button, Shift, DeviceX, DeviceY);
end;

procedure TZoomPanelDesigner.setEvents();
begin
  ZoomPanel.OnPaintBoxPaint := DoPaint;
end;

procedure TZoomPanelDesigner.setBackgroundImage(const Filename: string);
var b: TBitmap;
begin
  inherited setBackgroundImage(Filename);
  b := TBitmap.Create();
  b.LoadFromFile(Filename);
  try
    ZoomPanel.Bitmap := b;

    ZoomPanel.SetFirstScalePoint(
      MakePoint(0, ZoomPanel.Bitmap.Height),
      MakeDoublePoint(0, 0));

    // Faz com que a unidade seja igual a 1 pixel da imagem
    ZoomPanel.SetSecondScalePoint(
      MakePoint(ZoomPanel.Bitmap.Width, 0),
      MakeDoublePoint(ZoomPanel.Bitmap.Width, ZoomPanel.Bitmap.Height));

    ZoomPanel.DefineScaleNoSkew(False, False);
  finally
    b.Free();
  end;
end;

procedure TZoomPanelDesigner.ZoomPanelClick(Sender: TObject);
begin
  // Sender nao corresponde a ZoomPanel
  DoClick(ZoomPanel);
end;

procedure TZoomPanelDesigner.ZoomPanelDblClick(Sender: TObject);
begin
  // Sender nao corresponde a ZoomPanel
  DoDblClick(ZoomPanel);
end;

procedure TZoomPanelDesigner.sbFitImageClick(Sender: TObject);
begin
  ZoomPanel.Fit();
end;

end.
