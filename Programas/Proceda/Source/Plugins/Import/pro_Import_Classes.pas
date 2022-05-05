unit pro_Import_Classes;

interface
uses Classes, Contnrs, SysUtils, pro_Interfaces;

type
  TDataRec = record
               dd, mm, aa : word;
               value      : double;
             end;

  pDataRec = ^TDataRec;

  // Representa os dados de um posto
  TStation = class
  private
    FList: TList;
    FName: string;
    FDataUnit: string;
    FDataType: string;
    FDescription: string;
    FProperties: TStrings;
  public
    constructor Create();
    destructor Destroy(); override;

    procedure Add(const DataRec: TDataRec); overload;
    procedure Add(const dd, mm, aa: word; const Value: single); overload;

    function getMinDate(): TDateTime;
    function getMaxDate(): TDateTime;

    property Name        : string   read FName        write FName;
    property Description : string   read FDescription write FDescription;
    property DataType    : string   read FDataType    write FDataType;
    property DataUnit    : string   read FDataUnit    write FDataUnit;
    property Properties  : TStrings read FProperties  write FProperties;
  end;

  // Representa um conjunto de dados - Postos
  TStations = class
  private
    FList: TObjectList;
    FDI: TTipoIntervalo;
    FFileType: TTipoDados;
    FTitle: string;
    function getStation(i: integer): TStation;
  public
    constructor Create(StationCount: integer);
    destructor Destroy(); override;

    // Utiliza a interface de controle para gerar o conjunto de dados
    procedure ConvertToProcedaDataSet(ProcedaIntf: IProcedaControl);

    property Title        : string         read FTitle write FTitle;
    property DataInterval : TTipoIntervalo read FDI    write FDI;

    property Station[i: integer] : TStation read getStation; default;
  end;

implementation

{ TStation }

constructor TStation.Create;
begin
  inherited Create();
  FList := TList.Create();
  FProperties := TStringList.Create();
end;

destructor TStation.Destroy;
var i: Integer;
begin
  for i := 0 to FList.Count-1 do Dispose( pDataRec(FList[i]) );
  FList.Free();
  FProperties.Free();
  inherited;
end;

procedure TStation.Add(const DataRec: TDataRec);
var p: pDataRec;
begin
  New(p);
  p^ := DataRec;
  FList.Add(p);
end;

procedure TStation.Add(const dd, mm, aa: word; const Value: single);
var p: pDataRec;
begin
  New(p);
  p.dd := dd;
  p.mm := mm;
  p.aa := aa;
  p.value := Value;
  FList.Add(p);
end;

function TStation.getMinDate(): TDateTime;
var p: pDataRec;
    i: integer;
    x: TDateTime;
begin
  p := FList.First();
  result := EncodeDate(p.aa, p.mm, p.dd);
  for i := 1 to FList.Count-1 do
    begin
    p := FList[i];
    x := EncodeDate(p.aa, p.mm, p.dd);
    if x < result then result := x;
    end;
end;

function TStation.getMaxDate(): TDateTime;
var p: pDataRec;
    i: integer;
    x: TDateTime;
begin
  p := FList.Last();
  result := EncodeDate(p.aa, p.mm, p.dd);
  for i := FList.Count-2 downto 0 do
    begin
    p := FList[i];
    x := EncodeDate(p.aa, p.mm, p.dd);
    if x > result then result := x;
    end;
end;

{ TStations }

procedure TStations.ConvertToProcedaDataSet(ProcedaIntf: IProcedaControl);
var i, j: Integer;
    MinDate, MaxDate, d1, d2: TDateTime;
    p: pDataRec;
    Station: TStation;
    dc: IDataControl;
begin
  // Obtem o mais amplo intervalo
  MinDate := 999999999999;
  MaxDate := -99999999999;
  for i := 0 to FList.Count-1 do
    begin
    Station := self.getStation(i);
    d1 := Station.getMinDate();
    d2 := Station.getMaxDate();
    if d1 < MinDate then MinDate := d1;
    if d2 > MaxDate then MaxDate := d2;
    end;

  // Gera o Dataset
  dc := ProcedaIntf.NewDataSet(MinDate, MaxDate, FDI, FList.Count);
  dc.setTitle(FTitle);

  for i := 0 to FList.Count-1 do
    begin
    Station := self.getStation(i);
    
    dc.setStationName(i, Station.Name);
    dc.setStationDesc(i, Station.Description);
    dc.setStationType(i, Station.DataType);
    dc.setStationUnit(i, Station.DataUnit);

    for j := 0 to Station.Properties.Count-1 do
      dc.defineStationProp(i, Station.Properties.Names[j],
                              Station.Properties.ValueFromIndex[j]);

    for j := 0 to Station.FList.Count-1 do
      begin
      p := Station.FList[j];
      d1 := EncodeDate(p.aa, p.mm, p.dd);
      dc.setStationValue(d1, i, p.Value);
      end;
    end;

  ProcedaIntf.DoneImport(dc);
end;

constructor TStations.Create(StationCount: integer);
var i: Integer;
begin
  inherited Create();
  FList := TObjectList.Create(true);
  for i := 1 to StationCount do
    FList.Add( TStation.Create() );
end;

destructor TStations.Destroy;
begin
  FList.Free();
  inherited;
end;

function TStations.getStation(i: integer): TStation;
begin
  result := TStation(FList[i]);
end;

end.
