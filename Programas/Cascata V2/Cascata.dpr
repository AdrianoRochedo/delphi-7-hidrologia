program Cascata;

{%ToDo 'Cascata.todo'}

uses
  Forms,
  SysUtils,
  WinUtils,
  IniFiles,
  ChartBaseClasses,
  foBook,
  Frame_Memo,
  Frame_RTF,
  JanelaPrincipal in 'JanelaPrincipal.pas' {caDialogo_JanelaPrincipal},
  JanelaDeDados in 'JanelaDeDados.pas' {caDialogo_Acudes},
  ca_Dialogo_PlanilhaBase in 'ca_Dialogo_PlanilhaBase.pas' {prDialogo_PlanilhaBase},
  ca_Dialogo_ParametrosBasicos in 'ca_Dialogo_ParametrosBasicos.pas' {caDialogo_PlanilhaPB},
  ca_Dialogo_FuncaoRegula in 'ca_Dialogo_FuncaoRegula.pas' {caDialogo_PlanilhaFR},
  ca_Dialogo_AjustePolinomio in 'ca_Dialogo_AjustePolinomio.pas' {caDialogo_PlanilhaAP},
  AboutForm in 'AboutForm.pas' {About},
  Splash in 'splash.pas' {SplashForm},
  UnitConst in 'UnitConst.pas';

{$R *.RES}

var s   : String;
    Ini : TIniFile;
    D   : TSplashForm;
    i   : Integer;
begin
  Application.Initialize;

  DecimalSeparator := '.';

  Application.CreateForm(TcaDialogo_JanelaPrincipal, caDialogo_JanelaPrincipal);
  Application.CreateForm(TcaDialogo_Acudes, caDialogo_Acudes);
  Application.Title := 'Cascata 2000 - Versão 2.0';

  Graficos := TfoChartList.Create();

  Planilha_PB := nil;
  Planilha_FR := nil;
  Planilha_AP := nil;

  s := ExtractFilePath(Application.ExeName);

  ini := TIniFile.Create(s + 'CASCATA.INI');
  gDir := ini.ReadString('GERAL', 'Dir', s);
  ini.Free;

  D := TSplashForm.Create(nil);
  D.Show;
  Delay(3000);
  D.Free;

  // Nao pode ser fechado pelo usuario
  Book := TBook.Create('Editor');
  Book.FreeOnClose := false;

  for i := 1 to ParamCount do
     if System.pos('\', ParamStr(i)) > 0 then
        caDialogo_JanelaPrincipal.Abrir(ParamStr(i));

  // ************************
  Application.Run;
  // ************************

  Book.Free;
  Graficos.Free;

  ini := TIniFile.Create(s + 'CASCATA.INI');
  ini.WriteString('GERAL', 'Dir', gDir);
  ini.Free;
end.
