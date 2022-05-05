unit mh_SPLASH;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, jpeg;

type
  TSplashForm = class(TForm)
    Panel1: TPanel;
    Bevel1: TBevel;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Image1: TImage;
    Image2: TImage;
  end;

var
  SplashForm: TSplashForm;

implementation

{$R *.DFM}

end.
