unit pr_Dialogo_Projeto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, drEdit,
  pr_DialogoBase, 
  pr_Dialogo_Projeto_RU,
  pr_Dialogo_Projeto_OpcVisRede;

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
    btnOpcVisRede: TButton;
    procedure btnProcurarClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure cbPropDOSChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbTipoSimulacaoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnRotinasClick(Sender: TObject);
    procedure btnAdicionarScriptClick(Sender: TObject);
    procedure btnRemoverScriptClick(Sender: TObject);
    procedure btnOpcVisRedeClick(Sender: TObject);
  private
    { Private declarations }
  public
    Rotinas: TprDialogo_Projeto_RU;
    OpcVisRede: TprDialogo_Projeto_OpcVisRede;
  end;

implementation
uses FileCTRL, pr_Funcoes, SysUtilsEx, ErrosDLG, pr_Const, pr_Tipos, pr_Vars, 
     pr_Classes,
     WinUtils,
     FileUtils;

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
  if ValidaIntervalos(mAnos.Lines, Erros) then
     begin
     OrdenaIntervalos(mAnos.Lines);
     ConsisteIntervalos(mAnos.Lines, Erros);
     end;
  inherited;
end;

procedure TprDialogo_Projeto.cbPropDOSChange(Sender: TObject);
var s: String;
begin
  inherited;
  s := cbPropDos.Items[cbPropDos.ItemIndex];
  if FileExists(gExePath + s + '.TXT') then
     mmPropDos.Lines.LoadFromFile(gExePath + s + '.TXT')
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

procedure TprDialogo_Projeto.FormCreate(Sender: TObject);
begin
  inherited;
  Rotinas := TprDialogo_Projeto_RU.Create(self);
  OpcVisRede := TprDialogo_Projeto_OpcVisRede.Create(self);
end;

procedure TprDialogo_Projeto.FormDestroy(Sender: TObject);
begin
  Rotinas.Free;
  OpcVisRede.Free;
  inherited;
end;

procedure TprDialogo_Projeto.btnRotinasClick(Sender: TObject);
begin
  Rotinas.Projeto := Objeto;
  Rotinas.Show;
end;

procedure TprDialogo_Projeto.btnAdicionarScriptClick(Sender: TObject);
var s: String;
begin
  if SelectFile(s, gDir, cFiltroPascalScript) then
     begin
     TprProjeto(Objeto).RetirarCaminhoSePuder(s);
     if lbScripts.Items.IndexOf(s) = -1 then
        lbScripts.Items.Add(s);
     end;
end;

procedure TprDialogo_Projeto.btnRemoverScriptClick(Sender: TObject);
begin
  DeleteElemFromListEx(lbScripts);
end;

procedure TprDialogo_Projeto.btnOpcVisRedeClick(Sender: TObject);
begin
  OpcVisRede.Show;
end;

end.
