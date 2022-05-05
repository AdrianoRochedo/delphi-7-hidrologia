unit UnitFormWhatDo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, {FrameBasic2BtH, FrListBox,} StdCtrls, ExtCtrls;

type
  TFormWhatToDo = class(TForm)
    LEdFieldOld: TLabeledEdit;
    LEdValueOld: TLabeledEdit;
    LBTables: TListBox;
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    LEdNewValue: TLabeledEdit;
    BtAply: TButton;
    Label3: TLabel;
    procedure FrBasic2BtH1BtOkClick(Sender: TObject);
    procedure FrBasic2BtH1BtCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormWhatToDo: TFormWhatToDo;

implementation

{$R *.dfm}

procedure TFormWhatToDo.FrBasic2BtH1BtOkClick(Sender: TObject);
begin
//  FrBasic2BtH1.BtOkClick(Sender);
//  ModalResult := FrBasic2BtH1.Modalresult;
end;

procedure TFormWhatToDo.FrBasic2BtH1BtCancelClick(Sender: TObject);
begin
//  FrBasic2BtH1.BtCancelClick(Sender);
//  ModalResult := FrBasic2BtH1.Modalresult;
end;

end.
