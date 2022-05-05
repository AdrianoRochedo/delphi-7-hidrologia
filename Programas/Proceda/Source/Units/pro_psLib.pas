unit pro_psLib;

// Unidade gerada automaticamente pelo Programa <Gerador de Bibliotecas>

interface
uses psBase;

  procedure API(Lib: TLib);

type
  Tps_Application = class(TpsClass)
    procedure AddMethods; override;
    class procedure am_AddSerie(Const Func_Name: String; Stack: TexeStack);
    class procedure am_GetDatasetByName(Const Func_Name: String; Stack: TexeStack);
    class procedure am_Series(Const Func_Name: String; Stack: TexeStack);
    class procedure am_ShowMessage(Const Func_Name: String; Stack: TexeStack);
  end;

  Tps_DSInfo = class(TpsClass)
    procedure AddMethods; override;
    class procedure am_Data(Const Func_Name: String; Stack: TexeStack);
    class procedure am_Filename(Const Func_Name: String; Stack: TexeStack);
    class procedure am_GetStationByName(Const Func_Name: String; Stack: TexeStack);
    class procedure am_getStationNames(Const Func_Name: String; Stack: TexeStack);
    class procedure am_Station(Const Func_Name: String; Stack: TexeStack);
    class procedure am_StationCount(Const Func_Name: String; Stack: TexeStack);
  end;

  Tps_Serie = class(TpsClass)
    procedure AddMethods; override;
    class procedure am_AddSerie(Const Func_Name: String; Stack: TexeStack);
    class procedure am_Admensionalize(Const Func_Name: String; Stack: TexeStack);
    class procedure am_Admensioned(Const Func_Name: String; Stack: TexeStack);
    class procedure am_Clone(Const Func_Name: String; Stack: TexeStack);
    class procedure am_Convert(Const Func_Name: String; Stack: TexeStack);
    class procedure am_ConvertToDataset(Const Func_Name: String; Stack: TexeStack);
    class procedure am_Data(Const Func_Name: String; Stack: TexeStack);
    class procedure am_LN(Const Func_Name: String; Stack: TexeStack);
    class procedure am_Name(Const Func_Name: String; Stack: TexeStack);
    class procedure am_Plot(Const Func_Name: String; Stack: TexeStack);
    class procedure am_PlotAMD(Const Func_Name: String; Stack: TexeStack);
    class procedure am_Series(Const Func_Name: String; Stack: TexeStack);
    class procedure am_ShowDataInSheet(Const Func_Name: String; Stack: TexeStack);
    class procedure am_ShowHeaderInSheet(Const Func_Name: String; Stack: TexeStack);
    class procedure am_Station(Const Func_Name: String; Stack: TexeStack);
    class procedure am_StrongName(Const Func_Name: String; Stack: TexeStack);
  end;

  Tps_Series = class(TpsClass)
    procedure AddMethods; override;
    class procedure am_Add(Const Func_Name: String; Stack: TexeStack);
    class procedure am_Count(Const Func_Name: String; Stack: TexeStack);
    class procedure am_Remove(Const Func_Name: String; Stack: TexeStack);
    class procedure am_Serie(Const Func_Name: String; Stack: TexeStack);
  end;

  Tps_Station = class(TpsClass)
    procedure AddMethods; override;
    class procedure am_AddSerie(Const Func_Name: String; Stack: TexeStack);
    class procedure am_Count(Const Func_Name: String; Stack: TexeStack);
    class procedure am_Description(Const Func_Name: String; Stack: TexeStack);
    class procedure am_ExtraData(Const Func_Name: String; Stack: TexeStack);
    class procedure am_getDate(Const Func_Name: String; Stack: TexeStack);
    class procedure am_getValue(Const Func_Name: String; Stack: TexeStack);
    class procedure am_IndexOfDate(Const Func_Name: String; Stack: TexeStack);
    class procedure am_IsNull(Const Func_Name: String; Stack: TexeStack);
    class procedure am_MonthCount(Const Func_Name: String; Stack: TexeStack);
    class procedure am_Name(Const Func_Name: String; Stack: TexeStack);
    class procedure am_Series(Const Func_Name: String; Stack: TexeStack);
    class procedure am_setValue(Const Func_Name: String; Stack: TexeStack);
  end;

