unit Ch_func;

interface
uses Classes, Forms, Controls, DB, DBTables, SysUtils, SysUtilsEx, FileUtils,
     {$ifdef CHUVAZ}
     wsMatrix,
     {$endif}
     CH_CONST;

  { - Obtém um código para um posto que não é numérico
    - Guarda o código e seu correspondente gerador em um arquivo
      Formato: código gerado = nome do posto
    - Gera uma mensagem avisando o usuário qual operação foi feita}
  function ObtemCodigo(const Posto: String): Integer;

{$ifdef CHUVAZ}
(*
  {Obtem uma lista com as informações sobre os períodos válidos de todos os postos}
  function ObtemPeriodosValidos(Dados: TQuery; RecDados: pTGlobalDataRec): TList;
*)
  {Converte os índices dos postos armazenados em um conjunto para sua representação em String}
  function SetToPostos(var s: TByteSet; RecDados: pTGlobalDataRec): String;

  {Obtem uma lista com as informações sobre os períodos válidos/inválidos dos postos}
  function ObtemPeriodos(RecDados: pTGlobalDataRec; Validos: Boolean; Postos: TStrings = nil): TListaDePeriodos;

  {Se a tabela de postos não existir, eu a crio}
  function CriaTabelaDeInformacaoDosPostos(const s: String): Boolean;

  {Cria um lista com os diferentes postos do arquivo}
  function CriaListaPostos(Name: String): TStrings;

  {Destroi os postos e cada período associado a eles}
  procedure DestroiListaDePostos(Postos: TStrings);

  {Cria uma tabela de dados de Postos}
  Function CriaTabelaDePostos(Const S: String; out Erro: String): TTable;

  {Seleciona todos os dados entre um intervalo de tempo}
  function SelectInterval(DI, DF: TDateTime; Const FileName: String): TQuery;

  {
  Transforma um DB em DST: Seguindo o formato ...
  DB(Posto, Data, Dado) --> DST(DadoPosto1, DadoPosto2, ..., DadoPostoN)          TIPO DIARIO
                            DST(Dadas, DadoPosto1, DadoPosto2, ..., DadoPostoN)   TIPO MENSAL
  OBS: O DST deve conter uma Dada Inicial e o tipo do Período
  }

  Function DBtoDST(x: TGlobalDataRec): TwsDataSet;

  {Seleciona os principais dados}
  {Menor Data, Maior Data, As identificações dos postos}
  function SelectData(Const Name: String; var x: TGlobalDataRec): Boolean;

  {Verifica se o arquivo especificado ja está em uso pelo sistema}
  Function ArquivoJaAberto(Const s: String): Boolean;

  // Remove os arquivos temporários criados por uma má operação do sistema
  procedure RemoveArquivosTemporarios(Dir: String);

  //Retorna as linhas de inicio e final para as datas dadas
  procedure ProcuraDatas(pDados: pTGlobalDataRec; const sDI, sDF: String; out LI, LF: Integer);
{$endif}

  {Registra as informações no arquivo de postos}
  function RegistraPosto(x: Array of Const): Integer;

  {Obtém o número de dias para um intervalo de simulação
   EX: Intervalo = semanal --> Número de dias = 7}
  {OBS: Cuidado com a ordem dos índices}
  Function GetDaysInPeriod(IndexIntSim: Integer; Data: TDateTime = 0): Integer;

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

 { Verifica se a Data passada é maior ou igual a menor data global (gDados.minDate),
 Caso a data passada seja maior ou igual a menor data global(portanto VALIDA)retorna True,
 Caso a data passada seja menor que a menor data global(portanto INVALIDA) retorna False }
  Function ValidaDataInicial(Data, MinDate: TDateTime): Boolean;

 { Verifica se a data 2 é maior que a data 1, caso a data2 seja menor que a Data1,
  retorna False (ou seja data invalida), caso contrario retorna True}
  Function ValidaDataFinal  (Data1, Data2: TDateTime): Boolean;

 {Esta funcao verifica se a data passada é o ultimo dia do mes, caso seja a funcao retorna
  true caso contrário retorna False}
  Function Ultimo_dia_do_mes(Data : TDateTime): Boolean;

 {Esta funcao verifica se a data passada é o primeiro dia do mes, caso seja a funcao retorna
  true caso contrario retorna False}
  Function Primeiro_dia_do_mes(Data : TDateTime): Boolean;

  // Salva as informações dos arquivos Mensais
  procedure SalvarArquivoAuxiliar(const x: TGlobalDataRec);

  // Dado uma data (mes, ano), retorna o número de dias do último período do mês
  function ObtemQuantidadeDeDiasDoUltimoPeriodo(TamanhoIntervalo: Byte; Mes, Ano: Word): byte;

  // Obtem o número de períodos que não sofrem variação de tamanho dependendo do tam. do Intervalo
  function ObtemPeriodosExatosNosMeses(TamanhoIntervalo: byte): byte;

