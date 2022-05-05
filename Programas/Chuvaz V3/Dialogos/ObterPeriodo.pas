unit ObterPeriodo;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, OvcBase, OvcEF, OvcPB, OvcPF, Buttons, Mask, ch_Tipos;

type
  TDLG_ObterPeriodo = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    btnFechar: TBitBtn;
    btnOk: TBitBtn;
    DI: TMaskEdit;
    DF: TMaskEdit;
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FInfo: TDSInfo;
  public
    constructor Create(Info: TDSInfo);
  end;

implementation
uses CH_CONST, WinUtils;

{$R *.DFM}

constructor TDLG_ObterPeriodo.Create(Info: TDSInfo);
begin
  Inherited Create(nil);
  FInfo := Info;
end;

procedure TDLG_ObterPeriodo.btnOkClick(Sender: TObject);
var Ini, Fim: TDateTime;
    C       : TWinControl;
begin
  Try
    if DI.EditMask = cMMYYYY then
       begin
       C := DI; ini := strToDate('01/' + DI.Text);
       C := DF; fim := strToDate('01/' + DF.Text);
       end
    else
       begin
       C := DI; ini := strToDate(DI.Text);
       C := DF; fim := strToDate(DF.Text);
       end;
  Except
    MessageDLG('Data Inválida', mtError, [mbOK], 0);
    C.SetFocus;
    Exit;
  End;
{
  If (ini = 0) or (fim = 0) Then
     MessageDLG('É necessário a entrada das duas datas', mtError, [mbOk], 0)
  Else
}
  If (fim < ini) Then
     MessageDLG('A data final não pode ser inferior a data inicial', mtError, [mbOk], 0)
  Else
  If ini < FInfo.DataInicial Then
     MessageDLG('Não existem dados para períodos anteriores a ' +
                 DateToStr(FInfo.DataInicial),
                 mtError, [mbOk], 0)
  Else
     Begin
     Close;
     ModalResult := mrOk;
     End;
end;

procedure TDLG_ObterPeriodo.FormCreate(Sender: TObject);
begin
  AjustResolution(Self);
end;

end.
