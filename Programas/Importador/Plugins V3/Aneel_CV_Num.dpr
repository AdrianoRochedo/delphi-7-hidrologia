library Aneel_CV_Num;

uses
  SysUtils,
  Classes,
  SysUtilsEx,
  DateUtils,
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
    Result := 'ANEEL - Chuva/Vazão Numérico';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function Filtro: PChar;
  begin
    Result := 'Arquivos de Chuva (*.PLU)|*.PLU|Arquivos de Vazão (*.DSC)|*.DSC';
  end;

  // Retorna uma descrição do formato de importação
  function Descricao: PChar;
  begin
    Result := 'Formato do Arquivo: Texto onde todos os caracteres são numéricos e "."'#13#10 +
              'Separador Decimal: ponto (.)'#13#10 +
              'Cada dado possui no máximo uma casa decimal e é formado por 6 caracteres'#13#10 +
              'Os dados iniciam na 2.coluna'#13#10 +
              '  - Primeiros oito caracteres: Identificação do Posto'#13#10 +
              '  - 10. carac. ao 14.: Ano'#13#10 +
              '  - 16. e 17. carac.: Mes'#13#10 +
              '  - A partir do 48. carac.: Dados'#13#10 +
              'Ex:'#13#10 +
              ' 028510071962451100031.200090.400000071105000010000.00005.60000.00000.00031.20002.00000.00000.00000.00000.00000.00000.00000.00000.00000.00000.00000.00020.00002.00016.60013.00000.00000.00000.00000.00000.00000.00000.00000.00000.07777.0'#13#10 +
              ' 028510071962451200041.000049.400000031203000010000.00000.00041.00006.70000.00000.00000.00000.00000.00000.00000.00000.00000.00000.00000.00000.00000.00000.00000.00000.00000.00000.00000.00000.00000.00001.70000.00000.00000.00000.00000.0'#13#10 +
              ' 028510071963450100051.000276.100000140130000010000.00000.00000.00013.20000.00000.00028.40002.40007.60022.60000.00000.00007.80005.00002.00000.00000.00000.00000.00000.00037.00000.00000.00000.00044.00001.90000.00000.00023.20051.00030.0'#13#10 +
              ' 028510071963450200063.000164.900000100228000010033.00005.60000.00000.00007.00000.00000.00000.00000.00000.00000.00000.00000.00000.00000.00000.00000.00000.00004.20031.00000.00000.00000.00007.20003.00003.70007.20063.07777.07777.07777.0'#13#10;
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
    Result := 0; // Diário
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
  var
      i, ii: Integer;
      Dia, Mes, Ano: Word;
      Dias: Word;
      s, s2: String;
      Posto: PChar;
      Dado: Real;
      Data: TDateTime;
      dc: Char;
      SL: TStrings;
  begin
    SL := TStringList.Create;
    SL.LoadFromFile(Arquivo);

    dc := DecimalSeparator;
    DecimalSeparator := '.';

    try
      for i := 0 to SL.Count-1 do
        begin
        s := SL[i];
        FAtualizarStatus(pChar(s), i);

        // Informações básicas
        Posto := PChar(Copy(s, 2, 8));
        Ano   := StrToInt(Copy(s, 10, 4));
        Mes   := StrToInt(Copy(s, 16, 2));
        Dias  := DateUtils.DaysInAMonth(Ano, Mes);

        // Coleta dos dados
        ii := 48; // Inicio dos dados
        Dia := 1;
        while Dia <= Dias do
          begin
          Data := EncodeDate(Ano, Mes, Dia);
          s2   := Copy(s, ii, 6);

          if System.Pos('7777', s2) > 0 then
             Dado := wscMissValue
          else
             Dado := StrToFloat(s2);

          FAppendRecord(Posto, Data, Dado, 0);

          inc(ii, 6);
          inc(Dia);
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
