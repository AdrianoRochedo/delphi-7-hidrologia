unit FrameAbout;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, SHDocVw, ExtCtrls;

type
  TFrame1 = class(TFrame)
    Panel1: TPanel;
    WebBrowser1: TWebBrowser;
  private
    { Private declarations }
  public
    procedure Open(const Url: string);
  end;



implementation

{$R *.dfm}

procedure TFrame1.Open(const Url: string);
begin
  WebBrowser1.Navigate(Url);
end;


end.
