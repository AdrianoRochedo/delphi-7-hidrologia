library VzoCEEE;

uses
  SysUtils,
  SysUtilsEx,
  wsCVec;

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
    Result := 'CEEE - Vazão';
  end;

  // Retorna o filtro dos arquivos que podem serem lidos
  function Filtro: PChar;
  begin
    Result := 'Arquivos Texto (*.txt)|*.txt|' +
              'Arquivos Texto (*.wri)|*.wri'
  end;

  // Retorna uma descrição do formato de importação
  function Descricao: PChar;
  begin
    Result := 'Importa os arquivos de Vazão da CEEE'#13#10 +
              'Formato: - Arquivo Texto de formato fixo.'#13#10 +
              '         - Ponto Decimal: "."'#13#10 +
              '         - É dividido em blocos anuais onde cada bloco possui:'#13#10 +
              '           - Cabeçalho'#13#10 +
              '           - 14 colunas onde a 1. e a 14. são os dias dos meses.'#13#10 +
              #13#10 +
              'Exemplo: '#13#10 +
              #13#10 +
              '1Q'#13#10 +
              '1DATA 24/03/97  ---  COMPANHIA ESTADUAL DE ENERGIA ELETRICA  -  CEEE   -  SUP. DE GERACAO     - D H E E  ---             PAG.    1'#13#10 +
              ''#13#10 +
              ' BACIA DO RIO  CAMISAS                               RS  POSTO  CAMISAS                                    CODIGO  DNAEE  86050000'#13#10 +
              ''#13#10 +
              ' ANO  1946                             * * *   V A Z O E S   D I A R I A S   ( M 3 / S )   * * *           AREA DRE.(KM2)   138.00'#13#10 +
              ''#13#10 +
              ''#13#10 +
              '  DIA     JAN       FEV       MAR       ABR       MAI       JUN       JUL       AGO       SET       OUT       NOV       DEZ    DIA'#13#10 +
              ''#13#10 +
              '  1   ********  ********      4.30      1.35      0.54      0.43      4.30      1.35      2.29      0.54      0.66      0.54     1'#13#10 +
              '  2   ********  ********      6.90      1.35      0.66      1.12      3.35      1.35      1.93      0.54      0.89      0.43     2'#13#10 +
              '  3   ********  ********     12.15      1.12      0.66      0.89      3.00      1.35      1.58      0.43      0.89      0.43     3'#13#10 +
              '  4   ********  ********      9.36      1.12      0.66      0.66      6.31      1.35      1.35      1.46      0.89      0.43     4'#13#10 +
              '  5   ********  ********      7.19      1.00      0.66      0.43      4.30      1.23      1.23      1.35      0.77      0.43     5'#13#10 +
              ''#13#10 +
              '  6   ********  ********      5.72      0.89      0.54      0.43      3.35      1.23      1.12      2.11      0.66      0.39     6'#13#10 +
              '  7   ********  ********      4.77      0.89      0.43      0.39      3.17      1.23      1.12      3.35      0.54      0.39     7'#13#10 +
              '  8   ********  ********      4.30      0.77      0.43      0.39      3.00      1.12      1.00      3.82      0.89      0.39     8'#13#10 +
              '  9   ********  ********      3.82      0.77      0.43      0.34      4.06      1.12      0.89      2.64      1.93      0.34     9'#13#10 +
              ' 10   ********  ********      3.35      0.77      0.43      0.34      3.82      1.00      0.89      1.93      1.93      0.34    10'#13#10 +
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

type
  TPosicao = Record
               Inicio     : Integer;
               Quantidade : Integer;
             end;

  TArray12 =  Array [0..12] of TPosicao;

const
  MissValue = -99999999;

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
      Raise Exception.Create('Arquivo inválido');
    end;
    If (Linha.Len > 1) and (dia <> '') Then
       Begin
       For i := 1 To 12 {Numero_colunas consideradas}  Do
         Begin
         Dado := Linha.Copy(Posicao_Campo[i].inicio, Posicao_Campo[i].Quantidade);
         Dado := SysUtilsEx.Alltrim(Dado);
         if (Dado <> '') and (Dado <> '********') then
            try
              Data := EncodeDate(Dado_Ano, i, iDia);
              FAppendRecord(PChar(Dado_Posto), Data, StrToFloatDef(Dado, MissValue), 0);
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

  // Rotina principal responsável por realizar a importação dos dados
  procedure Importar(Arquivo: PChar);
  Var Dado_Ano          : Integer;
      Linha             : TwsCVec;
      Arq               : TextFile;
      Posicao_Campo     : TArray12;
      Posicao_Cabecalho : Array [0..1]  of TPosicao;
      dc                : Char;
      sPosto, oldPosto  : String;

  const MissValue = -99999999;
  begin
    {Posicao do cabecalho - localizacao dentro do arquivo ceee}
    Posicao_Cabecalho[0].inicio := 123;   Posicao_Cabecalho[0].Quantidade := 8; {Codigo do posto}
    Posicao_Cabecalho[1].inicio := 7;     Posicao_Cabecalho[1].Quantidade := 4;{Ano}

    {Posicao dos meses}
    Posicao_Campo[0].inicio := 2;    Posicao_Campo[0].Quantidade:=2;{dia do mes}{VR}
    Posicao_Campo[1].inicio := 6;    Posicao_Campo[1].Quantidade:=9;{janeiro}
    Posicao_Campo[2].inicio := 16;   Posicao_Campo[2].Quantidade:=9;{fevereiro}
    Posicao_Campo[3].inicio := 26;   Posicao_Campo[3].Quantidade:=9;{março}
    Posicao_Campo[4].inicio := 36;   Posicao_Campo[4].Quantidade:=9;{abril}
    Posicao_Campo[5].inicio := 46;   Posicao_Campo[5].Quantidade:=9;{maio}
    Posicao_Campo[6].inicio := 56;   Posicao_Campo[6].Quantidade:=9;{junho}
    Posicao_Campo[7].inicio := 66;   Posicao_Campo[7].Quantidade:=9;{julho}
    Posicao_Campo[8].inicio := 76;   Posicao_Campo[8].Quantidade:=9;{agosto}
    Posicao_Campo[9].inicio := 86;   Posicao_Campo[9].Quantidade:=9;{setembro}
    Posicao_Campo[10].inicio:= 96;   Posicao_Campo[10].Quantidade:=9;{outubro}
    Posicao_Campo[11].inicio:= 106;  Posicao_Campo[11].Quantidade:=9;{novembro}
    Posicao_Campo[12].inicio:= 116;  Posicao_Campo[12].Quantidade:=9;{dezembro}

    dc := DecimalSeparator;
    DecimalSeparator := '.';

    oldPosto := '';
    AssignFile(Arq, Arquivo);
    try
      Reset(Arq);

            While Not EOF(Arq) Do
              Begin
              if not Pula_Linha_Ate(Arq, '1DATA') then Break {Sai do laço While};

              {Cabecalho}
              Pula_linha(Arq, 1);
              {Quando chegasse no final do arquivo da CEEE existe mais informacoes anuais,
               que nao sao utilizadas e tornasse dificil criar um padrao para este final de
               arquivo, portanto sabendo-se que quando isto acontece o posto retornado é igual
               a ´  ´, utilizou-se este fato para indicar o final de arquivo}

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

              {Lê os dados do Arquivo}
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
  CriarCampoStatus,
  TipoDosDados,
  Set_RotinaDeAdicaoDosDados,
  Set_StatusDaOperacao,
  Importar;

begin
end.
