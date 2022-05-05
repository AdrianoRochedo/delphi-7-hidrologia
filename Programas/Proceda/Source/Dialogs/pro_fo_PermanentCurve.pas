unit pro_fo_PermanentCurve;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Mask, Buttons, ExtCtrls,
  pro_Const, pro_Classes, wsConstTypes, wsVec, wsMatrix, Form_Chart, pro_fo_Memo,
  pro_fr_getValidIntervals,
  pro_Application,
  pro_fr_IntervalsOfStations;

type
  TGRF_CurvaDePermanencia = class(TForm)
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    Bevel1: TBevel;
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
    frame: TfrIntervalsOfStations;
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rbIntervalosClick(Sender: TObject);
    procedure PVmeDIChange(Sender: TObject);
  private
    FG    : TfoChart;
    FInfo : TDSInfo;
    procedure Plotar(Posto: Integer; o, o2: TObject);
  public
    constructor Create(Info: TDSInfo);
  end;

implementation
uses WinUtils, DialogsEx,
     Series, SysUtilsEx,
     wsFrequencias,
     wsFuncoesDeDataSets,
     wsgLib,
     GraphicUtils,
     pro_Procs;

{$R *.DFM}

constructor TGRF_CurvaDePermanencia.Create(Info: TDSInfo);
begin
  Inherited Create(nil);
  FInfo := Info;
end;

procedure TGRF_CurvaDePermanencia.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TGRF_CurvaDePermanencia.FormShow(Sender: TObject);
begin
  //PV.Mostrar(FInfo);
  frame.Info := FInfo;
  //FInfo.GetStationNames(lbPostos.Items);
end;

procedure TGRF_CurvaDePermanencia.Plotar(Posto: Integer; o, o2: TObject);
var S: TPointSeries;
    L: Integer;
    x, y: Real;
    Freq: TwsDataSet;
    vo, pr: TwsDFVec;
    m: TfoMemo;
begin
  if rbCompleta.Checked then
     begin
     vo := TwsDFVec(o);
     pr := TwsDFVec(o2);
     end
  else
     Freq := TwsDataSet(o);

  //S := FG.Series.AddPointSerie(lbPM.Items[Posto], selectColor(Posto));
  S := FG.Series.AddPointSerie(frame.PostosSel[Posto], selectColor(Posto));
  S.ShowInLegend := (frame.PostosSel.Count > 1);

  if cbImprimir.Checked then
     begin
     m := TfoMemo.Create(' Curva De Permanencia');
     m.Write('Período : ' + frame.sDI + ' - ' + frame.sDF);
     m.Write('Posto   : ' + frame.PostosSel[Posto]);
     m.Write();
     end;

  if rbCompleta.Checked then
     begin
     if cbImprimir.Checked then
        begin
        m.Write('Vazão          Probabilidade');
        for L := 1 to vo.Len do
          m.Write(LeftStr(FloatToStrF(vo[L], ffGeneral, 8, 10), 12) + '   ' +
                  LeftStr(FloatToStrF(pr[L], ffGeneral, 8, 10), 12));
        m.FormStyle := fsMDIChild;
        m.Show();
        Applic.ArrangeChildrens();
        end;

     S.Pointer.Style := psCircle;
     for L := 1 to vo.Len do
       S.AddXY(pr[L], vo[L]);
     end
  else
     begin
     if cbImprimir.Checked then
        begin
        m.FormStyle := fsMDIChild;
        m.Show();
        Applic.ArrangeChildrens();
        end;

     S.Pointer.Style := psCircle;
     for L := 1 to Freq.NRows do
       S.AddXY(Freq[L, 9], Freq[L, 2]);
     end;
end;

procedure TGRF_CurvaDePermanencia.btnOkClick(Sender: TObject);
var ds, Freq: TwsDataSet;
    LimSupSerie, m: Double;
    Posto, LI, LF, ints, i: Integer;
    Indexs: TListIndex;
    Vars : TStringList;
    vo, pr: TwsDFVec;
    HasMissValue: boolean;

    procedure Erro();
    begin
      raise Exception.Create('Série não pode ser plotada pois contém somente valores nulos');
    end;

