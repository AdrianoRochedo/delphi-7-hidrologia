unit pr_Funcoes;

interface
uses Windows, Forms, Classes, MessageManager, ErrosDLG,
     pr_Const,
     pr_Tipos;

  function PrioridadeToString(Prior: TEnumPriorDemanda): String;

  procedure ShowMessage(Const s: String); overload;
  procedure ShowMessage(Const s: TStrings); overload;
  procedure SetGlobalStatus(TudoCorreto: Boolean);

  function  ValidaIntervalos(SL: TStrings; Erros: TErros_DLG): Boolean;
  function  OrdenaIntervalos(SL: TStrings): Boolean;
  function  ConsisteIntervalos(SL: TStrings; Erros: TErros_DLG): Boolean;

  function  ValidaCoeficientes(SL: TStrings; Erros: TErros_DLG): Boolean;

  {Obtém a instância do objeto dado o seu nome}
  function  ObterObjetoPeloNome(const Nome: String; Projeto: TObject): TObject;

  // Obtém uma lista de todas as demandas pertencentes a uma mesma classe de demanda e a um projeto
  // Se <Classe> = "TODAS" então retorna uma lista ordenada com todas as demendas no formato:
  //    [nome da classe de demanda] nome da demanda
  procedure ObterDemandasPelaClasse(const Classe: String; var Demandas: TStrings; Projeto: TObject);

  {Verifica se no nome de um arquivo está seu caminho}
  function PossuiCaminho(const Arquivo: String): Boolean;

  procedure LerConfiguracoes;
  procedure GravarConfiguracoes;

  procedure CriarObjetosGlobais;
  procedure DestruirObjetosGlobais;

  {$IFDEF CD}
  procedure RegistrarObjetosCOM();
  {$ENDIF}

implementation
uses stdCTRLs,
     Registry,
     SysUtils,
     SysUtilsEx,
     FileUtils,
     FolderUtils,
     RegistryUtils,
     IniFiles,
     pr_Vars,
     pr_Gerenciador,
     OutPut,
     wsOutPut,
     drGraficos,
     Edit,
     esquemas_OpcoesGraf,
     WindowsManager,
     psBASE,

     // OCXs
     VCF1,
     MapObjects,

     // Bibliotecas do PascalScript
     Lib_System,
     Lib_Windows,
     Lib_Math,
     Lib_String,
     Lib_StringList,
     Lib_Listas,
     Lib_File,
     Lib_wsVec,
     Lib_wsMatrix,
     Lib_Chart,
     Lib_Sheet,
     pr_psLib,
     Rosenbrock_psLib,

     Main;

procedure ShowMessage(Const s: String);
begin
  GlobalMessages.Message := s;
end;

procedure ShowMessage(Const s: TStrings);
begin
  GlobalMessages.mm.Lines.Assign(s);
end;

procedure SetGlobalStatus(TudoCorreto: Boolean);
begin
  if TudoCorreto then
     gLeds.Picture.Bitmap.Handle := LoadBitmap(hInstance, 'LED_GREEN')
  else
     gLeds.Picture.Bitmap.Handle := LoadBitmap(hInstance, 'LED_RED');
end;

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

function ValidaIntervalos(SL: TStrings; Erros: TErros_DLG): Boolean;
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

function ConsisteIntervalos(SL: TStrings; Erros: TErros_DLG): Boolean;
var i, j, i1, i2, i11, i22: Integer;
    s1, s2 : String;
begin
  Result := True;
  for i := 0 to SL.Count-2 do
    begin
    SubStrings('-', s1, s2, SL[i], true);
    i1 := strToInt(s1); i2 := strToInt(s2);
    for j := i + 1 to SL.Count-1 do
      begin
      SubStrings('-', s1, s2, SL[j], true);
      i11 := strToInt(s1); i22 := strToInt(s2);
      if i2 >= i11 then
        begin
        Result := False;
        Erros.Add(etError,
        format('O intervalo < %s > invade o intervalo < %s >', [SL[i], SL[j]]));
        end;
      end; // for j
    end; //for i
