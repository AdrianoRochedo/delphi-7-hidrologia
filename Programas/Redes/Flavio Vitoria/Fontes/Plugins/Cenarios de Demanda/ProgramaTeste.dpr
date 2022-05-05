program ProgramaTeste;

uses
  ShareMem,
  Forms,
  windows,
  SysUtils,
  SysUtilsEx,
  Main in '..\Main.pas' {Form1},
  pr_Interfaces in '..\..\Unidades\pr_Interfaces.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run();
end.
