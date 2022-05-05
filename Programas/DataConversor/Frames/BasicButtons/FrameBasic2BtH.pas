unit FrameBasic2BtH;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFrBasic2BtH = class(TFrame)
    BtOk: TButton;
    BtCancel: TButton;
    procedure BtOkClick(Sender: TObject);
    procedure BtCancelClick(Sender: TObject);
  end;

implementation

{$R *.dfm}

procedure TFrBasic2BtH.BtOkClick(Sender: TObject);
begin
  (Parent as TForm).ModalResult := mrOk;
end;

procedure TFrBasic2BtH.BtCancelClick(Sender: TObject);
begin
  (Parent as TForm).ModalResult := mrCancel;
end;

end.