implementation
uses Classes,
     wsVec,
     wsMatrix,
     Form_Chart,
     SpreadSheetBook,
     pro_Application,
     pro_Classes;

  procedure API(Lib: TLib);
  const cCAT_Proceda = 'Proceda';
  begin
    Tps_Application.Create(TproApplication,
                           nil,
                           '',
                           cCAT_Proceda,
                           [],
                           [],
                           [],
                           False,
                           Lib.Classes);

    Tps_DSInfo.Create(TDSInfo,
                      nil,
                      'Representa um conjunto de postos.',
                      cCAT_Proceda,
                      [],
                      [],
                      [],
                      False,
                      Lib.Classes);

    Tps_Serie.Create(TSerie,
                     nil,
                     'Representa uma série de valores',
                     cCAT_Proceda,
                     [],
                     [],
                     [],
                     true,
                     Lib.Classes);

    Tps_Series.Create(TSeries,
                      nil,
                      'Representa uma lista de séries',
                      cCAT_Proceda,
                      [],
                      [],
                      [],
                      False,
                      Lib.Classes);

    Tps_Station.Create(TStation,
                       nil,
                       'Representa um posto.',
                       cCAT_Proceda,
                       [],
                       [],
                       [],
                       False,
                       Lib.Classes);
  end;

{ Tps_Application }

class procedure Tps_Application.am_AddSerie(Const Func_Name: String; Stack: TexeStack);
var o: TproApplication;
begin
  o := TproApplication(Stack.getSelf());
  o.AdicionarSerie(TSerie(Stack.AsObject(1)))
end;

class procedure Tps_Application.am_GetDatasetByName(Const Func_Name: String; Stack: TexeStack);
var o: TproApplication;
begin
  o := TproApplication(Stack.AsObject(2));
  Stack.PushObject(o.DatasetByName(Stack.AsString(1)))
end;

class procedure Tps_Application.am_Series(Const Func_Name: String; Stack: TexeStack);
var o: TproApplication;
begin
  o := TproApplication(Stack.AsObject(1));
  Stack.PushObject(o.Series)
end;

class procedure Tps_Application.am_ShowMessage(Const Func_Name: String; Stack: TexeStack);
var o: TproApplication;
begin
  o := TproApplication(Stack.AsObject(2));
  o.ShowMessage(Stack.AsString(1))
end;

procedure Tps_Application.AddMethods;
begin
  with Procs do
    begin
    Add('AddSerie',
        'Adiciona uma série na aplicação',
        '',
        [pvtObject],
        [TSerie],
        [True],
        pvtNull,
        TObject,
        am_AddSerie);

    Add('ShowMessage',
        'Mostra uma mensagem na aplicação',
        '',
        [pvtString],
        [nil],
        [False],
        pvtNull,
        TObject,
        am_ShowMessage);
    end;

  with Functions do
    begin
    Add('GetDatasetByName',
        '',
        '',
        [pvtString],
        [nil],
        [False],
        pvtObject,
        TDSInfo,
        am_GetDatasetByName);

    Add('Series',
        'Retorna a lista de séries da aplicação',
        '',
        [],
        [],
        [],
        pvtObject,
        TSeries,
        am_Series);
    end;
end;

{ Tps_DSInfo }

class procedure Tps_DSInfo.am_Data(Const Func_Name: String; Stack: TexeStack);
var o: TDSInfo;
begin
  o := TDSInfo(Stack.AsObject(1));
  Stack.PushObject(o.DS)
end;

class procedure Tps_DSInfo.am_Filename(Const Func_Name: String; Stack: TexeStack);
var o: TDSInfo;
begin
  o := TDSInfo(Stack.AsObject(1));
  Stack.PushString(o.NomeArq)
end;

class procedure Tps_DSInfo.am_GetStationByName(Const Func_Name: String; Stack: TexeStack);
var o: TDSInfo;
begin
  o := TDSInfo(Stack.AsObject(2));
  Stack.PushObject(o.getStationByName(Stack.AsString(1)))
