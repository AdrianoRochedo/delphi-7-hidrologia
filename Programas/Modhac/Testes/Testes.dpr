program Testes;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  Rochedo.TrackBar in 'Rochedo.TrackBar.pas',
  SpreadSheetBook_Frame in '..\..\..\..\Lib\SpreadSheet\SpreadSheetBook_Frame.pas' {SpreadSheetBookFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
