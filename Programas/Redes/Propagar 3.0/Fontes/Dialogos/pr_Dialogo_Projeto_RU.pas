unit pr_Dialogo_Projeto_RU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TprDialogo_Projeto_RU = class(TForm)
    edPlanejaUsuario: TEdit;
    Panel101: TPanel;
    b2: TButton;
    b22: TButton;
    edGeralUsuario: TEdit;
    Panel10: TPanel;
    b1: TButton;
    b11: TButton;
    edOperaUsuario: TEdit;
    Panel2: TPanel;
    b4: TButton;
    b44: TButton;
    edEnergiaUsuario: TEdit;
    Panel12: TPanel;
    b5: TButton;
    b55: TButton;
    btnOk: TBitBtn;
    b555: TButton;
    b444: TButton;
    b222: TButton;
    b111: TButton;
    procedure escolherArquivo_Click(Sender: TObject);
    procedure Limpar_Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure editar_Click(Sender: TObject);
  private
    { Private declarations }
  public
    Projeto: TObject;
  end;

implementation
uses OutPut,
     pr_Application,
     pr_Classes,
     pr_Const,
     pr_Tipos,
     pr_Vars,
     DialogUtils,
     psEditor,
     psBASE;

{$R *.DFM}

procedure TprDialogo_Projeto_RU.escolherArquivo_Click(Sender: TObject);
var s: String;
    x: TEdit;
begin
  x := TEdit(TComponent(Sender).Tag);
  s := x.Text;

  if SelectFile(s, Applic.LastDir, cFiltroPascalScript) then
     begin
     TprProjeto(Projeto).RetiraCaminhoSePuder(s);
     x.Text := s;
     end;
end;

procedure TprDialogo_Projeto_RU.Limpar_Click(Sender: TObject);
begin
  TEdit(TComponent(Sender).Tag).Text := '';
end;

procedure TprDialogo_Projeto_RU.FormCreate(Sender: TObject);
begin
  b1.Tag := integer(edGeralUsuario  );  b11.Tag := b1.Tag; b111.Tag := b1.Tag;
  b2.Tag := integer(edPlanejaUsuario);  b22.Tag := b2.Tag; b222.Tag := b2.Tag;
  //b3.Tag := integer(edRacionaUsuario);  b33.Tag := b3.Tag; b333.Tag := b3.Tag;
  b4.Tag := integer(edOperaUsuario  );  b44.Tag := b4.Tag; b444.Tag := b4.Tag;
  b5.Tag := integer(edEnergiaUsuario);  b55.Tag := b5.Tag; b555.Tag := b5.Tag;
end;

procedure TprDialogo_Projeto_RU.btnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TprDialogo_Projeto_RU.editar_Click(Sender: TObject);
var s: String;
    p: TprProjeto;
    v: TVariable;
begin
  p := TprProjeto(Projeto);
  s := TEdit(TComponent(Sender).Tag).Text;
  p.VerificaCaminho(s);
  v := TVariable.Create('Projeto', pvtObject, Integer(p), p.ClassType, True);
  RunScript(g_psLib, s, Applic.LastDir, nil, [v], p.GlobalObjects, False);
end;

end.
