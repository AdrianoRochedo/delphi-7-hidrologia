program chuvaz_V3;

{ DOCUMENTA��O:
  - As opera��es que necessitarem do contexto do DST ir�o no menu principal e as que n�o,
    poder�o ser localizadas na �rvore. Isto �, as opera��es que podem serem feitas posto a
    posto, s�o opera��es at�micas e sendo assim n�o necessitam do contexto do DST.

  - Para o c�lculo de estat�sticas, sempre utilizar os m�todos "DataDoPrimeiroValorValido" e
    "DataDoUltimoValorValido" para obter o menor intervalo poss�vel para os dados.

  COMO:
  - Implementar novas estat�sticas at�micas ?
    - Derive classes de TEstatistica
    - Sobreescreva os m�todos "Iniciar" e "Calcular"
    - No m�todo "Iniciar" forne�a uma classifica��o (prop. Classe) e defina as poss�veis a��es
      atrav�s do m�todo "CriarAcao". Se uma determinada a��o ainda n�o foi definida na janela
      principal ent�o defina um m�todo do tipo TNotifyEvent, crie tamb�m uma vari�vel global em
      ch_Vars.pas e associe este m�todo criado a esta var. global no evento OnCreate da janela
      principal.
      Tamb�m, opcionalmente, voc� poder� definir o nome da estat�stica e o nome da instancia
    - Na janela principal, atrav�s do menu "Menu_Posto", crie um item que invoque "CalcularEstatistica"
    - Complemente o m�todo "CalcularEstatistica"
    - O restante ser� gerenciado pela janela principal.

  - Implementar op��es at�micas para os postos ?
    - Adicione um item ao menu "Menu_Posto" e implemente este item
    - O restante ser� gerenciado pela janela principal.

}

uses
  Forms,
  WinUtils,
  Principal in 'Dialogos\Principal.pas' {DLG_Principal},
  ch_Tipos in 'Unidades\ch_Tipos.pas',
  ch_Procs in 'Unidades\ch_Procs.pas',
  ch_Vars in 'Unidades\ch_Vars.pas',
  ObterPeriodosValidos in 'Dialogos\ObterPeriodosValidos.PAS' {DLG_ObterPeriodosValidos},
  AnaliseDasFalhas in 'Dialogos\AnaliseDasFalhas.PAS' {DLG_AnaliseDeFalhas},
  ch_Const in 'Unidades\ch_Const.PAS',
  AnaliseAnual in 'Dialogos\AnaliseAnual.PAS' {DLG_AnaliseAnual},
  AnalisePorAgrupamento in 'Dialogos\AnalisePorAgrupamento.pas' {DLG_AnalisePorAgrupamento},
  OpcoesDeImpressao in 'Dialogos\OpcoesDeImpressao.pas' {DLG_OpcoesDeImpressao},
  FramePeriodosValidos in 'Frames\FramePeriodosValidos.pas' {Frame_PeriodosValidos: TFrame},
  CalculoDeNovosPostos in 'Dialogos\CalculoDeNovosPostos.pas' {DLG_CalcularNovosPostos},
  PLU in 'Dialogos\PLU.PAS' {DLG_PLU},
  PLU_Opcoes in 'Dialogos\PLU_Opcoes.pas' {DLG_PLU_Opcoes},
  ObterPeriodo in 'Dialogos\ObterPeriodo.pas' {DLG_ObterPeriodo},
  VZO in 'Dialogos\VZO.PAS' {DLG_VZO},
  ETP in 'Dialogos\ETP.PAS' {DLG_ETP},
  ETP_Media in 'Dialogos\ETP_Media.PAS' {DLG_ETP_Media},
  Graf_CurvaDePermanencia_OPT in 'Graficos\Graf_CurvaDePermanencia_OPT.PAS' {GRF_CurvaDePermanencia},
  Graf_DuplaMassa_OPT in 'Graficos\Graf_DuplaMassa_OPT.PAS' {GRF_DuplaMassa},
  Graf_Chuva_X_vazao in 'Graficos\Graf_Chuva_X_vazao.PAS' {Graf_Chuva_X_Vazao_Form},
  Valores_Chuva_X_Vazao in 'Graficos\Valores_Chuva_X_Vazao.pas' {Valores_Chuva_X_Vazao_Form},
  Leg_Chuva_X_Vazao in 'Graficos\Leg_Chuva_X_Vazao.pas' {Leg_Chuva_X_Vazao_Form},
  Graf_chuvaXvazao_OPT in 'Graficos\Graf_chuvaXvazao_OPT.pas' {GRF_chuvaXvazao},
  Graf_GANTT in 'Graficos\Graf_GANTT.PAS' {GRF_Gantt},
  FrameSelecaoDePostos in 'Frames\FrameSelecaoDePostos.pas' {Frame_SelecaoDePostos: TFrame},
  FrameAbout in 'About\FrameAbout.pas' {Frame1: TFrame},
  ch_Acoes in 'Unidades\ch_Acoes.pas',
  AdvClasses in '..\..\..\Comum\Lib\Temp\advClasses.pas',
  advClasses_Receptor in '..\..\..\Comum\Lib\Temp\advClasses_Receptor.pas',
  advClasses_Messages in '..\..\..\Comum\Lib\Temp\advClasses_Messages.pas',
  FormAbout in 'Dialogos\FormAbout.pas' {FAbout};

{$R *.RES}

begin
  WinUtils.PixelsPerInch := 96;

  Application.Initialize;
  Application.CreateForm(TDLG_Principal, DLG_Principal);
  ActionManager := Tch_ActionManager.Create(DLG_Principal.Arvore);

  IniciarVariaveisGlobais;
  Application.Run;
  FinalizarVariaveisGlobais;

  ActionManager.Free;
end.