implementation
uses {$ifdef CHUVAZ} wsgLIB, wsVec, {$endif}
     Dialogs, GaugeFo, stDate, FileCtrl, iniFiles, wsConstTypes;

function ObtemCodigo(const Posto: String): Integer;
var Ini : TIniFile;
    SL  : TStrings;
begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Chuvaz.ini');
  if Ini.SectionExists(INI_SECTION_CODPOSTOS) then
     begin
     SL := TStringList.Create;
     Ini.ReadSection(INI_SECTION_CODPOSTOS, SL);
     Ini.WriteString(INI_SECTION_CODPOSTOS, intToStr(SL.Count + 1), Posto);
     Result := SL.Count + 1;
     SL.Free;
     end
  else
     begin
     Result := 1;
     Ini.WriteString(INI_SECTION_CODPOSTOS, '1', Posto);
     end;

  Ini.Free;
end;

function RegistraPosto(x: Array of Const): Integer;
begin
  Try
    Result := StrToInt(string(x[0].VAnsiString));
  Except
    Result := ObtemCodigo(string(x[0].VAnsiString));
  End;
end;

{$ifdef CHUVAZ}
(*
{Obtem uma lista com as informações sobre os períodos válidos de todos os postos}
function ObtemPeriodosValidos(Dados: TQuery; RecDados: pTGlobalDataRec): TList;
var  DataInicial,
     DataAnterior,
     DataAtual      : TDateTime;
     PostoAtual     : Longint;
     PostoAnterior  : Longint;
     i              : integer;
     nReg           : Longint;
     Limite         : byte;

   procedure AdicionaPeriodo(const DI, DF: TDateTime; const Posto: Cardinal);
   var p: pRecDadosPeriodo;
   begin
     new(p);
     p.DI := DI;
     p.DF := DF;
     p.Posto := Posto;
     Result.Add(p);
   end;

   Procedure InsereDado;
   Begin
     if (DataAtual - DataAnterior = 1) and (PostoAtual = PostoAnterior) then
        AdicionaPeriodo(DataInicial, DataAtual, PostoAnterior)
     else
        AdicionaPeriodo(DataInicial, DataAnterior, PostoAnterior);
   End;

   Procedure Pesquisa;
   Begin
     nReg := 1;
     Dados.First;
     While not Dados.Eof do
       begin
       {Procura a primeira data inicial válida}
       DataInicial  :=  Dados.Fields[1].AsDateTime;
       PostoAtual   :=  Dados.Fields[0].AsInteger;

       DataAnterior  := DataInicial;
       DataAtual     := DataInicial;
       PostoAnterior := PostoAtual;

       {Procura pelo final do intervalo}
       while (DataAtual - DataAnterior <= Limite) and
             (PostoAtual = PostoAnterior) do
         begin
         F.Next;
         Inc(nReg); Pr.Value := nReg;

         if Dados.Eof then break;

         DataAnterior := DataAtual;
         DataAtual    := Dados.Fields[1].AsDateTime;
         PostoAtual   := Dados.Fields[0].AsInteger;
         end;
       InsereDado;
       end;
   End;

begin
  Result := Nil;
  If Dados = Nil Then Exit;

  FMensal := (RecDados.Tipo = tiMensal);
  Limite  := 1 + 30 * byte(FMensal); // 1 para diarios ou 31 para mensais

  Dados.DisableControls;
  Screen.Cursor := crHourGlass;
  Try
    Result := TList.Create;
    Pesquisa;
  Finally
    Screen.Cursor := crDefault;
    Dados.EnableControls;
  End;
end;
*)

