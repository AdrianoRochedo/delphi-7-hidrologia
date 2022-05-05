unit mh_OPC_GRF_CurvaDePermanencia;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Mask, Buttons, ExtCtrls,
  wsVec, wsMatrix, Form_Chart, foBook,
  mh_TCs;

type
  TDLG_CurvaDePermanencia = class(TForm)
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    GroupBox1: TGroupBox;
    rbCompleta: TRadioButton;
    rbIntervalos: TRadioButton;
    Panel1: TPanel;
    rbDivNat: TRadioButton;
    rbDivLog: TRadioButton;
    GroupBox2: TGroupBox;
    rbNormal: TRadioButton;
    rbLogNormal: TRadioButton;
    rbNormalLog: TRadioButton;
    cbImprimir: TCheckBox;
    rbLogLog: TRadioButton;
    edIntervalos: TEdit;
    cbNormalizar: TCheckBox;
    Bevel1: TBevel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rbIntervalosClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FG: TfoChart;
    FDS: TwsDataSet;
    book: TBook;
    procedure Plotar(Posto: Integer; o, o2: TObject);
    procedure SetDados(const Value: TwsDataSet);
  public
    property Dados: TwsDataSet read FDS write SetDados;
  end;

implementation
uses WinUtils,
     mh_Classes,
     Series,
     SysUtilsEx,
     wsConstTypes,
     wsFrequencias,
     wsFuncoesDeEscalares,
     wsgLib,
     GraphicUtils;

{$R *.DFM}

procedure TDLG_CurvaDePermanencia.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TDLG_CurvaDePermanencia.Plotar(Posto: Integer; o, o2: TObject);
var S: TPointSeries;
    L: Integer;
    x, y: Double;
    Freq: TwsDataSet;
    vo, pr: TwsDFVec;
    SL: TStringList;
    c: TColor;
begin
  if rbCompleta.Checked then
     begin
     vo := TwsDFVec(o);
     pr := TwsDFVec(o2);
     end
  else
     Freq := TwsDataSet(o);

  if Posto = 2 then c := clRED else c := clBLUE;
  S := FG.Series.AddPointSerie(FDS.Struct.Col[Posto].Name, c);

  if cbImprimir.Checked then
     begin
     book.Show();
     book.NewPage('memo', FDS.Struct.Col[Posto].Name);
     end
  else
     book.Hide();

  if rbCompleta.Checked then
     begin
     if cbImprimir.Checked then
        begin
        book.TextPage.BeginUpdate();
        book.TextPage.Write('Vazão          Probabilidade');
        for L := 1 to vo.Len do
          book.TextPage.Write(LeftStr(FloatToStrF(vo[L], ffGeneral, 8, 10), 12) + '   ' +
                              LeftStr(FloatToStrF(pr[L], ffGeneral, 8, 10), 12));
        book.TextPage.EndUpdate();
        end;

     S.Pointer.Style := psSmallDot;
     for L := 1 to vo.Len do
       if (not pr.IsMissValue(L, x)) and (not vo.IsMissValue(L, y)) then
          S.AddXY(x, y);
     end
  else
     begin
     if cbImprimir.Checked then
        begin
        SL := TStringList.Create;
        Freq.Print(SL);
        book.TextPage.BeginUpdate();
        for L := 0 to SL.Count-1 do book.TextPage.Write(SL[L]);
        book.TextPage.EndUpdate();
        SL.Free();
        end;

     S.Pointer.Style := psCircle;
     for L := 1 to Freq.NRows do
       if (not Freq.IsMissValue(L, 9, x)) and (not Freq.IsMissValue(L, 2, y)) then
          S.AddXY(x, y);
     end;
end;

procedure TDLG_CurvaDePermanencia.btnOkClick(Sender: TObject);
var ds, Freq: TwsDataSet;
    LimSupSerie, m: Double;
    Posto, ints, i: Integer;
    vo, pr: TwsDFVec;
    ehCalibracao: Boolean;
    i1, i2: integer;
    b: boolean;
