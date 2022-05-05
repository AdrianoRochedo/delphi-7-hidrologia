unit iphs1_Dialogo_SB_TCV_SCS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, drEdit;

type
  Tiphs1_Form_Dialogo_SB_TCV_SCS = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Panel2: TPanel;
    edCN: TdrEdit;
    btnCalcular: TButton;
    procedure btnCalcularClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    h: Cardinal;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure Tiphs1_Form_Dialogo_SB_TCV_SCS.btnCalcularClick(Sender: TObject);
var F: function(Validar: Boolean): Real;
begin
  if h <> 0 then
     begin
     @F := GetProcAddress(h, 'ObterCN');
     if @F <> nil then edCN.AsFloat := F(True);
     end;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV_SCS.FormCreate(Sender: TObject);
begin
  h := LoadLibrary('CN.DLL');
end;

procedure Tiphs1_Form_Dialogo_SB_TCV_SCS.FormDestroy(Sender: TObject);
begin
  if h <> 0 then FreeLibrary(h);
end;

end.
