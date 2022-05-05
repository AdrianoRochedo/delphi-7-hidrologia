unit GRF_Dist_ThreeParameters;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GRF_Dist_TwoParameters, FrameGRF_ParDistrib, StdCtrls, Buttons,
  drEdit, ExtCtrls;

type
  TfoGRF_Dist_ThreeParameters = class(TfoGRF_Dist_TwoParameters)
    laP3: TLabel;
    edP3: TdrEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
