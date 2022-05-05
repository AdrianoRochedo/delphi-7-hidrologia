library Isareg_Diario;

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
    Result := 'ISAREG - Di�rio';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function Filtro: PChar;
  begin
    Result := 'Arquivos Texto (*.txt)|*.txt|Todos (*.*)|*.*';
  end;

  // Retorna uma descri��o do formato de importa��o
  function Descricao: PChar;
  begin
    Result := 'Formato do Arquivo:'#13#10 +
              'Identifica��o do Posto: Nome do arquivo sem a extens�o'#13#10 +
              'Separador Decimal: . (ponto)'#13#10 +
              '  - As duas primeiras linhas cont�m informa��es sobre o formato dos dados'#13#10 +
              '  - 1. Linha, 1. Valor: Se di�rio - indica o num. de linhas (dias) de um bloco de dados. As colunas s�o os meses)'#13#10 +
              '  - 2. Linha, 1. Valor: Indica o n�mero de blocos (anos)'#13#10 +
              '  - 2. Linha, 2. Valor: Indica o m�s inicial (1. coluna. Ex: Junho)'#13#10 +
              '  - 2. Linha, 3. Valor: Indica o m�s final do pr�prio ano ou ano seguinte'#13#10 +
              '  - 3. Linha, 1. Valor: Indica o ano atual do primeiro m�s indicado'#13#10 +
              '  - 4. Linha em diante: Blocos de dados';
  end;

  // Retorna a vers�o do padr�o de importa��o
  function Versao: PChar;
  begin
    Result := '1.0';
  end;

  // Retorna se deve ou n�o criar um campo de Status
  function CriarCampoStatus: Boolean;
  begin
    Result := False;
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
  var i, j, k: Integer;
      Dia, Mes, Ano: Word;
      Dias: Word;
      s, Posto: String;
      Dado: Real;
      Data: TDateTime;
      Status: byte;
      SL, Dados: TStrings;
      dc: Char;
      Anos : Integer;
      MI   : Integer;
      MF   : Integer;

      MesmoAno: Boolean;
      Sub1    : Byte;

  const MissValue = -99999999;

        procedure LeLinha(L, Dia: Integer);
        var Mes: Integer;
        begin
          FAtualizarStatus(pChar(SL[L]), L);
          StringToStrings(DelSpace1(AllTrim(SL[L])), Dados, [' ']);
          if MesmoAno then
             for Mes := MI to MF do
               if Dia <= DaysInMonth(Mes, Ano-Sub1, Ano-Sub1) then
                  begin
                  Data := EncodeDate(Ano-Sub1, Mes, Dia);
                  Dado := StrToFloat(Dados[Mes-MI]);
                  if Dado < -70 then Dado := MissValue;
                  FAppendRecord(PChar(Posto), Data, Dado, 0);
                  end
               else
          else
             begin
             for Mes := MI to 12 do
               if Dia <= DaysInMonth(Mes, Ano-Sub1, Ano-Sub1) then
                  begin
                  Data := EncodeDate(Ano-Sub1, Mes, Dia);
                  Dado := StrToFloat(Dados[Mes-MI]);
                  if Dado < -70 then Dado := MissValue;
                  FAppendRecord(PChar(Posto), Data, Dado, 0);
                  end;

             for Mes := 1 to MF do
               if Dia <= DaysInMonth(Mes, Ano, Ano) then
                  begin
                  Data := EncodeDate(Ano, Mes, Dia);
                  Dado := StrToFloat(Dados[Mes+MI-2]);
                  if Dado < -70 then Dado := MissValue;
                  FAppendRecord(PChar(Posto), Data, Dado, 0);
                  end;
             end;
        end;

  begin
    Dados := nil;

    SL := TStringList.Create;
    SL.LoadFromFile(Arquivo);

    dc := DecimalSeparator;
    DecimalSeparator := '.';

    try
      Posto := ExtractFileName(ChangeFileExt(Arquivo, ''));
      Dias := StrToInt(AllTrim(SL[0])); // n�mero de intervalos
      StringToStrings(DelSpace1(AllTrim(SL[1])), Dados, [' ']);
      Anos := StrToInt(Dados[0]);
      MI   := StrToInt(Dados[1]);
      MF   := StrToInt(Dados[2]);

      MesmoAno := (MF > MI);
      Sub1 := byte(MI > 6); // ???????

      k := 1;
      for i := 1 to Anos do
          begin
          inc(k);
          FAtualizarStatus(pChar(SL[k]), k);
          Ano := StrToInt(AllTrim(SL[k]));
          for j := 1 to Dias do
            begin
            inc(k);
            LeLinha(k, j);
            end; // for j
          end; // for i
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
