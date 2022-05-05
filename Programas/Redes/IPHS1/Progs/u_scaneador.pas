unit u_scaneador;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, jpeg;

type
  TForm1 = class(TForm)
    im: TImage;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    // vy = indice vertical inicial
    // il = indice da linha para a posicao vertical vy
    procedure calcular(vy, il, y1, y2, x1, x2: Integer; sl: TStrings);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var sl: TStrings;
begin
  sl := TStringList.Create;

  calcular(0, 0, 0, 125, 0, 239, sl);

  sl.SaveToFile('mapa.txt');
  sl.Free;
end;

procedure TForm1.calcular(vy, il, y1, y2, x1, x2: Integer; sl: TStrings);
var x, y: Integer;
    c: TCanvas;
    s: String[100];
    b: Boolean;
    cor: TColor;
begin
  cor := clRed;

  c := im.Picture.Bitmap.Canvas;
  for y := y1 to y2 do
    begin
    b := true;
    s := '';
    for x := x1 to x2 do
      begin
      if (c.Pixels[x, y] = cor) and (c.Pixels[x+1, y] <> cor) and b then
         begin
         s := format('FVerticalLines[%d][%d].p1 := point(%d, %d);  ', [vy, il, x, y]);
         b := false;
         continue;
         end;

      if not b and (c.Pixels[x, y] = cor) then
         begin
         s := s + format('FVerticalLines[%d][%d].p2 := point(%d, %d);  ', [vy, il, x, y]);
         break;
         end;
      end;
    SL.Add(s);
    inc(vy);
    end;
  sl.add('');
end;

end.
