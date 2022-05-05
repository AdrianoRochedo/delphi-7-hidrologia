unit FormAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrameAbout;

type
  TFAbout = class(TForm)
    FrameAbout: TFrame1;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAbout: TFAbout;

implementation
{$R *.dfm}

procedure TFAbout.FormCreate(Sender: TObject);
begin
  FrameAbout.Open(ExtractFilePath(Application.ExeName) + 'help\about.html');
end;

end.
