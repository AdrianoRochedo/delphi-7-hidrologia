unit iphs1_Dialogo_Res_Vertedor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, drEdit, ExtCtrls;

type
  Tiphs1_Form_Dialogo_Res_Vertedor = class(TForm)
    Panel1: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    edCD: TdrEdit;
    edL: TdrEdit;
    edCC: TdrEdit;
    btnCancelar: TBitBtn;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    procedure btnCancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;                                                         

implementation

{$R *.dfm}

procedure Tiphs1_Form_Dialogo_Res_Vertedor.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

end.
