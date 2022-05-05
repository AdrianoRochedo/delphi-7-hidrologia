unit iphs1_Dialogo_TD;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  iphs1_Dialogo_Base, StdCtrls, Buttons, ExtCtrls, iphs1_Tipos, drEdit, Menus,

  // Diálogos auxiliares: Métodos de Propagação de Escoamento
  iphs1_Dialogo_TD_MPE_Base,
  iphs1_Dialogo_TD_MPE_CL,
  iphs1_Dialogo_TD_MPE_CNL,
  iphs1_Dialogo_TD_MPE_CPI,
  iphs1_Dialogo_TD_MPE_XK,
  iphs1_Dialogo_TD_MPE_MCCF;

type
  Tiphs1_Form_Dialogo_TD = class(Tiphs1_Form_Dialogo_Base)
    paMPE: TPanel;
    Panel10: TPanel;
    rbKX: TRadioButton;
    rbCL: TRadioButton;
    rbCNL: TRadioButton;
    rbCPI: TRadioButton;
    sbCPI: TSpeedButton;
    sbCNL: TSpeedButton;
    sbKX: TSpeedButton;
    sbCL: TSpeedButton;
    sbCF: TSpeedButton;
    rbCF: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbKXClick(Sender: TObject);
    procedure sbCLClick(Sender: TObject);
    procedure sbCNLClick(Sender: TObject);
    procedure sbCPIClick(Sender: TObject);
    procedure MPE_Click(Sender: TObject);
    procedure sbCFClick(Sender: TObject);
  private
    FCTP  : Real;    // Comprimento do Trecho
    FCFM  : Real;    // Cota de fundo de montante
    FCFJ  : Real;    // Cota de fundo de jusante
    FAC   : Real;    // Altura do canal
    FLC   : Real;    // Largura do canal
    FRST  : Real;    // Rugosidade dos Sub-Trechos
    FVR   : Real;    // Vazão de Ref.
    FNST  : Integer; // Número de Sub-trechos
    FITC  : Integer; // Intervalo de tempo de Cálculo

    FVR_auto  : Boolean; // Vazão de Ref. automática
    FNST_auto : Boolean; // Número de Sub-trechos automático
    FITC_auto : Boolean; // Intervalo de tempo de Cálculo automático

    // Planicie de Inundação (Base)
    FAPI  : Real; // Altura da Planicie de Inundação
    FLPI  : Real; // Largura da Planicie de Inundação

    // Tabelas
    FNPT_KX : Integer;
    FTab_KX : TTab3D;

    procedure SetDadosComuns(Dialogo: Tiphs1_Form_Dialogo_TD_MPE_Base);
    procedure GetDadosComuns(Dialogo: Tiphs1_Form_Dialogo_TD_MPE_Base);
  public
    DLG_MPE_CL  : Tiphs1_Form_Dialogo_TD_MPE_CL;
    DLG_MPE_CNL : Tiphs1_Form_Dialogo_TD_MPE_CNL;
    DLG_MPE_CPI : Tiphs1_Form_Dialogo_TD_MPE_CPI;
    DLG_MPE_KX  : Tiphs1_Form_Dialogo_TD_MPE_XK;
    DLG_MPE_CF  : Tiphs1_Form_Dialogo_TD_MPE_MCCF;

    procedure GetDados(var CTP, CFM, CFJ, AC, LC, RST, VR, API, LPI: Real;
                       var VR_auto, NST_auto, ITC_auto: Boolean;
                       var ITC, NST, NPT_KX: Integer;
                       var Tab_KX: TTab3D);

    procedure SetDados(const CTP, CFM, CFJ, AC, LC, RST, VR, API, LPI: Real;
                       const VR_auto, NST_auto, ITC_auto: Boolean;
                       const ITC, NST, NPT_KX: Integer;
                       const Tab_KX: TTab3D);
  end;

implementation

{$R *.DFM}

