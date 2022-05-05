program Chuvaz_to_Proceda;

{
  Converte arquivos do Chuvaz 1.0 para o formato do programa Proceda
}

uses
  Forms,
  Main in 'Main.pas' {foMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfoMain, foMain);
  Application.Run;
end.
