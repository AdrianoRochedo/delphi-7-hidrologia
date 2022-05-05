program chuvaz_V3;

{ DOCUMENTAÇÃO:
  - As operações que necessitarem do contexto do DST irão no menu principal e as que não,
    poderão ser localizadas na árvore. Isto é, as operações que podem serem feitas posto a
    posto, são operações atômicas e sendo assim não necessitam do contexto do DST.

  - Para o cálculo de estatísticas, sempre utilizar os métodos "DataDoPrimeiroValorValido" e
    "DataDoUltimoValorValido" para obter o menor intervalo possível para os dados.

  COMO:
  - Implementar novas estatísticas atômicas ?
    - Derive classes de TEstatistica
    - Sobreescreva os métodos "Iniciar" e "Calcular"
    - No método "Iniciar" forneça uma classificação (prop. Classe) e defina as possíveis ações
      através do método "CriarAcao". Se uma determinada ação ainda não foi definida na janela
      principal então defina um método do tipo TNotifyEvent, crie também uma variável global em
      ch_Vars.pas e associe este método criado a esta var. global no evento OnCreate da janela
      principal.
      Também, opcionalmente, você poderá definir o nome da estatística e o nome da instancia
    - Na janela principal, através do menu "Menu_Posto", crie um item que invoque "CalcularEstatistica"
    - Complemente o método "CalcularEstatistica"
    - O restante será gerenciado pela janela principal.

  - Implementar opções atômicas para os postos ?
    - Adicione um item ao menu "Menu_Posto" e implemente este item
    - O restante será gerenciado pela janela principal.

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
