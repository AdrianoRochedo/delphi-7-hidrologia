unit cd_Frame_Sensibilidade;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, drEdit;

type
  TfrSensibilidade = class(TFrame)
    X: TdrEdit;
    Label1: TLabel;
    y: TdrEdit;
    Label2: TLabel;
    z: TdrEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    btnCalc: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
