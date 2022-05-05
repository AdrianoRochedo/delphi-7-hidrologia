library VzoDNAAE;

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

  // Retorna o nome do Padrão de importação
  function Nome: PChar;
  begin
    Result := 'DNAAE - Vazão';
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
    Result := 'Importa os arquivos de Vazão do DNAAE';
  end;

  // Retorna a versão do padrão de importação
  function Versao: PChar;
  begin
    Result := '1.0';
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
  TArray4  =  Array [0..04] of TPosicao;

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
         {Posto, dia, mes, ano, dado}
         Try
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

  // Rotina principal responsável por realizar a importação dos dados
  procedure Importar(Arquivo: PChar);
  Var   Dado_Posto        : LongInt;
        Dado_Ano          : Integer;
        Linha             : TwsCVec;
        Arq               : TextFile;
        Posicao_Campo     : TArray12;
        Posicao_Cabecalho : TArray4;
        dc                : Char;
        sPosto, oldPosto  : String;

  Const Numero_Colunas  = 12;
  begin
    {Posicao do cabecalho}
    Posicao_Cabecalho[0].inicio := 53;     Posicao_Cabecalho[0].Quantidade:=4;{Ano}
    Posicao_Cabecalho[1].inicio := 51;     Posicao_Cabecalho[1].Quantidade:=8;{Codigo}

    {Posicao dos meses}
    Posicao_Campo[0].inicio := 4;     Posicao_Campo[0].Quantidade:=2;{dia do mes}{VR}
    Posicao_Campo[1].inicio := 9;     Posicao_Campo[1].Quantidade:=9;{janeiro}
    Posicao_Campo[2].inicio := 17;    Posicao_Campo[2].Quantidade:=9;{fevereiro}
    Posicao_Campo[3].inicio := 26;    Posicao_Campo[3].Quantidade:=9;{março}
    Posicao_Campo[4].inicio := 35;    Posicao_Campo[4].Quantidade:=9;{abril}
    Posicao_Campo[5].inicio := 44;    Posicao_Campo[5].Quantidade:=9;{maio}
    Posicao_Campo[6].inicio := 53;    Posicao_Campo[6].Quantidade:=9;{junho}
    Posicao_Campo[7].inicio := 62;    Posicao_Campo[7].Quantidade:=9;{julho}
    Posicao_Campo[8].inicio := 71;    Posicao_Campo[8].Quantidade:=9;{agosto}
    Posicao_Campo[9].inicio := 80;    Posicao_Campo[9].Quantidade:=9;{setembro}
    Posicao_Campo[10].inicio:= 89;    Posicao_Campo[10].Quantidade:=9;{outubro}
    Posicao_Campo[11].inicio:= 98;    Posicao_Campo[11].Quantidade:=9;{novembro}
    Posicao_Campo[12].inicio := 107;  Posicao_Campo[12].Quantidade := 9;{dezembro}

    dc := DecimalSeparator;
    DecimalSeparator := ',';

    oldPosto := '';
    AssignFile(Arq, Arquivo);
    try
      Reset(Arq);

            While Not EOF(Arq) Do
              Begin
              {Cabecalho}
              Pula_linha( Arq, 6);
              Linha := TwsCVec.Create;
              If EOF(Arq) then
                begin
                Linha.Free;
                Break; {Problema ultimo caracter sobra duas linhas}
                end;
              Linha.GetUntil (Arq,  #10, CharNo);

              try
                Dado_Ano := StrToInt(Linha.Copy(Posicao_Cabecalho[0].inicio,
                                                Posicao_Cabecalho[0].Quantidade));{Pega o ano}
              finally
                Linha.Free;
              end;

              Pula_linha( Arq, 1);

              Linha := TwsCVec.Create;
              Linha.GetUntil (Arq,  #10, CharNo);

              {Pega o codigo do posto}
              sPosto := Linha.Copy(Posicao_Cabecalho[1].inicio, Posicao_Cabecalho[1].Quantidade);
              if sPosto <> oldPosto then
                 begin
                 //Dado_Posto := RegistraPosto([sPosto, x.FileName]);
                 oldPosto := sPosto;
                 end;

              Linha.Free;

              Pula_linha(Arq, 5);
              {Fim Cabecalho}

              LeBloco (Arq, sPosto, Dado_Ano, Posicao_Campo);  {Le os dados do mes}

              Pula_linha(Arq, 10);
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
