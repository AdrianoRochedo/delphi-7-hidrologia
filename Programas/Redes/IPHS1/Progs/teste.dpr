program teste;

uses
  Forms,
  u_teste in 'u_teste.pas' {Form2},
  iphs1_GaugeDoReservatorio in '..\Unidades\iphs1_GaugeDoReservatorio.pas',
  iphs1_Dialogo_Res_VisNivel in '..\Dialogos\iphs1_Dialogo_Res_VisNivel.pas' {foiphs1_Dialogo_Res_VisNivel};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
