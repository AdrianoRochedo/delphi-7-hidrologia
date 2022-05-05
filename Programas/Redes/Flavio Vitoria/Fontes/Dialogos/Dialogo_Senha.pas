unit Dialogo_Senha;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TPasswordDlg = class(TForm)
    Label1: TLabel;
    edSenha: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label2: TLabel;
    L_Reg: TLabel;
  private
    function getPass: integer;
    { Private declarations }
  public
    constructor Create(const Registro: string);
    class function getPassword(const Registro: string): integer;

    property Password : integer read getPass;
  end;

implementation

{$R *.dfm}

{ TPasswordDlg }

constructor TPasswordDlg.Create(const Registro: string);
begin
  inherited Create(nil);
  L_Reg.Caption := Registro;
end;

function TPasswordDlg.getPass(): integer;
begin
  result := strToIntDef(edSenha.Text, 0);
end;

class function TPasswordDlg.getPassword(const Registro: string): integer;
var d: TPasswordDlg;
begin
  d := TPasswordDlg.Create(Registro);

  if d.ShowModal() = mrOK then
     result := d.Password
  else
     result := 0;

  d.Free();
end;

end.
 
