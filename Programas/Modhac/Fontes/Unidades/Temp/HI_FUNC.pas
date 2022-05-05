unit Hi_func;

interface
uses SysUtils, wsMatrix;

  Function LeArqChuvas    (Const Nome: String; Carac_Fim_Reg, Carac_Fim_Campo: Char;
     IC, Unidade, Mes: Byte; Ano: Integer; Area: Double): TwsDataSet;

  Function Conta999s      (Const Nome: String): Longint;
  Function ContaValores   (Const Nome: String): Longint;

  Function CodToFObjetive   (Cod: Longint   ): String;
  Function IntCompToStr     (IntComp: Byte  ): String;
  Function StrToIntComp     (Const S: String): Byte;

  Function IntSimToStr      (IntSim: Byte  ): String;
  Function StrToIntSim      (Const S: String): Byte;

  Procedure Get_FO_Unidade  (Cod: Longint; var FO, Unidade: Byte);

implementation
uses wsConstTypes,
     wsVec,
     wsCVec,
     Math,
     wsGLib,
     SysUtilsEx,
     Hi_Const,
     Forms,
     stDate;

Function LeArqChuvas (Const Nome: String; Carac_Fim_Reg, Carac_Fim_Campo: Char;
  IC, Unidade, Mes: Byte; Ano: Integer; Area: Double): TwsDataSet;

