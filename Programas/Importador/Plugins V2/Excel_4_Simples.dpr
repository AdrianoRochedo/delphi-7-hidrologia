library Excel_4_Simples;

uses
  SysUtils,
  stDate,
  //Dialogs,
  //DialogsEx,
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

  // Retorna o nome do Padr�o de importa��o
  function Nome: PChar;
  begin
    Result := 'Excel 4 - Simples';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function Filtro: PChar;
  begin
    Result := 'Arquivos Excel 4 (*.xls)|*.xls';
  end;

  // Retorna uma descri��o do formato de importa��o
  function Descricao: PChar;
  begin
    Result := 'Os arquivos devem estar no padr�o Excel 4'#13#10 +
              'Formato:'#13#10 +
              '  - Linha 1, Coluna 1: Identifica��o do Posto'#13#10 +
              '  - Apartir da Linha 2:'#13#10 +
              '    - Coluna 1: Data (dd/mm/aaaa)'#13#10 +
              '    - Coluna 2: Valor do Dado'#13#10 +
              ''#13#10 +
              'Ex:'#13#10 +
              '       Col1        Col2'#13#10 +
              'Lin1   Posto ID'#13#10 +
              'Lin2   01/01/2000  2,3'#13#10 +
              'Lin3   02/01/2000  1,3'#13#10 +
              '...';
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
    Result := 0;
      //MessageDlg2('Qual o Tipo dos Dados ?', mtConfirmation, ['&Diario', '&Mensal'], [0, 0], 0) - 1;
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
  var Posto: String;
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
         Raise Exception.Create('O arquivo do Excel n�o est� no formato (XLS 4)');

      Posto := TabExcel.TextRC[1, 1];
      L := 1;
      repeat
        inc(L);
        sD := TabExcel.EntryRC[L, 1];
        if sD <> '' then
           begin
           Data := StrToDate(sD);
           sX := TabExcel.TextRC[L, 2];
           if sX <> '' then
              begin
              x := StrToFloat(sX);
              FAppendRecord(PChar(Posto), Data, x, 0);
              end;
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
  CriarCampoStatus,
  TipoDosDados,
  Set_RotinaDeAdicaoDosDados,
  Set_StatusDaOperacao,
  Importar;

begin
end.
