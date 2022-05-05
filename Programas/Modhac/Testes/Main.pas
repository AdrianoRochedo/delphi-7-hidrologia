unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Rochedo.TrackBar, SpreadSheetBook_Frame;

type
  TForm1 = class(TForm)
    FBar: TdrTrackBar;
    p: TSpreadSheetBookFrame;
    procedure FBarChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FBarChange(Sender: TObject);
begin
  caption := FloatToStr(FBar.Position);
  p.ActiveSheet.Write(1, 2, FBar.Position);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FBar.Position := 100.3;
  p.ActiveSheet.WriteCenter(1, 1, true, 'teste');
  p.ActiveSheet.Write(1, 2, FBar.Position);
end;

end.