end;

class procedure Tps_DSInfo.am_getStationNames(Const Func_Name: String; Stack: TexeStack);
var o: TDSInfo;
begin
  o := TDSInfo(Stack.AsObject(2));
  o.getStationNames(TStringList(Stack.AsObject(1)))
end;

class procedure Tps_DSInfo.am_Station(Const Func_Name: String; Stack: TexeStack);
var o: TDSInfo;
begin
  o := TDSInfo(Stack.AsObject(2));
  Stack.PushObject(o.Station[Stack.AsInteger(1)])
end;

class procedure Tps_DSInfo.am_StationCount(Const Func_Name: String; Stack: TexeStack);
var o: TDSInfo;
begin
  o := TDSInfo(Stack.AsObject(1));
  Stack.PushInteger(o.NumPostos)
end;

procedure Tps_DSInfo.AddMethods;
begin
  with Procs do
    begin
    Add('getStationNames',
        'Retorna o nome dos postos em uma lista de strings',
        '',
        [pvtObject],
        [TStringList],
        [True],
        pvtNull,
        TObject,
        am_getStationNames);
    end;

  with Functions do
    begin
    Add('Data',
        'Retorna os dados (matriz) deste conjunto',
        '',
        [],
        [],
        [],
        pvtObject,
        TwsDataset,
        am_Data);

    Add('Filename',
        'Retorna o nome do arquivo',
        '',
        [],
        [],
        [],
        pvtString,
        TObject,
        am_Filename);

    Add('GetStationByName',
        'Retorna o posto que coincidir com o parâmetro passado ou nil.',
        '',
        [pvtString],
        [nil],
        [False],
        pvtObject,
        TStation,
        am_GetStationByName);

    Add('Station',
        'Retorna o i-égimo posto baseado em 0',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtInteger,
        TObject,
        am_Station);

    Add('StationCount',
        'Retorna o número de postos contidos.',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        am_StationCount);
    end;
end;

{ Tps_Serie }

class procedure Tps_Serie.am_AddSerie(Const Func_Name: String; Stack: TexeStack);
var o: TSerie;
begin
  o := TSerie(Stack.AsObject(2));
  o.AdicionarSerie(TSerie(Stack.AsObject(1)))
end;

class procedure Tps_Serie.am_Admensionalize(Const Func_Name: String; Stack: TexeStack);
var o: TSerie;
begin
  o := TSerie(Stack.AsObject(1));
  o.Admensionalizar();
end;

class procedure Tps_Serie.am_Admensioned(Const Func_Name: String; Stack: TexeStack);
var o: TSerie;
begin
  o := TSerie(Stack.AsObject(1));
  Stack.PushBoolean(o.Adimensionalizada)
end;

class procedure Tps_Serie.am_Clone(Const Func_Name: String; Stack: TexeStack);
var o: TSerie;
begin
  o := TSerie(Stack.AsObject(1));
  Stack.PushObject(o.Clone)
end;

class procedure Tps_Serie.am_Convert(Const Func_Name: String; Stack: TexeStack);
var o: TSerie;
begin
  o := TSerie(Stack.AsObject(2));
  o.ConverterDados(Stack.AsFloat(1))
end;

class procedure Tps_Serie.am_ConvertToDataset(Const Func_Name: String; Stack: TexeStack);
var o: TSerie;
begin
  o := TSerie(Stack.AsObject(1));
  Stack.PushObject(o.ConverterParaDataset())
end;

class procedure Tps_Serie.am_Data(Const Func_Name: String; Stack: TexeStack);
var o: TSerie;
begin
  o := TSerie(Stack.AsObject(1));
  Stack.PushObject(o.Dados)
end;

class procedure Tps_Serie.am_LN(Const Func_Name: String; Stack: TexeStack);
var o: TSerie;
begin
  o := TSerie(Stack.AsObject(1));
  o.LN()
end;

class procedure Tps_Serie.am_Name(Const Func_Name: String; Stack: TexeStack);
var o: TSerie;
begin
  o := TSerie(Stack.AsObject(1));
  Stack.PushString(o.Nome)
