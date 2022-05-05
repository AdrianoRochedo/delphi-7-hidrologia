unit pr_Dialogo_Projeto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pr_DialogoBase, StdCtrls, Buttons, ExtCtrls, drEdit;

type
  TprDialogo_Projeto = class(TprDialogo_Base)
    Panel3: TPanel;
    Panel4: TPanel;
    mAnos: TMemo;
    cbIntSim: TComboBox;
    Open: TOpenDialog;
    SpeedButton1: TSpeedButton;
    Panel7: TPanel;
    edDirSai: TEdit;
    SpeedButton2: TSpeedButton;
    Panel8: TPanel;
    edDirPes: TEdit;
    Panel14: TPanel;
    edNF: TdrEdit;
    Panel5: TPanel;
    cbPropDOS: TComboBox;
    mmPropDOS: TMemo;
    Panel6: TPanel;
    Panel9: TPanel;
    rbDOS: TRadioButton;
    rbTipoSimulacao: TRadioButton;
    btnRotinas: TButton;
    Panel10: TPanel;
    lbScripts: TListBox;
    btnAdicionarScript: TButton;
    btnRemoverScript: TButton;
    procedure btnProcurarClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure cbPropDOSChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbTipoSimulacaoClick(Sender: TObject);
    procedure btnAdicionarScriptClick(Sender: TObject);
    procedure btnRemoverScriptClick(Sender: TObject);
  public
  end;

implementation
uses FileCTRL, SysUtilsEx, MessagesForm,
     pr_Application,
     pr_Funcoes,
     pr_Const,
     pr_Classes,
     pr_Tipos,
     pr_Vars,
     WinUtils,
     DialogUtils;

{$R *.DFM}

procedure TprDialogo_Projeto.btnProcurarClick(Sender: TObject);
var s: String;
begin
  inherited;
  case TComponent(Sender).Tag of
    0, 1:
      if not SelectDirectory('Selecione um Diretório', '', s) then exit;
    end;

  case TComponent(Sender).Tag of
    0: edDirSai.Text    := s;
    1: edDirPes.Text    := s;
    end;
end;

procedure TprDialogo_Projeto.btnOkClick(Sender: TObject);
var Erro: Boolean;
begin
  Erros.Clear;
  inherited;
end;

procedure TprDialogo_Projeto.cbPropDOSChange(Sender: TObject);
var s: String;
begin
  inherited;
  s := cbPropDos.Items[cbPropDos.ItemIndex];
  if FileExists(Applic.appDir + s + '.TXT') then
     mmPropDos.Lines.LoadFromFile(Applic.appDir + s + '.TXT')
  else
     begin
     mmPropDos.Lines.Clear;
     mmPropDos.Lines.Add('Não há descrição');
     end;
end;

procedure TprDialogo_Projeto.FormShow(Sender: TObject);
begin
  inherited;
  cbPropDOSChange(nil);
end;

procedure TprDialogo_Projeto.rbTipoSimulacaoClick(Sender: TObject);
begin
  Panel5.Enabled    := rbDOS.Checked;
  cbPropDOS.Enabled := Panel5.Enabled;
  mmPropDOS.Enabled := Panel5.Enabled;
end;

procedure TprDialogo_Projeto.btnAdicionarScriptClick(Sender: TObject);
var s: String;
begin
  if SelectFile(s, Applic.LastDir, cFiltroPascalScript) then
     begin
     TprProjeto(Objeto).RetiraCaminhoSePuder(s);
     if lbScripts.Items.IndexOf(s) = -1 then
        lbScripts.Items.Add(s);
     end;
end;

procedure TprDialogo_Projeto.btnRemoverScriptClick(Sender: TObject);
begin
  DeleteElemFromListEx(lbScripts);
end;

end.
