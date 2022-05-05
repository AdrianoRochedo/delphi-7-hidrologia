unit iphs1_Dialogo_Res_TCV;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, AxCtrls, OleCtrls, vcf1,
  StdCtrls, Buttons, drEdit;

type
  Tiphs1_Form_Dialogo_Res_TCV = class(TForm)
    Panel4: TPanel;
    Panel1: TPanel;
    btnCancelar: TBitBtn;
    Panel2: TPanel;
    Panel3: TPanel;
    Tab: TF1Book;
    edNPT: TdrEdit;
    edCMR: TdrEdit;
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

procedure Tiphs1_Form_Dialogo_Res_TCV.edNPTExit(Sender: TObject);
begin
  if edNPT.AsInteger > 150 then edNPT.AsInteger := 150 else
  if edNPT.AsInteger < 1  then edNPT.AsInteger := 1;
  Tab.MaxRow := edNPT.AsInteger;
end;

procedure Tiphs1_Form_Dialogo_Res_TCV.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure Tiphs1_Form_Dialogo_Res_TCV.TabExit(Sender: TObject);
begin
  Tab.EndEdit;
end;

procedure Tiphs1_Form_Dialogo_Res_TCV.FormShow(Sender: TObject);
begin
  if edNPT.AsInteger > 0 then
     edNPTExit(Sender)
end;

end.
