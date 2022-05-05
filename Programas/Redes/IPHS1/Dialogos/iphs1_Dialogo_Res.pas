unit iphs1_Dialogo_Res;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  iphs1_Dialogo_Base, StdCtrls, Buttons, ExtCtrls, drEdit, Menus,
  iphs1_Dialogo_Res_TCV,
  iphs1_Dialogo_Res_EE,
  iphs1_Dialogo_Res_Orificio,
  iphs1_Dialogo_Res_Vertedor;

type
  Tiphs1_Form_Dialogo_Res = class(Tiphs1_Form_Dialogo_Base)
    Panel9: TPanel;
    sbCV: TSpeedButton;
    edAI: TdrEdit;
    Panel7: TPanel;
    rbVO: TRadioButton;
    paVO: TPanel;
    cbVert: TCheckBox;
    btnVert: TSpeedButton;
    cbOrif: TCheckBox;
    btnOrif: TSpeedButton;
    edBypass: TdrEdit;
    Panel10: TPanel;
    rbEE: TRadioButton;
    paEE: TPanel;
    btnEE: TSpeedButton;
    Panel12: TPanel;
    edNE: TdrEdit;
    Panel6: TPanel;
    procedure btnEE_Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnVertClick(Sender: TObject);
    procedure btnOrifClick(Sender: TObject);
    procedure EstruturasDeSaida_Click(Sender: TObject);
    procedure cbVertClick(Sender: TObject);
    procedure cbOrifClick(Sender: TObject);
    procedure btnTCV_Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    DLG_TCV  : Tiphs1_Form_Dialogo_Res_TCV;
    DLG_EE   : Tiphs1_Form_Dialogo_Res_EE;
    DLG_Vert : Tiphs1_Form_Dialogo_Res_Vertedor;
    DLG_Orif : Tiphs1_Form_Dialogo_Res_Orificio;
  end;

implementation
uses hidro_Procs,
     iphs1_Classes,
     iphs1_Constantes,
     LanguageControl,
     FrameEstruturaRes_Q,
     WinUtils;


{$R *.DFM}

procedure Tiphs1_Form_Dialogo_Res.btnEE_Click(Sender: TObject);
var i: Integer;
    f: TfrEstruturaRes_Q;
begin
  if (edNE.AsInteger < 1) or (edNE.AsInteger > 10) then
     raise Exception.Create('Número de Extruturas inválido.'#13 +
                            'Entre com um número entre 1 e 10');

  DLG_EE.NumEstruturas := edNE.AsInteger; 
  for i := 1 to DLG_EE.NumEstruturas do
    begin
    f := TfrEstruturaRes_Q(DLG_EE.FindComponent('f' + IntToStr(i)));
    if f <> nil then
       f.edIT.AsInteger := Tiphs1_Projeto(Tiphs1_PCR(Objeto).Projeto).NIT;
    end;
  DLG_EE.ShowModal;
end;

procedure Tiphs1_Form_Dialogo_Res.FormCreate(Sender: TObject);
begin
  inherited;
  DLG_TCV := Tiphs1_Form_Dialogo_Res_TCV.Create(Self);
  DLG_EE  := Tiphs1_Form_Dialogo_Res_EE.Create(Self);
  DLG_Vert := Tiphs1_Form_Dialogo_Res_Vertedor.Create(Self);
  DLG_Orif := Tiphs1_Form_Dialogo_Res_Orificio.Create(Self);
end;

procedure Tiphs1_Form_Dialogo_Res.FormDestroy(Sender: TObject);
begin
  DLG_TCV.Free;
  DLG_EE.Free;
  DLG_Vert.Free;
  DLG_Orif.Free;
  inherited;
end;

procedure Tiphs1_Form_Dialogo_Res.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If key = VK_F1 then
     MostrarHTML('EdicaoDosObjetos.htm#RES');
end;

procedure Tiphs1_Form_Dialogo_Res.btnVertClick(Sender: TObject);
begin
  PosicionarDialogo(DLG_Vert, TControl(Sender));
  DLG_Vert.ShowModal;
end;

procedure Tiphs1_Form_Dialogo_Res.btnOrifClick(Sender: TObject);
begin
  PosicionarDialogo(DLG_Orif, TControl(Sender));
  DLG_Orif.ShowModal;
end;

procedure Tiphs1_Form_Dialogo_Res.EstruturasDeSaida_Click(Sender: TObject);
begin
  EnableControl(paVO, rbVO.Checked);
  EnableControl(paEE, rbEE.Checked);
end;

procedure Tiphs1_Form_Dialogo_Res.cbVertClick(Sender: TObject);
begin
  btnVert.Enabled := cbVert.Checked;
end;

procedure Tiphs1_Form_Dialogo_Res.cbOrifClick(Sender: TObject);
begin
  btnOrif.Enabled := cbOrif.Checked;
end;

procedure Tiphs1_Form_Dialogo_Res.btnTCV_Click(Sender: TObject);
begin
  DLG_TCV.ShowModal;
end;

procedure Tiphs1_Form_Dialogo_Res.FormShow(Sender: TObject);
begin
  EstruturasDeSaida_Click(nil);
end;

procedure Tiphs1_Form_Dialogo_Res.FormActivate(Sender: TObject);
begin
  inherited;
  cbVertClick(nil);
  cbOrifClick(nil);
end;

end.