begin
  FG := TfoChart.Create(' ' + FDS.MLab + ' - Curva de Permanência');
  FG.Chart.View3D := False;
  FG.Chart.Title.Alignment := taLeftJustify;

  ehCalibracao := (FDS.Tag_2 > 0) and (FDS.Tag_2 < 3);

  if rbIntervalos.Checked then
     ds := FDS.Copy
  else
     ds := FDS;

  if ehCalibracao then
     begin
     i1 := 2;  // vzo obs.
     i2 := 3;  // vzo calc.
     end
  else
     begin     // somente vzo calc.
     i1 := 3;
     i2 := 3;
     end;

  StartWait;
  try
    for Posto := i1 to i2 do
      if rbCompleta.Checked then
         begin
         vo := TwsDFVec(FDS.CopyCol(Posto));      // dados originais

         // Admensiono a série
         if cbNormalizar.Checked then
            begin
            m := vo.Mean(ints);
            vo.ByScalar(m, wsConstTypes.opDiv, false, false);
            end;

         vo.Sort(False, False); // ordeno em ordem decrescente o próprio vetor

         // Calculo da probabilidade
         pr := TwsDFVec(vo.Copy(1, vo.Len)); // cópia dos valores originais ordenados e admensionalisados
         if pr <> nil then
            begin
            pr.Accum(False); // acumulo para o mesmo vetor

            m := pr[pr.Len]; // obtenho a maior probabilidade acumulada
            if m <> 0 then
               for i := 1 to pr.Len do
                 pr[i] := pr[i] / m * 100; // calculo a probabilidade

            Plotar(Posto, vo, pr);
            end;

         vo.Free;
         pr.Free;                        
         end
      else
         begin
         // Admensiono a série
         if cbNormalizar.Checked then
            begin
            m := wsMatrixMean(ds, Posto, 1, ds.NRows, b);
            for i := 1 to ds.nRows do
              ds[i, Posto] := wsFuncoesDeEscalares.scalarDiv(ds[i, Posto], m);
            end;

         if rbIntervalos.Checked then ints := StrToIntDef(edIntervalos.Text, 0) else ints := 0;
         ints := ChangeToFactor(ds, Posto, LimSupSerie, ints, (rbIntervalos.Checked and rbDivLog.Checked));
         Freq := SimpleTable(Posto, -1, ds, True, LimSupSerie);
         Plotar(Posto, Freq, nil);
         Freq.Free;
         edIntervalos.Text := intToStr(ints);
         end;
  finally
    if rbIntervalos.Checked then ds.Free;
    StopWait;
  end;

  try
    FG.Chart.LeftAxis.Logarithmic := (rbLogNormal.Checked or rbLogLog.Checked);
    FG.Chart.BottomAxis.Logarithmic := FG.Chart.LeftAxis.Logarithmic;
  except
    On e: Exception do
       MessageDLG(e.message, mtError, [mbOk], 0);
  end;

  FG.Show(fsMDIChild);
end;

procedure TDLG_CurvaDePermanencia.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDLG_CurvaDePermanencia.rbIntervalosClick(Sender: TObject);
begin
  rbDivNat.Enabled := rbIntervalos.Checked;
  rbDivLog.Enabled := rbIntervalos.Checked;
  edIntervalos.Enabled := rbIntervalos.Checked;
  if edIntervalos.Enabled then edIntervalos.SetFocus;
end;

procedure TDLG_CurvaDePermanencia.SetDados(const Value: TwsDataSet);
Var aux: Double;
Begin
  FDS := Value;
  If (FDS.nRows > 0) Then
     If (FDS.nCols > 2) and
        (FDS.Struct.Col[1].ColType = dtNumeric) and
        (FDS.Struct.Col[2].ColType = dtNumeric) and
        (FDS.Struct.Col[3].ColType = dtNumeric) Then
        Begin
        End
     Else
        Raise Exception.Create(eDSPlotError2)
  Else
     Raise Exception.Create(eDSPlotError1);
End;

procedure TDLG_CurvaDePermanencia.FormCreate(Sender: TObject);
begin
  book := TBook.Create(' Curva de Permanencia - Tab. de Frequências', fsStayOnTop);
  book.BorderIcons := [];
  book.FormStyle := fsStayOnTop;
end;

procedure TDLG_CurvaDePermanencia.FormDestroy(Sender: TObject);
begin
  book.Free();
end;

end.
