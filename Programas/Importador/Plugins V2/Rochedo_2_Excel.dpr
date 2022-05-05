library Rochedo_2_Excel;

uses
  Classes,
  SysUtils,
  SysUtilsEx,
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
    Result := 'Rochedo - Padrão 2 - Excel com Fórmula (96 valores)';
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
              'Formato:'#13#10 +
              '    - 1. Coluna: Código do Posto'#13#10 +
              '    - 2. Coluna: Data'#13#10 +
              '    - 4. Coluna em diante: 96 valores (1 dia com intervalos de 15 minutos)'#13#10 +
              ''#13#10 +
              'Para cada Posto deverá existir um arquivo contendo os coeficiêntes do'#13#10 +
              'polinômio para transformação dos valores. Um em cada linha'#13#10 +
              'O nome do arquivo deverá seguir a seguinte regra: CodigoPosto.txt';
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
  var s, sData, OldPosto, Posto: String;
      Acum, x: Real;
      L, C, NumVals: Integer;
      Data: TDateTime;
      TabExcel: TF1Book;
      TipoFileExcel: SmallInt;
      Coefs: Array[0..2] of Real;
      SL: TStrings;
      LI, LS: Real;
  begin
    TabExcel := TF1Book.Create(nil);
    SL := TStringList.Create;
    try
      TabExcel.Read(String(Arquivo), TipoFileExcel);
      if TipoFileExcel <> F1FileExcel4 then
         Raise Exception.Create('O arquivo do Excel não está no formato (XLS 4)');

      L := 2;
      OldPosto := '';
      Posto := TabExcel.TextRC[L, 1];
      repeat
        sData := TabExcel.EntryRC[L, 2];
        FAtualizarStatus(pChar(Posto + '  ' + sData), L);

        // Lê os coeficientes ...
        if Posto <> OldPosto then
           begin
           OldPosto := Posto;
           s := ExtractFilePath(Arquivo) + Posto + '.txt';
           if FileExists(s) then
              begin
              SL.LoadFromFile(s);
              LI := StrToFloatDef(SL[0], 0);
              LS := StrToFloatDef(SL[1], 0);
              Coefs[0] := StrToFloatDef(SL[2], 0);
              Coefs[1] := StrToFloatDef(SL[3], 0);
              Coefs[2] := StrToFloatDef(SL[4], 0);
              end
           else
              begin
              LI := 0;
              LS := 0;
              Coefs[0] := 0;
              Coefs[1] := 0;
              Coefs[2] := 0;
              end;
           end;

        Data := StrToDate(sData);

        Acum := 0;
        NumVals := 0;
        for C := 4 to 99 do // 96 valores
          begin
          x := TabExcel.NumberRC[L, C];
          if x > -0.5 then
             begin
             Acum := Acum + x;
             inc(NumVals);
             end
          end;

        if NumVals > 0 then
           begin
           x := Acum / NumVals;
           if x > -0.0001 then
              begin
              x := Coefs[0] * sqr(x) + Coefs[1] * x + Coefs[2];
              if x > -0.00001 then
                 FAppendRecord(PChar(Posto), Data, x, 0);
              end;
           end;

        inc(L);
        Posto := TabExcel.TextRC[L, 1];
      until Posto = '';
    finally
      SL.Free;
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
