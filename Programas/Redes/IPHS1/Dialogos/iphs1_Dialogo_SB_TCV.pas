unit iphs1_Dialogo_SB_TCV;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AxCtrls, OleCtrls, vcf1, StdCtrls, CheckLst, ExtCtrls, Buttons,
  iphs1_Classes, gridx32, drEdit;

type
  Tiphs1_Form_Dialogo_SB_TCV = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel_Tormenta: TPanel;
    rbNR: TRadioButton;                                                         
    rbR: TRadioButton;
    sbReordenada: TSpeedButton;
    Panel4: TPanel;
    Panel_SE: TPanel;
    sbIPHII: TSpeedButton;
    rbIPHII: TRadioButton;
    sbSCS: TSpeedButton;
    rbSCS: TRadioButton;
    sbHec: TSpeedButton;
    rbHec: TRadioButton;
    sbFI: TSpeedButton;
    rbFI: TRadioButton;
    sbHOLTAN: TSpeedButton;
    rbHOLTAN: TRadioButton;
    Panel6: TPanel;
    Panel_ES: TPanel;
    sbHU: TSpeedButton;
    sbHT: TSpeedButton;
    sbHYMO: TSpeedButton;
    sbCLARK: TSpeedButton;
    rbHU: TRadioButton;
    rbHT: TRadioButton;
    rbHYMO: TRadioButton;
    rbCLARK: TRadioButton;
    Panel_EB: TPanel;
    rbPEB_S: TRadioButton;
    rbPEB_N: TRadioButton;
    sbPEB_S: TSpeedButton;
    Panel_Impressao: TPanel;
    btnCancelar: TBitBtn;
    Panel_Tab: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    BitBtn1: TBitBtn;
    TabPostos: TdrCheckBoxGrid;
    cbIR: TCheckBox;
    edAB: TdrEdit;
    edTC: TdrEdit;
    btnCalcularTC: TButton;
    procedure sbIPHIIClick(Sender: TObject);
    procedure sbSCSClick(Sender: TObject);
    procedure sbHecClick(Sender: TObject);
    procedure sbFIClick(Sender: TObject);
    procedure sbHOLTANClick(Sender: TObject);
    procedure sbHUClick(Sender: TObject);
    procedure sbHTClick(Sender: TObject);
    procedure sbHYMOClick(Sender: TObject);
    procedure sbCLARKClick(Sender: TObject);
    procedure sbPEB_SClick(Sender: TObject);
    procedure sbReordenadaClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SE_Click(Sender: TObject);
    procedure ES_Click(Sender: TObject);
    procedure edTCxChange(Sender: TObject);
    procedure rbPEB_Click(Sender: TObject);
    procedure btnCalcularTCClick(Sender: TObject);
    procedure rbRClick(Sender: TObject);
    procedure TabPostosKeyPress(Sender: TObject; var Key: Char);
    procedure edTCExit(Sender: TObject);
  private
    FAjustar: Boolean;
    FSB: Tiphs1_SubBacia;
    procedure AjustarES;
    procedure AjustarSE;
  public
    property SubBacia : Tiphs1_SubBacia read FSB write FSB;
  end;

implementation
uses WinUtils,
     SysUtilsEx,
     iphs1_Tipos,
     iphs1_Dialogo_SB_TCV_Calculo_TC,
     iphs1_Dialogo_SB_TCV_IPHII,
     iphs1_Dialogo_SB_TCV_SCS,
     iphs1_Dialogo_SB_TCV_HEC,
     iphs1_Dialogo_SB_TCV_FI,
     iphs1_Dialogo_SB_TCV_HOLTAN,
     iphs1_Dialogo_SB_TCV_HU,
     iphs1_Dialogo_SB_TCV_HTSCS,
     iphs1_Dialogo_SB_TCV_HYMO,
     iphs1_Dialogo_SB_TCV_CLARK,
     iphs1_Dialogo_SB_TCV_PEB,
     iphs1_Dialogo_SB_TCV_REORDENADA,
     iphs1_Constantes,
     LanguageControl;


