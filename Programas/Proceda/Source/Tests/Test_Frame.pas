unit Test_Frame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pro_fr_IntervalsOfStations, StdCtrls, ExtCtrls;

type
  TTestFrame = class(TForm)
    frame: TfrIntervalsOfStations;
    Bevel1: TBevel;
    btnClose: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
