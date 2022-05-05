library Isareg_out;

{%File '..\..\..\..\..\..\..\Tipos de Arquivos\Isareg\diario.txt'}
{%File '..\..\..\..\..\..\..\Tipos de Arquivos\Isareg\mensal.txt'}

uses
  ShareMem,
  DateUtils,
  SysUtils,
  Classes,
  SysUtilsEx,
  FileUtils,
  FolderUtils,
  pro_Interfaces in '..\..\..\Units\pro_Interfaces.pas';

{$R *.RES}

var
  // Interface de controle do Proceda
  FProceda: IProcedaControl;

  // Interface para controle de um processo
  FPC: IProcessControl;

  // Interface para controle dos dados
  FData: IDataControl;

  // Propriedades definidas pelo chamador
  FProps: TStrings;

  // Variáveis internas
  FFolder  : string;   // Diretorio onde serao gerados os arquivos
  FAI      : integer;  // ano inicial
  FAF      : integer;  // ano final
  FMI      : integer;  // mes inicial
  FMF      : integer;  // mes final

  function getPluginType(): string;
  begin
    result := 'Data Export';
  end;

  // Retorna o nome do Padrão dd exportador
  function getName(): string;
  begin
    Result := 'ISAREG - EVAP 56';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function getFileFilter(): string;
  begin
    Result := 'Arquivos Texto (*.txt)|*.txt|Todos (*.*)|*.*';
  end;

  // Retorna uma descrição do formato de importação
  function getDescription(): string;
  begin
    Result := 'Exporta os dados para o formato Isareg - Evap 56.'#13 +
              'Cada campo/posto criará um arquivo específico dependendo do tipo de seus'#13 +
              'dados e de sua unidade de medida.'#13 +
              'Os arquivos serão criados na pasta indicada com o nome dos postos mais'#13 +
              'uma extensão especializada.';
  end;

  // Retorna a versão do padrão de importação
  function getVersion(): string;
  begin
    Result := '1.0';
  end;

  // Retorna as propriedades e os valores padroes para o chamador
  procedure getProperties(Props: TStrings);
  begin
    {0} Props.Add('Pasta Destino=' + FolderUtils.WindowsTempDir());
    {1} Props.Add('Ano Inicial=1970');
    {2} Props.Add('Ano Final=' + toString(DateUtils.YearOf(DateUtils.Today())));
    {3} Props.Add('Mes Inicial=1');
    {4} Props.Add('Mes Final=12');
    {5} Props.Add('Separador Decimal=(Ponto|Vírgula)');
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

  procedure setDataControlInterface(const intf: IDataControl);
  begin
    FData := intf;
  end;

  procedure setInternalProperties();
  begin