procedure Tiphs1_Form_Dialogo_TD.FormCreate(Sender: TObject);
begin
  inherited;
  FTab_KX := TTab3D.Create(0);
  DLG_MPE_CL  := Tiphs1_Form_Dialogo_TD_MPE_CL.Create(self);
  DLG_MPE_CNL := Tiphs1_Form_Dialogo_TD_MPE_CNL.Create(self);
  DLG_MPE_CPI := Tiphs1_Form_Dialogo_TD_MPE_CPI.Create(self);
  DLG_MPE_KX  := Tiphs1_Form_Dialogo_TD_MPE_XK.Create(self);
  DLG_MPE_CF  := Tiphs1_Form_Dialogo_TD_MPE_MCCF.Create(self);
end;


procedure Tiphs1_Form_Dialogo_TD.FormDestroy(Sender: TObject);
begin
  FTab_KX.Free;
  DLG_MPE_CL.Free;
  DLG_MPE_CNL.Free;
  DLG_MPE_CPI.Free;
  DLG_MPE_KX.Free;
  DLG_MPE_CF.Free;
  inherited;
end;

procedure Tiphs1_Form_Dialogo_TD.sbKXClick(Sender: TObject);
var i: Integer;
begin
  inherited;
  DLG_MPE_KX.edCFM.AsFloat := FCFM;
  DLG_MPE_KX.edCFJ.AsFloat := FCFJ;
  DLG_MPE_KX.edAC.AsFloat  := FAC;

  DLG_MPE_KX.edNPT.AsInteger := FNPT_KX;

  if FNPT_KX > 0 then
     begin
     DLG_MPE_KX.Tab.MaxRow := FNPT_KX;
     FTab_KX.Len := FNPT_KX;
     for i := 1 to FNPT_KX do
       begin
       DLG_MPE_KX.Tab.NumberRC[i, 1] := FTab_KX[i-1].x;
       DLG_MPE_KX.Tab.NumberRC[i, 2] := FTab_KX[i-1].y;
       DLG_MPE_KX.Tab.NumberRC[i, 3] := FTab_KX[i-1].z;
       end;
     end;

  if DLG_MPE_KX.ShowModal = mrOK then
    begin
    FCFM := DLG_MPE_KX.edCFM.AsFloat;
    FCFJ := DLG_MPE_KX.edCFJ.AsFloat;
    FAC  := DLG_MPE_KX.edAC.AsFloat;

    FNPT_KX := DLG_MPE_KX.edNPT.AsInteger;

    if FNPT_KX > 0 then
       begin
       FTab_KX.Len := FNPT_KX;
       for i := 1 to FNPT_KX do
         begin
         FTab_KX[i-1].x := DLG_MPE_KX.Tab.NumberRC[i, 1];
         FTab_KX[i-1].y := DLG_MPE_KX.Tab.NumberRC[i, 2];
         FTab_KX[i-1].z := DLG_MPE_KX.Tab.NumberRC[i, 3];
         end;
       end;
    end;
end;

procedure Tiphs1_Form_Dialogo_TD.sbCLClick(Sender: TObject);
begin
  inherited;
  SetDadosComuns(DLG_MPE_CL);
  if DLG_MPE_CL.ShowModal = mrOK then
     GetDadosComuns(DLG_MPE_CL);
end;

procedure Tiphs1_Form_Dialogo_TD.sbCNLClick(Sender: TObject);
begin
  inherited;
  SetDadosComuns(DLG_MPE_CNL);

  // 2.062
  DLG_MPE_CNL.cbNST.Checked := false;
  DLG_MPE_CNL.cbITC.Checked := false;

  if DLG_MPE_CNL.ShowModal = mrOK then
     GetDadosComuns(DLG_MPE_CNL);
end;

procedure Tiphs1_Form_Dialogo_TD.sbCPIClick(Sender: TObject);
begin
  inherited;
  DLG_MPE_CPI.edAPI.AsFloat := FAPI;
  DLG_MPE_CPI.edLPI.AsFloat := FLPI;
  SetDadosComuns(DLG_MPE_CPI);
  if DLG_MPE_CPI.ShowModal = mrOK then
     begin
     GetDadosComuns(DLG_MPE_CPI);
     FAPI := DLG_MPE_CPI.edAPI.AsFloat;
     FLPI := DLG_MPE_CPI.edLPI.AsFloat;
     end;
