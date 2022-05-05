unit iphs1_Dialogo_SB_TCV_Calculo_TC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, drEdit, ExtCtrls;

type
  Tfoiphs1_Dialogo_SB_TCV_Calculo_TC = class(TForm)
    btnOK: TButton;
    btnCancelar: TButton;
    Label1: TLabel;
    rbKirpch: TRadioButton;
    L1: TLabel;
    Label2: TLabel;
    edK_C: TdrEdit;
    edK_D: TdrEdit;
    Bevel1: TBevel;
    Bevel2: TBevel;
    L_Res: TLabel;
    procedure Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FTC: Real;
    function Calcular: Real;
  public
    // O resultado é fornecido em minutos
    property TempoDeConcentracao: Real read FTC;
  end;

implementation
uses Math;

{$R *.dfm}

function Tfoiphs1_Dialogo_SB_TCV_Calculo_TC.Calcular: Real;
var L, H: Real;
begin
  if rbKirpch.Checked then
     begin
     L := StrToFloat(edK_C.AsString);
     H := StrToFloat(edK_D.AsString);
     Result := 57 * Power(Power(L, 3) / H, 0.385);
     end;
end;

procedure Tfoiphs1_Dialogo_SB_TCV_Calculo_TC.Change(Sender: TObject);
begin
  try
    FTC := Calcular;
    L_Res.Caption := 'Resultado:  ' + FloatToStr(FTC);
  except
    FTC := -1;
    L_Res.Caption := 'Resultado:  Não Calculado';
  end;
end;

procedure Tfoiphs1_Dialogo_SB_TCV_Calculo_TC.FormCreate(Sender: TObject);
begin
  FTC := -1;
end;

end.