end;

function OrdenaIntervalos(SL: TStrings): Boolean;
var i, i1, i2: Integer;
    s1, s2 : String;
begin
  Result := True;
  try
    if SL.Count < 2 then exit;
    i := 0;
    repeat
      s1 := Copy(SL[i],   1, System.Pos('-', SL[i])-1);
      s2 := Copy(SL[i+1], 1, System.Pos('-', SL[i+1])-1);
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

function  ValidaCoeficientes(SL: TStrings; Erros: TErros_DLG): Boolean;
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

procedure LerConfiguracoes;
var ini : TiniFile;
    SL  : TStrings;
    aux : Integer;
    s   : String;
begin
  SysUtils.TwoDigitYearCenturyWindow := 20;

  s := FolderUtils.GetSpecialFolderPath(FolderUtils.CSIDL_APPDATA, True);
  s := s + 'Propagar 3.0\';

  if not DirectoryExists(s) then
     if not ForceDirectories(s) then
        Exit;

  ini := TiniFile.Create(s + 'Propagar.ini');

  Gerenciador.Left    := ini.ReadInteger('Gerente', 'x' , 425);
  Gerenciador.Top     := ini.ReadInteger('Gerente', 'y' , 142);
  Gerenciador.Width   := ini.ReadInteger('Gerente', 'dx', 303);
  Gerenciador.Height  := ini.ReadInteger('Gerente', 'dy', 355);
  Gerenciador.Visible := ini.ReadBool   ('Gerente', 'Visible', False);

  with foMain do
    begin
    Left        := ini.ReadInteger('Principal', 'x' , Left);
    Top         := ini.ReadInteger('Principal', 'y' , Top);
    Width       := ini.ReadInteger('Principal', 'dx', Width);
    Height      := ini.ReadInteger('Principal', 'dy', Height);
    aux         := ini.ReadInteger('Principal', 'ws', ord(wsMaximized));
    WindowState := TWindowState(aux);
    end;

  with gOutPut do
    begin
    Editor.Left    := ini.ReadInteger('Editor', 'x' , Editor.Left);
    Editor.Top     := ini.ReadInteger('Editor', 'y' , Editor.Top);
    Editor.Width   := ini.ReadInteger('Editor', 'dx', Editor.Width);
    Editor.Height  := ini.ReadInteger('Editor', 'dy', Editor.Height);
    Editor.Visible := ini.ReadBool   ('Editor', 'Visible', False);
    end;

  gDir := ini.ReadString ('Geral', 'Diretorio', '');
  ini.Free;
{
  s := GetTempFile(s, '000');
  try
    DecryptFile(1803, gExePath + 'prSystem.seg', s);
    if FileExists(s) then
       begin
       SL := TStringList.Create;
       SL.LoadFromFile(s);
       DeleteFile(s);
       gBloqueado := not (SL.Values['Bloqueado'] = 'NAO');
       SL.Free;
       end
    else
       gBloqueado := True;
  except
      gBloqueado := True;
    end;
}    
end;

procedure GravarConfiguracoes;
var ini: TiniFile;
    s: String;
begin
  s := FolderUtils.GetSpecialFolderPath(FolderUtils.CSIDL_APPDATA, True);
  s := s + 'Propagar 3.0\';
  if DirectoryExists(s) then
     begin
     ini := TiniFile.Create(s + 'Propagar.ini');

     ini.WriteInteger('Gerente', 'x'      , Gerenciador.Left);
     ini.WriteInteger('Gerente', 'y'      , Gerenciador.Top);
     ini.WriteInteger('Gerente', 'dx'     , Gerenciador.Width);
     ini.WriteInteger('Gerente', 'dy'     , Gerenciador.Height);
     ini.WriteBool   ('Gerente', 'Visible', Gerenciador.Visible);

     ini.WriteInteger('Principal', 'x' , foMain.Left);
     ini.WriteInteger('Principal', 'y' , foMain.Top);
     ini.WriteInteger('Principal', 'dx', foMain.Width);
     ini.WriteInteger('Principal', 'dy', foMain.Height);
     ini.WriteInteger('Principal', 'ws', ord(foMain.WindowState));

     ini.WriteInteger('Editor', 'x'      , gOutPut.Editor.Left);
     ini.WriteInteger('Editor', 'y'      , gOutPut.Editor.Top);
     ini.WriteInteger('Editor', 'dx'     , gOutPut.Editor.Width);
     ini.WriteInteger('Editor', 'dy'     , gOutPut.Editor.Height);
     ini.WriteBool   ('Editor', 'Visible', gOutPut.Editor.Visible);

     ini.WriteString ('Geral', 'Diretorio', gDir);

     ini.Free;
     end;
