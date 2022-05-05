program SaoMiguel_Jequia;

{
  Inicio: 27/02/2004
  Fim: ???
  Horas trabalhadas: 53
}

// DIRETIVAS DE COMPILACAO ----------------------------------------------------

{
  NAO_CARREGAR_IMAGEM_DE_FUNDO - Nao permite carregar imagens de fundo para
                                 os projetos.

         OBJETOS_NAO_EDITAVEIS - Desabilita o botao "Ok" dos dialogos dos
                                 objetos.

                  VERSAO_FINAL - Versao de distribuicao do programa
}

// As seguintes diretivas tem somente uso nesta unidade

{.$define AcessoComSenha}
{.$define JaildoSantosPereira}
{.$define JoaoViegasFilho}
{.$define AntonioEduardoLanna}
{.$define WalterVianna}

// FIM DIRETIVAS DE COMPILACAO ------------------------------------------------

{Para limitacao das versoes utilizar a constante "dir_NivelDeRestricao" da unidade
 "DiretivasDeCompilacao" localizada em "x:\projetos\lib".
 Esta unidade devera ser uma das primeiras unidades declaradas no projeto e devera
 estar declarada em toda unidade que utilizar a constante}

{%ToDo 'SaoMiguel_Jequia.todo'}

uses
  ShareMem,
  Forms,
  sysUtils,
  Windows,
  Dialogs,
  WinUtils,
  DiretivasDeCompilacao,
  Application_Class in '..\..\..\..\..\Comum\Lib\Application_Class.pas' {Application: TDataModule},
  hidro_Form_GlobalMessages in '..\..\..\..\..\Comum\Hidro\hidro_Form_GlobalMessages.pas' {hidroForm_GlobalMessages},
  Frame_TreeViewObjects in '..\..\..\..\..\Comum\Frames\Frame_TreeViewObjects.pas' {TreeViewObjects: TFrame},
  Historico in '..\..\Comum\Dialogos\Historico.pas' {Form_Historico},
  Demand_Requirements in '..\..\..\..\..\Comum\Hidro\Demand_Requirements.pas',
  Esquemas_OpcoesGraf in '..\..\Comum\Unidades\esquemas_OpcoesGraf.pas',
  Planilha_DadosDosObjetos in '..\..\Comum\Planilhas\Planilha_DadosDosObjetos.pas',
  Planilha_base in '..\..\Comum\Planilhas\Planilha_base.pas' {Form_Planilha_Base},
  pr_Classes in 'Unidades\pr_Classes.pas',
  pr_Const in 'Unidades\pr_Const.pas',
  pr_Funcoes in 'Unidades\pr_Funcoes.pas',
  pr_Util in 'Unidades\pr_Util.pas',
  pr_psLib in 'Unidades\pr_psLib.pas',
  pr_Vars in 'Unidades\pr_Vars.pas',
  pr_Tipos in 'Unidades\pr_Tipos.pas',
  pr_Interfaces in 'Unidades\pr_Interfaces.pas',
  pr_Plugins in 'Unidades\pr_Plugins.pas',
  pr_Application in 'Unidades\pr_Application.pas' {prApplication: TDataModule},
  ProjectManager in 'Unidades\ProjectManager.pas' {foProjectManager},
  AboutForm in 'Dialogos\AboutForm.pas' {prDialogo_About},
  Splash in 'Dialogos\Splash.pas' {prDialogo_Splash},
  Dialogo_Senha in 'Dialogos\Dialogo_Senha.pas' {PasswordDlg},
  pr_Gerenciador in 'Dialogos\pr_Gerenciador.pas' {prDialogo_Gerenciador},
  pr_DialogoBase in 'Dialogos\pr_DialogoBase.pas' {prDialogo_Base},
  pr_Dialogo_PCP in 'Dialogos\pr_Dialogo_PCP.pas' {prDialogo_PCP},
  pr_Dialogo_PCPR in 'Dialogos\pr_Dialogo_PCPR.pas' {prDialogo_PCPR},
  pr_Dialogo_SB in 'Dialogos\pr_Dialogo_SB.pas' {prDialogo_SB},
  pr_Dialogo_TD in 'Dialogos\pr_Dialogo_TD.pas' {prDialogo_TD},
  pr_Dialogo_Projeto in 'Dialogos\pr_Dialogo_Projeto.pas' {prDialogo_Projeto},
  pr_Dialogo_Descarga in 'Dialogos\pr_Dialogo_Descarga.pas' {prDialogo_Descarga},
  pr_Dialogo_Demanda in 'Dialogos\pr_Dialogo_Demanda.pas' {prDialogo_Demanda},
  pr_Dialogo_Demanda_TVU in 'Dialogos\pr_Dialogo_Demanda_TVU.pas' {prDialogo_TVU},
  pr_Dialogo_Demanda_TUD in 'Dialogos\pr_Dialogo_Demanda_TUD.pas' {prDialogo_TUD},
  pr_Dialogo_Demanda_Opcoes in 'Dialogos\pr_Dialogo_Demanda_Opcoes.pas' {prDialogo_OpcoesDeDemanda},
  pr_Dialogo_Demanda_TVU_Distribuir in 'Dialogos\pr_Dialogo_Demanda_TVU_Distribuir.pas' {prDialogo_TVU_Distribuir},
  pr_Dialogo_ClasseDeDemanda in 'Dialogos\pr_Dialogo_ClasseDeDemanda.pas' {prDialogo_ClasseDeDemanda},
  pr_Dialogo_PCPR_Curvas in 'Dialogos\pr_Dialogo_PCPR_Curvas.pas' {prDialogo_Curvas},
  pr_Dialogo_MatContrib in 'Dialogos\pr_Dialogo_MatContrib.pas' {prDialogo_MatContrib},
  pr_Dialogo_Demanda_TFI in 'Dialogos\pr_Dialogo_Demanda_TFI.pas' {prDialogo_TFI},
  pr_Dialogo_FalhasDeUmPC in 'Dialogos\pr_Dialogo_FalhasDeUmPC.pas' {prDialogo_FalhasDeUmPC},
  pr_Dialogo_PlanilhaBase in 'Dialogos\pr_Dialogo_PlanilhaBase.pas' {prDialogo_PlanilhaBase},
  pr_Dialogo_Grafico_PCs_XTudo in 'Dialogos\pr_Dialogo_Grafico_PCs_XTudo.pas' {prDialogo_Grafico_PCs_XTudo},
  pr_Dialogo_Grafico_PCsRes_XTudo in 'Dialogos\pr_Dialogo_Grafico_PCsRes_XTudo.pas' {prDialogo_Grafico_PCsRes_XTudo},
  pr_Dialogo_Intervalos in 'Dialogos\pr_Dialogo_Intervalos.pas' {prDialogo_Intervalos},
  pr_Dialogo_Projeto_RU in 'Dialogos\pr_Dialogo_Projeto_RU.pas' {prDialogo_Projeto_RU},
  pr_Dialogo_Projeto_Otimizavel in 'Dialogos\pr_Dialogo_Projeto_Otimizavel.pas' {prDialogo_ProjetoOtimizavel},
  pr_Dialogo_Projeto_Otimizador_RU in 'Dialogos\pr_Dialogo_Projeto_Otimizador_RU.pas' {prDialogo_Projeto_Otimizador_RU},
  pr_Dialogo_Demanda_SD in 'Dialogos\pr_Dialogo_Demanda_SD.pas' {prDialogo_SDD},
  pr_Dialogo_Planilha_FalhasDasDemandas in 'Dialogos\pr_Dialogo_Planilha_FalhasDasDemandas.pas' {prDialogo_Planilha_FalhasDasDemandas},
  pr_Dialogo_PC_Energia in 'Dialogos\pr_Dialogo_PC_Energia.pas' {prDialogo_PC_Energia},
  pr_Monitor in 'Dialogos\pr_Monitor.pas' {DLG_Monitor},
  pr_Monitor_DefinirVariaveis in 'Dialogos\pr_Monitor_DefinirVariaveis.pas' {DLG_DefinirVariaveis},
  prDialogo_Planilha_DemandasDeUmaClasse in 'Dialogos\prDialogo_Planilha_DemandasDeUmaClasse.pas' {prDialogoPlanilha_DemandasDeUmaClasse},
  prDialogo_EscolherClasseDemanda in 'Dialogos\prDialogo_EscolherClasseDemanda.pas' {prDialogoEscolherClasseDemanda},
  prForm_Equacoes in 'Equacoes\prForm_Equacoes.pas' {prForm_Equacoes},
  pr_Form_AreaDeProjeto_Base in 'Dialogos\pr_Form_AreaDeProjeto_Base.pas' {foAreaDeProjeto_Base},
  pr_Form_AreaDeProjeto_BMP in 'Dialogos\pr_Form_AreaDeProjeto_BMP.pas' {foAreaDeProjeto_BMP},
  sm_Application in 'Sao Miguel\sm_Application.pas' {smApplication: TDataModule},
  Main in 'Sao Miguel\MAIN.PAS' {prDialogo_Principal};

{$R Propagar_3.RES}

const SenhaMestra = 180374;

{$ifdef AcessoComSenha}
var Senha: integer;

  {$ifdef NomeDaPessoa}
  const RegistroPessoal = 'Nome da Pessoa';
  const SenhaPessoal = 1111;
  {$endif}

{$else}
const RegistroPessoal = '';
{$endif}

procedure ExecPreInitialization();
var H: THandle;
begin
  {$ifdef AcessoComSenha}
  Senha := TPasswordDlg.getPassword(RegistroPessoal);
  if (Senha = SenhaMestra) or (Senha = SenhaPessoal) then
     // Acesso Permitido
  else
     begin
     MessageDLG('Senha incorreta !', mtInformation, [mbOk], 0);
     Exit;
     end;
  {$endif}

  {$ifdef VERSAO_FINAL}
  H := FindWindow('TprDialogo_Principal', nil);
  if H <> 0 then
     begin
     Windows.ShowWindow(H, SW_SHOWNORMAL);
     Exit;
     end;
  {$endif}
end;

begin
  ExecPreInitialization();
  TSystem.Run(
    TsmApplication.Create('Propagar São Miguel - Jequiá', '1.0', RegistroPessoal)
    );
end.


