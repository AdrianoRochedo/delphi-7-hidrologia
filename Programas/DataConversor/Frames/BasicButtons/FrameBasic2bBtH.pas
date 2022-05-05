unit FrameBasic2bBtH;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFrBasic2bBtH = class(TFrame)
    BtYes: TButton;
    BtNo: TButton;
    procedure BtYesClick(Sender: TObject);
    procedure BtNoClick(Sender: TObject);
  private
    FModalResult : TModalResult;
  public
    property Modalresult : TModalResult read FModalResult;
  end;

implementation

{$R *.dfm}

procedure TFrBasic2bBtH.BtYesClick(Sender: TObject);
begin
  FModalResult := mrOk;
end;

procedure TFrBasic2bBtH.BtNoClick(Sender: TObject);
begin
  FModalResult := mrNo;
end;

end.
