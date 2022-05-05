unit iphs1_Dialogo_TD_MPE_Base;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, drEdit;

type
  Tiphs1_Form_Dialogo_TD_MPE_Base = class(TForm)
    btnOk: TBitBtn;
    btnCancelar: TBitBtn;
    p5: TPanel;
    p1: TPanel;
    p9: TPanel;
    p8: TPanel;
    p6: TPanel;
    edLC: TdrEdit;
    edCTP: TdrEdit;
    edITC: TdrEdit;
    edNST: TdrEdit;
    edRST: TdrEdit;
    p3: TPanel;
    p7: TPanel;
    edCFJ: TdrEdit;
    edVR: TdrEdit;
    p2: TPanel;
    edCFM: TdrEdit;
    p4: TPanel;
    edAC: TdrEdit;
    cbVR: TCheckBox;
    cbNST: TCheckBox;
    cbITC: TCheckBox;
    procedure cbVRClick(Sender: TObject);
    procedure cbNSTClick(Sender: TObject);
    procedure cbITCClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure Tiphs1_Form_Dialogo_TD_MPE_Base.cbVRClick(Sender: TObject);
begin
  edVR.Enabled := not cbVR.Checked;
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_Base.cbNSTClick(Sender: TObject);
begin
  edNST.Enabled := not cbNST.Checked;
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_Base.cbITCClick(Sender: TObject);
begin
  edITC.Enabled := not cbITC.Checked;
end;

end.
