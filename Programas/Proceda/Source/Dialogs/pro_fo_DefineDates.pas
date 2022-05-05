unit pro_fo_DefineDates;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, pro_fr_Dates;

type
  TfoDefineDates = class(TForm)
    frDates: TfrDates;
    btnOk: TButton;
    btnCancel: TButton;
    Bevel1: TBevel;
  private
    constructor Create(beginDate, endDate: TDateTime);
  public
    class function getDates(var beginDate, endDate: TDateTime; out Error: string): boolean;
  end;

implementation

{$R *.dfm}

{ TfoDefineDates }

constructor TfoDefineDates.Create(beginDate, endDate: TDateTime);
begin
  inherited Create(nil);
  frDates.edDI.Text := DateToStr(beginDate);
  frDates.edDF.Text := DateToStr(endDate);
end;

class function TfoDefineDates.getDates(var beginDate, endDate: TDateTime; out Error: string): boolean;
var d: TfoDefineDates;
    di, df: TDateTime;
begin
  di := beginDate;
  df := endDate;
  d := TfoDefineDates.Create(beginDate, endDate);
  result := (d.ShowModal = mrOK);
  Error := '';
  if result then
     begin
     beginDate := StrToDateDef(d.frDates.edDI.Text, -1);
     endDate := StrToDateDef(d.frDates.edDF.Text, -1);
     result := (beginDate <> -1) and (endDate <> -1) and (beginDate >= di) and (endDate <= df);
     if not result then Error := 'Intervalo inválido';
     end;
  d.Free();   
end;

end.
