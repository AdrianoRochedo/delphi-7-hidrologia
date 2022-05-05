library SUDENE_Texto;

uses
  SysUtils,
  Classes,
  SysUtilsEx,
  stDate,
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
    Result := 'SUDENE - Texto';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function Filtro: PChar;
  begin
    Result := 'Arquivos Texto (*.txt)|*.txt';
  end;

  // Retorna uma descri��o do formato de importa��o
  function Descricao: PChar;
  begin
    Result := 'Formato do Arquivo: Texto com 6 colunas com posi��es fixas'#13#10 +
              'Os dados iniciam na 2. linha'#13#10 +
              '  - 1.Coluna: Identifica��o do Posto'#13#10 +
              '  - 2.Coluna: Estado'#13#10 +
              '  - 3.Coluna: Ano'#13#10 +
              '  - 4.Coluna: Mes'#13#10 +
              '  - 5.Coluna: Dia'#13#10 +
              '  - 6.Coluna: Valor (Ponto Decimal: ",")';
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
  var Dia, Mes, Ano: Word;
      i: Integer;
      s, Posto: String;
      Dado: Real;
      dc: Char;
      Arq: Text;
  begin
    dc := DecimalSeparator;
    DecimalSeparator := ',';
    AssignFile(Arq, Arquivo);
    Reset(Arq);
    try
      // Pula o cabe�alho
      ReadLn(Arq, s);

      i := 1;
      while not Eof(Arq) do
        begin
        ReadLn(Arq, s);
        inc(i); FAtualizarStatus(pChar(s), i);

        Posto := Copy(s, 1, 7);
        Ano   := StrToInt(Copy(s, 22, 4));
        Mes   := StrToInt(SysUtilsEx.AllTrim(Copy(s, 30, 2)));
        Dia   := StrToInt(SysUtilsEx.AllTrim(Copy(s, 38, 2)));
        Dado  := StrToFloatDef(SysUtilsEx.AllTrim(Copy(s, 46, 5)), wscMissValue);

        FAppendRecord(PChar(Posto), EncodeDate(Ano, Mes, Dia), Dado, 0);
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