begin
  LI := Finfo.IndiceDaData(frame.sDI);
  LF := Finfo.IndiceDaData(frame.sDF);

  if frame.PostosSel.Count = 0 then
     Raise Exception.Create('Escolha pelo menos um posto para plotar');

  FG := TfoChart.Create(' Curva de Permanência');
  FG.Chart.View3D := False;

  FG.Chart.Title.Alignment := taLeftJustify;
  FG.Chart.Title.Text.Add('Período: ' + frame.sDI + ' - ' + frame.sDF);

  for Posto := 0 to frame.PostosSel.Count-1 do
    begin
    Indexs := TListIndex.Create();
    Indexs.AddIndex(LI, LF);
    Vars := TStringList.Create();
    Vars.Add(frame.PostosSel[Posto]);
    ds := dsSubDataSet(FInfo.DS, Indexs, '', Vars);
    Indexs.Free();
    Vars.Free();

    StartWait;
    try
      if ds.NRows < 2 then Exit;

      if rbCompleta.Checked then
         begin
         vo := TwsDFVec(ds.CopyCol(1));      // dados originais

         if cbNormalizar.Checked then
            begin
            m := vo.Mean(ints);
            vo.ByScalar(m, wsConstTypes.opDiv, false, false);
            end;

         vo.Sort(False, False); // ordeno em ordem decrescente o próprio vetor

         // Calculo da probabilidade
         pr := TwsDFVec(vo.Copy(1, vo.Len)); // cópia dos valores originais ordenados e admensionalisados
         pr.Accum(False); // acumulo para o mesmo vetor
         m := pr[pr.Len]; // obtenho o maior valor acumulado
         if m <> 0 then
            for i := 1 to pr.Len do
              pr[i] := pr[i] / m * 100 // calculo a probabilidade
         else
            Erro();

         Plotar(Posto, vo, pr);

         vo.Free;
         pr.Free;
         end
      else
         begin
         // Admensiono a série
         if cbNormalizar.Checked then
            begin
            m := wsMatrixMean(ds, 1, 1, ds.NRows, HasMissValue);
            for i := 1 to ds.nRows do ds[i, 1] := ds[i, 1] / m;
            end;

         if rbIntervalos.Checked then ints := StrToIntDef(edIntervalos.Text, 0) else ints := 0;
         ints := ChangeToFactor(ds, 1, LimSupSerie, ints, (rbIntervalos.Checked and rbDivLog.Checked));
         Freq := SimpleTable(1, -1, ds, True, LimSupSerie);
         Plotar(Posto, Freq, nil);
         Freq.Free;
         edIntervalos.Text := intToStr(ints);
         end;
     finally
       StopWait;
       ds.Free;
       end;
     end; // for i

  FG.Chart.LeftAxis.Logarithmic := (rbLogNormal.Checked or rbLogLog.Checked);
  FG.Chart.BottomAxis.Logarithmic := (rbNormalLog.Checked or rbLogLog.Checked);

  Applic.SetupChart(FG.Chart);
  FG.Show(fsMDIChild);

  Applic.ArrangeChildrens();
end;

procedure TGRF_CurvaDePermanencia.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TGRF_CurvaDePermanencia.rbIntervalosClick(Sender: TObject);
begin
  rbDivNat.Enabled := rbIntervalos.Checked;
  rbDivLog.Enabled := rbIntervalos.Checked;
  edIntervalos.Enabled := rbIntervalos.Checked;
  if edIntervalos.Enabled then edIntervalos.SetFocus;
end;

procedure TGRF_CurvaDePermanencia.PVmeDIChange(Sender: TObject);
begin
  btnOk.Enabled := (frame.DI <> frame.DF);
end;

end.
