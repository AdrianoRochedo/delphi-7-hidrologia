unit hidro_Procs;

interface
uses Windows, Forms, Classes, MessageManager, MessagesForm;

  {Faz a validação dos coeficientes e da sua soma que não deve exceder 1}
  function ValidaCoeficientes(SL: TStrings; Erros: TfoMessages): Boolean;

  {Obtém a instância do objeto dado o seu nome}
  function ObtemObjetoPeloNome(const Nome: String; Projeto: TObject): TObject;

  {Verifica se no nome de um arquivo está seu caminho}
  function PossuiCaminho(const Arquivo: String): Boolean;

  {Abre um arquivo HTML}
  procedure MostrarHTML(const Nome: String);

implementation
uses stdCTRLs,
     ShellAPI,
     SysUtils,
     SysUtilsEx,
     FileUtils,
     hidro_Variaveis;

function ObtemObjetoPeloNome(const Nome: String; Projeto: TObject): TObject;
var p: pRecObjeto;
begin
  New(p);
  p.Obj := nil;

  if Nome <> '' then
     GetMessageManager.SendMessage(UM_OBTEM_OBJETO, [@Nome, p, Projeto]);

  Result := p.Obj;
  Dispose(p);
end;

function  ValidaCoeficientes(SL: TStrings; Erros: TfoMessages): Boolean;
var r: real;
    i: integer;
begin
  Result := True;
  r := 0;
  for i := 1 to SL.Count-1 do
    try
      r := r + SysUtils.StrToFloat(SL[i]);
    except
      Result := False;
      Erros.Add(etError, 'Erro nos Coeficientes:'#13 +
                         'Valor inválido: ' + SL[i]);
    end;

  if Result and ((r > 1.0) or (r < 0.0)) then
     begin
     Result := False;
     Erros.Add(etError, 'Erro nos Coeficientes:'#13 +
                        'Eles somam mais do que 1.');
     end;
end;

function PossuiCaminho(const Arquivo: String): Boolean;
begin
  Result := System.Pos('\', Arquivo) > 0;
end;

procedure MostrarHTML(const Nome: String);
begin
  ShellExecute(Application.Handle,
              'open',
              'IExplore',
              pChar(ExtractFilePath(Application.ExeName) + 'Ajuda\' + Nome),
              '',
              SW_SHOWNORMAL);
end;

end.
