library ChuvaCEEE;

uses
  SysUtils,
  SysUtilsEx,
  wsCVec,
  wsGLib,
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

  // Retorna o nome do Padr�o de importa��o
  function Nome: PChar;
  begin
    Result := 'CEEE - Chuva';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function Filtro: PChar;
  begin
    Result := 'Arquivos Texto (*.txt)|*.txt|' +
              'Arquivos Texto (*.wri)|*.wri'
  end;

  // Retorna uma descri��o do formato de importa��o
  function Descricao: PChar;
  begin
    Result := 'Importa os arquivos de Chuvas da CEEE'#13#10 +
              'Formato: - Arquivo Texto de formato fixo.'#13#10 +
              '         - Ponto Decimal: "."'#13#10 +
              '         - � dividido em blocos anuais onde cada bloco possui:'#13#10 +
              '           - Cabe�alho'#13#10 +
              '           - 14 colunas onde a 1. e a 14. s�o os dias dos meses.'#13#10 +
              #13#10 +
              'Exemplo: '#13#10 +
              #13#10 +
              '1P'#13#10 +
              '1DATA 03/02/97  ---  COMPANHIA ESTADUAL DE ENERGIA ELETRICA  -  CEEE   -  SUP. DE GERACAO   -  D H E E   --- PAG.    1'#13#10 +
              ''#13#10 +
              ' MUNICIPIO                                          RS    POSTO CAPELA SAO JOSE DOS AUSENTES                COD. DNAEE 02850002'#13#10 +
              ''#13#10 +
              ' ANO 1961                               --  PRECIPITACOES DIARIAS (MILIMETROS)  --                           ANO 1961'#13#10 +
              ''#13#10 +
              ''#13#10 +
              ' DIA     JAN      FEV      MAR      ABR      MAI      JUN      JUL      AGO      SET      OUT      NOV      DEZ   DIA'#13#10 +
              ''#13#10 +
              '   1     0.0      7.6      0.0      0.0      0.0      0.0      0.0      0.0      0.0      0.0     20.4      0.0     1'#13#10 +
              '   2     0.0      0.0      0.0      0.0      0.0      0.0      0.0      0.0      0.0      0.0     13.0      0.0     2'#13#10 +
              '   3     0.0     22.2      0.0      0.0      0.0      0.0      0.0      0.0      0.0      0.0      9.9      0.0     3'#13#10 +
              '   4     0.0      0.0      0.0      0.0      0.0      0.0      0.0      0.0      6.0      0.0     18.0     11.0     4'#13#10 +
              '   5     0.0     25.6      0.0      0.0      0.0     35.6      0.0      0.0     14.0     25.0     11.6      0.0     5'#13#10 +
              '...';
  end;

  // Retorna a vers�o do padr�o de importa��o
  function Versao: PChar;
  begin
    Result := '1.0';
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

type
  TPosicao = Record
               Inicio     : Integer;
               Quantidade : Integer;
             end;

  TArray12 =  Array [0..12] of TPosicao;

{Pula o numero de linha indicado pela variavel linhas do arquivo determinado
 pela variavel do tipo TextFile Arquivo}
procedure  Pula_linha( Var Arquivo: TextFile; Linhas :integer);
var i: integer;
Begin
  For i := 1 to Linhas Do Readln(Arquivo);    {ativo}
End;

function  Pula_Linha_Ate( Var Arquivo: TextFile; Const S: String): Boolean;
var Linha: String;
Begin
  Repeat
    Readln(Arquivo, Linha);
    Result := (System.Pos(S, Linha) > 0);
  Until Result or EOF(Arquivo);
End;

procedure LeBloco (Var Arquivo: TextFile;
                   const Dado_Posto: String;
                   const Dado_Ano: Integer;
                   const Posicao_Campo: TArray12);
