unit fo_SkinDist_TwoParameters;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fo_SkinDist_OneParameter, StdCtrls, Buttons, drEdit, ExtCtrls;

type
  TfoSkinDist_TwoParameters = class(TfoSkinDist_OneParameter)
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
