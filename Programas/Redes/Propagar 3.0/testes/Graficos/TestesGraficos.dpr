program TestesGraficos;

uses
  Forms,
  Graficos in 'Graficos.pas' {Form1},
  Zoomler in 'D:\Downloads\Componentes\zoomler\ZOOMLER.PAS';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
