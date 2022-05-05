unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, DB, DBTables;

type
  TfoMain = class(TForm)
    Label1: TLabel;
    edNome: TEdit;
    btnNome: TSpeedButton;
    L1: TLabel;
    PB: TProgressBar;
    Info: TLabel;
    btnConverter: TButton;
    T: TTable;
    procedure btnNomeClick(Sender: TObject);
    procedure btnConverterClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  foMain: TfoMain;

implementation
uses DialogUtils,
     wsConstTypes,
     wsVec,
     wsMatrix;

{$R *.dfm}

procedure TfoMain.btnNomeClick(Sender: TObject);
var s: String;
begin
  if DialogUtils.SelectFile(s, '', 'Arquivos Chuvaz|*.DB') then
     edNome.Text := s;
end;

procedure TfoMain.btnConverterClick(Sender: TObject);
var d, d1, d2: TDateTime;
    Postos: TStringList;
    s, s1: string;
    ds: TwsDataset;
    i, i1, i2: integer;
    v: TwsVec;
    aa, mm, dd: word;
    c2, c3, c4: TwsQualitative;
    x: real;
begin
  T.Close;
  T.TableName := edNome.Text;
  T.Open;

  Postos := TStringList.Create();

  Info.Caption := 'Analizando arquivo ...';
  Application.ProcessMessages();

  // Obtem o intervalo maximo e os postos existentes
  PB.Min := 1;
  PB.Max := T.RecordCount;
  s1 := '';
  d1 := 999999999999999;
  d2 := 0;
  while not T.Eof do
    begin
    s := T.Fields[0].AsString;
    d := T.Fields[1].AsDateTime;
    if d < d1 then d1 := d;
    if d > d2 then d2 := d;
    if s <> s1 then begin s1 := s; Postos.Add(s); end;
    PB.Position := T.RecNo;
    T.Next();
    end;

  Info.Caption := 'Criando arquivo de destino ...';
  Application.ProcessMessages();

  ds := TwsDataset.Create('Proceda');

  ds.Struct.AddNumeric('DataAgregada', '');

  ds.Struct.AddQualitative('Dia', '');
  c2 := TwsQualitative(ds.Struct.Col[2]);
  for i := 1 to 31 do c2.AddLevel(intToStr(i));

  ds.Struct.AddQualitative('Mes', '');
  c3 := TwsQualitative(ds.Struct.Col[3]);
  for i := 1 to 12 do c3.AddLevel(intToStr(i));

  ds.Struct.AddQualitative('Ano', '');
  c4 := TwsQualitative(ds.Struct.Col[4]);
  DecodeDate(d1, aa, mm, dd); i1 := aa;
  DecodeDate(d2, aa, mm, dd); i2 := aa;
  for i := i1 to i2 do c4.AddLevel(intToStr(i));

  for i := 0 to Postos.Count-1 do
    ds.Struct.AddNumeric(Postos[i], '');

  PB.Max := Trunc(d2);
  PB.Min := Trunc(d1);

  d := d1;
  while d <= d2 do
    begin
    DecodeDate(d, aa, mm, dd);
    v := ds.AddRow('');
    v[1] := d;
    v[2] := dd;
    v[3] := mm;
    v[4] := c4.LevelToIndex(intToStr(aa));
    d := d + 1 {dia};
    PB.Position := Trunc(d);
    end;

  Info.Caption := 'Convertendo arquivo ...';
  Application.ProcessMessages();

  // Copia os dados para o Dataset
  PB.Min := 1;
  PB.Max := T.RecordCount;
  T.First();
  while not T.Eof do
    begin
    s := T.Fields[0].AsString;
    d := T.Fields[1].AsDateTime;
    x := T.Fields[2].AsFloat;
    if x < -999999 then x := wscMissValue;
    ds[Trunc(d - d1 + 1), Postos.IndexOf(s) + 5] := x;
    PB.Position := T.RecNo;
    T.Next();
    end;

  Postos.Free();
  ds.SaveToFile(ChangeFileExt(T.TableName, '.proceda'));

  PB.Position := 1;
  Info.Caption := 'Progresso da Operação:';

  ds.Free();
  T.Close();
end;

end.
