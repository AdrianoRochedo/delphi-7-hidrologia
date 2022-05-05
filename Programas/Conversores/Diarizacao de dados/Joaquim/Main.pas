unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DateUtils, SpreadSheetBook_Frame, SheetWrapper, StdCtrls, drEdit;

type
  TfoMain = class(TForm)
    frPlanilha: TSpreadSheetBookFrame;
    Label1: TLabel;
    Label2: TLabel;
    edLI: TdrEdit;
    edLF: TdrEdit;
    btnConverter: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnConverterClick(Sender: TObject);
  private
    cInitialLine : integer;
    cFinalLine   : integer;

    cDateTime    : integer;
    cVol         : integer;
    cHours       : integer;
    cDays        : integer;

    cNewHours    : integer;
    cNewDate1_a  : integer;
    cNewDate1_b  : integer;
    cNewDate2    : integer;
    cNewVol1     : integer;
    cNewVol2     : integer;

    procedure write (R, C: integer; const Value: string); overload;
    procedure write (R, C: integer; const Value: real); overload;

    function AsFloat    (aRow, aCol: Integer): Real;
    function AsText     (aRow, aCol: Integer): String;
    function AsDateTime (aRow, aCol: Integer): TDateTime;

    procedure Convert();
  end;

var
  foMain: TfoMain;

implementation

{$R *.dfm}

procedure TfoMain.FormShow(Sender: TObject);
var dt: TDateTime;
begin
  frPlanilha.LoadFromFile(ExtractFilePath(Application.ExeName) + 'balanco.xls');

  // Formatos
  Sysutils.ShortDateFormat := 'DD/MM/YYYY';
  Sysutils.ShortTimeFormat := 'HH:MM';

  // Constantes - Linhas e Colunas da Planilha
  cDateTime    := 1;
  cVol         := 2;
  cHours       := 3;
  cDays        := 4;
  cNewDate1_a  := 5;
  cNewDate1_b  := 6;
  cNewHours    := 7;
  cNewVol1     := 8;
  cNewDate2    := 9;
  cNewVol2     := 10;

  // Testes
  {
  dt := Sysutils.StrToDateTime('18/03/1974 04:25');
  caption := dateTimeToStr(dt);
  }
end;

procedure TfoMain.write(R, C: integer; const Value: string);
begin
  frPlanilha.ActiveSheet.WriteCenter(R, C, Value);
end;

procedure TfoMain.write(R, C: integer; const Value: real);
begin
  frPlanilha.ActiveSheet.Write(R, C, Value);
end;

function TfoMain.AsFloat(aRow, aCol: Integer): Real;
begin
  result := frPlanilha.ActiveSheet.GetFloat(aRow, aCol);
end;

function TfoMain.AsText(aRow, aCol: Integer): String;
begin
  result := frPlanilha.ActiveSheet.GetDisplayText(aRow, aCol);
end;

function TfoMain.AsDateTime(aRow, aCol: Integer): TDateTime;
begin
  result := StrToDateTimeDef( frPlanilha.ActiveSheet.GetDisplayText(aRow, aCol), -999);
end;

procedure TfoMain.Convert();
var L1, L2, L3, Days, i: integer;
    dtAn, dtAt, dt1, dt2: TDateTime;
    Hours, h, v, v1: real;
