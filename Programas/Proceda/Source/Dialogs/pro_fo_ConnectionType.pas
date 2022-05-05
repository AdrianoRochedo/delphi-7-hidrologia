unit pro_fo_ConnectionType;

{
  Possiveis tipos de coneccao:
    Access
    Excel
    Firebird-1.0
    Firebird-1.5
    Interbase-5
    Interbase-6
    msSQL
    mySQL
    mySQL-3.20
    mySQL-3.23
    mySQL-4.0
    Oracle
    Paradox\DBase
    PostgreSQL
    PostgreSQL-6.5
    PostgreSQL-7.2
    Sybase
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfoConnectionType = class(TForm)
    Bevel: TBevel;
    btnOK: TButton;
    btnCancel: TButton;
    cbCT: TComboBox;
    Label1: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    function getConnType: string;
    { Private declarations }
  public
    class function getConnectionType(): string;
    property ConnectionType : string read getConnType;
  end;

implementation

{$R *.dfm}

{ TForm2 }

function TfoConnectionType.getConnType(): string;
begin
  result := cbCT.Text;
end;

procedure TfoConnectionType.btnOKClick(Sender: TObject);
begin
  if getConnType() = '' then
     raise Exception.Create('Escolha um tipo de conecção');
  ModalResult := mrOK;
end;

procedure TfoConnectionType.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

class function TfoConnectionType.getConnectionType(): string;
var d: TfoConnectionType;
begin
  d := TfoConnectionType.Create(nil);
  if d.ShowModal = mrOk then
     result := d.ConnectionType
  else
     result := '';
end;

end.
