program ImageScanner;

uses
  Forms,
  u_scaneador in 'u_scaneador.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