begin
  // 1.loop: Calculo das diferencas em horas e dias -------------------------------------------------

  // Salva a data atual para ser usada como data anterior na
  // proxima execucao do loop
  dtAn := AsDateTime(cInitialLine, cDateTime);
  L1 := cInitialLine + 1;
  L2 := L1;
  while L1 <= cFinalLine do
    begin
    // Pega a data e hora atual
    dtAt := AsDateTime(L1, cDateTime);

    // Incrementa a data anterior em 1 dia para comparar com a data atual
    // Tambem armazena o dia seguinte na forma "DD/MM/YYY 00:00", este valor
    // podera ser utilizado na distribuicao das horas para o calculo dos novos
    // volumes desagregados.
    dt1 := DateUtils.DateOf( DateUtils.IncDay(dtAn, 1) );

    // Calcula a diferenca em dias
    Days := Trunc(DateUtils.DateOf(dtAt) - dt1 + 1);
    write(L1, cDays, Days);

    // Calcula a diferenca em horas
    Hours := DateUtils.HourSpan(dtAt, dtAn);
    write(L1, cHours, Hours);

    // Pega o volume
    v := frPlanilha.ActiveSheet.GetFloat(L1, cVol);

    // Desagrega os periodos
    if Days = 0 then
       begin
       // Estamos dentro do proprio dia
       write(L2, cNewDate1_a, DateTimeToStr(dtAn));
       write(L2, cNewDate1_b, DateTimeToStr(dtAt));
       write(L2, cNewHours, DateUtils.HourSpan(dtAt, dtAn));
       write(L2, cNewVol1, v);
       inc(L2);
       end
    else
       begin
       // Estamos dentro de um periodo de dias diferentes ...

       // Pega o volume
       v := frPlanilha.ActiveSheet.GetFloat(L1, cVol);

       // Data anterior ate o fim do dia
       dt1 := DateUtils.DateOf(dtAn + 1);
       h := DateUtils.HourSpan(dt1, dtAn);
       write(L2, cNewDate1_a, DateTimeToStr(dtAn));
       write(L2, cNewDate1_b, DateTimeToStr(dt1));
       write(L2, cNewHours, h);
       write(L2, cNewVol1, v / Hours * h);
       dt2 := dt1 - 1;
       inc(L2);

       // Dias que faltam
       for i := 1 to Days-1 do
         begin
         dt2 := dt1 + i - 1;
         write(L2, cNewDate1_a, DateTimeToStr(dt2));
         write(L2, cNewDate1_b, DateTimeToStr(dt2 + 1));
         write(L2, cNewHours, 24);
         write(L2, cNewVol1, v / Hours * 24);
         inc(L2);
         end;

       // Data atual ate o fim do intervalo
       h := DateUtils.HourSpan(dtAt, dt2 + 1);
       write(L2, cNewDate1_a, DateTimeToStr(dt2 + 1));
       write(L2, cNewDate1_b, DateTimeToStr(dtAt));
       write(L2, cNewHours, h);
       write(L2, cNewVol1, v / Hours * h);
       inc(L2);
       end;

    // Salva a data atual para ser usada como data anterior na
    // proxima execucao do loop
    dtAn := dtAt;

    // Vai para a proxima linha
    inc(L1);
    end; // 1.loop

  // 2.loop: Diarizacao do volume --------------------------------------------------------------------

  L1 := cInitialLine + 1;
  L3 := L2;
  L2 := L1;
  dtAn := AsDateTime(L1, cNewDate1_a);
  v := frPlanilha.ActiveSheet.GetFloat(L1, cNewVol1);
  inc(L1);
  while L1 < L3 do
    begin
    // Pega a data e hora atual
    dtAt := AsDateTime(L1, cNewDate1_a);

    // Pega o volume atual
    v1 := frPlanilha.ActiveSheet.GetFloat(L1, cNewVol1);

    if DateUtils.DateOf(dtAt) = DateUtils.DateOf(dtAn) then
       v := v + v1
    else
       begin
       write(L2, cNewDate2, DateToStr(dtAn));
       write(L2, cNewVol2 , v);
       inc(L2);
       v := v1;
       end;

    dtAn := dtAt;   

    inc(L1);
    end;

    write(L2, cNewDate2, DateToStr(dtAn));
    write(L2, cNewVol2 , v);
end;

procedure TfoMain.btnConverterClick(Sender: TObject);
begin
  frPlanilha.SS.DefaultColWidth := 80;
  frPlanilha.LoadFromFile(ExtractFilePath(Application.ExeName) + 'balanco.xls');

  cInitialLine := edLI.AsInteger;
  cFinalLine   := edLF.AsInteger;

  // Cabecalhos
  write(1, cHours   , 'Horas');
  write(1, cDays    , 'Dias');
  write(1, cNewDate1_a, 'Int.Ini.');
  write(1, cNewDate1_b, 'Int.Fin.');
  write(1, cNewHours, 'Horas');
  write(1, cNewVol1 , 'Volume');
  write(1, cNewDate2, 'Dia');
  write(1, cNewVol2 , 'Vol.Dia');
  frPlanilha.ActiveSheet.BoldRow(1);

  // Dimensao das colunas
  frPlanilha.ActiveSheet.ColWidth[cNewDate1_a] := 140;
  frPlanilha.ActiveSheet.ColWidth[cNewDate1_b] := 140;

  frPlanilha.SS.BeginUpdate();
  try
    Convert();
  finally
    frPlanilha.SS.EndUpdate();
  end;
end;

end.
