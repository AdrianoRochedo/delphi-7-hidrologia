unit pro_fo_ETP_Media;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons,
  Mask, drEdit;

type
  TDLG_ETP_Media = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Bevel1: TBevel;
    btnHelp: TBitBtn;
    btnFechar: TBitBtn;
    btnOk: TBitBtn;
    DI: TMaskEdit;
    DF: TMaskEdit;
    Valor: TdrEdit;
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    sAno : String;
    Procedure SetAnoBase(Ano: Word);
  public
    DataIni, DataFim: TDateTime;
    Property AnoBase: Word Write SetAnoBase;
  end;

implementation
uses SysUtilsEx, WinUtils;

{$R *.DFM}

Procedure TDLG_ETP_Media.SetAnoBase(Ano: Word);
Begin
  sAno := IntToStr(Ano);
End;

procedure TDLG_ETP_Media.btnOkClick(Sender: TObject);
var d: TDateTime;
begin
  Try
    ActiveControl := DI;
    DataIni := StrToDate(DI.Text + '/' + sAno);

    ActiveControl := DF;
    DataFim := StrToDate(DF.Text + '/' + sAno);
  Except
    Raise Exception.Create('Data inválida');
  End;

  Try
    ActiveControl := Valor;
    StrToFloat(AllTrim(Valor.Text));
  Except
    Raise Exception.Create('Valor Inválido');
  End;

  If DataIni > DataFim Then
     Begin
     d := DataFim;
     DataFim := DataIni;
     DataIni := d;
     End;

  ModalResult := mrOk;   
end;

procedure TDLG_ETP_Media.FormCreate(Sender: TObject);
begin
  Valor.Text := Format('0%s0', [DecimalSeparator]);
  AjustResolution(Self);
end;

end.