end;

class procedure Tps_Serie.am_Plot(Const Func_Name: String; Stack: TexeStack);
var o: TSerie;
begin
  o := TSerie(Stack.AsObject(3));
  o.Plotar(TfoChart(Stack.AsObject(1)), Stack.AsInteger(2))
end;

class procedure Tps_Serie.am_PlotAMD(Const Func_Name: String; Stack: TexeStack);
var o: TSerie;
begin
  o := TSerie(Stack.AsObject(3));
  o.PlotarDMA(TfoChart(Stack.AsObject(1)), Stack.AsInteger(2))
end;

class procedure Tps_Serie.am_Series(Const Func_Name: String; Stack: TexeStack);
var o: TSerie;
begin
  o := TSerie(Stack.AsObject(1));
  Stack.PushObject(o.Series)
end;

class procedure Tps_Serie.am_ShowDataInSheet(Const Func_Name: String; Stack: TexeStack);
var o: TSerie;
begin
  o := TSerie(Stack.AsObject(3));
  o.MostrarDadosEmPlanilha(TSpreadSheetBook(Stack.AsObject(1)), Stack.AsInteger(2))
end;

class procedure Tps_Serie.am_ShowHeaderInSheet(Const Func_Name: String; Stack: TexeStack);
var o: TSerie;
begin
  o := TSerie(Stack.AsObject(3));
  o.MostrarCabecalhoEmPlanilha(TSpreadSheetBook(Stack.AsObject(1)), Stack.AsInteger(2))
end;

class procedure Tps_Serie.am_Station(Const Func_Name: String; Stack: TexeStack);
var o: TSerie;
begin
  o := TSerie(Stack.AsObject(1));
  Stack.PushObject(o.Posto)
end;

class procedure Tps_Serie.am_StrongName(Const Func_Name: String; Stack: TexeStack);
var o: TSerie;
begin
  o := TSerie(Stack.AsObject(1));
  Stack.PushString(o.NomeCompleto)
end;

procedure Tps_Serie.AddMethods;
begin
  with Procs do
    begin
    Add('AddSerie',
        'Adiciona uma outra série como filho desta.',
        '',
        [pvtObject],
        [TSerie],
        [True],
        pvtNull,
        TObject,
        am_AddSerie);

    Add('Admensionalize',
        'Admensiona os valores da série',
        '',
        [],
        [],
        [],
        pvtNull,
        TObject,
        am_Admensionalize);

    Add('Convert',
        'Converte os valores baseado em um fator, isto é, '#13 +
        'realiza uma multiplicação dos valores pelo fator dado.',
        '',
        [pvtReal],
        [nil],
        [False],
        pvtNull,
        TObject,
        am_Convert);

    Add('LN',
        'Calcula o Logarítmo Natural de cada um dos valores da série',
        '',
        [],
        [],
        [],
        pvtNull,
        TObject,
        am_LN);

    Add('Plot',
        'Plota os dados da série em um gráfico.'#13 +
        'O segundo parâmetro é utilizado para seleção automática da cor utilizada na série.',
        '',
        [pvtObject, pvtInteger],
        [TfoChart, nil],
        [True, False],
        pvtNull,
        TObject,
        am_Plot);

    Add('PlotAMD',
        'Plota a diferença da média acumulada.'#13 +
        'O segundo parâmetro é utilizado na seleção automática da cor',
        '',
        [pvtObject, pvtInteger],
        [TfoChart, nil],
        [True, False],
        pvtNull,
        TObject,
        am_PlotAMD);

    Add('ShowDataInSheet',
        'Mostra os valores da série em uma planilha em uma determinada coluna.',
        '',
        [pvtObject, pvtInteger],
        [TSpreadSheetBook, nil],
        [True, False],
        pvtNull,
        TObject,
        am_ShowDataInSheet);

    Add('ShowHeaderInSheet',
        'Mostra o cabeçalho da série em uma planilha em uma determinada coluna.',
        '',
        [pvtObject, pvtInteger],
        [TSpreadSheetBook, nil],
        [True, False],
        pvtNull,
        TObject,
        am_ShowHeaderInSheet);
    end;

  with Functions do
    begin
    Add('Admensioned',
        'Retorna se a série foi admensionalizada.',
        '',
        [],
        [],
        [],
        pvtBoolean,
        TObject,
        am_Admensioned);

    Add('Clone',
        'Clona o objeto',
        '',
        [],
        [],
        [],
        pvtObject,
        TSerie,
        am_Clone);

    Add('ConvertToDataset',
        'Converte o vetor com dados para um Dataset de uma coluna',
        '',
        [],
        [],
        [],
        pvtObject,
        TwsDataset,
        am_ConvertToDataset);

    Add('Data',
        'Retorna o vetor com os dados da série',
        '',
        [],
        [],
        [],
        pvtObject,
        TwsDFVec,
        am_Data);

    Add('Name',
        'Retorna o nome da série',
        '',
        [],
        [],
        [],
        pvtString,
        TObject,
        am_Name);

    Add('Series',
        'Retorna a lista de séries desta série',
        '',
        [],
        [],
        [],
        pvtObject,
        TSeries,
        am_Series);

    Add('Station',
        'Retorna a que posto esta série pertence.'#13 +
        'Se for uma série da aplicação, retornará nil.',
        '',
        [],
        [],
        [],
        pvtObject,
        TStation,
        am_Station);

    Add('StrongName',
        'Retorna o nome completo da série',
        '',
        [],
        [],
        [],
        pvtString,
        TObject,
        am_StrongName);
    end;