function SetToPostos(var s: TByteSet; RecDados: pTGlobalDataRec): String;
var i: byte;
begin
  Result := '';
  for i := 0 to 255 do
    if i in s then
       if Result = '' then
          Result := RecDados.Postos[i]
       else
          Result := Result + ', ' + RecDados.Postos[i]
end;

function ObtemPeriodos(RecDados: pTGlobalDataRec; Validos: Boolean; Postos: TStrings = nil): TListaDePeriodos;
var i, j : Integer;
    ds   : TwsDataSet;
    em   : byte;         // É mensal
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
  em  := byte(RecDados.Tipo = tiMensal);
  ds  := RecDados.DataSet;
  dAt := 0;

  Result := TListaDePeriodos.Create;

  if Postos <> nil then
     IndCols := ds.IndexColsFromStrings(Postos);

  for i := 1 to ds.NRows do
    begin
    dAn := dAt;
    if boolean(em) then dAt := ds[i, 1] else dAt := RecDados.MinDate + i - 1;

    if Postos = nil then
       for j := 1+em to ds.NCols do
         if ds.IsMissValue(i, j, x) then Exclude(pAt, j-em-1) else Include(pAt, j-em-1)
    else
       for j := 1 to IndCols.Len do
         if ds.IsMissValue(i, IndCols[j], x) then
            Exclude(pAt, IndCols[j]-1)
         else
            Include(pAt, IndCols[j]-1);

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

function CriaListaPostos(Name: String): TStrings;
var Table : TQuery;
    pr    : pTPeriodo;
begin
  Screen.Cursor := crHourGlass;
  Table := TQuery.Create(nil);
  Try
    Table.SQL.Clear;
    Table.SQL.Add(Format( cSQL_MinMaxDatePostos, [Name]));
    Table.Open;
    If Table.RecordCount > 0 then
       begin
       Table.First;
       Result := TStringList.Create;
       while Not Table.Eof do
         begin
         // cria o registro das datas do posto
         New(pr);
         pr.Inicio := Table.Fields[1].AsString;
         pr.Fim := Table.Fields[2].AsString;

         Result.AddObject(Table.Fields[0].AsString, pointer(pr));
         Table.next;
         end;
       end
    else
       Result := nil;
  Finally
    Screen.Cursor := crDefault;
    Table.Free;
  End;
end;

{----------------------------------------------------------}
{Seleciona todos os dados entre um intervalo de datas}
function SelectInterval(DI, DF: TDateTime; Const FileName: String): TQuery;
Var sDI, sDF: String;
begin
  Result := TQuery.Create(nil);
  With Result do
    begin
    DateTimeToString(sDI, cSQLDate, DI);
    DateTimeToString(sDF, cSQLDate, DF);
    SQL.ADD(Format(cSQL_Periodo, [FileName, sDI, sDF]));
    Open;
    If Result.RecordCount = 0 Then
       begin
       Free;
       Result := nil;
       MessageDLG(Format('Nenhum registro foi encontrado entre %s e %s.',
           [DateToStr(DI), DateToStr(DF)]), mtWarning, [mbOK], 0);
       end;
    end
end;
{----------------------------------------------------------}