{$R *.DFM}

procedure Tiphs1_Form_Dialogo_SB_TCV.sbIPHIIClick(Sender: TObject);
var d: Tiphs1_Form_Dialogo_SB_TCV_IPHII;
begin
  d := Tiphs1_Form_Dialogo_SB_TCV_IPHII.Create(self);
  PosicionarDialogo(d, TControl(Sender));

  d.edH.AsFloat    := FSB.IP_H;
  d.edIB.AsFloat   := FSB.IP_IB;
  d.edIO.AsFloat   := FSB.IP_IO;
  d.edPAI.AsFloat  := FSB.IP_PAI;
  d.edRMAX.AsFloat := FSB.IP_RMAX;
  d.edVB.AsFloat   := FSB.IP_VB;

  if d.ShowModal = mrOK then
     begin
     FSB.IP_H    := d.edH.AsFloat;
     FSB.IP_IB   := d.edIB.AsFloat;
     FSB.IP_IO   := d.edIO.AsFloat;
     FSB.IP_PAI  := d.edPAI.AsFloat;
     FSB.IP_RMAX := d.edRMAX.AsFloat;
     FSB.IP_VB   := d.edVB.AsFloat;
     end;
  d.Free;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.sbSCSClick(Sender: TObject);
var d: Tiphs1_Form_Dialogo_SB_TCV_SCS;
begin
  d := Tiphs1_Form_Dialogo_SB_TCV_SCS.Create(self);
  PosicionarDialogo(d, TControl(Sender));
  d.edCN.AsFloat := FSB.SCS_CN;
  if d.ShowModal = mrOK then
     begin
     FSB.SCS_CN := d.edCN.AsFloat;
     end;
  d.Release;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.sbHecClick(Sender: TObject);
var d: Tiphs1_Form_Dialogo_SB_TCV_HEC;
begin
  d := Tiphs1_Form_Dialogo_SB_TCV_HEC.Create(self);
  PosicionarDialogo(d, TControl(Sender));

  d.edVI.AsFloat := FSB.HEC_VI;
  d.edPD.AsFloat := FSB.HEC_PD;
  d.edLP.AsFloat := FSB.HEC_LP;
  d.edEI.AsFloat := FSB.HEC_EI;

  if d.ShowModal = mrOK then
     begin
     FSB.HEC_VI := d.edVI.AsFloat;
     FSB.HEC_PD := d.edPD.AsFloat;
     FSB.HEC_LP := d.edLP.AsFloat;
     FSB.HEC_EI := d.edEI.AsFloat;
     end;
  d.Free;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.sbFIClick(Sender: TObject);
var d: Tiphs1_Form_Dialogo_SB_TCV_FI;
begin
  d := Tiphs1_Form_Dialogo_SB_TCV_FI.Create(self);
  PosicionarDialogo(d, TControl(Sender));

  d.edI.AsFloat  := FSB.FI_I;
  d.edPI.AsFloat := FSB.FI_PI;

  if d.ShowModal = mrOK then
     begin
     FSB.FI_I  := d.edI.AsFloat;
     FSB.FI_PI := d.edPI.AsFloat;
     end;
  d.Free;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.sbHOLTANClick(Sender: TObject);
var d: Tiphs1_Form_Dialogo_SB_TCV_HOLTAN;
begin
  d := Tiphs1_Form_Dialogo_SB_TCV_HOLTAN.Create(self);
  PosicionarDialogo(d, TControl(Sender), False);

  d.edCI.AsFloat := FSB.HO_CI;
  d.edEE.AsFloat := FSB.HO_EE;
  d.edEI.AsFloat := FSB.HO_EI;
  d.edIB.AsFloat := FSB.HO_IB;

  if d.ShowModal = mrOK then
     begin
     FSB.HO_CI := d.edCI.AsFloat;
     FSB.HO_EE := d.edEE.AsFloat;
     FSB.HO_EI := d.edEI.AsFloat;
     FSB.HO_IB := d.edIB.AsFloat;
     end;
  d.Free;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.sbHUClick(Sender: TObject);
