unit mh_GRF_VZCxVZO;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, TeeProcs, TeEngine, Chart, Series,
  StdCtrls, Buttons, wsMatrix, CurvFitt;

type
  TDLG_Graphic_2 = class(TForm)
    ChVzcVzo: TChart;
    Info: TPanel;
    Label1: TLabel;
    Lab_FO: TLabel;
    BtnCopy: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure BtnCopyClick(Sender: TObject);
  private
    FDS : TwsDataSet;
    Procedure SetDados(DS: TwsDataSet);
    procedure MostraDados;
  public
    Zoom     : Integer;
    Property Dados: TwsDataSet Read FDS Write SetDados;
  end;

var
  DLG_Graphic_2 : TDLG_Graphic_2;


implementation
uses wsConstTypes, wsCvec, wsVec, wsGLIB, Assist, GaugeFo,
     mh_Classes,
     mh_TCs,
     mh_Procs;

{$R *.DFM}

Procedure TDLG_Graphic_2.SetDados(DS: TwsDataSet);
Begin
  If (DS.nRows > 0) Then
     If (DS.nCols > 1) and
        (DS.Struct.Col[1].ColType = dtNumeric) and
        (DS.Struct.Col[2].ColType = dtNumeric) Then
        FDS := DS
     Else
        Raise Exception.Create(eDSPlotError2)
  Else
     Raise Exception.Create(eDSPlotError1);
End;

procedure TDLG_Graphic_2.FormCreate(Sender: TObject);
begin
  Zoom := 100;
  ChVzcVzo.ZoomPercent(100);
end;

procedure TDLG_Graphic_2.MostraDados;
var SerieX  : Double;
    SerieY  : Double;
    x       : Double;
    SomaVZO : Double;
    SomaVZC : Double;
    i       : Longint;
    nPontos : LongInt;
    Pr      : TDLG_Progress;

    Series1 : TPointSeries;
    Series2 : TLineSeries;
    Series4 : TFastLineSeries;
    Series5 : TFastLineSeries;
    Series6 : TFastLineSeries;
    Series7 : TLineSeries;
    Series8 : TFastLineSeries;

    T : TTrendFunction;
begin
  Series1 := TPointSeries.Create(nil);
  Series1.ParentChart := ChVzcVzo;
  Series1.Pointer.Style := psCircle;
  Series1.Pointer.HorizSize := 1;
  Series1.Pointer.VertSize := 1;
  Series1.Title := 'VZO x VZC';

  Series2 := TLineSeries.Create(nil);
  Series2.ParentChart := ChVzcVzo;
  Series2.SeriesColor := clGREEN;
  Series2.LinePen.Width := 2;
  Series2.Title := 'Referência';

  Series4 := TFastLineSeries.Create(nil);
  Series4.ParentChart := ChVzcVzo;
  Series4.Title := 'Média de VZO';

  Series5 := TFastLineSeries.Create(nil);
  Series5.ParentChart := ChVzcVzo;
  Series5.Title := 'Média de VZC';

  Series6 := TFastLineSeries.Create(nil);
  Series6.ParentChart := ChVzcVzo;
  Series6.Title := 'Média de VZC';

  Series7 := TLineSeries.Create(nil);
  Series7.ParentChart := ChVzcVzo;
  Series7.SeriesColor := clRED;
  Series7.LinePen.Width := 2;
  Series7.Title := 'Tendência';

  Series8 := TFastLineSeries.Create(nil);
  Series8.ParentChart := ChVzcVzo;
  Series8.Title := 'Média de VZO';

  ChVzcVzo.RightAxis.Minimum := 0; {valor minimo dos eixos a direita}

  SomaVZO  := 0;
  SomaVZC  := 0;
  nPontos  := 0;

  Pr := CreateProgress(-1, -1, FDS.nRows, 'Plotando dados do conjunto: ' + FDS.MLab);
  mhApplication.Assistant.Active(0,0);
  For i := 1 to FDS.nRows do
    begin
    Pr.Value := i;
    SerieX := FDS[i, cVZO];
    SerieY := FDS[i, cVZC];
    if (SerieX > 0) and (SerieY > 0) then
       begin
       Series1.AddXY(SerieX, SerieY);
       SomaVZO := SomaVZO + SerieX;
       SomaVZC := SomaVZC + SerieY;
       inc(nPontos);
       end
    end;
  Pr.Free;

  x := ChVzcVzo.MaxXValue(ChVzcVzo.BottomAxis);
  Series2.AddXY( 0, 0, '', clTeeColor);
  Series2.AddXY( x, x, '', clTeeColor);

  T := TTrendFunction.Create(self);
  T.ParentSeries := Series7;
  T.Period := nPontos;
  T.AddPoints(Series1);

  {Plota a media de VZO  - Total possui a soma de todas VZO  e cont o numero de valores }
  x := ChVzcVzo.MaxYValue(ChVzcVzo.LeftAxis);
  Series4.AddXY((SomaVZO/nPontos) , 0, '', clTeeColor);
  Series4.AddXY((SomaVZO/nPontos) , x, '', clTeeColor);

  {Plota a media de VZO  - No eixo Y}
  Series8.AddXY( 0, (SomaVZO/nPontos) , '', clTeeColor);
  Series8.AddXY( x, (SomaVZO/nPontos) , '', clTeeColor);

  {Plota a media de VZC  - Total possui a soma de todas VZC  e cont o numero de valores }
  Series5.AddXY((SomaVZC/nPontos) , 0, '', clTeeColor);
  Series5.AddXY((SomaVZC/nPontos) , x, '', clTeeColor);

  {Plota a media de VZC  - No eixo Y }
  Series6.AddXY( 0, (SomaVZC/nPontos), '', clTeeColor);
  Series6.AddXY( x, (SomaVZC/nPontos), '', clTeeColor);
end;

procedure TDLG_Graphic_2.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDLG_Graphic_2.FormShow(Sender: TObject);
var FO, Unidade: Byte;
begin
  Screen.Cursor := crHourGlass;
  mhApplication.Assistant.Lines.Clear;
  mhApplication.Assistant.Title.Caption := 'Aviso';
  mhApplication.Assistant.Lines.Add('Aguarde alguns momentos até');
  mhApplication.Assistant.Lines.Add('a plotagem total dos pontos.');
  mhApplication.Assistant.UseCursorPos := True;

  Caption := ' ' + FDS.MLab + ' - Gráfico VZO x VZC';

  Get_FO_Unidade(FDS.Tag_1, FO, Unidade);
  Lab_FO.Caption := CodToFObjetive(FO);

  Try
    MostraDados;
    ChVzcVzo.UndoZoom;
  Finally
    Screen.Cursor := crDefault;
  End;
end;

procedure TDLG_Graphic_2.BtnCopyClick(Sender: TObject);
begin
  {$ifdef DEMO}
  mhApplication.ShowDemoMessage();
  {$else}
  ChVzcVzo.CopyToClipboardBitmap;
  {$endif}
end;

end.
   