end;

{ Tps_Series }

class procedure Tps_Series.am_Add(Const Func_Name: String; Stack: TexeStack);
var o: TSeries;
begin
  o := TSeries(Stack.AsObject(2));
  o.Adicionar(TSerie(Stack.AsObject(1)))
end;

class procedure Tps_Series.am_Count(Const Func_Name: String; Stack: TexeStack);
var o: TSeries;
begin
  o := TSeries(Stack.AsObject(1));
  Stack.PushInteger(o.NumSeries)
end;

class procedure Tps_Series.am_Remove(Const Func_Name: String; Stack: TexeStack);
var o: TSeries;
begin
  o := TSeries(Stack.AsObject(2));
  o.Remover(TSerie(Stack.AsObject(1)))
end;

class procedure Tps_Series.am_Serie(Const Func_Name: String; Stack: TexeStack);
var o: TSeries;
begin
  o := TSeries(Stack.AsObject(2));
  Stack.PushObject(o.Serie[Stack.AsInteger(1)])
end;

procedure Tps_Series.AddMethods;
begin
  with Procs do
    begin
    Add('Add',
        'Adiciona uma série na lista',
        '',
        [pvtObject],
        [TSerie],
        [True],
        pvtNull,
        TObject,
        am_Add);

    Add('Remove',
        'Remove uma série da lista',
        '',
        [pvtObject],
        [TSerie],
        [True],
        pvtNull,
        TObject,
        am_Remove);
    end;

  with Functions do
    begin
    Add('Count',
        'Retorna o número de séries da lista',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        am_Count);

    Add('Serie',
        'Retorna a i-égima série da lista iniciando em 0',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtObject,
        TSerie,
        am_Serie);
    end;
end;

{ Tps_Station }

class procedure Tps_Station.am_AddSerie(Const Func_Name: String; Stack: TexeStack);
var o: TStation;
begin
  o := TStation(Stack.AsObject(2));
  o.AdicionarSerie(TSerie(Stack.AsObject(1)))
end;

class procedure Tps_Station.am_Count(Const Func_Name: String; Stack: TexeStack);
var o: TStation;
begin
  o := TStation(Stack.AsObject(1));
  Stack.PushInteger(o.Count)
end;

class procedure Tps_Station.am_Description(Const Func_Name: String; Stack: TexeStack);
var o: TStation;
begin
  o := TStation(Stack.AsObject(1));
  Stack.PushObject(o.Comment)
end;

class procedure Tps_Station.am_ExtraData(Const Func_Name: String; Stack: TexeStack);
var o: TStation;
begin
  o := TStation(Stack.AsObject(1));
  Stack.PushObject(o.ExtraData)
