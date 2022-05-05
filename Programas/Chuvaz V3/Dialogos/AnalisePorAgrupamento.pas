unit AnalisePorAgrupamento;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ch_Tipos;

type
  TDLG_AnalisePorAgrupamento = class(TForm)
    GroupBox1: TGroupBox;
    rbMedias: TRadioButton;
    rbTotais: TRadioButton;
    Label1: TLabel;
    cbPeriodo: TComboBox;
    btnOk: TButton;
    btnCancel: TButton;
    rgQuebrarLinhas: TRadioGroup;
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    Finfo: TDSInfo;
  public
    constructor Create(Info: TDSInfo);
  end;

implementation
uses wsVec, wsOutPut, wsMatrix, wsgLib, SysUtilsEx, WinUtils,
     ch_Const,
     ch_Procs;

{$R *.DFM}

constructor TDLG_AnalisePorAgrupamento.Create(Info: TDSInfo);
begin
  Inherited Create(nil);
  FInfo := Info;
end;

procedure TDLG_AnalisePorAgrupamento.btnOkClick(Sender: TObject);
var DS            : TwsDataSet;
    DSO           : TwsDataSet;
    SL            : TStrings;
    v             : TwsVec;
    i, j          : Integer;
    cont          : Integer;
    DaysInPeriod  : Integer;
    InterSim      : Integer;
    aux           : Double;
    DataIni       : TDate;
    DataAtual     : TDate;
    Ano, Mes, Dia : Word;
    ParteDoMes    : Byte;
begin
  Screen.Cursor := crHourGlass;
  DSO := FInfo.DS;

  //criação da matriz auxiliar que receberá as estatísticas.
  DS := TwsDataSet.Create('Estatisticas');
  for i := cPostos to DSO.nCols do
    DS.Struct.AddNumeric(DSO.ColName[i], '');

  Try
    Cont := 0;
    v    := VecConst(0, DSO.nCols-cPostos+1);

    Applic.OutPut.Editor.NewPage;

    DaysInPeriod := DiasNoPeriodo(cbPeriodo.ItemIndex + 1, FInfo.DataInicial);
    InterSim     := DiasQueFaltamParaO_UltimoDiaDoPeriodo(FInfo.DataInicial, DaysInPeriod) + 1;

    For i := 1 to DSO.nRows Do
      begin
      inc(Cont);
      DataAtual := DSO.AsDateTime[i, 1];

      //calcula o somatorio dos valores
      for j := 1 to v.Len do
        begin
        aux := DSO[i, j+cPostos-1];
        if not IsMissValue(aux) then v[j] := v[j] + aux;
        end;

      If Cont = InterSim Then {Acabou um período}
         begin
         //calcula as média dos valores
         if rbMedias.Checked then
            for j := 1 to v.Len do
               if not IsMissValue(v[j]) then
                  v[j] := v[j] / Cont;

         DecodeDate(DataAtual, Ano, Mes, Dia);
         inc(ParteDoMes);

         case cbPeriodo.ItemIndex of
           0: begin
              v.Name := Format('"%d. Quinq. de %s de %d"', [ParteDoMes, cNomeCurtoMes[Mes], Ano]);
              if ParteDoMes = 6 then ParteDoMes := 0;
              end;

           1: begin
              v.Name := Format('"%d. Sem. de %s de %d"', [ParteDoMes, cNomeCurtoMes[Mes], Ano]);
              if ParteDoMes = 4 then ParteDoMes := 0;
              end;

           2: begin
              v.Name := Format('"%d. Dec. de %s de %d"', [ParteDoMes, cNomeCurtoMes[Mes], Ano]);
              if ParteDoMes = 3 then ParteDoMes := 0;
              end;

           3: begin
              v.Name := Format('"%d. Quinz. de %s de %d"', [ParteDoMes, cNomeCurtoMes[Mes], Ano]);
              if ParteDoMes = 2 then ParteDoMes := 0;
              end;

           4: v.Name := '"' + cNomeCurtoMes[Mes] + ' de ' + intToStr(Ano) + '"';
           end;

         DS.MADD(v);
         if i < DSO.nRows then v := VecConst(0, DSO.nCols-cPostos+1);

         DaysInPeriod := DiasNoPeriodo(cbPeriodo.ItemIndex + 1, DataAtual + 1);

         {Pega quantos dias faltam para o último dia de qualquer período para o dia seguinte}
         {EX: Dia Atual 07/11/90, vou passar para a funcao 08/11/90 e ela irá me retornar 6 (dias)}
         {08/11/90 + 6 (dias) = 14/11/90 (ultimo dia da segunda semana se o período for semanal)}
         InterSim := DiasQueFaltamParaO_UltimoDiaDoPeriodo(DataAtual + 1, DaysInPeriod) + 1;

         Cont := 0;
         end;
      end;

    DS.PrintOptions.PrintDesc    := False;
    DS.PrintOptions.Center       := False;

    case rgQuebrarLinhas.ItemIndex of
      0: DS.PrintOptions.LineLen := 80;
      1: DS.PrintOptions.LineLen := 132;
      2: DS.PrintOptions.LineLen := 1000;
      end;

    Applic.OutPut.Show(true);

    SL := TStringList.Create();
    DS.Print(SL);
    Applic.OutPut.Editor.WriteStrings(SL);
    SL.Free();
  Finally
    DS.Free;
    Screen.Cursor := crDefault;
    Close;
  end;
end;

procedure TDLG_AnalisePorAgrupamento.FormShow(Sender: TObject);
begin
  cbPeriodo.ItemIndex := 0;
end;

procedure TDLG_AnalisePorAgrupamento.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDLG_AnalisePorAgrupamento.FormCreate(Sender: TObject);
begin
  AjustResolution(Self);
end;

end.
