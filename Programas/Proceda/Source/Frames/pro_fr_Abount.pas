unit pro_fr_Abount;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, SHDocVw, ExtCtrls;

type
  TfrAbout = class(TFrame)
    WebBrowser: TWebBrowser;
  private
    { Private declarations }
  public
    procedure Open(const Url: string);
  end;

implementation

{$R *.dfm}

procedure TfrAbout.Open(const Url: string);
begin
  WebBrowser.Navigate(Url);
end;

end.
