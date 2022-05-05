unit mh_Bacia_Simulacao;

interface

uses Windows, Classes, Graphics, Forms, Controls, Buttons,
     StdCtrls, ExtCtrls, drEdit,
     mh_Classes;

type
  TDLG_Ctrl_Simulacao = class(TForm)
    btnCancel: TBitBtn;
    btnHelp: TBitBtn;
    Bevel1: TBevel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    btnFechar: TBitBtn;
    btnOK: TBitBtn;
    Pf_IQS: TdrEdit;
    Pf_RSP: TdrEdit;
    Pf_RSS: TdrEdit;
    Pf_RSB: TdrEdit;
    Pf_TS: TdrEdit;
    Pf_TB: TdrEdit;
    procedure Aceitar(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure GlobalChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnOKClick(Sender: TObject);
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
  DLG_Ctrl_Simulacao: TDLG_Ctrl_Simulacao;

implementation
Uses Assist,
     Dialogs,
     mh_TCs;

{$R *.DFM}

Procedure TDLG_Ctrl_Simulacao.SetDados(pDados: Pointer);
Begin
  FpDados := pDados;
  Changing := False;
  With pTDadosDaBacia(FpDados)^.ExecDados do
    Begin
    pf_IQS.AsInteger  :=  IQS;
    pf_RSP.AsFloat    :=  RSP;
    pf_RSS.AsFloat    :=  RSS;
    pf_RSB.AsFloat    :=  RSB;
    pf_TS.AsFloat     :=  TS;
    pf_TB.AsFloat     :=  TB;
    End;
  Changing := True;
End;

procedure TDLG_Ctrl_Simulacao.Aceitar(Sender: TObject);
begin
  With pTDadosDaBacia(FpDados)^.ExecDados do
    Begin
    IQS := pf_IQS.AsInteger;
    RSP := pf_RSP.AsFloat;
    RSS := pf_RSS.AsFloat;
    RSB := pf_RSB.AsFloat;
    TS  := pf_TS.AsFloat;
    TB  := pf_TB.AsFloat;
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

procedure TDLG_Ctrl_Simulacao.btnCancelClick(Sender: TObject);
begin
  SetDados(FpDados);
end;

procedure TDLG_Ctrl_Simulacao.GlobalChange(Sender: TObject);
begin
  Modificado := True;
end;

procedure TDLG_Ctrl_Simulacao.FormShow(Sender: TObject);
begin
  Modificado := False;
end;

procedure TDLG_Ctrl_Simulacao.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TDLG_Ctrl_Simulacao.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  mhApplication.Assistant.Hide;
end;

procedure TDLG_Ctrl_Simulacao.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  If Modificado Then
     If MessageDLG(dlgModificGeral, mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
        Aceitar(nil);
  CanClose := True;
end;

procedure TDLG_Ctrl_Simulacao.btnOKClick(Sender: TObject);
var Inutil: Boolean;
begin
  FormCloseQuery(Sender, Inutil);
end;

end.
