library CodeVasf_1;

uses
  SysUtils,
  Classes,
  SysUtilsEx;

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
    Result := 'CODEVASF - Diário com Dados de 15 em 15 minutos';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function Filtro: PChar;
  begin
    Result := 'Arquivos Texto (*.txt)|*.txt';
  end;

  // Retorna uma descrição do formato de importação
  function Descricao: PChar;
  begin
    Result := '';
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
  var i, ii: Integer;
      Posto: String;
      Dado: Real;
      Data: TDateTime;
      Dados: TStrings;
      SL: TStrings;
      dc: Char;
  begin
    Dados := nil;

    SL := TStringList.Create;
    SL.LoadFromFile(Arquivo);

    dc := DecimalSeparator;
    DecimalSeparator := ',';
    try
      for i := 1 to SL.Count-1 do
        begin
        FAtualizarStatus(pChar(SL[i]), i);
        StringToStrings(SL[i], Dados, [';']);

        if Dados.Count <> 99 then Continue;

        Posto := Copy(Dados[0], 2, Length(Dados[0])-2);
        Data  := StrToDate(Dados[1]);

        // Dados Diários de 15 em 15 minutos
        Dado := 0;
        for ii := 3 to 98 do
          Dado := Dado + StrToFloatDef(Dados[ii]);

        FAppendRecord(PChar(Posto), Data, Dado, 0);
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
