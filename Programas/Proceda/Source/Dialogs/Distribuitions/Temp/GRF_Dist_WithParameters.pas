unit GRF_Dist_WithParameters;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GRF_ProbDist, StdCtrls, drEdit, Buttons, ExtCtrls;

type
  TfoGRF_Dist_WithParameters = class(TfoGRF_ProbDist)
    gbPars: TGroupBox;
    R1: TRadioButton;
    R2: TRadioButton;
    R3: TRadioButton;
    R4: TRadioButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
