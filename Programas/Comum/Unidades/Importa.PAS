unit Importa;

interface
uses Classes, wsMatrix, wsVec, wsCVec, SysUtilsEx, wsGlib,
     {wsFuncoesDeVetores, }DBTables, StdCtrls,
     CH_Const, OvcBase, OvcViewr;

Const CharSetEndField : TCharSet = [' '];
      CharNo          : TCharSet = [#10, #13];

procedure ImptChz_DNAAE (Arquivos: TStrings;
                         Const NomeArq: String;
                         Carac_Fim_Reg,
                         Carac_Fim_Campo: Char;
                         var x: TGlobalDataRec);

procedure ImptChzCEEE (Arquivos: TStrings;
                       Const NomeArq: String;
                       Carac_Fim_Reg,
                       Carac_Fim_Campo: Char;
                       var x: TGlobalDataRec);

procedure ImptVzo_DNAAE (Arquivos: TStrings;
                         Const NomeArq: String;
                         Carac_Fim_Reg,
                         Carac_Fim_Campo: Char;
                         var x: TGlobalDataRec);

procedure ImptVzoCEEE (Arquivos: TStrings;
                       Const NomeArq: String;
                       Carac_Fim_Reg,
                       Carac_Fim_Campo: Char;
                       var x: TGlobalDataRec);

procedure ImptA_DNAAE (Arquivos: TStrings;
                       Const NomeArq: String;
                       Carac_Fim_Reg,
                       Carac_Fim_Campo: Char;
                       var x: TGlobalDataRec);

procedure ImptArquivoPadraoExcel(Arquivos: TStrings;
                            Const NomeArq: String;
                            var x: TGlobalDataRec);

procedure ImptArquivoAlagoas(Arquivos: TStrings;
                             Const NomeArq: String;
                             var x: TGlobalDataRec);

procedure ImptConverterParaMensal(Arquivos: TStrings;
                                  Const NomeArq: String;
                                  var x: TGlobalDataRec);

procedure ImptHidroWeb(Arquivos: TStrings;
                       Const NomeArq: String;
                       var x: TGlobalDataRec);

procedure ImptCodeVasp_15minutos(Arquivos: TStrings;
                                 Const NomeArq: String;
                                 var x: TGlobalDataRec);

procedure Impt_X(Arquivos: TStrings;
                 Const NomeArq: String;
                 var x: TGlobalDataRec);

procedure ImptConverterPara_NPeriodo(Arquivos: TStrings;
                                     Const NomeArq: String;
                                     var x: TGlobalDataRec;
                                     TamOrig, TamDest, CodPosto: Integer;
                                     DataInicial: TDateTime);

implementation
uses DB, SysUtils, Forms, Controls, wsOutPut, Comum_1, Dialogs, GaugeFo, ch_Func, ErrosDLG,
     AxCtrls, OleCtrls, FileCtrl,
     vcf1 {Planilha},
     WinUtils,
     stDate;

procedure MostraErro(const s1, s2: String);
begin
{$ifdef CHUVAZ}
  gError.Add(etError, 'Erro na tentativa de importar o arquivo ' +
                      s1 + #13 + 'Erro: ' + s2);
  gError.Show;
{$endif}
end;

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
                   Dado_Posto: LongInt;
                   Dado_Ano: Integer;
                   X: TQuery;
                   Posicao_Campo: TArray12 );
Const
  CharNo            : TCharSet = [#10, #13];

Var
  Dado              : String;
  Dia               : String;
  iDia              : Integer;
  Linha             : TCVec;
  Data              : TDateTime;
  i                 : Word;
Begin
  Repeat
  Linha := TCVec.Create;
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
         X.AppendRecord([Dado_Posto, Data, ValMiss(dado)]);  {Cuidar}
       except
         {Nada}
         end;
       End; { For i }
     End; { If Linha.Len > 1 and dia <> ''}
  Linha.Free;
  Application.ProcessMessages;
  Until Dia = '31'; {Repeat }
END;

{Abre a tabela passada ordenado-a por posto e data}
procedure ReAbreQuery ( Var x: TQuery; FileName : String );
begin
  x.Close;
  x.SQL.Clear;
  x.SQL.Add(Format(cSQL_Order_no999, [FileName]));
  x.Open;
end;

Function CriaTabela(Const Nome: String; CriaIndex: Boolean = False;
                    CriaCampoStatus: Boolean = False): Boolean;
Var Table1 : TTable;
begin
  Result := False;
  Table1 := TTable.Create(nil);
  try
    with Table1 do
      begin
      Active    := False;
      TableName := Nome;
      TableType := ttParadox;
      with FieldDefs do
        begin
        Clear;
        Add('Posto',  ftString, 10, false);
        Add('Data' ,  ftDate ,   0, false);
        Add('Dado' ,  ftFloat,   0, false);

        if CriaCampoStatus then
           Add('Status' ,  ftSmallInt, 0, false);
        end;

      If CriaIndex Then
         with IndexDefs do
           begin
           Clear;
           Add('', 'Posto;Data', [ixPrimary, ixUnique]);
           end;

      CreateTable;
      Result := FileExists(Nome);
      end;
  finally
    Table1.Free;
  end;
end;

{Importa um arquivo do DNAAE e retorna uma tabela no formato Codigo Posto, Dia, Mes, Ano,
 Observação os caracteres de fim de registro e fim de campo
 sao respectivamente #10 #32}
Procedure ImptChz_DNAAE(Arquivos: TStrings; Const NomeArq: String; Carac_Fim_Reg,
                        Carac_Fim_Campo: Char; var x: TGlobalDataRec);

Const Numero_Colunas    = 12;

Var   Dado_Posto        : LongInt;
      Dado_Ano          : Integer;
      Linha             : TCVec;
      Arquivo           : TextFile;
      Posicao_Campo     : TArray12;
      Posicao_Cabecalho : TArray4;
      i                 : Integer;
      ts, ds            : Char;
      sPosto, oldPosto  : String;
      Pr                : TDLG_Progress;
Begin
    {Posicao do cabecalho}
    Posicao_Cabecalho[0].inicio := 64;     Posicao_Cabecalho[0].Quantidade := 4;{Ano}
    Posicao_Cabecalho[1].inicio := 51;     Posicao_Cabecalho[1].Quantidade := 8;{Codigo}

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


    ts := ThousandSeparator;
    ds := DecimalSeparator;
    ThousandSeparator := '.'; {O arquivo do DNAEE utiliza a ',' como separador decimal}
    DecimalSeparator  := ',';

    x.FileName := ChangeFileExt(NomeArq, '.db');
    CriaTabela(x.FileName);
    x.Tab := TQuery.Create(Nil);
    x.Tab.RequestLive := True;
    x.Tab.SQL.Add(Format(cSQL_RequestLive, [x.FileName]));
    x.Tab.Open;

    Screen.Cursor := crHourGlass;
    Pr := CreateProgress(-2, -2, Arquivos.Count, '');
    Try
      for i := 0 to Arquivos.Count - 1 do
        begin
        Pr.Value := i + 1;
        Pr.Msg   := 'Importando arquivo: ' + Arquivos[i];
        AssignFile(Arquivo, Arquivos[i]);
        oldPosto := '';

        Try
          Reset(Arquivo);

          Try
            While Not EOF(Arquivo) Do
              Begin
              {Cabecalho}
              Pula_linha( Arquivo, 6);
              Linha := TCVec.Create;
              If EOF(Arquivo) then
                 begin
                 Linha.Free;
                 Break; {Problema ultimo caracter sobra duas linhas}
                 end;

              Linha.GetUntil (Arquivo,  #10, CharNo);
              try
                Dado_Ano := StrToInt(Linha.Copy(Posicao_Cabecalho[0].inicio, Posicao_Cabecalho[0].Quantidade));{Pega o ano}
              finally
                Linha.Free;
              end;

              Pula_linha( Arquivo, 1);
              Linha := TCVec.Create;
              Linha.GetUntil (Arquivo,  #10, CharNo);

              {Pega o codigo do posto}
              sPosto := Linha.Copy( Posicao_Cabecalho[1].inicio,Posicao_Cabecalho[1].Quantidade);
              if sPosto <> oldPosto then
                 begin
                 Dado_Posto := RegistraPosto([sPosto, x.FileName]);
                 oldPosto := sPosto;
                 end;
              Linha.Free;

              {Fim Cabecalho}
              Pula_linha( Arquivo, 5);

              {Lê os dados do Arquivo}
              LeBloco (Arquivo, Dado_Posto, Dado_Ano, x.Tab, Posicao_Campo);

              Pula_linha(Arquivo, 9);
              End; { While Not EOF }

          Except
            On E: Exception do MostraErro(Arquivos[i], E.Message);
          End;

        Finally
          CloseFile(Arquivo);
          End;
        End; {For i}

    ReAbreQuery ( x.Tab, x.FileName);
    Finally
      pr.Free;
      ThousandSeparator := ts;
      DecimalSeparator  := ds;
      If x.Tab.RecordCount = 0 Then
         begin
         x.Tab.Free;
         x.Tab := nil;
         end;
      Screen.Cursor := crDefault;
      End
  End; { Function ImptChz_DNAAE}

{ATENCAO ESTE ARQUIVO USA O SEPARADOR '.' PARA CASAS DECIMAIS}
{Importa um arquivo no formato da CEEE e retorna um data set
 Observação os caracteres de fim de registro e fim de campo
 sao respectivamente #10 #32}
Procedure ImptChzCEEE(Arquivos: TStrings; Const NomeArq: String; Carac_Fim_Reg,
                        Carac_Fim_Campo: Char; var x: TGlobalDataRec);

Const Numero_Colunas = 12;


Type   TPosicao = Record
                      Inicio     : Integer;
                      Quantidade : Integer;
                    end;

Var
      i                 : Integer;
      Dado_Ano          : Integer;
      Dado_Posto        : LongInt;
      Linha             : TCVec;
      Arquivo           : TextFile;
      Posicao_Campo     : TArray12;
      Posicao_Cabecalho : Array [0..1]  of TPosicao;
      ts, ds            : Char;
      sPosto, oldPosto  : String;
      Pr                : TDLG_Progress;

  Begin
    {Posicao do cabecalho - localizacao dentro do arquivo ceee}
    Posicao_Cabecalho[0].inicio := 120;   Posicao_Cabecalho[0].Quantidade:=8; {Codigo do posto}
    Posicao_Cabecalho[1].inicio := 6;     Posicao_Cabecalho[1].Quantidade:=4; {Ano}

    {Posicao dos meses}
    Posicao_Campo[0].inicio := 3;    Posicao_Campo[0].Quantidade:=2;{dia do mes}{VR}
    Posicao_Campo[1].inicio := 5;    Posicao_Campo[1].Quantidade:=8;{janeiro}
    Posicao_Campo[2].inicio := 14;   Posicao_Campo[2].Quantidade:=8;{fevereiro}
    Posicao_Campo[3].inicio := 23;   Posicao_Campo[3].Quantidade:=8;{março}
    Posicao_Campo[4].inicio := 32;   Posicao_Campo[4].Quantidade:=8;{abril}
    Posicao_Campo[5].inicio := 41;   Posicao_Campo[5].Quantidade:=8;{maio}
    Posicao_Campo[6].inicio := 50;   Posicao_Campo[6].Quantidade:=8;{junho}
    Posicao_Campo[7].inicio := 59;   Posicao_Campo[7].Quantidade:=8;{julho}
    Posicao_Campo[8].inicio := 68;   Posicao_Campo[8].Quantidade:=8;{agosto}
    Posicao_Campo[9].inicio := 77;   Posicao_Campo[9].Quantidade:=8;{setembro}
    Posicao_Campo[10].inicio:= 86;   Posicao_Campo[10].Quantidade:=8;{outubro}
    Posicao_Campo[11].inicio:= 95;   Posicao_Campo[11].Quantidade:=8;{novembro}
    Posicao_Campo[12].inicio:= 104;  Posicao_Campo[12].Quantidade:=8;{dezembro}

    ts := ThousandSeparator;
    ds := DecimalSeparator;
    ThousandSeparator := ',' ;   {O arquivo do CEEE utiliza o '.' como separador decimal}
    DecimalSeparator  := '.';

    x.FileName := ChangeFileExt(NomeArq,'.db');
    CriaTabela(x.FileName);
    x.Tab := TQuery.Create(Nil);
    x.Tab.RequestLive := True;
    x.Tab.SQL.Add(Format(cSQL_RequestLive, [x.FileName]));
    x.Tab.Open;

    Screen.Cursor := crHourGlass;
    Pr := CreateProgress(-2, -2, Arquivos.Count, '');
    Try
      for i := 0 to Arquivos.Count - 1 do
        begin
        Pr.Value := i + 1;
        Pr.Msg   := 'Importando arquivo: ' + Arquivos[i];
        AssignFile(Arquivo, Arquivos[i]);
        oldPosto := '';

        Try
          Reset(Arquivo);

          Try
            While Not EOF(Arquivo) Do
              Begin
              {Cabecalho}
              Pula_linha( Arquivo, 3);
              {Quando chegasse no final do arquivo da CEEE existe mais informacoes anuais,
               que nao sao utilizadas e tornasse dificil criar um padrao para este final de
               arquivo, portanto sabendo-se que quando isto acontece o posto retornado é igual
               a '  ', utilizou-se este fato para indicar o final de arquivo}

              Linha := TCVec.Create;
              Linha.GetUntil (Arquivo,  #10, CharNo);

              {Pega o codigo do posto}
              sPosto := Linha.Copy(Posicao_Cabecalho[0].inicio, Posicao_Cabecalho[0].Quantidade);
              if sPosto <> oldPosto then
                 begin
                 Dado_Posto := RegistraPosto([sPosto, x.FileName]);
                 oldPosto := sPosto;
                 end;

              If Dado_Posto < 0 then
                 begin
                 Linha.Free;
                 Break; {Problema ultimo caracter sobra duas linhas}
                 end;

              Linha.Free;
              Pula_linha( Arquivo, 1);
              Linha := TCVec.Create;
              Linha.GetUntil (Arquivo,  #10, CharNo);
              {Pega o ano}
              Try
                Dado_Ano := StrToInt(Linha.Copy(Posicao_Cabecalho[1].inicio, Posicao_Cabecalho[1].Quantidade));
              Finally
                Linha.Free;
              end;

              Pula_linha( Arquivo, 4);
              {Fim Cabecalho}

              LeBloco (Arquivo, Dado_Posto, Dado_Ano, x.Tab, Posicao_Campo);  {Le os dados do mes}

              Pula_linha(Arquivo,11);
              End; { While not EOF}

          Except
            On E: Exception do MostraErro(Arquivos[i], E.Message);
          End;

        Finally
          CloseFile(Arquivo);
          End;
        End; {For i}

    ReAbreQuery ( x.Tab, x.FileName);
    Finally
      pr.Free;
      If x.Tab.RecordCount = 0 Then
         begin
         x.Tab.Free;
         x.Tab := nil;
         end;
      Screen.Cursor := crDefault;
      ThousandSeparator := ts;
      DecimalSeparator  := ds;
      End
  End; { ImptChzCEEE }

{PROCEDIMENTOS PARA IMPORTACAO DE VAZOES -----------------------------------------------}

{Importa um arquivo do DNAAE e retorna uma tabela no formato Codigo Posto, Dia, Mes, Ano,
 Observação os caracteres de fim de registro e fim de campo
 sao respectivamente #10 #32}
Procedure ImptVzo_DNAAE(Arquivos: TStrings; Const NomeArq: String; Carac_Fim_Reg,
                        Carac_Fim_Campo: Char; var x: TGlobalDataRec);

Const Numero_Colunas  = 12;

Var
      i                 : Integer;
      Dado_Posto        : LongInt;
      Dado_Ano          : Integer;
      Linha             : TCVec;
      Arquivo           : TextFile;
      Posicao_Campo     : TArray12;
      Posicao_Cabecalho : TArray4;
      ts, ds            : Char;
      sPosto, oldPosto  : String;
      Pr                : TDLG_Progress;

Begin
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

    ts := ThousandSeparator;
    ds := DecimalSeparator;
    ThousandSeparator := '.' ;   {O arquivo do DNAEE utiliza a ',' como separador decimal}
    DecimalSeparator  := ',';

    x.FileName := ChangeFileExt(NomeArq, '.db');
    CriaTabela(x.FileName);
    x.Tab := TQuery.Create(Nil);
    x.Tab.RequestLive := True;
    x.Tab.SQL.Add(Format(cSQL_RequestLive, [x.FileName]));
    x.Tab.Open;

    Screen.Cursor := crHourGlass;
    Pr := CreateProgress(-2, -2, Arquivos.Count, '');
    Try
      for i := 0 to Arquivos.Count - 1 do
        begin
        Pr.Value := i + 1;
        Pr.Msg   := 'Importando arquivo: ' + Arquivos[i];
        AssignFile(Arquivo, Arquivos[i]);
        oldPosto := '';

        Try
          Reset(Arquivo);

          Try
            While Not EOF(Arquivo) Do
              Begin
              {Cabecalho}
              Pula_linha( Arquivo, 6);
              Linha := TCVec.Create;
              If EOF(Arquivo) then
                begin
                Linha.Free;
                Break; {Problema ultimo caracter sobra duas linhas}
                end;
              Linha.GetUntil (Arquivo,  #10, CharNo);

              try
                Dado_Ano := StrToInt(Linha.Copy(Posicao_Cabecalho[0].inicio, Posicao_Cabecalho[0].Quantidade));{Pega o ano}
              finally
                Linha.Free;
              end;

              Pula_linha( Arquivo, 1);

              Linha := TCVec.Create;
              Linha.GetUntil (Arquivo,  #10, CharNo);

              {Pega o codigo do posto}
              sPosto := Linha.Copy(Posicao_Cabecalho[1].inicio, Posicao_Cabecalho[1].Quantidade);
              if sPosto <> oldPosto then
                 begin
                 Dado_Posto := RegistraPosto([sPosto, x.FileName]);
                 oldPosto := sPosto;
                 end;

              Linha.Free;

              Pula_linha( Arquivo, 5);
              {Fim Cabecalho}

              LeBloco (Arquivo, Dado_Posto, Dado_Ano, x.Tab, Posicao_Campo);  {Le os dados do mes}

              Pula_linha(Arquivo, 10);
              End; { While Not EOF }

          Except
            On E: Exception do MostraErro(Arquivos[i], E.Message);
          End;

        Finally
          CloseFile(Arquivo);
          End;
        End; {For i}

    ReAbreQuery ( x.Tab, x.FileName);
    Finally
      pr.Free;
      If x.Tab.RecordCount = 0 Then
         begin
         x.Tab.Free;
         x.Tab := nil;
         end;
      Screen.Cursor := crDefault;
      ThousandSeparator := ts;
      DecimalSeparator  := ds;
      End
  End; { Function ImptVzo_DNAAE}

{Importa um arquivo no formato padrao do DNAEE (Tanto Chuva, como Vazao)e retorna um data set
 Observação os caracteres de fim de registro e fim de campo
 sao respectivamente #10 #32.
 Obs.: Os arquivos no formato padrao do DNAEE sao compostos de 6 caracteres sendo um deste carac
 teres o ponto decimas, hora eles aparecem com duas casas decimais hora com apenas uma}
Procedure ImptA_DNAAE(Arquivos: TStrings; Const NomeArq: String; Carac_Fim_Reg,
                        Carac_Fim_Campo: Char; var x: TGlobalDataRec);

Const Numero_Colunas             = 11;

Type   TPosicao = Record
                    Inicio     : Integer;
                    Quantidade : Integer;
                  end;

Var
      Cont_Dia,
      Incremento,
      i               : Integer;
      Dado,
      dado_dia        : String;
      Posto           : Longint;
      Mes,
      Ano             : Integer;
      Data            : TDateTime;
      Linha           : TCVec;
      Arquivo         : TextFile;
      Posicao_Campo   : Array [1..4] of TPosicao;
      ts, ds          : Char;
      sPosto, oldPosto: String;
      Pr              : TDLG_Progress;

  Begin
    Posicao_Campo[1].inicio := 2;    Posicao_Campo[1].Quantidade:=8;{codigo do posto}
    Posicao_Campo[2].inicio := 10;   Posicao_Campo[2].Quantidade:=4;{ano}
    Posicao_Campo[3].inicio := 16;   Posicao_Campo[3].Quantidade:=2;{mes}
    Posicao_Campo[4].inicio := 48;   Posicao_Campo[4].Quantidade:=248;{Vazao de cada dia do mes}


    ts := ThousandSeparator;
    ds := DecimalSeparator;
    ThousandSeparator := ',' ;   {O arquivo do DNAEE utiliza a ',' como separador decimal}
    DecimalSeparator  := '.';

    x.FileName := ChangeFileExt(NomeArq, '.db');
    CriaTabela(x.FileName);
    x.Tab := TQuery.Create(Nil);
    x.Tab.RequestLive := True;
    x.Tab.SQL.Add(Format(cSQL_RequestLive, [x.FileName]));
    x.Tab.Open;

    Screen.Cursor := crHourGlass;
    Pr := CreateProgress(-2, -2, Arquivos.Count, '');
    Try
      for i := 0 to Arquivos.Count - 1 do
        begin
        Pr.Value := i + 1;
        Pr.Msg   := 'Importando arquivo: ' + Arquivos[i];
        AssignFile(Arquivo, Arquivos[i]);
        oldPosto := '';

        Try
          Reset(Arquivo);

          Try
            While Not EOF(Arquivo) Do
              Begin
              Linha := TCVec.Create;

              Try
                Application.ProcessMessages;
                Linha.GetUntil (Arquivo,  #13, CharNo);
                If Linha.Len > 1 Then
                   Begin
                   incremento  := 1;

                   sPosto := Linha.Copy(Posicao_Campo[1].inicio, Posicao_Campo[1].Quantidade);
                   if sPosto <> oldPosto then
                      begin
                      Posto := RegistraPosto([sPosto, x.FileName]);
                      oldPosto := sPosto;
                      end;

                   Ano  := StrToInt(Linha.Copy(Posicao_Campo[2].inicio, Posicao_Campo[2].Quantidade));
                   Mes  := StrToInt(Linha.Copy(Posicao_Campo[3].inicio, Posicao_Campo[3].Quantidade));
                   Dado := Linha.Copy(Posicao_Campo[4].inicio, Posicao_Campo[4].Quantidade);
                   For Cont_Dia := 1 to 31 do {quebra coluna}
                     begin
                     dado_dia := Copy(Dado, incremento, 6);
                     if (dado_dia = '007777') or (dado_dia ='7777.0') then dado_dia := 'ValorNaoValido';
                     Inc(incremento, 6);
                     Try
                       Data := EncodeDate(Ano,Mes,Cont_dia);
                       x.Tab.AppendRecord([Posto, Data, ValMiss(dado_dia)]);  {Cuidar}
                     except
                       {Nada}
                       end;
                     end;
                   End; { If Linha.Len > 1 }
              Finally
                Linha.Free;
                End;
              End; { While Not EOF }

          Except
            On E: Exception do MostraErro(Arquivos[i], E.Message);
          End;

        Finally
          CloseFile(Arquivo);
          End;
        End; {For i}

    ReAbreQuery ( x.Tab, x.FileName);
    Finally
      pr.Free;
      If x.Tab.RecordCount = 0 Then
         begin
         x.Tab.Free;
         x.Tab := nil;
         end;
      Screen.Cursor := crDefault;
      ThousandSeparator := ts;
      DecimalSeparator  := ds;
      End
  End; { ImptA_DNAAE }

Procedure ImptVzoCEEE(Arquivos: TStrings; Const NomeArq: String; Carac_Fim_Reg,
                        Carac_Fim_Campo: Char; var x: TGlobalDataRec);
{ATENCAO ESTE ARQUIVO USA O SEPARADOR '.' PARA CASAS DECIMAIS}
{Importa um arquivo no formato da CEEE e retorna um data set
 Observação os caracteres de fim de registro e fim de campo
 sao respectivamente #10 #32}


Const Numero_Colunas             = 12;


Type   TPosicao = Record
                      Inicio     : Integer;
                      Quantidade : Integer;
                    end;

Var
      i                 : Integer;
      Dado_Ano          : Integer;
      Dado_Posto        : LongInt;
      Linha             : TCVec;
      Arquivo           : TextFile;
      Posicao_Campo     : TArray12;
      Posicao_Cabecalho : Array [0..1]  of TPosicao;
      ts, ds            : Char;
      sPosto, oldPosto  : String;
      Pr                : TDLG_Progress;

  Begin
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
    Posicao_Campo[11].inicio:= 106;   Posicao_Campo[11].Quantidade:=9;{novembro}
    Posicao_Campo[12].inicio:= 116;  Posicao_Campo[12].Quantidade:=9;{dezembro}

    ts := ThousandSeparator;
    ds := DecimalSeparator;
    ThousandSeparator := ',' ;   {O arquivo do CEEE utiliza o '.' como separador decimal}
    DecimalSeparator  := '.';

    x.FileName := ChangeFileExt(NomeArq,'.db');
    CriaTabela(x.FileName);
    x.Tab := TQuery.Create(Nil);
    x.Tab.RequestLive := True;
    x.Tab.SQL.Add(Format(cSQL_RequestLive, [x.FileName]));
    x.Tab.Open;

    Screen.Cursor := crHourGlass;
    Pr := CreateProgress(-2, -2, Arquivos.Count, '');
    Try
      for i := 0 to Arquivos.Count - 1 do
        begin
        Pr.Value := i + 1;
        Pr.Msg   := 'Importando arquivo: ' + Arquivos[i];
        AssignFile(Arquivo, Arquivos[i]);
        oldPosto := '';

        Try
          Reset(Arquivo);

          Try
            While Not EOF(Arquivo) Do
              Begin
              if not Pula_Linha_Ate(Arquivo, '1DATA') then Break {Sai do laço While};

              {Cabecalho}
              Pula_linha( Arquivo, 1);
              {Quando chegasse no final do arquivo da CEEE existe mais informacoes anuais,
               que nao sao utilizadas e tornasse dificil criar um padrao para este final de
               arquivo, portanto sabendo-se que quando isto acontece o posto retornado é igual
               a ´  ´, utilizou-se este fato para indicar o final de arquivo}

              Linha := TCVec.Create;
              Linha.GetUntil (Arquivo,  #10, CharNo);

              {Pega o codigo do posto}
              sPosto := Linha.Copy(Posicao_Cabecalho[0].inicio, Posicao_Cabecalho[0].Quantidade);
              if sPosto <> oldPosto then
                 begin
                 Dado_Posto := RegistraPosto([sPosto, x.FileName]);
                 oldPosto := sPosto;
                 end;

              If Dado_Posto < 0 then
                 begin
                 Linha.Free;
                 Break; {Problema ultimo caracter sobra duas linhas}
                 end;

              Linha.Free;

              Pula_linha( Arquivo, 1);
              Linha := TCVec.Create;
              Linha.GetUntil (Arquivo,  #10, CharNo);

              {Pega o ano}
              Try
                Dado_Ano := StrToInt(Linha.Copy(Posicao_Cabecalho[1].inicio, Posicao_Cabecalho[1].Quantidade));
              Finally
                Linha.Free;
              end;

              {Fim Cabecalho}
              Pula_linha( Arquivo, 4);

              {Lê os dados do Arquivo}
              LeBloco (Arquivo, Dado_Posto, Dado_Ano, x.Tab, Posicao_Campo);
              End; { While Not EOF }

          Except
            On E: Exception do MostraErro(Arquivos[i], E.Message);
          End;

        Finally
          CloseFile(Arquivo);
          End;
        End; {For i}

    ReAbreQuery ( x.Tab, x.FileName);
    Finally
      pr.Free;
      If x.Tab.RecordCount = 0 Then
         begin
         x.Tab.Free;
         x.Tab := nil;
         end;
      Screen.Cursor := crDefault;
      ThousandSeparator := ts;
      DecimalSeparator  := ds;
     End
  End; { ImptVzoCEEE }

{-------------------- // ----------------------- // ----------------------}

procedure ImptArquivoPadraoExcel(Arquivos: TStrings;
                            Const NomeArq: String;
                            var x: TGlobalDataRec);

Var   C                 : TComum;
      Data              : TDateTime;
      Valor             : Double;
      Arquivo           : TOvcTextFileViewer;
      i                 : Integer;
      Header            : TRecStandartFile;
      Tab               : TTable;
      ts, ds            : Char;
      TabExcel          : TF1Book;
      TipoFileExcel     : SmallInt;
{
      Procedure OpenTextFile(Const Nome: String);
      Begin
        Arquivo.FileName := Nome;
        Arquivo.IsOpen := True;
      End;
}
      Function LeCabecalho(const Tipo: String = ''): Integer;
      var s: String;
      begin
        Result := -1;
        If (Arquivo.LineCount > 5) or (Tipo = 'Excel') Then
           begin
           if Tipo = 'Excel' then
              s := AllTrim(TabExcel.TextRC[1, 1], [#9, #10, #13, #32])
           else
              s := AllTrim(Arquivo.Lines[0], [#9, #10, #13, #32]);

           If CompareText(s, 'CHUVAZ') = 0 Then
              begin
              if Tipo = 'Excel' then
                 Header.Titulo := AllTrim(TabExcel.TextRC[2, 1], [#9, #10, #13, #32])
              else
                 Header.Titulo := AllTrim(Arquivo.Lines[1], [#9, #10, #13, #32]);

              if Tipo = 'Excel' then
                 s := AllTrim(TabExcel.TextRC[3, 1], [#9, #10, #13, #32])
              else
                 s := AllTrim(Arquivo.Lines[2], [#9, #10, #13, #32]);

              Header.Natureza := byte( (CompareText(s, 'VAZÃO') = 0) or
                                       (CompareText(s, 'VAZAO') = 0) or
                                       (s = '1') );

              if Tipo = 'Excel' then
                 s := AllTrim(TabExcel.TextRC[4, 1], [#9, #10, #13, #32])
              else
                 s := AllTrim(Arquivo.Lines[3], [#9, #10, #13, #32]);

              Header.Tipo := TIntervalo( (CompareText(s, 'MENSAL') = 0) or (s = '1') );
              Result := 1;
{
              if Tipo = 'Excel' then
                 s := AllTrim(TabExcel.TextRC[5, 1], [#9, #10, #13, #32])
              else
                 s := AllTrim(Arquivo.Lines[4], [#9, #10, #13, #32]);

              If (CompareText(s, 'COLUNASIMPLES') = 0) or (s = '0') Then Header.Formato := cCOLUNASIMPLES else
              If (CompareText(s, 'TABELA') = 0) or (s = '1') Then Header.Formato := cTABELA
              else
                 Header.Formato := cCOLUNAPOSTO;

              Result := Header.Formato;

              if Header.Formato = cCOLUNASIMPLES Then
                 begin
                 if Tipo = 'Excel' then
                    s := AllTrim(TabExcel.TextRC[6, 1], [#9, #10, #13, #32])
                 else
                    s := AllTrim(Arquivo.Lines[5], [#9, #10, #13, #32]);

                 if s <> '' then
                    Header.Posto := RegistraPosto([s, x.FileName])
                 else
                    Raise Exception.Create('Erro: Identificação do Posto Faltando');
                 end;
}
              end;
           end;

        if Result = -1 Then
           Raise Exception.Create(cMSG10);
      end;
(*
      procedure LeituraColunaSimples; //-------------------------------------------------
      var i, ii: Integer;
          s, s1: String;
          pr   : TDLG_Progress;
          PD   : char;
      begin
        If DecimalSeparator = '.' then PD := ',' else PD := '.';
        gOutPut.Editor.Show;
        Pr := CreateProgress(-2, -2, Arquivo.LineCount - 7, 'Importando arquivo ' + x.FileName);
        Try
          For i := 6 to Arquivo.LineCount - 2 Do
            Begin
            Pr.Value := i;
            s := AllTrim(Arquivo.Lines[i], [#9, #10, #13, #32]);
            ii := Pos(#9, s); // Tenta encontrar o caracter TAB
            If ii = 0 Then ii := Pos(#32, s); // Se não conseguir tenta encontrar um espaço

            s1 := Copy(s, 1, ii-1);
            Try
              Data  := strToDate(s1);
            Except
              gError.Add(etError, Format('Erro: Data Inválida < %s >', [s1]));
              gError.Show;
              Continue;
            End;

            s := AllTrim(Copy(s, ii+1, Length(s)-ii), [#32, #9]);
            s := ChangeChar(s, PD, DecimalSeparator);
            Try
              valor := StrToFloat(s);
            Except
              valor := MissValue;
              gError.Add(etError,
                     'Importação do arquivo padrão.'#13 +
                     'Erro: O valor < ' + s + ' > não é um valor válido');
              gError.Show;
            End;

            If Not Tab.FindKey([Header.Posto, Data]) Then
               Tab.AppendRecord([Header.Posto, Data, Valor])
            Else
               begin
               gError.Add(etError, 'Erro: Dados Repetidos na importação'#13 +
                                   'Posto = ' + intToStr(Header.Posto) + #13 +
                                   'Data = ' + DateToStr(Data) );
               gError.Show;
               end;
            End; // For i
        Finally
          pr.Free;
          end;
      end;

      procedure LeituraTabela;
      var i: Integer;
      begin
        ShowMessage('Leitura tipo Tabela ainda não implementada !');
        EXIT;
        For i := 6 to Arquivo.LineCount - 1 Do
          Begin
          //...
          //x.Tab.AppendRecord([Posto, Data, ValMiss(...)]);
          End; { While Not EOF }
      end;

      procedure LeituraColunaPosto;
      var i: Integer;
      begin
        ShowMessage('Leitura tipo Coluna Posto ainda não implementada !');
        EXIT;
        For i := 6 to Arquivo.LineCount - 1 Do
          Begin
          //...
          //x.Tab.AppendRecord([Posto, Data, ValMiss(...)]);
          End; { While Not EOF }
      end;

      procedure LeituraExcelColunaSimples;
      var i: Integer;
          s, s1: String;
      begin
        StartWait;
        Try
          i := 7;
          s1 := SysUtilsEx.allTrim(TabExcel.TextRC[i, 1]);
          while (s1 <> '') and (i < 100000) do
            Begin

            Try
              Data  := strToDate(s1);
            Except
              gError.Add(etError, Format('Erro: Data Inválida < %s >', [s1]));
              gError.Show;
              inc(i); s1 := SysUtilsEx.allTrim(TabExcel.TextRC[i, 1]);
              Continue;
            End;

            Valor := TabExcel.NumberRC[i, 2];

            If Not Tab.FindKey([Header.Posto, Data]) Then
               Tab.AppendRecord([Header.Posto, Data, Valor])
            Else
               begin
               gError.Add(etError, 'Erro: Dados Repetidos na importação'#13 +
                                   'Posto = ' + intToStr(Header.Posto) + #13 +
                                   'Data = ' + DateToStr(Data) );
               gError.Show;
               end;

            inc(i); s1 := SysUtilsEx.allTrim(TabExcel.TextRC[i, 1]);
            End; // while
        Finally
          StopWait;
          end;
      end; // LeituraExcelColunaSimples
*)
      procedure LeituraExcel;
      var i, j, Posto : Integer;
          s, s1, s2   : String;
      begin
        StartWait;
        Try
          j := 2;
          s2 := SysUtilsEx.allTrim(TabExcel.TextRC[5, j]);
          while (s2 <> '') and (j < 100) do
            begin
            Posto := RegistraPosto([s2]);

            i := 6;
            s1 := SysUtilsEx.allTrim(TabExcel.TextRC[i, 1]);
            while (s1 <> '') and (i < 100000) do
              Begin

              Try
                Data  := strToDate({'01/' + }s1);
              Except
                {$ifdef CHUVAZ}
                gError.Add(etError, Format('Erro: Data Inválida < %s >', [s1]));
                gError.Show;
                {$endif}
                inc(i); s1 := SysUtilsEx.allTrim(TabExcel.TextRC[i, 1]);
                Continue;
              End;

              Valor := TabExcel.NumberRC[i, j];

              If Not Tab.FindKey([Posto, Data]) Then
                 Tab.AppendRecord([Posto, Data, Valor])
              Else
                 begin
                 {$ifdef CHUVAZ}
                 gError.Add(etError, 'Erro: Dados Repetidos na importação'#13 +
                                     'Posto = ' + intToStr(Posto) + #13 +
                                     'Data = ' + DateToStr(Data) );
                 gError.Show;
                 {$endif}
                 end;

              inc(i);
              s1 := SysUtilsEx.allTrim(TabExcel.TextRC[i, 1]);
              end; // while linhas

            inc(j);
            s2 := SysUtilsEx.allTrim(TabExcel.TextRC[5, j]);
            end; // while colunas

            if Header.Tipo = tiMensal then x.Meses := i - 6;
        finally
          StopWait;
          end;
      end; // LeituraExcelColunaPosto

begin
  ts := ThousandSeparator;
  ds := DecimalSeparator;
  ThousandSeparator := '.' ;
  DecimalSeparator  := ',';

  x.FileName := NomeArq;

  CriaTabela(x.FileName, True {Indexada});
  Tab := TTable.Create(nil);
  Tab.TableName := x.FileName;
  Tab.Open;

  C := TComum.Create(nil);
  Arquivo := C.Arquivo;

  TabExcel := TF1Book.Create(nil);

  Screen.Cursor := crHourGlass;
  Try
    for i := 0 to Arquivos.Count - 1 do
      Try
        if ExtractFileExt(Arquivos[i]) = '.xls' then
           begin
           TabExcel.Read(Arquivos[i], TipoFileExcel);
           if TipoFileExcel <> F1FileExcel4 then
              Raise Exception.Create('O arquivo do Excel não está no formato (XLS 4)');

           LeCabecalho('Excel');
           LeituraExcel;
           //LeituraExcelColunaPosto;
           end
{
        else
           begin // leitura de arquivos textos
           OpenTextFile(Arquivos[i]);
           case LeCabecalho Of
             0: LeituraColunaSimples;
             1: LeituraTabela;
             2: LeituraColunaPosto;
             end;
           end;
}
      Except
        On E: Exception do MostraErro(Arquivos[i], E.Message);
      End;

      // Fica com o tipo do último arquivo lido << CUIDADO >>
      x.Tipo := Header.Tipo;
  Finally
    ThousandSeparator := ts;
    DecimalSeparator  := ds;
    TabExcel.Free;
    C.Release;
    Tab.Close;
    Tab.Free;
    DeleteFile(ChangeFileExt(x.FileName, '.PX'));

    x.Tab := TQuery.Create(Nil);
    x.Tab.RequestLive := True;
    x.Tab.SQL.Add(Format(cSQL_RequestLive, [x.FileName]));
    x.Tab.Open;
    If x.Tab.RecordCount = 0 Then
       begin
       x.Tab.Free;
       x.Tab := nil;
       end;

    Screen.Cursor := crDefault;
    End
end;

procedure ImptArquivoAlagoas(Arquivos: TStrings;
                             Const NomeArq: String;
                             var x: TGlobalDataRec);
Var  Data    : TDateTime;
     Valor   : Double;
     SL      : TStrings;
     i       : Integer;
     Tab     : TTable;
     ts, ds  : Char;
     Posto   : Integer;

const MSG_1   = 'Arquivo inválido';

      // Posições iniciais das colunas (meses)
      PosicaoDiario : Array[1..12] of byte = (8, 17, 26, 35, 44, 53, 62, 71, 80, 89, 98, 107);
      PosicaoMensal : Array[1..12] of byte = (6, 15, 24, 33, 42, 51, 60, 69, 78, 87, 96, 105);

     function ImportaDados: Integer;

         procedure LeDadosDoBloco(var LinhaInicial: Integer);
         var Ano, Mes, Dia: Integer;
             s: String;
             r: Real;
         begin
           Ano := StrToInt(Copy(SL[LinhaInicial - 3], 48, 4));

           for Mes := 1 to 12 do
             for Dia := 1 to DaysInMonth(Mes, Ano, 0) do
               begin
               s := SysUtilsEx.AllTrim(Copy(SL[LinhaInicial + Dia - 1], PosicaoDiario[Mes], 8));

               if (s <> '') then
                  r := StrToFloatDef(s, wsgLIB.MissValue)
               else
                  r := wsgLIB.MissValue;

               Tab.AppendRecord([Posto, EncodeDate(Ano, Mes, Dia), r])
               end;

           inc(LinhaInicial, 31);
         end;

         procedure ProximoBloco(var LinhaInicial: Integer);
         var i: Integer;
         begin
           for i := LinhaInicial to SL.Count-1 do
              if Copy(SL[i], 1, 3) = 'DIA' then
                 begin
                 LinhaInicial := i + 1;
                 Exit;
                 end;

           LinhaInicial := -1;
         end;

         procedure LeDadosAnuais(LinhaInicial: Integer);
         var Ano, Mes: Integer;
             r: Real;
             s: String;
         begin
           Ano := StrToIntDef(Copy(SL[LinhaInicial], 1, 4), 0);

           while Ano > 0 do
             begin

             for Mes := 1 to 12 do
               begin
               s := SysUtilsEx.AllTrim(Copy(SL[LinhaInicial], PosicaoMensal[Mes], 8));

               if (s <> '') then
                  r := StrToFloatDef(s, wsgLIB.MissValue)
               else
                  r := wsgLIB.MissValue;

               Tab.AppendRecord([Posto, EncodeDate(Ano, Mes, 01), r]);
               inc(x.Meses);
               end;

             inc(LinhaInicial);
             Ano := StrToIntDef(Copy(SL[LinhaInicial], 1, 4), 0);
             end;
         end;

     var i: Integer;
         s: String;
         Diario: Boolean;
     begin
       Result := -1;

       if SL.Count < 8 then
          Raise Exception.Create(MSG_1);

       s := SL[6]; // "ANO" ou "DIA"
       if s <> '' then s := Copy(s, 1, 3);
       if s = 'DIA' then Result := ord(tiDiario) else
       if s = 'ANO' then Result := ord(tiMensal);

       if Result = -1 then
          Raise Exception.Create(MSG_1);

       i := 7; // Linha inicial dos dados para qualquer um dos tipos
       if Result = ord(tiDiario) then
          repeat
            LeDadosDoBloco(i);
            ProximoBloco(i);
          Until i = -1
       else
          LeDadosAnuais(7);
     end;

var s: String;
begin
  ts := ThousandSeparator;
  ds := DecimalSeparator;
  ThousandSeparator := ',' ;
  DecimalSeparator  := '.';

  x.FileName := NomeArq;

  CriaTabela(x.FileName, True {Indexada});
  Tab := TTable.Create(nil);
  Tab.TableName := x.FileName;
  Tab.Open;

  SL := TStringList.Create;

  Screen.Cursor := crHourGlass;
  Try
    for i := 0 to Arquivos.Count - 1 do
      Try
        SL.LoadFromFile(Arquivos[i]);
        InputQuery('Importação dos dados de Alogoas', 'Entre com o número do Posto', s);
        try
          Posto := StrToInt(SysUtilsEx.AllTrim(s));
        except
          ShowMessage('Valor inválido para o posto: ' + s);
          Continue;
        end;
        x.Tipo := TIntervalo(ImportaDados);
      Except
        On E: Exception do MostraErro(Arquivos[i], E.Message);
      End;
  Finally
    ThousandSeparator := ts;
    DecimalSeparator  := ds;

    SL.Free;

    Tab.Close;
    Tab.Free;
    DeleteFile(ChangeFileExt(x.FileName, '.PX'));

    x.Tab := TQuery.Create(Nil);
    x.Tab.RequestLive := True;
    x.Tab.SQL.Add(Format(cSQL_RequestLive, [x.FileName]));
    x.Tab.Open;
    If x.Tab.RecordCount = 0 Then
       begin
       x.Tab.Free;
       x.Tab := nil;
       end;

    Screen.Cursor := crDefault;
    End
end;

procedure ImptConverterParaMensal(Arquivos: TStrings;
                                  Const NomeArq: String;
                                  var x: TGlobalDataRec);
var inPosto : String;
    inData  : String;
    inTam   : String;
    Data    : TDateTime;
    Posto   : Integer;
    TamInt  : Integer;
    Valor   : Double;
    V       : TwsSFVec;
    i       : Integer;
    k       : Integer;
    Tab     : TTable;
    ts, ds  : Char;

     function ImportaDados: Integer;
     var Dia, Ano, Mes: Word;
         i, k : Integer;
         NP   : byte;    // enégimo periodo;
         P    : byte;    // periodo n
         PF   : byte;    // número de períodos fixos nos meses
         QDUP : Integer; // Quantidade De Dias Do Ultimo Periodo
         Dias : Integer;
         r    : Real;
     begin
       Result := ord(tiMensal);
       DecodeDate(Data, Ano, Mes, Dia);

       if TamInt > 1 then
          begin
          PF := ObtemPeriodosExatosNosMeses(TamInt);

          // Cálculo do período inicial do mês
          if Dia = 1 then
             P := 1
          else
             P := (Dia - 1) div TamInt + 1;
          end
       else
          begin
          PF := DaysInMonth(Mes, Ano, Ano);
          P  := Dia;
          end;

       i := 0;
       
       repeat
         r := 0;
         Dias := 0;

         // Calcula o somatório dos dados que estão em períodos fixos
         for k := P to PF do
           begin
           inc(i);
           if i <= v.Len then
              begin
              r := r + v[i];
              inc(Dias, TamInt);
              end;
           end;

         // Calcula o primeiro sub-total ponderado
         if TamInt > 1 then
            r := r * TamInt;

         // Soma com o resto ponderado do mes
         QDUP := ObtemQuantidadeDeDiasDoUltimoPeriodo(TamInt, Mes, Ano);
         if (QDUP > 0) then
            begin
            inc(i);
            inc(Dias, QDUP);
            if i <= v.Len then
               r := r + v[i] * QDUP;
            end;

         // Obtem a média mensal
         r := r / Dias;

         Tab.AppendRecord([Posto, EncodeDate(Ano, Mes, 01), r]);
         inc(x.Meses);

         inc(Mes);
         if Mes > 12 then
            begin
            Mes := 1;
            inc(Ano);
            end;

         P := 1;
         if TamInt = 1 then PF := DaysInMonth(Mes, Ano, Ano);

       until i >= v.Len;
     end;

begin
  ts := ThousandSeparator;
  ds := DecimalSeparator;
  ThousandSeparator := ',';
  DecimalSeparator  := '.';

  x.FileName := NomeArq;

  CriaTabela(x.FileName, True {Indexada});
  Tab := TTable.Create(nil);
  Tab.TableName := x.FileName;
  Tab.Open;

  V := TwsSFVec.Create(0);

  Screen.Cursor := crHourGlass;
  Try
    for i := 0 to Arquivos.Count - 1 do
      Try
        V.LoadFromTextFile(Arquivos[i]);

        InputQuery('Conversão Para Mensal', 'Entre com o tamanho do Intervalo. Ex: 7 (Semanal)', inTam);
        InputQuery('Conversão Para Mensal', 'Entre com o número do Posto', inPosto);
        InputQuery('Conversão Para Mensal', 'Entre com Data Inicial', inData);

        try
          TamInt := StrToInt(SysUtilsEx.AllTrim(inTam));
          if not TamInt in [1, 5, 7, 10, 15] then Abort;
        except
          ShowMessage('Tamanho do Intervalo Inválido: ' + inTam);
          Continue;
        end;

        try
          Posto := StrToInt(SysUtilsEx.AllTrim(inPosto));
        except
          ShowMessage('Valor inválido para o posto: ' + inPosto);
          Continue;
        end;

        try
          Data := StrToDate(SysUtilsEx.AllTrim(inData));
        except
          ShowMessage('Data Inválida: ' + inData);
          Continue;
        end;

        x.Tipo := TIntervalo(ImportaDados);
      Except
        On E: Exception do MostraErro(Arquivos[i], E.Message);
      End;
  Finally
    ThousandSeparator := ts;
    DecimalSeparator  := ds;

    V.Free;

    Tab.Close;
    Tab.Free;
    DeleteFile(ChangeFileExt(x.FileName, '.PX'));

    x.Tab := TQuery.Create(Nil);
    x.Tab.RequestLive := True;
    x.Tab.SQL.Add(Format(cSQL_RequestLive, [x.FileName]));
    x.Tab.Open;
    If x.Tab.RecordCount = 0 Then
       begin
       x.Tab.Free;
       x.Tab := nil;
       end;

    Screen.Cursor := crDefault;
    End
end;

{A ideia aqui é converter os dados para valores diários e depois para o respectivo período}
procedure ImptConverterPara_NPeriodo(Arquivos: TStrings;
                                     Const NomeArq: String;
                                     var x: TGlobalDataRec;
                                     TamOrig, TamDest, CodPosto: Integer;
                                     DataInicial: TDateTime);

{
  procedure Importar(const Arquivo: String);
  begin
    V.LoadFromTextFile(Arquivo);

    x.Tipo := TIntervalo(ImportaDados);
  end;
}
begin
(*
  ts := ThousandSeparator;
  ds := DecimalSeparator;
  ThousandSeparator := ',';
  DecimalSeparator  := '.';

  x.FileName := NomeArq;

  CriaTabela(x.FileName, True {Indexada});
  Tab := TTable.Create(nil);
  Tab.TableName := x.FileName;
  Tab.Open;

  V := TwsSFVec.Create(0);

  Screen.Cursor := crHourGlass;
  Try
    for i := 0 to Arquivos.Count - 1 do
      Try
        Importar(Arquivos[i]);
      Except
        On E: Exception do MostraErro(Arquivos[i], E.Message);
      End;
  Finally
    ThousandSeparator := ts;
    DecimalSeparator  := ds;

    V.Free;

    Tab.Close;
    Tab.Free;
    DeleteFile(ChangeFileExt(x.FileName, '.PX'));

    x.Tab := TQuery.Create(Nil);
    x.Tab.RequestLive := True;
    x.Tab.SQL.Add(Format(cSQL_RequestLive, [x.FileName]));
    x.Tab.Open;
    If x.Tab.RecordCount = 0 Then
       begin
       x.Tab.Free;
       x.Tab := nil;
       end;

    Screen.Cursor := crDefault;
    End
*)
end;

procedure ImptHidroWeb(Arquivos: TStrings;
                       Const NomeArq: String;
                       var x: TGlobalDataRec);
var s: String;
    i: Integer;
    ts, ds: Char;
    Tab: TTable;
    SL: TStrings;

    procedure Importar;
    var i, ii, k: Integer;
        Dia, Mes, Ano: Word;
        Dias: Word;
        Posto: Cardinal;
        Dado: Real;
        Data: TDateTime;
        Status: byte;
        Dados: TStrings;
    begin
      Dados := nil;
      for i := 11 to SL.Count-1 do
        begin
        StringToStrings(SL[i], Dados, [';']);

        if Dados.Count <> 65 then Continue;

        // Informações básicas
        Posto := StrToInt(Dados[0]);
        Ano   := StrToInt(Dados[1]);
        Mes   := StrToInt(Dados[2]);

        Dias  := DaysInMonth(Mes, Ano, Ano);

        // Dados Diários + Status
        for ii := 3 to 33 do
          begin
          Dia := ii - 2;
          if Dia <= Dias then
             begin
             k := ii + 31;
             s := Dados[ii];
             if (s = '-') or (s = '') then Dado := MissValue else Dado := StrToFloat(s);
             Status := StrToInt(Dados[k]);
             Data := EncodeDate(Ano, Mes, Dia);
             Tab.AppendRecord([Posto, Data, Dado, Status]);
             end;
          end;

        end;
    end;

begin
  ts := ThousandSeparator;
  ds := DecimalSeparator;
  ThousandSeparator := ',' ;
  DecimalSeparator  := '.';

  x.FileName := NomeArq;

  CriaTabela(x.FileName, True {Indexada}, True {Cria Campo Status});
  Tab := TTable.Create(nil);
  Tab.TableName := x.FileName;
  Tab.Open;

  SL := TStringList.Create;

  Screen.Cursor := crHourGlass;
  Try
    for i := 0 to Arquivos.Count - 1 do
      Try
        SL.LoadFromFile(Arquivos[i]);
        Importar;
        x.Tipo := tiDiario;
      Except
        On E: Exception do MostraErro(Arquivos[i], E.Message);
      End;
  Finally
    ThousandSeparator := ts;
    DecimalSeparator  := ds;

    SL.Free;

    Tab.Close;
    Tab.Free;
    DeleteFile(ChangeFileExt(x.FileName, '.PX'));
{
    x.Tab := TQuery.Create(Nil);
    x.Tab.RequestLive := True;
    x.Tab.SQL.Add(Format(cSQL_RequestLive, [x.FileName]));
    x.Tab.Open;
    If x.Tab.RecordCount = 0 Then
       begin
       x.Tab.Free;
       x.Tab := nil;
       end;
}
    Screen.Cursor := crDefault;
    End
end;

procedure ImptCodeVasp_15minutos(Arquivos: TStrings;
                                 Const NomeArq: String;
                                 var x: TGlobalDataRec);
var s: String;
    i: Integer;
    ts, ds: Char;
    Tab: TTable;
    SL: TStrings;

    procedure Importar;
    var i, ii, k: Integer;
        Posto: String;
        Dado: Real;
        Data: TDateTime;
        Dados: TStrings;
        s, P, F: String;
        D: Char;
    begin
      Dados := nil;
      for i := 1 to SL.Count-1 do
        begin
        StringToStrings(SL[i], Dados, [';']);

        if Dados.Count <> 99 then Continue;

        Posto := Copy(Dados[0], 2, Length(Dados[0])-2);
        Data  := StrToDate(Dados[1]);

        // Dados Diários de 15 em 15 minutos
        Dado := 0;
        for ii := 3 to 98 do
          Dado := Dado + StrToFloatDef(Dados[ii]);

        If Not Tab.FindKey([Posto, Data]) Then
           Tab.AppendRecord([Posto, Data, Dado]);
        end;
    end;

begin
  ts := ThousandSeparator;
  ds := DecimalSeparator;
  ThousandSeparator := '.' ;
  DecimalSeparator  := ',';

  x.FileName := NomeArq;

  CriaTabela(x.FileName, True {Indexada}, False {Cria Campo Status});
  Tab := TTable.Create(nil);
  Tab.TableName := x.FileName;
  Tab.Open;

  SL := TStringList.Create;

  Screen.Cursor := crHourGlass;
  Try
    for i := 0 to Arquivos.Count - 1 do
      Try
        SL.LoadFromFile(Arquivos[i]);
        Importar;
        x.Tipo := tiDiario;
      Except
        On E: Exception do MostraErro(Arquivos[i], E.Message);
      End;
  Finally
    ThousandSeparator := ts;
    DecimalSeparator  := ds;

    SL.Free;

    Tab.Close;
    Tab.Free;
    DeleteFile(ChangeFileExt(x.FileName, '.PX'));
    Screen.Cursor := crDefault;
    End
end;

procedure Impt_X(Arquivos: TStrings;
                 Const NomeArq: String;
                 var x: TGlobalDataRec);
var TabExcel : TF1Book;
    i: Integer;
    ts, ds: Char;
    Tab: TTable;
    TipoFileExcel: SmallInt;

    procedure Importar;
    var Posto: String;
        D, M, A: Word;
        x: Real;
        L, C: Integer;
        sD, sX: String;
        Data: TDateTime;
    begin
      Posto := TabExcel.TextRC[1, 1];
      L := 2;
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
                Tab.AppendRecord([Posto, Data + C - 1, x]);
                end
             end
           end;
      until sD = '';
    end;

begin
  ts := ThousandSeparator;
  ds := DecimalSeparator;
  ThousandSeparator := '.' ;
  DecimalSeparator  := ',';

  x.FileName := NomeArq;

  CriaTabela(x.FileName, True {Indexada}, False {Cria Campo Status});
  Tab := TTable.Create(nil);
  Tab.TableName := x.FileName;
  Tab.Open;

  TabExcel := TF1Book.Create(nil);

  Screen.Cursor := crHourGlass;
  Try
    for i := 0 to Arquivos.Count - 1 do
      Try
        TabExcel.Read(Arquivos[i], TipoFileExcel);
        if TipoFileExcel <> F1FileExcel4 then
           Raise Exception.Create('O arquivo do Excel não está no formato (XLS 4)');

        Importar;
      Except
        On E: Exception do MostraErro(Arquivos[i], E.Message);
      End;

    x.Tipo := tiDiario;
  Finally
    ThousandSeparator := ts;
    DecimalSeparator  := ds;

    Tab.Close;
    Tab.Free;
    DeleteFile(ChangeFileExt(x.FileName, '.PX'));
    Screen.Cursor := crDefault;
    End
end;

end.

