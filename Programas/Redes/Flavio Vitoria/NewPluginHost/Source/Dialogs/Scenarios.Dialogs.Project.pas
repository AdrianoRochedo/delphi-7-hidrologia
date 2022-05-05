unit Scenarios.Dialogs.Project;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Rochedo.Component.Dialog, StdCtrls, Buttons, ExtCtrls;

type
  TProjectDialog = class(TComponentDialog)
    Panel10: TPanel;
    lbScripts: TListBox;
    btnAdicionarScript: TButton;
    btnRemoverScript: TButton;
    procedure btnAdicionarScriptClick(Sender: TObject);
    procedure btnRemoverScriptClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
uses DialogUtils, WinUtils, Scenarios.Application, Scenarios.Components;

{$R *.dfm}

procedure TProjectDialog.btnAdicionarScriptClick(Sender: TObject);
var s: String;
begin
  if SelectFile(s, Applic.LastDir, 'Scripts|*.pscript|Todos os Arquivos|*.*') then
     begin
     TProject(Parent).getRelativePath(s);
     if lbScripts.Items.IndexOf(s) = -1 then
        lbScripts.Items.Add(s);
     end;
end;

procedure TProjectDialog.btnRemoverScriptClick(Sender: TObject);
begin
  DeleteElemFromListEx(lbScripts);
end;

end.
