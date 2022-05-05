library Isareg;

uses
  ShareMem,
  DateUtils,
  SysUtils,
  Classes,
  wsGLib,
  SysUtilsEx,
  wsConstTypes,
  pro_Interfaces in '..\..\..\Units\pro_Interfaces.pas',
  pro_Import_Classes in '..\pro_Import_Classes.pas';

{$R *.RES}

  {ATENCAO: O ano que aparece nos arquivos eh o ano do mes de fevereiro,
            dependendo disso, a o ano devera ser ajustado ao mes da cultura
            caso a cultura seja formada por mais de um ano.}

type
  TTipoCultura = (tcUmAno, tcDoisAnos, tcDoisAnosEsp);

var
  // Interface de controle do Proceda
  FProceda: IProcedaControl;

  // Interface para controle de um processo
  FPC: IProcessControl;

  // Propriedades definidas pelo chamador
  FProps: TStrings;

  function getPluginType(): string;
  begin
    result := 'Data Import';
  end;

  // Retorna o nome do Padrão de importação
  function getName(): string;
  begin
    Result := 'ISAREG - EVAP 56';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function getFileFilter: string;
  begin
    Result := 'Arquivos Texto (*.txt)|*.txt|Todos (*.*)|*.*';
  end;

  // Retorna uma descrição do formato de importação
  function getDescription: string;
  begin
    Result := 'Formato do Arquivo:'#13#10 +
              'Identificação do Posto: Nome do arquivo sem a extensão'#13#10 +
              'Separador Decimal: . (ponto)'#13#10 +
              '  - As duas primeiras linhas contém informações sobre o formato dos dados'#13#10 +
              '  - 1. Linha, 1. Valor: "31" Dados diários - "1" Dados mensais'#13#10 +
              '  - 2. Linha, 1. Valor: Indica o número de blocos (anos)'#13#10 +
              '  - 2. Linha, 2. Valor: Indica o mês inicial (1. coluna. Ex: Junho)'#13#10 +
              '  - 2. Linha, 3. Valor: Indica o mês final do próprio ano ou ano seguinte'#13#10 +
              '  - 3. Linha, 1. Valor: - Diário: Indica o ano atual do primeiro mês indicado'#13#10 +
              '                        - Mensal: Indica o primeiro ano'#13#10 +
              '  - 4. Linha em diante: Blocos de dados';
  end;

  // Retorna a versão do padrão de importação
  function getVersion(): string;
  begin
    Result := '1.1';
  end;

  // Retorna as propriedades e os valores Default para o chamador
  procedure getProperties(Props: TStrings);
  begin
    Props.Add('Separador Decimal=(Ponto|Vírgula)');
    Props.Add('Intervalo dos Dados=(Diário|Mensal)');
    Props.Add('Título=Postos Isareg - Evap 56');
  end;

  procedure setProperties(Props: TStrings);
  begin
    FProps := Props;
  end;

  procedure setProcedaControlInterface(const intf: IProcedaControl);
  begin
    FProceda := intf;
  end;

  procedure setProcessControlInterface(const intf: IProcessControl);
  begin
    FPC := intf;
  end;

  // Rotina principal responsável por realizar a importação dos dados
  procedure InternalImport(const Filename: string;
                           const Stations: TStations;
                           const StationIndex: integer);

  var SL, Dados: TStrings;
      MI : Integer;
      MF : Integer;
      TC : TTipoCultura;
      x  : TDataRec;

        function AjustarAno(Mes, Ano: integer): integer;
        begin
          if TC = tcDoisAnosEsp then
             if Mes = 1 then
                result := Ano + 1
             else
                result := Ano
          else
             if Mes < MI then
                result := Ano
             else
                result := Ano - 1;
        end;

        procedure LeLinha(L, Dia, Ano: Integer);
        var Mes: Integer;
        begin
          Split(DelSpace1(AllTrim(SL[L])), Dados, [#32, #9]);

          if TC = tcUmAno then
             for Mes := MI to MF do
               begin
               if Dia <= DaysInAMonth(Ano, Mes) then
                  begin
                  x.dd := Dia;
                  x.mm := Mes;
                  x.aa := Ano;
                  x.value := StrToFloatDef(Dados[Mes - MI], wscMissValue);
                  if x.value < -70 then x.value := wscMissValue;
                  Stations[StationIndex].Add(x);
                  end
               end
          // A cultura se espalha por dois anos
          else
             begin
             for Mes := MI to 12 do
               begin
               x.aa := AjustarAno(Mes, Ano);
               if Dia <= DaysInAMonth(x.aa, Mes) then
                  begin
                  x.dd := Dia;
                  x.mm := Mes;
                  x.value := StrToFloatDef(Dados[Mes - MI], wscMissValue);
                  if x.value < -70 then x.value := wscMissValue;
                  Stations[StationIndex].Add(x);
                  end;
               end;

             for Mes := 1 to MF do
               begin
               x.aa := AjustarAno(Mes, Ano);
               if Dia <= DaysInAMonth(x.aa, Mes) then
                  begin
                  x.dd := Dia;
                  x.mm := Mes;
                  x.value := StrToFloatDef(Dados[12 - MI + Mes], wscMissValue);
                  if x.value < -70 then x.value := wscMissValue;
                  Stations[StationIndex].Add(x);
                  end;
               end;
             end;
        end;

        procedure setStationType(Ext: string; Codigo: integer);
        var dt, un: string;
        begin
          Ext := UpperCase(Ext);
          un  := '';

          if Ext = '.VEN' then
             begin
             dt := 'wind speed';
             if Codigo = 1 then
                un := 'm/s'
             else
                un := 'km/h';
             end
          else

          // se o arquivo for de dias de sol ...
          if Ext = '.INS' then
             begin
             if Codigo <= 3 then
                begin
                dt := 'sunshine';
                case Codigo of
                  1: un := 'daily average value';
                  2: un := 'hours/max sunshine hours';
                  3: un := 'hours per decade/month';
                  end
                end
             else
                if Codigo = 4 then
                   begin
                   dt := 'global radiation';
                   un := 'MJ/m2/day';
                   end
                else
                   if Codigo = 5 then
                      begin
                      dt := 'shortwave net radiation';
                      un := 'MJ/m2/day';
                      end
             end
          else

          if Ext = '.PRE' then
             dt := 'precipitation'
          else

          if Ext = '.TPA' then
             dt := 'maximum temperature'
          else

          if Ext = '.TPI' then
             dt := 'minimum temperature'
          else

          if Ext = '.DEW' then
             dt := 'dew point temperature'
          else

          if Ext = '.WET' then
             dt := 'wet bulb temperature'
          else

          if Ext = '.DRY' then
             dt := 'dry bulb temperature'
          else

          if Ext = '.HUM' then
             dt := 'average relative humidity'
          else

          if Ext = '.RHI' then
             dt := 'minimum relative humidity'
          else

          if Ext = '.RHA' then
             dt := 'maximum relative humidity'
          else
             dt := '';

          Stations[StationIndex].DataType := dt;
          Stations[StationIndex].DataUnit := un;
        end;

  var
      i, j, k : Integer;
      Dias    : integer;
      Anos    : integer;
      Ano     : integer;
      Codigo  : integer;
      Ext     : string;

  begin
    FPC.ipc_ShowMessage('Importando ' + Filename + ' ...');

    Dados := nil;
    SL := TStringList.Create();
    SL.LoadFromFile(Filename);
    try
      Ext := ExtractFileExt(Filename);

      // Nome do posto
      Stations[StationIndex].Name :=
        ExtractFileName(ChangeFileExt(Filename, '')) + '_' + Ext;

      // número de intervalos
      Split(DelSpace1(AllTrim(SL[0])), Dados, [#32, #9]);
      Dias := StrToInt(Dados[0]);

      if Dados.Count > 1 then
         Codigo := StrToInt(Dados[1])
      else
         Codigo := -1;

      setStationType(Ext, Codigo);

      // Dados Gerais
      Split(DelSpace1(AllTrim(SL[1])), Dados, [#32, #9]);

      Anos := StrToInt(Dados[0]);
      MI   := StrToInt(Dados[1]);
      MF   := StrToInt(Dados[2]);

      // Verifica se a cultura ocupa mais de um ano
      if (MI <= MF) then
         TC := tcUmAno
      else
         if (MI = 2) then
            TC := tcDoisAnosEsp
         else
            TC := tcDoisAnos;

      FPC.ipc_setMaxProgress(Anos);
      FPC.ipc_setMinProgress(1);

      // Dados Diários
      if Dias = 31 then
         begin
         // Faz a leitura dos blocos anuais
         k := 1;
         for i := 1 to Anos do
             begin
             inc(k);
             Ano := StrToInt(AllTrim(SL[k]));
             for j := 1 to Dias do
               begin
               inc(k);
               LeLinha(k, j, Ano);
               end; // for j
             FPC.ipc_setProgress(i);
             end; // for i
         end
      else
      // Dados Mensais
      if Dias = 1 then
         begin
         // Faz a leitura dos blocos anuais
         Ano := StrToInt(AllTrim(SL[2]));
         k := 3;
         for i := 1 to Anos do
             begin
             LeLinha(k, 1, Ano + i - 1);
             inc(k);
             FPC.ipc_setProgress(i);
             end; // for i
         end;

    finally
      SL.Free;
    end;
  end;

  procedure setInternalProperties(const Stations: TStations);
  begin
    if FProps.ValueFromIndex[0] = 'Ponto' then
       SysUtils.DecimalSeparator := '.'
    else
       SysUtils.DecimalSeparator := ',';

    if FProps.ValueFromIndex[1] = 'Diário' then
       Stations.DataInterval := tiDiario
    else
       Stations.DataInterval := tiMensal;

      // Título
      Stations.Title := FProps.ValueFromIndex[2];
  end;

  function Import(const Files: TStrings): boolean;
  var i: Integer;
      Stations: TStations;
  begin
    try
      Stations := TStations.Create(Files.Count);
      try
        setInternalProperties(Stations);

        for i := 0 to Files.Count-1 do
          InternalImport(Files[i], Stations, i);

        Stations.ConvertToProcedaDataSet(FProceda);

        result := true;
      finally
        Stations.Free();
      end;
    except
      On E: Exception do
         begin
         FPC.ipc_ShowError(E.Message);
         result := false;
         end;
    end;
  end;

exports
  getPluginType, 
  getName,
  getFileFilter,
  getDescription,
  getVersion,
  getProperties,
  setProperties,
  setProcedaControlInterface,
  setProcessControlInterface,
  Import;

begin
end.
