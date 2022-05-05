unit Dados_Cenarios;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs;

type
  TDadosSenario_DLG = class(TForm)
    btnOk: TButton;
    btnCancelar: TButton;
    Label1: TLabel;
    Label2: TLabel;
    edNome: TEdit;
    edComentario: TEdit;
    Bevel1: TBevel;
    Label3: TLabel;
    edArquivo: TEdit;
    btnDir: TSpeedButton;
    Open: TOpenDialog;
    procedure btnOkClick(Sender: TObject);
    procedure btnDirClick(Sender: TObject);
    procedure edArquivoKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
uses SysUtil2, ba_Classes;

{$R *.DFM}

procedure TDadosSenario_DLG.btnOkClick(Sender: TObject);
begin
  if allTrim(edNome.Text) = '' then
     Raise Exception.Create('Por favor, preencha o campo NOME')
  else
     ModalResult := mrOk;
end;

procedure TDadosSenario_DLG.btnDirClick(Sender: TObject);
begin
  open.InitialDir := gDir;
  if open.Execute then
     begin
     gDir := ExtractFilePath(open.FileName);
     edArquivo.Text := open.FileName;
     end;
end;

procedure TDadosSenario_DLG.edArquivoKeyPress(Sender: TObject;  var Key: Char);
begin
  if Key = #8 then edArquivo.Text := '' else Key := #0;
end;

end.
