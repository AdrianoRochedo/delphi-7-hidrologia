unit cd_Form_Dados;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cd_Classes, StdCtrls, ExtCtrls, CheckLst, Buttons, gridx32, FileCtrl,
  cd_Form_DadosGerais;

type
  TfoDados = class(TForm)
    btnFechar: TButton;
    sb2: TSpeedButton;
    sb3: TSpeedButton;
    sb4: TSpeedButton;
    sb5: TSpeedButton;
    sb6: TSpeedButton;
    edC: TEdit;
    Panel2: TPanel;
    edS: TEdit;
    Panel3: TPanel;
    edP: TEdit;
    Panel4: TPanel;
    edE: TEdit;
    Panel5: TPanel;
    edA: TEdit;
    Panel8: TPanel;
    edPasta: TEdit;
    Panel12: TPanel;
    Panel13: TPanel;
    btnTransferir: TButton;
    btnDG: TButton;
    Open: TOpenDialog;
    procedure btnFecharClick(Sender: TObject);
    procedure Arquivo_Click(Sender: TObject);
    procedure btnTransferirClick(Sender: TObject);
    procedure btnDGClick(Sender: TObject);
  private
    FCenario: TLavoura;
    procedure SelecionarArquivo(L: TCheckListBox; Ext: string);
  public
    DLG_InfoGerais: TfoDadosGerais;

    constructor Create(Cenario: TLavoura);
    destructor Destroy; override;
  end;

var
  foDados: TfoDados;

implementation
uses SysUtilsEx,
     cd_Form_TransferirDados;

{$R *.dfm}

{ TfoSimular }

const
  Exts : array[1..5] of string = ('cul', 'sol', 'pre', 'et0', 'asc');

constructor TfoDados.Create(Cenario: TLavoura);
begin
  inherited Create(nil);
  FCenario := Cenario;
  DLG_InfoGerais := TfoDadosGerais.Create(nil);
end;

procedure TfoDados.btnFecharClick(Sender: TObject);
begin
  Close();
end;

procedure TfoDados.Arquivo_Click(Sender: TObject);
var s: string;
begin
  s := Exts[TSpeedButton(Sender).Tag];
  Open.InitialDir := edPasta.Text;
  Open.DefaultExt := s;
  Open.Filter := Format('Arquivos %s|*.%s', [UpperCase(s), s]);
  if Open.Execute() then
     begin
     s := ExtractRelativePath(edPasta.Text, Open.FileName);
     case TSpeedButton(Sender).Tag of
       1: edC.Text := s;
       2: edS.Text := s;
       3: edP.Text := s;
       4: edE.Text := s;
       5: edA.Text := s;
       end;
     end;
end;

procedure TfoDados.SelecionarArquivo(L: TCheckListBox; Ext: string);
begin
  Open.InitialDir := edPasta.Text;
  Open.DefaultExt := Ext;
  Open.Filter := Format('Arquivos %s|*.%s', [UpperCase(Ext), Ext]);
  if Open.Execute() then
     L.Items.Add(ExtractRelativePath(edPasta.Text, Open.FileName));
end;

procedure TfoDados.btnTransferirClick(Sender: TObject);
var d: TfoTransferirDados;
begin
  d := TfoTransferirDados.Create(FCenario);
  d.ShowModal();
  d.Free();
end;

destructor TfoDados.Destroy;
begin
  DLG_InfoGerais.Free();
  inherited;
end;

procedure TfoDados.btnDGClick(Sender: TObject);
begin
  DLG_InfoGerais.ShowModal();
end;

end.
