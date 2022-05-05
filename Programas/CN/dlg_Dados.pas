unit dlg_Dados;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, drEdit, IniFiles;

type
  TdlgDados = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    edTit: TEdit;
    cbTB: TComboBox;
    cbUS: TComboBox;
    cbS: TComboBox;
    cbTS: TComboBox;
    edCN: TdrEdit;
    edPerc: TdrEdit;
    procedure OKBtnClick(Sender: TObject);
    procedure cbTBChange(Sender: TObject);
    procedure cbUSChange(Sender: TObject);
    procedure cbSChange(Sender: TObject);
    procedure cbTSChange(Sender: TObject);
  private
    FDirDados: String;
    FIniTB: TMemIniFile;
    slTS_Hints : TStrings;

    procedure CalcularCN;
  public
    constructor Create(const DirDados: String);
    destructor Destroy; override;
  end;

implementation
uses WinUtils;

{$R *.dfm}

procedure TdlgDados.OKBtnClick(Sender: TObject);
begin
  if edCN.Text = '' then
     raise Exception.Create('CN ainda não definido');

  ModalResult := mrOk;
end;

procedure TdlgDados.cbTBChange(Sender: TObject);
var s: String;
begin
  case cbTB.ItemIndex of
    0: s := FDirDados + 'Bacias Rurais.dat';
    1: s := FDirDados + 'Bacias Urbanas.dat';
    else
       s := FDirDados + 'Bacias Urbanas.dat';
  end; // Case

  Clear([cbS, edCN]);
  cbTS.ItemIndex := -1;

  FIniTB.Free;
  FIniTB := TMemIniFile.Create(s);
  FIniTB.ReadSections(cbUS.Items);
end;

procedure TdlgDados.cbUSChange(Sender: TObject);
var i: Integer;
begin
  if cbTB.Text = '' then
     raise Exception.Create('Primeiro escolha um tipo de Bacia');

  Clear([edCN, cbS]);
  cbTS.ItemIndex := -1;

  i := FIniTB.ReadInteger(cbUS.Text, 'Tipos', 0);
  for i := 1 to i do
    cbS.Items.Add(FIniTB.ReadString(cbUS.Text, 'T' + IntToStr(i), ''));
end;

procedure TdlgDados.cbSChange(Sender: TObject);
begin
  if cbTS.Text <> '' then
     CalcularCN;
end;

procedure TdlgDados.cbTSChange(Sender: TObject);
begin
  cbTS.Hint := slTS_Hints[cbTS.ItemIndex];
  if cbS.Text <> '' then
     CalcularCN;
end;

procedure TdlgDados.CalcularCN;
var i: Integer;
    Tipo: Char;
begin
  i := cbS.ItemIndex + 1;
  case cbTS.ItemIndex of
    0: Tipo := 'A';
    1: Tipo := 'B';
    2: Tipo := 'C';
    3: Tipo := 'D';
    end;
  edCN.Text := FIniTB.ReadString(cbUS.Text, 'T' + IntToStr(i) + '_' + Tipo, '');
end;

constructor TdlgDados.Create(const DirDados: String);
begin
  inherited Create(nil);
  FDirDados := DirDados;
  slTS_Hints := TStringList.Create;
  slTS_Hints.LoadFromFile(DirDados + 'Tipos de Solos.dat');
end;

destructor TdlgDados.Destroy;
begin
  if FIniTB <> nil then FIniTB.Free;
  slTS_Hints.Free;
  inherited;
end;

end.
