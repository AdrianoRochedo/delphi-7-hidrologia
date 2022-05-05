unit mh_OpcoesGerais;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, FileCtrl;

type
  TDLG_OpcoesGerente = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    edProjectName: TEdit;
    Panel1: TPanel;
    Bevel1: TBevel;
    cbDelOutPutFiles: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

end.
