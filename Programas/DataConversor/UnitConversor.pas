unit UnitConversor;

interface
uses DB,DBTables, Classes;
const
  CIMax = 7;
  COMax = 19;
type
  TListType   = (isInput=CIMax-1, isOutput=COMax-1);
  TTableILIst = array [0..CIMax-1] of TTable;
  TTableOList = array [0..COMax-1] of TTable;

  TConversor = class
    private
      FLog        : TStringList;
      FInputList  : TTableILIst;
      FOutputList : TTableOList;
      FIndex      : integer;
      FInputDir   : string;
      FOutputDir  : string;

      procedure StartTables;

      function IndexOf(const TableName: string; TableType: TListType): integer;
      function OWhatToDo(const TableName, Field, Value: string) : byte;
    public
      property FieldIndex : integer     read FIndex write FIndex;
      property InputList  : TTableILIst read FInputList;
      property OutputList : TTableOList read FOutputList;
      property InputDir   : string      read FInputDir write FInputDir;
      property OutputDir  : string      read FOutputDir write FOutputDir;

      function Insert(const Table, Field: string; const Value: variant): integer;
      function InsertIf(const Table1, Field1: string; const Values1: array of variant; const Table2, Field2: string; const Values2: array of variant): integer;
      function Copy(const Table1, Field1, Table2, Field2: string): boolean;
      function Execute : boolean;
      function Add(const Table: TTable): integer;

      constructor Create;
    end;
implementation
uses Math, UnitFormWhatDo, Forms, Sysutils, Dialogs;

{ TConversor }

function TConversor.Add(const Table: TTable): integer;
begin
  Table.Insert;
  Table.Post;
  Table.Last;
  Result := Table.RecNo;
end;

function TConversor.Copy(const Table1, Field1, Table2, Field2: string): boolean;
var
  I,J   : integer;
  F1,F2 : TField;
begin
// Preparar...
  I := IndexOf(Table1,isInput);
  J := IndexOf(Table2,isOutput);
  Result := False;

// Apontar...
  if (I > -1) and (J > -1) then
     begin
     F1 := InputList[I].FindField(Field1);
     F2 := OutputList[J].FindField(Field2);
     if (F1 <> nil) and (F2 <> nil) then
        begin
        Result := True;
        F2.Value := F1.Value;
        OutputList[J].Post;
        FLog.Append(Table2 + '.' + Field2 + ' := ' + Table1 + '.' + Field1 + ' = ' + F1.AsString);
        end
     else
        FLog.Append('Campos ' + Table2 + '.' + Field2 + ' ou ' + Table1 + '.' + Field1 + ' não encontrados');
     end
  else
     FLog.Append('Tabelas '+ Table2 + ' ou ' + Table1 + ' não encontradas');
end;

constructor TConversor.Create;
var
  Index : integer;
begin
  for Index := 0 to CIMax do
    FInputList[Index] := TTable.Create(nil);

  for Index := 0 to COMax do
    FOutputList[Index] := TTable.Create(nil);

  InputDir := '';
  OutputDir := '';
end;

function TConversor.Execute: boolean;
begin
  StartTables;
  OutputList[0].Open;
  OutputList[0].Last;
  FieldIndex := OutputList[0].RecNo;
  ShowMessage(IntToStr(FieldIndex));
end;

function TConversor.IndexOf(const TableName: string; TableType: TListType): integer;
var
  Index : integer;
begin
// Preparar...
  Index := 0;

// Apontar...
  case TableType of
    isInput:
      while (Index <= integer(isInput)) and (FInputList[Index].TableName <> TableName) do
        Inc(Index);

    isOutput:
      while (Index <= integer(isOutput)) and (FOutputList[Index].TableName <> TableName) do
        Inc(Index);
  end; //Case

// Fogo!!!
  if Index <= integer(TableType) then
     Result := Index
  else
     Result := -1;
end;

function TConversor.Insert(const Table, Field: string; const Value: variant): integer;
var
  I : integer;
  F : TField;
  T : TTable;
