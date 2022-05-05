unit cd_Form_EstimativasEconomicas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cd_Frame_Sensibilidade, ExtCtrls, drEdit, ComCtrls,
  cd_Classes;

type
  TfoEstimativasEconomicas = class(TForm)
    Book: TPageControl;
    TabSheet6: TTabSheet;
    c_BY: TdrEdit;
    Panel48: TPanel;
    c_CA: TdrEdit;
    Panel49: TPanel;
    c_NI: TdrEdit;
    Panel51: TPanel;
    Panel68: TPanel;
    c_FCost: TdrEdit;
    Panel74: TPanel;
    c_VCost: TdrEdit;
    Panel75: TPanel;
    Panel76: TPanel;
    c_T: TdrEdit;
    Panel77: TPanel;
    TabSheet7: TTabSheet;
    s_FR: TdrEdit;
    Panel53: TPanel;
    s_PH: TdrEdit;
    Panel54: TPanel;
    s_PE: TdrEdit;
    Panel55: TPanel;
    s_Life: TdrEdit;
    Panel56: TPanel;
    Panel67: TPanel;
    s_ICost: TdrEdit;
    Panel69: TPanel;
    s_MCost: TdrEdit;
    Panel70: TPanel;
    Panel71: TPanel;
    s_TCost: TdrEdit;
    Panel72: TPanel;
    s_RV: TdrEdit;
    Panel73: TPanel;
    TabSheet8: TTabSheet;
    o_WP: TdrEdit;
    Panel58: TPanel;
    o_EP: TdrEdit;
    Panel59: TPanel;
    Panel61: TPanel;
    o_P: TdrEdit;
    Panel62: TPanel;
    o_CH: TdrEdit;
    Panel63: TPanel;
    Panel66: TPanel;
    Panel44: TPanel;
    btnFechar: TButton;
    s_IR: TdrEdit;
    Panel65: TPanel;
    s_SE: TdrEdit;
    Panel1: TPanel;
    procedure btnFecharClick(Sender: TObject);
    procedure CustoTotalIrrigacao_Change(Sender: TObject);
    procedure CustoTotalDoSistema_Change(Sender: TObject);
  private
    FC: TCrop;
  public
    constructor Create(C: TCrop);
  end;

implementation

{$R *.dfm}

{ TfoEstimativasEconomicas }

constructor TfoEstimativasEconomicas.Create(C: TCrop);
begin
  inherited Create(nil);
  FC := C;

  //c_CL.AsFloat := FC.CustoLav;
  //c_PP .AsFloat  := FC.c_PP ;

  c_BY    .AsFloat := FC.BaseYield          ;
  c_NI    .AsFloat := FC.NetIncome          ;
  c_CA    .AsFloat := FC.CultivatedArea     ;
  c_FCost .AsFloat := FC.FixedCost          ;
  c_VCost .AsFloat := FC.VariableCost       ;

  s_FR    .AsFloat := FC.Sys_FlowRate       ;
  s_PH    .AsFloat := FC.Sys_PressureHead   ;
  s_SE    .AsFloat := FC.Sys_Efficiency     ;
  s_PE    .AsFloat := FC.Sys_PumpEffic      ;
  s_Life  .AsFloat := FC.Sys_Life           ;
  s_ICost .AsFloat := FC.Sys_IrrInstCost    ;
  s_MCost .AsFloat := FC.Sys_IrrMainCost    ;
  s_RV    .AsFloat := FC.Sys_IrrResVal      ;
  s_IR    .AsFloat := FC.Sys_AnualIR        ;

  o_WP    .AsFloat := FC.WaterPrice         ;
  o_EP    .AsFloat := FC.EnergyPrice        ;
  o_P     .AsFloat := FC.Labor_Persons      ;
  o_CH    .AsFloat := FC.Labor_CostHourly   ;
end;

procedure TfoEstimativasEconomicas.btnFecharClick(Sender: TObject);
begin
  FC.BaseYield          := c_BY    .AsFloat ;
  FC.NetIncome          := c_NI    .AsFloat ;
  FC.CultivatedArea     := c_CA    .AsFloat ;
  FC.FixedCost          := c_FCost .AsFloat ;
  FC.VariableCost       := c_VCost .AsFloat ;

  FC.Sys_FlowRate       := s_FR    .AsFloat ;
  FC.Sys_PressureHead   := s_PH    .AsFloat ;
  FC.Sys_Efficiency     := s_SE    .AsFloat ;
  FC.Sys_PumpEffic      := s_PE    .AsFloat ;
  FC.Sys_Life           := s_Life  .AsFloat ;
  FC.Sys_IrrInstCost    := s_ICost .AsFloat ;
  FC.Sys_IrrMainCost    := s_MCost .AsFloat ;
  FC.Sys_IrrResVal      := s_RV    .AsFloat ;
  FC.Sys_AnualIR        := s_IR    .AsFloat ;

  FC.WaterPrice         := o_WP    .AsFloat ;
  FC.EnergyPrice        := o_EP    .AsFloat ;
  FC.Labor_Persons      := o_P     .AsFloat ;
  FC.Labor_CostHourly   := o_CH    .AsFloat ;

  Close;
end;

procedure TfoEstimativasEconomicas.CustoTotalIrrigacao_Change(Sender: TObject);
begin
  c_T.AsFloat := c_FCost.AsFloat + c_VCost.AsFloat;
end;

procedure TfoEstimativasEconomicas.CustoTotalDoSistema_Change(Sender: TObject);
begin
  s_TCost.AsFloat := s_ICost.AsFloat + s_MCost.AsFloat;
end;

end.