end;

procedure Tiphs1_Form_Dialogo_TD.SetDados(const CTP, CFM, CFJ, AC, LC, RST, VR, API, LPI: Real;
                                          const VR_auto, NST_auto, ITC_auto: Boolean;
                                          const ITC, NST, NPT_KX: Integer;
                                          const Tab_KX: TTab3D);
begin
  FCTP      := CTP;
  FCFM      := CFM;
  FCFJ      := CFJ;
  FAC       := AC;
  FLC       := LC;
  FRST      := RST;
  FVR       := VR;
  FNST      := NST;
  FITC      := ITC;
  FVR_auto  := VR_auto;
  FNST_auto := NST_auto;
  FITC_auto := ITC_auto;
  FAPI      := API;
  FLPI      := LPI;

  FNPT_KX := NPT_KX;
  FTab_KX.Assign(Tab_KX);
end;

procedure Tiphs1_Form_Dialogo_TD.GetDados(var CTP, CFM, CFJ, AC, LC, RST, VR, API, LPI: Real;
                                          var VR_auto, NST_auto, ITC_auto: Boolean;
                                          var ITC, NST, NPT_KX: Integer;
                                          var Tab_KX: TTab3D);
begin
  CTP      := FCTP;
  CFM      := FCFM;
  CFJ      := FCFJ;
  AC       := FAC;
  LC       := FLC;
  RST      := FRST;
  VR       := FVR;
  NST      := FNST;
  ITC      := FITC;
  VR_auto  := FVR_auto;
  NST_auto := FNST_auto;
  ITC_auto := FITC_auto;
  API      := FAPI;
  LPI      := FLPI;

  NPT_KX := FNPT_KX;
  Tab_KX.Assign(FTab_KX);
end;

procedure Tiphs1_Form_Dialogo_TD.SetDadosComuns(Dialogo: Tiphs1_Form_Dialogo_TD_MPE_Base);
begin
  with Dialogo do
    begin
    edCTP.AsFloat  := FCTP;
    edCFM.AsFloat  := FCFM;
    edCFJ.AsFloat  := FCFJ;
    edAC.AsFloat   := FAC;
    edLC.AsFloat   := FLC;
    edRST.AsFloat  := FRST;
    edVR.AsFloat   := FVR;

    edNST.AsInteger := FNST;
    edITC.AsInteger := FITC;

    cbVR.Checked   := FVR_auto;
    cbNST.Checked  := FNST_auto;
    cbITC.Checked  := FITC_auto;
    end;
end;

procedure Tiphs1_Form_Dialogo_TD.GetDadosComuns(Dialogo: Tiphs1_Form_Dialogo_TD_MPE_Base);
begin
  with Dialogo do
    begin
    FCTP := edCTP.AsFloat;
    FCFM := edCFM.AsFloat;
    FCFJ := edCFJ.AsFloat;
    FAC  := edAC.AsFloat;
    FLC  := edLC.AsFloat;
    FRST := edRST.AsFloat;
    FVR  := edVR.AsFloat;

    FNST := edNST.AsInteger;
    FITC := edITC.AsInteger;

    FVR_auto  := cbVR.Checked;
    FNST_auto := cbNST.Checked;
    FITC_auto := cbITC.Checked;

    if rbCNL.Checked then // 2.062
       begin
       FNST_auto := false;
       FITC_auto := false;
       end;
    end;
end;

procedure Tiphs1_Form_Dialogo_TD.MPE_Click(Sender: TObject);
begin
  sbKX.Enabled  := rbKX.Checked;
  sbCL.Enabled  := rbCL.Checked;
  sbCNL.Enabled := rbCNL.Checked;
  sbCPI.Enabled := rbCPI.Checked;
  sbCF.Enabled  := rbCF.Checked;
end;

procedure Tiphs1_Form_Dialogo_TD.sbCFClick(Sender: TObject);
begin
  // por dados
  if DLG_MPE_CF.ShowModal = mrOK then
     // pegar dados
end;

end.
