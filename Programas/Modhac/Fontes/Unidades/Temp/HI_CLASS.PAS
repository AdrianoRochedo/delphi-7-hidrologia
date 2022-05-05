unit HI_Class;

interface
uses Hi_Const, Forms, SysUtils, Wintypes, WinProcs, Graf_3, Historic;

Type

 TSubBacia = Class
 Private
   FileSugest : String[10];  {Sugestao para o nome dos arquivos de saída}
   FileInc    : Integer;     {Auxiliar para a formação do nome do arquivo de saída}
   Function GetDados: TDadosDaBacia;
 Public
   pDados     : pTDadosDaBacia;
   FileName   : String;
   ExecDir    : String;
   Editing    : Boolean;
   Modified   : Boolean;
   Form       : TForm;    {Janela de informações principais}
   Historico  : TDLG_Historico;
   ParamsGraf : TDLG_GraphicPar;

   Constructor Create;
   Destructor Destroy; Override;

   Class Function LoadFromFile(Const Name: String): TSubBacia;
   Procedure SaveToFile(Const Name: String);

   Function  GetNameFiles(Const DirTrab: String): String;
   Procedure ShowInfoGeral(Ger_Handle: HWnd);

   Procedure ShowParamsGraphics;
   Procedure CopiarParametros;
   Procedure ColarParametros;

   Procedure Executar(DirTrab, NomeArqSai: String; DelFiles: Boolean; Pos: Integer);

   Property Dados: TDadosDaBacia Read GetDados;
 End;

