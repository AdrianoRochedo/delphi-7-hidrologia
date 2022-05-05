unit pr_Funcoes;

interface
uses Windows, Forms, Classes, MessageManager, MessagesForm, Dialogs,
     pr_Const,
     pr_Tipos;

  function PrioridadeToString(Prior: TEnumPriorDemanda): String;
  function ValidarIntervalos(SL: TStrings; Erros: TfoMessages): Boolean;
  function OrdenarIntervalos(SL: TStrings): Boolean;
  function ConsistirIntervalos(SL: TStrings; Erros: TfoMessages): Boolean;
  function ValidarCoeficientes(SL: TStrings; Erros: TfoMessages): Boolean;

  {Obtém a instância do objeto dado o seu nome}
  function ObterObjetoPeloNome(const Nome: String; Projeto: TObject): TObject;

  // Obtém uma lista de todas as demandas pertencentes a uma mesma classe de demanda e a um projeto
  // Se <Classe> = "TODAS" então retorna uma lista ordenada com todas as demendas no formato:
  //    [nome da classe de demanda] nome da demanda
  procedure ObterDemandasPelaClasse(const Classe: String; var Demandas: TStrings; Projeto: TObject);

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
     esquemas_OpcoesGraf,
     WindowsManager;

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

// Obtém uma lista de todas as demandas pertencentes a uma mesma classe de demanda e a um projeto
// Se <Classe> = "TODAS" então retorna uma lista ordenada com todas as demendas no formato:
//    [nome da classe de demanda] nome da demanda
procedure ObterDemandasPelaClasse(const Classe: String; var Demandas: TStrings; Projeto: TObject);
begin
  Demandas.Clear;
  GetMessageManager.SendMessage(UM_OBTEM_DEMANDA_PELA_CLASSE, [@Classe, Demandas, Projeto]);
end;

function ValidarIntervalos(SL: TStrings; Erros: TfoMessages): Boolean;
var i, i1, i2: Integer;
    s1, s2 : String;
begin
  Result := True;
  for i := 0 to SL.Count-1 do
    begin
    SubStrings('-', s1, s2, SL[i], True);
    try
      i1 := strToInt(s1);
      i2 := strToInt(s2);
      if i1 > i2 then SL[i] := s2 + ' - ' + s1 else SL[i] := s1 + ' - ' + s2;
    except
      On E: Exception do
         begin
         Result := False;
         Erros.Add(etError, 'Intervalo Inválido: ' + SL[i]);
         end;
      end;
    end; // for
end;

function ConsistirIntervalos(SL: TStrings; Erros: TfoMessages): Boolean;
var i, j, i2, i11: Integer;
    s1, s2 : String;
begin
  Result := True;
  for i := 0 to SL.Count-2 do
    begin
    SubStrings('-', s1, s2, SL[i], true);
    for j := i + 1 to SL.Count-1 do
      begin
      SubStrings('-', s1, s2, SL[j], true);
      if i2 >= i11 then
        begin
        Result := False;
        Erros.Add(etError,
        format('O intervalo < %s > invade o intervalo < %s >', [SL[i], SL[j]]));
        end;
      end; // for j
    end; //for i
end;

function OrdenarIntervalos(SL: TStrings): Boolean;
var i, i1, i2: Integer;
    s1, s2 : String;
begin
  Result := True;
  try
    if SL.Count < 2 then exit;
    i := 0;
    repeat
      s1 := System.Copy(SL[i],   1, System.Pos('-', SL[i])-1);
      s2 := System.Copy(SL[i+1], 1, System.Pos('-', SL[i+1])-1);
      i1 := strToInt(allTrim(s1));
      i2 := strToInt(allTrim(s2));
      if i1 > i2 then
         begin
         s1 := SL[i];
         SL[i] := SL[i + 1];
         SL[i + 1] := s1;
         i := 0;
         end
      else
         inc(i);
    until i = SL.Count;
  except
    Result := False;
  end;
end;

function ValidarCoeficientes(SL: TStrings; Erros: TfoMessages): Boolean;
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
