library HidroWeb;

uses
  SysUtils,
  Classes,
  SysUtilsEx,
  stDate;

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
    Result := 'HidroWEB';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function Filtro: PChar;
  begin
    Result := 'Arquivos Texto (*.txt)|*.txt';
  end;

  // Retorna uma descri��o do formato de importa��o
  function Descricao: PChar;
  begin
    Result := 'Os arquivos seguem o padr�o de exporta��o feitos pelo site HidroWEB'#13#10 +
              'Formato do Arquivo: Texto com 65 colunas separadas por ";"'#13#10 +
              '  - 1.Coluna: Identifica��o do Posto'#13#10 +
              '  - 2.Coluna: Ano'#13#10 +
              '  - 3.Coluna: Mes'#13#10 +
              '  - 4. 5. ... 34.Coluna: Valores (Um para cada dias do mes)'#13#10 +
              '  - 35. 36. ... 65.Coluna: Status do Dado (Um para cada dias do mes)';
  end;

  // Retorna a vers�o do padr�o de importa��o
  function Versao: PChar;
  begin
    Result := '1.1';
  end;

  // Retorna se deve ou n�o criar um campo de Status
  function CriarCampoStatus: Boolean;
  begin
    Result := True;
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
  var i, ii, k: Integer;
      Dia, Mes, Ano: Word;
      Dias: Word;
      s, Posto: String;
      Dado: Real;
      Data: TDateTime;
      Status: byte;
      Dados: TStrings;
      SL: TStrings;
      dc: Char;
  const MissValue = -99999999;
  begin
    Dados := nil;

    SL := TStringList.Create;
    SL.LoadFromFile(Arquivo);

    dc := DecimalSeparator;
    DecimalSeparator := '.';

    // Procura a linha inicial dos dados
    ii := SL.Count;
    for i := 0 to SL.Count-1 do
      if System.Pos('C�digo;Ano', SL[i]) > 0 then
         begin
         ii := i + 1;
         break;
         end;

    try
      for i := ii to SL.Count-1 do
        begin
        FAtualizarStatus(pChar(SL[i]), i);
        StringToStrings(SL[i], Dados, [';']);

        if Dados.Count <> 65 then Continue;

        // Informa��es b�sicas
        Posto := Dados[0];
        Ano   := StrToInt(Dados[1]);
        Mes   := StrToInt(Dados[2]);

        Dias  := DaysInMonth(Mes, Ano, Ano);

        // Dados Di�rios + Status
        for ii := 3 to 33 do
          begin
          Dia := ii - 2;
          if Dia <= Dias then
             begin
             k := ii + 31;
             s := Dados[ii];
             if (s = '-') or (s = '') then Dado := MissValue else Dado := StrToFloat(s);
             Status := StrToInt(Dados[k]);
             Data := EncodeDate(Ano, Mes, Dia);
             FAppendRecord(PChar(Posto), Data, Dado, Status);
             end;
          end;
        end;
    finally
      DecimalSeparator := dc;
      SL.Free;
    end;
  end;

exports
  Nome,
  Filtro,
  Descricao,
  Versao,
  CriarCampoStatus,
  TipoDosDados,
  Set_RotinaDeAdicaoDosDados,
  Set_StatusDaOperacao,
  Importar;

begin
end.
