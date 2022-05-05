library SUDENE_2_Excel;

uses
  SysUtils,
  stDate,
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
    Result := 'SUDENE - padrão Excel';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function Filtro: PChar;
  begin
    Result := 'Arquivos Excel 4 (*.xls)|*.xls';
  end;

  // Retorna uma descrição do formato de importação
  function Descricao: PChar;
  begin
    Result := 'Os arquivos devem estar no padrão Excel 4'#13#10 +
              'A identificação do posto deverá estar no inicio do nome do arquivo antes do caracter "_"'#13#10 +
              'Formato:'#13#10 +
              '  - Apartir da Linha 2:'#13#10 +
              '    - Coluna 1 e 2: Data'#13#10 +
              '    - Coluna 3 em diante: 31 valores (1 para cada dia do mes)'#13#10 +
              ''#13#10 +
              'Ex:'#13#10 +
              '       Col1        Col2         Col3        ...       Col33'#13#10 +
              'Lin1   Posto ID'#13#10 +
              'Lin2   Data        Data         1                     31'#13#10 +
              'Lin3   01/01/2000  01/01/2000   2,3                   1,1'#13#10 +
              'Lin4   02/01/2000  02/01/2000   1,3                   0  '#13#10 +
              '...'#13#10;
  end;

  // Retorna a versão do padrão de importação
  function Versao: PChar;
  begin
    Result := '2.0';
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
  var Posto: String;
      D, M, A: Word;
      x: Real;
      L, C: Integer;
      sD, sX: String;
      Data: TDateTime;
      TabExcel: TF1Book;
      TipoFileExcel: SmallInt;
  begin
    TabExcel := TF1Book.Create(nil);
    try
      TabExcel.Read(Arquivo, TipoFileExcel);
      if TipoFileExcel <> F1FileExcel4 then
         Raise Exception.Create('O arquivo do Excel não está no formato (XLS 4)');

      //Posto := TabExcel.TextRC[1, 1];
      L := Pos('_', ExtractFileName(Arquivo));
      Posto := Copy(ExtractFileName(Arquivo), 1, L-1);

      L := 1;
      repeat
        inc(L);
        sD := TabExcel.EntryRC[L, 1];
        if sD <> '' then
           begin
           Data := StrToDate(sD);
           DecodeDate(Data, A, M, D);
           for C := 1 to DaysInMonth(M, A, A) do
             begin
             sX := TabExcel.TextRC[L, C + 2];
             if sX <> '' then
                begin
                x := StrToFloat(sX);
                FAppendRecord(PChar(Posto), Data + C - 1, x, 0);
                end
             end
           end;
      until sD = '';
    finally
      TabExcel.Free;
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
