unit xx_Classes;

 // Utilize esta unidade como modelo para suas classes e de preferencia troque o prefixo
 // xx por algo mais significativo.

interface
uses // Geral
     Classes,
     Types,
     MapObjects,
     SysUtils,
     Graphics,
     ErrosDLG,
     Shapes,

     // Projeto
     hidro_Tipos,
     hidro_Classes,
     hidro_Dialogo;

type
  // Projeto

  Txx_Dados_Projeto = class(THidroDados)
  protected
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); override;
    procedure SalvarEmArquivo(Ini: TIF; Const Secao: String); override;
    procedure PegarDadosDoDialogo(d: THidroDialogo); override;
    procedure PorDadosNoDialogo(d: THidroDialogo); override;
    procedure ValidarDados(var TudoOk: Boolean; DialogoDeErros: TErros_DLG;
                           Completo: Boolean = False); override;
  end;

  Txx_Projeto = class(TProjeto)
  protected
    function CriarDados: THidroDados; override;
    function CriarGerenteDeResultados: TGerenteDeResultados; override;
    function CriarObjeto(const ID: String; Pos: ImoPoint): THidroComponente; override;
    procedure ExecutarSimulacao; override;
  end;

  // Sub-Bacia

  Txx_Dados_SubBacia = class(THidroDados)
  private
    FArea: Real;
  protected
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); override;
    procedure SalvarEmArquivo(Ini: TIF; Const Secao: String); override;
    procedure PegarDadosDoDialogo(d: THidroDialogo); override;
    procedure PorDadosNoDialogo(d: THidroDialogo); override;
    procedure ValidarDados(var TudoOk: Boolean; DialogoDeErros: TErros_DLG;
                           Completo: Boolean = False); override;
  public
    property Area : Real read FArea;
  end;

  Txx_SubBacia = class(TSubBacia)
  protected
    function CriarDados: THidroDados; override;
    function CriarDialogo: THidroDialogo; override;
  end;

  // Trecho-Dágua

  Txx_TrechoDagua = class(TTrechoDagua)
  protected
  end;

  // PC

  Txx_PC = class(TPC)
  protected
    function CriarTrechoDagua(ConectarEm: TPC): TTrechoDagua; override;
    function PossuiObjetosConectados: Boolean; override;
    function ObterVazoesDeMontante: Real; override;
    function ObterVazaoAfluenteSBs: Real; override;
    procedure BalancoHidrico; override;
  end;

  // Reservatório

  Txx_Dados_RES = class(THidroDados)
  protected
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); override;
    procedure SalvarEmArquivo(Ini: TIF; Const Secao: String); override;
    procedure PegarDadosDoDialogo(d: THidroDialogo); override;
    procedure PorDadosNoDialogo(d: THidroDialogo); override;
    procedure ValidarDados(var TudoOk: Boolean; DialogoDeErros: TErros_DLG; Completo: Boolean = False); override;
  end;

  Txx_RES = class(Txx_PC)
  protected
    function CriarDados: THidroDados; override;
    function CriarImagemDoComponente: TdrBaseShape; override;
    function ObterPrefixo: String; Override;
    procedure BalancoHidrico; override;
  end;

  // Derivação

  Txx_Dados_Derivacao = class(THidroDados)
  protected
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); override;
    procedure SalvarEmArquivo(Ini: TIF; Const Secao: String); override;
    procedure PegarDadosDoDialogo(d: THidroDialogo); override;
    procedure PorDadosNoDialogo(d: THidroDialogo); override;
    procedure ValidarDados(var TudoOk: Boolean; DialogoDeErros: TErros_DLG;
                           Completo: Boolean = False); override;
  end;

  Txx_Derivacao = class(TDerivacao)
  protected
    function CriarDados: THidroDados; override;
  end;

  // Demandas

  Txx_Demanda = class(TDemanda)
  end;

implementation
uses xx_GerenteDeResultados,
     xx_Dialogo_SubBacia;

{ Txx_Dados_Projeto }

procedure Txx_Dados_Projeto.LerDoArquivo(Ini: TIF; const Secao: String);
begin

end;

procedure Txx_Dados_Projeto.PegarDadosDoDialogo(d: THidroDialogo);
begin

end;

procedure Txx_Dados_Projeto.PorDadosNoDialogo(d: THidroDialogo);
begin

end;

procedure Txx_Dados_Projeto.SalvarEmArquivo(Ini: TIF; const Secao: String);
begin

end;

procedure Txx_Dados_Projeto.ValidarDados(var TudoOk: Boolean; DialogoDeErros: TErros_DLG; Completo: Boolean);
begin
  inherited;

end;

{ Txx_Projeto }

function Txx_Projeto.CriarDados: THidroDados;
begin
  Result := Txx_Dados_Projeto.Create;
end;

function Txx_Projeto.CriarGerenteDeResultados: TGerenteDeResultados;
begin
  Result := TxxGerenteDeResultados.Create(self);
end;

