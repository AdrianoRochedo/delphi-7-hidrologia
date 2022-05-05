unit pr_Dialogo_PCP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pr_DialogoBase, StdCtrls, Buttons, ExtCtrls, ComCtrls, Spin,
  pr_Dialogo_PC_Energia;

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
    procedure btnGerClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure CRC_Click(const Action: String);
  public
    Form_Energia: TprDialogo_PC_Energia;
  end;

implementation
uses pr_Classes,
     pr_Const,
     pr_Vars, 
     //SysUtilsEx,
     FileUtils,
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

  if SelectFile(s, gDir, cFiltroPascalScript) then
     begin
     TprProjeto(Objeto).RetirarCaminhoSePuder(s);
     x.Text := s;
     end;
end;

procedure TprDialogo_PCP.FormCreate(Sender: TObject);
begin
  inherited;
  b1.Tag := integer(edEnergiaUsuario); b11.Tag := b1.Tag; b111.Tag := b1.Tag;
  Form_Energia := TprDialogo_PC_Energia.Create(Objeto);
end;

procedure TprDialogo_PCP.CRC_Click(const Action: String);
begin
end;

procedure TprDialogo_PCP.EditarClick(Sender: TObject);
var s: String;
    p: TprProjeto;
    v1, v2: TVariable;
begin
  p := TprProjeto(TprPCP(Objeto).Projeto);
  s := TEdit(TComponent(Sender).Tag).Text;

  p.VerificarCaminho(s);

  v1 := TVariable.Create('Saida', pvtObject, Integer(gOutPut), gOutPut.ClassType, True);
  v2 := TVariable.Create('Projeto', pvtObject, Integer(p), p.ClassType, True);

  RunScript(g_psLib, s, gDir, nil, [v1, v2], p.GlobalObjects, False);
end;

procedure TprDialogo_PCP.rbGerSimClick(Sender: TObject);
begin
  btnGer.Enabled := rbGerSim.Checked;
end;

procedure TprDialogo_PCP.btnGerClick(Sender: TObject);
begin
  Form_Energia.Tipo := 1;
  Form_Energia.ShowModal;
end;

procedure TprDialogo_PCP.FormDestroy(Sender: TObject);
begin
  Form_Energia.Free;
  inherited;
end;

end.


