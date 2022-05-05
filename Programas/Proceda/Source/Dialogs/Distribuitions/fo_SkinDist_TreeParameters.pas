unit fo_SkinDist_TreeParameters;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fo_SkinDist_TwoParameters, StdCtrls, ExtCtrls, drEdit;

type
  TfoSkinDist_TreeParameters = class(TfoSkinDist_TwoParameters)
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
