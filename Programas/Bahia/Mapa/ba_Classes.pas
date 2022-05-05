unit ba_Classes;

interface
uses Classes, gridx32;

type
  TListaDeCenarios = Class;

  pRecCenario = ^TRecCenario;
  TRecCenario =  record
                   Arquivo    : String;
                   Nome       : String;
                   Comentario : String;
                 end;

  pRecSubBacia = ^TRecSubBacia;
  TRecSubBacia =  record
                    Nome       : String;
                    Comentario : String;
                    Cenarios   : TListaDeCenarios;
                  end;

  TListaDeCenarios = Class
  private
    FList: TList;
    function getCenario(i: Integer): TRecCenario;
    function getNumCenarios: Integer;
    procedure setCenario(i: Integer; const Value: TRecCenario);
    procedure setArquivo(i: Integer; const Value: String);
  public
    constructor Create;
    Destructor  Destroy; override;

    function  Remover(i: Integer): Integer;
    function  Adicionar(const umCenario: TRecCenario): Integer;

    procedure Associar(Cenarios: TListaDeCenarios);
    procedure Mostrar(SG: TdrStringAlignGrid);
    procedure Limpar;

    property Cenario[i: Integer]: TRecCenario read getCenario write setCenario; default;
    property Arquivo[i: Integer]: String write setArquivo;
    property NumCenarios: Integer read getNumCenarios;
  end;

  TListaDeSubBacias = Class
  private
    FList: TList;
    function getNumSubBacias: Integer;
    function getSubBacia(i: Integer): TRecSubBacia;
    procedure setSubBacia(i: Integer; const Value: TRecSubBacia);
  public
    constructor Create;
    Destructor  Destroy; override;

    function  Remover(i: Integer): Integer;
    function  Adicionar(const umaSubBacia: TRecSubBacia): Integer;
    function  IndicePeloNome(const NomeSB: String): Integer;

    procedure Limpar;
    procedure LerDoArquivo;

    property SubBacia[i: Integer]: TRecSubBacia read getSubBacia write setSubBacia; default;
    property NumSubBacias: Integer read getNumSubBacias;
  end;

  var
    gDir : String;

implementation
uses Forms, SysUtils, IniFiles;

{ TListaDeCenarios }

function TListaDeCenarios.Adicionar(const umCenario: TRecCenario): Integer;
var p: pRecCenario;
begin
  new(p);
  p^ := umCenario;
  Result := FList.Add(p);
end;

procedure TListaDeCenarios.Associar(Cenarios: TListaDeCenarios);
var i: Integer;
begin
  Limpar;
  for i := 0 to Cenarios.NumCenarios - 1 do
    Adicionar(Cenarios[i]);
end;

constructor TListaDeCenarios.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TListaDeCenarios.Destroy;
begin
  Limpar;
  FList.Free;
  inherited;
end;

function TListaDeCenarios.getCenario(i: Integer): TRecCenario;
begin
  Result := TRecCenario(FList[i]^);
end;

function TListaDeCenarios.getNumCenarios: Integer;
begin
  Result := FList.Count;
end;

procedure TListaDeCenarios.Limpar;
var i: Integer;
    p: pRecCenario;
begin
  for i := 0 to FList.Count - 1 do
    begin
    p := FList[i];
    Dispose(p);
    end;
  FList.Clear;
end;

procedure TListaDeCenarios.Mostrar(SG: TdrStringAlignGrid);
var i: Integer;
    p: pRecCenario;
begin
  SG.Clear(False);
  SG.RowCount := FList.Count + 1;
  for i := 0 to FList.Count - 1 do
    begin
    p := FList[i];
    SG.Cells[0, i+1] := p.Nome;
    SG.Cells[1, i+1] := p.Comentario;
    end;
end;

function TListaDeCenarios.Remover(i: Integer): Integer;
var p: pRecCenario;
begin
  p := FList[i];
  Dispose(p);
  FList.Delete(i);
end;

procedure TListaDeCenarios.setArquivo(i: Integer; const Value: String);
var p: pRecCenario;
begin
  p := FList[i];
  p.Arquivo := Value;
end;

procedure TListaDeCenarios.setCenario(i: Integer; const Value: TRecCenario);
var p: pRecCenario;
begin
  p := FList[i];
  p^ := Value;
