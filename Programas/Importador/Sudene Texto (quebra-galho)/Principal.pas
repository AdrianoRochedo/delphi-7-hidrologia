unit Principal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Db, DBTables;

type
  Tform_Principal = class(TForm)
    Label1: TLabel;
    edArquivo: TEdit;
    SpeedButton1: TSpeedButton;
    mmPostos: TMemo;
    Label2: TLabel;
    btnImportar: TButton;
    Open: TOpenDialog;
    FTab: TTable;
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnImportarClick(Sender: TObject);
  private
    procedure Importar;
  public
    { Public declarations }
  end;

var
  form_Principal: Tform_Principal;

implementation
uses SysUtilsEx;

{$R *.DFM}

procedure Tform_Principal.SpeedButton1Click(Sender: TObject);
begin
  if open.Execute then
     edArquivo.Text := open.FileName;
end;

procedure Tform_Principal.Importar;
var Dia, Mes, Ano: Word;
    i: Integer;
    s, Posto, Postos: String;
    Dado: Real;
    dc: Char;
    Arq: TextFile;
const MissValue = -99999999;
begin
  dc := DecimalSeparator;
  DecimalSeparator := ',';
  AssignFile(Arq, edArquivo.Text);
  Reset(Arq);
  Postos := mmPostos.Text;
  try
    // Pula o cabeçalho
    ReadLn(Arq, s);

    i := 1;
    while not Eof(Arq) do
      begin
      ReadLn(Arq, s);
      inc(i);
      caption := IntToStr(i) + ' registros importados';
      if (i mod 100 = 0) then Application.ProcessMessages;

      Posto := Copy(s, 1, 7);
      if System.Pos(Posto, Postos) > 0 then
         begin
         Ano   := StrToInt(Copy(s, 22, 4));
         Mes   := StrToInt(AllTrim(Copy(s, 30, 2)));
         Dia   := StrToInt(AllTrim(Copy(s, 38, 2)));
         Dado  := StrToFloatDef(AllTrim(Copy(s, 46, 5)), MissValue);

         FTab.AppendRecord([Posto, EncodeDate(Ano, Mes, Dia), Dado]);
         end;
      end;
  finally
    CloseFile(Arq);
    DecimalSeparator := dc;
  end;
end;

Function CriaTabela(Const Nome: String; CriaCampoStatus: Boolean = False): Boolean;
Var Table1 : TTable;
begin
  Result := False;
  Table1 := TTable.Create(nil);
  try
    with Table1 do
      begin
      Active    := False;
      TableName := Nome;
      TableType := ttParadox;
      TableLevel := 7;
      with FieldDefs do
        begin
        Clear;
        Add('Posto',  ftString, 10, false);
        Add('Data' ,  ftDate ,   0, false);
        Add('Dado' ,  ftFloat,   0, false);

        if CriaCampoStatus then
           Add('Status' ,  ftSmallInt, 0, false);
        end;

      with IndexDefs do
        begin
        Clear;
        Add('', 'Posto;Data', [ixPrimary, ixUnique]);
        end;

      CreateTable;
      Result := FileExists(Nome);
      end;
  finally
    Table1.Free;
  end;
end;

procedure Tform_Principal.btnImportarClick(Sender: TObject);
var s: String;
begin
  s := ChangeFileExt(edArquivo.Text, '.DB');
  Try
    CriaTabela(s);
    FTab.Close;
    FTab.TableName := s;
    FTab.Open;
    Try
      Importar;
    Except
      On E: Exception do ShowMessage(E.Message);
    End;
  Finally
    FTab.Close;
    DeleteFile(ChangeFileExt(s, '.PX'));
    Caption := ' SUDENE (6 colunas)';
  End
end;

end.
