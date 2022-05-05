unit Dialogo_Projeto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Dialogo_Base, StdCtrls, Buttons, ExtCtrls, Dialogo_Projeto_RU;

type
  TForm_Dialogo_Projeto = class(TForm_Dialogo_Base)
    btnRotinas: TButton;
    Panel10: TPanel;
    lbScripts: TListBox;
    btnAdicionarScript: TButton;
    btnRemoverScript: TButton;
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnRotinasClick(Sender: TObject);
    procedure btnAdicionarScriptClick(Sender: TObject);
    procedure btnRemoverScriptClick(Sender: TObject);
  private
    { Private declarations }
  public
    Rotinas: TForm_Dialogo_Projeto_RU;
  end;

implementation
uses FileCTRL,
     SysUtilsEx,
     MessagesForm,
     Hidro_Classes,
     Hidro_Variaveis,
     Hidro_Constantes,
     WinUtils,
     DialogUtils;

{$R *.DFM}

procedure TForm_Dialogo_Projeto.btnOkClick(Sender: TObject);
var Erro: Boolean;
begin
  Erros.Clear;
  inherited;
end;

procedure TForm_Dialogo_Projeto.FormCreate(Sender: TObject);
begin
  inherited;
  Rotinas := TForm_Dialogo_Projeto_RU.Create(self);
end;

procedure TForm_Dialogo_Projeto.FormDestroy(Sender: TObject);
begin
  Rotinas.Free;
  inherited;
end;

procedure TForm_Dialogo_Projeto.btnRotinasClick(Sender: TObject);
begin
  Rotinas.Projeto := Objeto;
  Rotinas.Show;
end;

procedure TForm_Dialogo_Projeto.btnAdicionarScriptClick(Sender: TObject);
var s: String;
begin
  if SelectFile(s, gDir, cFiltroPascalScript) then
     begin
     TProjeto(Objeto).RetirarCaminhoSePuder(s);
     if lbScripts.Items.IndexOf(s) = -1 then
        lbScripts.Items.Add(s);
     end;
end;

procedure TForm_Dialogo_Projeto.btnRemoverScriptClick(Sender: TObject);
begin
  DeleteElemFromListEx(lbScripts);
end;

end.
