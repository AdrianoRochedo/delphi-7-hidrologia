unit GRF_Dist_TwoParameters;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GRF_Dist_OneParameter, FrameGRF_ParDistrib, StdCtrls, Buttons,
  drEdit, ExtCtrls;

type
  TfoGRF_Dist_TwoParameters = class(TfoGRF_Dist_OneParameter)
    laP2: TLabel;
    edP2: TdrEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
