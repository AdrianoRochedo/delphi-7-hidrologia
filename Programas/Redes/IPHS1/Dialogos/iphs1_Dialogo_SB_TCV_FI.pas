unit iphs1_Dialogo_SB_TCV_FI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, drEdit;

type
  Tiphs1_Form_Dialogo_SB_TCV_FI = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Panel2: TPanel;
    Panel1: TPanel;
    edPI: TdrEdit;
    edI: TdrEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  iphs1_Form_Dialogo_SB_TCV_FI: Tiphs1_Form_Dialogo_SB_TCV_FI;

implementation

{$R *.DFM}

end.
