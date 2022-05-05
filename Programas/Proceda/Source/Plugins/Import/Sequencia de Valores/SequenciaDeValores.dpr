library SequenciaDeValores;

{
  Importa uma sequencia aleatoria de valores.
  O usuario devera indicar o tipo do dado e a data inicial
  Tambem devera indicar o nome do posto.
}

uses
  ShareMem,
  SysUtils,
  Classes,
  SysUtilsEx,
  DateUtils,
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
    Result := 'Texto - Sequência de Valores';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function getFileFilter(): string;
  begin
    Result := 'Arquivos Texto (*.txt)|*.txt|' +
              'Arquivos VZO (*.vzo)|*.vzo|' +
              'Arquivos VZC (*.vzc)|*.vzc|' +
              'Arquivos PLU (*.plu)|*.plu|' +
              'Arquivos ETP (*.etp)|*.etp|' +
              'Todos os Arquivos (*.*)|*.*';
  end;

  // Retorna uma descrição do formato de importação
  function getDescription(): string;
  begin
    Result :=  'Importa uma sequência aleatória de valores.'#13#10 +
               'Os valores poderão ser sequenciais, isto é, um por linha ou'#13#10 +
               'separados por espaço, TAB ou ponto e virgula ";"'#13#10 +
               'O usuario deverá indicar o tipo de intervalo e a data inicial.'#13#10 +
               'Também deverá indicar o nome do posto.';
  end;

  // Retorna a versão do padrão de importação
  function getVersion(): string;
  begin
    Result := '1.2';
  end;

  // Retorna as propriedades e os valores Default para o chamador
  procedure getProperties(Props: TStrings);
  begin
    Props.Add('Nome do Posto=Nome');
    Props.Add('Separador Decimal=(Ponto|Vírgula)');
    Props.Add('Intervalo dos Dados=(Diário|Mensal)');
    Props.Add('Data Inicial=01/01/1980');
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

  var FNomePosto: string;
      FDataInicial: TDateTime;

  // Rotina principal responsável por realizar a importação dos dados
  procedure InternalImport(const Filename: string;
                           const Stations: TStations;
                           const StationIndex: integer);
  var x: TDataRec;
      D: TDateTime;
      s: String;
      p: TStrings;
      v: TStrings;
      i: integer;
      j: integer;
      k: integer;

      procedure AddValue(const v: string; const i: integer);
      begin
        if i = 0 then
           D := FDataInicial
        else
           if Stations.DataInterval = tiDiario then
              D := DateUtils.IncDay(D)
           else
              D := SysUtils.IncMonth(D);

        SysUtils.DecodeDate(D, x.aa, x.mm, x.dd);
        x.value := toFloat(v, wscMissValue);
        Stations[StationIndex].Add(x);
      end;

  begin
    FPC.ipc_ShowMessage('Importando ' + Filename + ' ...');

    v := nil;
    p := TStringList.Create();
    try
      p.LoadFromFile(Filename);

      // Define o nome da estacao
      s := FNomePosto;
      if StationIndex > 0 then s := s + '_' + ToString(StationIndex + 1);
      Stations[StationIndex].Name := s;

      // Leitura do arquivo
      k := 0;
      FPC.ipc_ShowMessage('Numero de linhas: ' + toString(p.Count));
      if p.Count > 0 then
         begin
         // Converte eventuais caracteres TAB por ESPACO
         s := AllTrim(ChangeChar(p[0], K_TAB, K_SPACE));

         // Verifica na primeira linha do arquivo se existe mais de um valor por linha
         if (CharCount(K_SPACE, s) > 0) or
            (CharCount(';', s) > 0) then
            // Existe mais de uma valor por linha
            for i := 0 to p.Count-1 do
               begin
               // Converte eventuais caracteres TAB por ESPACO
               // Remove os espacos iniciais e finais
               // Converte 2 ou mais espacos consecutivos em um unico espaco
               // Quebra a string em varios pedacos e adiciona-os
               //FPC.ipc_ShowMessage('procesando linha ' + toString(i+1));  // <----------------
               s := AllTrim(ChangeChar(p[i], K_TAB, K_SPACE));
               Split(s, v, [K_SPACE, ';']);
               for j := 0 to v.Count-1 do
                 begin
                 AddValue(v[j], k);
                 inc(k);
                 end;
               end
         else
            // Existe um unico valor por linha
            for i := 0 to p.Count-1 do
              AddValue(AllTrim(p[i]), i);
         end;
    finally
      p.Free();
      v.Free();
    end;
  end;

  procedure setInternalProperties(const Stations: TStations);
  begin
    FNomePosto := FProps.ValueFromIndex[0];

    if FProps.ValueFromIndex[1] = 'Ponto' then
       SysUtils.DecimalSeparator := '.'
    else
       SysUtils.DecimalSeparator := ',';

    if FProps.ValueFromIndex[2] = 'Diário' then
       Stations.DataInterval := tiDiario
    else
       Stations.DataInterval := tiMensal;

    // Gerara uma excecao se a data estiver incorreta
    FDataInicial := StrToDate(FProps.ValueFromIndex[3]);
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
