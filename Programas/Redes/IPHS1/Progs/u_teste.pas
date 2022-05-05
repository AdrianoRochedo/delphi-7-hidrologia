unit u_teste;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, iphs1_GaugeDoReservatorio, jpeg, ComCtrls, StdCtrls, ExtCtrls,
  drEdit;

type
  TForm2 = class(TForm)
    gauge: TTrackBar;
    Button1: TButton;
    e: TdrEdit;
    procedure FormShow(Sender: TObject);
    procedure gaugeChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    im: Tiphs1_ResGause;
    b: Tiphs1_ResGause;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormShow(Sender: TObject);
begin
  b := Tiphs1_ResGause.Create;
  b.LoadFromFile('../imagens/Reservatorio.bmp');
end;

procedure TForm2.gaugeChange(Sender: TObject);
begin
  b.Percent := gauge.Position;
  canvas.Draw(0, 0, b);
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  b.Percent := e.AsInteger;
  canvas.Draw(0, 0, b);
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  b.Free;
end;

end.
