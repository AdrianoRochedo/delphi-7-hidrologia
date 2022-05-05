unit esquemas_OpcoesGraf;

interface
uses Classes, Lists;

type
  Tesq_OpcoesGraf = TBooleanList;

  TListaDeEsquemasGraficos = Class
  private
    FLista: TStrings;
    function getEsq(index: Integer): Tesq_OpcoesGraf;
    function getNumEsquemas: Integer;
    procedure setEsq(index: Integer; const Value: Tesq_OpcoesGraf);
  public
    constructor Create;
    Destructor  Destroy; override;

    function  Existe(const Nome: String): Boolean;
    function  Remover(const Nome: String): Integer;
    function  Adicionar(const Nome: String; Esquema: Tesq_OpcoesGraf): Integer;

    procedure Mostrar(C: TStrings);

    property Esquema[index: Integer]: Tesq_OpcoesGraf read getEsq write setEsq; default;
    property Esquemas: Integer read getNumEsquemas;
  end;


implementation

{ TListaDeEsquemasGraficos }

function TListaDeEsquemasGraficos.Adicionar(const Nome: String; Esquema: Tesq_OpcoesGraf): Integer;
begin
  Result := FLista.AddObject(Nome, Esquema);
end;

constructor TListaDeEsquemasGraficos.Create;
begin
  inherited Create;
  FLista := TStringList.Create;
end;

destructor TListaDeEsquemasGraficos.Destroy;
var i: Integer;
begin
  for i := 0 to FLista.Count-1 do Tesq_OpcoesGraf(FLista.Objects[i]).Free;
  FLista.Free;
  inherited Destroy;
end;

function TListaDeEsquemasGraficos.Existe(const Nome: String): Boolean;
begin
  Result := (FLista.IndexOf(Nome) > -1);
end;

function TListaDeEsquemasGraficos.getEsq(index: Integer): Tesq_OpcoesGraf;
begin
  Result := Tesq_OpcoesGraf(FLista.Objects[Index]);
end;

function TListaDeEsquemasGraficos.getNumEsquemas: Integer;
begin
  Result := FLista.Count;
end;

procedure TListaDeEsquemasGraficos.Mostrar(C: TStrings);
begin
  C.Assign(FLista);
end;

function TListaDeEsquemasGraficos.Remover(const Nome: String): Integer;
begin
  if Existe(Nome) then
     FLista.Delete(FLista.IndexOf(Nome));
end;

procedure TListaDeEsquemasGraficos.setEsq(index: Integer; const Value: Tesq_OpcoesGraf);
begin
  Tesq_OpcoesGraf(FLista.Objects[Index]).Free;
  FLista.Objects[Index] := Value;
end;

end.