Const CharSetEndField : TCharSet = [#32];
      CharNo          : TCharSet = [#10, #13];
      Numero_Colunas             = 11;

Var   NumReg,
      IndexMatriz,
      I,
      j,
      Posicao      : Integer;
      Dado         : String;
      Linha        : TwsCVec;
      Linha_Vector : TWSVec;
      Arquivo      : TextFile;
      Aux          : Double;
      Tempo        : Longint;

      Function GetTempo(MesIni, AnoIni: Integer; i: Longint): Longint;
      var nDias: Longint;
      Begin
        Mes := i mod 12 + MesIni - 1;
        Ano := (i + Mes - 2) div 12 + AnoIni;
        nDias := DaysInMonth(Mes, Ano, Ano);
        Result := nDias * SecondsInDay;
      End;

Begin
  Result := Nil;
  AssignFile(Arquivo, Nome);
  Try
    Reset(Arquivo);
    Result := TwsDataset.Create('Chuvas', 0, 0);
    For i := 1 to Numero_colunas - 1 do
       Result.Struct.AddNumeric(cNomeColunas[i], '');
    Try
      While Not EOF(Arquivo) Do
        Begin
        Application.ProcessMessages;
        Linha := TwsCVec.Create;
        Linha.GetUntil (Arquivo,  #10, CharNo);
        If Linha.Len > 1 Then
            Begin
            Linha_Vector := TwsDFVec.Create(Numero_colunas - 1);
            Result.MAdd(Linha_Vector);
            IndexMatriz := 0;
            Posicao := 5; // ignora a primeira coluna do arquivo
            For i := 1 To Numero_colunas Do
              Begin
              Dado := Linha.StrUntilChar(CharSetEndField, Posicao);
              If i > 1 Then
                 Begin
                 Try
                   Aux := StrToFloat(Dado);
                   If Aux < 0 Then Aux := wsConstTypes.wscMissValue;
                   Result.PrintOptions.MaxIdSize := Max(Result.PrintOptions.MaxIdSize, Length(Dado) + 3);
                 Except
                   Aux := wsConstTypes.wscMissValue;
                 End;
                 Linha_Vector[i - 1] := Aux;
                 End;                                           
              End; { For i }
            End; { If Linha.Len > 1 }
        Linha.Free;
        End; { While Not EOF }

        {Faz a conversão mm --> m3/s se necessário, exceto a 1. coluna}
        If Unidade = cM3s Then
           For i := 1 to Result.nRows do
             Begin
             If IC = DIARIO Then
                Tempo := SecondsInDay
             Else
                Tempo := GetTempo(Mes, Ano, i);

             For j := 2 to Result.nCols do
               If Result[i, j] <> wsConstTypes.wscMissValue Then
                  Result[i, j] := Result[i, j] * (Area * 1000) / Tempo;
             End;

     Except
       Result.Free;
       Raise;
     End;

  Finally
    CloseFile(Arquivo);
  End;
End; { LeArqChuvas }

{---------------------------------------------------------------------------}

Function ContaValores(Const Nome: String): Longint;
Type
   TCharSet = set of Char;

Const
    DelChar   : TCharSet = [#8, #9, #32, #13, #10];

var ch        : char;
    Arquivo   : TextFile;
    FimArquivo: Boolean;
begin
  AssignFile(Arquivo, Nome);
  Reset(Arquivo);
  Try
    Result := 0;
    While Not EOF(Arquivo) Do
      Begin
      Application.ProcessMessages;
      Read(Arquivo, Ch);
      if (Ch in DelChar) and not EOF(Arquivo) then
         while (Ch in DelChar) and not EOF(Arquivo) do Read(Arquivo, Ch);

      if not (Ch in DelChar) and not EOF(Arquivo) then
         begin
         while not (Ch in DelChar) and not EOF(Arquivo) do
           Read(Arquivo, Ch);
         inc (Result);
         end;
      End;   { While Not EOF }
  Finally
    CloseFile(Arquivo);
  End;
end;

{---------------------------------------------------------------------------}

function Conta999s(Const Nome: String): Longint;
var ch      : char;
    i       : longint;
    Arquivo : TextFile;
    valor   : String[5];
begin
  AssignFile(Arquivo, Nome);
  Reset(Arquivo);
  Result := 0;
  While Not EOF(Arquivo) Do
    Begin
    Application.ProcessMessages;
    Read(Arquivo, Ch);
    if Ch = '-' then
       begin
       valor := '-';
       For i := 1 to 4 do
         begin
         read(Arquivo, Ch);
         Valor := Valor + Ch;
         end;
       if Valor = '-999.' then inc (Result);
       valor := '';
       end;{if Ch = '-'}
    End;
 CloseFile(Arquivo);
 { While Not EOF }
end;

{---------------------------------------------------------------------------}

Function CodToFObjetive(Cod: Longint): String;
Begin
  Result := 'Nenhuma definida';
  Case Cod of
    1: Result := csMinQuad;
    2: Result := csFatorModulacao;
    3: Result := csValorABS;
    4: Result := csLogaritmica;
    End;
End;

{---------------------------------------------------------------------------}

Function IntCompToStr (IntComp: Byte): String;
Begin
  Case IntComp of
    0: Result := 'DIARIO';
    1: Result := 'MENSAL';
    Else
      Raise Exception.Create(eIntCompError);
    End;
End;

{---------------------------------------------------------------------------}

Function StrToIntComp (Const S: String): Byte;
Begin
  If CompareText(S, 'DIARIO') = 0 Then Result := 0 Else
  If CompareText(S, 'MENSAL') = 0 Then Result := 1
  Else
    Raise Exception.Create(eIntCompError);
End;

{---------------------------------------------------------------------------}

Function IntSimToStr (IntSim: Byte): String;
Begin
  Case IntSim of
    0: Result := 'DIÁRIO';
    1: Result := 'QUINQÜENDIAL';
    2: Result := 'SEMANAL';
    3: Result := 'DECENDIAL';
    4: Result := 'MENSAL';
    5: Result := 'OUTROS';
    Else
      Raise Exception.Create(eIntSimError);
    End;
End;

{---------------------------------------------------------------------------}

Function StrToIntSim (Const S: String): Byte;
Begin
  If (CompareText(S, 'Diário') = 0) or (CompareText(S, 'Diario') = 0) Then
     Result := 0 Else
  If (CompareText(S, 'Quinqüendial') = 0) or ((CompareText(S, 'Quinquendial') = 0)) Then
     Result := 1 Else
  If CompareText(S, 'Semanal')      = 0 Then Result := 2 Else
  If CompareText(S, 'Decendial')    = 0 Then Result := 3 Else
  If CompareText(S, 'Mensal')       = 0 Then Result := 4 Else
  If CompareText(S, 'Outros')       = 0 Then Result := 5
  Else
    Raise Exception.Create(eIntSimError);
End;

{---------------------------------------------------------------------------}

Procedure Get_FO_Unidade  (Cod: Longint; var FO, Unidade: Byte);
Begin
  FO := Cod mod 10;
  Unidade := Cod div 10;
End;

{---------------------------------------------------------------------------}
end.
