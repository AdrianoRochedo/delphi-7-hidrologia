unit Dialogo_Projeto_RU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TForm_Dialogo_Projeto_RU = class(TForm)
    edGeralUsuario: TEdit;
    Panel10: TPanel;
    b1: TButton;
    b11: TButton;
    btnOk: TBitBtn;
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
uses Hidro_Classes,
     Hidro_Variaveis,
     Hidro_Constantes,
     DialogUtils,
     psEditor,
     psBASE;

{$R *.DFM}

procedure TForm_Dialogo_Projeto_RU.escolherArquivo_Click(Sender: TObject);
var s: String;
    x: TEdit;
begin
  x := TEdit(TComponent(Sender).Tag);
  s := x.Text;

  if SelectFile(s, gDir, cFiltroPascalScript) then
     begin
     TProjeto(Projeto).RetirarCaminhoSePuder(s);
     x.Text := s;
     end;
end;

procedure TForm_Dialogo_Projeto_RU.Limpar_Click(Sender: TObject);
begin
  TEdit(TComponent(Sender).Tag).Text := '';
end;

procedure TForm_Dialogo_Projeto_RU.FormCreate(Sender: TObject);
begin
  b1.Tag := integer(edGeralUsuario  );  b11.Tag := b1.Tag; b111.Tag := b1.Tag;
end;

procedure TForm_Dialogo_Projeto_RU.btnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_Dialogo_Projeto_RU.editar_Click(Sender: TObject);
var s: String;
    p: TProjeto;
    v1: TVariable;
begin
  p := TProjeto(Projeto);
  s := TEdit(TComponent(Sender).Tag).Text;

  p.VerificaCaminho(s);
  v1 := TVariable.Create('Projeto', pvtObject, Integer(p), p.ClassType, True);

  RunScript(g_psLib, s, gDir, nil, [v1], p.ObjetosGlobais, False);
end;

end.
