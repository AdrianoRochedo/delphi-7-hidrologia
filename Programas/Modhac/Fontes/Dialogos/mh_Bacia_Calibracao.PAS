unit mh_Bacia_Calibracao;

interface

uses Windows, Classes, Graphics, Forms, Controls, Buttons,
     StdCtrls, ExtCtrls, mh_Classes, drEdit;

type
  TDLG_Ctrl_Calibracao = class(TForm)
    Bevel1: TBevel;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Cb_FOPT: TComboBox;
    Panel12: TPanel;
    Panel13: TPanel;
    btnFechar: TBitBtn;
    OKBtn: TBitBtn;
    Pf_NSTEP: TdrEdit;
    Pf_MAXIT: TdrEdit;
    Pf_IPRINT: TdrEdit;
    Pf_FTOL: TdrEdit;
    Pf_QREF1: TdrEdit;
    Pf_QREF2: TdrEdit;
    Pf_BI: TdrEdit;
    Pf_BS: TdrEdit;
    procedure CancelBtnClick(Sender: TObject);
    procedure Pf_MAXITxExit(Sender: TObject);
    procedure Aceitar(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GlobalChange(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure OKBtnClick(Sender: TObject);
  private
    FpDados:  Pointer;
    Modificado :  Boolean;
    Changing : Boolean;
    Procedure SetDados(pDados: Pointer);
  public
    SubBaciaNode: TmhSubBaciaNode;
    Property Dados: Pointer Write SetDados;
  end;

var
  DLG_Ctrl_Calibracao: TDLG_Ctrl_Calibracao;

implementation
Uses mh_TCs,
     Assist,
     Dialogs;

{$R *.DFM}

Procedure TDLG_Ctrl_Calibracao.SetDados(pDados: Pointer);
Begin
  FpDados := pDados;
  Changing := False;
  With pTDadosDaBacia(FpDados)^.ExecDados do
    Begin
    pf_NStep.AsInteger  :=  NStep;
    pf_MaxIT.AsInteger  :=  MaxIT;
    Pf_IPRINT.AsInteger :=  MaxIT + 1;
    pf_FTol.AsFloat     :=  FTol;
    cb_FOpt.ItemIndex   :=  FOpt - 1;
    pf_QRef1.AsFloat    :=  QRef1;
    pf_QRef2.AsFloat    :=  QRef2;
    pf_BI.AsFloat       :=  BI;
    pf_BS.AsFloat       :=  BS;
    End;
  Changing := False;
End;


procedure TDLG_Ctrl_Calibracao.CancelBtnClick(Sender: TObject);
begin
  SetDados(FpDados);
end;

procedure TDLG_Ctrl_Calibracao.Pf_MAXITxExit(Sender: TObject);
begin
  pf_IPrint.AsInteger := pf_MaxIT.AsInteger + 1;
end;

procedure TDLG_Ctrl_Calibracao.Aceitar(Sender: TObject);
begin
  With pTDadosDaBacia(FpDados)^.ExecDados do
    Begin
    NStep  := pf_NStep.AsInteger;
    MaxIT  := pf_MaxIT.AsInteger;
    Iprint := Pf_IPRINT.AsInteger;
    FTol   := pf_FTol.AsFloat;   
    FOpt   := cb_FOpt.ItemIndex + 1;
    QRef1  := pf_QRef1.AsFloat;  
    QRef2  := pf_QRef2.AsFloat;  
    BI     := pf_BI.AsFloat;     
    BS     := pf_BS.AsFloat;     
    End;
  Modificado := False;
  SubBaciaNode.SubBacia.Modified := True;
  {
  mhApplication.Assistant.Lines.Clear;
  mhApplication.Assistant.Title.Caption := 'Aviso';
  mhApplication.Assistant.Lines.Add(msgDTModific);
  mhApplication.Assistant.UseCursorPos := True;
  mhApplication.Assistant.Active(0,0);
  }
end;

procedure TDLG_Ctrl_Calibracao.FormCreate(Sender: TObject);
begin
  Cb_FOPT.ItemIndex := 0;
end;

procedure TDLG_Ctrl_Calibracao.FormShow(Sender: TObject);
begin
  Modificado := False;
end;

procedure TDLG_Ctrl_Calibracao.GlobalChange(Sender: TObject);
begin
  Modificado := True;
end;

procedure TDLG_Ctrl_Calibracao.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TDLG_Ctrl_Calibracao.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  mhApplication.Assistant.Hide;
end;

procedure TDLG_Ctrl_Calibracao.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  If Modificado Then
     If MessageDLG(dlgModificGeral, mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
        Aceitar(nil);
  CanClose := True;
end;

procedure TDLG_Ctrl_Calibracao.OKBtnClick(Sender: TObject);
var Inutil: Boolean;
begin
  FormCloseQuery(Sender, Inutil);
end;

end.
