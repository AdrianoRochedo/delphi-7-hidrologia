unit pro_Interfaces;

interface

type

  TTipoDados         = (tdChuva, tdVazao);
  TTipoIntervalo     = (tiDiario, tiQuinquendial, tiSemanal, tiDecendial,
                        tiQuinzenal, tiMensal, tiAnual);

  // Interface para controle de um processo
  IProcessControl = interface
    ['{F444178C-0C7A-414B-B96F-BD36081847C7}']
    procedure ipc_ShowMessage(const aMessage: string);
    procedure ipc_ShowError(const aError: string);
    procedure ipc_setMaxProgress(const aMax: integer);
    procedure ipc_setMinProgress(const aMin: integer);
    procedure ipc_setProgress(const aProgress: integer);
  end;

  // Representa uma interface para o controle dos dados do Proceda
  // Os indices das estacoes estao baseados em 0
  IDataControl = interface
    ['{C5C6CBB9-80A6-48A6-A663-47BB6BD3FB2A}']

    // functions
    function getReference(): TObject;
    function getLowRecIndex(): integer;
    function getHighRecIndex(): integer;
    function getLowDate(): TDateTime;
    function getHighDate(): TDateTime;
    function getDate(const RecordIndex: integer): TDateTime;
    function getStation(const RecordIndex, StationIndex: integer): real;
    function getStationName(StationIndex: integer): string;
    function getStationDesc(StationIndex: integer): string;
    function getStationType(StationIndex: integer): string;
    function getStationUnit(StationIndex: integer): string;
    function getStationProp(StationIndex, PropIndex: integer): string; overload;
    function getStationProp(StationIndex: integer; const PropName: string): string; overload;
    function getStationPropCount(StationIndex: integer): integer;
    function getStationCount(): integer;
    function getDataType(): TTipoDados; deprecated;
    function getIntervalType(): TTipoIntervalo;
    function getRecIndexByDate(const Date: TDateTime): integer;

    // procedures
    procedure setTitle(const Title: string);
    procedure setStationName(StationIndex: integer; const Name: string);
    procedure setStationValue(Date: TDateTime; StationIndex: integer; const Value: real);
    procedure setStationDesc(StationIndex: integer; const aDesc: string);
    procedure setStationType(StationIndex: integer; const aType: string);
    procedure setStationUnit(StationIndex: integer; const aUnit: string);
    procedure defineStationProp(StationIndex: integer; const aPropName, aPropValue: string);
  end;

  IProcedaControl = interface
    ['{254AA447-C417-4797-BBD1-A1B7EDA5FCB1}']
     function NewDataSet(const MinDate, MaxDate: TDateTime; const IntervalType: TTipoIntervalo; const StationCount: integer): IDataControl;
    procedure ShowMessage(const aMessage: string);
    procedure DoneImport(dc: IDataControl);
  end;

implementation

end.
