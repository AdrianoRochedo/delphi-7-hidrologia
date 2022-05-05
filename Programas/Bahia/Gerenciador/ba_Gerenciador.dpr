program ba_Gerenciador;

uses
  Forms,
  Principal in 'Principal.pas' {Principal_DLG};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TPrincipal_DLG, Principal_DLG);
  Application.Run;
end.
