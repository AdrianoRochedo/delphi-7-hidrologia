program IPHS1_WIN;

{ ATENÇÃO:
  - Quando compilar a versão final, definir a diretiva "FINAL"
  - o "." é o separador decimal de todos os arquivos de dados
}

{ TO-DO

  - Perguntar sobre as validações ...
  - Hints ...
  - Posicionamento das janelas
  - Uso de cores nos PCs
}

{%File 'To-Do.txt'}
{%File 'Bin\{%File'}
{%File 'Bin\Historico.txt'}

uses
  ShareMem,
  Forms,
  sysUtils,
  Windows,
  Dialogs,
  WinUtils,
  MAIN in 'Dialogos\MAIN.PAS' {iphs1_Dialogo_Principal},
  AboutForm in 'Dialogos\AboutForm.pas' {iphs1_Form_About},
  Splash in 'Dialogos\Splash.pas' {iphs1_Form_Splash},
  AreaDeProjeto_base in '..\Comum\Dialogos\AreaDeProjeto_base.PAS' {Form_AreaDeProjeto_base},
  VisaoEmArvore_base in '..\Comum\Dialogos\VisaoEmArvore_base.pas' {Form_VisaoEmArvore_base},
  iphs1_AreaDeProjeto in 'Dialogos\iphs1_AreaDeProjeto.pas' {iphs1_Form_AreaDeProjeto},
  iphs1_VisaoEmArvore in 'Dialogos\iphs1_VisaoEmArvore.pas' {iphs1_Form_VisaoEmArvore},
  iphs1_Procs in 'Unidades\iphs1_Procs.pas',
  hidro_Constantes in '..\Comum\Unidades\hidro_Constantes.pas',
  iphs1_Classes in 'Unidades\iphs1_Classes.pas',
  hidro_Tipos in '..\Comum\Unidades\hidro_Tipos.pas',
  hidro_Procs in '..\Comum\Unidades\hidro_Procs.pas',
  hidro_Classes in '..\Comum\Unidades\hidro_Classes.pas',
  Dialogo_base in '..\Comum\Dialogos\Dialogo_base.pas' {Form_Dialogo_Base},
  Dialogo_Projeto_RU in '..\Comum\Dialogos\Dialogo_Projeto_RU.pas' {Form_Dialogo_Projeto_RU},
  Dialogo_Projeto in '..\Comum\Dialogos\Dialogo_Projeto.pas' {Form_Dialogo_Projeto},
  hidro_Variaveis in '..\Comum\Unidades\hidro_Variaveis.pas',
  esquemas_OpcoesGraf in '..\Comum\Unidades\esquemas_OpcoesGraf.pas',
  Planilha_base in '..\Comum\Planilhas\Planilha_base.pas' {Form_Planilha_Base},
  Planilha_DadosDosObjetos in '..\Comum\Planilhas\Planilha_DadosDosObjetos.pas' {Form_Planilha_DadosDosObjetos},
  iphs1_Dialogo_Base in 'Dialogos\iphs1_Dialogo_Base.pas' {iphs1_Form_Dialogo_Base},
  iphs1_Dialogo_PC in 'Dialogos\iphs1_Dialogo_PC.pas' {iphs1_Form_Dialogo_PC},
  iphs1_Dialogo_TD in 'Dialogos\iphs1_Dialogo_TD.pas' {iphs1_Form_Dialogo_TD},
  iphs1_Dialogo_TD_MPE_Base in 'Dialogos\iphs1_Dialogo_TD_MPE_Base.pas' {iphs1_Form_Dialogo_TD_MPE_Base},
  iphs1_Dialogo_TD_MPE_CL in 'Dialogos\iphs1_Dialogo_TD_MPE_CL.pas' {iphs1_Form_Dialogo_TD_MPE_CL},
  iphs1_Dialogo_TD_MPE_CNL in 'Dialogos\iphs1_Dialogo_TD_MPE_CNL.pas' {iphs1_Form_Dialogo_TD_MPE_CNL},
  iphs1_Dialogo_TD_MPE_CPI in 'Dialogos\iphs1_Dialogo_TD_MPE_CPI.pas' {iphs1_Form_Dialogo_TD_MPE_CPI},
  iphs1_Dialogo_TD_MPE_XK in 'Dialogos\iphs1_Dialogo_TD_MPE_XK.pas' {iphs1_Form_Dialogo_TD_MPE_XK},
  iphs1_Dialogo_Res in 'Dialogos\iphs1_Dialogo_Res.pas' {iphs1_Form_Dialogo_Res},
  iphs1_Dialogo_Res_TCV in 'Dialogos\iphs1_Dialogo_Res_TCV.pas' {iphs1_Form_Dialogo_Res_TCV},
  iphs1_Dialogo_Res_EE in 'Dialogos\iphs1_Dialogo_Res_EE.pas' {iphs1_Form_Dialogo_Res_EE},
  iphs1_Dialogo_SB in 'Dialogos\iphs1_Dialogo_SB.pas' {iphs1_Form_Dialogo_SB},
  iphs1_Dialogo_SB_TCV in 'Dialogos\iphs1_Dialogo_SB_TCV.pas' {iphs1_Form_Dialogo_SB_TCV},
  iphs1_Dialogo_SB_TCV_Reordenada in 'Dialogos\iphs1_Dialogo_SB_TCV_Reordenada.pas' {iphs1_Form_Dialogo_SB_TCV_Reordenada},
  iphs1_Dialogo_SB_TCV_IPHII in 'Dialogos\iphs1_Dialogo_SB_TCV_IPHII.pas' {iphs1_Form_Dialogo_SB_TCV_IPHII},
  iphs1_Dialogo_SB_TCV_SCS in 'Dialogos\iphs1_Dialogo_SB_TCV_SCS.pas' {iphs1_Form_Dialogo_SB_TCV_SCS},
  iphs1_Dialogo_SB_TCV_FI in 'Dialogos\iphs1_Dialogo_SB_TCV_FI.pas' {iphs1_Form_Dialogo_SB_TCV_FI},
  iphs1_Dialogo_SB_TCV_HEC in 'Dialogos\iphs1_Dialogo_SB_TCV_HEC.pas' {iphs1_Form_Dialogo_SB_TCV_HEC},
  iphs1_Dialogo_SB_TCV_HOLTAN in 'Dialogos\iphs1_Dialogo_SB_TCV_HOLTAN.pas' {iphs1_Form_Dialogo_SB_TCV_HOLTAN},
  iphs1_Dialogo_SB_TCV_HTSCS in 'Dialogos\iphs1_Dialogo_SB_TCV_HTSCS.pas' {iphs1_Form_Dialogo_SB_TCV_HTSCS},
  iphs1_Dialogo_SB_TCV_PEB in 'Dialogos\iphs1_Dialogo_SB_TCV_PEB.pas' {iphs1_Form_Dialogo_SB_TCV_PEB},
  iphs1_Dialogo_SB_TCV_HYMO in 'Dialogos\iphs1_Dialogo_SB_TCV_HYMO.pas' {iphs1_Form_Dialogo_SB_TCV_HYMO},
  iphs1_Dialogo_SB_TCV_HU in 'Dialogos\iphs1_Dialogo_SB_TCV_HU.pas' {iphs1_Form_Dialogo_SB_TCV_HU},
  iphs1_Dialogo_SB_TCV_CLARK in 'Dialogos\iphs1_Dialogo_SB_TCV_CLARK.pas' {iphs1_Form_Dialogo_SB_TCV_CLARK},
  iphs1_Dialogo_Projeto in 'Dialogos\iphs1_Dialogo_Projeto.pas' {iphs1_Form_Dialogo_Projeto},
  iphs1_Dialogo_Derivacao in 'Dialogos\iphs1_Dialogo_Derivacao.pas' {iphs1_Form_Dialogo_Derivacao},
  Arrays in '..\..\..\..\Comum\Lib\Arrays.pas',
  iphs1_Tipos in 'Unidades\iphs1_Tipos.pas',
  About in 'Dialogos\About.pas' {Frame_About: TFrame},
  Graf_CExHR in 'Dialogos\Graf_CExHR.pas' {Grafico_CExHR},
  Dialogo_EscolherObjeto in '..\Comum\Dialogos\Dialogo_EscolherObjeto.pas' {DialogoEscolherObjeto},
  iphs1_EscolherPCR in 'Dialogos\iphs1_EscolherPCR.pas' {iphs1_Form_EscolherPCR},
  iphs1_EscolherPC in 'Dialogos\iphs1_EscolherPC.pas' {iphs1_Form_EscolherPC},
  iphs1_EscolherDER in 'Dialogos\iphs1_EscolherDER.pas' {iphs1_Form_EscolherDER},
  iphs1_EscolherSB in 'Dialogos\iphs1_EscolherSB.pas' {iphs1_Form_EscolherSB},
  iphs1_EscolherTD in 'Dialogos\iphs1_EscolherTD.pas' {iphs1_Form_EscolherTD},
  Historico in '..\Comum\Dialogos\Historico.pas' {Form_Historico},
  iphs1_EscolherObjetos in 'Dialogos\iphs1_EscolherObjetos.pas' {iphs1_Dialogo_EscolherObjetos},
  frame_CheckListBox in '..\..\..\..\Comum\Frames\frame_CheckListBox.pas' {FrameCheckListBox: TFrame},
  drGraficosBase in '..\..\..\..\Comum\Graficos\drGraficosBase.pas' {grGraficoBase},
  drGraficos in '..\..\..\..\Comum\Graficos\drGraficos.pas' {grGrafico},
  Frame_Planilha in '..\..\..\..\Comum\Frames\Frame_Planilha.pas' {FramePlanilha: TFrame},
  Planilha_EntradaDeValores in '..\Comum\Planilhas\Planilha_EntradaDeValores.pas' {PlanilhaEntradaDeValores},
  LanguageControl in '..\..\..\..\Comum\Lib\LanguageControl.pas',
  iphs1_Constantes in 'Unidades\iphs1_Constantes.pas',
  FrameEstruturaRes_Q in 'Frames\FrameEstruturaRes_Q.pas' {frEstruturaRes_Q: TFrame},
  WindowsManagerMessages in '..\..\..\..\Comum\Lib\WindowsManagerMessages.pas',
  FileUtilsMessages in '..\..\..\..\Comum\Lib\FileUtilsMessages.pas',
  iphs1_Dialogo_SB_TCV_Calculo_TC in 'Dialogos\iphs1_Dialogo_SB_TCV_Calculo_TC.pas' {foiphs1_Dialogo_SB_TCV_Calculo_TC},
  iphs1_Dialogo_TD_VisNivel in 'Dialogos\iphs1_Dialogo_TD_VisNivel.pas' {foiphs1_Dialogo_TD_VisNivel},
  iphs1_Dialogo_Res_Orificio in 'Dialogos\iphs1_Dialogo_Res_Orificio.pas' {iphs1_Form_Dialogo_Res_Orificio},
  iphs1_Dialogo_Res_Vertedor in 'Dialogos\iphs1_Dialogo_Res_Vertedor.pas' {iphs1_Form_Dialogo_Res_Vertedor},
  Frame_TD_MPE_MCCF in 'Frames\Frame_TD_MPE_MCCF.pas' {iphs1_Frame_TD_MPE_MCCF: TFrame},
  Frame_TD_MPE_MCCF_CP in 'Frames\Frame_TD_MPE_MCCF_CP.pas' {iphs1_Frame_TD_MPE_MCCF_CP: TFrame},
  iphs1_Dialogo_TD_MPE_MCCF in 'Dialogos\iphs1_Dialogo_TD_MPE_MCCF.pas' {iphs1_Form_Dialogo_TD_MPE_MCCF},
  Graf_Res_Cota_X_Vazao in 'Dialogos\Graf_Res_Cota_X_Vazao.pas' {Grafico_Res_Cota_X_Vazao},
  iphs1_GaugeDoCanal in 'Unidades\iphs1_GaugeDoCanal.pas',
  iphs1_Dialogo_Res_VisNivel in 'Dialogos\iphs1_Dialogo_Res_VisNivel.pas' {foiphs1_Dialogo_Res_VisNivel},
  iphs1_GaugeDoReservatorio_2 in 'Unidades\iphs1_GaugeDoReservatorio_2.pas',
  iphs1_Dialogo_VazaoCont in 'Dialogos\iphs1_Dialogo_VazaoCont.pas' {iphs1_Form_Dialogo_VazaoCont};

