unit iphs1_Dialogo_TD_MPE_MCCF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Frame_TD_MPE_MCCF,
  ExtCtrls, drEdit, iphs1_Classes;

type
  Tiphs1_Form_Dialogo_TD_MPE_MCCF = class(TForm)
    btnOk: TBitBtn;
    btnCancelar: TBitBtn;
    edVR: TdrEdit;
    Panel7: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    edNCS: TdrEdit;
    sbCS: TScrollBox;
    Panel3: TPanel;
    rbEN: TRadioButton;
    rbERR: TRadioButton;
    edRug: TdrEdit;
    rbEAD: TRadioButton;
    paEAD: TPanel;
    pa1: TPanel;
    cbEAD_SR: TComboBox;
    cbEAD_L: TCheckBox;
    cbEAD_A: TCheckBox;
    cbEAD_DE: TCheckBox;
    cbEAD_DD: TCheckBox;
    Panel4: TPanel;
    pa7: TPanel;
    edLT: TdrEdit;
    pa8: TPanel;
    edCFM: TdrEdit;
    pa9: TPanel;
    edIS: TdrEdit;
    pa10: TPanel;
    edST: TdrEdit;
    laTAB: TLabel;
    Panel5: TPanel;
    edCFJ: TdrEdit;
    cbVR: TCheckBox;
    cbIS: TCheckBox;
    cbST: TCheckBox;
    paSecao: TPanel;
    Panel8: TPanel;
    Im: TImage;
    laSecao: TLabel;
    Panel6: TPanel;
    TP: Tiphs1_Frame_TD_MPE_MCCF;
    procedure Excesso_Click(Sender: TObject);
    procedure cbEAD_SR_Change(Sender: TObject);
    procedure edNCS_Change(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure edNCSEnter(Sender: TObject);
    procedure bVRClick(Sender: TObject);
    procedure bISClick(Sender: TObject);
    procedure bSTClick(Sender: TObject);
    procedure cbVRClick(Sender: TObject);
    procedure cbISClick(Sender: TObject);
    procedure cbSTClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Frames : Integer;
    procedure TipoSecaoMudou(TipoSecao: byte);
    procedure CriarTrechoParalelo(i: Integer);
    function getFrame(i: Integer): Tiphs1_Frame_TD_MPE_MCCF;
  public
    procedure SetDados(const CF_DG_VR       : Real;                   // Vazão de Ref.
                       const CF_DG_TE       : Integer;                // Tipo de Excesso
                       const CF_DG_Ex_RR    : Real;                   // Excesso 2: Rugosidade da Rua
                       const CF_DG_Ex_AD_SR : Integer;                // Excesso 1: Secao de Ref.
                       const CF_DG_Ex_AD_L  : Boolean;                // Excesso 1: Largura
                       const CF_DG_Ex_AD_A  : Boolean;                // Excesso 1: Altura
                       const CF_DG_Ex_AD_DE : Boolean;                // Excesso 1: Dec. Esq.
                       const CF_DG_Ex_AD_DD : Boolean;                // Excesso 1: Dec. Dir.
                       const CF_DG_LT       : Real;                   // Long. Trecho
                       const CF_DG_CFM      : Real;                   // Cota de fundo de Montante
                       const CF_DG_CFJ      : Real;                   // Cota de fundo de Jusante
                       const CF_DG_IS       : Real;                   // Int. Sim.
                       const CF_DG_ST       : Integer;                // Sub-Trechos
                       const CF_DG_VR_auto  : Boolean;
                       const CF_DG_IS_auto  : Boolean;
                       const CF_DG_ST_auto  : Boolean;

                       // Trecho Principal
                       const CF_TPrinc : TRec_TD_CF_TP;

                       // Trechos Paralelos
                       const CF_TPs : TArray_Rec_TD_CF_TP);

    procedure GetDados(var CF_DG_VR       : Real;                   // Vazão de Ref.
                       var CF_DG_TE       : Integer;                // Tipo de Excesso
                       var CF_DG_Ex_RR    : Real;                   // Excesso 2: Rugosidade da Rua
                       var CF_DG_Ex_AD_SR : Integer;                // Excesso 1: Secao de Ref.
                       var CF_DG_Ex_AD_L  : Boolean;                // Excesso 1: Largura
                       var CF_DG_Ex_AD_A  : Boolean;                // Excesso 1: Altura
                       var CF_DG_Ex_AD_DE : Boolean;                // Excesso 1: Dec. Esq.
                       var CF_DG_Ex_AD_DD : Boolean;                // Excesso 1: Dec. Dir.
                       var CF_DG_LT       : Real;                   // Long. Trecho
                       var CF_DG_CFM      : Real;                   // Cota de fundo de Montante
                       var CF_DG_CFJ      : Real;                   // Cota de fundo de Jusante
                       var CF_DG_IS       : Real;                   // Int. Sim.
                       var CF_DG_ST       : Integer;                // Sub-Trechos
                       var CF_DG_VR_auto  : Boolean;
                       var CF_DG_IS_auto  : Boolean;
                       var CF_DG_ST_auto  : Boolean;

                       // Trecho Principal
                       var CF_TPrinc : TRec_TD_CF_TP;

                       // Trechos Paralelos
                       var CF_TPs : TArray_Rec_TD_CF_TP);
  end;

implementation
uses WinUtils, hidro_Variaveis;

{$R *.dfm}

{ Tiphs1_Form_Dialogo_TD_MPE_MCCF }

procedure Tiphs1_Form_Dialogo_TD_MPE_MCCF.CriarTrechoParalelo(i: Integer);
var p, pa: TPanel;
    f: Tiphs1_Frame_TD_MPE_MCCF;
begin
  p  := TPanel.Create(nil);
  pa := TPanel.Create(nil);

  pa.Align := alLeft;
  pa.Alignment := taCenter;
  pa.Caption := intToStr(i + 1); // inicia em 2
  pa.Hint := 'Identificação da Seção';
  pa.ShowHint := true;
  pa.Width := 20;
  pa.Parent := p;

  f := Tiphs1_Frame_TD_MPE_MCCF.Create(nil);
  f.Name := 'f';
  f.Align := alClient;
  f.Parent := p;
  f.TipoSecaoMudou := TipoSecaoMudou;

  p.Name   := 'p' + IntToStr(i + 1); // inicia em 2
  p.Height := f.Height + 4;
  p.Width  := sbCS.Width - 4;
  p.Parent := sbCS;
  p.Left   := 0;
  p.Top    := (i-1) * p.Height;

  p.InsertComponent(f);
  sbCS.InsertComponent(p);

  f.cbTSChange(nil);
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_MCCF.Excesso_Click(Sender: TObject);
begin
  edRug.Enabled := rbERR.Checked;
  EnableControl(paEAD, rbEAD.Checked);
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_MCCF.cbEAD_SR_Change(Sender: TObject);
var f: Tiphs1_Frame_TD_MPE_MCCF;
begin
  if cbEAD_SR.ItemIndex > -1 then
     begin
     f := getFrame(cbEAD_SR.ItemIndex + 1);
     setEnable([cbEAD_L, cbEAD_A], f.TipoSec <> 2);
     setEnable([cbEAD_DE, cbEAD_DD], f.TipoSec = 3);
     end;
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_MCCF.edNCS_Change(Sender: TObject);
var i, k: Integer;
    c: TComponent;
begin
  if edNCS.AsInteger < 0 then edNCS.AsInteger := 0; // 2.062
  if edNCS.AsInteger > 7 then edNCS.AsInteger := 7;

  k := edNCS.AsInteger - Frames;
  if k > 0 then
     begin
     for i := 1 to k do CriarTrechoParalelo(Frames + i);
     Frames := Frames + k;
     end
  else if k < 0 then
     begin
     for i := 1 to abs(k) do
       begin
       Dec(Frames);
       c := sbCS.Components[Frames];
       sbCS.RemoveComponent(c);
       c.Free;
       end;
     end
  else
     Exit;

  // secao de referencia
  cbEAD_SR.Clear();
  cbEAD_SR.Items.Add('1'); // Trecho principal
  for i := 1 to Frames do
    cbEAD_SR.Items.Add(intToStr(i + 1)); // Trechos paralelos

  laTAB.Visible := False;
  im.Picture.Bitmap := nil;
  laSecao.Caption := ''; 
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_MCCF.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_MCCF.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_MCCF.SetDados(
  const CF_DG_VR       : Real;
  const CF_DG_TE       : Integer;
  const CF_DG_Ex_RR    : Real;
  const CF_DG_Ex_AD_SR : Integer;
  const CF_DG_Ex_AD_L  : Boolean;
  const CF_DG_Ex_AD_A  : Boolean;
  const CF_DG_Ex_AD_DE : Boolean;
  const CF_DG_Ex_AD_DD : Boolean;
  const CF_DG_LT       : Real;
  const CF_DG_CFM      : Real;
  const CF_DG_CFJ      : Real;
  const CF_DG_IS       : Real;
  const CF_DG_ST       : Integer;
  const CF_DG_VR_auto  : Boolean;
  const CF_DG_IS_auto  : Boolean;
  const CF_DG_ST_auto  : Boolean;
  const CF_TPrinc      : TRec_TD_CF_TP;
  const CF_TPs         : TArray_Rec_TD_CF_TP);

var i: Integer;
begin
  edVR.AsFloat   := CF_DG_VR;
  edLT.asFloat   := CF_DG_LT;
  edCFM.AsFloat  := CF_DG_CFM;
  edCFJ.AsFloat  := CF_DG_CFJ;
  edIS.AsFloat   := CF_DG_IS;
  edST.AsInteger := CF_DG_ST;

  cbVR.Checked := CF_DG_VR_auto;
  cbIS.Checked := CF_DG_IS_auto;
  cbST.Checked := CF_DG_ST_auto;

  // Trecho Principal
  with CF_TPrinc do
    TP.SetData(TS, AD, L, DE, DD, R);

  // Trechos Paralelos
  edNCS.AsInteger := Length(CF_TPs);
  edNCS_Change(nil);
  for i := 0 to High(CF_TPs) do
    with CF_TPs[i] do
      getFrame(i + 2).SetData(TS, AD, L, DE, DD, R);

  case CF_DG_TE of
    0: rbEN.Checked := True;
    1: rbEAD.Checked := True;
    2: rbERR.Checked := True;
    end;
  Excesso_Click(nil);

  edRug.AsFloat := CF_DG_Ex_RR;

  cbEAD_SR.ItemIndex := CF_DG_Ex_AD_SR - 1;
  cbEAD_SR_Change(nil);

  cbEAD_L.Checked := CF_DG_Ex_AD_L;
  cbEAD_A.Checked := CF_DG_Ex_AD_A;
  cbEAD_DE.Checked := CF_DG_Ex_AD_DE;
  cbEAD_DD.Checked := CF_DG_Ex_AD_DD;
end;

function Tiphs1_Form_Dialogo_TD_MPE_MCCF.getFrame(i: Integer): Tiphs1_Frame_TD_MPE_MCCF;
begin
  if i = 1 then
     Result := TP
  else
     Result := sbCS.FindComponent('p' + intToStr(i)).
                       FindComponent('f') as Tiphs1_Frame_TD_MPE_MCCF;
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_MCCF.GetDados(
  var CF_DG_VR       : Real;
  var CF_DG_TE       : Integer;
  var CF_DG_Ex_RR    : Real;
  var CF_DG_Ex_AD_SR : Integer;
  var CF_DG_Ex_AD_L  : Boolean;
  var CF_DG_Ex_AD_A  : Boolean;
  var CF_DG_Ex_AD_DE : Boolean;
  var CF_DG_Ex_AD_DD : Boolean;
  var CF_DG_LT       : Real;
  var CF_DG_CFM      : Real;
  var CF_DG_CFJ      : Real;
  var CF_DG_IS       : Real;
  var CF_DG_ST       : Integer;
  var CF_DG_VR_auto  : Boolean;
  var CF_DG_IS_auto  : Boolean;
  var CF_DG_ST_auto  : Boolean;
  var CF_TPrinc      : TRec_TD_CF_TP;
  var CF_TPs         : TArray_Rec_TD_CF_TP);

var i: Integer;
begin
  CF_DG_VR  := edVR.AsFloat;
  CF_DG_LT  := edLT.asFloat;
  CF_DG_CFM := edCFM.AsFloat;
  CF_DG_CFJ := edCFJ.AsFloat;
  CF_DG_IS  := edIS.AsFloat;
  CF_DG_ST  := edST.AsInteger;

  CF_DG_VR_auto  := cbVR.Checked;
  CF_DG_IS_auto  := cbIS.Checked;
  CF_DG_ST_auto  := cbST.Checked;

  // Trecho Principal
  with CF_TPrinc do
    TP.GetData(TS, AD, L, DE, DD, R);

  // Trechos Paralelos
  SetLength(CF_TPs, edNCS.AsInteger);
  for i := 0 to High(CF_TPs) do
    with CF_TPs[i] do
      getFrame(i + 2).GetData(TS, AD, L, DE, DD, R);

  if rbEN.Checked  then CF_DG_TE := 0;
  if rbEAD.Checked then CF_DG_TE := 1;
  if rbERR.Checked then CF_DG_TE := 2;

  CF_DG_Ex_RR := edRug.AsFloat;

  CF_DG_Ex_AD_SR := cbEAD_SR.ItemIndex + 1;

  CF_DG_Ex_AD_L := cbEAD_L.Checked;
  CF_DG_Ex_AD_A := cbEAD_A.Checked;
  CF_DG_Ex_AD_DE := cbEAD_DE.Checked;
  CF_DG_Ex_AD_DD := cbEAD_DD.Checked;
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_MCCF.edNCSEnter(Sender: TObject);
begin
  laTAB.Visible := True;
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_MCCF.bVRClick(Sender: TObject);
begin
  edVR.AsInteger := 0;
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_MCCF.bISClick(Sender: TObject);
begin
  edIS.AsInteger := 0;
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_MCCF.bSTClick(Sender: TObject);
begin
  edST.AsInteger := 0;
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_MCCF.cbVRClick(Sender: TObject);
begin
  edVR.Enabled := not cbVR.Checked;
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_MCCF.cbISClick(Sender: TObject);
begin
  edIS.Enabled := not cbIS.Checked;
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_MCCF.cbSTClick(Sender: TObject);
begin
  edST.Enabled := not cbST.Checked;
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_MCCF.TipoSecaoMudou(TipoSecao: byte);
var s: String;
begin
  case TipoSecao of
    0: begin
       s := gExePath + 'imagens\retangular.bmp';
       laSecao.Caption := 'Retangular';
       end;

    1: begin
       s := gExePath + 'imagens\circular.bmp';
       laSecao.Caption := 'Circular';
       end;

    2: begin
       s := gExePath + 'imagens\trapezoidal.bmp';
       laSecao.Caption := 'Trapezoidal';
       end;
  end;

  cbEAD_SR_Change(nil);

  if FileExists(s) then
     im.Picture.LoadFromFile(s);
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_MCCF.FormCreate(Sender: TObject);
begin
  laSecao.Caption := '';
  TP.TipoSecaoMudou := TipoSecaoMudou;
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_MCCF.FormShow(Sender: TObject);
begin
  edNCS_Change(nil);
end;

end.
