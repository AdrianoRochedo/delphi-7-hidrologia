unit cd_Form_TransferirDados;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CheckLst, cd_ClassesBase, cd_Classes;

type
  TfoTransferirDados = class(TForm)
    Label1: TLabel;
    lb1: TCheckListBox;
    Label2: TLabel;
    lb2: TCheckListBox;
    Bevel1: TBevel;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
  private
    FCrop: TCrop;
  public
    constructor Create(Crop: TCrop);
  end;

implementation
uses MessageManager;

{$R *.dfm}

constructor TfoTransferirDados.Create(Crop: TCrop);
begin
  inherited Create(nil);
  FCrop := Crop;
end;

procedure TfoTransferirDados.FormShow(Sender: TObject);
var L: TList;
    i: integer;
    x: TCrop;
begin
  L := TList.Create();
  getMessageManager.SendMessage(UM_Get_Lavouras, [FCrop, L]);
  for i := 0 to L.Count-1 do
    begin
    x := TCrop(L[i]);
    lb2.AddItem(x.Name, x);
    end;
  L.Free();  
end;

end.
