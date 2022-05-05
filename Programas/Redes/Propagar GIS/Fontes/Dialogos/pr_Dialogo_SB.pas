unit pr_Dialogo_SB;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pr_DialogoBase, StdCtrls, Buttons, ExtCtrls, gridx32, drEdit;

type
  TprDialogo_SB = class(TprDialogo_Base)
    Panel3: TPanel;
    Panel4: TPanel;
    edVA: TEdit;
    edArea: TdrEdit;
    btnProcurar: TSpeedButton;
    Open: TOpenDialog;
    Panel5: TPanel;
    sgCoefs: TdrStringAlignGrid;
    Panel6: TPanel;
    Sum: TEdit;
    procedure btnProcurarClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure sgCoefsKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure sgCoefsSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure FormShow(Sender: TObject);
    procedure edVAChange(Sender: TObject);
  private
    procedure CalculaSomatorio;
  public
    ArqVazModificado: Boolean;
  end;

implementation
uses pr_Funcoes, SysUtilsEx;

{$R *.DFM}

procedure TprDialogo_SB.btnProcurarClick(Sender: TObject);
begin
  inherited;
  if Open.Execute then edVA.Text := Open.FileName;
end;

procedure TprDialogo_SB.btnOkClick(Sender: TObject);
begin
  Erros.Clear;
  ValidaCoeficientes(sgCoefs.Cols[1], Erros);
  inherited;
end;

procedure TprDialogo_SB.sgCoefsKeyPress(Sender: TObject; var Key: Char);
var s: String;
begin
  // Só aceita valores Reais
  If (Key = '.') or (Key = ',') then
     begin
     Key := DecimalSeparator;
     s := sgCoefs.Cells[sgCoefs.Col, sgCoefs.Row];
     if (System.pos(Key, s) > 0) or (Length(s) = 0) then Key := #0;
     end
  else
     case Key of
       #8, '0'..'9' : {Aceita} ;
       else
         Key := #0;
       end;
end;

procedure TprDialogo_SB.FormCreate(Sender: TObject);
begin
  inherited;
  sgCoefs.Cells[0, 0] := 'PCs';
  sgCoefs.Cells[1, 0] := 'Valor';
end;

procedure TprDialogo_SB.sgCoefsSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: String);
begin
  CalculaSomatorio;
end;

procedure TprDialogo_SB.CalculaSomatorio;
var d: Extended;
    i: Integer;
begin
  d := 0;
  For i := 1 to sgCoefs.RowCount-1 do
      d := d + StrToFloatDef(sgCoefs.Cells[1, i], 0);

  Sum.Text := format('%1.4f', [d]);
  If d > 1.00000001 Then Sum.Text := Format('Soma > 1%s0', [DecimalSeparator]);
end;

procedure TprDialogo_SB.FormShow(Sender: TObject);
begin
  inherited;
  CalculaSomatorio;
end;

procedure TprDialogo_SB.edVAChange(Sender: TObject);
begin
  inherited;
  ArqVazModificado := True;
end;

end.
