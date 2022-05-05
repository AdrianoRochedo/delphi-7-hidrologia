unit pr_Dialogo_TD;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pr_DialogoBase, StdCtrls, Buttons, ExtCtrls, drEdit;

type
  TprDialogo_TD = class(TprDialogo_Base)
    Panel4: TPanel;
    Panel5: TPanel;
    edVazMin: TdrEdit;
    edVazMax: TdrEdit;
    Panel3: TPanel;
    edC: TdrEdit;
    Panel6: TPanel;
    edASM: TdrEdit;
    Panel7: TPanel;
    edPSM: TdrEdit;
    Panel8: TPanel;
    edLBSM: TdrEdit;
    Panel9: TPanel;
    edRH: TdrEdit;
    Panel10: TPanel;
    edCM: TdrEdit;
    p2: TPanel;
    edD: TdrEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
