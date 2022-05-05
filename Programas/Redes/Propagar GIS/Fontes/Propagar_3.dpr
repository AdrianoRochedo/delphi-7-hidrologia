program Propagar_3;

{Quando compilar a versão final, definir a diretiva "FINAL"}

{ TO-DO
  - Melhorar Posicionamento e Tamanho das janelas na abertura de arquivos
  - Hints em modo selecao/edicao
  - Evitar fliquer na seleção dos objetos da rede
  - Mudar componentes que utilizam Planilhas/Grids/etc por frames
  - Valores Default
}



{%File '..\Bin\Historico.txt'}
{%File '..\Docs\Erros.txt'}
{%ToDo 'Propagar_3.todo'}

uses
  Forms,
  sysUtils,
  Windows,
  Dialogs,
  WinUtils,
  drGraficosBase in '..\..\..\..\..\Comum\Graficos\drGraficosBase.pas' {grGraficoBase},
  hidro_Form_GlobalMessages in '..\..\..\..\..\Comum\Hidro\hidro_Form_GlobalMessages.pas' {hidroForm_GlobalMessages},
  Frame_PromotionList in '..\..\..\..\..\Comum\Frames\Frame_PromotionList.pas' {frPL: TFrame},
  Frame_moLayer in '..\..\..\..\..\Comum\MapObjects\Frame_moLayer.pas' {Frame_moLayer: TFrame},
  Frame_moUnits in '..\..\..\..\..\Comum\MapObjects\Frame_moUnits.pas' {Frame_moUnits: TFrame},
  Form_moLayerProps in '..\..\..\..\..\Comum\MapObjects\Form_moLayerProps.pas' {Form_moLayerProps},
  esquemas_OpcoesGraf in '..\..\Comum\Unidades\esquemas_OpcoesGraf.pas',
  Historico in '..\..\Comum\Dialogos\Historico.pas' {Form_Historico},
  Planilha_DadosDosObjetos in '..\..\Comum\Planilhas\Planilha_DadosDosObjetos.pas',
  Planilha_base in '..\..\Comum\Planilhas\Planilha_base.pas' {Form_Planilha_Base},
  pr_psLib in 'Unidades\pr_psLib.pas',
  pr_Classes in 'Unidades\pr_Classes.pas',
  pr_Const in 'Unidades\pr_Const.pas',
  pr_Vars in 'Unidades\pr_Vars.pas',
  pr_Tipos in 'Unidades\pr_Tipos.pas',
  pr_Funcoes in 'Unidades\pr_Funcoes.pas',
  pr_Util in 'Unidades\pr_Util.pas',
  Rosenbrock_psLib in 'Rosenbrock\Rosenbrock_psLib.pas',
  Rosenbrock_Class in 'Rosenbrock\Rosenbrock_Class.pas',
  Rosenbrock_FormFO in 'Rosenbrock\Rosenbrock_FormFO.pas' {rbFormFO},
  Rosenbrock_FormParameter in 'Rosenbrock\Rosenbrock_FormParameter.pas' {rbFormParameter},
  Rosenbrock_FormParMan in 'Rosenbrock\Rosenbrock_FormParMan.pas' {rbFormParMan},
  Rosenbrock_FrameParMan in 'Rosenbrock\Rosenbrock_FrameParMan.pas' {rbFrameParMan: TFrame},
  MAIN in 'Dialogos\MAIN.PAS' {foMain},
  pr_AreaDeProjeto in 'Dialogos\pr_AreaDeProjeto.PAS' {prDialogo_AreaDeProjeto},
  pr_Gerenciador in 'Dialogos\pr_Gerenciador.pas' {prDialogo_Gerenciador},
  pr_DialogoBase in 'Dialogos\pr_DialogoBase.pas' {prDialogo_Base},
  pr_Dialogo_PCP in 'Dialogos\pr_Dialogo_PCP.pas' {prDialogo_PCP},
  pr_Dialogo_PCPR in 'Dialogos\pr_Dialogo_PCPR.pas' {prDialogo_PCPR},
  pr_Dialogo_PCPR_Curvas in 'Dialogos\pr_Dialogo_PCPR_Curvas.pas' {prDialogo_Curvas},
  pr_Dialogo_PC_Energia in 'Dialogos\pr_Dialogo_PC_Energia.pas' {prDialogo_PC_Energia},
  pr_Dialogo_Projeto in 'Dialogos\pr_Dialogo_Projeto.pas' {prDialogo_Projeto},
  pr_Dialogo_Projeto_RU in 'Dialogos\pr_Dialogo_Projeto_RU.pas' {prDialogo_Projeto_RU},
  pr_Dialogo_Projeto_OpcVisRede in 'Dialogos\pr_Dialogo_Projeto_OpcVisRede.pas' {prDialogo_Projeto_OpcVisRede},
  pr_Dialogo_Projeto_Rosenbrock in 'Dialogos\pr_Dialogo_Projeto_Rosenbrock.pas' {prDialogo_ProjetoRosen},
  pr_Dialogo_Projeto_Rosenbrock_RU in 'Dialogos\pr_Dialogo_Projeto_Rosenbrock_RU.pas' {prDialogo_Projeto_Rosenbrock_RU},
  pr_Dialogo_SB in 'Dialogos\pr_Dialogo_SB.pas' {prDialogo_SB},
  pr_Dialogo_TD in 'Dialogos\pr_Dialogo_TD.pas' {prDialogo_TD},
  pr_Dialogo_ClasseDeDemanda in 'Dialogos\pr_Dialogo_ClasseDeDemanda.pas' {prDialogo_ClasseDeDemanda},
  pr_Dialogo_Demanda in 'Dialogos\pr_Dialogo_Demanda.pas' {prDialogo_Demanda},
  pr_Dialogo_Demanda_TVU in 'Dialogos\pr_Dialogo_Demanda_TVU.pas' {prDialogo_TVU},
  pr_Dialogo_Demanda_TVU_Distribuir in 'Dialogos\pr_Dialogo_Demanda_TVU_Distribuir.pas' {prDialogo_TVU_Distribuir},
  pr_Dialogo_Demanda_TUD in 'Dialogos\pr_Dialogo_Demanda_TUD.pas' {prDialogo_TUD},
  pr_Dialogo_Demanda_TFI in 'Dialogos\pr_Dialogo_Demanda_TFI.pas' {prDialogo_TFI},
  pr_Dialogo_Demanda_SD in 'Dialogos\pr_Dialogo_Demanda_SD.pas' {prDialogo_SDD},
  pr_Dialogo_Demanda_Opcoes in 'Dialogos\pr_Dialogo_Demanda_Opcoes.pas' {prDialogo_OpcoesDeDemanda},
  pr_Dialogo_MatContrib in 'Dialogos\pr_Dialogo_MatContrib.pas' {prDialogo_MatContrib},
  pr_Dialogo_FalhasDeUmPC in 'Dialogos\pr_Dialogo_FalhasDeUmPC.pas' {prDialogo_FalhasDeUmPC},
  pr_Dialogo_PlanilhaBase in 'Dialogos\pr_Dialogo_PlanilhaBase.pas' {prDialogo_PlanilhaBase},
  pr_Dialogo_Planilha_DemandasDeUmaClasse in 'Dialogos\pr_Dialogo_Planilha_DemandasDeUmaClasse.pas' {prDialogo_Planilha_DemandasDeUmaClasse},
  pr_Dialogo_Grafico_PCs_XTudo in 'Dialogos\pr_Dialogo_Grafico_PCs_XTudo.pas' {prDialogo_Grafico_PCs_XTudo},
  pr_Dialogo_Grafico_PCsRes_XTudo in 'Dialogos\pr_Dialogo_Grafico_PCsRes_XTudo.pas' {prDialogo_Grafico_PCsRes_XTudo},
  pr_Dialogo_Intervalos in 'Dialogos\pr_Dialogo_Intervalos.pas' {prDialogo_Intervalos},
  pr_Dialogo_EscolherClasseDemanda in 'Dialogos\pr_Dialogo_EscolherClasseDemanda.pas' {prDialogo_EscolherClasseDemanda},
  pr_Dialogo_Planilha_FalhasDasDemandas in 'Dialogos\pr_Dialogo_Planilha_FalhasDasDemandas.pas' {prDialogo_Planilha_FalhasDasDemandas},
  pr_Monitor in 'Dialogos\pr_Monitor.pas' {DLG_Monitor},
  pr_Monitor_DefinirVariaveis in 'Dialogos\pr_Monitor_DefinirVariaveis.pas' {DLG_DefinirVariaveis},
  AboutForm in 'Dialogos\AboutForm.pas' {prDialogo_About},
  Splash in 'Dialogos\Splash.pas' {prDialogo_Splash};