var d: Tiphs1_Form_Dialogo_SB_TCV_HU;
    i: Integer;
begin
  d := Tiphs1_Form_Dialogo_SB_TCV_HU.Create(self);
  PosicionarDialogo(d, TControl(Sender));

  d.edNPT.AsInteger := FSB.HU_NPT;
  if FSB.HU_NPT > 0 then
     begin
     d.Tab.MaxRow := FSB.HU_NPT;
     FSB.HU_Tab.Len := FSB.HU_NPT;
     for i := 1 to FSB.HU_NPT do
       d.Tab.NumberRC[i, 1] := FSB.HU_Tab[i-1];
     end;

  if d.ShowModal = mrOK then
     begin
     FSB.HU_NPT := d.edNPT.AsInteger;
     for i := 1 to FSB.HU_NPT do
       FSB.HU_Tab[i-1] := d.Tab.NumberRC[i, 1];
     end;
  d.Free;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.sbHTClick(Sender: TObject);
var d: Tiphs1_Form_Dialogo_SB_TCV_HTSCS;
begin
  d := Tiphs1_Form_Dialogo_SB_TCV_HTSCS.Create(self);
  PosicionarDialogo(d, TControl(Sender));

  d.edDB.AsFloat := FSB.HT_DB;
  d.edDB.Enabled := (edTC.AsFloat = 0);

  if d.ShowModal = mrOK then
     begin
     FSB.HT_DB := d.edDB.AsFloat;
     end;
  d.Free;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.sbHYMOClick(Sender: TObject);
var d: Tiphs1_Form_Dialogo_SB_TCV_HYMO;
begin
  d := Tiphs1_Form_Dialogo_SB_TCV_HYMO.Create(self);
  PosicionarDialogo(d, TControl(Sender));

  d.TC := edTC.AsFloat;
  d.edCC.AsFloat := FSB.HY_CC;
  d.edDN.AsFloat := FSB.HY_DN;
  d.edRR.AsFloat := FSB.HY_RR;
  d.edTP.AsFloat := FSB.HY_TP;

  if d.ShowModal = mrOK then
     begin
     FSB.HY_CC := d.edCC.AsFloat;
     FSB.HY_DN := d.edDN.AsFloat;
     FSB.HY_RR := d.edRR.AsFloat;
     FSB.HY_TP := d.edTP.AsFloat;
     end;
  d.Free;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.sbCLARKClick(Sender: TObject);
var d: Tiphs1_Form_Dialogo_SB_TCV_CLARK;
    i: Integer;
begin
  StartWait;
  d := Tiphs1_Form_Dialogo_SB_TCV_CLARK.Create(self);
  PosicionarDialogo(d, TControl(Sender), False);
  StopWait;

  d.TC              := StrToFloatDef(edTC.Text, 0);
  d.edDB.AsFloat    := FSB.CL_DB;
  d.edKS.AsFloat    := FSB.CL_KS;
  d.edXN.AsFloat    := FSB.CL_XN;
  d.edNPT.AsInteger := FSB.CL_NPT;

  if FSB.CL_NPT > 0 then
     begin
     d.Tab.MaxRow := FSB.CL_NPT;
     for i := 1 to FSB.CL_NPT do
       d.Tab.NumberRC[i, 1] := FSB.CL_Tab[i-1];
     end;

  if d.ShowModal = mrOK then
     begin
     FSB.CL_DB  := d.edDB.AsFloat;
     FSB.CL_KS  := d.edKS.AsFloat;
     FSB.CL_XN  := d.edXN.AsFloat;
     FSB.CL_NPT := d.edNPT.AsInteger;
     FSB.CL_Tab.Len := FSB.CL_NPT;
     for i := 1 to FSB.CL_NPT do
       FSB.CL_Tab[i-1] := d.Tab.NumberRC[i, 1];
     end;
  d.Free;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.sbPEB_SClick(Sender: TObject);
