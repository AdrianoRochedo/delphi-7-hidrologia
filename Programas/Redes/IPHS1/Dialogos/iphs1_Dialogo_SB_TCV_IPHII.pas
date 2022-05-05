unit iphs1_Dialogo_SB_TCV_IPHII;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, drEdit;

type
  Tiphs1_Form_Dialogo_SB_TCV_IPHII = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Panel2: TPanel;
    edIO: TdrEdit;
    Panel1: TPanel;
    edIB: TdrEdit;
    Panel4: TPanel;
    edH: TdrEdit;
    Panel3: TPanel;
    edRMax: TdrEdit;
    Panel6: TPanel;
    edVB: TdrEdit;
    Panel5: TPanel;
    edPAI: TdrEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
