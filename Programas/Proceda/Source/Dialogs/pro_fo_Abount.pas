unit pro_fo_Abount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pro_fr_Abount;

type
  TfoAbout = class(TForm)
    FrameAbout: TfrAbout;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
{$R *.dfm}

procedure TfoAbout.FormCreate(Sender: TObject);
begin
  FrameAbout.Open(ExtractFilePath(Application.ExeName) + 'help\about.html');
end;

end.
