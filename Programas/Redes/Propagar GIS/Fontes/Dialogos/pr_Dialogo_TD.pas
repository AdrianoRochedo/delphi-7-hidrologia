unit pr_Dialogo_TD;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pr_DialogoBase, StdCtrls, Buttons, ExtCtrls,
  drEdit;

type
  TprDialogo_TD = class(TprDialogo_Base)
    Panel4: TPanel;
    Panel5: TPanel;
    edVazMin: TdrEdit;
    edVazMax: TdrEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  prDialogo_TD: TprDialogo_TD;

implementation

{$R *.DFM}

end.
