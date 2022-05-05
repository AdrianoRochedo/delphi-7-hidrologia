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
  ShareMem,
  Application_Class in '..\..\..\Comum\Lib\Application_Class.pas' {Application: TDataModule},
  ch_Tipos in 'Unidades\ch_Tipos.pas',
  ch_Procs in 'Unidades\ch_Procs.pas',
  ch_Const in 'Unidades\ch_Const.PAS',
  ch_Acoes in 'Unidades\ch_Acoes.pas',
  FramePeriodosValidos in 'Frames\FramePeriodosValidos.pas' {Frame_PeriodosValidos: TFrame},
  FrameSelecaoDePostos in 'Frames\FrameSelecaoDePostos.pas' {Frame_SelecaoDePostos: TFrame},
  FrameAbout in 'About\FrameAbout.pas' {Frame1: TFrame},
  Principal in 'Dialogos\Principal.pas' {DLG_Principal},
  ObterPeriodosValidos in 'Dialogos\ObterPeriodosValidos.PAS' {DLG_ObterPeriodosValidos},
  ObterPeriodo in 'Dialogos\ObterPeriodo.pas' {DLG_ObterPeriodo},
  AnaliseDasFalhas in 'Dialogos\AnaliseDasFalhas.PAS' {DLG_AnaliseDeFalhas},
  AnaliseAnual in 'Dialogos\AnaliseAnual.PAS' {DLG_AnaliseAnual},
  AnalisePorAgrupamento in 'Dialogos\AnalisePorAgrupamento.pas' {DLG_AnalisePorAgrupamento},
  CalculoDeNovosPostos in 'Dialogos\CalculoDeNovosPostos.pas' {DLG_CalcularNovosPostos},
  OpcoesDeImpressao in 'Dialogos\OpcoesDeImpressao.pas' {DLG_OpcoesDeImpressao},
  ETP in 'Dialogos\ETP.PAS' {DLG_ETP},
  ETP_Media in 'Dialogos\ETP_Media.PAS' {DLG_ETP_Media},
  PLU in 'Dialogos\PLU.PAS' {DLG_PLU},
  PLU_Opcoes in 'Dialogos\PLU_Opcoes.pas' {DLG_PLU_Opcoes},
  VZO in 'Dialogos\VZO.PAS' {DLG_VZO},
  Graf_CurvaDePermanencia_OPT in 'Graficos\Graf_CurvaDePermanencia_OPT.PAS' {GRF_CurvaDePermanencia},
  Graf_DuplaMassa_OPT in 'Graficos\Graf_DuplaMassa_OPT.PAS' {GRF_DuplaMassa},
  Graf_Chuva_X_vazao in 'Graficos\Graf_Chuva_X_vazao.PAS' {Graf_Chuva_X_Vazao_Form},
  Graf_chuvaXvazao_OPT in 'Graficos\Graf_chuvaXvazao_OPT.pas' {GRF_chuvaXvazao},
  Graf_GANTT in 'Graficos\Graf_GANTT.PAS' {GRF_Gantt},
  Valores_Chuva_X_Vazao in 'Graficos\Valores_Chuva_X_Vazao.pas' {Valores_Chuva_X_Vazao_Form},
  Leg_Chuva_X_Vazao in 'Graficos\Leg_Chuva_X_Vazao.pas' {Leg_Chuva_X_Vazao_Form},
  FormAbout in 'Dialogos\FormAbout.pas' {FAbout},
  pro_fo_DataImport in 'Dialogos\pro_fo_DataImport.pas' {foDataImport},
  pro_Interfaces in 'Unidades\pro_Interfaces.pas',
  pro_Plugins in 'Unidades\pro_Plugins.pas';

{$R *.RES}

begin
  Applic := TchApplication.Create('PROCEDA', '1.0');
  Applic.Run();
  Applic.Free();
end.
