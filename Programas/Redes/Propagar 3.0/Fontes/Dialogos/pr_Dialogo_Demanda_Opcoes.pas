unit pr_Dialogo_Demanda_Opcoes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TprDialogo_OpcoesDeDemanda = class(TForm)
    cbSincronizar: TCheckBox;
    btnOk: TBitBtn;
    cbTVU: TCheckBox;
    cbTUD: TCheckBox;
    cbTFI: TCheckBox;
    procedure btnOkClick(Sender: TObject);
    procedure cbSincronizarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  prDialogo_OpcoesDeDemanda: TprDialogo_OpcoesDeDemanda;

implementation

{$R *.DFM}

procedure TprDialogo_OpcoesDeDemanda.btnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TprDialogo_OpcoesDeDemanda.cbSincronizarClick(Sender: TObject);
begin
  cbTVU.Enabled := cbSincronizar.Checked;
  cbTUD.Enabled := cbSincronizar.Checked;
  cbTFI.Enabled := cbSincronizar.Checked;
end;

end.
