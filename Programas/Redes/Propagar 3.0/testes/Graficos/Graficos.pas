unit Graficos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GraphicUtils, StdCtrls, Shapes, Zoomler;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    z: TZoomler;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var p, p1, p2: TPoint;
begin
  p1 := Point(200, 200);

  p2 := Point(20, 60);
  Canvas.Pen.Width := 1;
  Canvas.Pen.Color := clBLACK;
  DesenhaSeta(Canvas, p1, p2, 30, 20);
  p := ObterPontoNaReta(p1, p2, 80);
  Canvas.Pen.Width := 1;
  Canvas.Pen.Color := clRED;
  Canvas.Ellipse(p.x-4, p.Y-4, p.x+4, p.Y+4);

  p2 := Point(300, 300);
  Canvas.Pen.Width := 2;
  Canvas.Pen.Color := clBLUE;
  DesenhaSeta(Canvas, p1, p2, 30, 20);
  p := ObterPontoNaReta(p1, p2, 80);
  Canvas.Pen.Width := 1;
  Canvas.Pen.Color := clRED;
  Canvas.Ellipse(p.x-4, p.Y-4, p.x+4, p.Y+4);

  p2 := Point(300, 20);
  Canvas.Pen.Width := 3;
  Canvas.Pen.Color := clGREEN;
  DesenhaSeta(Canvas, p1, p2, 30);
  p := ObterPontoNaReta(p1, p2, 80);
  Canvas.Pen.Width := 1;
  Canvas.Pen.Color := clRED;
  Canvas.Ellipse(p.x-4, p.Y-4, p.x+4, p.Y+4);

  p2 := Point(20, 300);
  Canvas.Pen.Width := 4;
  Canvas.Pen.Color := clRED;
  DesenhaSeta(Canvas, p1, p2, 30);
  p := ObterPontoNaReta(p1, p2, 80);
  Canvas.Pen.Width := 1;
  Canvas.Pen.Color := clBLUE;
  Canvas.Ellipse(p.x-6, p.Y-6, p.x+6, p.Y+6);

  // retas paralelas ...

  p1 := Point(20, 340);
  p2 := Point(300, 340);
  Canvas.Pen.Width := 2;
  Canvas.Pen.Color := clBLUE;
  DesenhaSeta(Canvas, p1, p2, 30);

  p1 := Point(20, 370);
  p2 := Point(300, 370);
  Canvas.Pen.Width := 2;
  Canvas.Pen.Color := clBLUE;
  DesenhaSeta(Canvas, p1, p2, 30, 50);

  p := ObterPontoNaReta(p1, p2, 80);
  Canvas.Pen.Width := 1;
  Canvas.Pen.Color := clRED;
  Canvas.Ellipse(p.x-4, p.Y-4, p.x+4, p.Y+4);
end;

procedure TForm1.Button2Click(Sender: TObject);
var s: TdrFlag;
    i, j: integer;
begin
  s := TdrFlag.Create(self);
  s.Parent := self;
  s.SetBounds(50, 50, 100, 200);
  s.ThreeD := false;
  s.Paint();

  s := TdrFlag.Create(self);
  s.Color := clBlack;
  s.Parent := self;
  s.SetBounds(250, 50, 18, 25);
  s.ThreeD := false;
  s.Paint();

  sleep(500);
  s.Color := clRED;
  s.Paint();

  sleep(500);
  s.Color := clBLUE;
  s.Paint();

  sleep(500);
  s.Color := clYellow;
  s.Paint();

  sleep(500);
  s.Color := clRED;
  s.Paint();

  sleep(500);
  for i := 0 to 255 do
    for j := 0 to 255 do
      begin
      s.Color := RGB(i, j, 150);
      s.Paint();
      end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  z := TZoomler.Create(self);
  z.Parent := self;
  //z.SetBounds(20, 50, Width-20, Height-50);
  z.Top := 100;
  z.Left := 20;
end;

end.
