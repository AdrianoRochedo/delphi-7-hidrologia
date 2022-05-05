unit pr_Dialogo_Demanda_TFI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pr_Dialogo_Demanda_TVU, StdCtrls, gridx32,
  Buttons, drEdit;

type
  TprDialogo_TFI = class(TprDialogo_TVU)
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  prDialogo_TFI: TprDialogo_TFI;         // <...>

implementation

{$R *.DFM}

procedure TprDialogo_TFI.FormShow(Sender: TObject);
begin
  inherited;
  Tab.ColCount := 2;
  Tab.Cells[1, 0] := 'Valor';
end;

end.