var d: Tiphs1_Form_Dialogo_SB_TCV_PEB;
begin
  d := Tiphs1_Form_Dialogo_SB_TCV_PEB.Create(self);
  PosicionarDialogo(d, TControl(Sender));

  d.edPR.AsFloat := FSB.PEB_PR;
  d.edVB.AsFloat := FSB.PEB_VB;

  if d.ShowModal = mrOK then
     begin
     FSB.PEB_PR := d.edPR.AsFloat;
     FSB.PEB_VB := d.edVB.AsFloat;
     end;
  d.Free;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.sbReordenadaClick(Sender: TObject);
var d: Tiphs1_Form_Dialogo_SB_TCV_Reordenada;
begin
  d := Tiphs1_Form_Dialogo_SB_TCV_Reordenada.Create(self);
  PosicionarDialogo(d, TControl(Sender));

  case FSB.TP of
    tp25: d.rb25.Checked := True;
    tp50: d.rb50.Checked := True;
    tp75: d.rb75.Checked := True;
    end;

  if d.ShowModal = mrOK then
     begin
     if d.rb25.Checked then FSB.TP := tp25 else
     if d.rb50.Checked then FSB.TP := tp50 else
     if d.rb75.Checked then FSB.TP := tp75;
     end;
  d.Free;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.btnOKClick(Sender: TObject);
var i: Integer;
    p: Tiphs1_Projeto;
    x: Real;
begin
  FSB.AB := edAB.AsFloat;
  FSB.TC := edTC.AsFloat;

  x := 0;

  p := Tiphs1_Projeto(FSB.Projeto);
  for i := 0 to TabPostos.RowCount-1 do
    if TabPostos.Checked[1, i] then
       begin
       FSB.Coefs[i] := StrToFloat(TabPostos.Cells[1, i]);
       x := x + FSB.Coefs[i];
       end
    else
       FSB.Coefs[i] := 0;

  if System.Abs(x - 1.0) > 0.01 then
     Raise Exception.Create(LanguageManager.GetMessage(cMesID_IPH, 45)
       {'Coeficientes de Thiessen não somam 1'});

  if rbNR.Checked then FSB.TP := tp0;
  FSB.SE := TenSE(Panel_SE.Tag);
  FSB.ES := TenES(Panel_ES.Tag);
  FSB.PEB := rbPEB_S.Checked;
  FSB.IR := cbIR.Checked;

  ModalResult := mrOK;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.FormShow(Sender: TObject);
var i: Integer;
    p: Tiphs1_Projeto;
begin
  edAB.AsFloat := FSB.AB;
  edTC.AsFloat := FSB.TC;

  p := Tiphs1_Projeto(FSB.Projeto);

  // Ajusta a contribuicao dos postos de chuva
  TabPostos.RowCount := p.PChuva.Count;
  FSB.Coefs.Len := TabPostos.RowCount;
  for i := 0 to p.PChuva.Count-1 do
    begin
    TabPostos.Cells[0, i]   := System.Copy(p.PChuva[i], 1, System.Pos(' : ', p.PChuva[i])-1);
    TabPostos.Checked[1, i] := FSB.Coefs[i] > 0.0001;
    TabPostos.Cells[1, i]   := FormatFloat('0.00', FSB.Coefs[i]);
    end;

  // seta o valor 1.00 como default quando temos somente um posto de chuva no projeto
  if p.PChuva.Count = 1 then
     begin
     TabPostos.Cells[1, 0] := '1' + DecimalSeparator + '00';
     TabPostos.Checked[1, 0] := true;
     end;

  FAjustar := False;
  if FSB.TP = tp0 then
     rbNR.Checked := True
  else
     begin
     rbR.OnClick := nil;
     rbR.Checked := True;
     rbR.OnClick := rbRClick;
     end;

  case FSB.SE of
    seIPHII  : rbIPHII.Checked := True;
    seSCS    : rbSCS.Checked := True;
    seHEC1   : rbHEC.Checked := True;
    seFI     : rbFI.Checked := True;
    seHOLTAN : rbHOLTAN.Checked := True;
    end;
  FAjustar := True;

  case FSB.ES of
    esHU    : rbHU.Checked := True;
    esHT    : rbHT.Checked := True;
    esHYMO  : rbHYMO.Checked := True;
    esCLARK : rbCLARK.Checked := True;
    end;
  if FSB.PEB then rbPEB_S.Checked := True else rbPEB_N.Checked := True;
  cbIR.Checked := FSB.IR;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.AjustarSE;