{
Converte um arquivo do tipo Paradox (.DB) num DataSet (.DST)
ALGORÍTMO:
  1) Selecionar a menor e a maior data
  2) Criar um DataSet com:
     (Maior data - Menor data + 1) Linhas
     (Número distinto de postos + 3) Colunas
  3) Percorrer a tabela original
     (Ordenana por Posto, Data)
       Para cada registro:
         Linha  = DataAtual - Menor Data + 1
         Coluna = Índice do posto + 4
         DataSet[Linha, Coluna] = x
}

Function DBtoDST(x: TGlobalDataRec): TwsDataSet;
Var i:           Integer;
    PostoOld:    String;
    s:           String;
    IndicePosto: Integer;
    Linha:       Longint;
    Coluna:      Longint;
    nReg:        Longint;
    DataAtual:   TDateTime;
    ColEstrut:   TwsDSStructure;
    Pr:          TDLG_Progress;

    SF: TStringField;
    FF: TFloatField;
    DF: TDateField;
Begin
   SF := TStringField(x.Tab.Fields[0]);
   DF := TDateField(x.Tab.Fields[1]);
   FF := TFloatField(x.Tab.Fields[2]);

  {Cria o DataSet e inicialíza-o}
  ColEstrut := TwsDSStructure.Create;

  if x.Tipo = tiMensal then
     ColEstrut.AddNumeric('Datas', '');

  For i := 0 to x.Postos.Count - 1 do
     begin
     ColEstrut.AddNumeric(GetValidID(x.Postos[i]), 'Posto ' + x.Postos[i]);
     ColEstrut.ColByName(GetValidID(x.Postos[i])).Size := 10;
     end;

  if x.Tipo = tiMensal then
     i := x.Meses
  else
     i := Trunc(x.MaxDate - x.MinDate + 1);

  Result := TwsDataSetChuvaz.CreateStructured(
              'DADOS' {Nome do Conjunto},
              i {Número de linhas},
              ColEstrut {Estrutura das colunas});

  Result.PrintOptions.PrintDesc := false;
  TwsDataSetChuvaz(Result).BaseDate := x.MinDate;

  For Linha := 1 to Result.nRows do
    For Coluna := 1 to x.Postos.Count do
      Result[Linha, Coluna] := wscMissValue;

  {Percorre a tabela}
  x.Tab.DisableControls;
  x.Tab.First;
  PostoOld := ''; //. -1;
  IndicePosto := 0;
  nReg := 0;
  Pr := CreateProgress(-2, -2, x.Tab.RecordCount, 'Preparando arquivo');
  Try
    While not x.Tab.EOF do
      Begin
      DataAtual := DF.Value;

      s := SF.Value;
      If s <> PostoOld Then
         Begin
         PostoOld := s;
         Inc(IndicePosto);
         Linha := 0; // Somente para arquivos mensais
         End;

      if x.Tipo = tiMensal then
         begin
         inc(Linha);

         // A primeira coluna é a data
         Result[Linha, 1] := DataAtual;
         Result[Linha, IndicePosto + 1] := FF.Value {Valor};
         end
      else
         begin
         Linha  := Trunc(DataAtual - x.MinDate + 1);
         Result[Linha, IndicePosto] := FF.Value {Valor};
         end;

      x.Tab.Next;
      Inc(nReg); Pr.Value := nReg;
      End;
  Finally
    x.Tab.EnableControls;
  End;
End; {DBtoDST}

procedure DestroiListaDePostos(Postos: TStrings);
var i: Integer;
begin
  for i := 0 to Postos.Count-1 do
    Dispose(pTPeriodo(Postos.Objects[i]));
  Postos.Free;
end;

function SelectData(Const Name: String; var x: TGlobalDataRec): Boolean;
var q: TQuery;
    s: String;
