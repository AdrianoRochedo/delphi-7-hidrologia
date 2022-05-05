library Excel_Getulio;

{%File 'Importante.txt'}

uses
  SysUtils,
  SysUtilsEx,
  wsConstTypes,
  wsgLib,
  Excel_DLL in '..\..\..\..\Comum\DLLs\Excel_DLL.pas',
  BaseSpreadSheetBook in '..\..\..\..\Comum\SpreadSheet\BaseSpreadSheetBook.pas';

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
    Result := 'Excel - Getúlio';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function Filtro: PChar;
  begin
    Result := 'Arquivos Excel (*.xls)|*.xls';
  end;

  // Retorna uma descrição do formato de importação
  function Descricao: PChar;
  begin
    Result := 'Os arquivos devem estar no padrão Excel 4'#13#10                                         +
              'Formato:'#13#10                                                                          +
              '  - A código do posto vem entre parênteses no nome do arquivo. Ex: xxx(83).xls'#13#10    +
              '  - Linha 1: Identificação das Colunas'#13#10                                            +
              '  - Apartir da Linha 2:'#13#10                                                           +
              '    - Coluna 1: Ano'#13#10                                                               +
              '    - Coluna 2: Mes'#13#10                                                               +
              '    - Coluna 3: Dia'#13#10                                                               +
              '    - Coluna 4: Valor do Dado'#13#10                                                     +
              #13#10                                                                                    +
              'Ex:'#13#10                                                                               +
              '       C1     C2     C3     C4'#13#10                                                    +
              'Lin1   Ano    Mes    Dia    Dado'#13#10                                                  +
              'Lin2   1990   12     1      2.3'#13#10                                                   +
              'Lin3   1990   12     2      1.3'#13#10                                                   +
              '...';
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
  var Posto, sX: String;
      x: Real;
      L: Integer;
      ano, mes, dia: Word;
      Data: TDateTime;
      TabExcel: TBaseSpreadSheetBook;
      Sheet: TBaseSheet;
  begin
    SysUtils.DecimalSeparator := '.';
    TabExcel := Excel_DLL.CreateSpreadSheet();
    try
      TabExcel.LoadFromFile(Arquivo);
      Sheet := TabExcel.ActiveSheet;

      Posto := SysUtilsEx.SubString(Arquivo, '(', ')');
      if Posto = '' then
         begin
         FAtualizarStatus('Identificação do Posto não encontrada', -1);
         Exit;
         end;

      L := 1;
      while true do
        begin
        inc(L);

        ano  := strToIntDef( Sheet.GetDisplayText(L, 1), 0);
        mes  := strToIntDef( Sheet.GetDisplayText(L, 2), 0);
        dia  := strToIntDef( Sheet.GetDisplayText(L, 3), 0);

        // Verifica término da Planilha
        if (ano = 0) and (mes = 0) then Break;

        if TryEncodeDate(ano, mes, dia, Data) then
           begin
           sX := Sheet.GetText(L, 4);
           if sX <> '' then
              begin
              x := strToFloatDef(sX, wscMissValue);
              if wsgLib.IsMissValue(x) then
                 FAtualizarStatus(pChar('Erro de Conversão de Valor: ' + sX), L)
              else
                 FAppendRecord(PChar(Posto), Data, x, 0);
              end;
           end
        else
           FAtualizarStatus(pChar('Data Inválida: ' + Format('%d/%d/%d', [dia, mes, ano])), L);

        end; // while
    finally
      TabExcel.Free();
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