end;

procedure CriarObjetosGlobais;
begin
  // Lista dos erros de validação
  gErros := TErros_DLG.Create(Application);

  // Esquema de opções de Gráficos
  gEsq_OpcoesGraf := TListaDeEsquemasGraficos.Create;

  // Saída de resultados
  gOutPut                  := TwsOutPut.Create;
  gOutPut.DocType          := dtTEXT;
  gOutPut.Editor.FormStyle := fsStayOnTop;

  // Bibliotecas do Pascal Script
  g_psLib := TLib.Create;
  with g_psLib do
    begin
    Functions.Economize := False;
    Procs.Economize := False;
    Classes.Economize := False;

    Include(Lib_System.API);
    Include(Lib_Windows.API);
    Include(Lib_Math.API);
    Include(Lib_String.API);
    Include(Lib_StringList.API);
    Include(Lib_Listas.API);
    Include(Lib_File.API);
    Include(Lib_wsVec.API);
    Include(Lib_wsMatrix.API);
    Include(Lib_Chart.API);
    Include(Lib_Sheet.API);
    Include(pr_psLib.API);
    Include(Rosenbrock_psLib.API);
    end;

  gmoPoint := coPoint.Create;
end;

procedure DestruirObjetosGlobais;
begin
  gEsq_OpcoesGraf.Free;
  gErros.Free;
  gOutPut.Free;
  g_psLib.Free;
  gmoPoint := nil;
end;

function PrioridadeToString(Prior: TEnumPriorDemanda): String;
begin
  case Prior of
    pdPrimaria   : Result := 'PRIMÁRIA';
    pdSecundaria : Result := 'SECUNDÁRIA';
    pdTerciaria  : Result := 'TERCIÁRIA';
  end;
end;

const
  CLASS_DAO: TGUID = '{00000010-0000-0010-8000-00AA006D2EA4}';

{$IFDEF CD}
procedure RegistrarObjetosCOM();
var Reg: TRegistry;
    Registred: Boolean;
begin
  Reg := TRegistry.Create;
  try
    // FormulaOne
    Registred := ComClassIsRegistred(Reg, CLASS_F1Book);
    if not Registred then
       RegisterCOM(gExePath + 'Lib\FormulaOne\VCF132.OCX');

    // MapObjects
    Registred := ComClassIsRegistred(Reg, CLASS_Map) and
                 ComClassIsRegistred(Reg, CLASS_GeoCoordSys);
    if not Registred then
       begin
       RegisterCOM(gExePath + 'Lib\MapObjects\Mo20.OCX');
       RegisterCOM(gExePath + 'Lib\MapObjects\cad20.Dll');
       RegisterCOM(gExePath + 'Lib\MapObjects\coverage20.Dll');
       RegisterCOM(gExePath + 'Lib\MapObjects\mosde302.Dll');
       RegisterCOM(gExePath + 'Lib\MapObjects\mosde80.Dll');
       RegisterCOM(gExePath + 'Lib\MapObjects\mosde81.Dll');
       RegisterCOM(gExePath + 'Lib\MapObjects\sg.Dll');
       end;

    // DAO 3.50
    Registred := ComClassIsRegistred(Reg, CLASS_DAO);
    if not Registred then
       RegisterCOM(gExePath + 'Lib\DAO\dao350.DLL');
  finally
    Reg.Free;
  end;  
end;
{$ENDIF}

end.
