unit iphs1_Dialogo_Derivacao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, iphs1_Dialogo_Base, drEdit, Menus;

type
  Tiphs1_Form_Dialogo_Derivacao = class(Tiphs1_Form_Dialogo_Base)
    Panel6: TPanel;
    Panel7: TPanel;
    rbDer: TRadioButton;
    rbDH: TRadioButton;
    Panel11: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel15: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel16: TPanel;
    edCPL: TdrEdit;
    edCPR: TdrEdit;
    edCPD: TdrEdit;
    edCDL: TdrEdit;
    edCDR: TdrEdit;
    edCDD: TdrEdit;
    paDer: TPanel;
    paDH: TPanel;
    Panel19: TPanel;
    edPerc: TdrEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure rbDerClick(Sender: TObject);
    procedure rbDHClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
uses hidro_Procs;

{$R *.DFM}

procedure Tiphs1_Form_Dialogo_Derivacao.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If key = VK_F1 then
     MostrarHTML('EdicaoDosObjetos.htm#DER');
end;

procedure Tiphs1_Form_Dialogo_Derivacao.rbDerClick(Sender: TObject);
begin
  paDer.Enabled := rbDer.Checked;
  rbDH.Checked := not rbDer.Checked;
end;

procedure Tiphs1_Form_Dialogo_Derivacao.rbDHClick(Sender: TObject);
begin
  paDH.Enabled := rbDH.Checked;
  rbDer.Checked := not rbDH.Checked;
end;

procedure Tiphs1_Form_Dialogo_Derivacao.FormShow(Sender: TObject);
begin
  if rbDer.Checked then rbDerClick(nil) else rbDHClick(nil);
end;

end.
