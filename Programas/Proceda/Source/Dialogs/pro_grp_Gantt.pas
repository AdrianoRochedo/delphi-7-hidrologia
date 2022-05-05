unit pro_grp_Gantt;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Buttons, TeeProcs, TeEngine, Chart, DBTables,
  Series, GanttCh, Spin, pro_Const, pro_Classes, pro_Interfaces,
  Mask, ComCtrls;

type
  TGRF_Gantt = class(TForm)
    Panel1: TPanel;
    Lb_Inicial: TLabel;
    Lb_valor_ini: TLabel;
    Lb_Final: TLabel;
    Lb_valor_fin: TLabel;
    Gantt: TChart;
    Label1: TLabel;
    sbZoomIn: TSpeedButton;
    sbZoomOut: TSpeedButton;
    seZOOM: TSpinEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure GanttMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure S2Change(Sender: TObject);
    procedure btnAtualizaClick(Sender: TObject);
    procedure ZoomClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure seZOOMChange(Sender: TObject);
    procedure seZOOMKeyPress(Sender: TObject; var Key: Char);
  private
    //ChangingBars   : Boolean;
    Serie          : TGanttSeries;
    FInfo          : TDSInfo;

    procedure CMDialogKey(var Message: TCMDialogKey); message cm_DialogKey;
  public
    constructor Create(Info: TDSInfo; Plotar: Boolean = True);
    procedure PlotarGantt(Info: TDSInfo);
  end;

const
  cErro: TDateTime = -9999;

implementation
uses pro_Procs,
     pro_Application,
     GaugeFo,
     WinUtils,
     SysUtilsEx;

{$R *.DFM}

constructor TGRF_Gantt.Create(Info: TDSInfo; Plotar: Boolean = True);
begin
  FInfo := Info;
  Inherited Create(nil);
  if Plotar then PlotarGantt(Info);
end;

procedure TGRF_Gantt.CMDialogKey(var Message: TCMDialogKey);
begin
  with Message do
    case CharCode of
      VK_TAB   : inherited;
      VK_LEFT  : Begin Gantt.BottomAxis.Scroll(- 20, False); Result := 1; End;
      VK_RIGHT : Begin Gantt.BottomAxis.Scroll(  20, False); Result := 1; End;
      VK_Up    : Begin Gantt.LeftAxis.Scroll( 0.01, False); Result := 1; End;
      VK_Down  : Begin Gantt.LeftAxis.Scroll(-0.01, False); Result := 1; End;
    end;
end;

procedure TGRF_Gantt.PlotarGantt(Info: TDSInfo);
var  DataInicial,
     DataAnterior,
     DataAtual      : TDateTime;
     PostoAtual     : String;
     PostoAnterior  : String;
     i              : integer;
     nReg           : Longint;
     Limite         : byte;
     Pr             : TDLG_Progress;

(*
   Procedure MostraDados();
   var i, ii: Integer;
       DadoVal, EmPerVal: Boolean;
       x: Double;
       DI, DF: TDateTime;
   begin
     for i := cPostos to FInfo.DS.nCols do
       begin
       EmPerVal := False;
       for ii := 1 to FInfo.DS.nRows do
         begin
         DadoVal := not FInfo.DS.IsMissValue(ii, i, x);

         if DadoVal and not EmPerVal then
            begin
            DI := FInfo.DataInicial + ii - 1;
            EmPerVal := True;
            end;

         if EmPerVal and (not DadoVal or (ii = FInfo.DS.nRows)) then
            begin
            if DadoVal and (ii = FInfo.DS.nRows) then
               DF := FInfo.DataInicial + ii - 1 // o próprio dia
            else
               DF := FInfo.DataInicial + ii - 2; // o dia anterior

            Serie.AddGantt(DI, DF, i-1, FInfo.DS.Struct.Col[i].Name);
            EmPerVal := False;
            end;
         end;
       end;
   End;
*)

   procedure MostrarDados();
   var L  : TListaDePeriodos;
       P  : TStrings;
       PT : TStrings;
       i  : integer;
       k  : integer;
       per: pRecDadosPeriodo;
   begin
     // limpa o Gantt
     Serie.Clear();

     // Obtem os postos a serem mostrados
     P := TStringList.Create();
     FInfo.GetStationNames(P);

     // Cria a lista temporaria que armazenara os postos
     PT := TStringList.Create();

     // Percorre os postos selecionados e monta o Gantt com os periodos
     // individuais de cada posto
     for i := 0 to P.Count-1 do
       begin
       // Obtem os periodos do posto i
       PT.Clear();
       PT.Add(P[i]);
       L := pro_Procs.ObtemPeriodos(FInfo, true, PT);

       // Monta o gantt do posto i
       for k := 0 to L.NumPeriodos-1 do
         begin
         per := L[k];
         serie.AddGantt(per.DI, per.DF, i, p[i]);
         end;

       // Destroi a lista
       L.Free();
       end; // for i

     // Destroi as lista
     PT.Free();
     P.Free();

     Applic.SetupChart(Gantt);
     Gantt.Legend.Visible := false;
     Gantt.MarginTop := 10;
   end;

