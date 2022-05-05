unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Rochedo.PanZoom, SysUtilsEx, Shapes;

const
  Objetos = 300;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    cmdZoomIn: TButton;
    cmdOneToOne: TButton;
    cmdZoomOut: TButton;
    Splitter1: TSplitter;
    cmdSizeToImage: TButton;
    cmdPaint: TButton;
    lblXY: TLabel;
    lblStatus: TLabel;
    chkProportionalZoom: TCheckBox;
    chkAligned: TCheckBox;
    p: TPanZoomPanel;
    cmdLoadImage: TButton;
    Open: TOpenDialog;
    chkResizable: TCheckBox;
    lblPenWidth: TLabel;
    txtPenWidth: TEdit;
    udPenWidth: TUpDown;
    procedure cmdZoomInClick(Sender: TObject);
    procedure cmdOneToOneClick(Sender: TObject);
    procedure cmdZoomOutClick(Sender: TObject);
    procedure cmdSizeToImageClick(Sender: TObject);
    procedure cmdPaintClick(Sender: TObject);
    procedure chkAlignedClick(Sender: TObject);
    procedure pMouseMove(Sender: TObject; Shift: TShiftState;
                                     DeviceX, DeviceY: Integer;
                                     ActualX, ActualY: Double);
    procedure pZoomInBegin(Sender: TObject);
    procedure pPaintBegin(Sender: TObject);
    procedure cmdLoadImageClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure chkResizableClick(Sender: TObject);
    procedure txtPenWidthChange(Sender: TObject);
    procedure pZoomInEnd(Sender: TObject);
    procedure pDblClick(Sender: TObject);
    procedure pPaintBoxPaint(Sender: TObject);
    procedure pBitmapPaint(Sender: TObject; BitmapCanvas: TCanvas);
  private
    PCs : array [1..Objetos] of TdrRectangle;
    PRs : array [1..Objetos] of TDoublePoint;
    procedure CheckWidgets;
    procedure SetPenWidth;
    procedure UpdateObjects();
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.cmdZoomInClick(Sender: TObject);
begin
  p.ProportionalZoom := chkProportionalZoom.Checked;
  p.ZoomingIn := not p.ZoomingIn;
end;

procedure TForm1.cmdOneToOneClick(Sender: TObject);
begin
  p.OneToOne();
  //UpdateObjects();
end;

procedure TForm1.cmdZoomOutClick(Sender: TObject);
var
  Factor: string;
begin
  Factor := '1.0';
  if InputQuery('Zoom Out', 'Enter factor:', Factor) then
     begin
     p.ZoomIn(toFloat(Factor, 1));
     end;
end;

procedure TForm1.cmdSizeToImageClick(Sender: TObject);
begin
  p.SizeToImage;
end;

procedure TForm1.cmdPaintClick(Sender: TObject);
begin
  p.Painting := not p.Painting;
end;

procedure TForm1.chkAlignedClick(Sender: TObject);
const
  Aligns: array [Boolean] of TAlign = (alNone, alClient);
begin
  if chkAligned.Checked then chkResizable.Checked := False;
  p.Align := Aligns[chkAligned.Checked];
end;

procedure TForm1.pMouseMove(Sender: TObject;
                                        Shift: TShiftState;
                                        DeviceX, DeviceY: Integer;
                                        ActualX, ActualY: Double);
const
  sFormat = '0.00';
begin
  if not p.ScaleDefined then Exit;
  lblXY.Caption := '(' + FormatFloat(sFormat, ActualX) + ', ' +
                   FormatFloat(sFormat, ActualY) + ')';
end;

procedure TForm1.pZoomInBegin(Sender: TObject);
const
  ZoomingStatus: array [Boolean] of string = ('', 'Zooming');
  ZoomInCaptions: array [Boolean] of string = ('Zoom &In', '&Cancel');
begin
  lblStatus.Caption := ZoomingStatus[p.ZoomingIn];
  cmdZoomIn.Caption := ZoomInCaptions[p.ZoomingIn];
  CheckWidgets;
end;

procedure TForm1.pPaintBegin(Sender: TObject);
const
  PaintingStatus: array [Boolean] of string = ('', 'Painting');
  PaintCaptions: array [Boolean] of string = ('&Paint', '&Cancel');
begin
  lblStatus.Caption := PaintingStatus[p.Painting];
  cmdPaint.Caption := PaintCaptions[p.Painting];
  CheckWidgets;
end;

