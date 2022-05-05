unit mh_Bacia_DadosGerais;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Mask, ExtCtrls, Messages, Execfile, Dialogs, Spin, drEdit,
  mh_TCs,
  mh_Classes;

type
  TDLG_Informacoes = class(TForm)
    btnCancel: TBitBtn;
    btnHelp: TBitBtn;
    EdTitulo1: TEdit;
    EdTitulo2: TEdit;
    cb_IntComp: TComboBox;
    cb_Mes: TComboBox;
    SpinAno: TSpinButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    EdAno: TEdit;
    Bevel2: TBevel;
    cb_IntSim: TComboBox;
    ModoDeExecucao: TGroupBox;
    rbC: TRadioButton;
    rbV: TRadioButton;
    rbS: TRadioButton;
    Bevel3: TBevel;
    btnParam: TBitBtn;
    btnFechar: TBitBtn;
    bntAceitar: TBitBtn;
    Panel3: TPanel;
    Panel4: TPanel;
    GroupBox1: TGroupBox;
    EdArqPLU: TEdit;
    EdArqETP: TEdit;
    EdArqVZO: TEdit;
    EdArqVZC: TEdit;
    Panel5: TPanel;
    Panel6: TPanel;
    PnVZO: TPanel;
    Panel7: TPanel;
    PanelVZC: TPanel;
    PanelVZO: TPanel;
    PanelETP: TPanel;
    PanelPLU: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Open: TOpenDialog;
    pf_Area: TdrEdit;
    edExtPLU: TdrEdit;
    edExtVZO: TdrEdit;
    edDataIni: TdrEdit;
    edDataFim: TdrEdit;
    procedure SpinAnoDownClick(Sender: TObject);
    procedure SpinAnoUpClick(Sender: TObject);
    procedure EdAnoChange(Sender: TObject);
    procedure ModoDeExecClick(Sender: TObject);
    procedure cb_IntCompChange(Sender: TObject);
    procedure Aceitar(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GlobalChange(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnParamClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnFecharClick(Sender: TObject);
    procedure ArquivosClick(Sender: TObject);
    procedure bntAceitarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FpDados            :  Pointer;
    Modificado         :  Boolean;
    Changing           : Boolean;
    Param_Handle       : HWnd;
    FMostrarParametros : Boolean;

    Procedure SetDados(pDados: Pointer);
    Procedure WMExecModeChange(Var MSG: TMessage); Message WM_ExecModeChange;
  public
    SubBaciaNode: TmhSubBaciaNode;  {A própria instancia, não uma cópia}
    Ger_Handle: HWnd;               {Handle da janela que chamou esta}

    property Dados: Pointer Write SetDados;
    property MostrarParametros : Boolean read FMostrarParametros write FMostrarParametros;
  end;

var
  DLG_Informacoes: TDLG_Informacoes;

implementation
Uses SysUtils, SysUtilsEx, Assist, WinUtils,
     mh_Bacia_Parametros,
     mh_Procs;

{$R *.DFM}

Procedure TDLG_Informacoes.SetDados(pDados: Pointer);
Begin
  FpDados := pDados;
  Changing := False;
  With pTDadosDaBacia(FpDados)^.InfoGerais, pTDadosDaBacia(FpDados)^.ExecDados do
    Begin
    cb_IntSim.ItemIndex  :=  IntSim;
    cb_IntComp.ItemIndex :=  IntComp;
    cb_Mes.ItemIndex     :=  Mes - 1;
    edAno.Text           :=  Ano;

    Case ExecMode Of
      1: rbC.Checked := True;
      2: rbV.Checked := True;
      3: rbS.Checked := True;
      End;
{
    Case pTDadosDaBacia(FpDados)^.Unidade of
      0: rbmm.Checked  := True;
      1: rbm3s.Checked := True;
      End;
}
    edTitulo1.Text    := Titulo1;
    edTitulo2.Text    := Titulo2;

    {edTitulo3.Text    := Titulo3;}
    edArqPLU.Text     := ArqPLU;
    edArqETP.Text     := ArqETP;
    edArqVZO.Text     := ArqVZO;
    edArqVZC.Text     := ArqVZC;

    pf_Area.AsFloat   := Area;

    edExtVZO.AsInteger := ExtVZO;
    edExtPLU.AsInteger := ExtPLU;
    End;
  Changing := True;
End;


Procedure TDLG_Informacoes.WMExecModeChange(Var MSG: TMessage);
Begin
  SubBaciaNode.SubBacia.Modified := True;
  Modificado := True;

  { Indica qual a caixa foi seleciona}
  Case MSG.Wparam of
    1: RbC.Checked := true;
    2: RbV.Checked := true;
    3: RbS.Checked := true;
  end;

  If FpDados <> Nil Then
     pTDadosDaBacia(FpDados)^.ExecDados.ExecMode := MSG.Wparam;

  EdArqVZO.Enabled := ((MSG.Wparam = 1) or (MSG.Wparam = 2));

  If EdArqVZO.Enabled then
     PnVZO.Font.Color := clBlack
  Else
     PnVZO.Font.Color := clSilver;
End;

procedure TDLG_Informacoes.SpinAnoDownClick(Sender: TObject);
begin
  {Diminui um ano da EdAno}
  Try
    EdAno.Text := IntToStr(StrToInt(EdAno.Text) - 1);
    GlobalChange(nil);
  Except
    EdAno.Text := mhApplication.Year;
  End;
end;

procedure TDLG_Informacoes.SpinAnoUpClick(Sender: TObject);
begin
 {Aumenta um ano da EdAno desde que nao passe do ano atual}
  Try
    if StrToInt(EdAno.Text) < StrToInt(mhApplication.Year) then
       EdAno.Text := IntToStr(StrToInt(EdAno.Text) + 1);
    GlobalChange(nil);
  Except
    EdAno.Text := mhApplication.Year;
  End;
end;

procedure TDLG_Informacoes.EdAnoChange(Sender: TObject);
begin
  If AllTrim(EdAno.Text) = '' Then Exit;
  Try
    if StrToInt(EdAno.Text) > StrToInt(mhApplication.Year) then
       EdAno.Text := mhApplication.Year;
    GlobalChange(nil);
  Except
  {nada}
  End;
end;

procedure TDLG_Informacoes.ModoDeExecClick(Sender: TObject);
var L : Longint;
begin
   If Changing Then
      Begin
      PostMessage(Handle, WM_ExecModeChange, TRadioButton(Sender).Tag, 0);
      PostMessage(Param_Handle, WM_ExecModeChange, TRadioButton(Sender).Tag, 0);
      End;
end;

procedure TDLG_Informacoes.cb_IntCompChange(Sender: TObject);
begin
  SetEnable([cb_Mes, EdAno, SpinAno], cb_IntComp.ItemIndex <> 0);
  GlobalChange(nil);
end;

procedure TDLG_Informacoes.Aceitar(Sender: TObject);
Var Validando: Boolean;
begin
  {Validações ----------------------------------------}
  If cb_IntComp.ItemIndex = 1 {Mensal} Then
     Begin
     Try
       StrToInt(edAno.Text);
     Except
       ShowErrorAndGoto(['Ano inválido !'], edAno);
       Exit;
     End;

     If cb_Mes.ItemIndex = -1 Then
        Begin
        ShowErrorAndGoto(['Mês inválido !'], edAno);
        Exit;
        End;
     End;
  {Validações ----------------------------------------}

  With pTDadosDaBacia(FpDados)^.InfoGerais, pTDadosDaBacia(FpDados)^.ExecDados do
    Begin
    IntSim   := cb_IntSim.ItemIndex;
    IntComp  := cb_IntComp.ItemIndex;
    Mes      := cb_Mes.ItemIndex + 1;
    Ano      := edAno.Text;

    {ExecMode já está sendo pego em outras ocasiões}
    If RbC.Checked Then ExecMode := cCalibracao  Else
    If RbV.Checked Then ExecMode := cVerificacao Else
    If RbS.Checked Then ExecMode := cSimulacao;

    pTDadosDaBacia(FpDados)^.Unidade := cMM;

    Titulo1 := edTitulo1.Text;
    Titulo2 := edTitulo2.Text;

    ArqPLU  := edArqPLU.Text;
    ArqETP  := edArqETP.Text;
    ArqVZO  := edArqVZO.Text;
    ArqVZC  := edArqVZC.Text;

    Area    := pf_Area.AsFloat;

    { Irão receber valores automaticamente após a escolha dos arquivos}
    ExtVZO  := EdExtVZO.AsInteger;
    ExtPLU  := EdExtPLU.AsInteger;
    End;

  Modificado := False;
  SubBaciaNode.SubBacia.Modified := True;

  {
  mhApplication.Assistente.Lines.Clear;
  mhApplication.Assistente.Title.Caption := 'Aviso';
  mhApplication.Assistente.Lines.Add(msgDTModific);
  mhApplication.Assistente.UseCursorPos := True;
  mhApplication.Assistente.Active(0,0);
  }
end;

procedure TDLG_Informacoes.btnCancelClick(Sender: TObject);
begin
  SetDados(FpDados);
end;

procedure TDLG_Informacoes.FormCreate(Sender: TObject);
begin
  edExtPLU.AsInteger    := 0;
  edExtVZO.AsInteger    := 0;
  cb_IntComp.ItemIndex  := 0;
  cb_IntSim.ItemIndex   := 0;
  cb_Mes.ItemIndex      := 0;
  EdAno.Text            := mhApplication.Year;
end;

procedure TDLG_Informacoes.FormShow(Sender: TObject);
begin
  {rbC.Checked := True;}
  edDataIni.AsString := '01/1900';
  edDataFim.AsString := edDataIni.AsString;
  Modificado := False;
end;

procedure TDLG_Informacoes.GlobalChange(Sender: TObject);
begin
  If Changing Then Modificado := True;
end;

procedure TDLG_Informacoes.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  mhApplication.Assistant.Hide;
end;

procedure TDLG_Informacoes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SubBaciaNode.SubBacia.Editing := False;
  SendMessage(Ger_Handle, WM_SubBacDataChange, 0, Longint(SubBaciaNode));
  Action := caFree;
end;

procedure TDLG_Informacoes.btnParamClick(Sender: TObject);
var D: TDLG_Parametros;
begin
  D := TDLG_Parametros.Create(Self);
  D.PaiHandle := Handle;
  D.Dados := FpDados;
  D.SubBaciaNode := SubBaciaNode;
  D.Caption := pTDadosDaBacia(FpDados)^.InfoGerais.Titulo1;
  Param_Handle := D.Handle;
  D.ShowModal;
end;

procedure TDLG_Informacoes.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  If Modificado Then
     If MessageDLG(dlgModificGeral, mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
        Aceitar(sender);

  {SubBaciaNode.SubBacia.CanExecute := (edExtVZO.AsString <> '') and (edExtPLU.AsString <> '');}
  CanClose := True;
end;

procedure TDLG_Informacoes.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TDLG_Informacoes.ArquivosClick(Sender: TObject);
var S: String[10];
    S2: String[10];
begin
  S := AllTrim(TPanel(Sender).Caption);
  Delete(S, 1, 1);
  Open.InitialDir := SubBaciaNode.SubBacia.ExecDir;
  Open.DefaultExt := S;
  Open.FileName := '*.' + S;
  Open.Title := 'Escolha um arquivo com a extensão ' + S;

  If Open.Execute Then
     Begin

     If ofExtensionDifferent in Open.Options Then
        Raise Exception.Create('Este arquivo não tem a extensão: ' + S);

     S2 := ChangeFileExt(ExtractFileName(Open.FileName), '');
     TEdit(FindComponent('edArq' + S)).Text := S2;
     Open.FileName := ExtractShortPathName(Open.FileName);

     If S = 'PLU' Then
        Begin
        SubBaciaNode.SubBacia.pDados.N999PLU := Conta999s(Open.FileName);
        edExtPLU.AsInteger := ContaValores(Open.FileName);
        End Else

     If S = 'ETP' Then
        Begin
        End Else

     If S = 'VZO' Then
        Begin
        edExtVZO.AsInteger := ContaValores(Open.FileName);
        edArqVZC.Text := S2;
        End Else

     If S = 'VZC' Then
        Begin
        End;
     End;

  if rbS.Checked then
     edExtVZO.AsInteger := SubBaciaNode.SubBacia.pDados.N999PLU;

  If (edExtVZO.AsInteger <> 0) and (edExtPLU.AsInteger <> 0) and
     (edExtVZO.AsInteger <> SubBaciaNode.SubBacia.Dados.N999PLU) Then
     Begin
     MessageDLG(eN999PLUError, mtError, [mbOK], hcN999PLUError);
     If S = 'PLU' Then
        Begin
        edExtVZO.AsString := '';
        edArqVZO.Text := '';
        End
     Else
        Begin
        edArqPLU.Text := '';
        edExtPLU.AsString := '';
        SubBaciaNode.SubBacia.pDados.N999PLU := 0;
        End;
     End;

  Modificado := True;   
end;

procedure TDLG_Informacoes.bntAceitarClick(Sender: TObject);
var Inutil: Boolean;
begin
  FormCloseQuery(Sender, Inutil);
end;

procedure TDLG_Informacoes.FormActivate(Sender: TObject);
begin
  if FMostrarParametros then
     btnParamClick(Sender);
end;

end.
