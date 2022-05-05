unit pr_Dialogo_Projeto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pr_DialogoBase, StdCtrls, Buttons, ExtCtrls, pr_Dialogo_Projeto_RU, drEdit;

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
    Label1: TLabel;
    rbOI_AbrirDialogo: TRadioButton;
    rbOI_ExecutarScript: TRadioButton;
    Label2: TLabel;
    Label3: TLabel;
    Panel11: TPanel;
    rbOI_NavInterno: TRadioButton;
    rbOI_NavSO: TRadioButton;
    Panel12: TPanel;
    Label4: TLabel;
    rbPVN_SBs: TCheckBox;
    procedure btnProcurarClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure cbPropDOSChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbTipoSimulacaoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnRotinasClick(Sender: TObject);
  private
    { Private declarations }
  public
    Rotinas: TprDialogo_Projeto_RU;
  end;

implementation
uses FileCTRL, SysUtilsEx, MessagesForm, 
     pr_Application,
     pr_Funcoes,
     pr_Const,
     pr_Classes,
     pr_Tipos,
     pr_Vars;

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
begin
  Erros.Clear;
  if pr_Funcoes.ValidarIntervalos(mAnos.Lines, Erros) then
     begin
     pr_Funcoes.OrdenarIntervalos(mAnos.Lines);
     pr_Funcoes.ConsistirIntervalos(mAnos.Lines, Erros);
     end;
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

procedure TprDialogo_Projeto.FormCreate(Sender: TObject);
begin
  inherited;
  Rotinas := TprDialogo_Projeto_RU.Create(self);
end;

procedure TprDialogo_Projeto.FormDestroy(Sender: TObject);
begin
  Rotinas.Free;
  inherited;
end;

procedure TprDialogo_Projeto.btnRotinasClick(Sender: TObject);
begin
  Rotinas.Projeto := Objeto;
  Rotinas.Show;
end;

end.
