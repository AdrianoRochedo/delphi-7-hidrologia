unit PLU_Opcoes;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Mask, drEdit;

type
  TdlgPLU_Opcoes = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Bevel1: TBevel;
    Label1: TLabel;
    R1: TRadioButton;
    R2: TRadioButton;
    R3: TRadioButton;
    R4: TRadioButton;
    R5: TRadioButton;
    R0: TRadioButton;
    R6: TRadioButton;
    Dias: TdrEdit;
    Label2: TLabel;
    edNVL: TdrEdit;
    ValorIndicado: TdrEdit;
    procedure RsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FItemIndex : Integer;
    Procedure SetItemIndex(Value: Integer);
  public
    Property ItemIndex: Integer Read FItemIndex Write SetItemIndex;
  end;

implementation
uses SysUtils, ch_Const, WinUtils;

{$R *.DFM}

Procedure TdlgPLU_Opcoes.SetItemIndex(Value: Integer);
begin
  Try
    TRadioButton(FindComponent('R' + IntToStr(Value))).Checked := True;
    FItemIndex := Value;
  Except
    R0.Checked := True;
    FItemIndex := 0;
  End;
end;

procedure TdlgPLU_Opcoes.RsClick(Sender: TObject);
begin
  ValorIndicado.Enabled := R6.Checked;
  FItemIndex := StrToInt(TRadioButton(Sender).Name[2]);
end;

procedure TdlgPLU_Opcoes.FormCreate(Sender: TObject);
begin
  AjustResolution(Self);
  FItemIndex := 0;
  //ValorIndicado.EditMask := Format('999%s99;1; ', [DecimalSeparator]);
  //ValorIndicado.Text     := Format('000%s00', [DecimalSeparator]);
end;

procedure TdlgPLU_Opcoes.FormShow(Sender: TObject);
begin
  Dias.AsInteger := CDEFAULTDAYSFORFAIL;
end;

end.