(*
    {0} Props.Add('Pasta Destino=' + FolderUtils.WindowsTempDir());
    {1} Props.Add('Ano Inicial=1970');
    {2} Props.Add('Ano Final=' + toString(DateUtils.YearOf(DateUtils.Today())));
    {3} Props.Add('Mes Inicial=1');
    {4} Props.Add('Mes Final=12');
    {5} Props.Add('Separador Decimal=(Ponto|Vírgula)');
*)
    FFolder  := FProps.ValueFromIndex[0];
    FAI      := toInt(FProps.ValueFromIndex[1], -1);
    FAF      := toInt(FProps.ValueFromIndex[2], -1);
    FMI      := toInt(FProps.ValueFromIndex[3], -1);
    FMF      := toInt(FProps.ValueFromIndex[4], -1);

    if FProps.ValueFromIndex[5] = 'Ponto' then
       SysUtils.DecimalSeparator := '.'
    else
       SysUtils.DecimalSeparator := ',';
  end;

  procedure CheckProperties();
  begin
    if not ((FData.getIntervalType() = tiDiario) or
            (FData.getIntervalType() = tiMensal)) then
       raise Exception.Create('Este plugin somente converte dados ' +
                              'Diários ou Mensais.');

    if not DirectoryExists(FFolder) then
       raise Exception.Create('Diretório não existe: ' + FFolder);

    if LastChar(FFolder) <> '\' then
       FFolder := FFolder + '\';

    if (FAI = -1) or (FAI <= 1000) or (FAI >= 2300) then
       raise Exception.Create('Ano Inicial inválido: ' + toString(FAI));

    if (FAF = -1) or (FAF <= 1000) or (FAF >= 2300) then
       raise Exception.Create('Ano final inválido: ' + toString(FAF));

    if (FMI = -1) or (FMI < 1) or (FMI > 12) then
       raise Exception.Create('Mes Inicial inválido: ' + toString(FMI));

    if (FMF = -1) or (FMF < 1) or (FMF > 12) then
       raise Exception.Create('Mes Final inválido: ' + toString(FMF));

    if FAI > FAF then
       raise Exception.Create('Ano inicial maior que o ano final');
  end;

  // Obtem um valor formatado do conjunto de dados
  function getData(y, m, d, StationIndex: integer): string;
  var i: Integer;
      x: real;
      date: TDateTime;
  begin
    if TryEncodeDate(y, m, d, date) then
       i := FData.getRecIndexByDate(date)
    else
       i := -1;

    if i = -1 then
       result := '   -77.00'
    else
       begin
       x := FData.getStation(i, StationIndex);
       if x < -999999 then x := -77.00;
       result := SysUtilsEx.RightStr(toString(x), 9);
       end;
  end;

  // Cada linha contera somente um ano de dados diarios
  procedure D_OneYear(f: TTextFileWriter; StationIndex: integer);
  var y, m, d: word;
      s: string;
  begin
    FPC.ipc_setMaxProgress(FAF);
    FPC.ipc_setMinProgress(FAI);

    // Blocos anuias
    for y := FAI to FAF do
      begin
      FPC.ipc_setProgress(y);

      // Ano
      f.WriteLN(y);

      // Dados diarios
      for d := 1 to 31 do
        begin
        s := '';
        for m := FMI to FMF do s := s + getData(y, m, d, StationIndex);
        F.WriteLN(s);
        end; // for d
      end; // for y
  end;

  // Cada linha contera dois anos de dados diarios
  procedure D_TwoYears(f: TTextFileWriter; StationIndex: integer);
  var y, m, d: word;
      s: string;
  begin
    FPC.ipc_setMaxProgress(FAF-1);
    FPC.ipc_setMinProgress(FAI);

    // Blocos anuais
    for y := FAI to FAF do
      begin
      FPC.ipc_setProgress(y);

      // Ano
      f.WriteLN(y);

      // Dados diarios
      for d := 1 to 31 do
        begin
        s := '';

        if FMI <> 2 then
           begin
           for m := FMI to  12 do s := s + getData(y-1, m, d, StationIndex);
           for m :=  01 to FMF do s := s + getData(  y, m, d, StationIndex);
           end
        else
           begin
           for m := 02 to 12 do s := s + getData(y, m, d, StationIndex);
           s := s + getData(y+1, 1, d, StationIndex); // Janeiro
           end;

        F.WriteLN(s);
        end; // for d
      end; // for y
  end;

  // Cada linha contera somente um ano de dados mensais
  procedure M_OneYear(f: TTextFileWriter; StationIndex: integer);
  var y, m: word;
      s: string;
  begin
    FPC.ipc_setMaxProgress(FAF);
    FPC.ipc_setMinProgress(FAI);

    // Blocos anuias
    for y := FAI to FAF do
      begin
      FPC.ipc_setProgress(y);
      s := '';
      for m := FMI to FMF do s := s + getData(y, m, 01, StationIndex);
      F.WriteLN(s);
      end; // for y
  end;

  // Cada linha contera dois anos de dados mensais: "ano atual" ate "ano atual + 1"
  procedure M_TwoYears(f: TTextFileWriter; StationIndex: integer);
  var y, m: word;
      s: string;
  begin
    FPC.ipc_setMaxProgress(FAF-1);
    FPC.ipc_setMinProgress(FAI);

    // Blocos anuais
    for y := FAI to FAF-1 do
      begin
      FPC.ipc_setProgress(y);
      s := '';

      if FMI <> 2 then
         begin
         for m := FMI to  12 do s := s + getData(y-1, m, 01, StationIndex);
         for m :=  01 to FMF do s := s + getData(  y, m, 01, StationIndex);
         end
      else
         begin
         for m := 02 to 12 do s := s + getData(y, m, 01, StationIndex);
         s := s + getData(y+1, 1, 01, StationIndex); // Janeiro
         end;

      F.WriteLN(s);
      end; // for y
  end;

  // Escreve o cabecalho dos arquivos
  procedure WriteHeader(f: TTextFileWriter; StationIndex: integer);

    procedure Error();
    begin
      FPC.ipc_ShowError('Unidade de Medida inválida para o Campo/Posto ' +
                         FData.getStationName(StationIndex));
      FPC.ipc_ShowMessage('Verifique a unidade selecionada.');
    end;

  var s, dt, un, c: String;
  begin
    // Primeira linha; Codigo do intervalo; Codigo da unidade de medida

    // Codigo: Diario
    if FData.getIntervalType() = tiDiario then
       s := '31'
    else
    // Codigo: Mensal
    if FData.getIntervalType() = tiMensal then
       s := '1';

    dt := FData.getStationType(StationIndex);
    un := FData.getStationUnit(StationIndex);

    c := '   1';

    // Se o arquivo for de vento ...
    if dt = 'wind speed' then
       if un = 'm/s' then
          c := '   1'
       else if un = 'km/h' then
          c := '   2'
       else
          begin
          Error();
          c := '   (?? not defined unit)';
          end;

    // se o arquivo for de dias de sol ...
    if dt = 'sunshine' then
       if un = 'daily average value' then
          c := '   1'
       else if un = 'hours/max sunshine hours' then
          c := '   2'
       else if (un = 'hours per decade') or (un = 'hours per month') then
          c := '   3'
       else
          begin
          Error();
          c := '   (?? not defined unit)';
          end;

    // se o arquivo for de radiacao solar ...

    if dt = 'global radiation' then
       c := '   4';

    if dt = 'shortwave net radiation' then
       c := '   5';

    F.WriteLN(s + c);

    // Segunda linha: Numero de Anos;  Mes inicial;  Mes final

    s := Format('%d    %d    %d', [FAF - FAI + 1, FMI, FMF]);
    F.WriteLN(s);

    // Terceira linha: Primeiro ano

    if FData.getIntervalType() = tiMensal then
       F.WriteLN(FAI);
  end;

  // Retorna um nome para o arquivo
  function getFileName(StationIndex: integer): string;
  var s, dt, un: String;
  begin
    dt := FData.getStationType(StationIndex);
    un := FData.getStationUnit(StationIndex);

    if dt = 'wind speed' then
       s := 'VEN'
    else

    // se o arquivo for de dias de sol ...
    if (dt = 'sunshine') or
       (dt = 'global radiation') or
       (dt = 'shortwave net radiation') then
       s := 'INS'
    else

    if (dt = 'precipitation') then
       s := 'PRE'
    else

    if (dt = 'maximum temperature') then
       s := 'TPA'
    else

    if (dt = 'minimum temperature') then
       s := 'TPI'
    else

    if (dt = 'dew point temperature') then
       s := 'DEW'
    else

    if (dt = 'wet bulb temperature') then
       s := 'WET'
    else

    if (dt = 'dry bulb temperature') then
       s := 'DRY'
    else

    if (dt = 'average relative humidity') then
       s := 'HUM'
    else

    if (dt = 'minimum relative humidity') then
       s := 'RHI'
    else

    if (dt = 'maximum relative humidity') then
       s := 'RHA'
    else

    if (dt <> '') then
       s := ChangeChar(dt, ' ', '_')
    else
       s := 'data_type_not_defined';

    result := FFolder + FData.getStationName(StationIndex) + '.' + s;
  end;

  // Gera um arquivo com os dados do posto
  procedure SaveStation(StationIndex: integer);
  var f: TTextFileWriter;
      s: string;
  begin
    s := getFileName(StationIndex);
    f := TTextFileWriter.Create(s, true);
    try
      FPC.ipc_ShowMessage('Gerando arquivo: ' + s + ' ...');

      // Cabecalho do arquivo
      WriteHeader(f, StationIndex);

      // Intervalo: Diario
      if FData.getIntervalType() = tiDiario then
         if FMI <= FMF then
            D_OneYear(f, StationIndex)
         else
            D_TwoYears(f, StationIndex);

      // Intervalo: Mensal
      if FData.getIntervalType() = tiMensal then
         if FMI <= FMF then
            M_OneYear(f, StationIndex)
         else
            M_TwoYears(f, StationIndex);
    finally
      f.Free();
    end;
  end;

  // Gera tantos arquivos quanto forem os postos
  procedure internalExport();
  var i: integer;
  begin
    for i := 0 to FData.getStationCount()-1 do
      SaveStation(i);
  end;

  function Export(): boolean;
  begin
    result := false;
    try
      setInternalProperties();
      checkProperties();
      internalExport();
      result := true;
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
  setDataControlInterface,
  Export;

begin
end.
