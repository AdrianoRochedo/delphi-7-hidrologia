unit Rosenbrock_FrameParMan;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Gauges, ExtCtrls;

type
  TrbFrameParMan = class(TFrame)
    paName: TPanel;
    paValue: TPanel;
    paMarca: TPanel;
    Panel4: TPanel;
    Gauge: TGauge;
    paTP: TPanel;
    procedure paNameDblClick(Sender: TObject);
  private
    FLL: Real;
    FHL: Real;
    procedure SetHiLimit(const Value: Real);
    procedure SetLowLimit(const Value: Real);
    procedure SetName(const Value: String);
    procedure SetValue(const Value: Real);
    procedure CalculateGaugeHint;
    procedure SetStatusFO(const Value: Char);
    procedure SetStepLen(const Value: Real);
    procedure SetColor(const Value: TColor);
  public
    property ParName  : String  write SetName;
    property Value    : Real    write SetValue;
    property StatusFO : Char    write SetStatusFO;
    property StepLen  : Real    write SetStepLen;
    property Color    : TColor  write SetColor;
    property LowLimit : Real    read FLL write SetLowLimit;
    property HiLimit  : Real    read FHL write SetHiLimit;
  end;

implementation
uses Rosenbrock_Class;

{$R *.dfm}

{ TrbFrameParMan }

procedure TrbFrameParMan.SetHiLimit(const Value: Real);
begin
  FHL := Value;
  Gauge.MaxValue := Trunc(Value*1000);
  CalculateGaugeHint;
end;

procedure TrbFrameParMan.SetLowLimit(const Value: Real);
begin
  FLL := Value;
  Gauge.MinValue := Trunc(Value*1000);
  CalculateGaugeHint;
end;                

procedure TrbFrameParMan.SetName(const Value: String);
begin
  paName.Caption := '   ' + Value;
end;

procedure TrbFrameParMan.SetValue(const Value: Real);
begin
  Gauge.Progress := Trunc(Value * 1000);
  paValue.Caption := FormatFloat('0.###', Value);
end;

procedure TrbFrameParMan.paNameDblClick(Sender: TObject);
var p: TrbParameter;
begin
  p := TrbParameter(Tag);
  if p.FormPar = nil then
     p.Show(100, 100)
  else
     p.FormPar.Show;
end;

procedure TrbFrameParMan.CalculateGaugeHint;
begin
  Gauge.Hint := 'Limite Inferior: ' + FormatFloat('0.###', FLL) + #13 +
                'Limite Superior: ' + FormatFloat('0.###', FHL);
end;

procedure TrbFrameParMan.SetStatusFO(const Value: Char);
begin
  paMarca.Caption := Value;
end;

procedure TrbFrameParMan.SetStepLen(const Value: Real);
begin
  paTP.Caption := FormatFloat('0.##', Value);
end;

procedure TrbFrameParMan.SetColor(const Value: TColor);
begin
  Gauge.ForeColor := Value;
end;

end.
