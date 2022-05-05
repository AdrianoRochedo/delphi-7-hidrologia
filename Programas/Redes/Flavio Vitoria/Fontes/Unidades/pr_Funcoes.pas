unit pr_Funcoes;

interface
uses Windows, Forms, Classes, MessageManager, MessagesForm, Dialogs,
     pr_Const,
     pr_Tipos;

  function PrioridadeToString(Prior: TEnumPriorDemanda): String;

  {Obtém a instância do objeto dado o seu nome}
  function ObterObjetoPeloNome(const Nome: String; Projeto: TObject): TObject;

  {Verifica se no nome de um arquivo está seu caminho}
  function PossuiCaminho(const Arquivo: String): Boolean;

implementation
uses stdCTRLs,
     SysUtils,
     SysUtilsEx,
     FileUtils,
     FolderUtils,
     IniFiles,
     pr_Vars,
     pr_Gerenciador,
     OutPut,
     Form_Chart,
     WindowsManager,
     Main;

function ObterObjetoPeloNome(const Nome: String; Projeto: TObject): TObject;
var p: pRecObjeto;
begin
  New(p);
  p.Obj := nil;

  if Nome <> '' then
     GetMessageManager.SendMessage(UM_OBTEM_OBJETO, [@Nome, p, Projeto]);

  Result := p.Obj;
  Dispose(p);
end;

function PossuiCaminho(const Arquivo: String): Boolean;
begin
  Result := System.Pos(':\', Arquivo) > 0;
end;

function PrioridadeToString(Prior: TEnumPriorDemanda): String;
begin
  case Prior of
    pdPrimaria   : Result := 'PRIMÁRIA';
    pdSecundaria : Result := 'SECUNDÁRIA';
    pdTerciaria  : Result := 'TERCIÁRIA';
  end;
end;

end.
