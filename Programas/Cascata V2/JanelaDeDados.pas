unit JanelaDeDados;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, gridx32, Buttons;

type
  TcaDialogo_Acudes = class(TForm)
    Painel: TPanel;
    Scroll: TScrollBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    GroupBox1: TGroupBox;
    sgTitulos: TdrStringAlignGrid;
    sgCoefCorr: TdrStringAlignGrid;
    sgArqVaz: TdrStringAlignGrid;
    btnAV: TSpeedButton;
    sgArqChu: TdrStringAlignGrid;
    btnAC: TSpeedButton;
    sgMes_VazMin: TdrStringAlignGrid;
    sgMes_CoefDesc: TdrStringAlignGrid;
    sgMes_PercRetDescarga: TdrStringAlignGrid;
    sgCoefCorrEvap: TdrStringAlignGrid;
    sgMes_ValEvapLago: TdrStringAlignGrid;
    Label12: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    sgDA_AMax: TdrStringAlignGrid;
    sgDA_AMin: TdrStringAlignGrid;
    sgDA_AIni: TdrStringAlignGrid;
    sgDA_PercVMin: TdrStringAlignGrid;
    sgDA_TF: TdrStringAlignGrid;
    sgDA_TPF: TdrStringAlignGrid;
    sgDA_NMCR: TdrStringAlignGrid;
    GroupBox2: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Label21: TLabel;
    sgFR_NumPontos: TdrStringAlignGrid;
    sgFR_ParKD: TdrStringAlignGrid;
    sgFR_NumPol: TdrStringAlignGrid;
    sgFR_GrauPol: TdrStringAlignGrid;
    GroupBox3: TGroupBox;
    Label24: TLabel;
    Label25: TLabel;
    sgAASL_PercErro: TdrStringAlignGrid;
    sgAASL_NumMaxIter: TdrStringAlignGrid;
    FileOpen: TOpenDialog;
    sgAtivos: TdrStringAlignGrid;
    Label11: TLabel;
    GroupBox4: TGroupBox;
    sgGrauPol: TdrStringAlignGrid;
    sgCoefsPol: TdrStringAlignGrid;
    Label10: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Grades_KeyPress(Sender: TObject; var Key: Char);
    procedure btnClick(Sender: TObject);
    procedure sgGrauPol_KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sgFR_NumPol_KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgTitulosSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure sgAtivosKeyPress(Sender: TObject; var Key: Char);
    procedure sgAtivosTopLeftChanged(Sender: TObject);
    procedure sgTitulosTopLeftChanged(Sender: TObject);
    procedure sgAtivosDblClick(Sender: TObject);
  private
    FNumAcudes: Word;
    procedure setNumAcudes(const Value: Word);
  public
    property NumAcudes: Word read FNumAcudes write setNumAcudes;
  end;

var
  caDialogo_Acudes: TcaDialogo_Acudes;

implementation
uses SysUtilsEx;

{$R *.DFM}

procedure TcaDialogo_Acudes.FormCreate(Sender: TObject);
begin
  if Screen.Width > 550 then
     begin
     Top    := -2;
     Left   := 262;
     Height := Screen.Height - 22;
     end
  else
     begin
     Top    := 16;
     Left   := 0;
     Height := Screen.Height - 42;
     end;

  {$IFDEF DEBUG}
  NumAcudes := 3;
  {$ELSE}
  NumAcudes := 1;
  {$ENDIF}
end;

// Somente valores reais s?o permitidos
procedure TcaDialogo_Acudes.Grades_KeyPress(Sender: TObject; var Key: Char);
var g: TdrStringAlignGrid;

  function GradesDeInteiros: Boolean;
  begin
    Result := (g.Name = 'sgGrauPol')      or
              (g.Name = 'sgDA_NMCR')      or
              (g.Name = 'sgFR_NumPontos') or
              (g.Name = 'sgFR_ParKD')     or
              (g.Name = 'sgFR_NumPol')    or
              (g.Name = 'sgFR_GrauPol')   or
              (g.Name = 'sgAASL_NumMaxIter');
  end;

begin
  g := TdrStringAlignGrid(Sender);

  case Key of
    '.', ',' :
    if not GradesDeInteiros then
       begin
       Key := DecimalSeparator;
       if System.Pos(Key, g.Cells[g.Col, g.Row]) > 0 then Key := #0;
       end
    else
       Key := #0;

    '0'..'9', #8, #13, '-': {nada};

    else
      Key := #0;
    end;
