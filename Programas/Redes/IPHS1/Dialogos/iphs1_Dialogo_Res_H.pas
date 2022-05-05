unit iphs1_Dialogo_Res_H;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, AxCtrls, OleCtrls, vcf1,
  StdCtrls, Buttons, drEdit;

type
  Tiphs1_Form_Dialogo_Res_H = class(TForm)
    Panel4: TPanel;
    Panel1: TPanel;
    btnCancelar: TBitBtn;
    Panel2: TPanel;
    Panel3: TPanel;
    Tab: TF1Book;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    edNPT: TdrEdit;
    edCD: TdrEdit;
    edLV: TdrEdit;
    edCCV: TdrEdit;
    procedure edNPTExit(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure TabExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    NumOps: Word;
  end;

implementation

{$R *.DFM}

procedure Tiphs1_Form_Dialogo_Res_H.edNPTExit(Sender: TObject);
begin
  if edNPT.AsInteger > 15 then edNPT.AsInteger := 15 else
  if edNPT.AsInteger < 1  then edNPT.AsInteger := 1;
  Tab.MaxRow := edNPT.AsInteger;
end;

procedure Tiphs1_Form_Dialogo_Res_H.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure Tiphs1_Form_Dialogo_Res_H.TabExit(Sender: TObject);
begin
  Tab.EndEdit;
end;

procedure Tiphs1_Form_Dialogo_Res_H.FormShow(Sender: TObject);
begin
  if edNPT.AsInteger > 0 then
     edNPTExit(Sender)
end;

end.
