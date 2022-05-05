unit CH_CONST;

interface
Uses Forms, Controls, SysUtils, DBTables, Classes, 
     {$ifdef CHUVAZ}
     wsMatrix,
     {$endif}
     ErrosDLG,
     wsOutPut,
     SysUtilsEx,
     drPlanilha;
                                                      
Type
  TIntervalo = (tiDiario, tiMensal);

  pTPeriodo = ^TPeriodo;
  TPeriodo  = record
                Inicio: String[10];
                Fim   : String[10];
              end;

  pRecDadosPeriodo = ^TRecDadosPeriodo;
  TRecDadosPeriodo = record
                       DI     : TDateTime; // Data Inicial
                       DF     : TDateTime; // Data Final
                       Postos : TByteSet;  // Índices dos Postos
                     end;


  // Olhar documentação em "Detalhes técnicos.txt"
  pTGlobalDataRec        = ^TGlobalDataRec;
  TGlobalDataRec         = Record
                             FileName    : String;
                             Tab         : {TQuery} TTable;
                             Tipo        : TIntervalo;
                             Meses       : Integer;
                             {$ifdef CHUVAZ}
                             dlgTab      : TForm;
                             dlgEditTab  : TForm;
                             Lockeds     : Integer;
                             MinDate     : TDateTime;
                             MaxDate     : TDateTime;
                             Postos      : TStrings;
                             DataSet     : TwsDataSet;
                             {$endif}
                           End;

  TRecPLU_DEF            = Record
                             IntComp:    Byte;
                             IntSim:     Byte;
                             Linhas:     Word;
                             Colunas:    Word;
                             DataIni:    Double;
                             Valores:    TStrings;
                             PostosSel:  TStrings;
                           End;

  TRecVZO_DEF            = Record
                             IntComp:       Byte;
                             IntSim:        Byte;
                             Posto:         String[30];
                             nIntervalos:   Word;
                             InterIni:      TStrings;
                             InterFin:      TStrings;
                             Multiplic:     Double;
                             UsarMultiplic: Boolean;
                           End;

  TRecStandartFile       = Record
                             Titulo     : String;
                             Natureza   : byte;
                             Tipo       : TIntervalo;
                             Formato    : byte;
                             Posto      : Integer;
                           End;

  TPosicao               = Record
                             Inicio     : Integer;
                             Quantidade : Integer;
                           end;

  TArray12 =  Array [0..12] of TPosicao;
  TArray4  =  Array [0..04] of TPosicao;

