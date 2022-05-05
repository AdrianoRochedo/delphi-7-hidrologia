program MPSGenerator;

uses
  Forms,
  SysUtils,
  formMain in 'formMain.pas',
  MPSConversor in 'F:\Projetos\Lib\Geral\MPSConversor.pas';

{$R *.res}

begin
  SysUtils.DecimalSeparator := '.';
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
