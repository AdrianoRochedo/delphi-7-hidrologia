unit pr_Application;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles, Application_Class, pr_Plugins, XML_Utils, Debug, comCTRLs,
  extCTRLs, foBook,
  DiretivasDeCompilacao,
  hidro_Form_GlobalMessages;

type
  TprApplication = class(TApplication)
  private
    FXW: TXML_Writer;
    FPlugins: TPluginList;
    FActiveObject: TObject;
    FFileVersion: integer;
    FDebug: TDebug;
    FPersonalReg: string;
    FGM: ThidroForm_GlobalMessages;
    FStatusBar: TStatusBar;
    FStatusLed: TImage;
    procedure BeforeRun(); override;
    procedure CreateMainForm(); override;
    procedure ReadGlobalsOptions(ini: TIniFile); override;
    procedure SaveGlobalsOptions(ini: TIniFile); override;
    procedure ExceptionEvent(Sender: TObject; E: Exception);
  public
    constructor Create(const Title, Version, PersonalReg: string);
    destructor Destroy(); override;

    // Abre um arquivo da aplicacao
    procedure OpenFile(const Filename: string); override;

    // Obtem o gerador de XML padrão
    function getXMLWriter(): TXML_Writer;

    // Mostra um erro em uma janela
    procedure ShowError(const msg: string);

    // Mostra mensagens em uma janelanão modal
    procedure ShowMessage(const msg: string);

    // Limpa a janela de mensagens
    procedure ClearMessages();

    // Mostra a janela de mensagens
    procedure ShowMessageForm();

    // Escreve na barra de status
    procedure WriteStatus(const Texts: Array of String; Beep: Boolean);

    // Estabelece o status da aplicacao
    procedure setGlobalStatus(Status: Boolean);

    // Cria um novo editor multi-paginas
    function NewBook(const Caption: string): TBook;

    {$ifdef VERSAO_LIMITADA}
    procedure ShowLightMessage(const msg: string);
    {$endif}

    // Barra de status da aplicação
    property StatusBar : TStatusBar read FStatusBar write FStatusBar;

    // Imagem que indica o status da aplicacao
    property StatusLed : TImage read FStatusLed write FStatusLed;

    // Plugins do sistema
    property Plugins : TPluginList read FPlugins;

    // Utilizado para relatório de erros
    // Ex. Indicar qual objeto gerou erro no salvamento da rede.
    property ActiveObject : TObject read FActiveObject write FActiveObject;

    // versao dos arquivos de dados
    property FileVersion : integer read FFileVersion;

    // Indica o nome da pessoa para o qual o Propagar esta registrado
    property PersonalReg : string read FPersonalReg;

    // Objeto para depuração
    property Debug : TDebug read FDebug;
  end;

  function Applic(): TprApplication;

implementation
uses Main,

     // PascalScript
     psBASE,
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
     Lib_SpreadSheet,
     pr_psLib,
     Optimizer_psLib,

     SysUtilsEx,
     WinUtils,
     pr_Vars,
     pr_Classes,
     MessagesForm,
     pr_Gerenciador,
     OutPut,
     Splash;

{$R *.dfm}

function Applic(): TprApplication;
begin
  result := TprApplication( TSystem.getAppInstance() );
end;

{ TprApplication }


// FileVersion 1 : primeira versao
// FileVersion 2 : Acrescimo dos dados sobre qualidade da agua
constructor TprApplication.Create(const Title, Version, PersonalReg: string);
begin
  FFileVersion := 2;
  FPersonalReg := PersonalReg;

  FGM := ThidroForm_GlobalMessages.Create(nil);

  inherited Create(Title, Version);

  Forms.Application.HintHidePause := 10000;
  Forms.Application.OnException := ExceptionEvent;

  SysUtils.DecimalSeparator := '.';
  SysUtils.TwoDigitYearCenturyWindow := 20;

  // Sub-Objetos --------------------------------------------------

  FDebug := TDebug.Create();

  FXW := TXML_Writer.Create(nil);

  FPlugins := TPluginList.Create();
  FPlugins.AddPath(appDir + 'Plugins\CenariosDeDemanda');
  FPlugins.Load();

  // Lista dos erros de validação
  gErros := TfoMessages.Create();

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
    Include(Lib_SpreadSheet.API);
    Include(pr_psLib.API);
    Include(Optimizer_psLib.API);
    end;
end;

destructor TprApplication.Destroy();
begin
  FGM.Free();
  FXW.Free();
  FPlugins.Free();
  gErros.Free();
  g_psLib.Free();
  FDebug.Free();

  inherited Destroy();
end;