Const
  {Comandos SQL}
  cSQL_Select            = 'SELECT * FROM "%s"';

  cSQL_Order_Date        = 'SELECT * FROM "%s" ORDER BY Posto, Data';

  cSQL_Order_no999       = 'SELECT * FROM "%s" WHERE dado  <> -99999999 ' +
                           'ORDER BY Posto, Data ';

  cSQL_RequestLive       = 'SELECT * FROM "%s"';

  cSQL_Postos            = 'SELECT DISTINCT Posto FROM "%s"';

  cSQL_Posto             = 'SELECT * FROM "%s" WHERE dado <> -99999999 AND posto = "%s" ' +
                           'ORDER BY Posto, Data';

  cSQL_MinMaxDate        = 'SELECT MIN(Data), MAX(Data) FROM "%s"';

  cSQL_MinMaxDatePosto   = 'SELECT MIN(Data), MAX(Data) FROM "%s" ' +
                           'WHERE Posto = "%s"';

  cSQL_MinMaxDatePostos  = 'SELECT Posto, MIN(Data), MAX(Data) ' +
                           'FROM "%s" GROUP BY Posto';

  cSQL_Periodo           = 'SELECT * FROM "%s" WHERE ' +
                           'data BETWEEN "%s" AND "%s" AND ' +
                           'dado <> -99999999 ' +
                           'ORDER BY Posto, Data';

  cTodos                 = '|Todos os Arquivos (*.*)|*.*';

  cSQL_PeriodoPosto      = 'SELECT * FROM "%s" WHERE posto = "%s" AND ' +
                           'Data BETWEEN "%s" AND "%s" ' +
                           'ORDER BY Data';

  {Confirmações}
  cMSG1                  = 'ATENÇÃO'#13 +
                           'Este processo implica na remoção permanente dos dados !'#13 +
                           'Você tem certeza ?';

  cMSG2                  = 'O arquivo < %s > já existe !'#13 +
                           'Se voce quiser salvá-lo assim mesmo, use o Editor.';

  cMSG3                  = 'O arquivo < %s >'#13 +
                           'não pode ser lido. Tipo desconhecido';

  cMSG4                  = 'Data inicial inexistente';

  cMSG5                  = 'Datas não compatíveis (verifique os períodos indicados)';

  cMSG6                  = 'A Data %s não é a data final do mês';

  cMSG7                  = 'A Data %s não é a data inicial do mês';

  cMSG8                  = 'O arquivo < %s > já está aberto.';

  cMSG9                  = 'A data inicial não pode ser maior que a final.';

  cMSG10                 = 'Arquivo inválido';

  {Erros}
  cSaveError             = 'Erro na tentativa de salvar o arquivo';
  cLoadError             = 'Erro na abertura do arquivo < %s >';

  {Gerais}
  cSQLDate               = 'mm/dd/yyyy';
  cMMYYYY                = '!90/0000;1;';
  cDDMMYYYY              = '!90/90/0000;1;';
  csDDMMYYYY             = 'Formato: Dia/Mes/Ano';
  csMMYYYY               = 'Formato: Mes/Ano';
  cNomeCurtoMes          : array[1..12] of String[3] = (
                           'Jan',
                           'Fev',
                           'Mar',
                           'Abr',
                           'Mai',
                           'Jun',
                           'Jul',
                           'Ago',
                           'Set',
                           'Out',
                           'Nov',
                           'Dez'
                           );

  cINTCOMP_DIARIO        = 0;
  cINTCOMP_MENSAL        = 1;

  cINTSIM_DIARIO         = 0;
  cINTSIM_QUINQUENDIAL   = 1;
  cINTSIM_SEMANAL        = 2;
  cINTSIM_DECENDIAL      = 3;
  cINTSIM_QUINZENAL      = 4;
  cINTSIM_MENSAL         = 5;
  cINTSIM_ANUAL          = 6;

  cCOLUNASIMPLES         = 0;
  cTABELA                = 1;
  cCOLUNAPOSTO           = 2;

  CDEFAULTDAYSFORFAIL    = 5; {Número máximo de falhas para pequenos intervalos}

  {Arquivos INI}
  INI_SECTION_CODPOSTOS  = 'CODIGO DOS POSTOS NAO CONVERTIDOS';

{$ifdef CHUVAZ}
Type
  TListaDePeriodos = Class
  private
    FList: TList;
    function getNumPeriodos: Integer;
    function getPeriodo(i: word): pRecDadosPeriodo;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Adicionar(const DI, DF: TDateTime; const Postos: TByteSet);
    procedure Imprimir(Lugar: TwsOutPut; RecDados: pTGlobalDataRec; MostrarPostos: Boolean);

    property NumPeriodos: Integer read getNumPeriodos;
    property Periodo[i: word]: pRecDadosPeriodo read getPeriodo; default;
  end;

  TDataList = Class
  Private
    FList: TList;
    Function  GetData(Index: Integer): pTGlobalDataRec;
    Function  GetLocked(Index: Integer): Integer;
    Function  GetCount: Integer;
    Function  GetLocks: Integer;
    Procedure SetLocked(Index: Integer; x: Integer);
  Public
    Constructor Create;
    Destructor  Destroy; override;

    Function  Add(x: TGlobalDataRec): Integer;
    Procedure Delete(Index: Integer);

    Property Data[Index: Integer]: pTGlobalDataRec Read GetData; Default;
    Property Lockeds[Index: Integer]: Integer Read GetLocked Write SetLocked;
    Property Count: Integer read GetCount;
    Property Locks: Integer read GetLocks;
  end;

  TwsEstatisticDataSet = Class(TwsDataSet)
  private
    FCE: Boolean;
    procedure SetCE(Value: Boolean);
  public
    Mensal : Boolean;   // Indica se os dados estão em intervalos mensais
    property CalculateEstatistics: Boolean read FCE write SetCE;
  end;

  TwsDataSetChuvaz = Class(TwsEstatisticDataSet)
  Private
    Procedure Header(Start, Amt: Longint; Buffer: TStrings); override;
    function ToChar(L, Start, Amt: Integer; Buffer: TStrings): Integer; override;
  Public
    PrintByDate : Boolean;   // Imprime na 1. coluna a data ou o número da linha
    BaseDate    : TDateTime; // Armazena a menor data (usado no cálculo das datas)
  end;

