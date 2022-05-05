unit iphs1_Dialogo_TD_MPE_CPI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, iphs1_Dialogo_TD_MPE_Base, StdCtrls, drEdit, ExtCtrls, Buttons;

type
  Tiphs1_Form_Dialogo_TD_MPE_CPI = class(Tiphs1_Form_Dialogo_TD_MPE_Base)
    Panel1: TPanel;
    Panel2: TPanel;
    edAPI: TdrEdit;
    edLPI: TdrEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel3: TPanel;
    edRPI: TdrEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

end.