begin
  sbIPHII.Enabled  := rbIPHII.Checked;
  sbSCS.Enabled    := rbSCS.Checked;
  sbHEC.Enabled    := rbHEC.Checked;
  sbFI.Enabled     := rbFI.Checked;
  sbHOLTAN.Enabled := rbHOLTAN.Checked;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.AjustarES;
begin
  sbHU.Enabled    := rbHU.Checked;
  sbHT.Enabled    := rbHT.Checked and (edTC.AsFloat = 0);
  sbHYMO.Enabled  := rbHYMO.Checked;
  sbCLARK.Enabled := rbCLARK.Checked;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.SE_Click(Sender: TObject);
begin
  Panel_SE.Tag := TComponent(Sender).Tag;
  SetEnable([sbPEB_S, rbPEB_S, rbPEB_N], rbIPHII.Checked);

  if FAjustar then
     begin
     rbCLARK.OnClick := nil;
     rbCLARK.Checked := rbIPHII.Checked;
     rbCLARK.OnClick := ES_Click;
     if rbCLARK.Checked then
        begin
        ES_Click(rbCLARK);
        MessageDLG('O método CLARK está foi vinculado ao método IPH II'#13 +
                   'portanto, verifique os dados do método CLARK em Escoamento Superficial',
                   mtInformation, [mbOK], 0);
        end;
     end;

  AjustarSE;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.ES_Click(Sender: TObject);
begin
  Panel_ES.Tag := TComponent(Sender).Tag;
  AjustarES;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.edTCxChange(Sender: TObject);
begin
  SetEnable([sbHT], edTC.AsFloat = 0);
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.rbPEB_Click(Sender: TObject);
begin
  sbPEB_S.Enabled := rbPEB_S.Checked;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.btnCalcularTCClick(Sender: TObject);
begin
  with Tfoiphs1_Dialogo_SB_TCV_Calculo_TC.Create(nil) do
    begin
    if ShowModal = mrOk then edTC.AsFloat := TempoDeConcentracao;
    Release;
    end;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.rbRClick(Sender: TObject);
begin
  sbReordenada.Enabled := rbR.Checked;
  if rbR.Checked then
     sbReordenadaClick(sbReordenada);
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.TabPostosKeyPress(Sender: TObject; var Key: Char);
var s: String;
begin
  // Só aceita valores Reais
  If (Key = '.') or (Key = ',') then
     begin
     Key := DecimalSeparator;
     s := TabPostos.Cells[TabPostos.Col, TabPostos.Row];
     if (System.pos(Key, s) > 0) or (Length(s) = 0) then Key := #0;
     end
  else
     case Key of
       #8, '0'..'9' : {Aceita} ;
       else
         Key := #0;
       end;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV.edTCExit(Sender: TObject);
begin
{
  if (rbHYMO.Checked) and (edTC.AsFloat = 0) then
     raise Exception.Create(
       'Método HYMO selecionado.'#13 +
       'Verifique suas propriedades pois este método depende do Tempo de Concentração.'
       );
}       
end;

end.