Const
  CharNo  : TCharSet = [#10, #13];

Var
  Dado    : String;
  Dia     : String;
  iDia    : Integer;
  Linha   : TwsCVec;
  Data    : TDateTime;
  i       : Word;
Begin
  Repeat
    Linha := TwsCVec.Create;
    Linha.GetUntil (Arquivo,  #10, CharNo);
    Dia  := Linha.Copy(Posicao_Campo[0].inicio, Posicao_Campo[0].Quantidade);
    Dia  := SysUtilsEx.Alltrim(Dia);
    Try
      if Dia <> '' then iDia := StrToInt(dia);
    Except
      Raise Exception.Create('Arquivo inv�lido');
    end;
    If (Linha.Len > 1) and (dia <> '') Then
       Begin
       For i := 1 To 12 {Numero_colunas consideradas}  Do
         Begin
         Dado := Linha.Copy(Posicao_Campo[i].inicio, Posicao_Campo[i].Quantidade);
         Dado := SysUtilsEx.Alltrim(Dado);
         if Dado <> '' then
            try
              Data := EncodeDate(Dado_Ano, i, iDia);
              FAppendRecord(PChar(Dado_Posto), Data, StrToFloatDef(Dado, wscMissValue), 0);
            except
              {Nada}
            end;
         End; { For i }
       End; { If Linha.Len > 1 and dia <> ''}
    Linha.Free;
  Until Dia = '31'; {Repeat }
End;

Const CharSetEndField : TCharSet = [' '];
      CharNo          : TCharSet = [#10, #13];

  // Rotina principal respons�vel por realizar a importa��o dos dados
  procedure Importar(Arquivo: PChar);
  Var Dado_Ano          : Integer;
      Dado_Posto        : LongInt;
      Linha             : TwsCVec;
      Arq               : TextFile;
      Posicao_Campo     : TArray12;
      Posicao_Cabecalho : Array [0..1]  of TPosicao;
      dc                : Char;
      sPosto, oldPosto  : String;

  begin
    {Posicao do cabecalho - localizacao dentro do arquivo ceee}
    Posicao_Cabecalho[0].inicio := 120;   Posicao_Cabecalho[0].Quantidade := 8; {Codigo do posto}
    Posicao_Cabecalho[1].inicio := 6;     Posicao_Cabecalho[1].Quantidade := 4;{Ano}

    {Posicao dos meses}
    Posicao_Campo[0].inicio  := 3;    Posicao_Campo[0].Quantidade  := 2;  {dia do mes}{VR}
    Posicao_Campo[1].inicio  := 6;    Posicao_Campo[1].Quantidade  := 9;  {janeiro}
    Posicao_Campo[2].inicio  := 14;   Posicao_Campo[2].Quantidade  := 9;  {fevereiro}
    Posicao_Campo[3].inicio  := 23;   Posicao_Campo[3].Quantidade  := 9;  {mar�o}
    Posicao_Campo[4].inicio  := 32;   Posicao_Campo[4].Quantidade  := 9;  {abril}
    Posicao_Campo[5].inicio  := 41;   Posicao_Campo[5].Quantidade  := 9;  {maio}
    Posicao_Campo[6].inicio  := 50;   Posicao_Campo[6].Quantidade  := 9;  {junho}
    Posicao_Campo[7].inicio  := 59;   Posicao_Campo[7].Quantidade  := 9;  {julho}
    Posicao_Campo[8].inicio  := 68;   Posicao_Campo[8].Quantidade  := 9;  {agosto}
    Posicao_Campo[9].inicio  := 77;   Posicao_Campo[9].Quantidade  := 9;  {setembro}
    Posicao_Campo[10].inicio := 86;   Posicao_Campo[10].Quantidade := 9; {outubro}
    Posicao_Campo[11].inicio := 95;   Posicao_Campo[11].Quantidade := 9; {novembro}
    Posicao_Campo[12].inicio := 104;  Posicao_Campo[12].Quantidade := 9; {dezembro}

    dc := DecimalSeparator;
    DecimalSeparator := '.';

    oldPosto := '';
    AssignFile(Arq, Arquivo);
    try
      Reset(Arq);

            While Not EOF(Arq) Do
              Begin
              if not Pula_Linha_Ate(Arq, '1DATA') then Break {Sai do la�o While};

              {Cabecalho}
              Pula_linha(Arq, 1);
              {Quando chegasse no final do arquivo da CEEE existe mais informacoes anuais,
               que nao sao utilizadas e tornasse dificil criar um padrao para este final de
               arquivo, portanto sabendo-se que quando isto acontece o posto retornado � igual
               a �  �, utilizou-se este fato para indicar o final de arquivo}

              Linha := TwsCVec.Create;
              Linha.GetUntil (Arq,  #10, CharNo);

              {Pega o codigo do posto}
              sPosto := Linha.Copy(Posicao_Cabecalho[0].inicio, Posicao_Cabecalho[0].Quantidade);
              if sPosto <> oldPosto then
                 oldPosto := sPosto;

              If sPosto = '' then
                 begin
                 Linha.Free;
                 Break; {Problema ultimo caracter sobra duas linhas}
                 end;

              Linha.Free;

              Pula_linha(Arq, 1);
              Linha := TwsCVec.Create;
              Linha.GetUntil (Arq,  #10, CharNo);

              {Pega o ano}
              Try
                Dado_Ano := StrToInt(Linha.Copy(Posicao_Cabecalho[1].inicio,
                                                Posicao_Cabecalho[1].Quantidade));
              Finally
                Linha.Free;
              end;

              {Fim Cabecalho}
              Pula_linha( Arq, 4);

              {L� os dados do Arquivo}
              LeBloco (Arq, sPosto, Dado_Ano, Posicao_Campo);
              End; { While Not EOF }
    finally
      DecimalSeparator := dc;
      Close(Arq);
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
