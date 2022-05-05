unit iphs1_Dialogo_PC;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  iphs1_Dialogo_Base, StdCtrls, Buttons, ExtCtrls, drEdit, Menus;

type
  Tiphs1_Form_Dialogo_PC = class(Tiphs1_Form_Dialogo_Base)
    cbCor: TColorBox;
    Panel6: TPanel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  iphs1_Form_Dialogo_PC: Tiphs1_Form_Dialogo_PC;

implementation
uses hidro_Procs;

{$R *.DFM}

procedure Tiphs1_Form_Dialogo_PC.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If key = VK_F1 then
     MostrarHTML('EdicaoDosObjetos.htm#PC');
end;

end.