implementation
uses Info_Ger, Params, Hi_Vars, ExecFile, wsMatrix, Edit, SysUtilsEx, FileUtils, WinUtils,
     Classes, Assist, Dialogs, Controls, Hi_Func, Gerent;

 Constructor TSubBacia.Create;
 Begin
   Inherited Create;
   Editing  := False;
   Modified := False;
   ExecDir  := gModHacPath;
   New(pDados);
   FillChar(pDados^, SizeOf(TDadosDaBacia), 0);
   Historico := TDLG_Historico.Create(nil);
   Historico.Dados := pDados;
 End;

 Destructor TSubBacia.Destroy;
 Begin
   Historico.Free;
   If Assigned(ParamsGraf) Then ParamsGraf.Free;
   If Editing Then Form.Close;
   Dispose(pDados);
   Inherited Destroy;
 End;

 Class Function TSubBacia.LoadFromFile(Const Name: String): TSubBacia;
 var F: File;
     Erro: Word;
     S: String[10];
 Begin
   AssignFile(F, Name);
   Try
     Reset(F, 1);
   Except
     Raise Exception.CreateFmt(eLoadError + #13 +
           'Arquivo não encontrado.', [Name]);
   End;

   Try
     BlockRead(F, S, SizeOf(S));
     If S = 'Sub-Bacia' Then
        Begin
        Result := TSubBacia.Create;
        Result.FileName := Name;
        try
          BlockRead(F, Result.pDados^, SizeOf(TDadosDaBacia));
        except
          raise Exception.CreateFmt('Versão incorreta do arquivo: %s', [Name]);
          end;
        End
     Else
        Raise Exception.CreateFmtHelp(eLoadSubBacError + '.'#13 +
              'Arquivo: %s', [Name], hcSubBacError);
   Finally
     CloseFile(F);
   End;
 End;

 Procedure TSubBacia.SaveToFile(Const Name: String);
 var F: File;
     Erro: Word;
     S: String[10];
 Begin
   S := 'Sub-Bacia';
   Try
     AssignFile(F, Name);
     ReWrite(F, 1);
     BlockWrite(F, S, SizeOf(S));
     BlockWrite(F, pDados^, SizeOf(TDadosDaBacia));
     CloseFile(F);
     FileName := Name;
     Modified := False;
   Except
     Raise Exception.CreateHelp(eSaveError, hcSaveError);
     End;
 End;

 Function TSubBacia.GetDados: TDadosDaBacia;
 Begin
   Result := pDados^
 End;

 Procedure TSubBacia.ShowInfoGeral(Ger_Handle: Hwnd);
 Var D: TDLG_Informacoes;
 Begin
   If Not Editing Then
      Begin
      Editing := True;
      D := TDLG_Informacoes.Create(ActiveProject);
      Form := D;
      D.Ger_Handle := Ger_Handle;
      D.SubBacia := Self;
      {D.FormStyle := fsMDIchild;}
      D.Dados := pDados;
      D.ShowModal;
      End
   Else
      Form.ShowModal;
 End;

 Procedure TSubBacia.Executar(DirTrab, NomeArqSai: String;
                              DelFiles: Boolean; Pos: Integer);
 var i,j       : integer;
     Ano       : Integer;
     S          : String;
     NomeArqEnt : String;      {Nome temporário do arq. de entrada}
     Nome1      : String;
     Nome2      : String;
     NomeRes    : String;
     NomePar    : String;
     Tamanho    : Integer;
     F          : Boolean;
     Dados      : TwsDataSet;
     Tam        : Array[1..nParametros] Of Integer;
     Par        : Array[1..nParametros, 1..5] of String[10];
     SL         : TStringList;
     Col        : TStrings;
     Batch      : TStrings;
     Exec       : TExecFile;
     AP         : TDLG_Gerente;
 Begin
  gOutPut.Editor.NewPage;
  AP := ActiveProject;

  DirTrab := ExtractShortPathName(DirTrab);
  if DirTrab[Length(DirTrab)] <> '\' then DirTrab := DirTrab + '\';

  NomeArqEnt := ChangeFileExt(GetTempFile(DirTrab, 'TMP'), '.ENT');
  Nome1      := ExtractFileName(NomeArqEnt);
  Nome2      := ChangeFileExt(Nome1, '.SAI');
  NomeRes    := ChangeFileExt(Nome1, '.RES');
  NomePar    := ChangeFileExt(Nome1, '.PAR');

  With pDados^ Do
    Begin
    gOutPut.Editor.ActiveDoc.DeleteAll(True);
    gOutPut.Editor.Write(Aspa + InfoGerais.Titulo1 +Aspa);
    gOutPut.Editor.Write(Aspa + InfoGerais.Titulo2 +Aspa);
    gOutPut.Editor.Write(FloatToStr(InfoGerais.Area));
    gOutPut.Editor.Write(Aspa + InfoGerais.Titulo3 +Aspa);

    {Para documentação}
    gOutPut.Editor.Write(Aspa + IntCompToStr(ExecDados.IntComp) + Aspa);
    gOutPut.Editor.Write(Aspa + IntSimToStr (ExecDados.IntSim) + Aspa);

    gOutPut.Editor.Write(Aspa + DirTrab + InfoGerais.ArqPLU + '.plu' + Aspa);
    gOutPut.Editor.Write(Aspa + DirTrab + InfoGerais.ArqETP + '.etp' + Aspa);
    gOutPut.Editor.Write(Aspa + DirTrab + InfoGerais.ArqVZO + '.vzo' + Aspa);
    gOutPut.Editor.Write(Aspa + DirTrab + InfoGerais.ArqVZC + '.vzc' + Aspa);

    gOutPut.Editor.Write(Aspa + DirTrab + NomeRes + Aspa);
    gOutPut.Editor.Write(Aspa + DirTrab + NomePar + Aspa);

    gOutPut.Editor.Write(IntToStr(InfoGerais.ExtPLU) + ' ' + IntToStr(InfoGerais.ExtVZO));

    gOutPut.Editor.Write(' ');

    {Pega o maior comprimento de cada coluna para formatação}
    for i := 1 to NParametros do
      Begin
      Tam[i] := 0; {F = 0 --> ffGeneral | F = 1 --> ffExponencial}
      F := (i = 7) or (i = 10) or (i = 11) or (i = 13) or (i = 14);

      Par[i, 1] := FloatToStrF(Parametros[i].ValsIni, TFloatFormat(F), 4, 2);
      If Length(Par[i, 1]) > Tam[i] Then Tam[i] := Length(Par[i, 1]);

      Par[i, 2] := FloatToStrF(Parametros[i].ValsMin, TFloatFormat(F), 4, 2);
      If Length(Par[i, 2]) > Tam[i] Then Tam[i] := Length(Par[i, 2]);

      Par[i, 3] := FloatToStrF(Parametros[i].ValsMax, TFloatFormat(F), 4, 2);
      If Length(Par[i, 3]) > Tam[i] Then Tam[i] := Length(Par[i, 3]);

      Par[i, 4] := FloatToStrF(Parametros[i].PassoIni, TFloatFormat(F), 4, 2);
      If Length(Par[i, 4]) > Tam[i] Then Tam[i] := Length(Par[i, 4]);

      Par[i, 5] := FloatToStrF(Parametros[i].Precisao, TFloatFormat(F), 4, 2);
      If Length(Par[i, 5]) > Tam[i] Then Tam[i] := Length(Par[i, 5]);
      End;

    {Imprime os parametros na saída}
    for j := 1 to 5 do
      Begin
      S := '';
      for i := 1 to NParametros do
        S := S  + strCenter(Par[i, j], Tam[i]) + ' ';
      gOutPut.Editor.Write(S);
      End;

    {Parametros de controle : indentificação do intervalo de computação}
    gOutPut.Editor.Write( IntToStr(ExecDados.IntComp) );

    {Indicação do ano e mes caso intervalo de computacao mensal}
    if ExecDados.IntComp = 1 {Mensal} then
       gOutPut.Editor.Write( InfoGerais.Ano + ' ' + IntToStr(InfoGerais.Mes))
    else
       gOutPut.Editor.Write('');

    {modo de execução}      {Ver fato de zero retonar valor inicial do modo de execusao???}
    gOutPut.Editor.Write( IntToStr(ExecDados.ExecMode) );

    {Controles da otimizacao}
    If pDados^.ExecDados.ExecMode = 1 {Calibracao} Then
       gOutPut.Editor.Write( IntToStr  (ExecDados.Nstep)   + ' ' +
                      IntToStr  (ExecDados.Maxit)   + ' ' +
                      IntToStr  (ExecDados.Iprint)  + ' ' +
                      FloatToStrF(ExecDados.Ftol, ffExponent, 4,2)  +' '+
                      IntToStr  (ExecDados.Fopt)    + ' ' +
                      FloatToStr(ExecDados.Qref1)   + ' ' +
                      FloatToStr(ExecDados.Qref2)   + '  '+
                      IntToStr  (ExecDados.Iqs) )     ;

    gOutPut.Editor.Write( FloatToStr  (ExecDados.RSP)   +' '+
                   FloatToStr  (ExecDados.RSS)   +' '+
                   FloatToStr  (ExecDados.RSB)   +' '+
                   FloatToStr  (ExecDados.TS)    +' '+
                   FloatToStr  (ExecDados.TB) );


    If pDados^.ExecDados.ExecMode = cCalibracao Then
       gOutPut.Editor.Write( FloatToStr  (ExecDados.BI)   +' '+
                      FloatToStr  (ExecDados.BS) );

    gOutPut.Editor.SaveDoc(NomeArqEnt);
    End; {With}

  gOutPut.Editor.Show;

  Batch := TStringList.Create;
  Batch.Add('CLS');
  Batch.Add('CD %1');
  Batch.Add(Format('%s %%2 %%3', [ExtractShortPathName(gModHacPath + gsModHacFile)]));
  Batch.SaveToFile(gModHacPath + 'Modhac.Bat');
  Batch.Free;

  Exec             := TExecFile.Create(nil);
  Exec.CommandLine := ExtractShortPathName(gModHacPath + 'Modhac.bat');
  Exec.Wait        := True;

  Try
    Exec.Parameters := DirTrab + ' ' + Nome1 + ' ' + Nome2;

    Assistente.Lines.Clear;
    If Exec.Execute Then
       If FileExists(DirTrab + Nome2) Then
          Begin
          DeleteFile(PChar(DirTrab + NomeArqSai + '.SAI'));
          //Delay(1000);
          RenameFile(DirTrab + Nome2, DirTrab + NomeArqSai + '.SAI');
          gOutPut.Editor.NewPage;
          gOutPut.Editor.OpenDoc(DirTrab + NomeArqSai + '.SAI');

          SysUtils.DeleteFile(DirTrab + Nome1);
          SysUtils.DeleteFile(DirTrab + Nome2);
          SysUtils.DeleteFile(NomeArqSai);

          {Tenta ler o arquivo NomeRes}
          Try
            Screen.Cursor := crHourGlass;
            Assistente.Lines.Clear;
            Assistente.Title.Caption := 'Aviso';
            Assistente.Lines.Add('O sistema executou o Modhac e');
            Assistente.Lines.Add('agora está lendo os resultados');
            Assistente.UseCursorPos := True;
            Assistente.Active(0,0);
            Try
              If pDados^.ExecDados.IntComp = MENSAL Then
                 Ano := StrToInt(pDados^.InfoGerais.Ano);

              Dados := LeArqChuvas(DirTrab + NomeRes , #10, #32,
                pDados^.ExecDados.IntComp, pDados^.Unidade, pDados^.InfoGerais.Mes,
                Ano, pDados^.InfoGerais.Area);

              If (Dados <> Nil) and (Dados.nRows > 0) Then
                 Begin
                 {Codificação de Tag_1:
                    Na unidade eu guardo a Função Objetivo e na Dezena a unidade}
                 Dados.Tag_1 := pDados^.ExecDados.FOpt + 10 * pDados^.Unidade;

                 Dados.Tag_2 := pDados^.ExecDados.ExecMode;
                 Dados.MLab  := NomeArqSai + '.DST';
                 Dados.SaveToFile(DirTrab + Dados.MLab);
                 Modified := True;
                 AP.AddDataSet(False, Pos, Dados);
                 AP.Arvore.FullExpand;
                 End
              Else
                 MessageDLG(eLoadResError, mtInformation, [mbOK], 0);
            Finally
              Screen.Cursor := crDefault;
            End;

            {Se eu consegui ler o arquivo NomeRes então o deleto}
            If DelFiles Then SysUtils.DeleteFile(DirTrab + NomeRes);
          Except
            MessageDLG(eLoadResError, mtInformation, [mbOK], 0);
          End;

          Assistente.Hide;

          {Lê o arquivo de Parâmetros NomePar se Calibração}
          If pDados^.ExecDados.ExecMode = cCalibracao Then
             Begin
             SL := TStringList.Create;
             Col := TStringList.Create;
             Try
               Try
                 SL.LoadFromFile(DirTrab + NomePar);
               Except
                 Raise Exception.CreateFmt(
                   'O arquivo de Parâmetros < %s > não foi criado', [NomePar]);
               End;

               For i := 0 To SL.Count - 2 do
                 Begin
                 Col.Add(SL[i]);
                 pDados^.Parametros[i+1].ValsIni := StrToFloat(AllTrim(SL[i]));
                 End;
               Historico.NewCol := Col;
               Modified := True;
               If DelFiles Then SysUtils.DeleteFile(DirTrab + NomeRes);
             Finally
               Col.Free;
               SL.Free;
               End;
             End;

          gOutPut.Editor.Show;

          If pDados^.ExecDados.ExecMode = cCalibracao Then
             Begin
             Assistente.Lines.Clear;
             Assistente.Lines.Add('Novos Parâmetros foram calculados');
             If Assistente.Visible Then Assistente.ShowText else Assistente.Active(0,0);
             Delay(2000);
             Assistente.Hide;
             End;

          End
       Else
         Begin
         Assistente.Title.Caption := 'Ops !!';
         Assistente.Lines.Add('O ModHac foi executado mas algo deu errado.');
         Assistente.Lines.Add('  - Podem ser os parâmetros');
         Assistente.Lines.Add('  - Algum arquivo pode estar incorreto');
         Assistente.Lines.Add('  - Etc ...');
         End
    Else
       Begin
       Assistente.Title.Caption := 'Ops !!';
       Assistente.Lines.Add('O ModHac não pode ser executado.');
       Case Exec.ErrorCode of
         2,3: Assistente.Lines.Add('O programa não foi encontrado.');
           8: Assistente.Lines.Add('Memória insuficiente.');
         End;
       End;

    Assistente.UseCursorPos := True;
    Assistente.Active(0, 0);

  Finally
    SysUtils.DeleteFile(gModHacPath + 'Modhac.Bat');
    Exec.Free;
    End;
