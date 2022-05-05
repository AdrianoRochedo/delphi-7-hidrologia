unit mh_Bacia_Parametros;

interface
uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
     StdCtrls, ExtCtrls, Dialogs, Menus, Messages, CSEZForm, Frame_Planilha,
     mh_TCs,
     mh_Classes, Rochedo.TrackBar;

type
  TDLG_Parametros = class(TcsezForm)
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
    csEZKeys: TcsEZKeys;
    fmPlanilha: TFramePlanilha;
    Menu_Historico: TMenuItem;
    Menu_Evolucao: TMenuItem;
    paControles: TPanel;
    c2: TdrTrackBar;
    c3: TdrTrackBar;
    c4: TdrTrackBar;
    c5: TdrTrackBar;
    c6: TdrTrackBar;
    c7: TdrTrackBar;
    c8: TdrTrackBar;
    c9: TdrTrackBar;
    c10: TdrTrackBar;
    c11: TdrTrackBar;
    c12: TdrTrackBar;
    c13: TdrTrackBar;
    c14: TdrTrackBar;
    c15: TdrTrackBar;
    Label1: TLabel;
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
    procedure fmPlanilhaTabKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure fmPlanilhaTabClick(Sender: TObject; nRow, nCol: Integer);
    procedure fmPlanilhaMenu_AbrirClick(Sender: TObject);
    procedure fmPlanilhaMenu_ColarClick(Sender: TObject);
    procedure fmPlanilhaMenu_SalvarClick(Sender: TObject);
    procedure Menu_EvolucaoClick(Sender: TObject);
    procedure fmPlanilhaTabKeyPress(Sender: TObject; var Key: Char);
    procedure fmPlanilhaTabKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure Controles_Change(Sender: TObject);
    procedure fmPlanilhaTabEndEdit(Sender: TObject;
      var EditString: WideString; var Cancel: Smallint);
  private
    FpDados           : Pointer;
    Modificado        : Boolean;
    Changing          : Boolean;
    DesabilitaColunas : Boolean;
    Controles         : array[2..15] of TdrTrackBar;

    Procedure SetDados(pDados: Pointer);
    procedure SetText(L, C: Integer; const s: String);
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
uses SysUtils, Assist, SysUtilsEx, ClipBrd, vcf1,
     mh_Bacia_Calibracao,
     mh_Bacia_Simulacao;

{$R *.DFM}

Procedure TDLG_Parametros.SetDados(pDados: Pointer);
var i: Integer;
Begin
  Changing := False;
  FpDados := pDados;
  ParamDados := pTDadosDaBacia(FpDados)^.Parametros;

  for i := 1 to NParametros do
    with fmPlanilha.Tab, ParamDados[i] do
      begin
      NumberRC[i+1, 2] := ValsIni;
      NumberRC[i+1, 3] := ValsMin;
      NumberRC[i+1, 4] := ValsMax;
      NumberRC[i+1, 5] := PassoIni;
      NumberRC[i+1, 6] := Precisao;

      Controles[i+1].Min := ValsMin;
      Controles[i+1].Max := ValsMax;
      Controles[i+1].Position := ValsIni;
      end;

  Changing := True;
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
   If Changing Then
      Begin
      PostMessage(Handle, WM_ExecModeChange, TRadioButton(Sender).Tag, 0);
      PostMessage(PaiHandle, WM_ExecModeChange, TRadioButton(Sender).Tag, 0);
      End;
end;

procedure TDLG_Parametros.Aceitar(Sender: TObject);
var i: Integer;
begin
  fmPlanilha.Tab.EndEdit;
  for i := 1 to NParametros do
    with fmPlanilha.Tab, ParamDados[i] do
      begin
      ValsIni  := NumberRC[i+1, 2];
      ValsMin  := NumberRC[i+1, 3];
      ValsMax  := NumberRC[i+1, 4];
      PassoIni := NumberRC[i+1, 5];
      Precisao := NumberRC[i+1, 6];
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

procedure TDLG_Parametros.setText(L, C: Integer; const s: String);
begin
  with fmPlanilha.Tab do
    begin
    SetActiveCell(L, C);
    SetAlignment(F1HAlignCenter, False, F1VAlignCenter, 0);
    SetFont('ARIAL', 8, True, False, False, False, clBlack, False, False);
    Text := s;
    end;
end;

procedure TDLG_Parametros.FormShow(Sender: TObject);
var i: Integer;
begin
  Modificado := False;
  fmPlanilha.SetDecimalSeparator(mhApplication.Old_DecSep);

  with fmPlanilha.Tab do
    begin
    ShowColHeading := False;
    ShowRowHeading := False;
    ShowTabs       := F1TabsOff;
    MaxCol         := 6;
    MaxRow         := 15;

    setText(1, 2, 'V.Atuais');
    setText(1, 3, 'V.Míns');
    setText(1, 4, 'V.Máxs');
    setText(1, 5, 'Pass.Inic.');
    setText(1, 6, 'Precisão');
    
    for i := 1 to nParametros do
      setText(i+1, 1, ParamNames[i]);
    end;
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

procedure TDLG_Parametros.fmPlanilhaTabKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var CanSelect: Boolean;
begin
  CanSelect := not ( DesabilitaColunas and (fmPlanilha.Tab.Col > 1) );
  if not CanSelect and (fmPlanilha.Tab.Col > 1) Then
     Key := 0
  else
     Modificado := True;
end;

procedure TDLG_Parametros.fmPlanilhaTabClick(Sender: TObject; nRow, nCol: Integer);
var L: Integer;
    C: Integer;
begin
   If (nRow > 1) and (nCol = 1) Then
      PanelInfo.Caption := '  ' + ParamHints[nRow-1]
   Else
      PanelInfo.Caption := '';
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

procedure TDLG_Parametros.fmPlanilhaTabKeyPress(Sender: TObject; var Key: Char);
begin
  fmPlanilha.TabKeyPress(Sender, Key);
end;

procedure TDLG_Parametros.fmPlanilhaTabKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  fmPlanilhaTabClick(Sender, fmPlanilha.Tab.Row, fmPlanilha.Tab.Col);
end;

procedure TDLG_Parametros.FormCreate(Sender: TObject);
var i: integer;
begin
  for i := 2 to 15 do
    Controles[i] := TdrTrackBar(
      paControles.FindChildControl('c' + intToStr(i)));
end;

procedure TDLG_Parametros.Controles_Change(Sender: TObject);
var c: TdrTrackBar;
begin
  c := TdrTrackBar(Sender);
  fmPlanilha.Tab.NumberRC[c.Tag, 2] := c.Position;
end;

procedure TDLG_Parametros.fmPlanilhaTabEndEdit(Sender: TObject; var EditString: WideString; var Cancel: Smallint);
var R, C: integer;
begin
  R := fmPlanilha.Tab.Row;
  C := fmPlanilha.Tab.Col;
  if (R > 1) and (R < 16) then
     case C of
       2: Controles[R].Position := toFloat(EditString);
       3: Controles[R].Min := toFloat(EditString);
       4: Controles[R].Max := toFloat(EditString);
       end;
end;

end.


