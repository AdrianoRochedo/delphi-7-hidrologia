unit iphs1_Dialogo_SB_TCV_CLARK;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AxCtrls, OleCtrls, vcf1, ExtCtrls,
  drEdit;

type
  Tiphs1_Form_Dialogo_SB_TCV_CLARK = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Panel4: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Tab: TF1Book;
    Panel1: TPanel;
    Label1: TLabel;
    Panel5: TPanel;
    Label2: TLabel;
    Panel6: TPanel;
    edKS: TdrEdit;
    edXN: TdrEdit;
    edDB: TdrEdit;
    edNPT: TdrEdit;
    procedure edNPTxExit(Sender: TObject);
    procedure TabExit(Sender: TObject);
    procedure edit_Change(Sender: TObject);
  private
    FTC: Real;
  public
    property TC : Real read FTC write FTC;
  end;

implementation
uses SysUtilsEx;

{$R *.DFM}

procedure Tiphs1_Form_Dialogo_SB_TCV_CLARK.edNPTxExit(Sender: TObject);
begin
  if edNPT.AsInteger < 1  then edNPT.AsInteger := 1;
  Tab.MaxRow := edNPT.AsInteger;
  Tab.SetActiveCell(1, 1);
end;

procedure Tiphs1_Form_Dialogo_SB_TCV_CLARK.TabExit(Sender: TObject);
begin
  Tab.EndEdit;
end;

procedure Tiphs1_Form_Dialogo_SB_TCV_CLARK.edit_Change(Sender: TObject);
var XN, XK: Real;
begin
  XK := StrToFloatDef(edKS.AsString, 0);
  XN := StrToFloatDef(edXN.AsString, 0);
  edDB.Enabled := (TC = 0) or (XK = 0);
  edNPT.Enabled := (XN = 0);
  Tab.Enabled := edNPT.Enabled;
end;

end.