end;

{ TListaDeSubBacias }

function TListaDeSubBacias.Adicionar(const umaSubBacia: TRecSubBacia): Integer;
var p: pRecSubBacia;
begin
  new(p);
  p^ := umaSubBacia;
  Result := FList.Add(p);
end;

constructor TListaDeSubBacias.Create;
begin
  inherited;
  FList := TList.Create;
end;

destructor TListaDeSubBacias.Destroy;
begin
  inherited;
  Limpar;
  FList.Free;
end;

function TListaDeSubBacias.getNumSubBacias: Integer;
begin
  Result := FList.Count;
end;

function TListaDeSubBacias.getSubBacia(i: Integer): TRecSubBacia;
begin
  Result := TRecSubBacia(FList[i]^);
end;

function TListaDeSubBacias.IndicePeloNome(const NomeSB: String): Integer;
var p: pRecSubBacia;
begin
  for Result := 0 to FList.Count - 1 do
    begin
    p := FList[Result];
    if CompareText(p^.Nome, NomeSB) = 0 then
       Exit;
    end;
  Result := -1;
end;

procedure TListaDeSubBacias.LerDoArquivo;
var Ini      : TMemIniFile;
    i,j,k,kk : Integer;
    s, Path  : String;
    SB       : TRecSubBacia;
    C        : TRecCenario;
begin
  Path := ExtractFilePath(Application.ExeName);
  Ini := TMemIniFile.Create(Path + 'SubBacias.Dat');
  i := Ini.ReadInteger('Geral', 'NumSubBacias', 0);
  for k := 1 to i do
    begin
    SB.Nome       := Ini.ReadString('Geral', 'SB'+IntToStr(k), '');
    SB.Comentario := Ini.ReadString(SB.Nome, 'Comentario', '');
    SB.Cenarios   := TListaDeCenarios.Create;

    j := Ini.ReadInteger(SB.Nome, 'NumCenarios', 0);
    for kk := 1 to j do
      begin
      s := ' C' + IntToStr(kk);
      C.Nome       := Ini.ReadString(SB.Nome, 'Nome' + s, '');
      C.Comentario := Ini.ReadString(SB.Nome, 'Comentario' + s, '');
      C.Arquivo    := Path + Ini.ReadString(SB.Nome, 'Arquivo' + s, '');
      SB.Cenarios.Adicionar(C);
      end; // for kk

    Adicionar(SB);
    end; // for k

  Ini.Free;
end;

procedure TListaDeSubBacias.Limpar;
var i: Integer;
    p: pRecSubBacia;
begin
  for i := 0 to FList.Count - 1 do
    begin
    p := FList[i];
    Dispose(p);
    end;
  FList.Clear;
end;

function TListaDeSubBacias.Remover(i: Integer): Integer;
var p: pRecSubBacia;
begin
  p := FList[i];
  Dispose(p);
  FList.Delete(i);
end;

procedure TListaDeSubBacias.setSubBacia(i: Integer; const Value: TRecSubBacia);
var p: pRecSubBacia;
    Ini: TMemIniFile;
    s, s2, Path: String;
begin
  p := FList[i];
  p^ := Value;

  Path := ExtractFilePath(Application.ExeName);
  Ini := TMemIniFile.Create(Path + 'SubBacias.Dat');
  Ini.EraseSection(Value.Nome);
  Ini.WriteString(Value.Nome, 'Comentario', Value.Comentario);
  Ini.WriteInteger(Value.Nome, 'NumCenarios', Value.Cenarios.NumCenarios);
  for i := 0 to Value.Cenarios.NumCenarios-1 do
    begin
    s := ' C' + IntToStr(i+1);
    Ini.WriteString(Value.Nome, 'Nome' + s , Value.Cenarios[i].Nome);
    Ini.WriteString(Value.Nome, 'Comentario' + s , Value.Cenarios[i].Comentario);

    s2 := Value.Cenarios[i].Arquivo;
    Delete(s2, 1, Length(Path));
    Ini.WriteString(Value.Nome, 'Arquivo' + s , s2);
    end;
  Ini.UpdateFile;
  Ini.Free;
end;

end.
