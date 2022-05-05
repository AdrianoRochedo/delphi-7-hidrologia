program PluginHost;

// DIRETIVAS DE COMPILACAO ----------------------------------------------------

{
         OBJETOS_NAO_EDITAVEIS - Desabilita o botao "Ok" dos dialogos dos
                                 objetos.

                  VERSAO_FINAL - Versao de distribuicao do programa

               VERSAO_LIMITADA - Limita o número de coisas que se podem fazer
}

// As seguintes diretivas tem somente uso nesta unidade

     {.$define AcessoComSenha}
     {.$define JaildoSantosPereira}
     {.$define JoaoViegasFilho}
     {.$define AntonioEduardoLanna}
     {.$define WalterVianna}

// FIM DIRETIVAS DE COMPILACAO ------------------------------------------------

{Para limitacao de versoes utilizar a constante "dir_NivelDeRestricao" da unidade
 "DiretivasDeCompilacao" localizada em "x:\projetos\lib".
 Esta unidade devera ser uma das primeiras unidades declaradas no projeto e devera
 estar declarada em toda unidade que utilizar a constante}

{%File '..\Bin\Historico.txt'}
{%ToDo 'PluginHost.todo'}

uses
  ShareMem,
  Forms,
  sysUtils,
  Windows,
  Dialogs,
  WinUtils,
  DiretivasDeCompilacao,
  Application_Class in '..\..\..\..\..\Lib\Geral\Application_Class.pas' {Application: TDataModule},
  Scenarios.Form.GlobalMessages in '..\NewPluginHost\Source\Dialogs\Scenarios.Form.GlobalMessages.pas' {GlobalMessagesForm},
  pr_Classes in 'Unidades\pr_Classes.pas',
  pr_Const in 'Unidades\pr_Const.pas',
  pr_Funcoes in 'Unidades\pr_Funcoes.pas',
  pr_Util in 'Unidades\pr_Util.pas',
  pr_psLib in 'Unidades\pr_psLib.pas',
  pr_Vars in 'Unidades\pr_Vars.pas',
  pr_Tipos in 'Unidades\pr_Tipos.pas',
  pr_Interfaces in 'Unidades\pr_Interfaces.pas',
  pr_Application in 'Unidades\pr_Application.pas' {prApplication: TDataModule},
  pr_Plugins in 'Unidades\pr_Plugins.pas',
  MAIN in 'Dialogos\MAIN.PAS' {prDialogo_Principal},
  AboutForm in 'Dialogos\AboutForm.pas' {prDialogo_About},
  Splash in 'Dialogos\Splash.pas' {prDialogo_Splash},
  Dialogo_Senha in 'Dialogos\Dialogo_Senha.pas' {PasswordDlg},
  pr_Gerenciador in 'Dialogos\pr_Gerenciador.pas' {prDialogo_Gerenciador},
  pr_DialogoBase in 'Dialogos\pr_DialogoBase.pas' {prDialogo_Base},
  pr_Dialogo_PCP in 'Dialogos\pr_Dialogo_PCP.pas' {prDialogo_PCP},
  pr_Dialogo_TD in 'Dialogos\pr_Dialogo_TD.pas' {prDialogo_TD},
  pr_Dialogo_Projeto in 'Dialogos\pr_Dialogo_Projeto.pas' {prDialogo_Projeto},
  Planilha_base in '..\..\Comum\Planilhas\Planilha_base.pas' {Form_Planilha_Base},
  pr_Form_AreaDeProjeto_Base in 'Dialogos\pr_Form_AreaDeProjeto_Base.pas' {foAreaDeProjeto_Base},
  pr_Form_AreaDeProjeto_BMP in 'Dialogos\pr_Form_AreaDeProjeto_BMP.pas' {foAreaDeProjeto_BMP},
  Frame_RTF in '..\..\..\..\..\Lib\Frames\Frame_RTF.pas' {fr_RTF: TFrame},
  Frame_Memo in '..\..\..\..\..\Lib\Frames\Frame_Memo.pas' {fr_Memo: TFrame},
  pr_Dialogo_Descarga in 'Dialogos\pr_Dialogo_Descarga.pas' {prDialogo_Descarga},
  Historico in '..\..\Comum\Dialogos\Historico.pas' {Form_Historico},
  pr_Dialogo_QA in 'Dialogos\pr_Dialogo_QA.pas' {prDialogo_QA},
  pr_Form_AreaDeProjeto_Zoom in 'Dialogos\pr_Form_AreaDeProjeto_Zoom.pas' {foAreaDeProjeto_Zoom};

{$R *.RES}

const SenhaMestra = 180374;

{$ifdef AcessoComSenha}
var Senha: integer;

  {$ifdef JoaoViegasFilho}
  const RegistroPessoal = 'Joao Soares Viegas Filho';
  const SenhaPessoal = 111;
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
    TprApplication.Create('PluginHost', '0.01', RegistroPessoal)
    );
end.


