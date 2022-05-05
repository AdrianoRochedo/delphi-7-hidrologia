unit iphs1_Dialogo_SB_TCV_HYMO;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, drEdit;

type
  Tiphs1_Form_Dialogo_SB_TCV_HYMO = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Panel2: TPanel;
    edTP: TdrEdit;
    Panel6: TPanel;
    edDN: TdrEdit;
    Panel7: TPanel;
    edCC: TdrEdit;
    Panel1: TPanel;
    edRR: TdrEdit;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    TC: real;
  end;

implementation
uses WinUtils,
     SysUtilsEx;

{$R *.DFM}

procedure Tiphs1_Form_Dialogo_SB_TCV_HYMO.FormShow(Sender: TObject);
begin
  SetEnable([Panel6, Panel7, edDN, edCC], TC = 0);
end;

end.