procedure TprApplication.CreateMainForm();
begin
  CreateForm(TprDialogo_Principal, Main.MainForm);

  MainForm.Caption := ' ' + Forms.Application.Title + ' ' + Version;

  if FPersonalReg <> '' then
     MainForm.Caption := MainForm.Caption + ' - Registrado para ' + FPersonalReg;

  if dir_NivelDeRestricao <> 0 then
     MainForm.Caption := MainForm.Caption + ' - Nível de Restrição ' + toString(dir_NivelDeRestricao);

  {$ifdef VERSAO_LIMITADA}
  MainForm.Caption := MainForm.Caption + ' (VERSÃO LIMITADA)';
  {$endif}
end;

procedure TprApplication.ReadGlobalsOptions(ini: TIniFile);
var aux : Integer;
begin
  inherited;

  Gerenciador.Left    := ini.ReadInteger('Gerente', 'x' , 425);
  Gerenciador.Top     := ini.ReadInteger('Gerente', 'y' , 142);
  Gerenciador.Width   := ini.ReadInteger('Gerente', 'dx', 303);
  Gerenciador.Height  := ini.ReadInteger('Gerente', 'dy', 355);
  Gerenciador.Visible := ini.ReadBool   ('Gerente', 'Visible', False);
end;

procedure TprApplication.SaveGlobalsOptions(ini: TIniFile);
begin
  ini.WriteInteger('Gerente', 'x'      , Gerenciador.Left);
  ini.WriteInteger('Gerente', 'y'      , Gerenciador.Top);
  ini.WriteInteger('Gerente', 'dx'     , Gerenciador.Width);
  ini.WriteInteger('Gerente', 'dy'     , Gerenciador.Height);
  ini.WriteBool   ('Gerente', 'Visible', Gerenciador.Visible);

  ini.WriteInteger('Principal', 'x' , MainForm.Left);
  ini.WriteInteger('Principal', 'y' , MainForm.Top);
  ini.WriteInteger('Principal', 'dx', MainForm.Width);
  ini.WriteInteger('Principal', 'dy', MainForm.Height);
  ini.WriteInteger('Principal', 'ws', ord(MainForm.WindowState));

  inherited;
end;

procedure TprApplication.BeforeRun();
var i: Integer;
    d: TprDialogo_Splash;
    MostrarSplash: boolean;
begin
  inherited;

  {$IFDEF DEBUG}
  SysUtils.beep;
  Dialogs.showMessage('Este projeto contém código para DEBUG');
  {$ELSE}
  MostrarSplash := True;
  for i := 1 to System.ParamCount do
    if SysUtils.CompareText(ParamStr(i), 'SEMSPLASH') = 0 then
       MostrarSplash := False
    else
       if System.pos('\', System.ParamStr(i)) > 0 then
          Main.MainForm.CreateMDIChild(System.ParamStr(i), False, False, -1);

  if MostrarSplash then
     begin
     d := TprDialogo_Splash.Create(nil);
     d.Show;
     {$IFDEF FINAL}
     WinUtils.Delay(2500);
     {$ELSE}
     WinUtils.Delay(500);
     {$ENDIF}
     d.Free;
     end;
  {$ENDIF}
end;

function TprApplication.getXMLWriter(): TXML_Writer;
begin
  Result := FXW;
end;

procedure TprApplication.ExceptionEvent(Sender: TObject; E: Exception);
begin
  ShowError(E.Message);
end;

procedure TprApplication.ShowError(const msg: string);
var s: string;
begin
  if FActiveObject is TComponente then
     s := Format('Objeto: %s'#13 +
                 'Erro: %s',
                 [
                   TComponente(FActiveObject).Nome,
                   msg
                 ])
  else
     s := 'Erro: ' + msg;

  Dialogs.ShowMessage(s);   
end;

procedure TprApplication.ClearMessages();
begin
  FGM.Clear();
end;

procedure TprApplication.ShowMessage(const msg: string);
begin
  FGM.Message := msg;
end;

procedure TprApplication.ShowMessageForm();
begin
  FGM.Show();
end;

procedure TprApplication.WriteStatus(const Texts: array of String; Beep: Boolean);
begin
  if FStatusBar <> nil then
     WinUtils.WriteStatus(FStatusBar, Texts, Beep);
end;

procedure TprApplication.setGlobalStatus(Status: Boolean);
begin
  if Status then
     FStatusLed.Picture.Bitmap.Handle := LoadBitmap(hInstance, 'LED_GREEN')
  else
     FStatusLed.Picture.Bitmap.Handle := LoadBitmap(hInstance, 'LED_RED');
end;

procedure TprApplication.OpenFile(const Filename: string);
begin
  Main.MainForm.CreateMDIChild(Filename, false, false, -1);
end;

{$ifdef VERSAO_LIMITADA}
procedure TprApplication.ShowLightMessage(const msg: string);
begin
  MessageDLG('Versão Limitada - ' + msg, mtInformation, [mbOk], 0);
end;
{$endif}

function TprApplication.NewBook(const Caption: string): TBook;
begin
  result := foBook.TBook.Create(Caption, fsMDIChild);
end;

end.
