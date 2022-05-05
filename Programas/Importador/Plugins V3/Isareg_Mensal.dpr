library Isareg_Mensal;

uses
  SysUtils,
  Classes,
  SysUtilsEx,
  stDate,
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

  // Retorna o nome do Padrão de importação
  function Nome: PChar;
  begin
    Result := 'ISAREG - Mensal';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function Filtro: PChar;
  begin
    Result := 'Arquivos Texto (*.txt)|*.txt|Todos (*.*)|*.*';
  end;

  // Retorna uma descrição do formato de importação
  function Descricao: PChar;
  begin
    Result := 'Formato do Arquivo:'#13#10 +
              'Identificação do Posto: Nome do arquivo sem a extensão'#13#10 +
              'Separador Decimal: . (ponto)'#13#10 +
              '  - As duas primeiras linhas contém informações sobre o formato dos dados'#13#10 +
              '  - 1. Linha, 1. Valor: Se diário - indica o num. de linhas (dias) de um bloco de dados. As colunas são os meses)'#13#10 +
              '  - 2. Linha, 1. Valor: Indica o número de blocos (anos)'#13#10 +
              '  - 2. Linha, 2. Valor: Indica o mês inicial (1. coluna. Ex: Junho)'#13#10 +
              '  - 2. Linha, 3. Valor: Indica o mês final do próprio ano ou ano seguinte'#13#10 +
              '  - 3. Linha, 1. Valor: Indica o ano atual do primeiro mês indicado'#13#10 +
              '  - 4. Linha em diante: Blocos de dados';
  end;

  // Retorna a versão do padrão de importação
  function Versao: PChar;
  begin
    Result := '1.0';
  end;

  // Retorna se deve ou não criar um campo de Status
  function CriarCampoStatus: Boolean;
  begin
    Result := False;
  end;

  // Retorna o tipo dos dados que estão sendo importados: 0 = Diario  1 = Mensal
  function TipoDosDados: Byte;
  begin
    Result := 1; // Mensal
  end;

  // Recebe o endereço de Callback da rotina que irá adicionar os dados no BD
  procedure Set_RotinaDeAdicaoDosDados(Rotina: TProc_AppendRecord);
  begin
    FAppendRecord := Rotina;
  end;

  // Recebe o endereço de Callback da rotina que irá atualizar as mensagens de status
  procedure Set_StatusDaOperacao(Rotina: TProc_AtualizarStatus);
  begin
    FAtualizarStatus := Rotina;
  end;

  // Rotina principal responsável por realizar a importação dos dados
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

        procedure LeLinha(L: Integer);
        var Mes: Integer;
        begin
          FAtualizarStatus(pChar(SL[L]), L);
          StringToStrings(DelSpace1(AllTrim(SL[L])), Dados, [' ']);
          if MesmoAno then
             for Mes := MI to MF do
               begin
               Data := EncodeDate(Ano, Mes, 01);
               Dado := StrToFloat(Dados[Mes-MI]);
               if Dado < -70 then Dado := wscMissValue;
               FAppendRecord(PChar(Posto), Data, Dado, 0);
               end
          else
             begin
             for Mes := MI to 12 do
               begin
               Data := EncodeDate(Ano, Mes, 01);
               Dado := StrToFloat(Dados[Mes-MI]);
               if Dado < -70 then Dado := wscMissValue;
               FAppendRecord(PChar(Posto), Data, Dado, 0);
               end;

             for Mes := 1 to MF do
               begin
               Data := EncodeDate(Ano+1, Mes, 01);
               Dado := StrToFloat(Dados[Mes+MI-2]);
               if Dado < -70 then Dado := wscMissValue;
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
      Dias := StrToInt(AllTrim(SL[0])); // número de intervalos
      StringToStrings(DelSpace1(AllTrim(SL[1])), Dados, [' ']);
      Anos := StrToInt(Dados[0]);
      MI   := StrToInt(Dados[1]);
      MF   := StrToInt(Dados[2]);

      MesmoAno := (MF > MI);

      k := 1;
      for i := 1 to Anos do
          begin
          inc(k);
          FAtualizarStatus(pChar(SL[k]), k);
          Ano := StrToInt(AllTrim(SL[k]));
          inc(k);
          LeLinha(k);
          end; // for i
(*
      for i := ii to SL.Count-1 do
        begin
        FAtualizarStatus(pChar(SL[i]), i);
        StringToStrings(SL[i], Dados, [';']);

        if Dados.Count <> 65 then Continue;

        // Informações básicas
        Posto := Dados[0];
        Ano   := StrToInt(Dados[1]);
        Mes   := StrToInt(Dados[2]);

        Dias  := DaysInMonth(Mes, Ano, Ano);

        // Dados Diários + Status
        for ii := 3 to 33 do
          begin
          Dia := ii - 2;
          if Dia <= Dias then
             begin
             k := ii + 31;
             s := Dados[ii];
             if (s = '-') or (s = '') then Dado := wscMissValue else Dado := StrToFloat(s);
             Status := StrToInt(Dados[k]);
             Data := EncodeDate(Ano, Mes, Dia);
             FAppendRecord(PChar(Posto), Data, Dado, Status);
             end;
          end;
        end;
*)
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
