unit pr_Dialogo_PCP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pr_DialogoBase, StdCtrls, Buttons, ExtCtrls, ComCtrls, Spin;

type
  TprDialogo_PCP = class(TprDialogo_Base)
    edEnergiaUsuario: TEdit;
    Panel101: TPanel;
    b1: TButton;
    b11: TButton;
    b111: TButton;
    Panel4: TPanel;
    cbCor: TColorBox;
    Panel5: TPanel;
    rbGerNao: TRadioButton;
    rbGerSim: TRadioButton;
    btnGer: TButton;
    procedure Limpar_Click(Sender: TObject);
    procedure EscolherArquivo_Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditarClick(Sender: TObject);
    procedure rbGerSimClick(Sender: TObject);
  private
    procedure CRC_Click(const Action: String);
  end;

implementation
uses OutPut,
     pr_Application,
     pr_Classes,
     pr_Const,
     pr_Vars,
     DialogUtils,
     psEditor,
     psBASE;

{$R *.DFM}

procedure TprDialogo_PCP.Limpar_Click(Sender: TObject);
begin
  edEnergiaUsuario.Text := '';
end;

procedure TprDialogo_PCP.EscolherArquivo_Click(Sender: TObject);
var s: String;
    x: TEdit;
begin
  x := TEdit(TComponent(Sender).Tag);
  s := x.Text;

  if SelectFile(s, Applic.LastDir, cFiltroPascalScript) then
     begin
     TprProjeto(Objeto).RetiraCaminhoSePuder(s);
     x.Text := s;
     end;
end;

procedure TprDialogo_PCP.FormCreate(Sender: TObject);
begin
  inherited;
  b1.Tag := integer(edEnergiaUsuario); b11.Tag := b1.Tag; b111.Tag := b1.Tag;
end;

procedure TprDialogo_PCP.CRC_Click(const Action: String);
begin
end;

procedure TprDialogo_PCP.EditarClick(Sender: TObject);
var s: String;
    p: TprProjeto;
    v: TVariable;
begin
  p := TprProjeto(TprPC(Objeto).Projeto);
  s := TEdit(TComponent(Sender).Tag).Text;
  p.VerificaCaminho(s);
  v := TVariable.Create('Projeto', pvtObject, Integer(p), p.ClassType, True);
  RunScript(g_psLib, s, Applic.LastDir, nil, [v], p.GlobalObjects, False);
end;

procedure TprDialogo_PCP.rbGerSimClick(Sender: TObject);
begin
  btnGer.Enabled := rbGerSim.Checked;
end;

end.