End;

{Retorna somente com um nome de no máximo 8 caracteres}
Function TSubBacia.GetNameFiles(Const DirTrab: String): String;
var D: TSaveDialog;
Begin
  Result := '';
  D := TSaveDialog.Create(Application);
  Try
    D.InitialDir := DirTrab;
    D.Title := 'Salvar arquivo';
    D.Options := [ofNoChangeDir, ofPathMustExist, ofOverwritePrompt];
    If D.Execute Then
       Begin
       Result := ExtractFileName(D.FileName);
       Result := ChangeFileExt(Result, '');
       End;
  Finally
    D.Free;
  End;
End;

Procedure TSubBacia.ShowParamsGraphics;       
begin
  If ParamsGraf = Nil Then
     Begin
     ParamsGraf := TDLG_GraphicPar.Create(Application);
     ParamsGraf.Pai := Self;
     ParamsGraf.Caption := ParamsGraf.Caption + ' para a Sub-Bacia: ' + Dados.InfoGerais.Titulo1;
     Screen.Cursor := crHourGlass;
     Try
       ParamsGraf.Plotar_Serie(Historico.G);
     Finally
       Screen.Cursor := crDefault;
       End;
     ParamsGraf.FormStyle := fsMDIchild;
     End
  Else
     ParamsGraf.Show;
