unit pro_fo_FaultAnalysis;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Mask,
  pro_fo_Memo, pro_Interfaces, pro_Classes, pro_Application;

type
  TDLG_AnaliseDeFalhas = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    btnAnalisar: TBitBtn;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    L1: TLabel;
    L2: TLabel;
    L3: TLabel;
    L4: TLabel;
    L5: TLabel;
    L11: TLabel;
    L22: TLabel;
    L33: TLabel;
    L44: TLabel;
    L55: TLabel;
    lab_FalhasTotais: TLabel;
    lab_Max: TLabel;
    lab_Min: TLabel;
    lab_med: TLabel;
    lab_DSV: TLabel;
    btnFechar: TBitBtn;
    Label3: TLabel;
    cbPosto: TComboBox;
    btnDetalhes: TBitBtn;
    DI: TMaskEdit;
    DF: TMaskEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFecharClick(Sender: TObject);
    procedure btnAnalisarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbPostoChange(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btnDetalhesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    sl_Falhas : TStrings;
    Finfo: TDSInfo;
  public
    constructor Create(Info: TDSInfo);
  end;

implementation
uses wsMatrix, wsgLib, wsVec,
     GaugeFo, SysUtilsEx, WinUtils,
     pro_Const;

{$R *.DFM}

procedure TDLG_AnaliseDeFalhas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDLG_AnaliseDeFalhas.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TDLG_AnaliseDeFalhas.btnAnalisarClick(Sender: TObject);
var LinhaInic, LinhaFim  : Longint;
    d1, d2               : TDateTime;
    Pi                   : Integer;    {Indice do posto no DataSet}
    x                    : Double;     {Valor do dado atual}
    nFalhas              : Longint;
    Cont                 : Longint;    {Conta as sub-falhas}
    VI                   : Boolean;    {Verifica se é valor perdido}
    SB                   : TwsGeneral;
    i                    : Longint;
    Col                  : TwsLIVec;
    Res                  : TwsGeneral; {Resultado das estatísticas}
    IsMiss               : Boolean;
    Estatisticas         : TwsLIVec;     {Índice das estatísticas a serem calculadas}
    Entre1e5, Tot1e5     : Longint;
    Entre6e10, Tot6e10   : Longint;
    Entre11e20, Tot11e20 : Longint;
    Entre21e30, Tot21e30 : Longint;
    MaisQue30, TotMais30 : Longint;

    Procedure VerificaQualIntervalo(Cont: Longint);
    var s: String;
    begin
      If sl_Falhas.Count = 0 Then Exit;

      s := sl_Falhas[sl_Falhas.Count-1];
      s := s + ' - ' + DateToStr(i + d1 - 2) + '     ' + IntToStr(Cont) + ' dia(s)';

      If (Cont > 0) and (Cont <= 5) Then
         begin
         inc(Entre1e5);
         inc(Tot1e5, Cont);
         L1.Caption  := intToStr(Entre1e5);
         L11.Caption := intToStr(Tot1e5);
         s := '1=' + s;
         end
      Else If (Cont > 5) and (Cont < 11) Then
         begin
         inc(Entre6e10);
         inc(Tot6e10, Cont);
         L2.Caption  := intToStr(Entre6e10);
         L22.Caption := intToStr(Tot6e10);
         s := '2=' + s;
         end
      Else If (Cont > 10) and (Cont < 21) Then
         begin
         inc(Entre11e20);
         inc(Tot11e20, Cont);
         L3.Caption  := intToStr(Entre11e20);
         L33.Caption := intToStr(Tot11e20);
         s := '3=' + s;
         end
      Else If (Cont > 20) and (Cont < 31) Then
         begin
         inc(Entre21e30);
         inc(Tot21e30, Cont);
         L4.Caption  := intToStr(Entre21e30);
         L44.Caption := intToStr(Tot21e30);
         s := '4=' + s;
         end
      Else If (Cont > 30) Then
         begin
         inc(MaisQue30);
         inc(TotMais30, Cont);
         L5.Caption  := intToStr(MaisQue30);
         L55.Caption := intToStr(TotMais30);
         s := '5=' + s;
         end;

      sl_Falhas[sl_Falhas.Count-1] := s;
    end;

begin
  If cbPosto.ItemIndex = -1 Then
     begin
     MessageDLG('Selecione um posto !', mtWarning, [mbOk], 0);
     Exit;
     end;

  d1 := StrToDate(DI.Text);
  d2 := StrToDate(DF.Text);

  If d1 > d2 Then
     begin
     MessageDLG(cMSG9, mtError, [mbOk], 0);
     ModalResult := mrNone;
     exit;
     end;

  LinhaInic := FInfo.IndiceDaData(d1);
  LinhaFim  := FInfo.IndiceDaData(d2);

  if LinhaInic < 1 then LinhaInic := 1;
  if LinhaFim  > FInfo.DS.nRows then LinhaFim := FInfo.DS.nRows;

  Pi := FInfo.DS.Struct.IndexOf(cbPosto.Items[cbPosto.ItemIndex]);
  SB := FInfo.DS.SubMatrix(LinhaInic, LinhaFim - LinhaInic + 1, Pi, 1);

  {Inicializações}
  VI         := False;
  Cont       := 0;
  nFalhas    := 0;
  Entre1e5   := 0;  Tot1e5    := 0;
  Entre6e10  := 0;  Tot6e10   := 0;
  Entre11e20 := 0;  Tot11e20  := 0;
  Entre21e30 := 0;  Tot21e30  := 0;
  MaisQue30  := 0;  TotMais30 := 0;
  L1.Caption := '00'; L11.Caption := '00';
  L2.Caption := '00'; L22.Caption := '00';
  L3.Caption := '00'; L33.Caption := '00';
  L4.Caption := '00'; L44.Caption := '00';
  L5.Caption := '00'; L55.Caption := '00';
  lab_Max.Caption := '00';
  lab_Min.Caption := '00';
  lab_Med.Caption := '00';
  lab_DSV.Caption := '00';
  lab_FalhasTotais.Caption := '00';
  sl_Falhas.Clear;

  Screen.Cursor := crHourGlass;
  Try
    For i := 1 to SB.nRows - 1 do
      begin
      x := SB[i, 1];
      IsMiss := IsMissValue(x);

      If IsMiss and (not VI) Then
         begin
         VI := True;
         inc(nFalhas);
         inc(Cont);
         lab_FalhasTotais.Caption := '  ' + intToStr(nFalhas);
         {Insere a data da primeira falha}
         if FInfo.TipoIntervalo = tiDiario then
            sl_Falhas.Add(DateToStr(FInfo.DS.AsDateTime[i, 1]));
         end
      Else If IsMiss Then
         begin
         inc(nFalhas);
         inc(Cont);
         lab_FalhasTotais.Caption := '  ' + intToStr(nFalhas);
         end
      Else If VI Then
         begin
         if FInfo.TipoIntervalo = tiDiario then VerificaQualIntervalo(Cont);
         VI := False;
         Cont := 0;
         end;
      end; // for

      x := SB[SB.nRows, 1];

      If IsMissValue(x) Then
         begin
         inc(nFalhas);
         lab_FalhasTotais.Caption := '  ' + intToStr(nFalhas);
         if FInfo.TipoIntervalo = tiDiario then
            If VI Then
               VerificaQualIntervalo(Cont + 1)
            Else
               VerificaQualIntervalo(1);
         end;

    {Cálculo das Estatísticas}
    Col := TwsLIVec.CreateFrom([1]);
    Estatisticas := TwsLIVec.CreateFrom([5{Máxima}, 4{Mínima}, 0{Média}, 2{Desvio Padrão}]);
    Try
      Res := SB.DescStat(Col, Estatisticas);
      If Res <> Nil Then
         begin
         lab_Max.Caption := FloatToStrF(Res[1,1], ffFixed, 5, 2);
         lab_Min.Caption := FloatToStrF(Res[1,2], ffFixed, 5, 2);
         lab_Med.Caption := FloatToStrF(Res[1,3], ffFixed, 5, 2);
         lab_DSV.Caption := FloatToStrF(Res[1,4], ffFixed, 5, 2);
         Res.Free;
         end
      Else
         begin
         lab_Max.Caption := 'Erro';
         lab_Min.Caption := 'Erro';
         lab_Med.Caption := 'Erro';
         lab_DSV.Caption := 'Erro';
         end;
    Finally
      Col.Free;
      Estatisticas.Free;
    End;

  Finally
    SB.Free;
    Screen.Cursor := crDefault;
  End;
end;

procedure TDLG_AnaliseDeFalhas.FormShow(Sender: TObject);
begin
  FInfo.GetStationNames(cbPosto.Items);
  sl_Falhas := TStringList.Create;

  // Seleciona o primeiro posto (sempre haverá pelo menos um posto)
  cbPosto.ItemIndex := 0;
  cbPostoChange(nil);
end;

procedure TDLG_AnaliseDeFalhas.FormHide(Sender: TObject);
begin
  sl_Falhas.Free;
end;

procedure TDLG_AnaliseDeFalhas.cbPostoChange(Sender: TObject);
var Posto: String;
begin
  Posto := cbPosto.Items[cbPosto.ItemIndex];
  DI.Text := FInfo.DataDoPrimeiroValorValido(Posto);
  DF.Text := FInfo.DataDoUltimoValorValido(Posto);
end;

procedure TDLG_AnaliseDeFalhas.btnImprimirClick(Sender: TObject);
var s: String;
    m: TfoMemo;
begin
  m := TfoMemo.Create('Análise de Falhas');

  m.Write('ESTATÍSTICAS DE UM PERÍODO');
  m.Write;
  m.Write('Data Inicial: .......... ' + DI.Text);
  m.Write('Data Final: ............ ' + DF.Text);
  m.Write('Posto: ................. ' + cbPosto.Items[cbPosto.ItemIndex]);

  if FInfo.TipoIntervalo = tiDiario then s := 'DIÁRIO' else s := 'MENSAL';
  m.Write('Tipo: .................. ' + s);

  m.Write;
  m.Write('____________________________________________________________________');
  m.Write;
  m.Write('Falhas Totais: ................................: '+lab_FalhasTotais.Caption);
  m.Write('');
  m.Write('Periodos: Dias        Quantidade         Dias Totais  ');
  m.Write(' 1 => x <=  5  ............'+LeftStr(L1.Caption,5)+'   ........... '+LeftStr(L11.Caption,5));
  m.Write(' 6 => x <= 10  ............'+LeftStr(L2.Caption,5)+'   ........... '+LeftStr(L22.Caption,5));
  m.Write('11 => x <= 20  ............'+LeftStr(L3.Caption,5)+'   ........... '+LeftStr(L33.Caption,5));
  m.Write('21 => x <= 30  ............'+LeftStr(L4.Caption,5)+'   ........... '+LeftStr(L44.Caption,5));
  m.Write('Mais que 30    ............'+LeftStr(L5.Caption,5)+'   ........... '+LeftStr(L55.Caption,5));
  m.Write('____________________________________________________________________');
  m.Write;
  m.Write('Estatísticas');
  m.Write;
  m.Write('Valor máximo :  ...................... ' + LeftStr(lab_Max.Caption,10));
  m.Write('Valor mínimo :  ...................... ' + LeftStr(lab_Min.Caption,10));
  m.Write('Valor médio  :  ...................... ' + LeftStr(lab_med.Caption,10));
  m.Write('Desvio padrão:  ...................... ' + LeftStr(lab_DSV.Caption,10));

  m.FormStyle := fsMDIChild;
  m.Show();
  Applic.ArrangeChildrens();
end;

procedure TDLG_AnaliseDeFalhas.btnDetalhesClick(Sender: TObject);
var i, ii  : Integer;
    sL, sR : String;
    NF     : Boolean;
    m      : TfoMemo;
begin
  btnImprimirClick(Sender);

  m := TfoMemo.Create(' Análise de falhas - Detalhes');

  m.Write('____________________________________________________________________');
  m.Write('');
  m.Write('Detalhes : ');
  m.Write('');

  For i := 1 to 5 do
    begin
    Case i of
      1: m.Write('   1 => x <=  5');
      2: m.Write('   6 => x <= 10');
      3: m.Write('  11 => x <= 20');
      4: m.Write('  21 => x <= 30');
      5: m.Write('  Mais que 30');
      end;

    NF := True;
    For ii := 0 to sl_Falhas.Count - 1 do
      begin
      SubStrings('=', sL, sR, sl_Falhas[ii]);
      If StrToInt(sL) = i Then
         begin
         m.Write('      ' + sR);
         NF := False;
         end;
      end;

    If NF Then m.Write('      Nenhuma Falha');
    m.Write('');
    end;
end;

constructor TDLG_AnaliseDeFalhas.Create(Info: TDSInfo);
begin
  Inherited Create(nil);
  FInfo := Info;
end;

procedure TDLG_AnaliseDeFalhas.FormCreate(Sender: TObject);
begin
  AjustResolution(Self);
end;

end.
