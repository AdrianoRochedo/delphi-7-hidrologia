unit FrListBox;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls;

type
  TFrameListBox = class(TFrame)
    ListBox: TListBox;
    PMListBox: TPopupMenu;
    Remover1: TMenuItem;
    procedure Remover1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrameListBox.Remover1Click(Sender: TObject);
begin
  ListBox.Items.Delete(ListBox.ItemIndex);
end;

end.
