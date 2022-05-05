unit pr_Dialogo_Descarga;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pr_DialogoBase, StdCtrls, Buttons, ExtCtrls, drEdit;

type
  TprDialogo_Descarga = class(TprDialogo_Base)
    Panel3: TPanel;
    edCargaDBOC: TdrEdit;
    Panel6: TPanel;
    edCargaDBON: TdrEdit;
    Panel7: TPanel;
    edCargaColif: TdrEdit;
    Panel4: TPanel;
    edConDBOC: TdrEdit;
    Panel5: TPanel;
    edConDBON: TdrEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
