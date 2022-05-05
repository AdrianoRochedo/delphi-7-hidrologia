unit iphs1_Dialogo_SB_TCV_HU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AxCtrls, OleCtrls, vcf1, ExtCtrls,
  drEdit;

type
  Tiphs1_Form_Dialogo_SB_TCV_HU = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Panel4: TPanel;
    edNPT: TdrEdit;
    Panel2: TPanel;
    Panel3: TPanel;
    Tab: TF1Book;
    procedure edNPTExit(Sender: TObject);
    procedure TabExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure Tiphs1_Form_Dialogo_SB_TCV_HU.edNPTExit(Sender: TObject);
begin
  if edNPT.AsInteger < 1  then edNPT.AsInteger := 1;
  Tab.MaxRow := edNPT.AsInteger;
  Tab.SetActiveCell(1, 1);
end;

procedure Tiphs1_Form_Dialogo_SB_TCV_HU.TabExit(Sender: TObject);
begin
  Tab.EndEdit;
end;

end.