function Txx_Projeto.CriarObjeto(const ID: String; Pos: ImoPoint): THidroComponente;
var p: TPoint;
begin
  if (CompareText(ID, 'PC') = 0) or (CompareText(ID, 'Txx_PC') = 0) then
     begin
     Result := Txx_PC.Create(Pos, self, TabNomes);
     end
  else

  if (CompareText(ID, 'Reservatorio') = 0) or (CompareText(ID, 'Txx_RES') = 0) then
     begin
     Result := Txx_RES.Create(Pos, self, TabNomes);
     end
  else

  if CompareText(ID, 'Sub-Bacia') = 0 then
     begin
     p := moPointToPoint(Pos);
     inc(p.x, 20); dec(p.y, 20);
     Result := Txx_SubBacia.Create(PointTo_moPoint(p), self, TabNomes);
     end
  else

  if CompareText(ID, 'Derivacao') = 0 then
     begin
     p := moPointToPoint(Pos);
     inc(p.x, 20); dec(p.y, 20);
     Result := Txx_Derivacao.Create(PointTo_moPoint(p), self, TabNomes);
     end
  else

  if (CompareText(ID, 'Demanda') = 0) then
     begin
     Result := Txx_Demanda.Create(Pos, self, TabNomes, '...');
     end;

  Result.Modificado := True;
end;

procedure Txx_Projeto.ExecutarSimulacao;
begin

end;

{ Txx_Dados_SubBacia }

procedure Txx_Dados_SubBacia.LerDoArquivo(Ini: TIF; const Secao: String);
begin

end;

procedure Txx_Dados_SubBacia.PegarDadosDoDialogo(d: THidroDialogo);
begin
  with (d as TxxDialogo_SubBacia) do
    begin
    FArea := edArea.AsFloat;
    end;
end;

procedure Txx_Dados_SubBacia.PorDadosNoDialogo(d: THidroDialogo);
begin
  with (d as TxxDialogo_SubBacia) do
    begin
    edArea.AsFloat := FArea;
    end;
end;

procedure Txx_Dados_SubBacia.SalvarEmArquivo(Ini: TIF;  const Secao: String);
begin

end;

procedure Txx_Dados_SubBacia.ValidarDados(var TudoOk: Boolean; DialogoDeErros: TErros_DLG; Completo: Boolean);
begin

end;

{ Txx_SubBacia }

function Txx_SubBacia.CriarDados: THidroDados;
begin
  Result := Txx_Dados_SubBacia.Create;
end;

function Txx_SubBacia.CriarDialogo: THidroDialogo;
begin
  Result := TxxDialogo_SubBacia.Create(TabNomes, self);
end;

{ Txx_PC }

procedure Txx_PC.BalancoHidrico;
begin

end;

function Txx_PC.CriarTrechoDagua(ConectarEm: TPC): TTrechoDagua;
begin
  Result := Txx_TrechoDagua.Create(Self, ConectarEm, TabNomes, Projeto);
end;

function Txx_PC.ObterVazaoAfluenteSBs: Real;
begin
  Result := 0;
end;

function Txx_PC.ObterVazoesDeMontante: Real;
begin
  Result := 0;
end;

function Txx_PC.PossuiObjetosConectados: Boolean;
begin
  Result := False;
end;

{ Txx_Dados_RES }

procedure Txx_Dados_RES.LerDoArquivo(Ini: TIF; const Secao: String);
begin

end;

procedure Txx_Dados_RES.PegarDadosDoDialogo(d: THidroDialogo);
begin

end;

procedure Txx_Dados_RES.PorDadosNoDialogo(d: THidroDialogo);
begin

end;

procedure Txx_Dados_RES.SalvarEmArquivo(Ini: TIF; const Secao: String);
begin

end;

procedure Txx_Dados_RES.ValidarDados(var TudoOk: Boolean; DialogoDeErros: TErros_DLG; Completo: Boolean);
begin

end;

{ Txx_RES }

procedure Txx_RES.BalancoHidrico;
begin

end;

function Txx_RES.CriarDados: THidroDados;
begin
  Result := Txx_Dados_RES.Create;
end;

function Txx_RES.CriarImagemDoComponente: TdrBaseShape;
begin
  Result := TdrTriangle.Create(nil);
  Result.Canvas.Brush.Color := clBlue;
  Result.Width := 20;
  Result.Height := 20;
end;

function Txx_RES.ObterPrefixo: String;
begin
  Result := 'Res_';
end;

{ Txx_Dados_Derivacao }

procedure Txx_Dados_Derivacao.LerDoArquivo(Ini: TIF; const Secao: String);
begin

end;

procedure Txx_Dados_Derivacao.PegarDadosDoDialogo(d: THidroDialogo);
begin

end;

procedure Txx_Dados_Derivacao.PorDadosNoDialogo(d: THidroDialogo);
begin

end;

procedure Txx_Dados_Derivacao.SalvarEmArquivo(Ini: TIF; const Secao: String);
begin

end;

procedure Txx_Dados_Derivacao.ValidarDados(var TudoOk: Boolean; DialogoDeErros: TErros_DLG; Completo: Boolean);
begin

end;

{ Txx_Derivacao }

function Txx_Derivacao.CriarDados: THidroDados;
begin
  Result := Txx_Dados_Derivacao.Create;
end;

end.