begin
  Result := False;
  q := TQuery.Create(nil);
  q.SQL.Add(Format(cSQL_MinMaxDate, [Name]));
  Application.MainForm.Enabled := False;

  s := Application.MainForm.Caption;
  Application.MainForm.Caption := s + ' (Selecionando Intervalo Principal)';
  Application.ProcessMessages;
  Try
    q.Open;

    x.Lockeds := 0;

    if q.RecordCount > 0 Then
       begin
       x.MinDate := q.Fields[0].AsDateTime;
       x.MaxDate := q.Fields[1].AsDateTime;
       end
    else
       x.MinDate := 0;

    If Assigned(x.Postos) Then DestroiListaDePostos(x.Postos);
    if x.MinDate <> 0 then
       begin
       Application.MainForm.Caption := s + ' (Selecionando Intervalo para cada Posto)';
       Application.ProcessMessages;
       x.Postos := CriaListaPostos(Name);
       end;

    Application.MainForm.Caption := s;
    Application.ProcessMessages;

    If Assigned(x.DataSet) Then x.DataSet.Free;
    if x.Postos <> nil Then
       begin
       x.DataSet := DBtoDST(x);
       x.DataSet.PrintOptions.MaxIDSize := 15;
       TwsDataSetChuvaz(x.DataSet).Mensal := (x.Tipo = tiMensal);
       end;

    Result := (x.MinDate <> 0) and (x.Postos <> nil) and (x.DataSet <> nil)
  Finally
    q.Free;
    Application.MainForm.Enabled := True;
  End;
end;
{$endif}

Function GetDaysInPeriod(IndexIntSim: Integer; Data: TDateTime = 0): Integer;
var Ano, Mes, Dia: Word;
begin
  Case IndexIntSim of
    cINTSIM_DIARIO:       Result := 1;
    cINTSIM_QUINQUENDIAL: Result := 5;
    cINTSIM_SEMANAL:      Result := 7;
    cINTSIM_DECENDIAL:    Result := 10;
    cINTSIM_QUINZENAL:    Result := 15;
    cINTSIM_MENSAL:       Begin
                          DecodeDate(Data, Ano, Mes, Dia);
                          Result := DaysInMonth(Mes, Ano, 0);
                          End;
    cINTSIM_ANUAL:        Begin
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

{Esta funcao verifica se a data passada é o ultimo dia do mes, caso seja a funcao retorna
true caso contrario retorna False}
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

{Esta funcao verifica se a data passada é o primeiro dia do mes, caso seja a funcao retorna
 true caso contrario retorna False}
Function Primeiro_dia_do_mes(Data : TDateTime): Boolean;
Var Ano, Mes, Dia : Word;
Begin
  Result := True;
  DecodeDate(Data, Ano, Mes, Dia);
  If Dia <> 1  then
     begin
     MessageDlg( Format(cMSG4,[DateTimeToStr(Data)]), mtInformation, [mbOk], 0);
     Result := False;
     end;
End;

Function CriaTabelaDePostos(Const S: String; out Erro: String): TTable;
begin
  Erro := '';
  Result := TTable.Create(nil);
  try
    with Result do
      begin
      Active := False;
      TableName := S;
      TableType := ttParadox;
      TableLevel := 7;
      with FieldDefs do
        begin
        Clear;
        Add('Posto',  ftString , 10, false);
        Add('Data' ,  ftDate   ,  0, false);
        Add('Dado' ,  ftFloat  ,  0, false);
        end;
      CreateTable;
      Open;
      end;
  Except
    On E: Exception do
       begin
       Erro := E.Message;
       Result.Free;
       Result := nil;
       end;
  end;
end;

{$ifdef CHUVAZ}
Function ArquivoJaAberto(Const s: String): Boolean;
Var i: Integer;
Begin
  Result := False;
  For i := 0 to gList.Count - 1 do
    If CompareText(gList.Data[i].FileName, s) = 0 Then
       begin
       Result := True;
       Break;
       end;
End;

function CriaTabelaDeInformacaoDosPostos(const s: String): Boolean;
Var T   : TTable;
    dir : String;
