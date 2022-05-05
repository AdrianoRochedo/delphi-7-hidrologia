program LP_Solver_Res_Reader_Test;

uses
  Forms,
  Main in 'Main.pas' {foMain},
  LP_Solver_Res_Reader in '..\..\..\..\..\..\Lib\Optimizers\LP_Solver_Res_Reader.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfoMain, foMain);
  Application.Run;
end.
