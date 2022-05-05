unit pr_Dialogo_Projeto_OpcVisRede;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, drEdit, ExtCtrls, Frame_moUnits;

type
  TprDialogo_Projeto_OpcVisRede = class(TForm)
    btnOk: TBitBtn;
    GroupBox2: TGroupBox;
    GroupBox1: TGroupBox;
    VR_SD_rbSP: TRadioButton;
    VR_SD_rbE: TRadioButton;
    VR_SD_edE: TdrEdit;
    edSC: TLabeledEdit;
    sbSC: TSpeedButton;
    edSC_Cod: TEdit;
    Label1: TLabel;
    edEscala: TdrEdit;
    frUnidade: TFrame_moUnits;
    procedure sbSCClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
uses Form_moCoordinateSystem;

{$R *.dfm}

procedure TprDialogo_Projeto_OpcVisRede.sbSCClick(Sender: TObject);
var sName, sCod: String;
    cType: Char;
begin
  if TForm_moCoordinateSystem.GetCoordinateSystem(cType, sName, sCod) then
     begin
     edSC.Text := '(' + cType + ') ' + sName;
     edSC_Cod.Text := sCod;
     end;
end;

procedure TprDialogo_Projeto_OpcVisRede.btnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TprDialogo_Projeto_OpcVisRede.FormCreate(Sender: TObject);
begin
  frUnidade.ShowUnits();
end;

end.
