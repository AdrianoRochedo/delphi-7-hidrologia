unit cd_MolduraDosDados;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, CheckLst, FileCtrl, gridx32;

type
  TMoldura = class(TFrame)
    edC: TEdit;
    Panel1: TPanel;
    sb2: TSpeedButton;
    edS: TEdit;
    Panel2: TPanel;
    sb3: TSpeedButton;
    edP: TEdit;
    Panel3: TPanel;
    sb4: TSpeedButton;
    edE: TEdit;
    Panel4: TPanel;
    sb5: TSpeedButton;
    Panel5: TPanel;
    Panel6: TPanel;
    edA: TEdit;
    Panel7: TPanel;
    sb6: TSpeedButton;
    sb1: TSpeedButton;
    edPasta: TEdit;
    Panel8: TPanel;
    edAnos: TEdit;
    Panel9: TPanel;
    clMan: TCheckListBox;
    clRes: TCheckListBox;
    btnAddMan: TButton;
    btnRemMan: TButton;
    btnAddRes: TButton;
    btnRemRes: TButton;
    Open: TOpenDialog;
    Panel10: TPanel;
    sgRC: TdrStringAlignGrid;
    procedure sb1Click(Sender: TObject);
    procedure Arquivos_Click(Sender: TObject);
    procedure btnAddManClick(Sender: TObject);
    procedure btnAddResClick(Sender: TObject);
    procedure btnRemManClick(Sender: TObject);
    procedure btnRemResClick(Sender: TObject);
    procedure ClickCheck(Sender: TObject);
    procedure edAnosExit(Sender: TObject);
  private
    procedure SelecionarArquivo(L: TCheckListBox; Ext: string);
    procedure RemoverArquivo(L: TCheckListBox);
  public
    function getChecked(L: TCheckListBox; var Ind: Integer): string;
  end;

implementation
uses SysUtilsEx;

{$R *.dfm}

const
  Exts : array[1..5] of string = ('cul', 'sol', 'pre', 'et0', 'asc');

procedure TMoldura.sb1Click(Sender: TObject);
var dir: string;
begin
  if SelectDirectory('Selecione uma Pasta', '', dir) then
     edPasta.Text := dir;
end;

procedure TMoldura.Arquivos_Click(Sender: TObject);
var s: string;
begin
  s := Exts[TSpeedButton(Sender).Tag];
  Open.InitialDir := edPasta.Text;
  Open.DefaultExt := s;
  Open.Filter := Format('Arquivos %s|*.%s', [UpperCase(s), s]);
  if Open.Execute() then
     begin
     s := ExtractFileName(Open.FileName);
     case TSpeedButton(Sender).Tag of
       1: edC.Text := s;
       2: edS.Text := s;
       3: edP.Text := s;
       4: edE.Text := s;
       5: edA.Text := s;
       end;
     end;
end;

procedure TMoldura.SelecionarArquivo(L: TCheckListBox; Ext: string);
begin
  Open.InitialDir := edPasta.Text;
  Open.DefaultExt := Ext;
  Open.Filter := Format('Arquivos %s|*.%s', [UpperCase(Ext), Ext]);
  if Open.Execute() then
     L.Items.Add(ExtractFileName(Open.FileName));
end;

procedure TMoldura.btnAddManClick(Sender: TObject);
begin
  SelecionarArquivo(clMan, 'esq');
end;

procedure TMoldura.btnAddResClick(Sender: TObject);
begin
  SelecionarArquivo(clRes, 'res');
end;

procedure TMoldura.btnRemManClick(Sender: TObject);
begin
  RemoverArquivo(clMan);
end;

procedure TMoldura.btnRemResClick(Sender: TObject);
begin
  RemoverArquivo(clRes);
end;

procedure TMoldura.RemoverArquivo(L: TCheckListBox);
begin
  L.DeleteSelected();
end;

// deixa somente um ativo
procedure TMoldura.ClickCheck(Sender: TObject);
var c: TCheckListBox;
    i: Integer;
begin
  c := TCheckListBox(Sender);
  for i := 0 to c.Items.Count-1 do
    c.Checked[i] := false;
  c.Checked[c.ItemIndex] := true;
end;

function TMoldura.getChecked(L: TCheckListBox; var Ind: Integer): string;
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

procedure TMoldura.edAnosExit(Sender: TObject);
var s1, s2: string;
    i1, i2, k: integer;
begin
  if System.Pos('-', edAnos.Text) > 0 then
     begin
     SysUtilsEx.SubStrings('-', s1, s2, edAnos.Text, true);
     i1 := strToIntDef(s1, -1);
     i2 := strToIntDef(s2, -1);
     if (i1 <> -1) and (i2 <> -1) and (i2 >= i1) then
        begin
        sgRC.ColCount := i2 - i1 + 1;
        for k := 0 to sgRC.ColCount-1 do
          sgRC.Cells[k, 0] := toString(i1 + k);
        end;
     end
  else
     begin
     sgRC.ColCount := 1;
     sgRC.Cells[0, 0] := edAnos.Text;
     end;
end;

end.
