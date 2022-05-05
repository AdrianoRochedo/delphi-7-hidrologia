unit pr_Dialogo_QA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pr_DialogoBase, StdCtrls, Buttons, ExtCtrls;

type
  TprDialogo_QA = class(TprDialogo_Base)
    Panel3: TPanel;
    paQual: TPanel;
    C8: TPanel;
    R8: TRadioButton;
    C7: TPanel;
    R7: TRadioButton;
    C6: TPanel;
    R6: TRadioButton;
    C5: TPanel;
    R5: TRadioButton;
    C4: TPanel;
    R4: TRadioButton;
    C3: TPanel;
    R3: TRadioButton;
    C2: TPanel;
    R2: TRadioButton;
    C1: TPanel;
    R1: TRadioButton;
  public
    function getQA(): integer;
    procedure setQA(const Value: integer);
  end;

implementation
uses pr_Tipos;

{$R *.dfm}

{ TprDialogo_QA }

function TprDialogo_QA.getQA(): integer;
var i: integer;
    r: TRadioButton;
begin
  for i := 1 to TQACodigos.NumCodigos do
    begin
    r := TRadioButton( paQual.FindChildControl('R' + intToStr(i)) );
    if r.Checked then
       begin
       result := r.Tag;
       exit;
       end;
    end;
end;

procedure TprDialogo_QA.setQA(const Value: integer);
var i: integer;
    r: TRadioButton;
begin
  for i := 1 to TQACodigos.NumCodigos do
    begin
    r := TRadioButton( paQual.FindChildControl('R' + intToStr(i)) );
    if r.Tag = Value then
       begin
       r.Checked := true;
       exit;
       end;
    end;
end;

end.
