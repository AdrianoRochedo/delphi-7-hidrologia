program MapaBahia;

uses
  Forms,
  Mapa in 'Mapa.pas' {Mapa_DLG},
  Cenarios in 'Cenarios.pas' {Cenarios_DLG},
  Dados_Cenarios in 'Dados_Cenarios.pas' {DadosSenario_DLG},
  ba_Classes in 'ba_Classes.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMapa_DLG, Mapa_DLG);
  Application.Run;
end.
