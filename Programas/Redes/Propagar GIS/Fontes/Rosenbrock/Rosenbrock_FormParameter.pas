unit Rosenbrock_FormParameter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Gauges, ExtCtrls;

type
  TrbFormParameter = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label6: TLabel;
    L_Value: TLabel;
    L_LowLimit: TLabel;
    L_HiLimit: TLabel;
    L_Step: TLabel;
    L_Tolerance: TLabel;
    PL1: TPanel;
    Gauge: TGauge;
    Label16: TLabel;
    Label17: TLabel;
    Leds: TImage;
    Label9: TLabel;
    Label12: TLabel;
    L_StatusFO: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    FDono : Pointer;

    procedure SetHiLimit(const Value: Real);
    procedure SetLowLimit(const Value: Real);
    procedure SetName(const Value: String);
    procedure SetStep(const Value: Real);
    procedure SetTolerance(const Value: Real);
    procedure SetValue(const Value: Real);
    procedure SetStatusFO(const Value: Char);
    { Private declarations }
  public
    constructor Create(aOwner: Pointer);

    property ParName      : String  write SetName;
    property Value        : Real    write SetValue;
    property LowLimit     : Real    write SetLowLimit;
    property HiLimit      : Real    write SetHiLimit;
    property Step         : Real    write SetStep;
    property Tolerance    : Real    write SetTolerance;
    property StatusFO     : Char    write SetStatusFO;
  end;

implementation
uses Rosenbrock_Class;

{$R *.DFM}

{ TrbFormParameter }

constructor TrbFormParameter.Create(aOwner: Pointer);
begin
  inherited Create(nil);
  FDono := aOwner;
end;

procedure TrbFormParameter.SetHiLimit(const Value: Real);
begin
  L_HiLimit.Caption := FloatToStrF(Value, ffFixed, 10, 4);
  Gauge.MaxValue := Trunc(Value*1000);
end;

procedure TrbFormParameter.SetLowLimit(const Value: Real);
begin
  L_LowLimit.Caption := FloatToStrF(Value, ffFixed, 10, 4);
  Gauge.MinValue := Trunc(Value*1000);
end;

procedure TrbFormParameter.SetName(const Value: String);
begin
  Caption := Value;
end;

procedure TrbFormParameter.SetStep(const Value: Real);
begin
  L_Step.Caption := FloatToStrF(Value, ffFixed, 10, 4);
end;

procedure TrbFormParameter.SetTolerance(const Value: Real);
begin
  L_Tolerance.Caption := FloatToStrF(Value, ffFixed, 10, 4);
end;

procedure TrbFormParameter.SetValue(const Value: Real);
begin
  L_Value.Caption := FloatToStrF(Value, ffFixed, 10, 4);
  Gauge.Progress := Trunc(Value*1000);
end;

procedure TrbFormParameter.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  TrbParameter(FDono).FormPar := nil;
end;

procedure TrbFormParameter.SetStatusFO(const Value: Char);
begin
  L_StatusFO.Caption := Value;
end;

procedure TrbFormParameter.FormCreate(Sender: TObject);
begin
  L_StatusFO.Caption := '';
end;

end.
