unit Graf_CurvaDePermanencia_OPT;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Mask, Buttons, ExtCtrls,
  CH_Const, CH_Tipos,
  wsVec, wsMatrix, FramePeriodosValidos,
  Form_Chart;

type
  TGRF_CurvaDePermanencia = class(TForm)
    Label2: TLabel;
    lbPostos: TListBox;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    Bevel1: TBevel;
    Label5: TLabel;
    sbAddPM: TBitBtn;
    sbSubPM: TBitBtn;
    lbPM: TListBox;
    PV: TFrame_PeriodosValidos;
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
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sbAddPMClick(Sender: TObject);
    procedure sbSubPMClick(Sender: TObject);
    procedure rbIntervalosClick(Sender: TObject);
    procedure PVmeDIChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
     ch_Procs;

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
  PV.Mostrar(FInfo);
  FInfo.MostrarPostos(lbPostos.Items);
end;

procedure TGRF_CurvaDePermanencia.Plotar(Posto: Integer; o, o2: TObject);
var S: TPointSeries;
    L: Integer;
    x, y: Real;
    Freq: TwsDataSet;
    vo, pr: TwsDFVec;
begin
  if rbCompleta.Checked then
     begin
     vo := TwsDFVec(o);
     pr := TwsDFVec(o2);
     end
  else
     Freq := TwsDataSet(o);

  S := FG.Series.AddPointSerie(lbPM.Items[Posto], selectColor(Posto));
  S.ShowInLegend := (lbPM.Items.Count > 1);

  if cbImprimir.Checked then
     begin
     Applic.OutPut.Editor.NewPage;
     Applic.OutPut.Write('Período : ' + PV.IntervaloComoString);
     Applic.OutPut.Write('Posto   : ' + lbPM.Items[Posto]);
     Applic.OutPut.Write;
     end;

  if rbCompleta.Checked then
     begin
     if cbImprimir.Checked then
        begin
        Applic.OutPut.Write('Vazão          Probabilidade');
        for L := 1 to vo.Len do
          Applic.OutPut.Write(LeftStr(FloatToStrF(vo[L], ffGeneral, 8, 10), 12) + '   ' +
                        LeftStr(FloatToStrF(pr[L], ffGeneral, 8, 10), 12));
        Applic.OutPut.Show;
        end;

     S.Pointer.Style := psCircle;
     for L := 1 to vo.Len do
       S.AddXY(pr[L], vo[L]);
     end
  else
     begin
     if cbImprimir.Checked then
        Applic.OutPut.Show;

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

    procedure Erro;
    begin
      raise Exception.Create('Série não pode ser plotada pois contém somente valores nulos');
    end;

begin
  LI := Finfo.IndiceDaData(PV.meDI.Text);
  LF := Finfo.IndiceDaData(PV.meDF.Text);

  if lbPM.Items.Count = 0 then
     Raise Exception.Create('Escolha pelo menos um posto para plotar');

  FG := TfoChart.Create(' Curva de Permanência');
  FG.Chart.View3D := False;

  FG.Chart.Title.Alignment := taLeftJustify;
  FG.Chart.Title.Text.Add('Período: ' + PV.meDI.Text + ' - ' + PV.meDF.Text);

  for Posto := 0 to lbPM.Items.Count-1 do
    begin
    Indexs := TListIndex.Create;
    Indexs.AddIndex(LI, LF);
    Vars := TStringList.Create;
    Vars.Add(GetValidID(lbPM.Items[Posto]));
    ds := dsSubDataSet(FInfo.DS, Indexs, '', Vars);
    Indexs.Free;
    Vars.Free;

    StartWait;
    try
      if ds.NRows < 2 then Exit;

      if rbCompleta.Checked then
         begin
         vo := TwsDFVec(ds.CopyCol(1));      // dados originais

         // Admensiono a série
         if cbNormalizar.Checked then
            begin
            m := vo.Mean(ints);
            if m <> 0 then
               for i := 1 to vo.Len do vo[i] := vo[i] / m
            else
               Erro;
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
            m := wsMatrixMean(ds, 1, 1, ds.NRows);
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
  FG.Show(fsMDIChild);
end;

procedure TGRF_CurvaDePermanencia.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TGRF_CurvaDePermanencia.sbAddPMClick(Sender: TObject);
begin
  AddElemToList(lbPostos, lbPM, False);
end;

procedure TGRF_CurvaDePermanencia.sbSubPMClick(Sender: TObject);
begin
  DeleteElemFromList(lbPM, VK_DELETE);
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
  btnOk.Enabled := (PV.meDI.Text <> PV.meDF.Text);
end;

procedure TGRF_CurvaDePermanencia.FormCreate(Sender: TObject);
begin
  AjustResolution(Self);
end;

end.
