unit OpcoesDeImpressao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TDLG_OpcoesDeImpressao = class(TForm)
    GroupBox1: TGroupBox;
    rbPorIntervalo: TRadioButton;
    rbPorData: TRadioButton;
    GroupBox2: TGroupBox;
    rbCentralizado: TRadioButton;
    rbEsquerda: TRadioButton;
    btnOk: TButton;
    btnCanvel: TButton;
    GroupBox3: TGroupBox;
    cbEstatisticas: TCheckBox;
    GroupBox4: TGroupBox;
    _80Colunas: TRadioButton;
    _132Colunas: TRadioButton;
    NaoQuebrar: TRadioButton;
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
uses WinUtils;

{$R *.DFM}

procedure TDLG_OpcoesDeImpressao.btnOkClick(Sender: TObject);
begin
  close;
  ModalResult := mrOk;
end;

procedure TDLG_OpcoesDeImpressao.FormCreate(Sender: TObject);
begin
  AjustResolution(Self);
end;

end.
