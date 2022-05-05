unit pro_fr_getValidIntervals;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, pro_Const, pro_Classes, pro_Procs;

type
  TFrame_getValidIntervals = class(TFrame)
    lbPeriodos: TListBox;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label4: TLabel;
    meDI: TMaskEdit;
    meDF: TMaskEdit;
    Label3: TLabel;
    edPostos: TEdit;
    procedure lbPeriodosClick(Sender: TObject);
  private
    FPeriodos: TListaDePeriodos;
    FInfo: TDSInfo;
    function getIntervalo: String;
    procedure setIntervalo(const Value: String);
  public
    procedure Mostrar(Info: TDSInfo);
    procedure ValidarDatas;
    procedure ObtemDatas(out DI, DF: TDateTime);
    procedure ObtemIndiceDasDatas(out LI, LF: Integer);
    property  IntervaloComoString : String read getIntervalo write setIntervalo;
  end;

implementation
uses SysUtilsEx, WinUtils;

{$R *.DFM}

{ TFrame_PeriodosValidos }

procedure TFrame_getValidIntervals.Mostrar(Info: TDSInfo);
var s: String;
    i: Integer;
begin
  FInfo := Info;
  if FPeriodos <> nil then FPeriodos.Free;
  FPeriodos := ObtemPeriodos(FInfo, True);
  lbPeriodos.Clear;
  for i := 0 to FPeriodos.NumPeriodos-1 do
    begin
    s := DateToStr(FPeriodos[i].DI) + ' - ' + DateToStr(FPeriodos[i].DF);
    lbPeriodos.Items.Add(s);
    end;
end;

procedure TFrame_getValidIntervals.lbPeriodosClick(Sender: TObject);
var i: Integer;
begin
  i := lbPeriodos.ItemIndex;
  meDI.Text := DateToStr(FPeriodos[i].DI);
  meDF.Text := DateToStr(FPeriodos[i].DF);
  edPostos.Text := SetToPostos(FPeriodos[i].Postos, FInfo);
end;

procedure TFrame_getValidIntervals.ValidarDatas;
var DI, DF: TDateTime;
begin
  if not validaData(meDI.Text, DI) then
     ShowErrorAndGoto(['Data inicial inválida'], meDI);

  if not validaData(meDF.Text, DF) then
     ShowErrorAndGoto(['Data final inválida'], meDF);

  if DI > DF then
     ShowErrorAndGoto(['Data inicial maior que a data final'], meDI);

  if DI < FInfo.DataInicial then
     ShowErrorAndGoto(['Data inicial menor que o limite mínimo permitido'], meDI);

  if DF > FInfo.DataFinal then
     ShowErrorAndGoto(['Data final maior que o limite máximo permitido'], meDF);
end;

function TFrame_getValidIntervals.getIntervalo: String;
begin
  Result := meDI.Text + ' - ' + meDF.Text;
end;

procedure TFrame_getValidIntervals.setIntervalo(const Value: String);
var s1, s2: String;
begin
  SubStrings('-', s1, s2, Value);
  meDI.Text := AllTrim(s1);
  meDF.Text := AllTrim(s2);
  edPostos.Text := '';
  lbPeriodos.ItemIndex := -1;
end;

procedure TFrame_getValidIntervals.ObtemDatas(out DI, DF: TDateTime);
begin
  DI := StrToDate(meDI.Text);
  DF := StrToDate(meDF.Text);
end;

procedure TFrame_getValidIntervals.ObtemIndiceDasDatas(out LI, LF: Integer);
begin
  LI := FInfo.IndiceDaData(meDI.Text);
  LF := FInfo.IndiceDaData(meDF.Text);
end;

end.
