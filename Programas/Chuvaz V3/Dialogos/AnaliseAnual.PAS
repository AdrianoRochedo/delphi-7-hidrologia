unit AnaliseAnual;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, OvcBase, StdCtrls, Buttons, OvcEF, OvcPB, OvcPF, Gridx32, ExtCtrls, Mask,
  ch_Tipos;

type
  TDLG_AnaliseAnual = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cbPosto: TComboBox;
    btnAnalisar: TBitBtn;
    BitBtn2: TBitBtn;
    btnImprimir: TBitBtn;
    Grid: TdrStringAlignGrid;
    Label4: TLabel;
    Panel: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Pn_Media: TPanel;
    Pn_DSP: TPanel;
    DI: TMaskEdit;
    DF: TMaskEdit;
    procedure btnAnalisarClick(Sender: TObject);
    procedure Analizar_Dado_Anual;
    procedure FormShow(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    Finfo: TDSInfo;
  public
    constructor Create(Info: TDSInfo);
  end;

implementation

{$R *.DFM}

uses wsConstTypes, wsGlib, wsMatrix, wsVec,
     wsOutPut, SysUtilsEx, WinUtils,
     ch_Const;

procedure TDLG_AnaliseAnual.btnAnalisarClick(Sender: TObject);
begin
  Analizar_Dado_Anual;
end;

{Neste procedimento as medias e os desvios padroes sao armazenadas em uma matriz do tipo
 Ano   Media DSP
 xxxx  xxxx  xxxx}
procedure TDLG_AnaliseAnual.Analizar_Dado_Anual;
Var AnoInicial, AnoFinal, Linha : Word;
    Ano, Mes, Dia, i            : Word;
    IndiceInicial, IndiceFinal  : Word;
    s                           : String;
    Matriz                      : TwsGeneral;
    Vec                         : TwsVec;
    x                           : Double;
    IndPosto                    : Integer;
    d1, d2                      : TDateTime;

begin
  If StrToDate(DI.Text) > StrToDate(DF.Text) Then
     begin
     MessageDLG(cMSG9, mtError, [mbOk], 0);
     ModalResult := mrNone;
     exit;
     end;

  s  := cbPosto.Items[cbPosto.ItemIndex];
  d1 := StrToDate(FInfo.DataDoPrimeiroValorValido(s));
  d2 := StrToDate(FInfo.DataDoUltimoValorValido(s));

  DecodeDate(d1, AnoInicial, Mes, Dia);
  DecodeDate(d2, AnoFinal, Mes, Dia);

  Linha := 0;
  IndPosto := FInfo.DS.Struct.IndexOf(s);

  Matriz := TwsGeneral.Create(0, 3);

  // Calcula as estatísticas para cada ano
  For Ano := AnoInicial To AnoFinal Do
    begin
    Inc(Linha);  {Guarda o numero de linhas da grid}

    IndiceInicial := FInfo.IndiceDaData(DI.Text + '/' + IntToStr(Ano));
    IndiceFinal   := FInfo.IndiceDaData(DF.Text + '/' + IntToStr(Ano));

    Vec :=  TwsDFVec.Create(3);
    Vec[1] := Ano;  {Ano}
    if IndiceInicial = IndiceFinal then
       begin
       Vec[2] := FInfo.DS[IndiceInicial, IndPosto];
       Vec[3] := wscMissValue;
       end
    else
       begin
       Vec[2] := wsMatrixMean(FInfo.DS, IndPosto, IndiceInicial, IndiceFinal);
       Vec[3] := wsMatrixDSP (FInfo.DS, IndPosto, IndiceInicial, IndiceFinal, Vec[2]);
       end;

    Matriz.MAdd(Vec);
    end;   {For Ano...}

  Grid.RowCount := Linha + 1;
  For i := 1 To Linha Do
    begin
    Grid.Cells[0, i] := FloatToStr(Matriz[i, 1]); // Ano

    x := Matriz[i, 2]; // Media
    If not isMissValue(x) then
       Grid.Cells[1,i] := FloatToStrF(x, ffFixed, 8, 2)
    else
       Grid.Cells[1,i] := '----';

    x := Matriz[i, 3]; // Desvio Padrao
    If not isMissValue(x) then
       Grid.Cells[2, i] := FloatToStrF(x, ffFixed, 8, 2)
    else
       Grid.Cells[2, i] := '----';
    end;

  {Cacula os valores totais}

  Pn_Media.Caption := FloatToStrF(wsMatrixMean(Matriz, 2, 1, Matriz.NRows), ffFixed, 8, 2);

  If IndiceInicial <> IndiceFinal Then
     Pn_DSP.Caption  := FloatToStrF(wsMatrixMean (Matriz, 3, 1, Matriz.NRows), ffFixed, 8, 2)
  else
     Pn_DSP.Caption  := '----';

  Matriz.Free;
end;

procedure TDLG_AnaliseAnual.FormShow(Sender: TObject);
begin
  Grid.Cells[0,0] := 'Ano';
  Grid.Cells[1,0] := 'Média';
  Grid.Cells[2,0] := 'Desvio Padrão';
  FInfo.MostrarPostos(cbPosto.Items);
end;

procedure TDLG_AnaliseAnual.btnImprimirClick(Sender: TObject);
var i: integer;
begin
  Applic.OutPut.Editor.NewPage;
  Applic.OutPut.Editor.Write('');
  Applic.OutPut.Editor.Write('Periodo Inicial (Dia/Mes) : ' + DI.Text);
  Applic.OutPut.Editor.Write('Perido Final    (Dia/Mes) : ' + DF.Text);
  Applic.OutPut.Editor.Write('Posto                     : ' + cbPosto.Items[cbPosto.ItemIndex]);
  Applic.OutPut.Editor.Write('');
  Applic.OutPut.Editor.Write('____________________________________________________________________');
  Applic.OutPut.Editor.Write('');
  Applic.OutPut.Editor.Write('Estatisticas');
  Applic.OutPut.Editor.Write('Ano             Média             Desvio Padrão');
  Applic.OutPut.Editor.Write('');

  For i:= 1 To Grid.RowCount-1 Do
     Applic.OutPut.Editor.Write( Grid.Cells[0,i]+'            '+Grid.Cells[1,i]+'              '+ Grid.Cells[2,i]);

  Applic.OutPut.Editor.Write('____________________________________________________________________');
  Applic.OutPut.Editor.Write('');
  Applic.OutPut.Editor.Write('Valores totais das Estatisticas ');
  Applic.OutPut.Editor.Write('');
  Applic.OutPut.Editor.Write('Media :     ...................... ' + LeftStr(Pn_Media.Caption,10));
  Applic.OutPut.Editor.Write('DSP Médio:  ...................... ' + LeftStr(Pn_DSP.Caption,10));

  Applic.OutPut.Editor.Show;
end;

procedure TDLG_AnaliseAnual.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDLG_AnaliseAnual.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

constructor TDLG_AnaliseAnual.Create(Info: TDSInfo);
begin
  Inherited Create(nil);
  FInfo := Info;
end;

procedure TDLG_AnaliseAnual.FormCreate(Sender: TObject);
begin
  AjustResolution(Self);
end;

end.
