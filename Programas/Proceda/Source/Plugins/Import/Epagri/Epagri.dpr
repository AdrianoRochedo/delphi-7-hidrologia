library Epagri;

uses
  ShareMem,
  SysUtils,
  Classes,
  wsGLib,
  wsConstTypes,
  SysUtilsEx,
  DateUtils,
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

  // Variáveis internas
  FLerCab   : boolean;
  FLinhaIni : integer;

  function getPluginType(): string;
  begin
    result := 'Data Import';
  end;

  // Retorna o nome do Padrão de importação
  function getName(): string;
  begin
    Result := 'Epagri (texto não formatado)';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function getFileFilter(): string;
  begin
    Result := 'Arquivos Texto (*.txt)|*.txt';
  end;

  // Retorna uma descrição do formato de importação
  function getDescription(): string;
  begin
    Result := 'Arquivos texto com dados mensais separados por ponto e vírgula (;)'#13#10 +
              'Os dados iniciam geralmente na 8. linha'#13#10 +
              '  - 1.Valor: Ano'#13#10 +
              '  - 2.Valor .. 12.Valor: Mes'#13#10 +
              'O nome do Campo/Posto será o nome do arquivo sem sua extensão';
  end;

  // Retorna a versão do padrão de importação
  function getVersion(): string;
  begin
    Result := '1.0';
  end;

  // Retorna as propriedades e os valores Default para o chamador
  procedure getProperties(Props: TStrings);
  begin
    Props.Add('Título dos Dados=Dados Epagri');
    Props.Add('Separador Decimal=(Vírgula|Ponto)');
    Props.Add('Intervalo dos Dados=(Mensal)');
    Props.Add('Importar Cabeçalho=(Sim|Não)');
    Props.Add('Linha Inicial dos Dados=8');
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
      s, Nome: String;
      Dados: TStrings;
      SL: TStrings;
      x: TDataRec;
  begin
    FPC.ipc_ShowMessage('Importando ' + Filename + ' ...');

    SL := TStringList.Create;
    SL.LoadFromFile(Filename);

    // Linha inicial dos dados
    ii := FLinhaIni;

    FPC.ipc_SetMaxProgress(SL.Count-1);
    FPC.ipc_SetMinProgress(ii);

    Stations[StationIndex].Name := ChangeFileExt(ExtractFilename(Filename), '');
    Stations[StationIndex].DataType := 'rain days';
    Stations[StationIndex].DataUnit := 'days';

    // Cabecalho
    if FLerCab then
       begin
       Stations[StationIndex].Properties.Add( 'Latitude=' + System.Copy(SL[2], 12, 15));
       Stations[StationIndex].Properties.Add('Longitude=' + System.Copy(SL[3], 12, 15));
       Stations[StationIndex].Properties.Add( 'Altitude=' + AllTrim(SubString(SL[4], ':', 'metro')));
       end;

    try
      Dados := nil;
      for i := ii to SL.Count-1 do
        begin
        Split(SL[i], Dados, [';']);
        if Dados.Count <> 13 then Continue;

        x.dd  := 01;
        x.aa  := StrToInt(Dados[0]);

        // Dados Diários
        for ii := 1 to 12 do
          begin
          x.mm := ii;
          x.value := StrToIntDef(Dados[ii], -1);

          // Poderão existir valores negativos indicando a não existencia de dado
          if x.value < 0 then x.value := wscMissValue;

          Stations[StationIndex].Add(x);
          end;

        FPC.ipc_SetProgress(i);
        end;
    finally
      SL.Free;
    end;
  end;

  procedure setInternalProperties(const Stations: TStations);
  begin
    {
    0: Props.Add('Título dos Dados=Dados Epagri');
    1: Props.Add('Separador Decimal=(Vírgula|Ponto)');
    2: Props.Add('Intervalo dos Dados=(Mensal)');
    3: Props.Add('Importar Cabeçalho=(Sim|Não)');
    4: Props.Add('Linha Inicial dos Dados=8');
    }

    Stations.Title := FProps.ValueFromIndex[0];

    if FProps.ValueFromIndex[1] = 'Ponto' then
       SysUtils.DecimalSeparator := '.'
    else
       SysUtils.DecimalSeparator := ',';

    if FProps.ValueFromIndex[2] = 'Diário' then
       Stations.DataInterval := tiDiario
    else
       Stations.DataInterval := tiMensal;

    FLerCab := (FProps.ValueFromIndex[3] = 'Sim');
    FLinhaIni := strToIntDef(FProps.ValueFromIndex[4], 8);
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
