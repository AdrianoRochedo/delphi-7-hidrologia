unit iphs1_Procs;

interface
uses Windows, Forms, Classes,
     MessagesForm,
     Hidro_Constantes;

  procedure ShowMessage(Const s: String); overload;
  procedure ShowMessage(Const s: TStrings); overload;
  
  procedure SetGlobalStatus(TudoCorreto: Boolean);

  procedure LerConfiguracoes();
  procedure GravarConfiguracoes();

  procedure CriarObjetosGlobais();
  procedure destruirObjetosGlobais();

  function ObterDadosDeUmaCurvaIDF(): String;

implementation
uses Hidro_Variaveis,
     stdCTRLs,
     SysUtils,
     SysUtilsEx,
     DialogUtils,
     IniFiles,
     Form_Chart,
     esquemas_OpcoesGraf,
     WindowsManager,
     VisaoEmArvore_base,
     FolderUtils,
     Execfile,
     psBASE,

     // Bibliotecas do Script
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

     Main;

procedure ShowMessage(Const s: String);
begin
  gMemo.Lines.Text := s;
end;

procedure ShowMessage(Const s: TStrings);
begin
  gMemo.Lines.Assign(s);
end;

procedure SetGlobalStatus(TudoCorreto: Boolean);
begin
  if TudoCorreto then
     gLeds.Picture.Bitmap.Handle := LoadBitmap(hInstance, 'LED_GREEN')
  else
     gLeds.Picture.Bitmap.Handle := LoadBitmap(hInstance, 'LED_RED');
end;

procedure LerConfiguracoes();
var ini : TiniFile;
begin
  ini := TiniFile.Create(FolderUtils.GetAppDataFolder() + 'IPHS1\IPHS1.ini');
  gDir := ini.ReadString ('Geral', 'Diretorio', '');
  gBloqueado := False;
  ini.Free;
end;

procedure GravarConfiguracoes();
var ini: TiniFile;
    s: string;
    b: boolean;
begin
  s := FolderUtils.GetAppDataFolder() + 'IPHS1\';

  if DirectoryExists(s) then
     b := true
  else
     b := ForceDirectories(s);

  if b then
     begin
     ini := TiniFile.Create(s + 'IPHS1.ini');
     ini.WriteString ('Geral', 'Diretorio', gDir);
     ini.Free();
     end;
end;

procedure CriarObjetosGlobais();
begin
  // Lista dos erros de validação
  gErros := TfoMessages.Create();

  // Esquema de opções de Gráficos
  gEsq_OpcoesGraf := TListaDeEsquemasGraficos.Create;

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
    end;
end;

procedure DestruirObjetosGlobais;
begin
  gEsq_OpcoesGraf.Free;
  gErros.Free;
  g_psLib.Free;
end;

function ObterDadosDeUmaCurvaIDF: String;
var e: TExecFile;
    s: String;
begin
  s := '';
  Result := '';
  e := TExecFile.Create(nil);
  try
    e.Wait := True;
    e.CommandLine := gExePath + 'CurvasIDF.exe';
    if e.Execute then
       if SelectFile(s, gDir, cFiltroTexto, true, ' Selecione o arquivo salvo na IDF') then
          Result := s;
  finally
    e.Free;
  end;
end;

end.
