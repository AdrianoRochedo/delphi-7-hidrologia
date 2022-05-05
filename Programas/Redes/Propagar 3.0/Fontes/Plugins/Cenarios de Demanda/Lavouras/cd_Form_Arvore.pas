unit cd_Form_Arvore;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Frame_TreeViewObjects, cd_Classes, Menus;

type
  TfoMain = class(TForm)
    frTree: TTreeViewObjects;
    procedure FormShow(Sender: TObject);
  private
    FCrop: TCrop;
  public
    constructor Create(Crop: TCrop);
  end;

implementation

{$R *.dfm}

{ TfoMain }

constructor TfoMain.Create(Crop: TCrop);
begin
  inherited Create(nil);
  FCrop := Crop;
end;

procedure TfoMain.FormShow(Sender: TObject);
begin
  FCrop.ShowInTree(frTree.Tree);
end;

end.