end;

procedure TcaDialogo_Acudes.btnClick(Sender: TObject);
var g: TdrStringAlignGrid;
begin
  if TComponent(Sender).Name = 'btnAV' then g := sgArqVaz else g := sgArqChu;
  if FileOpen.Execute then
     g.Cells[1, g.Row] := FileOpen.FileName;
end;

procedure TcaDialogo_Acudes.sgGrauPol_KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var i, k, x: Integer;
    g1, g2 : TdrStringAlignGrid;
begin
  g1 := sgGrauPol;
  g2 := sgCoefsPol;

  k := 1;
  for i := 0 to NumAcudes - 1 do
    begin
    try
      x := strToInt(g1.Cells[1, i + byte(g1.Tag > 0)]);
    except
      x := 1;
      g1.Cells[1, i + byte(g1.Tag > 0)] := 'Erro';
      end;

    if x > k then k := x;
    end;

  g2.FixedRows := 1;
  g2.ColCount := k + 1;
  for i := 0 to k do
    begin
    g2.ColWidths[i] := 70;
    g2.Cells[i, 0] := 'Grau ' + intToStr(i + 1);
    end;
end;

procedure TcaDialogo_Acudes.setNumAcudes(const Value: Word);
var i: Integer;
    j: Integer;
    g: TdrStringAlignGrid;
begin
  FNumAcudes := Value;
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TdrStringAlignGrid then
       begin
       g := TdrStringAlignGrid(Components[i]);

       g.RowCount := FNumAcudes + byte((g.Tag = 1) or (g.Name = 'sgFR_NumPol') or
                                       (g.Name = 'sgCoefsPol') or (g.Name = 'sgFR_GrauPol'));

       if g.Tag < 2 then
          for j := 0 to FNumAcudes-1 do
            g.Cells[0, g.Tag + j] := ' ' + intToStr(j + 1);

       if System.Copy(g.Name, 1, 5) = 'sgMes' then
          begin
          g.FixedRows := 1;
          for j := 1 to 12 do
            g.Cells[j, 0] := ' ' + ShortMonthNames[j];
          end;
       end; // for i
end;

procedure TcaDialogo_Acudes.sgFR_NumPol_KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var i, k, x: Integer;
    g1, g2 : TdrStringAlignGrid;
begin
  g1 := sgFR_NumPol;
  g2 := sgFR_GrauPol;

  k := 1;
  for i := 0 to NumAcudes - 1 do
    begin
    try
      x := strToInt(g1.Cells[1, i + byte(g1.Tag > 0)]);
    except
      x := 1;
      g1.Cells[1, i + byte(g1.Tag > 0)] := 'Erro';
      end;

    if x > k then k := x;
    end;

  g2.FixedRows := 1;
  g2.ColCount := k;
  for i := 0 to k-1 do
    begin
    g2.ColWidths[i] := 50;
    g2.Cells[i, 0] := 'Grau ' + IntToStr(i + 1);
    end;
end;

procedure TcaDialogo_Acudes.sgTitulosSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: String);
var c: TdrStringAlignGrid;
begin
  c := TdrStringAlignGrid(Sender);
  c.Cells[aCol, aRow] := allTrim(c.Cells[aCol, aRow]);
end;

procedure TcaDialogo_Acudes.sgAtivosKeyPress(Sender: TObject; var Key: Char);
begin
  Key := upCase(Key);
  case Key of
    #32, 'X' : sgAtivos.Cells[1, sgAtivos.Row] := Key;
    else       Key := #0;
  end
end;

procedure TcaDialogo_Acudes.sgAtivosTopLeftChanged(Sender: TObject);
begin
  sgTitulos.TopRow := sgAtivos.TopRow;
end;

procedure TcaDialogo_Acudes.sgTitulosTopLeftChanged(Sender: TObject);
begin
  sgAtivos.TopRow := sgTitulos.TopRow;
end;

procedure TcaDialogo_Acudes.sgAtivosDblClick(Sender: TObject);
var L: Integer;
begin
  L := sgAtivos.Row;
  if sgAtivos.Cells[1, L] <> 'X' then
     sgAtivos.Cells[1, L] := 'X'
  else
     sgAtivos.Cells[1, L] := '';
end;

end.
