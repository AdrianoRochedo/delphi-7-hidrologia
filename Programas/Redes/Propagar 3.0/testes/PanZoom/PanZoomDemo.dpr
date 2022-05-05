program PanZoomDemo;

uses
  Forms,
  SysUtils,
  Rochedo.PanZoom in 'Rochedo.PanZoom.pas',
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  SysUtils.DecimalSeparator := '.';
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
