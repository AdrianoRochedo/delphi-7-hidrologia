library Rochedo_1;

uses
  SysUtils,
  Classes,
  SysUtilsEx,
  stDate,
  Math;
  
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
    Result := 'Rochedo - Padrão';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function Filtro: PChar;
  begin
    Result := 'Arquivos Texto (*.txt)|*.txt';
  end;

  // Retorna uma descrição do formato de importação
  function Descricao: PChar;
  begin
    Result := 'Formato do Arquivo: Texto com 32 colunas'#13#10 +
              '  - Código do Posto: Está no nome do Arquivo. Ex: codigo.txt'#13#10 +
              '  - 1.Coluna: Data no formato Mes/Ano. Está separada do resto por brancos'#13#10 +
              '  - 2.Coluna em diante: Dados separados por TAB - Inicio: 11'#13#10 +
              '  - Ponto Decimal: Vírgula (,)';
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
  var i, ii, k      : Integer;
      Mes, Ano      : Word;
      s, s2, s3, s4 : String;
      Posto         : String;
      Dado          : Real;
      Data          : TDateTime;
      Dados, SL     : TStrings;
      dc            : Char;

  const MissValue = -99999999;
  begin
    Dados := TStringList.Create;
    Dados.LoadFromFile(Arquivo);

    dc := DecimalSeparator;
    DecimalSeparator := ',';

    try
      if Dados.Count > 0 then
         begin
         SL := nil;
         Posto := ChangeFileExt(ExtractFileName(Arquivo), '');

         // Importação dos dados linha por linha
         for i := 0 to Dados.Count-1 do
           begin
           s := Dados[i];
           if AllTrim(s) = '' then Continue;
           FAtualizarStatus(pChar(s), i);

           // Mes/ano
           s2 := copy(s, 1, 7);
           getInfo('/', s3, s4, s2);
           Mes := StrToInt(s3);
           Ano := StrToInt(s4);

           s := copy(s, 11, Length(s));
           if s = '' then Continue;

           // Dados Diários
           StringToStrings(s, SL, [#9]);
           k := Min(SL.Count, DaysInMonth(Mes, Ano, Ano));
           for ii := 0 to k-1 do
             begin
             Dado := StrToFloatDef(SL[ii], MissValue);
             Data := EncodeDate(Ano, Mes, ii+1);
             FAppendRecord(PChar(Posto), Data, Dado, 0);
             end;
           end; // for
         end; // if
    finally
      DecimalSeparator := dc;
      Dados.Free;
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
