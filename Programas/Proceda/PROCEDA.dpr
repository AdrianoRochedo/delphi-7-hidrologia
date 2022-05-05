program PROCEDA;

{ DIRETIVAS DE COMPILACAO:

    - VERSAO_LIMITADA: limita recursos do programa

}

{---------------------------------------------------------------------------------------}
{ATENCAO: Compilar com a diretiva "Range Check" desligada senao erros ocorrem na criacao
          de novos postos por calculo}

{ DOCUMENTAÇÃO:
  - As operações que necessitarem do contexto do DST irão no menu principal e as que não,
    poderão ser localizadas na árvore. Isto é, as operações que podem serem feitas posto a
    posto, são operações atômicas e sendo assim não necessitam do contexto do DST.

  - Para o cálculo de estatísticas, sempre utilizar os métodos "DataDoPrimeiroValorValido" e
    "DataDoUltimoValorValido" para obter o menor intervalo possível para os dados.

  COMO:
  - Implementar novas estatísticas atômicas ?
    - Derive classes de TSerie
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

{%ToDo 'PROCEDA.todo'}
{%File 'Bin\Historico.txt'}

uses
  ShareMem,
  Frame_HTML_IE,
  Application_Class,
  pro_Interfaces in 'Source\Units\pro_Interfaces.pas',
  pro_DB_Interfaces in 'Source\Units\pro_DB_Interfaces.pas',
  pro_BaseClasses in 'Source\Units\pro_BaseClasses.pas',
  pro_Classes in 'Source\Units\pro_Classes.pas',
  pro_DB_Classes in 'Source\Units\pro_DB_Classes.pas',
  pro_Procs in 'Source\Units\pro_Procs.pas',
  pro_Const in 'Source\Units\pro_Const.pas',
  pro_Actions in 'Source\Units\pro_Actions.pas',
  pro_Plugins in 'Source\Units\pro_Plugins.pas',
  pro_Application in 'Source\Units\pro_Application.pas',
  pro_fr_getValidIntervals in 'Source\Frames\pro_fr_getValidIntervals.pas' {Frame_getValidIntervals: TFrame},
  pro_fr_StationSelections in 'Source\Frames\pro_fr_StationSelections.pas' {Frame_SelecaoDePostos: TFrame},
  pro_fr_Abount in 'Source\Frames\pro_fr_Abount.pas' {frAbout: TFrame},
  pro_fo_Main in 'Source\Dialogs\pro_fo_Main.pas' {DLG_Principal},
  pro_fo_getValidIntervals in 'Source\Dialogs\pro_fo_getValidIntervals.pas' {DLG_ObterPeriodosValidos},
  pro_fo_getInterval in 'Source\Dialogs\pro_fo_getInterval.pas' {DLG_ObterPeriodo},
  pro_fo_FaultAnalysis in 'Source\Dialogs\pro_fo_FaultAnalysis.pas' {DLG_AnaliseDeFalhas},
  pro_fo_YearAnalysis in 'Source\Dialogs\pro_fo_YearAnalysis.pas' {DLG_AnaliseAnual},
  pro_fo_GroupAnalysis in 'Source\Dialogs\pro_fo_GroupAnalysis.pas' {DLG_AnalisePorAgrupamento},
  pro_fo_GenerateNewStations in 'Source\Dialogs\pro_fo_GenerateNewStations.pas' {DLG_CalcularNovosPostos},
  pro_fo_ETP_Generation in 'Source\Dialogs\pro_fo_ETP_Generation.pas' {DLG_ETP},
  pro_fo_ETP_Media in 'Source\Dialogs\pro_fo_ETP_Media.pas' {DLG_ETP_Media},
  pro_fo_PLU_Generation in 'Source\Dialogs\pro_fo_PLU_Generation.pas' {DLG_PLU},
  pro_fo_PLU_Generation_Options in 'Source\Dialogs\pro_fo_PLU_Generation_Options.pas' {DLG_PLU_Opcoes},
  pro_fo_VZO_Generation in 'Source\Dialogs\pro_fo_VZO_Generation.pas' {DLG_VZO},
  pro_fo_PermanentCurve in 'Source\Dialogs\pro_fo_PermanentCurve.pas' {GRF_CurvaDePermanencia},
  pro_fo_DoubleMass in 'Source\Dialogs\pro_fo_DoubleMass.pas' {GRF_DuplaMassa},
  pro_fo_PLU_VZO in 'Source\Dialogs\pro_fo_PLU_VZO.pas' {GRF_chuvaXvazao},
  pro_fo_PLU_VZO_Values in 'Source\Dialogs\pro_fo_PLU_VZO_Values.pas' {Valores_Chuva_X_Vazao_Form},
  pro_fo_PLU_VZO_Legends in 'Source\Dialogs\pro_fo_PLU_VZO_Legends.pas' {Leg_Chuva_X_Vazao_Form},
  pro_fo_Abount in 'Source\Dialogs\pro_fo_Abount.pas' {foAbout},
  pro_fo_InsertStation in 'Source\Dialogs\pro_fo_InsertStation.pas' {foInsertStation},
  pro_fo_DataExport in 'Source\Dialogs\pro_fo_DataExport.pas' {foDataExport},
  pro_fo_DataImport in 'Source\Dialogs\pro_fo_DataImport.pas' {foDataImport},
  pro_fo_Station_EditExtraData in 'Source\Dialogs\pro_fo_Station_EditExtraData.pas' {foStation_EditExtraData},
  pro_fo_Memo in 'Source\Dialogs\pro_fo_Memo.pas' {foMemo},
  pro_grp_PLU_VZO in 'Source\Dialogs\pro_grp_PLU_VZO.pas' {Graf_Chuva_X_Vazao_Form},
  pro_grp_Gantt in 'Source\Dialogs\pro_grp_Gantt.pas' {GRF_Gantt},
  pro_fo_Series_LinearModel in 'Source\Dialogs\pro_fo_Series_LinearModel.pas' {foSeries_LinearModel},
  pro_fo_Series_DescEstats in 'Source\Dialogs\pro_fo_Series_DescEstats.pas' {foSeries_DescEstats},
  pro_fo_Series_FrequencyAnalisys in 'Source\Dialogs\pro_fo_Series_FrequencyAnalisys.pas' {foSeries_FrequencyAnalisys},
  pro_fo_ViewDataSet in 'Source\Dialogs\pro_fo_ViewDataSet.pas' {foViewDataset},
  pro_fo_ConnectionType in 'Source\Dialogs\pro_fo_ConnectionType.pas' {foConnectionType},
  pro_fo_BaseConnection in 'Source\Dialogs\pro_fo_BaseConnection.pas' {foBaseConnection},
  pro_fo_Access_Connection in 'Source\Dialogs\pro_fo_Access_Connection.pas' {foAccess_Connection},
  pro_fr_Dates in 'Source\Frames\pro_fr_Dates.pas' {frDates: TFrame},
  pro_fo_DefineDates in 'Source\Dialogs\pro_fo_DefineDates.pas' {foDefineDates},
  pro_Skins_Dist in 'Source\Units\pro_Skins_Dist.pas',
  fo_Skin_Dialog in 'Source\Dialogs\Distribuitions\fo_Skin_Dialog.pas' {foSkinDialog},
  fr_ParDistrib in 'Source\Frames\Distribuitions\fr_ParDistrib.pas' {Frame_ParDistrib: TFrame},
  fo_SkinDistBase in 'Source\Dialogs\Distribuitions\fo_SkinDistBase.pas' {foSkinDistBase},
  fo_SkinDist_WithParameters in 'Source\Dialogs\Distribuitions\fo_SkinDist_WithParameters.pas' {foSkinDist_WithParameters},
  fo_SkinDist_OneParameter in 'Source\Dialogs\Distribuitions\fo_SkinDist_OneParameter.pas' {foSkinDist_OneParameter},
  fo_SkinDist_TwoParameters in 'Source\Dialogs\Distribuitions\fo_SkinDist_TwoParameters.pas' {foSkinDist_TwoParameters},
  MonthDialog in '..\..\..\Lib\Dialogs\MonthDialog.pas' {Form1},
  fo_SkinDist_TreeParameters in 'Source\Dialogs\Distribuitions\fo_SkinDist_TreeParameters.pas' {foSkinDist_TreeParameters},
  pro_fr_IntervalsOfStations in 'Source\Frames\pro_fr_IntervalsOfStations.pas' {frIntervalsOfStations: TFrame},
  pro_fo_AnalysisOfIntervals in 'Source\Dialogs\pro_fo_AnalysisOfIntervals.pas' {foAnaliseDePeriodos},
  Frame_RTF in '..\..\..\Lib\Frames\Frame_RTF.pas' {fr_RTF: TFrame},
  SpreadSheetBook_Frame in '..\..\..\Lib\SpreadSheet\SpreadSheetBook_Frame.pas' {SpreadSheetBookFrame: TFrame},
  Frame_Memo in '..\..\..\Lib\Frames\Frame_Memo.pas' {fr_Memo: TFrame},
  pro_fo_PLU_SelPerCont in 'Source\Dialogs\pro_fo_PLU_SelPerCont.pas' {foPLU_SelPerCont},
  Frame_CheckListBox in '..\..\..\Lib\Frames\frame_CheckListBox.pas' {FrameCheckListBox: TFrame},
  psScriptControl in '..\..\..\Lib\PascalScript\psScriptControl.pas' {foScriptControl},
  pro_psLib in 'Source\Units\pro_psLib.pas';

{$R *.RES}

begin
  TSystem.Run(
    TproApplication.Create('PROCEDA', '1.37'));
end.
