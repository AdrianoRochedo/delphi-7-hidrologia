library HidroWeb_2;

uses
  ShareMem,
  SysUtils,
  Classes,
  SysUtilsEx,
  DateUtils,
  wsGLib,
  wsConstTypes,
  pro_Interfaces in '..\..\..\Units\pro_Interfaces.pas',
  pro_Import_Classes in '..\pro_Import_Classes.pas';

{$R *.RES}

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
    Result := 'HidroWEB';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function getFileFilter(): string;
  begin
    Result := 'Arquivos Texto (*.txt)|*.txt';
  end;

  // Retorna uma descrição do formato de importação
  function getDescription(): string;
  begin
    Result := 'Os arquivos seguem o padrão de exportação feitos pelo site HidroWEB'#13#10 +
              'Formato do Arquivo: Texto com 65 colunas separadas por ";"'#13#10 +
              '  - 1.Coluna: Identificação do Posto'#13#10 +
              '  - 2.Coluna: Ano'#13#10 +
              '  - 3.Coluna: Mes'#13#10 +
              '  - 4. 5. ... 34.Coluna: Valores (Um para cada dias do mes)'#13#10 +
              '  - 35. 36. ... 65.Coluna: Status do Dado (Um para cada dias do mes)';
  end;

  // Retorna a versão do padrão de importação
  function getVersion(): string;
  begin
    Result := '2.0';
  end;

  // Retorna as propriedades e os valores Default para o chamador
  procedure getProperties(Props: TStrings);
  begin
    Props.Add('Separador Decimal=(Ponto|Vírgula)');
    Props.Add('Intervalo dos Dados=(Diário|Mensal)');
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
  var i, ii: Integer;
      Dias: Word;
      s, Nome: String;
      Dados: TStrings;
      SL: TStrings;
      x: TDataRec;
  begin
    FPC.ipc_ShowMessage('Importando ' + Filename + ' ...');

    SL := TStringList.Create;
    SL.LoadFromFile(Filename);

    // Procura a linha inicial dos dados
    ii := SL.Count;
    for i := 0 to SL.Count-1 do
      if System.Pos('Código;Ano', SL[i]) > 0 then
         begin
         ii := i + 1;
         break;
         end;

    FPC.ipc_SetMinProgress(ii);
    FPC.ipc_SetMaxProgress(SL.Count-1);

    try
      Dados := nil;
      for i := ii to SL.Count-1 do
        begin
        Split(SL[i], Dados, [';']);
        if Dados.Count < 64 then Continue;

        Stations[StationIndex].Name := Dados[0];

        x.aa  := StrToInt(Dados[1]);
        x.mm  := StrToInt(Dados[2]);
        Dias  := DaysInAMonth(x.aa, x.mm);

        // Dados Diários
        for ii := 3 to 33 do
          begin
          x.dd := ii - 2;
          if x.dd <= Dias then
             begin
             s := Dados[ii];

             if (s = '-') or (s = '') then
                x.value := wscMissValue
             else
                x.value := StrToFloat(s);

             Stations[StationIndex].Add(x);
             end;
          end;

        FPC.ipc_SetProgress(i);
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
