unit cd_Form_Simular;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cd_Classes, StdCtrls, ExtCtrls, CheckLst, Buttons, gridx32, FileCtrl,
  cd_Form_Simular_DadosGerais;

type
  TfoSimular = class(TForm)
    btnOk: TButton;
    m: TMemo;
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
    Panel6: TPanel;
    Panel7: TPanel;
    edA: TEdit;
    Panel8: TPanel;
    edPasta: TEdit;
    Panel12: TPanel;
    clMan: TCheckListBox;
    clRes: TCheckListBox;
    btnAddMan: TButton;
    btnRemMan: TButton;
    btnAddRes: TButton;
    btnRemRes: TButton;
    Open: TOpenDialog;
    Panel13: TPanel;
    Panel14: TPanel;
    btnTransferir: TButton;
    btnDG: TButton;
    procedure btnOkClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure Arquivo_Click(Sender: TObject);
    procedure btnAddManClick(Sender: TObject);
    procedure btnRemManClick(Sender: TObject);
    procedure btnAddResClick(Sender: TObject);
    procedure btnRemResClick(Sender: TObject);
    procedure ClickCheck(Sender: TObject);
    procedure btnTransferirClick(Sender: TObject);
    procedure btnDGClick(Sender: TObject);
  private
    FCenario: TLavoura;
    procedure SelecionarArquivo(L: TCheckListBox; Ext: string);
    procedure RemoverArquivo(L: TCheckListBox);
  public
    DLG_InfoGerais: TfoSimular_DadosGerais;

    constructor Create(Cenario: TLavoura);
    destructor Destroy; override;

    function getChecked(L: TCheckListBox; var Ind: Integer): string;
  end;

var
  foSimular: TfoSimular;

implementation
uses SysUtilsEx,
     cd_Form_TransferirDados;

{$R *.dfm}

{ TfoSimular }

const
  Exts : array[1..5] of string = ('cul', 'sol', 'pre', 'et0', 'asc');

constructor TfoSimular.Create(Cenario: TLavoura);
begin
  inherited Create(nil);
  FCenario := Cenario;
  DLG_InfoGerais := TfoSimular_DadosGerais.Create(nil);
end;


procedure TfoSimular.btnOkClick(Sender: TObject);
begin
  m.Clear();
  m.Lines.Add('Simulando ...');

  FCenario.PegarDadosDoDialogo(self);
  FCenario.ExecutarIsareg();

  m.Lines.Clear();
  if FCenario.TemErros then
     begin
     m.Lines.Add('Erros:');
     FCenario.MostrarErros(m.Lines);
     end
  else
     begin
     m.Lines.Add('A simulação gerou novos dados.');
     end;
end;

procedure TfoSimular.btnFecharClick(Sender: TObject);
begin
  Close();
end;

procedure TfoSimular.Arquivo_Click(Sender: TObject);
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

procedure TfoSimular.btnAddManClick(Sender: TObject);
begin
  SelecionarArquivo(clMan, 'esq');
end;

procedure TfoSimular.btnRemManClick(Sender: TObject);
begin
  RemoverArquivo(clMan);
end;

procedure TfoSimular.btnAddResClick(Sender: TObject);
begin
  SelecionarArquivo(clRes, 'res');
end;

procedure TfoSimular.btnRemResClick(Sender: TObject);
begin
  RemoverArquivo(clRes);
end;

procedure TfoSimular.RemoverArquivo(L: TCheckListBox);
begin
  L.DeleteSelected();
end;

procedure TfoSimular.SelecionarArquivo(L: TCheckListBox; Ext: string);
begin
  Open.InitialDir := edPasta.Text;
  Open.DefaultExt := Ext;
  Open.Filter := Format('Arquivos %s|*.%s', [UpperCase(Ext), Ext]);
  if Open.Execute() then
     L.Items.Add(ExtractRelativePath(edPasta.Text, Open.FileName));
end;

procedure TfoSimular.ClickCheck(Sender: TObject);
var c: TCheckListBox;
    i: Integer;
begin
  c := TCheckListBox(Sender);
  for i := 0 to c.Items.Count-1 do
    c.Checked[i] := false;
  c.Checked[c.ItemIndex] := true;
end;

function TfoSimular.getChecked(L: TCheckListBox; var Ind: Integer): string;
var i: Integer;
begin
  Ind := -1;
  Result := '';
  for i := 0 to L.Items.Count-1 do
    if L.Checked[i] then
       begin
       Result := L.Items[i];
       Ind := i;
       Break;
       end;
end;

procedure TfoSimular.btnTransferirClick(Sender: TObject);
var d: TfoTransferirDados;
begin
  d := TfoTransferirDados.Create(FCenario);
  d.ShowModal();
  d.Free();
end;

destructor TfoSimular.Destroy;
begin
  DLG_InfoGerais.Free();
  inherited;
end;

procedure TfoSimular.btnDGClick(Sender: TObject);
begin
  DLG_InfoGerais.ShowModal();
end;

end.
