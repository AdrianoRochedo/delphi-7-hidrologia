unit Scenarios.Application;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles, Application_Class, XML_Utils, Debug, comCTRLs,
  extCTRLs, foBook, MessagesForm, psBASE,

  // Programa ....
  Scenarios.Plugins,
  Scenarios.Form.GlobalMessages;

type
  TScenariosApplication = class(TApplication)
  private
    FPlugins: TPluginList;
    FFileVersion: integer;
    FPersonalReg: string;
    FGM: TGlobalMessagesForm;
    FStatusBar: TStatusBar;
    FStatusLed: TImage;
    FMessages: TfoMessages;
    FPS_Lib: TLib;
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

    // Barra de status da aplicação
    property StatusBar : TStatusBar read FStatusBar write FStatusBar;

    // Imagem que indica o status da aplicacao
    property StatusLed : TImage read FStatusLed write FStatusLed;

    // Plugins do sistema
    property Plugins : TPluginList read FPlugins;

    // versao dos arquivos de dados
    property FileVersion : integer read FFileVersion;

    // Indica o nome da pessoa para o qual o Propagar esta registrado
    property PersonalReg : string read FPersonalReg;

    // Mensagens de erros
    property Messages : TfoMessages read FMessages;

    // Bibliotecas do PascalScript
    property PS_Lib : TLib read FPS_Lib;
  end;

  function Applic(): TScenariosApplication;

implementation
uses Scenarios.Form.Main,

     // PascalScript
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
     Scenarios.Script.Classes,

     SysUtilsEx,
     WinUtils,
     OutPut;
     //Splash;

{$R *.dfm}

function Applic(): TScenariosApplication;
begin
  result := TScenariosApplication( TSystem.getAppInstance() );
end;

{ TScenariosApplication }


// FileVersion 1 : primeira versao
// FileVersion 2 : Acrescimo dos dados sobre qualidade da agua
constructor TScenariosApplication.Create(const Title, Version, PersonalReg: string);
begin
  FFileVersion := 2;
  FPersonalReg := PersonalReg;

  FGM := TGlobalMessagesForm.Create(nil);

  inherited Create(Title, Version);

  Forms.Application.HintHidePause := 10000;
  Forms.Application.OnException := ExceptionEvent;

  SysUtils.DecimalSeparator := '.';
  SysUtils.TwoDigitYearCenturyWindow := 20;

  // Sub-Objetos --------------------------------------------------

  // Plugins
  FPlugins := TPluginList.Create();
  FPlugins.AddPath(appDir + 'Plugins');
  FPlugins.Load();

  // Lista dos erros de validação
  FMessages := TfoMessages.Create();

  // Bibliotecas do Pascal Script
  FPS_Lib := TLib.Create();
  with FPS_Lib do
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
    Include(Scenarios.Script.Classes.API);
    end;
end;

destructor TScenariosApplication.Destroy();
begin
  FGM.Free();
  FMessages.Free();
  FPS_Lib.Free();
  FPlugins.Free();
  inherited Destroy();
end;

procedure TScenariosApplication.CreateMainForm();
var FMainForm: TForm;
begin
  CreateForm(TfoMain, FMainForm);

  FMainForm.Caption := ' ' + Forms.Application.Title + ' ' + Version;

  if FPersonalReg <> '' then
     FMainForm.Caption := FMainForm.Caption + ' - Registrado para ' + FPersonalReg;
end;

procedure TScenariosApplication.ReadGlobalsOptions(ini: TIniFile);
var aux : Integer;
begin
  inherited;
(*
  Gerenciador.Left    := ini.ReadInteger('Gerente', 'x' , 425);
  Gerenciador.Top     := ini.ReadInteger('Gerente', 'y' , 142);
  Gerenciador.Width   := ini.ReadInteger('Gerente', 'dx', 303);
  Gerenciador.Height  := ini.ReadInteger('Gerente', 'dy', 355);
  Gerenciador.Visible := ini.ReadBool   ('Gerente', 'Visible', False);
*)
end;

procedure TScenariosApplication.SaveGlobalsOptions(ini: TIniFile);
begin
(*
  ini.WriteInteger('Gerente', 'x'      , Gerenciador.Left);
  ini.WriteInteger('Gerente', 'y'      , Gerenciador.Top);
  ini.WriteInteger('Gerente', 'dx'     , Gerenciador.Width);
  ini.WriteInteger('Gerente', 'dy'     , Gerenciador.Height);
  ini.WriteBool   ('Gerente', 'Visible', Gerenciador.Visible);

  ini.WriteInteger('Principal', 'x' , FMainForm.Left);
  ini.WriteInteger('Principal', 'y' , FMainForm.Top);
  ini.WriteInteger('Principal', 'dx', FMainForm.Width);
  ini.WriteInteger('Principal', 'dy', FMainForm.Height);
  ini.WriteInteger('Principal', 'ws', ord(FMainForm.WindowState));
*)
  inherited;
end;

procedure TScenariosApplication.BeforeRun();
var i: Integer;
    //d: TprDialogo_Splash;
    MostrarSplash: boolean;
begin
  inherited;
(*
  {$IFDEF DEBUG}
  SysUtils.beep;
  Dialogs.showMessage('Este projeto contém código para DEBUG');
  {$ELSE}
  MostrarSplash := True;
  for i := 1 to System.ParamCount() do
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
*)
{TODO 1 -cProgramacao: BeforeRun - Splash}
end;

procedure TScenariosApplication.ExceptionEvent(Sender: TObject; E: Exception);
begin
  ShowError(E.Message);
end;

procedure TScenariosApplication.ClearMessages();
begin
  FGM.Clear();
end;

procedure TScenariosApplication.ShowMessage(const msg: string);
begin
  FGM.Message := msg;
end;

procedure TScenariosApplication.ShowMessageForm();
begin
  FGM.Show();
end;

procedure TScenariosApplication.WriteStatus(const Texts: array of String; Beep: Boolean);
begin
  if FStatusBar <> nil then
     WinUtils.WriteStatus(FStatusBar, Texts, Beep);
end;

procedure TScenariosApplication.setGlobalStatus(Status: Boolean);
begin
  if Status then
     FStatusLed.Picture.Bitmap.Handle := LoadBitmap(hInstance, 'LED_GREEN')
  else
     FStatusLed.Picture.Bitmap.Handle := LoadBitmap(hInstance, 'LED_RED');
end;

procedure TScenariosApplication.OpenFile(const Filename: string);
begin
  TfoMain(MainForm).CreateMDIChild(Filename);
end;

function TScenariosApplication.NewBook(const Caption: string): TBook;
begin
  result := foBook.TBook.Create(Caption, fsMDIChild);
end;

end.
