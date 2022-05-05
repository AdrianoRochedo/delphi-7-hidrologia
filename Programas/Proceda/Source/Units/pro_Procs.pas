unit pro_Procs;

interface                          
uses Classes, SysUtilsEx,
     pro_Classes,
     pro_Interfaces;

  {Converte os índices dos postos armazenados em um conjunto para sua representação em String}
  function SetToPostos(var s: TByteSet; Info: TDSInfo): String;

  {Obtem uma lista com as informações sobre os períodos válidos de todos os postos}
  function ObtemPeriodosValidos(Info: TDSInfo; Postos: TStrings = nil): TListaDePeriodos;

  {Obtem uma lista com as informações sobre os períodos válidos/inválidos dos postos}
  function ObtemPeriodos(Info: TDSInfo; Validos: Boolean; Postos: TStrings = nil): TListaDePeriodos;

  {Obtém o número de dias para um intervalo de simulação
   EX: Intervalo = semanal --> Número de dias = 7}
  {OBS: Cuidado com a ordem dos índices}
  Function DiasNoPeriodo(IndexIntSim: Integer; Data: TDateTime = 0): Integer;

  {Retorna quantos dias faltam para o último dia de um determinado periodo para uma data qualquer
   EX: Se eu passar o dia 08/11/90 e definir o período como SEMANAL , ela irá me retornar 6 (dias)
   08/11/90 + 6 (dias) = 14/11/90 (ultimo dia da segunda semana}
  Function DiasQueFaltamParaO_UltimoDiaDoPeriodo(Data: TDateTime; DiasNoPeriodo: Integer): Integer;

  {Faz a leitura das informações armazenadas no arquivo de definação de um PLU}
  Function Load_PLUDEF(var F: File): TRecPLU_DEF;

  {Faz a leitura das informações armazenadas no arquivo de definação de um VZO}
  Function Load_VZODEF(var F: File): TRecVZO_DEF;

  {Libera as informações armazenadas no arquivo de definação de um PLU}
  Procedure UnLoad_PLUDEF(x: TRecPLU_DEF);

  {Libera as informações armazenadas no arquivo de definação de um VZO}
  Procedure UnLoad_VZODEF(x: TRecVZO_DEF);

  {Esta funcao verifica se a data passada é o primeiro dia do mes, caso seja a funcao retorna
  true caso contrario retorna False}
  Function Primeiro_dia_do_mes(Data : TDateTime): Boolean;

  {Esta funcao verifica se a data passada é o ultimo dia do mes, caso seja a funcao retorna
  true caso contrário retorna False}
  Function Ultimo_dia_do_mes(Data : TDateTime): Boolean;

 { Verifica se a Data passada é maior ou igual a menor data global (gDados.minDate),
 Caso a data passada seja maior ou igual a menor data global(portanto VALIDA)retorna True,
 Caso a data passada seja menor que a menor data global(portanto INVALIDA) retorna False }
  Function ValidaDataInicial(Data, MinDate: TDateTime): Boolean;

 { Verifica se a data 2 é maior que a data 1, caso a data2 seja menor que a Data1,
  retorna False (ou seja data invalida), caso contrario retorna True}
  Function ValidaDataFinal  (Data1, Data2: TDateTime): Boolean;

implementation
uses stDate, SysUtils, Dialogs,
     wsMatrix,
     wsGLib,
     wsVec,
     pro_Const;

function SetToPostos(var s: TByteSet; Info: TDSInfo): String;
var i: byte;
begin
  Result := '';
  for i := 0 to 255 do
    if i in s then
       if Result = '' then
          Result := Info.Station[i].Nome
       else
          Result := Result + ', ' + Info.Station[i].Nome;
end;

function ObtemPeriodosValidos(Info: TDSInfo; Postos: TStrings = nil): TListaDePeriodos;
var i, j : Integer;
    ds   : TwsDataSet;
    dAn  : TDateTime;    // Data anterior
    dAt  : TDateTime;    // Data atual
    dIn  : TDateTime;    // Data inicial
    x    : Double;
    pAn  : TByteSet;     // Postos anteriores
    pAt  : TByteSet;     // Postos Atuais
    fp   : Boolean;      // Formando um periodo
    s    : String;

    IndCols : TwsLIVec;  // Índices das colunas quando são passados os postos
begin
  fp  := False;
  pAn := [];
  pAt := [];
  ds  := Info.DS;
  dAt := 0;

  Result := TListaDePeriodos.Create;

  if Postos <> nil then
     IndCols := ds.IndexColsFromStrings(Postos);

  for i := 1 to ds.NRows do
    begin
    dAn := dAt;
    dAt := Info.DS.AsDateTime[i, 1];

    if Postos = nil then
       for j := cPostos to ds.NCols do
         if ds.IsMissValue(i, j, x) then Exclude(pAt, j-cPostos) else Include(pAt, j-cPostos)
    else
       for j := 1 to IndCols.Len do
         if ds.IsMissValue(i, IndCols[j], x) then
            Exclude(pAt, IndCols[j]-cPostos)
         else
            Include(pAt, IndCols[j]-cPostos);

    if pAt <> pAn then
       begin
       if fp then
          if pAn <> [] then
             Result.Adicionar(dIn, dAn, pAn)
          else
             // Inicio do período
       else
          fp := true;

       dIn := dAt;
       pAn := pAt;
       end
    else
       if (i = ds.NRows) and (pAt <> []) then
          Result.Adicionar(dIn, dAt, pAt);
    end; // para todas as linhas

  if Postos <> nil then
     IndCols.Free;
end;

Function DiasNoPeriodo(IndexIntSim: Integer; Data: TDateTime = 0): Integer;
var Ano, Mes, Dia: Word;
begin
  Case TTipoIntervalo(IndexIntSim) of
    tiDiario       : Result := 1;
    tiQuinquendial : Result := 5;
    tiSemanal      : Result := 7;
    tiDecendial    : Result := 10;
    tiQuinzenal    : Result := 15;

    tiMensal       : Begin
                     DecodeDate(Data, Ano, Mes, Dia);
                     Result := DaysInMonth(Mes, Ano, 0);
                     End;

    tiAnual        : Begin
                     DecodeDate(Data, Ano, Mes, Dia);
                     Result := 365 + byte(isLeapYear(Ano));
                     End;
    end;
end;

Function DiasQueFaltamParaO_UltimoDiaDoPeriodo(Data: TDateTime; DiasNoPeriodo: Integer): Integer;
Var NDP            : Integer; {Número de Períodos}
    Px             : Integer; {Enégimo Período do Mês}
    Dia, Mes, Ano  : Word;
begin
  DecodeDate(Data, Ano, Mes, Dia);
  If DiasNoPeriodo < 28 {Não Mensal} Then
     begin
     NDP := 30 div DiasNoPeriodo;
     Px := (Dia - 1) div DiasNoPeriodo + 1;
     If Px < NDP Then
        Result := DiasNoPeriodo * Px - Dia
     Else
        Result := DaysInMonth(Mes, Ano, 0) - Dia;
     end
  Else
     Result := DiasNoPeriodo - Dia;
end;

{Faz a leitura das informações armazenadas no arquivo de definação de um PLU}
Function Load_PLUDEF(var F: File): TRecPLU_DEF;
var i,j          : Word;
    aByte        : Byte;
    aWord        : Word;
    aDouble      : Double;
    aBoolean     : Boolean;
    aString50    : String[50];
begin
   {Intervalo de Computação}
   BlockRead(F, aByte, SizeOf(aByte));
   Result.IntComp := aByte;

   {Intervalo de Simulação}
   BlockRead(F, aByte, SizeOf(aByte));
   Result.IntSim := aByte;

   {Linhas}
   BlockRead(F, aWord, SizeOf(aWord));
   Result.Linhas  := aWord;

   {Colunas}
   BlockRead(F, aWord, SizeOf(aWord));
   Result.Colunas := aWord;

   {Dados da grade - Parte 1}
   Result.Valores := TStringList.Create;
   For i := 0 to Result.Colunas - 1 do
     For j := 0 to Result.Linhas - 1 do
       begin
       BlockRead(F, aString50, SizeOf(aString50));
       Result.Valores.Add(aString50);
       end;

   {Dados da grade - Parte 2}
   Result.PostosSel := TStringList.Create;
   For i := 1 to Result.Colunas - 1 do
     For j := 2 to Result.Linhas - 1 do
       begin
       BlockRead(F, aBoolean, SizeOf(aBoolean));
       Result.PostosSel.Add(IntToStr(Byte(aBoolean)));
       end;

   {Data Inicial}
   BlockRead(F, aDouble, SizeOf(aDouble));
   Result.DataIni := aDouble;
end;

{Faz a leitura das informações armazenadas no arquivo de definação de um VZO}
Function Load_VZODEF(var F: File): TRecVZO_DEF;
var i            : Word;
    aByte        : Byte;
    aInteger     : Integer;
    aDouble      : Double;
    aString30    : String[30];
begin
  {Le o número de Intervalos}
  BlockRead(F, aInteger, SizeOf(aInteger));
  Result.nIntervalos := aInteger;

  {Intervalo de Computacao}
  BlockRead(F, aByte, SizeOf(aByte));
  Result.IntComp := aByte;

  {Intervalo de Simulação}
  BlockRead(F, aByte, SizeOf(aByte));
  Result.IntSim := aByte;

  {Posto}
  BlockRead(F, aString30, SizeOf(aString30));
  Result.Posto := aString30;

  {Le os intervalos iniciais}
  Result.InterIni := TStringList.Create;
  For i := 1 to Result.nIntervalos do
    begin
    BlockRead(F, aDouble, SizeOf(aDouble));
    Result.InterIni.Add(DateToStr(aDouble));
    end;

  {Le os intervalos iniciais}
  Result.InterFin := TStringList.Create;
  For i := 1 to Result.nIntervalos do
    begin
    BlockRead(F, aDouble, SizeOf(aDouble));
    Result.InterFin.Add(DateToStr(aDouble));
    end;

  Result.Multiplic := 1;
  Result.UsarMultiplic := False;
  if EOF(F) then Exit; // Para arquivos antigos

  {Multiplicador}
  BlockRead(F, aDouble, SizeOf(aDouble));
  Result.Multiplic := aDouble;

  {Usar Multiplicador}
  BlockRead(F, aByte, SizeOf(aByte));
  Result.UsarMultiplic := Boolean(aByte);
end;

{Libera as informações armazenadas no arquivo de definação de um PLU}
Procedure UnLoad_PLUDEF(x: TRecPLU_DEF);
begin
  x.PostosSel.Free;
  x.Valores.Free;
end;

{Libera as informações armazenadas no arquivo de definação de um VZO}
Procedure UnLoad_VZODEF(x: TRecVZO_DEF);
begin
  x.InterIni.Free;
  x.InterFin.Free;
end;

Function Primeiro_dia_do_mes(Data : TDateTime): Boolean;
Var Ano, Mes, Dia : Word;
Begin
  Result := True;
  DecodeDate(Data, Ano, Mes, Dia);
  If Dia <> 1  then
     begin
     MessageDlg(Format(cMSG4, [DateTimeToStr(Data)]), mtInformation, [mbOk], 0);
     Result := False;
     end;
End;

Function Ultimo_dia_do_mes(Data : TDateTime): Boolean;
Var Ano, Mes, Dia : Word;
Begin
  Result := True;
  DecodeDate(Data, Ano, Mes, Dia);
  If Dia < DaysInMonth(Mes, Ano, Ano)  then
     begin
     MessageDlg( Format(cMSG6,[DateTimeToStr(Data)]), mtInformation, [mbOk], 0);
     Result := False;
     end;
End;

Function ValidaDataInicial(Data, MinDate: TDateTime): Boolean;
Begin
If Data < MinDate  then
   begin
   MessageDlg( cMSG4, mtInformation, [mbOk], 0);
   Result := False;
   end
else
   Result := True;
End;

{Verifica se a data 2 é maior que a data 1, caso a data2 seja menor que a Data1,
retorna False (ou seja data invalida), caso contrario retorna True}
Function ValidaDataFinal  (Data1, Data2: TDateTime): Boolean;
Begin
If Data2  < Data1  then
   begin
   MessageDlg( cMSG5, mtInformation, [mbOk], 0);
   Result := False;
   end
else
   Result := True;
End;

function ObtemPeriodos(Info: TDSInfo; Validos: Boolean; Postos: TStrings = nil): TListaDePeriodos;
var i, j : Integer;
    ds   : TwsDataSet;
    dAn  : TDateTime;    // Data anterior
    dAt  : TDateTime;    // Data atual
    dIn  : TDateTime;    // Data inicial
    x    : Double;
    pAn  : TByteSet;     // Postos anteriores
    pAt  : TByteSet;     // Postos Atuais
    fp   : Boolean;      // Formando um periodo
    s    : String;

    IndCols : TwsLIVec;  // Índices das colunas quando são passados os postos
begin
  fp  := False;
  pAn := [];
  pAt := [];
  ds  := Info.DS;
  dAt := 0;

  Result := TListaDePeriodos.Create;

  if Postos <> nil then
     IndCols := ds.IndexColsFromStrings(Postos);

  for i := 1 to ds.NRows do
    begin
    dAn := dAt;
    dAt := Info.DS.AsDateTime[i, 1];

    if Postos = nil then
       for j := cPostos to ds.NCols do
         if ds.IsMissValue(i, j, x) then Exclude(pAt, j-cPostos) else Include(pAt, j-cPostos)
    else
       for j := 1 to IndCols.Len do
         if ds.IsMissValue(i, IndCols[j], x) then
            Exclude(pAt, IndCols[j]-cPostos)
         else
            Include(pAt, IndCols[j]-cPostos);

    if pAt <> pAn then
       begin
       if fp then
          if Validos then
             if pAn <> [] then
                Result.Adicionar(dIn, dAn, pAn)
             else
                // Inicio do período
          else
             if pAn = [] then
                Result.Adicionar(dIn, dAn, pAn)
             else
                // Inicio do período
       else
          fp := true;

       dIn := dAt;
       pAn := pAt;
       end
    else
       if i = ds.NRows then
          if Validos then
             if pAt <> [] then
                Result.Adicionar(dIn, dAt, pAt)
             else
                // nada
          else
             if pAt = [] then
                Result.Adicionar(dIn, dAt, pAt)
    end; // para todas as linhas

  if Postos <> nil then
     IndCols.Free;
end;

end.
