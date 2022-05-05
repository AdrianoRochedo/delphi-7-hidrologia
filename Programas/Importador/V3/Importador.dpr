program Importador;

uses
  Forms,
  Principal in 'Principal.pas' {DLG_Principal};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDLG_Principal, DLG_Principal);
  Application.Run;
end.
