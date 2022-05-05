library Elmo;

uses
  SysUtils,
  stDate,
  Dialogs,
  wsConstTypes,
  vcf1;

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
    Result := 'ELMO';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function Filtro: PChar;
  begin
    Result := 'Arquivos Excel 4 (*.xls)|*.xls';
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
    Result := 0;
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
  var TabExcel: TF1Book;

    function AchaInicioDosDados(var L: Integer): Boolean;
    var i: Integer;
    begin
      i := 0;
      repeat
        inc(i); // Tenta do máximo 100 vezes
        inc(L);
        Result := (TabExcel.TextRC[L, 1] = 'Dias');
      until Result or (i = 100);
    end;

    function ObtemMes(s: String): Word;
    const Meses : array[1..12] of String =
          ('janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho', 'julho', 'agosto',
           'setembro', 'outubro', 'novembro', 'dezembro');
    begin
      s := LowerCase(s);
      for Result := 1 to 12 do
        if s = Meses[Result] then Exit;
      Result := 0;
    end;

  var Posto: String;
      x: Real;
      L, i: Integer;
      Data: TDateTime;
      TipoFileExcel: SmallInt;
      ColPosto, Ano, Mes: Word;
      dc: Char;
  begin
    dc := SysUtils.DecimalSeparator;
    SysUtils.DecimalSeparator := ',';

    TabExcel := TF1Book.Create(nil);
    try
      TabExcel.Read(Arquivo, TipoFileExcel);
      if TipoFileExcel <> F1FileExcel4 then
         Raise Exception.Create('O arquivo do Excel não está no formato (XLS 4)');

      ColPosto := StrToInt(InputBox('Entrada de Dados', 'Entre a coluna onde estão os dados:', '2'));
      Posto := TabExcel.TextRC[3, ColPosto];

      L := 1;
      while AchaInicioDosDados(L) do
        begin
        Ano := StrToInt(TabExcel.TextRC[L-2, 4]);
        Mes := ObtemMes(TabExcel.TextRC[L-2, 3]);
        if Mes = 0 then
           Exception.Create('Erro: Mês inválido: ' + TabExcel.TextRC[L-2, 3] + #10#13 +
                            'Linha: ' + IntToStr(L-2));

        for i := 1 to DaysInMonth(Mes, Ano, Ano) do
          begin
          inc(L);
          x := StrToFloatDef(TabExcel.TextRC[L, ColPosto], wsConstTypes.wscMissValue);
          Data := EncodeDate(Ano, Mes, i);
          FAppendRecord(PChar(Posto), Data, x, 0);
          end;
        end;
    finally
      TabExcel.Free;
      SysUtils.DecimalSeparator := dc;
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
