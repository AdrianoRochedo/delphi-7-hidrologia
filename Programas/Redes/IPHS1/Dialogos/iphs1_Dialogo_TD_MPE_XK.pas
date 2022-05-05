unit iphs1_Dialogo_TD_MPE_XK;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, AxCtrls, OleCtrls, vcf1, drEdit;

type
  Tiphs1_Form_Dialogo_TD_MPE_XK = class(TForm)
    btnOk: TBitBtn;
    Panel6: TPanel;
    edNPT: TdrEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Tab: TF1Book;
    p3: TPanel;
    edCFJ: TdrEdit;
    p2: TPanel;
    edCFM: TdrEdit;
    p4: TPanel;
    edAC: TdrEdit;
    Panel4: TPanel;
    procedure edNPTExit(Sender: TObject);
    procedure TabExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure Tiphs1_Form_Dialogo_TD_MPE_XK.edNPTExit(Sender: TObject);
begin
  if edNPT.AsInteger > 50 then edNPT.AsInteger := 50 else
  if edNPT.AsInteger < 1  then edNPT.AsInteger := 1;
  Tab.MaxRow := edNPT.AsInteger;
end;

procedure Tiphs1_Form_Dialogo_TD_MPE_XK.TabExit(Sender: TObject);
begin
  Tab.EndEdit;
end;

end.