Var
    gPath        : String;     {Armazena o caminho global}
    gExePath     : String;     {Armazena o caminho do executável}
    gIndexFile   : Integer;    {Diz qual o arquivo é o ativo}
    gList        : TDataList;  {Armazena as informações sobre cada arquivo aberto}
    gFechando    : Boolean;    {Indica que a aplicação está em processo de finalização}
    gInstallDir  : String;     {Armazena o diretório de instalação}
    gError       : TErros_DLG; {janela que mostra as mais diversas mensagens}
    gOutPut      : TwsOutPut;  // Saída genérica de dados
    gVersao      : String;     // Versão do Programa
{$endif}

implementation
uses {$ifdef CHUVAZ}
     wsVec,
     wsGLib,
     ch_Func,
     wsConstTypes,
     {$endif}
     Math,
     WinUtils,
     GaugeFo;

{$ifdef CHUVAZ}

  Constructor TDataList.Create;
  begin
    FList := TList.Create;
    inherited Create;
  end;

  Destructor TDataList.Destroy;
  var i: Integer;
  begin
    i := FList.Count - 1;
    While i > -1 do
      begin
      Delete(i);
      Dec(i);
      end;
    Inherited Destroy;
  end;

  Function  TDataList.GetData(Index: Integer): pTGlobalDataRec;
  begin
    Result := FList[Index];
  end;

  Function  TDataList.GetLocked(Index: Integer): Integer;
  begin
    Result := Data[Index].Lockeds;
  end;

  Function  TDataList.GetCount: Integer;
  begin
    Result := FList.Count;
  end;

  Function  TDataList.GetLocks: Integer;
  var i: Integer;
  begin
    Result := 0;
    For i := 0 to FList.Count-1 Do
      if Lockeds[i] > 0 Then inc(Result);
  end;

  Procedure TDataList.SetLocked(Index: Integer; x: Integer);
  begin
    GetData(Index)^.Lockeds := x;
  end;

  Function TDataList.Add(x: TGlobalDataRec): Integer;
  var p: pTGlobalDataRec;
  begin
    New(p);
    x.dlgTab := nil;
    x.dlgEditTab := nil;
    p^ := x;
    Result := FList.Add(p);
  end;

  Procedure TDataList.Delete(Index: Integer);
  var p: pTGlobalDataRec;
  begin
    p := GetData(Index);

    If p^.dlgTab <> nil Then p^.dlgTab.Free;
    If p^.dlgEditTab <> nil Then p^.dlgEditTab.Free;
    While FindForm(p) <> nil do FindForm(p).Free;

    p^.Tab.Close;
    p^.Tab.Free;
    p^.DataSet.Free;
    DestroiListaDePostos(p^.Postos);
    Dispose(p);
    FList.Delete(Index);
  end;

  {------------------------------- TEstatisticDataSet ------------------------------}

procedure TwsEstatisticDataSet.SetCE(Value: Boolean);
var i, inutil      : Integer;
    Stat, Col      : TwsLIVec;
    Estatisticas   : TwsGeneral;
    Media, DSP, CV : Double;
    Pr             : TDLG_Progress;
