unit pr_Dialogo_Demanda_TVU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, gridx32, drEdit,
  pr_Const,
  pr_Tipos;

type
  TprDialogo_TVU = class(TForm)
    btnOk: TBitBtn;
    btnCancelar: TBitBtn;
    Tab: TdrStringAlignGrid;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    AnoInicial: TdrEdit;
    Label2: TLabel;
    AnoFinal: TdrEdit;
    Label3: TLabel;
    Valor: TdrEdit;
    btnAdicionar: TButton;
    btnRemover: TButton;
    btnImportar: TButton;
    GroupBox2: TGroupBox;
    btnSelecao: TBitBtn;
    btnEdicao: TBitBtn;
    Open: TOpenDialog;
    procedure FormShow(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure TabKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure btnSelecaoClick(Sender: TObject);
    procedure btnEdicaoClick(Sender: TObject);
    procedure TabClick(Sender: TObject);
    procedure TabKeyPress(Sender: TObject; var Key: Char);
    procedure btnImportarClick(Sender: TObject);
  private
    Cap: String;
    FProjeto: TObject;
  public
    Tipo: TEnumTipoDialogo;

    function  VerificarIntervalos(out Pos: Integer): Boolean;
    procedure VerificarIntervalo;
    procedure Obter(out Dados: TaRecVU);
    procedure Atribuir(const Dados: TaRecVU; AnoIni, AnoFim: Integer);
    procedure AdicionarDados; Virtual;
    procedure PegarValor(LI: Integer); Virtual;

    property Projeto: TObject read FProjeto write FProjeto;
  end;

implementation
uses SysUtilsEx,
     Demand_Requirements;

{$R *.DFM}

procedure TprDialogo_TVU.FormShow(Sender: TObject);
var C: Integer;
begin
  Caption := Cap + ' [Edição]';

  if Tipo = tdDemanda then
     begin
     AnoInicial.Enabled := False;
     AnoFinal.Enabled := False;
     btnImportar.Enabled := False;
     end
  else
     btnImportar.Enabled := True;

  for C := 1 to 12 do
    Tab.Cells[C, 0] := ShortMonthNames[C];
end;

procedure TprDialogo_TVU.VerificarIntervalo;
begin
  if AnoInicial.AsInteger > AnoFinal.AsInteger then
     begin
     ActiveControl := AnoInicial;
     Raise Exception.Create('Ano inicial maior que o Ano final');
     end;
end;

procedure TprDialogo_TVU.btnAdicionarClick(Sender: TObject);
begin
  if Tipo = tdClasseDemanda then
     begin
     VerificarIntervalo();
     AdicionarDados();
     end
  else
     if (Tab.Row > 0) then PegarValor(Tab.Row);
end;

procedure TprDialogo_TVU.btnRemoverClick(Sender: TObject);
begin
  if Tab.RowCount = 2 then
     begin
     Tab.Cells[0, 1] := '';
     Tab.Clear(False);
     end
  else
     Tab.RemoveRows(Tab.Row, 1);
end;

procedure TprDialogo_TVU.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TprDialogo_TVU.btnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TprDialogo_TVU.AdicionarDados;
var LI, i, Pos: Integer;
begin
  if VerificarIntervalos(Pos) then
     begin
     if Pos = Tab.RowCount then Tab.RowCount := Tab.RowCount + 1
     else if (Pos = 1) and (Tab.Cells[0, 1] = '') then {nada}
     else Tab.InsertRows(Pos, 1);

     PegarValor(Pos);
     Tab.Cells[0, Pos] := Format('%d - %d',
              [AnoInicial.AsInteger, AnoFinal.AsInteger]);
     end
  else
     Raise Exception.Create('Intervalo inteiro ou parte dele já está definido !');
end;

procedure TprDialogo_TVU.PegarValor(LI: Integer);
var C: Integer;
begin
  for C := 1 to 12 do Tab.Cells[C, LI] := Valor.AsString;
end;

procedure TprDialogo_TVU.TabKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ssCtrl in Shift then
     Case UpCase(char(Key)) of
       'C': Tab.Copy;
       'V': Tab.Paste;
       'A': btnSelecaoClick(nil);
       'E': btnEdicaoClick(nil);
     end;
end;

procedure TprDialogo_TVU.FormCreate(Sender: TObject);
begin
  Tipo := tdClasseDemanda;
  Cap := Caption;
  Tab.options := Tab.options + [goEditing];
  Tab.FocusColor := clHighlight;
  Tab.FocusTextColor := clHighlightText;
end;

procedure TprDialogo_TVU.Atribuir(const Dados: TaRecVU; AnoIni, AnoFim: Integer);
var i,j: Integer;
begin
  AnoInicial.AsInteger := AnoIni;
  AnoFinal.AsInteger   := AnoFim;

  if Length(Dados) > 0 then
     begin
     Tab.RowCount := Length(Dados) + 1;
     for i := 1 to Tab.RowCount-1 do
       begin
       if Dados[i-1].AnoIni <> Dados[i-1].AnoFim then
          Tab.Cells[0, i] := Format('%d - %d', [Dados[i-1].AnoIni, Dados[i-1].AnoFim])
       else
          Tab.Cells[0, i] := IntToStr(Dados[i-1].AnoIni);

       for j := 1 to 12 do Tab.Cells[j, i] :=
         FloatToStr(Dados[i-1].Mes[j]);
       end;
     end;   
end;

procedure TprDialogo_TVU.Obter(out Dados: TaRecVU);
var i, j: Integer;
    s1, s2: String;
begin
  if Tab.Cells[0, 1] = '' then
     SetLength(Dados, 0)
  else
     begin
     SetLength(Dados, Tab.RowCount-1);
     for i := 1 to Tab.RowCount-1 do
       begin
       if SubStrings('-', s1, s2, Tab.Cells[0, i], true) > 0 then
          begin
          Dados[i-1].AnoIni := strToInt(s1);
          Dados[i-1].AnoFim := strToInt(s2);
          end
       else
          begin
          Dados[i-1].AnoIni := strToInt(Tab.Cells[0, i]);
          Dados[i-1].AnoFim := Dados[i-1].AnoIni;
          end;

       for j := 1 to 12 do // <<<<< "INF" equivale a 0 aqui
         Dados[i-1].Mes[j] := StrToFloatDef(Tab.Cells[j, i], 0);
       end;
     end;
end;

function TprDialogo_TVU.VerificarIntervalos(out Pos: Integer): Boolean;
var k, i, ii: Integer;
    s1, s2: String;
begin
  Result := True;
  Pos := 1;
  if Tab.Cells[0, 1] = '' then Exit;
  for k := 1 to Tab.RowCount-1 do
    begin
    SubStrings('-', s1, s2, Tab.Cells[0, k], true);
    i := strToInt(s1);
    ii := strToInt(s2);
    if ((AnoInicial.AsInteger >= i) and (AnoInicial.AsInteger <= ii)) or
       ((AnoFinal  .AsInteger >= i) and (AnoFinal  .AsInteger <= ii)) then
       begin
       Result := False;
       Exit;
       end;
    if AnoInicial.AsInteger < ii then
       begin
       Pos := k;
       Exit;
       end
    else
       Pos := k + 1;
    end;
end;

procedure TprDialogo_TVU.btnSelecaoClick(Sender: TObject);
begin
  Caption := Cap + ' [Seleção]';
  Tab.Options := Tab.Options - [goEditing];
end;

procedure TprDialogo_TVU.btnEdicaoClick(Sender: TObject);
begin
  Caption := Cap + ' [Edição]';
  Tab.Options := Tab.Options + [goEditing];
end;

procedure TprDialogo_TVU.TabClick(Sender: TObject);
var s1, s2: String;
begin
  if (Tipo = tdDemanda) and (Tab.Row > 0) and (Tab.Col > 0) then
     begin
     SubStrings('-', s1, s2, Tab.Cells[0, Tab.Row], true);
     AnoInicial.AsString := s1;
     AnoFinal.AsString   := s2;
     end;
end;

procedure TprDialogo_TVU.TabKeyPress(Sender: TObject; var Key: Char);
var s: String;
begin
  // Só aceita valores Reais
  If (Key = '.') or (Key = ',') then
     begin
     Key := DecimalSeparator;
     s := Tab.Cells[Tab.Col, Tab.Row];
     if (System.pos(Key, s) > 0) or (Length(s) = 0) then Key := #0;
     end
  else
     case Key of
       #8, '0'..'9' : {Aceita} ;
       else
         Key := #0;
       end;
end;

procedure TprDialogo_TVU.btnImportarClick(Sender: TObject);
var r: TDemandRequirements;
    ano, mes: Integer;
begin
  if Open.Execute then
     begin
     r := TDemandRequirements.Create(Open.FileName);

     // Visual da grade
     Tab.RowCount := r.Years + 1;
     Tab.Clear(true);
     for mes := 1 to 12 do
       Tab.Cells[mes, 0] := ShortMonthNames[mes];

     // Dados das demandas
     for ano := 1 to r.Years do
       begin
       Tab.Cells[0, ano] := r.YearAsString[ano];
       for mes := 1 to 12 do
         Tab.Cells[mes, ano] := FormatFloat('0.######', r.Requirement[ano, mes]);
       end;
       
     r.Free;
     end;

end;

end.
