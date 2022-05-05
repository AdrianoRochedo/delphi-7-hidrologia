unit pr_Dialogo_Demanda_TUD;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pr_Dialogo_Demanda_TVU, StdCtrls, gridx32, Buttons,
  pr_Const, pr_Tipos, drEdit;

type
  TprDialogo_TUD = class(TprDialogo_TVU)
    procedure FormShow(Sender: TObject);
  private
    procedure PegarValor(LI: Integer); Override;
  public
    procedure Obtem(out Dados: TaRecUD);
    procedure Atribui(const Dados: TaRecUD; AnoIni, AnoFim: Integer);
  end;

implementation
uses SysUtilsEx;

{$R *.DFM}

{ TDLG_TUD }

procedure TprDialogo_TUD.PegarValor(LI: Integer);
begin
  Tab.Cells[1, LI] := AllTrim(Valor.AsString);
end;

procedure TprDialogo_TUD.FormShow(Sender: TObject);
begin
  Tab.Cells[1,0] := ' Unidades de demanda';
end;

procedure TprDialogo_TUD.Atribui(const Dados: TaRecUD; AnoIni, AnoFim: Integer);
var i: Integer;
begin
  AnoInicial.AsInteger := AnoIni;
  AnoFinal.AsInteger   := AnoFim;

  if Length(Dados) = 0 then exit;
  Tab.RowCount := Length(Dados) + 1;
  for i := 1 to Tab.RowCount-1 do
    begin
    Tab.Cells[0, i] := Format('%d - %d', [Dados[i-1].AnoIni, Dados[i-1].AnoFim]);
    Tab.Cells[1, i] := FloatToStr(Dados[i-1].Unidade);
    end;
end;

procedure TprDialogo_TUD.Obtem(out Dados: TaRecUD);
var i: Integer;
    s1, s2: String;
begin
  if Tab.Cells[0, 1] = '' then
     SetLength(Dados, 0)
  else
     begin
     SetLength(Dados, Tab.RowCount-1);
     for i := 1 to Tab.RowCount-1 do
       begin
       SubStrings('-', s1, s2, Tab.Cells[0, i], true);
       Dados[i-1].AnoIni := strToInt(s1);
       Dados[i-1].AnoFim := strToInt(s2);
       Dados[i-1].Unidade := strToFloat(Tab.Cells[1, i]);
       end;
     end;  
end;

end.
