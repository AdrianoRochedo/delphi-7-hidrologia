program NewPluginHost;

{%ToDo 'NewPluginHost.todo'}

uses
  ShareMem,
  Application_Class,
  pr_Interfaces in '..\..\Propagar 3.0\Fontes\Unidades\pr_Interfaces.pas',
  Scenarios.Application in 'Source\Units\Scenarios.Application.pas' {ScenariosApplication: TDataModule},
  Scenarios.Form.Main in 'Source\Dialogs\Scenarios.Form.Main.pas' {foMain},
  Scenarios.Form.GlobalMessages in 'Source\Dialogs\Scenarios.Form.GlobalMessages.pas' {GlobalMessagesForm},
  Scenarios.Plugins in 'Source\Units\Scenarios.Plugins.pas',
  Rochedo.Component in 'Source\Units\Rochedo.Component.pas',
  Rochedo.Component.Dialog in 'Source\Dialogs\Rochedo.Component.Dialog.pas' {ComponentDialog},
  Rochedo.MessageIDs in 'Source\Units\Rochedo.MessageIDs.pas',
  Rochedo.Designer in 'Source\Units\Rochedo.Designer.pas' {Designer},
  Scenarios.Designer in 'Source\Units\Scenarios.Designer.pas' {ScenariosDesigner},
  Scenarios.Consts in 'Source\Units\Scenarios.Consts.pas',
  Scenarios.Components in 'Source\Units\Scenarios.Components.pas',
  Rochedo.Designer.ZoomPanel in 'Source\Units\Rochedo.Designer.ZoomPanel.pas' {ZoomPanelDesigner},
  Scenarios.Dialogs.Project in 'Source\Dialogs\Scenarios.Dialogs.Project.pas' {ProjectDialog},
  Scenarios.Script.Classes in 'Source\Units\Scenarios.Script.Classes.pas';

{$R *.res}
{$R Imagens.res}

begin
  TSystem.Run(
    TScenariosApplication.Create('NewPluginHost', '0.01', '')
    );
end.
