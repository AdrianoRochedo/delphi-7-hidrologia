program Conversor;

uses
  Forms,
  Main in 'Main.pas' {foMain},
  SpreadSheetBook_Frame in '..\..\..\..\..\Comum\SpreadSheet\SpreadSheetBook_Frame.pas' {SpreadSheetBookFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfoMain, foMain);
  Application.Run;
end.