begin
// Preparar...
  I := IndexOf(Table,isOutput);
  Result := -1;

// Apontar...
  if I > -1 then
     begin
     T := OutputList[I];
     F := T.FindField(Field);
     if (F <> nil) then
        begin
        F.Value := Value;
        T.Post;
        Result := T.RecNo;
        FLog.Append(Table + '.' + Field + ' := ' + F.AsString);
        end
     else
        FLog.Append('Campo ' + Table + '.' + Field  + ' não encontrados ');
     end
  else
     FLog.Append('Tabelas '+ Table + ' não encontrada');
end;

function TConversor.InsertIf(const Table1, Field1: string; const Values1: array of variant;
                             const Table2, Field2: string; const Values2: array of variant): integer;
var
  T             : TTable;
  F1,F2         : TField;
  Index,I, J, L : integer;
begin
// Preparar...
  Index := 0;
  Result := -1;
  J := IndexOf(Table1,isInput);
  L := IndexOf(Table2,isOutput);
  I := Min(High(Values1),High(Values2));

// Apontar...
  if (I > -1) and (J > -1) then
     begin
     T := OutputList[L];
     F1 := InputList[J].FindField(Field1);
     F2 := T.FindField(Field2);
     if (F1 <> nil) and (F2 <> nil) then
        while Index <= I do
          if F1.Value = Values1[Index] then
             begin
             F2.Value := Values2[Index];
             T.Post;
             Index := I + 1;
             Result := T.RecNo;
             FLog.Append(Table2 + '.' + Field2 + ' := ' + F2.AsString + ' pq ' + F1.AsString);
             end
          else
             Inc(Index);
     end;
end;

function TConversor.OWhatToDo(const TableName, Field, Value: string): byte;
var
  Aux   : TStrings;
  Form  : TFormWhatToDo;
  Index : integer;
begin
// Preparar...
  Aux := TStrings.Create;
  Application.CreateForm(TFormWhatToDo,Form);

// Apontar...
  with Form do
    begin
    LEdValueOld.Text := Value;
    LEdFieldOld.Text := TableName + '.' + Field;
    for Index := 0 to Ord(isInput) do
      Aux.Append(InputList[Index].TableName);
    LBTables.Items := Aux;
    ShowModal;
    Result := byte(Form.ModalResult);
    end;

// Fogo!!!
  Aux.Free;
  Form.Free;
end;

procedure TConversor.StartTables;
var
  Index : integer;
begin
  for Index := 0 to CIMax do
    FInputList[Index].TableName := InputDir + 'Table' + IntToStr(Index + 1) + '.db';

  FOutputList[00].TableName := OutputDir + '\principal.db';
  FOutputList[01].TableName := OutputDir + '\ativanos.db';
  FOutputList[02].TableName := OutputDir + '\criacao.db';
  FOutputList[03].TableName := OutputDir + '\cultifina.db';
  FOutputList[04].TableName := OutputDir + '\cultirri.db';
  FOutputList[05].TableName := OutputDir + '\cultsati.db';
  FOutputList[06].TableName := OutputDir + '\culttipo.db';
  FOutputList[07].TableName := OutputDir + '\destprod.db';
  FOutputList[08].TableName := OutputDir + '\dimiprod.db';
  FOutputList[09].TableName := OutputDir + '\equipam.db';
  FOutputList[10].TableName := OutputDir + '\formprod.db';
  FOutputList[11].TableName := OutputDir + '\frutipo.db';
  FOutputList[12].TableName := OutputDir + '\grauinst.db';
  FOutputList[13].TableName := OutputDir + '\pessprod.db';
  FOutputList[14].TableName := OutputDir + '\pragas.db';
  FOutputList[15].TableName := OutputDir + '\aquisicao.db';
  FOutputList[16].TableName := OutputDir + '\prinrece.db';
  FOutputList[17].TableName := OutputDir + '\procol.db';
  FOutputList[18].TableName := OutputDir + '\tecnprod.db';
end;

end.