begin
  if (Value <> FCE) and (FnRows > 1) and (FnCols > 1) Then
     begin
     Screen.Cursor := crHourGlass;
     Try
       if FCE then // Destroi as estatísticas
          begin
          Struct.Delete('Coef_Var');
          Struct.Delete('Desv_Pad');
          Struct.Delete('Media');
          MDelete(FnRows);
          MDelete(FnRows);
          MDelete(FnRows);
          end
       else // Cria as estatísticas
          begin
          Stat := TwsLIVec.Create(3); // Estatísticas que serão calculadas
          Stat[1] := ord(teMedia);
          Stat[2] := ord(teDPadr);
          Stat[3] := ord(teCVar);
          Col := TwsLIVec.Create(nCols-Byte(Mensal));
          For i := 1 to nCols-Byte(Mensal) Do Col[i] := i+Byte(Mensal); // Colunas que quero calcular as estatísticas
          Estatisticas := DescStat(Col, Stat);
          Col.Free; Stat.Free;

          for i := 1 to 3 do MADD(TwsDFVec.Create(nCols));
          for i := 1 to Estatisticas.NRows do
            begin
            Self[nRows-2, i+Byte(Mensal)] := Estatisticas[i, 1]; // Media
            Self[nRows-1, i+Byte(Mensal)] := Estatisticas[i, 2]; // Desv. Padrão
            Self[nRows-0, i+Byte(Mensal)] := Estatisticas[i, 3]; // Coeficiente de variação
            end;

          Struct.AddNumeric('Media'   , 'Média para cada intervalo');
          Struct.AddNumeric('Desv_Pad', 'Desvio Padrão para cada intervalo');
          Struct.AddNumeric('Coef_Var', 'Coeficiente de Variação para cada intervalo');

          Pr := CreateProgress(-2, -2, nRows-3, 'Calculando estatisticas');

          // Calcula as estatísticas para cada intervalo
          for i := 1 to nRows - 3 do
            begin
            Pr.Value := i;
            Row[i].PartialVec_Mean_DSP_CV(1+Byte(Mensal), nCols-3, inutil, Media, DSP, CV);
            Self[i, nCols-2] := Media;
            Self[i, nCols-1] := DSP;
            Self[i, nCols-0] := CV;
            end;

          Pr.Free;

          // Calcula as estatísticas para as estatísticas de cada coluna
          for i := (nRows - 2) to nRows do
            begin
            Self[i, nCols-2] := wscMissValue; // Media
            Self[i, nCols-1] := wscMissValue; // Desv. Padrão
            Self[i, nCols-0] := wscMissValue; // Coeficiente de variação
            end;

            Self.RowName[nRows-2] := 'Média  ';
            Self.RowName[nRows-1] := 'Desv_Pad  ';
            Self.RowName[nRows-0] := 'Coef_Var  ';

          // Calcula a média das médias na linha
          Self[nRows-2, nCols-2] := Row[nRows-2].PartialMean(1+Byte(Mensal), nCols-3, inutil);

          Estatisticas.Free;
          end;
       FCE := Value;
     Finally
       Screen.Cursor := crDefault;
       end;
     end;
end;

{------------------------------- TwsDataSetChuvaz ----------------------------}

function TwsDataSetChuvaz.ToChar(L, Start, Amt: Integer; Buffer: TStrings): Integer;
var j, c: Longint;
    S: string;
    x: Double;
