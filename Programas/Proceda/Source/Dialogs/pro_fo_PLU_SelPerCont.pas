unit pro_fo_PLU_SelPerCont;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Frame_CheckListBox;

type
  TfoPLU_SelPerCont = class(TForm)
    frPer: TFrameCheckListBox;
    btnOk: TButton;
    btnCancel: TButton;
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfoPLU_SelPerCont.btnOkClick(Sender: TObject);
begin
  if frPer.ItemsSel.Count <> 2 then
     raise Exception.Create('Selecione dois períodos');
     
  ModalResult := mrOK;
end;

end.
