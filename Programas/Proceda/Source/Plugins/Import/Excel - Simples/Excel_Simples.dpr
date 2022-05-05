library Excel_Simples;

uses
  ShareMem,
  SysUtils,
  Classes,
  SysUtilsEx,
  DateUtils,
  wsConstTypes,
  SpreadSheetBook,
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
    Result := 'Excel - Formato Simples';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function getFileFilter(): string;
  begin
    Result := 'Arquivos Excel (*.xls)|*.xls';
  end;

  // Retorna uma descrição do formato de importação
  function getDescription(): string;
  begin
    Result := 'Os arquivos devem estar no padrão Excel'#13#10 +
              'Formato:'#13#10 +
              '  - Linha 1, Coluna 1: Identificação do Posto'#13#10 +
              '  - Apartir da Linha 2:'#13#10 +
              '    - Coluna 1: Data (dd/mm/aaaa)'#13#10 +
              '    - Coluna 2: Valor do Dado'#13#10 +
              ''#13#10 +
              'Ex:'#13#10 +
              '       Col1        Col2'#13#10 +
              'Lin1   Posto ID'#13#10 +
              'Lin2   01/01/2000  2,3'#13#10 +
              'Lin3   02/01/2000  1,3'#13#10 +
              '...';
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
  var x: TDataRec;
      L: Integer;
      sD, sX: String;
      p: TSpreadSheetBook;
  begin
    FPC.ipc_ShowMessage('Importando ' + Filename + ' ...');

    p := TSpreadSheetBook.Create();
    try
      p.LoadFromFile(Filename);
      p.ActiveSheetIndex := 0;

      Stations[StationIndex].Name := p.ActiveSheet.GetText(1, 1);

      L := 1;
      repeat
        inc(L);
        sD := p.ActiveSheet.GetDisplayText(L, 1);

        if sD <> '' then
           begin
           SysUtils.DecodeDate(StrToDate(sD), x.aa, x.mm, x.dd);
           x.value := toFloat(p.ActiveSheet.GetDisplayText(L, 2), wscMissValue);
           Stations[StationIndex].Add(x);
           end
        else
           break;

      until false;
    finally
      p.Free();
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