begin
  if PrintByDate Then
     if CalculateEstatistics and (L > nRows - 3) then
        S := RowName[L] + ' '
     else
        if Mensal then
           S := DateToStr(Data[L, 1]) + ' '
        else
           S := DateToStr(L + BaseDate - 1) + ' '
  else
     if CalculateEstatistics and (L > nRows - 3) then
        S := RowName[L] + ' '
     else
        S := IntToStr(L) + ' ';

  s := LeftPad(s, PrintOptions.MaxIDSize);

  Amt := Min(Amt, FNCols - Start + 1);
  for j := 0 to Amt - 1 - byte(Mensal) do
    begin
    c := Start+j+byte(Mensal);
    x := Data[L, Start + j + byte(Mensal)];
    if not wsgLib.isMissValue(x) then
      AppendStr(S, Format('%*.*g',[Struct.Col[c].Size, PrintOptions.colPrecision, Fuzz(x)]))
    else
      AppendStr(S, Format('%*s',[Struct.Col[c].Size, '.']))
    end;

  if PrintOptions.Center Then gOutPut.Editor.WriteCenter(s) Else gOutPut.Editor.Write(s);
  Result := Length(S)
end; { TWSMatrix.ToChar }

Procedure TwsDataSetChuvaz.Header(Start, Amt: Longint; Buffer: TStrings);
Var j, k, c: Longint;
    L: Word;
    st, P: string;
    SL: TStrings;
    Col: TwsDataSetCol;
Begin
  Try
    Buffer.Add('');
    k := integer((nRows > 0) and (Row[1].Name <> ''));

    if PrintByDate Then
       L := Length(DateToStr(Data[1, 1]) + ' ')
    else
       L := Length(IntToStr(nRows) + ' ');

    P := StringOfChar(' ', L);
    P := LeftPad(P, Printoptions.MaxIDSize);

    for j := 1 to Amt - byte(Mensal) do
      begin
      c  := Start+j+byte(Mensal);
      st := Struct.Col[c].Name;
      L  := Length(Format('%*.*g',
                   [Struct.Col[c].Size, Printoptions.colPrecision, Fuzz(9.99999999999999)]));

      if L <= Length(st) then L := Length(st);

      AppendStr(P, LeftPad(st, L));
      end;

      if Printoptions.Center Then gOutPut.Editor.WriteCenter(P) Else gOutPut.Editor.Write(P);
//      if Printoptions.WriteSeparator then
         if Printoptions.Center Then
            gOutPut.Editor.WriteCenter(StringOfChar('-', Length(P)))
         Else
            gOutPut.Editor.Write(StringOfChar('-', Length(P)));

  Except
    P := 'Existe um erro nos Descritores do Conjunto de Dados --> ' + Name;
    gOutPut.Editor.Write(P);
  End;
End;

{ TListaDePeriodos }

procedure TListaDePeriodos.Adicionar(const DI, DF: TDateTime; const Postos: TByteSet);
var p: pRecDadosPeriodo;
begin
  New(p);
  p.DI := DI;
  p.DF := DF;
  p.Postos := Postos;
  FList.Add(p);
end;

constructor TListaDePeriodos.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TListaDePeriodos.Destroy;
var i: Integer;
begin
  for i := 0 to FList.Count-1 do Dispose(pRecDadosPeriodo(FList[i]));
  FList.Free;
  inherited;
end;

function TListaDePeriodos.getNumPeriodos: Integer;
begin
  Result := FList.Count;
end;

function TListaDePeriodos.getPeriodo(i: word): pRecDadosPeriodo;
begin
  Result := pRecDadosPeriodo(FList[i]);
end;

procedure TListaDePeriodos.Imprimir(Lugar: TwsOutPut; RecDados: pTGlobalDataRec; MostrarPostos: Boolean);
var i: Integer;
    p: pRecDadosPeriodo;
begin
  for i := 0 to FList.Count-1 do
    begin
    p := getPeriodo(i);
    if MostrarPostos then
       Lugar.Editor.WriteFmt('DI = %s   DF = %s   Postos = %s',
                             [DateToStr(p.DI), DateToStr(p.DF), SetToPostos(p.Postos, RecDados)])
    else
       Lugar.Editor.WriteFmt('DI = %s   DF = %s',
                             [DateToStr(p.DI), DateToStr(p.DF)])
    end;
end;

Initialization
  gFechando := False;
  gIndexFile := -1;
  gList := TDataList.Create;
{$endif}  
end.