begin
  Result := True;
  dir := ExtractFilePath(s);
  if not DirectoryExists(dir) then Result := CreateDir(dir);
  if not Result then exit;

  T := TTable.Create(nil);
  try
    with T do
      begin
      Active    := False;
      TableName := s;
      TableType := ttParadox;
      with FieldDefs do
        begin
        Clear;
        Add('Codigo'  ,  ftAutoInc,   0, false);
        Add('Nome'    ,  ftString ,  50, false);
        Add('Arquivo' ,  ftString , 160, false);
        end;

      CreateTable;
      end;
  finally
    T.Free;
  end;
end;

procedure RemoveArquivosTemporarios(Dir: String);
var i : Integer;
    SL: TStrings;
begin
  //Dir := ExtractFilePath(Dir);
  if LastChar(Dir) = '\' then Delete(Dir, Length(Dir), 1);
  if not DirectoryExists(Dir) then Exit;
  SL := EnumerateFiles(['*'], Dir, False);
  Try
    For i := 0 to SL.Count - 1 do
      if System.Pos('_qsq', SL[i]) > 0 then
         DeleteFile(SL[i]);
  Finally
    SL.Free;;
  End;
end;

//Retorna as linhas de inicio e final para as datas dadas
procedure ProcuraDatas(pDados: pTGlobalDataRec; const sDI, sDF: String; out LI, LF: Integer);
var i: Integer;
    dd, mm, aa: Word;
    DI, DF: TDateTime;
begin
  LI := -1;
  LF := -1;

  if (sDI = '  /  /    ') or (sDI = '') then
     DI := pDados.MinDate
  else
     DI := StrToDate(sDI);

  if (sDF = '  /  /    ') or (sDF = '') then
     DF := pDados.MinDate
  else
     DF := StrToDate(sDF);

  if DI > DF then
     Raise Exception.Create('Data Inicial maior que a Data Final');

  if DI < pDados.MinDate then DI := pDados.MinDate;
  if DF > pDados.MaxDate then DF := pDados.MaxDate;

  if pDados.Tipo = tiDiario then
     begin
     LI := Trunc(DI - pDados.MinDate + 1);
     LF := Trunc(DF - pDados.MinDate + 1);
     end
  else
     begin
     DecodeDate(DI, aa, mm, dd);
     DI := EncodeDate(aa, mm, 01);
     for i := 1 to pDados.DataSet.nRows do
       if pDados.DataSet[i, 1] = DI then
          begin
          LI := i;
          Break;
          end;

     DecodeDate(DF, aa, mm, dd);
     DF := EncodeDate(aa, mm, 01);
     for i := LI to pDados.DataSet.nRows do
       if pDados.DataSet[i, 1] = DF then
          begin
          LF := i;
          Break;
          end;
     end;

  if LI = -1 then LI := 1;
  if LF = -1 then LF := pDados.DataSet.nRows;
end;
{$endif}

procedure SalvarArquivoAuxiliar(const x: TGlobalDataRec);
begin
  with TStringList.Create do
    begin
    Add('[GERAL]');
    Add('TIPO=MENSAL');
    Add('MESES=' + intToStr(x.Meses));
    SaveToFile(ChangeFileExt(x.FileName, '.CZ'));
    Free;
    end;
end;

function ObtemPeriodosExatosNosMeses(TamanhoIntervalo: byte): byte;
begin
  case TamanhoIntervalo of
    5:  Result := 5;
    7:  Result := 4;
    10: Result := 2;
    15: Result := 1;
  end;
end;

function ObtemQuantidadeDeDiasDoUltimoPeriodo(TamanhoIntervalo: Byte; Mes, Ano: Word): byte;
var Dias: byte;
begin
  Dias := DaysInMonth(Mes, Ano, Ano);
  case TamanhoIntervalo of
    1:  Result := 0;
    5:  Result := Dias - 25;
    7:  Result := Dias - 28;
    10: Result := Dias - 20;
    15: Result := Dias - 15;
  end;
end;

end.
