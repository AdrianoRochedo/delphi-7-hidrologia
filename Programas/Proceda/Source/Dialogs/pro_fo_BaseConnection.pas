unit pro_fo_BaseConnection;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, drEdit, ExtCtrls;

type
  TfoBaseConnection = class(TForm)
    Label1: TLabel;
    edID: TdrEdit;
    btnOk: TButton;
    btnCancel: TButton;
    Bevel1: TBevel;
  private
    function getID: string;
    { Private declarations }
  public
    property ID : string read getID;
  end;

implementation

{$R *.dfm}

{ TfoBaseConnection }

function TfoBaseConnection.getID: string;
begin
  result := edID.AsString;
end;

end.
