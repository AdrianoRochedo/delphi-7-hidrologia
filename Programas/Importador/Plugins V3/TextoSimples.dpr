library TextoSimples;

uses
  SysUtils,
  Classes,
  SysUtilsEx,
  wsGLib,
  wsConstTypes;

{$R *.RES}

type
  TProc_AppendRecord = procedure (Posto: PChar;
                                  Data: Double;
                                  Valor: Double;
                                  Status: Integer);

  TProc_AtualizarStatus = procedure (ComandoAtual: PChar;
                                     LinhaAtual: Integer);

var
  FAppendRecord : TProc_AppendRecord;
  FAtualizarStatus : TProc_AtualizarStatus;

  // Retorna o nome do Padr�o de importa��o
  function Nome: PChar;
  begin
    Result := 'Texto Simples';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function Filtro: PChar;
  begin
    Result := 'Arquivos Texto (*.txt)|*.txt';
  end;

  // Retorna uma descri��o do formato de importa��o
  function Descricao: PChar;
  begin
    Result := 'Formato do Arquivo: Texto'#13#10 +
              '1.Linha: Identifica��o do posto'#13#10 +
              '2.Linha em Diante: 2 colunas separadas por espa�o ou tabula��o'#13#10 +
              '  - 1.Coluna: Data (dd/mm/aaaa)'#13#10 +
              '  - 2.Coluna: Valor (Ponto Decimal: ",")';
  end;

  // Retorna a vers�o do padr�o de importa��o
  function Versao: PChar;
  begin
    Result := '1.0';
  end;

  // Retorna o tipo dos dados que est�o sendo importados: 0 = Diario  1 = Mensal
  function TipoDosDados: Byte;
  begin
    Result := 0; // Di�rio
  end;

  // Recebe o endere�o de Callback da rotina que ir� adicionar os dados no BD
  procedure Set_RotinaDeAdicaoDosDados(Rotina: TProc_AppendRecord);
  begin
    FAppendRecord := Rotina;
  end;

  // Recebe o endere�o de Callback da rotina que ir� atualizar as mensagens de status
  procedure Set_StatusDaOperacao(Rotina: TProc_AtualizarStatus);
  begin
    FAtualizarStatus := Rotina;
  end;

  // Rotina principal respons�vel por realizar a importa��o dos dados
  procedure Importar(Arquivo: PChar);
  var i, k: Integer;
      s, Posto: String;
      Dado: Real;
      dc: Char;
      Arq: Text;
      Data: TDateTime;
  begin
    dc := DecimalSeparator;
    DecimalSeparator := ',';
    AssignFile(Arq, Arquivo);
    Reset(Arq);
    try
      // L� a identifica��o do posto
      ReadLn(Arq, Posto);
      Posto := SysUtilsEx.AllTrim(Posto);

      i := 1;
      while not Eof(Arq) do
        begin
        ReadLn(Arq, s);
        inc(i); FAtualizarStatus(pChar(s), i);

        k := System.Pos(#32, s);
        if k = 0 then k := System.Pos(#9, s);

        Data  := StrToDate(SysUtilsEx.AllTrim(Copy(s, 1, k-1)));
        Dado  := StrToFloatDef(SysUtilsEx.AllTrim(Copy(s, k+1, 20)), wscMissValue);

        FAppendRecord(PChar(Posto), Data, Dado, 0);
        end;
    finally
      CloseFile(Arq);
      DecimalSeparator := dc;
    end;
  end;

exports
  Nome,
  Filtro,
  Descricao,
  Versao,
  TipoDosDados,
  Set_RotinaDeAdicaoDosDados,
  Set_StatusDaOperacao,
  Importar;

begin
end. 