end;

class procedure Tps_Station.am_getDate(Const Func_Name: String; Stack: TexeStack);
var o: TStation;
begin
  o := TStation(Stack.AsObject(2));
  Stack.PushFloat(o.Data[Stack.AsInteger(1)])
end;

class procedure Tps_Station.am_getValue(Const Func_Name: String; Stack: TexeStack);
var o: TStation;
begin
  o := TStation(Stack.AsObject(2));
  Stack.PushFloat(o.Valor[Stack.AsInteger(1)])
end;

class procedure Tps_Station.am_IndexOfDate(Const Func_Name: String; Stack: TexeStack);
var o: TStation;
begin
  o := TStation(Stack.AsObject(2));
  Stack.PushInteger(o.IndiceDaData(Stack.AsFloat(1)))
end;

class procedure Tps_Station.am_IsNull(Const Func_Name: String; Stack: TexeStack);
var o: TStation;
begin
  o := TStation(Stack.AsObject(2));
  Stack.PushBoolean(o.Nulo(Stack.AsInteger(1)))
end;

class procedure Tps_Station.am_MonthCount(Const Func_Name: String; Stack: TexeStack);
var o: TStation;
begin
  o := TStation(Stack.AsObject(1));
  Stack.PushInteger(o.NumeroDeMeses)
end;

class procedure Tps_Station.am_Name(Const Func_Name: String; Stack: TexeStack);
var o: TStation;
begin
  o := TStation(Stack.AsObject(1));
  Stack.PushString(o.Nome)
end;

class procedure Tps_Station.am_Series(Const Func_Name: String; Stack: TexeStack);
var o: TStation;
begin
  o := TStation(Stack.AsObject(1));
  Stack.PushObject(o.Series)
end;

class procedure Tps_Station.am_setValue(Const Func_Name: String; Stack: TexeStack);
var o: TStation;
begin
  o := TStation(Stack.AsObject(3));
  o.Valor[Stack.AsInteger(1)] := Stack.AsFloat(2);
end;

procedure Tps_Station.AddMethods;
begin
  with Procs do
    begin
    Add('AddSerie',
        'Adiciona uma série como filha deste posto.',
        '',
        [pvtObject],
        [TSerie],
        [True],
        pvtNull,
        TObject,
        am_AddSerie);

    Add('getValue',
        'Retorna o valor do i-egimo elemento do posto.',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtNull,
        TObject,
        am_getValue);

    Add('setValue',
        'Estabelece o valor do i-egimo elemento do posto.',
        '',
        [pvtInteger, pvtReal],
        [nil, nil],
        [False, False],
        pvtNull,
        TObject,
        am_setValue);
    end;

  with Functions do
    begin
    Add('Count',
        'Retorna o número de valores armazenados por este posto.',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        am_Count);

    Add('Description',
        'Representa o objeto que armazena as descrições do posto',
        '',
        [],
        [],
        [],
        pvtObject,
        TStringList,
        am_Description);

    Add('ExtraData',
        'Representa o objeto que armazena os dados extras do posto.',
        '',
        [],
        [],
        [],
        pvtObject,
        TStringList,
        am_ExtraData);

    Add('getDate',
        'Retorna a data do i-égimo valor do posto',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtReal,
        TObject,
        am_getDate);

    Add('IndexOfDate',
        'Retorna o índice de uma data',
        '',
        [pvtReal],
        [nil],
        [False],
        pvtInteger,
        TObject,
        am_IndexOfDate);

    Add('IsNull',
        'Verifica se um valor do posto é nulo.',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtBoolean,
        TObject,
        am_IsNull);

    Add('MonthCount',
        'Retorna o número de meses contidos pelo posto.'#13 +
        'Considera somente o periodo de dados.',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        am_MonthCount);

    Add('Name',
        'Retorna o nome deste posto',
        '',
        [],
        [],
        [],
        pvtString,
        TObject,
        am_Name);

    Add('Series',
        'Retorna as séries deste posto',
        '',
        [],
        [],
        [],
        pvtObject,
        TSeries,
        am_Series);
    end;
end;

end.