{$R *.RES}

var d: TprDialogo_Splash;
    MostrarSplash: Boolean;
    i: Integer;
  {$IFDEF FINAL}
    H: THandle;
  {$ENDIF}

begin
  {$IFDEF FINAL}
  H := FindWindow('TprDialogo_Principal', nil);
  if H <> 0 then
     begin
     Windows.ShowWindow(H, SW_SHOWNORMAL);
     Exit;
     end;
  {$ENDIF}

  gVersao  := 'Versão 3.0 - alfa';
  gExePath := ExtractFilePath(Application.ExeName);
                           
  {$IFDEF CD}
  // No caso de ser a versão CD, verificamos se os componentes OCX já
  // estão instalados na máquina cliente, se não estiverem, registramos
  // os OCXs do CD. 
  RegistrarObjetosCOM();
  {$ENDIF}

  Application.Initialize;

  Application.CreateForm(TfoMain, foMain);
  Gerenciador := TprDialogo_Gerenciador.Create(Application);

  // Inicializações
  CriarObjetosGlobais;
  LerConfiguracoes;

{$IFDEF DEBUG}
  SysUtils.beep;
  showMessage('Este programa contém código para DEBUG'#13 +
              'Compile-o sem a diretiva de compilação DEBUG');
{$ELSE}
  MostrarSplash := True;
  for i := 1 to ParamCount do
    begin
    if CompareText(ParamStr(i), '-NoSPLASH') = 0 then
       MostrarSplash := False else

    if CompareText(ParamStr(i), '-open') = 0 then
       foMain.CreateMDIChild(ParamStr(i+1), False, False, False) else

    if CompareText(ParamStr(i), '-run') = 0 then
       foMain.RunScript(ParamStr(i+1))
    end;

  if MostrarSplash then
     begin
     d := TprDialogo_Splash.Create(nil);
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

