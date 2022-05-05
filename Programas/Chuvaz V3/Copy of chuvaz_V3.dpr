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