{$R *.RES}  

{
  Application.CreateForm(Tiphs1_Dialogo_Principal, MainForm);
}
var d: Tiphs1_Form_Splash;
    MostrarSplash: Boolean;
    i: Integer;
    H: THandle;
begin
  {$IFDEF FINAL}
  H := FindWindow('Tiphs1_Dialogo_Principal', nil);
  if H <> 0 then
     begin
     Windows.ShowWindow(H, SW_SHOWNORMAL);
     Exit;
     end;
  {$ENDIF}

  gVersao                    := '2.0 beta';
  TwoDigitYearCenturyWindow  := 20;
  gExePath                   := ExtractFilePath(Application.ExeName);
  Application.HintHidePause  := 4000;
  Application.Initialize;

  Application.CreateForm(Tiphs1_Dialogo_Principal, MainForm);
  Gerenciador := Tiphs1_Form_VisaoEmArvore.Create(Application);

  // Inicializações
  CriarObjetosGlobais;
  LerConfiguracoes;

{$IFDEF DEBUG}
  SysUtils.beep;
  showMessage('Este projeto contém código para DEBUG');
{$ELSE}
  MostrarSplash := True;
  for i := 1 to ParamCount do
    if CompareText(ParamStr(i), 'SEMSPLASH') = 0 then
       MostrarSplash := False
    else
       if pos('\', ParamStr(i)) > 0 then
          MainForm.CreateMDIChild(ParamStr(i), False, False);

  if MostrarSplash then
     begin
     d := Tiphs1_Form_Splash.Create(nil);
     d.Show;
     {$IFDEF FINAL}
     Delay(2500);
     {$ELSE}
     Delay(500);
     {$ENDIF}
     d.Free;
     end;
{$ENDIF}

  Application.Run;

  // Finalizações
  GravarConfiguracoes;
  DestruirObjetosGlobais;
end.

