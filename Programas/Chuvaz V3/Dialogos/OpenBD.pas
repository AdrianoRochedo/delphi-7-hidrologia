unit OpenBD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DialogOpSv;

type
  TForm1 = class(TForm)
    FrameDialogOpSv1: TFrameDialogOpSv;
    procedure FrameDialogOpSv1Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ModuloComum, Principal, SearchKey, GerenteBD_Const;

{$R *.dfm}

procedure TForm1.FrameDialogOpSv1Button1Click(Sender: TObject);
var Dir : string;
begin
  Dir := FrameDialogOpSv1.DirectoryListBox1.Directory;
  Principal.DLG_Principal.OpenBd(Dir);
  SetValue(CFileConfig,CKeyDirBd,Dir);
  Close;
end;

end.
