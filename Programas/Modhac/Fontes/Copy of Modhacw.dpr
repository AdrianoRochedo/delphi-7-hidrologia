program Modhacw;

{ HISTÓRICO:
  1.45 - Remoção das opções de modo de execução da janela de parâmetros
       - Diretório não é mais ReadOnly na janela de Opções Gerais
       - Intervalos de Simulação não pode ser igual a zero

  1.46 - Compilado com Delphi 6 pela primeira vez

  1.50 - Reorganização de código e Nomes
}

uses
  Forms,
  SysUtils,
  SysUtilsEx,
  WinUtils,
  wsGLib,
  wsOutPut,
  Assist,
  mh_Bacia_Calibracao in 'Dialogos\mh_Bacia_Calibracao.PAS' {DLG_Ctrl_Calibracao},
  mh_GRF_ChuvaVazao_Estatisticas in 'Graficos\mh_GRF_ChuvaVazao_Estatisticas.pas' {DLG_Estat},
  mh_GerenteDeProjeto in 'Dialogos\mh_GerenteDeProjeto.PAS' {DLG_Gerente},
  mh_GRF_VZCxVZO in 'Graficos\mh_GRF_VZCxVZO.pas' {DLG_Graphic_2},
  mh_About in 'Dialogos\mh_About.pas' {DLG_Info},
  mh_HistoricoDosParametros in 'Dialogos\mh_HistoricoDosParametros.pas' {DLG_Historico},
  mh_Bacia_DadosGerais in 'Dialogos\mh_Bacia_DadosGerais.pas' {DLG_Informacoes},
  mh_GRF_ChuvaVazao_Legenda in 'Graficos\mh_GRF_ChuvaVazao_Legenda.pas' {DLG_Leg},
  mh_JanelaPrincipal in 'Dialogos\mh_JanelaPrincipal.PAS' {DLG_Main},
  mh_OpcoesGerais in 'Dialogos\mh_OpcoesGerais.PAS' {DLG_OpcoesGerente},
  mh_Bacia_Parametros in 'Dialogos\mh_Bacia_Parametros.pas' {DLG_Parametros},
  mh_Bacia_Simulacao in 'Dialogos\mh_Bacia_Simulacao.PAS' {DLG_Ctrl_Simulacao},
  mh_SPLASH in 'Dialogos\mh_SPLASH.PAS' {SplashForm},
  mh_GRF_ChuvaVazao_Valores in 'Graficos\mh_GRF_ChuvaVazao_Valores.pas' {DLG_Vals},
  mh_Classes in 'Unidades\mh_Classes.pas',
  mh_TCs in 'Unidades\mh_TCs.PAS',
  mh_Procs in 'Unidades\mh_Procs.pas',
  mh_Vars in 'Unidades\mh_Vars.pas',
  mh_GRF_EvolucaoDosParametros in 'Graficos\mh_GRF_EvolucaoDosParametros.pas' {DLG_GraphicPar},
  mh_GRF_ChuvaVazao in 'Graficos\mh_GRF_ChuvaVazao.pas' {DLG_Graphic_1},
  mh_OPC_GRF_CurvaDePermanencia in 'Dialogos\mh_OPC_GRF_CurvaDePermanencia.pas' {DLG_CurvaDePermanencia};

{$R *.RES}

var dlgSplash: TSplashForm;
begin
  dlgSplash := TSplashForm.Create(Application);
  dlgSplash.Show;
  Delay(2000);
  dlgSplash.Free;

  mhApplication.Initialize;
  mhApplication.CreateForm(TDLG_Main, DLG_Main);

  // *********************
  mhApplication.Run;
  // *********************

  mhApplication.Finalize;
end.