begin
  FInfo     := Info;
  Tag       := Integer(FInfo);
  Caption   := FInfo.NomeArq;

  Serie.Clear();
  Gantt.UndoZoom();
  MostrarDados();
end;

procedure TGRF_Gantt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TGRF_Gantt.FormCreate(Sender: TObject);
begin
  AjustResolution(Self);
  seZOOMChange(nil);
  Serie := TGanttSeries.Create(nil);
  Serie.ParentChart := Gantt;
  if FInfo.TipoIntervalo = tiMensal Then
     Gantt.BottomAxis.DateTimeFormat := 'mm/yyyy';
end;

procedure TGRF_Gantt.GanttMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var tmpTask  : Longint;
    s        : String;
begin
  if FInfo.TipoIntervalo = tiMensal then
     s := 'mm/yyyy'
  else
     s := 'dd/mm/yyyy';

  tmpTask := Serie.Clicked(x, y);
  if tmpTask <> -1 then
    begin
    Lb_valor_ini.Caption := FormatDateTime(s, Serie.XValues[tmpTask]);
    Lb_valor_fin.Caption := FormatDateTime(s, Serie.EndValues[tmpTask]);
    end
  else
    begin  { limpa os rotulos }
    Lb_valor_ini.Caption := '';
    Lb_valor_fin.Caption := '';
    end;
end;

procedure TGRF_Gantt.S2Change(Sender: TObject);
Var Diferenca: Double;
begin
{
  if not ChangingBars then
     With Gantt.LeftAxis do
       Begin
       Diferenca := Maximum - Minimum;
       Maximum := Minimum + Diferenca;
       end;
}       
end;

procedure TGRF_Gantt.btnAtualizaClick(Sender: TObject);
begin
  PlotarGantt(FInfo);
End;

procedure TGRF_Gantt.ZoomClick(Sender: TObject);
begin
  if seZoom.Value > 40 then seZoom.Value := 40;

  If TSpeedButton(Sender).Name = 'sbZoomOut' Then
     Gantt.ZoomPercent(100 - seZoom.Value)
  Else
     Gantt.ZoomPercent(100 + seZoom.Value);
end;

procedure TGRF_Gantt.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Case Key of
    VK_ESCAPE   : Close();
    VK_ADD      : ZoomClick(sbZoomIn);
    VK_SUBTRACT : ZoomClick(sbZoomOut);
    VK_PRIOR    : Gantt.BottomAxis.Scroll(-100, False);
    VK_NEXT     : Gantt.BottomAxis.Scroll( 100, False);
    End;

  If (ssCtrl in Shift) and (UpCase(Char(Key)) = 'C') Then
     Gantt.CopyToClipboardBitmap;
end;

procedure TGRF_Gantt.seZOOMChange(Sender: TObject);
begin
  sbZoomIn .Hint := Format('Zoom positivo de %d porcento', [seZoom.Value]);
  sbZoomOut.Hint := Format('Zoom negativo de %d porcento', [seZoom.Value]);
end;

procedure TGRF_Gantt.seZOOMKeyPress(Sender: TObject; var Key: Char);
begin
  Case Key of
    '0'..'9', #8 {BS} : // Aceita a tecla digitada
    else
      Key := #0; // Não aceita
    end;
end;

end.
