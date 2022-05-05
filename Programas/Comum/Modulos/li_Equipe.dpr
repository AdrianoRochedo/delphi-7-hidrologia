Library li_Equipe;

uses
  Forms,
  Equipe in 'EQUIPE.PAS' {DLG_Equipe};

{$R *.RES}

Procedure ShowAbout_1; Export;
var D: TDLG_Equipe;
Begin
  D := TDLG_Equipe.Create(nil);
  D.ShowModal;
  D.Free;
End;

Exports
  ShowAbout_1  index 1 name 'ShowAbout_1';

begin
end.
