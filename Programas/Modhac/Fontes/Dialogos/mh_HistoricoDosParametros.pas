unit mh_HistoricoDosParametros;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, Gridx32, StdCtrls, Menus, Buttons,
  mh_TCs, SpreadSheetBook_Frame;

type
  TDLG_Historico = class(TForm)
    PanelInfo: TPanel;
    p: TSpreadSheetBookFrame;
    procedure FormCreate(Sender: TObject);
    procedure GMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PanelInfoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Menu_FecharClick(Sender: TObject);
  private
    FColIndex: integer;
    FDados: pTDadosDaBacia;
    FFO_MQ: integer;
    FFO_MD: integer;
    FFO_VA: integer;
    FFO_LG: integer;
  public
    Procedure AddCol(Col: TStrings; FO: byte);
    property Dados: pTDadosDaBacia read FDados write FDados;
  end;

implementation
uses mh_Classes;

{$R *.DFM}

procedure TDLG_Historico.FormCreate(Sender: TObject);
var L: integer;
begin
  FColIndex := 1;
  L := 1;

  p.ActiveSheet.Write(L, 1, 'Parâmetros');      inc(L, 2);
  p.ActiveSheet.Write(L, 1, 'RSPX');            inc(L);
  p.ActiveSheet.Write(L, 1, 'RSSX');            inc(L);
  p.ActiveSheet.Write(L, 1, 'RSBX');            inc(L);
  p.ActiveSheet.Write(L, 1, 'RSBY');            inc(L);
  p.ActiveSheet.Write(L, 1, 'IMAX');            inc(L);
  p.ActiveSheet.Write(L, 1, 'IMIN');            inc(L);
  p.ActiveSheet.Write(L, 1, 'IDEC');            inc(L);
  p.ActiveSheet.Write(L, 1, 'ASP');             inc(L);
  p.ActiveSheet.Write(L, 1, 'ASS');             inc(L);
  p.ActiveSheet.Write(L, 1, 'ASBX');            inc(L);
  p.ActiveSheet.Write(L, 1, 'ASBY');            inc(L);
  p.ActiveSheet.Write(L, 1, 'PRED');            inc(L);
  p.ActiveSheet.Write(L, 1, 'CEVA');            inc(L);
  p.ActiveSheet.Write(L, 1, 'CHET');            inc(L, 2);

  p.ActiveSheet.Write(L, 1, 'Vz Tot Obs');      inc(L);
  p.ActiveSheet.Write(L, 1, 'Vz Tot Calc');     inc(L);
  p.ActiveSheet.Write(L, 1, 'Vz Tot Obs %');    inc(L);
  p.ActiveSheet.Write(L, 1, 'Vz Tot Cal %');    inc(L, 2);

  p.ActiveSheet.Write(L, 1, 'FO MQ'); FFO_MQ := L; inc(L);
  p.ActiveSheet.Write(L, 1, 'FO MD'); FFO_MD := L; inc(L);
  p.ActiveSheet.Write(L, 1, 'FO VA'); FFO_VA := L; inc(L);
  p.ActiveSheet.Write(L, 1, 'FO LG'); FFO_LG := L;

  p.ActiveSheet.BoldCol(1);
end;

procedure TDLG_Historico.AddCol(Col: TStrings; FO: byte);
var i: Integer;
    s: string;
    r: real;
begin
  // Vai para a proxima coluna
  inc(FColIndex);

  // Escreve os valores
  p.ActiveSheet.WriteCenter(1, FColIndex, true, Col[0]);
  for i := 1 to Col.Count-1 do
    begin
    r := StrToFloatDef(Col[i], -999);
    if r <> -999 then
       p.ActiveSheet.Write(i+2, FColIndex, r, 8);
    end;

  // Destaca em azul a funcao objetivo
  case FO of
    1: i := FFO_MQ;
    2: i := FFO_MD;
    3: i := FFO_VA;
    4: i := FFO_LG;
    end;
  if FO > 0 then p.ActiveSheet.SetCellColor(i, FColIndex, clBLUE);
end;

procedure TDLG_Historico.GMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var P        : TPoint;
    Col, Row : Longint;
begin
// {TODO 1 -cProgramacao: GMouseMove}
{
  GetCursorPos(P);
  P := ScreenToClient(P);
  G.MouseToCell(P.X, P.Y, Col, Row);
  If Row > 0 Then
     PanelInfo.Caption := ' ' + ParamNames[Row] + ': ' + ParamHints[Row]
  Else
     PanelInfo.Caption := '';
}
end;

procedure TDLG_Historico.PanelInfoMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  PanelInfo.Caption := '';
end;

procedure TDLG_Historico.Menu_FecharClick(Sender: TObject);
begin
  Close;
end;

end.

