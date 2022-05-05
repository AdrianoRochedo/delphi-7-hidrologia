unit pro_Interfaces;

interface

type
  // Interface para controle de um processo
  IProcessControl = interface
    ['{F444178C-0C7A-414B-B96F-BD36081847C7}']
    procedure ipc_ShowMessage(const aMessage: string);
    procedure ipc_ShowError(const aError: string);
    procedure ipc_setMaxProgress(const aMax: integer);
    procedure ipc_setMinProgress(const aMin: integer);
    procedure ipc_setProgress(const aProgress: integer);
  end;

  IProcedaControl = interface
    ['{254AA447-C417-4797-BBD1-A1B7EDA5FCB1}']
    procedure ip_NewDataSet(const iniDate, endDate: TDateTime; const StationCount: integer);
    procedure ip_SetStationName(StationIndex: integer; const Name: string);
    procedure ip_SetStationValue(Date: TDateTime; StationIndex: integer; const Value: real);
    procedure ip_DoneImport();
  end;

implementation

end.