procedure TForm1.CheckWidgets;
begin
  cmdLoadImage.Enabled := not Assigned(p.Bitmap);
  cmdZoomIn.Enabled := Assigned(p.Bitmap) and
                       not p.Painting;
  cmdOneToOne.Enabled := Assigned(p.Bitmap) and
                         not p.ZoomingIn and
                         not p.Painting;
  cmdZoomOut.Enabled := Assigned(p.Bitmap) and
                        not p.ZoomingIn and
                        not p.Painting;
  cmdSizeToImage.Enabled := Assigned(p.Bitmap) and
                            not p.ZoomingIn and
                            not p.Painting;
  cmdPaint.Enabled := Assigned(p.Bitmap) and
                      not p.ZoomingIn;
end;

procedure TForm1.cmdLoadImageClick(Sender: TObject);
var
  Bitmap: TBitmap;
  i: integer;
begin
  if Open.Execute then
    begin
    Bitmap := TBitmap.Create;
    try
      Bitmap.LoadFromFile(Open.FileName);
      p.Bitmap := Bitmap;

      p.SetFirstScalePoint(
        MakePoint(0, Bitmap.Height),
        MakeDoublePoint(0, 0));
{
      p.SetSecondScalePoint(
        MakeLongintPoint(Bitmap.Width, 0),
        MakeDoublePoint(1000, 1000));
}
      // Faz com que a escala seja do mesmo tamanho da imagem
      p.SetSecondScalePoint(
        MakePoint(Bitmap.Width, 0),
        MakeDoublePoint(Bitmap.Width, Bitmap.Height));

      p.DefineScaleNoSkew(False, False);

      // Obtem a posicao real dos objetos
      for i := 1 to Objetos do
        begin
        PCs[i] := TdrRectangle.Create(p);
        PCs[i].SetBounds(Random(Bitmap.Width), Random(Bitmap.Height), 10, 10);
        PCs[i].Color := Random(10000000);
        PCs[i].Parent := p;
        PRs[i] := p.DeviceToActual(PCs[i].Center);
        end;
      finally
        Bitmap.Free;
      end;
    end;

  CheckWidgets;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  CheckWidgets;
end;

procedure TForm1.chkResizableClick(Sender: TObject);
begin
  p.Sizable := chkResizable.Checked;
end;

procedure TForm1.SetPenWidth;
begin
  p.PenWidth := StrToIntDef(txtPenWidth.Text, 1);
end;

procedure TForm1.txtPenWidthChange(Sender: TObject);
begin
  SetPenWidth();
end;

procedure TForm1.UpdateObjects();
var PT, PT2: TPoint;
    i: integer;
begin
  for i := 1 to Objetos do
    begin
    // Calcula as coordenadas de tela
    PT := p.ActualToDevice(PRs[i]);

    // Teste de reposicionamento
    PCs[i].Center := PT;
    end;

  EXIT; // <------------------------------

  // liga os PCs
  p.PaintBoxCanvas.Pen.Color := clBlack;
  for i := 2 to Objetos do
    begin
    // Calcula as coordenadas de tela
    PT := p.ActualToDevice(PRs[i-1]);
    PT2 := p.ActualToDevice(PRs[i]);
    p.PaintBoxCanvas.MoveTo(PT.X, PT.Y);
    p.PaintBoxCanvas.LineTo(PT2.X, PT2.Y);
    end;

end;

procedure TForm1.pZoomInEnd(Sender: TObject);
begin
  pZoomInBegin(Sender);
end;

procedure TForm1.pDblClick(Sender: TObject);
begin
  Caption := ' Duplo-Click';
end;

procedure TForm1.pPaintBoxPaint(Sender: TObject);
begin
  if p.ScaleDefined and not p.Painting then
     UpdateObjects();
end;

procedure TForm1.pBitmapPaint(Sender: TObject; BitmapCanvas: TCanvas);
var i: Integer;
    PT1, PT2: TPoint;
begin
  //EXIT; // <------------------------------

  // liga os PCs
  BitmapCanvas.Pen.Color := clBlack;
  for i := 2 to Objetos do
    begin
    // Calcula as coordenadas de tela
    PT1 := p.ScaleSystem.ActualToMaster (PRs[i-1]);
    PT2 := p.ScaleSystem.ActualToMaster (PRs[i]);
    BitmapCanvas.MoveTo(PT1.X, PT1.Y);
    BitmapCanvas.LineTo(PT2.X, PT2.Y);
    end;
end;

end.
