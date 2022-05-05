unit mh_Bacia_Parametros;

interface
uses Windows, Classes, Graphics, Forms, Controls,
     Buttons, StdCtrls, ExtCtrls, Dialogs, Menus, Messages,
     mh_TCs, mh_Classes,
     cxSSheet,
     SpreadSheetBook_Frame,
     SysUtils, Assist, SysUtilsEx, ClipBrd;

type
  TDLG_Parametros = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    btnCalibracao: TBitBtn;
    Bevel1: TBevel;
    Menu: TPopupMenu;
    btnSimulacao: TBitBtn;
    btnFechar: TBitBtn;
    PanelInfo: TPanel;
    btnOpcoes: TSpeedButton;
    fmPlanilha: TSpreadSheetBookFrame;
    procedure btnCalibracaoClick(Sender: TObject);
    procedure btnSimulacaoClick(Sender: TObject);
    procedure ModoExecucaoClick(Sender: TObject);
    procedure Aceitar(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure GlobalChange(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Menu_HistoricoClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure btnOpcoesClick(Sender: TObject);
    procedure fmPlanilhaMenu_AbrirClick(Sender: TObject);
    procedure fmPlanilhaMenu_ColarClick(Sender: TObject);
    procedure fmPlanilhaMenu_SalvarClick(Sender: TObject);
    procedure Menu_EvolucaoClick(Sender: TObject);
    procedure fmPlanilhaSSClick(Sender: TObject);
    procedure fmPlanilhaSSCellChange(Sender: TcxSSBookSheet; const ACol,
      ARow: Integer);
  private
    FpDados           : Pointer;
    Modificado        : Boolean;
    Changing          : Boolean;
    DesabilitaColunas : Boolean;

    Procedure SetDados(pDados: Pointer);
    //procedure CellChange(Sheet: TSheet; aRow, aCol: integer);
  public
    PaiHandle    : HWnd;
    Intervalo    : Integer;
    ParamDados   : TTabParamDados;
    SubBaciaNode : TmhSubBaciaNode;

    Property Dados: Pointer Write SetDados;
  end;

var
  DLG_Parametros: TDLG_Parametros;

implementation
uses mh_Bacia_Calibracao,
     mh_Bacia_Simulacao;

{$R *.DFM}

Procedure TDLG_Parametros.SetDados(pDados: Pointer);
var i: Integer;
    r: double;
Begin
  FpDados := pDados;
  ParamDados := pTDadosDaBacia(FpDados)^.Parametros;

  Changing := true;
  for i := 1 to NParametros do
    begin
    fmPlanilha.ActiveSheet.Write(i+1, 2, ParamDados[i].ValsIni, 8);
    fmPlanilha.ActiveSheet.Write(i+1, 3, ParamDados[i].ValsMin, 8);
    fmPlanilha.ActiveSheet.Write(i+1, 4, ParamDados[i].ValsMax, 8);
    fmPlanilha.ActiveSheet.Write(i+1, 5, ParamDados[i].PassoIni, 8);
    fmPlanilha.ActiveSheet.Write(i+1, 6, ParamDados[i].Precisao, 8);
    end;
  Changing := false;

  i := pTDadosDaBacia(FpDados)^.ExecDados.ExecMode;

  { Desabilita o botão de calibração }
  btnCalibracao.Enabled := not ((i = 2) or (i = 3));

  {Desabilita as 4 últimas colunas no caso de Verificação ou Simulação}
  DesabilitaColunas := (i <> 1 {Calibração})
End;

procedure TDLG_Parametros.btnSimulacaoClick(Sender: TObject);
Var D: TDLG_Ctrl_Simulacao;
begin
  D := TDLG_Ctrl_Simulacao.Create(Self);
  Try
    D.Caption := pTDadosDaBacia(FpDados)^.InfoGerais.Titulo1;
    D.Dados := FpDados;
    D.SubBaciaNode := SubBaciaNode;
    D.ShowModal;
  Finally
    D.Free;
  End;
end;

procedure TDLG_Parametros.btnCalibracaoClick(Sender: TObject);
Var D: TDLG_Ctrl_Calibracao;
begin
  D := TDLG_Ctrl_Calibracao.Create(Self);
  Try
    D.Caption := pTDadosDaBacia(FpDados)^.InfoGerais.Titulo1;
    D.Dados := FpDados;
    D.SubBaciaNode := SubBaciaNode;
    D.ShowModal;
  Finally
    D.Free;
  End;
end;

procedure TDLG_Parametros.ModoExecucaoClick(Sender: TObject);
begin
   If not Changing Then
      Begin
      PostMessage(Handle, WM_ExecModeChange, TRadioButton(Sender).Tag, 0);
      PostMessage(PaiHandle, WM_ExecModeChange, TRadioButton(Sender).Tag, 0);
      End;
end;

procedure TDLG_Parametros.Aceitar(Sender: TObject);
var i: Integer;
begin
  //fmPlanilha.Tab.EndEdit;
  for i := 1 to NParametros do
    with fmPlanilha.ActiveSheet, ParamDados[i] do
      begin
      ValsIni  := getFloat(i+1, 2);
      ValsMin  := getFloat(i+1, 3);
      ValsMax  := getFloat(i+1, 4);
      PassoIni := getFloat(i+1, 5);
      Precisao := getFloat(i+1, 6);
      end;

  pTDadosDaBacia(FpDados)^.Parametros := ParamDados;
  Modificado := False;
  SubBaciaNode.SubBacia.Modified := True;
end;

procedure TDLG_Parametros.CancelBtnClick(Sender: TObject);
begin
  SetDados(FpDados);
end;

procedure TDLG_Parametros.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  mhApplication.Assistant.Hide;
  PanelInfo.Caption := '';
end;

procedure TDLG_Parametros.FormShow(Sender: TObject);
var i: Integer;
begin
  Changing := true;

  fmPlanilha.ActiveSheet.WriteCenter(1, 2, true, 'V.Atuais');
  fmPlanilha.ActiveSheet.WriteCenter(1, 3, true, 'V.Míns');
  fmPlanilha.ActiveSheet.WriteCenter(1, 4, true, 'V.Máxs');
  fmPlanilha.ActiveSheet.WriteCenter(1, 5, true, 'Pass.Inic.');
  fmPlanilha.ActiveSheet.WriteCenter(1, 6, true, 'Precisão');

  for i := 1 to nParametros do
    fmPlanilha.ActiveSheet.WriteCenter(i+1, 1, true, ParamNames[i]);

  Changing := false;
  Modificado := False;
end;

procedure TDLG_Parametros.GlobalChange(Sender: TObject);
begin
  Modificado := True;
end;

procedure TDLG_Parametros.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TDLG_Parametros.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDLG_Parametros.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  If Modificado Then
     {Força a atualização do que foi digitado}
     If MessageDLG(dlgModificGeral, mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
        Aceitar(nil);

  CanClose := True;
end;

procedure TDLG_Parametros.Menu_HistoricoClick(Sender: TObject);
begin
  SubBaciaNode.SubBacia.Historico.ShowModal;
end;

procedure TDLG_Parametros.OKBtnClick(Sender: TObject);
var Inutil: Boolean;
begin
  FormCloseQuery(Sender, Inutil);
end;

procedure TDLG_Parametros.btnOpcoesClick(Sender: TObject);
var P: TPoint;
begin
  P := Point(btnOpcoes.Left, btnOpcoes.Top);
  P := ClientToScreen(P);
  fmPlanilha.Menu.Popup(P.x, P.y);
end;

procedure TDLG_Parametros.fmPlanilhaMenu_AbrirClick(Sender: TObject);
begin
  fmPlanilha.Load.InitialDir := mhApplication.LastPath;
  fmPlanilha.Menu_AbrirClick(Sender);
  FormShow(Sender);
end;

procedure TDLG_Parametros.fmPlanilhaMenu_ColarClick(Sender: TObject);
begin
  fmPlanilha.Menu_ColarClick(Sender);
  Modificado := True;
  {TODO 1 -cProgramacao: racalcular controles}
end;

procedure TDLG_Parametros.fmPlanilhaMenu_SalvarClick(Sender: TObject);
begin
  fmPlanilha.Save.InitialDir := mhApplication.LastPath;
  fmPlanilha.Menu_SalvarClick(Sender);
end;

procedure TDLG_Parametros.Menu_EvolucaoClick(Sender: TObject);
begin
  SubBaciaNode.SubBacia.ShowParamsGraphics();
end;

procedure TDLG_Parametros.fmPlanilhaSSClick(Sender: TObject);
var R: integer;
begin
  //R := fmPlanilha.SS.ActiveCell.Y + 1;
  R := fmPlanilha.ActiveSheet.ActiveRow;
  If (R > 1) and (R < 15) Then
     PanelInfo.Caption := '  ' + ParamHints[R-1]
  Else
     PanelInfo.Caption := '';
end;

procedure TDLG_Parametros.fmPlanilhaSSCellChange(Sender: TcxSSBookSheet; const ACol, ARow: Integer);
begin
  Modificado := true;
end;

end.


