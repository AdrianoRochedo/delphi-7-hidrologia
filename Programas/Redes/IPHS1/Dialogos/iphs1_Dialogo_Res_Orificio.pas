unit iphs1_Dialogo_Res_Orificio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, drEdit, ExtCtrls;

type
  Tiphs1_Form_Dialogo_Res_Orificio = class(TForm)
    Panel1: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    edCD: TdrEdit;
    edA: TdrEdit;
    edC: TdrEdit;
    btnCancelar: TBitBtn;
    Image: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    procedure btnCancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure Tiphs1_Form_Dialogo_Res_Orificio.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

end.
