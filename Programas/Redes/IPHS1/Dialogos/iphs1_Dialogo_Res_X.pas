unit iphs1_Dialogo_Res_X;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  Tiphs1_Form_Dialogo_Res_X = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    procedure CriarEstruturas(Num: Integer);
  public
    { Public declarations }
  end;

var iphs1_Form_Dialogo_Res_X: Tiphs1_Form_Dialogo_Res_X;

implementation
uses Frame_Res_X;

{$R *.dfm}

procedure Tiphs1_Form_Dialogo_Res_X.CriarEstruturas(Num: Integer);
var i, t: Integer;
    f: Tiphs1_Frame_Res_X;
begin
  t := 0;
  for i := 1 to Num do
    begin
    f := Tiphs1_Frame_Res_X.Create(self);
    f.Top := t;
    f.Name := 'f' + IntToStr(i);
    f.Parent := self;
    inc(t, f.Height);
    end;
end;

procedure Tiphs1_Form_Dialogo_Res_X.FormCreate(Sender: TObject);
begin
  CriarEstruturas(5);
end;

end.
