unit pr_Dialogo_Projeto_Rosenbrock_RU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls;

type
  TprDialogo_Projeto_Rosenbrock_RU = class(TForm)
    edFimUsuario: TEdit;
    Panel101: TPanel;
    b2: TButton;
    b22: TButton;
    edIniUsuario: TEdit;
    Panel10: TPanel;
    b1: TButton;
    b11: TButton;
    edGeralUsuario: TEdit;
    Panel1: TPanel;
    b3: TButton;
    b33: TButton;
    btnOk: TBitBtn;
    OpenFile: TOpenDialog;
    b333: TButton;
    b222: TButton;
    b111: TButton;
    procedure Limpar_Click(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EscolherArquivo_Click(Sender: TObject);
    procedure Editar_Click(Sender: TObject);
  private
    { Private declarations }
  public
    Projeto: TObject;
  end;

implementation
uses pr_Classes,
     pr_Const,
     pr_Vars,
     FileUtils,
     psEditor,
     psBASE;

{$R *.DFM}

procedure TprDialogo_Projeto_Rosenbrock_RU.Limpar_Click(Sender: TObject);
begin
  TEdit(TComponent(Sender).Tag).Text := '';
end;

procedure TprDialogo_Projeto_Rosenbrock_RU.btnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TprDialogo_Projeto_Rosenbrock_RU.FormCreate(Sender: TObject);
begin
  b1.Tag := integer(edIniUsuario);   b11.Tag := b1.Tag; b111.Tag := b1.Tag;
  b2.Tag := integer(edFimUsuario);   b22.Tag := b2.Tag; b222.Tag := b2.Tag;
  b3.Tag := integer(edGeralUsuario); b33.Tag := b3.Tag; b333.Tag := b3.Tag;
end;

procedure TprDialogo_Projeto_Rosenbrock_RU.EscolherArquivo_Click(Sender: TObject);
var s: String;
    x: TEdit;
begin
  x := TEdit(TComponent(Sender).Tag);
  s := x.Text;

  if SelectFile(s, gDir, cFiltroPascalScript) then
     begin
     TprProjeto(Projeto).RetirarCaminhoSePuder(s);
     x.Text := s;
     end;
end;

procedure TprDialogo_Projeto_Rosenbrock_RU.Editar_Click(Sender: TObject);
var s: String;
    p: TprProjeto;
    v1, v2, v3: TVariable;
begin
  p := TprProjeto(Projeto);
  s := TEdit(TComponent(Sender).Tag).Text;

  p.VerificarCaminho(s);

  v1 := TVariable.Create('Saida', pvtObject, Integer(gOutPut), gOutPut.ClassType, True);
  v2 := TVariable.Create('Projeto', pvtObject, Integer(p), p.ClassType, True);

  if TEdit(TComponent(Sender).Tag).Name = 'edGeralUsuario' then
     begin
     v3 := TVariable.Create('FO', pvtReal, 0, nil, True);
     RunScript(g_psLib, s, gDir, nil, [v1, v2, v3], p.GlobalObjects, False);
     end
  else
     RunScript(g_psLib, s, gDir, nil, [v1, v2], p.GlobalObjects, False);
end;

end.
