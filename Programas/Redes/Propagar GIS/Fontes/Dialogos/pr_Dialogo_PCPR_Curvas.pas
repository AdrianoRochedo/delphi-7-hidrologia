unit pr_Dialogo_PCPR_Curvas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, AxCtrls, OleCtrls, vcf1, StdCtrls, Buttons;

type
  TprDialogo_Curvas = class(TForm)
    Panel7: TPanel;
    edCV: TEdit;
    Panel8: TPanel;
    edAV: TEdit;
    CV: TF1Book;
    H1: THeader;
    AV: TF1Book;
    Header1: THeader;
    btnOk: TBitBtn;
    procedure btnOkClick(Sender: TObject);
    procedure CVKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TprDialogo_Curvas.btnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TprDialogo_Curvas.CVKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var c: Char;
    Tab: TF1Book;
begin
  if (Shift = [ssCtrl]) then
     begin
     Tab := TF1Book(Sender);
     c := upCase(char(Key));
     case c of
       'C': Tab.EditCopy;
       'V': Tab.EditPaste;
       'X': Tab.EditCut;
       'P': Tab.FilePrint(True); // Mostra diálogo de Impressão
       end;
     end;
end;

end.
