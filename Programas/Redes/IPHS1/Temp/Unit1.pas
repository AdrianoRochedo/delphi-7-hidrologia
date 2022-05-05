unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    r: TTrackBar;
    g: TTrackBar;
    b: TTrackBar;
    procedure rChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.rChange(Sender: TObject);
begin
  with canvas do
    begin
    pen.Mode := pmCopy;
    brush.Color := clwhite;
    fillrect(rect(10, 10, 100, 100));

    pen.Mode := pmXor;
    pen.Width := 10;
    pen.Color := rgb(r.Position, g.Position, b.Position);
    moveto(0, 0);
    lineto(100, 100);

    caption := format('%d %d %d', [r.Position, g.Position, b.Position]);
    end
end;

end.
