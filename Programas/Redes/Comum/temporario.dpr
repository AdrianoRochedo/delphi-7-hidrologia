program temporario;



uses
  Forms,
  AreaDeProjeto_base in 'Dialogos\AreaDeProjeto_base.PAS' {Form_AreaDeProjeto_base},
  Dialogo_base in 'Dialogos\Dialogo_base.pas' {Form_Dialogo_Base},
  Dialogo_TD in 'Dialogos\Dialogo_TD.pas' {Form_Dialogo_TD},
  Dialogo_SB in 'Dialogos\Dialogo_SB.pas' {Form_Dialogo_SB},
  Dialogo_Projeto in 'Dialogos\Dialogo_Projeto.pas' {Form_Dialogo_Projeto},
  Dialogo_Projeto_RU in 'Dialogos\Dialogo_Projeto_RU.pas' {Form_Dialogo_Projeto_RU},
  VisaoEmArvore_base in 'Dialogos\VisaoEmArvore_base.pas' {Form_VisaoEmArvore_base},
  Planilha_base in 'Planilhas\Planilha_base.pas' {Form_Planilha_Base},
  pr_Dialogo_PlanilhaBase in '..\Propagar\Dialogos\pr_Dialogo_PlanilhaBase.pas' {prDialogo_PlanilhaBase},
  Planilha_DadosDosObjetos in 'Planilhas\Planilha_DadosDosObjetos.pas' {Form_Planilha_DadosDosObjetos};

{$R *.RES}

begin
  Application.Initialize;
  Application.Run;
end.
