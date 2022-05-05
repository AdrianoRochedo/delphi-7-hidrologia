unit pr_Dialogo_MatContrib;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  gridx32;

type
  TprDialogo_MatContrib = class(TForm)
    Matriz: TdrStringAlignGrid;
    Somatorio: TdrStringAlignGrid;
    procedure FormShow(Sender: TObject);
    procedure SomatorioTopLeftChanged(Sender: TObject);
    procedure MatrizGetEditMask(Sender: TObject; ACol, ARow: Integer;
      var Value: String);
    procedure MatrizSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure MatrizSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MatrizKeyPress(Sender: TObject; var Key: Char);
  private
    FMatrizAlterada: Boolean;
  public
    Dados: TList;
    property MatrizAlterada: Boolean read FMatrizAlterada;
  end;

var
  prDialogo_MatContrib: TprDialogo_MatContrib;

implementation
uses Math, pr_Const, pr_Tipos;

{$R *.DFM}

procedure TprDialogo_MatContrib.FormShow(Sender: TObject);
var i       : Integer;
    Tamanho : Integer;
    p       : pRecMatContrib;
begin
  Somatorio.Cells[0,0] := 'Soma';
  Somatorio.RowCount := Matriz.RowCount;

  // Calcula a largura da primeira coluna (Nomes das SunBacias)
  Tamanho := 0;
  for i := 1 to Matriz.RowCount - 1 do
    Tamanho := Max(Tamanho, Matriz.Canvas.TextWidth(Matriz.Cells[0, i]));
  Matriz.ColWidths[0] := Tamanho + 10;

  // Calcula a largura para cada coluna (Nome dos PCs)
  for i := 1 to Matriz.ColCount - 1 do
    begin
    Matriz.AlignCol [i] := alCenter;
    Matriz.ColWidths[i] := Matriz.Canvas.TextWidth(Matriz.Cells[i, 0]) + 10;
    end;

  for i := 0 to Dados.Count - 1 do
    begin
    p := pRecMatContrib(Dados[i]);
    Matriz.Cells[p.Col, p.Lin] := FloatToStr(p.Val);
    if i = 0 then
       begin
       Matriz.Col := p.Col;
       Matriz.Row := p.Lin;
       end;
    end;

  {Atualiza o somatório}
  For i := 1 to Matriz.RowCount - 1 do MatrizSetEditText(nil, -1, i, '');
end;

procedure TprDialogo_MatContrib.SomatorioTopLeftChanged(Sender: TObject);
begin
  If TdrStringGrid(Sender).Name = 'Somatorio' Then
     Matriz.TopRow := Somatorio.TopRow
  Else
     Somatorio.TopRow := Matriz.TopRow;
end;

procedure TprDialogo_MatContrib.MatrizGetEditMask(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
  If (Acol > 0) and (aRow > 1) Then
     Value := Format('0%s09;1', [DecimalSeparator]);
end;

procedure TprDialogo_MatContrib.MatrizSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var d: Extended;
    i: Integer;
begin
  //DecimalSeparator  := ','; Deixar por conta do usuário - Windows
  d := 0;
  Try
    For i := 1 to Matriz.ColCount-1 do
      If Matriz.Cells[i, aRow] <> '' Then
         d := d + StrToFloat(Matriz.Cells[i, aRow]);

    Somatorio.Cells[0, aRow] := format('%1.4f', [d]);
    If d > 1.0000001 Then Somatorio.Cells[0, aRow] := Format('Soma > 1%s0', [DecimalSeparator]);
  Except
    Somatorio.Cells[0, aRow] := 'N.Def';
  End;
end;

procedure TprDialogo_MatContrib.MatrizSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
var i: Integer;
    p: pRecMatContrib;
begin
  CanSelect := False;
  for i := 0 to Dados.Count - 1 do
    begin
    p := pRecMatContrib(Dados[i]);
    if (p.Col = ACol) and (p.Lin = ARow) then
       begin
       CanSelect := True;
       Break;
       end;
    end;
end;

procedure TprDialogo_MatContrib.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var i: Integer;
    p: pRecMatContrib;
begin
  CanClose := True;
  for i := 1 to Somatorio.RowCount-1 do
    if strToFloat(Somatorio.Cells[0, i]) <> 1 then
       begin
       CanClose := False;
       MessageDLG(Format('As contribuições da SubBacia <%s > não somam 1',
         [Matriz.Cells[0, i]]), mtError, [mbOK], 0);
       end;

  if CanClose then
     for i := 1 to Matriz.RowCount-1 do
       begin
       p := Dados[i-1];
       p.Val := strToFloat(Matriz.Cells[p.Col, p.Lin]);
       end;
end;

procedure TprDialogo_MatContrib.MatrizKeyPress(Sender: TObject; var Key: Char);
begin
  FMatrizAlterada := True;
end;

end.
          