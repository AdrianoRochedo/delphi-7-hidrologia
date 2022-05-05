unit Rosenbrock_FormFO;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, TeeProcs, TeEngine, Chart, Series, Buttons;

type
  TrbFormFO = class(TForm)
    Grafico: TChart;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    FDono : Pointer;
    procedure setFO(const Value: Real);
  public
    constructor Create(aOwner: Pointer);
    procedure Clear;
    property FO : Real write setFO;
  end;

var
  rbFormFO: TrbFormFO;

implementation
uses Rosenbrock_class;

{$R *.DFM}

{ TrbForm }

constructor TrbFormFO.Create(aOwner: Pointer);
begin
  inherited Create(nil);
  FDono := aOwner;
  Grafico.AddSeries(TFastLineSeries.Create(self));
end;

procedure TrbFormFO.setFO(const Value: Real);
begin
  With Grafico.Series[0] do
    begin
    if Count > 50 then Delete(0);
    AddY(Value, '', clTeeColor);
    Self.Caption := ' Valores da Função Objetico     FO = ' + FloatToStr(Value);
    RePaint;
    end;
end;

procedure TrbFormFO.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  TRosenbrock(FDono).FormFO := nil;
end;

procedure TrbFormFO.FormShow(Sender: TObject);
begin
  Grafico.Series[0].Clear;
  RePaint;
end;

procedure TrbFormFO.Clear;
begin
  Grafico.Series[0].Clear;
end;

end.