end;

procedure TSubBacia.ColarParametros;
begin
  if gPSB.TemDados then
     begin
     pDados.Parametros := gPSB.Parametros;
     pDados.ExecDados  := gPSB.ExecDados;
     Modified          := True;
     end;
end;

procedure TSubBacia.CopiarParametros;
begin
  gPSB.TemDados   := True;
  gPSB.Parametros := pDados.Parametros;
  gPSB.ExecDados  := pDados.ExecDados;
end;

end.
(*
{Retorna somente com um nome de no máximo 8 caracteres}
Function TSubBacia.GetNameFiles(Const DirTrab: String): String;
var D: TSaveDialog;
Begin
  Result := '';
  D := TSaveDialog.Create(Application);
  Try
    If FileSugest <> '' Then
       Inc(FileInc)
    Else
       Begin
       FileSugest := ExtractFileName(FileName);
       FileSugest := ChangeFileExt(FileSugest, '');
       FileInc    := 1;
       End;
    D.InitialDir := DirTrab;
    D.FileName := Copy(FileSugest, 1, 5) + IntToStr(FileInc);
    D.Title := 'Entre com um nome para os arquivos de saída. Sugestão: ' + D.FileName;
    D.Options := [ofNoChangeDir, ofPathMustExist, ofOverwritePrompt];
    If D.Execute Then
       Begin
       Result := ExtractFileName(D.FileName);
       Result := ChangeFileExt(Result, '');
       FileSugest := Copy(Result, 1, 5);
       End
    Else
       If FileInc = 1 Then
          FileSugest := ''
       Else
          Dec(FileInc);
  Finally
    D.Free;
  End;
End;
*)
