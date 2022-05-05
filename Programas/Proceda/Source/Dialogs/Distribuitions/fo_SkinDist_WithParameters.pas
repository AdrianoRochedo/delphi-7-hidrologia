unit fo_SkinDist_WithParameters;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fo_SkinDistBase, StdCtrls, drEdit, Buttons, ExtCtrls;

type
  TfoSkinDist_WithParameters = class(TfoSkinDistBase)
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
