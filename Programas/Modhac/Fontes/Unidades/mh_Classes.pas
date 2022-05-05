unit mh_Classes;

interface
uses Classes, Forms, SysUtils, Windows, MessagesForm, Assist,
     SysUtilsEx,
     wsTabelaDeSimbolos,
     wsMatrix,
     mh_TCs,
     mh_GRF_EvolucaodosParametros,
     mh_HistoricoDosParametros,
     XML_Interfaces,
     MSXML4;

Type
  TmhProject = class;

  TmhBaseNode = class(T_NRC_InterfacedObject, IToXML, IFromXML)
  private
    FFileName : String;   // Nome do arquivo que contém as informações do objeto conec. a este nó
    FObj: TObject;        // Objeto conectado a este nó
    FProject: TmhProject; // Projeto a que este nó está conectado

    // Obtém o caminho relativo ao caminho do projeto
    function getRelativeFileName: String;

    // IToXML interface
    procedure ToXML(Buffer: TStrings; Ident: Integer); virtual;
    function GetClassName: String;

    // IFromXML interface
    procedure FromXMLNodeList(NodeList: IXMLDOMNodeList); virtual;
    function GetObjectReference: TObject;
    function getFileName: String; virtual;
    function ToString(): String;
  public
    constructor Create(aProject: TmhProject; aObject: TObject);
    destructor Destroy; override;

    // Salva para arquivo as informações do nó
    procedure SaveToFile(const FileName: String); virtual;

    // Nome do arquivo que contém as informações do objeto conec. a este nó
    property FileName : String read getFileName write FFileName;
  end;

  TmhProject = class(TmhBaseNode)
  private
    FDelOutPutFiles: Boolean;
    FProjectName: String;
    FPath: String;
    FModified: Boolean;
    // IToXML interface
    procedure ToXML(Buffer: TStrings; Ident: Integer); override;
    // IFromXML interface
    procedure FromXMLNodeList(NodeList: IXMLDOMNodeList); override;
  public
    constructor Create;

    property ProjectName     : String  read FProjectName    write FProjectName;
    property Path            : String  read FPath           write FPath;
    property DelOutPutFiles  : Boolean read FDelOutPutFiles write FDelOutPutFiles;
    property Modified        : Boolean read FModified       write FModified;
  end;

  TmhDataSetNode = class(TmhBaseNode)
  private
    function getDataSet: TwsDataSet;
    function getFileName: String; override;
    // IFromXML interface
    procedure FromXMLNodeList(NodeList: IXMLDOMNodeList); override;
  public
    procedure SaveToFile(const FileName: String); override;
    property DataSet : TwsDataSet read getDataSet;
  end;

  TmhSubBaciaNode = class;

  TmhSubBacia = class(T_NRC_InterfacedObject, IToXML, IFromXML)
  Private
    FileSugest : String[10];  {Sugestao para o nome dos arquivos de saída}
    FileInc    : Integer;     {Auxiliar para a formação do nome do arquivo de saída}
    FSimCount  : Integer;     {guarda o numero de simulacoes ocorridas}
    FContainerNode: TmhSubBaciaNode;

    Function GetDados: TDadosDaBacia;

    // IToXML interface
    procedure ToXML(Buffer: TStrings; Ident: Integer);
    function GetClassName(): String;
    // IFromXML interface
    procedure FromXMLNodeList(NodeList: IXMLDOMNodeList);
    function GetObjectReference: TObject;
    function ToString(): String;
  Public
    pDados     : pTDadosDaBacia;
    //FileName   : String;
    ExecDir    : String;
    Editing    : Boolean;
    Modified   : Boolean;
    Form       : TForm;    {Janela de informações principais}
    Historico  : TDLG_Historico;
    ParamsGraf : TDLG_GraphicPar;

    Constructor Create;
    Destructor Destroy; Override;

    procedure LoadFromFile(Const Name: String);
    Procedure SaveToFile(Const Name: String);

    procedure ColocaValoresIniciaisNoHistorico();
    Function  GetNameFiles(Const DirTrab: String): String;
    Procedure MostrarInfoGeral(Ger_Handle: HWnd; MostrarParametros: Boolean = False);
    Procedure MostrarParametros();

    Procedure ShowParamsGraphics;
    Procedure CopiarParametros;
    Procedure ColarParametros;

    Procedure Executar(DirTrab, NomeArqSai: String; DelFiles: Boolean);

    Property Dados: TDadosDaBacia Read GetDados;
    property Node : TmhSubBaciaNode read FContainerNode write FContainerNode;
  End;

  TmhSubBaciaNode = class(TmhBaseNode)
  private
    function getSB: TmhSubBacia;
    // IFromXML interface
    procedure FromXMLNodeList(NodeList: IXMLDOMNodeList); override;
  public
    procedure SaveToFile(const FileName: String); override;
    property SubBacia : TmhSubBacia read getSB;
  end;

  TmhApplication = class
  private
     FDrive              : char;
     FAppPath            : String;
     FYear               : String;
     FErros              : TfoMessages;
     FLastPath           : String;
     FNE                 : Integer;
     FAssistant          : TAssistente;
     //FOutPut             : TEditor;
     FSysDate            : TDateTime;
     FTabVar             : TwsTabVar;       // Tabela de variáveis global
     FActiveProject      : TForm;
     FPSB                : TParametros;  // Parâmetros de uma Sub-Bacia (ClipBoard)
     FOldDecimalSeparator: Char;     
  public
    PSB: TParametros;

    procedure Initialize;
    procedure Finalize;
    procedure Run;
    procedure CreateForm(InstanceClass: TComponentClass; var Reference);
    procedure ShowDemoMessage();

    property AppPath       : String       read FAppPath;
    property LastPath      : String       read FLastPath write FLastPath;
    property Drive         : char         read FDrive;
    property Year          : String       read FYear;
    property SysDate       : TDateTime    read FSysDate;
    property TabVar        : TwsTabVar    read FTabVar;
    property ActiveProject : TForm        read FActiveProject write FActiveProject;
    property Old_DecSep    : Char         read FOldDecimalSeparator;

    // Objetos
    property Errors     : TfoMessages read FErros;
    property Assistant  : TAssistente read FAssistant;
 end;
    
var
  mhApplication : TmhApplication;

implementation
uses ExecFile, FileUtils, WinUtils, Dialogs, Controls,
     IniFiles,
     XML_Utils,
     foBook,
     mh_Procs,
     mh_Bacia_DadosGerais,
     mh_Bacia_Parametros,
     mh_GerenteDeProjeto,
     mh_SPLASH;

{ TmhSubBacia }

 Constructor TmhSubBacia.Create();
 Begin
   Inherited Create;
   Editing  := False;
   Modified := False;
   ExecDir  := mhApplication.AppPath;
   New(pDados);
   FillChar(pDados^, SizeOf(TDadosDaBacia), 0);
   Historico := TDLG_Historico.Create(nil);
   Historico.Dados := pDados;
 End;

 Destructor TmhSubBacia.Destroy;
 Begin
   Historico.Free();
   If Assigned(ParamsGraf) Then ParamsGraf.Free();
   If Editing Then Form.Release();
   Dispose(pDados);
   Inherited Destroy();
 End;

 function TmhSubBacia.GetObjectReference(): TObject;
 begin
   Result := Self;
 end;

 procedure TmhSubBacia.LoadFromFile(Const Name: String);
 var Ext : string;
     F   : File;
     Erro: Word;
     S   : String[10];
 Begin
   Modified := False;
   Ext := LowerCase(ExtractFileExt(Name));

   if Ext = '.xbac' then
      XML_Utils.LoadObjectFromXML(self, Name)
   else
   if Ext = '.bac' then
      begin
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
           try
             BlockRead(F, pDados^, SizeOf(TDadosDaBacia));
           except
             raise Exception.CreateFmt('Versão incorreta do arquivo: %s', [Name]);
           end
        Else
           Raise Exception.CreateFmtHelp(eLoadSubBacError + '.'#13 +
                 'Arquivo: %s', [Name], hcSubBacError);

        ColocaValoresIniciaisNoHistorico();
      Finally
        CloseFile(F);
        End;
      end;
 End;

 Procedure TmhSubBacia.SaveToFile(Const Name: String);
 Begin
   XML_Utils.SaveObjectToXML(Self, Name);
   Modified := False;
 End;

 Function TmhSubBacia.GetDados: TDadosDaBacia;
 Begin
   Result := pDados^
 End;

 Procedure TmhSubBacia.MostrarInfoGeral(Ger_Handle: Hwnd; MostrarParametros: Boolean = False);
 Var D: TDLG_Informacoes;
 Begin
   If Not Editing Then
      Begin
      Editing := True;
      D := TDLG_Informacoes.Create(mhApplication.ActiveProject);
      Form := D;
      D.Ger_Handle := Ger_Handle;
      D.SubBaciaNode := FContainerNode;
      D.Dados := pDados;
      D.MostrarParametros := MostrarParametros;
      D.ShowModal;
      Editing := False;
      End
   Else
      Form.ShowModal;
 End;

 Procedure TmhSubBacia.Executar(DirTrab, NomeArqSai: String; DelFiles: Boolean);

     procedure LerArquivoDeSaida(const NomeSai: string; Dados: TStrings);
     var i: Integer;
         SL: TStrings;
     begin
       SL := SysUtilsEx.LoadTextFile(NomeSai);
       i := SL.Count - 30;
       if i <= 0 then exit;

       if SysUtilsEx.Locate('TOT', SL, i) then
          begin
          // Vazao Observada total
          Dados.Add(SysUtilsEx.Copy(SL[i], 17, 11, true));

          // Vazao Calculada total
          Dados.Add(SysUtilsEx.Copy(SL[i], 28, 11, true));
          end;

       if SysUtilsEx.Locate('Observada:', SL, i) then
          begin
          // Vazao Observada em %
          Dados.Add(SysUtilsEx.Copy(SL[i], 33, 4, true));

          // Vazao Calculada em %
          inc(i);
          Dados.Add(SysUtilsEx.Copy(SL[i], 33, 4, true));

          // Pula uma linha
          Dados.Add('');
          end;

       if SysUtilsEx.Locate('VALORES DAS FUNCOES-OBJETIVO', SL, i) then
          begin
          // VFUNCAO-OBJETIVO MINIMOS QUADRADOS
          Dados.Add(SysUtilsEx.Copy(SL[i+1], 38, 13, true));

          // FUNCAO-OBJETIVO MODULADA
          Dados.Add(SysUtilsEx.Copy(SL[i+2], 38, 13, true));

          // FUNCAO-OBJETIVO VALOR ABSOLUTO
          Dados.Add(SysUtilsEx.Copy(SL[i+3], 38, 13, true));

          // FUNCAO-OBJETIVO LOGARITIMICA
          Dados.Add(SysUtilsEx.Copy(SL[i+4], 38, 13, true));
          end;

       SL.Free();
     end;

 var i,j             : integer;
     Ano             : Integer;
     S               : String;
     NomeArqEnt      : String;      {Nome temporário do arq. de entrada}
     NomeEnt         : String;
     NomeSai         : String;
     NomeRes         : String;
     NomePar         : String;
     DirTrabSai      : String;
     ShortDirTrab    : String;
     ShortDirTrabSai : String;
     Tamanho         : Integer;
     F               : Boolean;
     Dados           : TwsDataSet;
     Tam             : Array[1..nParametros] Of Integer;
     Par             : Array[1..nParametros, 1..5] of String[10];
     SL              : TStringList;
     Col             : TStrings;
     Batch           : TStrings;
     Exec            : TExecFile;
     AP              : TDLG_Gerente;
     book            : TBook;
 Begin
  {$ifdef VERSAO_LIMITADA}
  if FSimCount >= 2 then
     raise Exception.Create('Versão Limitada - Somente duas simulações são permitidas.');
  {$endif}

  S := self.Dados.InfoGerais.Titulo1 + '  (' + TimeToStr(Time) + ')';
  book := TBook.Create(S, fsMDIChild);

  AP := TDLG_Gerente(mhApplication.ActiveProject);

  if LastChar(DirTrab) <> '\' then
     DirTrab := DirTrab + '\';

  DirTrabSai := DirTrab + 'Saida\';
  if not ForceDirectories(DirTrabSai) then
     raise Exception.CreateFmt('Pasta <%s>'#13 +
                               'não pode ser criada', [DirTrabSai]);

  ShortDirTrab := ExtractShortPathName(DirTrab);
  ShortDirTrabSai := ShortDirTrab + 'Saida\';

  NomeArqEnt := ChangeFileExt(GetTempFile(ShortDirTrabSai, 'TMP'), '.ENT');
  NomeEnt    := ExtractFileName(NomeArqEnt);
  NomeSai    := ChangeFileExt(NomeEnt, '.SAI');
  NomeRes    := ChangeFileExt(NomeEnt, '.RES');
  NomePar    := ChangeFileExt(NomeEnt, '.PAR');

  With pDados^ Do
    Begin
    SL := TStringList.Create();

    SL.Add(Aspa + InfoGerais.Titulo1 + Aspa);
    SL.Add(Aspa + InfoGerais.Titulo2 + Aspa);
    SL.Add(FloatToStr(InfoGerais.Area));
    SL.Add(Aspa + InfoGerais.Titulo3 + Aspa);

    {Para documentação}
    SL.Add(Aspa + IntCompToStr(ExecDados.IntComp) + Aspa);
    SL.Add(Aspa + IntSimToStr (ExecDados.IntSim) + Aspa);

    SL.Add(Aspa + ShortDirTrab + InfoGerais.ArqPLU + '.plu' + Aspa);
    SL.Add(Aspa + ShortDirTrab + InfoGerais.ArqETP + '.etp' + Aspa);
    SL.Add(Aspa + ShortDirTrab + InfoGerais.ArqVZO + '.vzo' + Aspa);
    SL.Add(Aspa + ShortDirTrab + InfoGerais.ArqVZC + '.vzc' + Aspa);

    SL.Add(Aspa + ShortDirTrabSai + NomeRes + Aspa);
    SL.Add(Aspa + ShortDirTrabSai + NomePar + Aspa);

    SL.Add(IntToStr(InfoGerais.ExtPLU) + ' ' + IntToStr(InfoGerais.ExtVZO));

    SL.Add(' ');

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
      SL.Add(S);
      End;

    {Parametros de controle : indentificação do intervalo de computação}
    SL.Add( IntToStr(ExecDados.IntComp) );

    {Indicação do ano e mes caso intervalo de computacao mensal}
    if ExecDados.IntComp = MENSAL then
       SL.Add( InfoGerais.Ano + ' ' + IntToStr(InfoGerais.Mes))
    else
       SL.Add('');

    {modo de execução}      {Ver fato de zero retonar valor inicial do modo de execusao???}
    SL.Add( IntToStr(ExecDados.ExecMode) );

    {Controles da otimizacao}
    If pDados.ExecDados.ExecMode = cCalibracao Then
       SL.Add( IntToStr  (ExecDados.Nstep)   + ' ' +
                                   IntToStr   (ExecDados.Maxit)   + ' ' +
                                   IntToStr   (ExecDados.Iprint)  + ' ' +
                                   FloatToStrF(ExecDados.Ftol, ffExponent, 4, 2)  + ' ' +
                                   IntToStr   (ExecDados.Fopt)    + ' ' +
                                   FloatToStr (ExecDados.Qref1)   + ' ' +
                                   FloatToStr (ExecDados.Qref2)   + ' ' +
                                   IntToStr   (ExecDados.Iqs) )     ;

    SL.Add( FloatToStr  (ExecDados.RSP) + ' ' +
                                FloatToStr  (ExecDados.RSS) + ' ' +
                                FloatToStr  (ExecDados.RSB) + ' ' +
                                FloatToStr  (ExecDados.TS)  + ' ' +
                                FloatToStr  (ExecDados.TB) );


    If pDados.ExecDados.ExecMode = cCalibracao Then
       SL.Add( FloatToStr  (ExecDados.BI) + ' ' +
               FloatToStr  (ExecDados.BS) );

    SL.SaveToFile(NomeArqEnt);
    SL.Free();

    book.NewPage('memo', 'ENT', NomeArqEnt);
    End; {With}

  Batch := TStringList.Create();
  Batch.Add('CLS');
  Batch.Add('CD %1');
  Batch.Add(Format('%s %%2 %%3', [ExtractShortPathName(mhApplication.AppPath + gsModHacFile)]));
  Batch.Add('PAUSE');
  Batch.SaveToFile(mhApplication.AppPath + 'Modhac.Bat');
  Batch.Free;

  Exec             := TExecFile.Create(nil);
  Exec.CommandLine := ExtractShortPathName(mhApplication.AppPath + 'Modhac.bat');
  Exec.Wait        := True;

  Try
    Exec.Parameters := ShortDirTrabSai + ' ' + NomeEnt + ' ' + NomeSai;

    mhApplication.Assistant.Lines.Clear();
    If Exec.Execute() Then
       If FileExists(DirTrabSai + NomeSai) Then
          begin
          SysUtils.DeleteFile(DirTrabSai + NomeArqSai + '.SAI');
          SysUtils.RenameFile(DirTrabSai + NomeSai, DirTrabSai + NomeArqSai + '.SAI');

          book.NewPage('rtf', 'SAI', DirTrabSai + NomeArqSai + '.SAI');

          {Tenta ler o arquivo NomeRes}
          Screen.Cursor := crHourGlass;
          Try
            mhApplication.Assistant.Lines.Clear;
            mhApplication.Assistant.Title.Caption := 'Aviso';
            mhApplication.Assistant.Lines.Add('O sistema executou o Modhac e');
            mhApplication.Assistant.Lines.Add('agora está lendo os resultados');
            mhApplication.Assistant.UseCursorPos := True;
            mhApplication.Assistant.Active(0,0);
            Try
              If pDados.ExecDados.IntComp = MENSAL Then
                 Ano := StrToInt(pDados.InfoGerais.Ano);

              Dados := LeArqChuvas( DirTrabSai + NomeRes , #10, #32,
                                    pDados.ExecDados.IntComp,
                                    pDados.Unidade,
                                    pDados.InfoGerais.Mes,
                                    Ano,
                                    pDados.InfoGerais.Area );

              If (Dados <> Nil) and (Dados.nRows > 0) Then
                 Begin
                 {Codificação de Tag_1:
                 Na unidade eu guardo a Função Objetivo e na Dezena a unidade}
                 Dados.Tag_1 := pDados.ExecDados.FOpt + 10 * pDados^.Unidade;

                 Dados.Tag_2 := pDados.ExecDados.ExecMode;
                 Dados.MLab  := NomeArqSai + '.DST';
                 Dados.SaveToFile(DirTrabSai + Dados.MLab);
                 AP.AddDataSet(True, Dados);
                 AP.Tree.FullExpand;
                 Modified := True;
                 inc(FSimCount);
                 End
              Else
                 begin
                 Dados.Free;
                 MessageDLG(Format(eLoadResError, [DirTrabSai + NomeRes]),
                            mtInformation, [mbOK], 0);
                 end;
            Finally
              Screen.Cursor := crDefault;
            End;

            {Se eu consegui ler o arquivo NomeRes então o deleto}
            if DelFiles then SysUtils.DeleteFile(DirTrabSai + NomeRes);
          Except
            MessageDLG(eLoadResError, mtInformation, [mbOK], 0);
          End;

          mhApplication.Assistant.Hide();

          {Lê o arquivo de Parâmetros NomePar se Calibração}
          If pDados.ExecDados.ExecMode = cCalibracao Then
             begin
             SL := TStringList.Create;
             Col := TStringList.Create;
             Try
               Try
                 SL.LoadFromFile(DirTrabSai + NomePar);
               Except
                 Raise Exception.CreateFmt(
                   'O arquivo de Parâmetros < %s > não foi criado', [NomePar]);
               End;

               // Adiciona os dados atuais no historico e substitui os valores atuais
               Col.Add(NomeArqSai);
               For i := 0 To SL.Count - 2 do
                 Begin
                 Col.Add(SL[i]);
                 pDados.Parametros[i+1].ValsIni := StrToFloat(AllTrim(SL[i]));
                 End;

               // Pula uma linha
               Col.Add('');

               // Le o arquivo de saida para obtencao de informacoes adicionais
               LerArquivoDeSaida(DirTrabSai + NomeArqSai + '.SAI', Col);

               // Adiciona uma nova coluna com os dados atuais
               Historico.AddCol(Col, pDados.ExecDados.FOpt);

               Modified := True;
               if DelFiles then SysUtils.DeleteFile(DirTrabSai + NomeRes);
             finally
               Col.Free();
               SL.Free();
               end;

             mhApplication.Assistant.Lines.Clear();
             mhApplication.Assistant.Lines.Add('Novos Parâmetros foram calculados');
             If mhApplication.Assistant.Visible Then mhApplication.Assistant.ShowText else mhApplication.Assistant.Active(0,0);
             Delay(2000);
             mhApplication.Assistant.Hide();
             end; // if (ExecMode = cCalibracao)

          // Move o arquivo vzc para o dir. de saida
          Windows.MoveFile(pChar(DirTrab + pDados.InfoGerais.ArqVZC + '.vzc'),
                           pChar(DirTrabSai + NomeArqSai + '.vzc'));

          if FileExists(DirTrabSai + NomeArqSai + '.VZC') then
             book.NewPage('rtf', 'VZC', DirTrabSai + NomeArqSai + '.VZC');
          end // if (FileExists(DirTrabSai + NomeSai))
       else
         begin
         mhApplication.Assistant.Title.Caption := 'Ops !!';
         mhApplication.Assistant.Lines.Add('O ModHac foi executado mas algo deu errado.');
         mhApplication.Assistant.Lines.Add('  - Podem ser os parâmetros');
         mhApplication.Assistant.Lines.Add('  - Algum arquivo pode estar incorreto');
         mhApplication.Assistant.Lines.Add('  - Etc ...');
         end
    else
       begin
       mhApplication.Assistant.Title.Caption := 'Ops !!';
       mhApplication.Assistant.Lines.Add('O ModHac não pode ser executado.');
       case Exec.ErrorCode of
         2,3: mhApplication.Assistant.Lines.Add('O programa não foi encontrado.');
           8: mhApplication.Assistant.Lines.Add('Memória insuficiente.');
         end;
       end;

    mhApplication.Assistant.UseCursorPos := True;
    mhApplication.Assistant.Active(0, 0);

  Finally
    //SysUtils.DeleteFile(mhApplication.AppPath + 'Modhac.Bat');
    Exec.Free;
    End;
End;

{Retorna somente com um nome de no máximo 8 caracteres}
Function TmhSubBacia.GetNameFiles(Const DirTrab: String): String;
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

Procedure TmhSubBacia.ShowParamsGraphics();
begin
  If ParamsGraf = Nil Then
     Begin
     ParamsGraf := TDLG_GraphicPar.Create(nil);
     ParamsGraf.Pai := Self;
     ParamsGraf.Caption := ParamsGraf.Caption + ' para a Sub-Bacia: ' + Dados.InfoGerais.Titulo1;
     try
       ParamsGraf.Plotar_Serie(Historico.P.ActiveSheet);
     except
       end;
     End;
  ParamsGraf.Show;
end;

procedure TmhSubBacia.ColarParametros;
begin
  if mhApplication.PSB.TemDados then
     begin
     pDados.Parametros := mhApplication.PSB.Parametros;
     pDados.ExecDados  := mhApplication.PSB.ExecDados;
     Modified          := True;
     end;
end;

procedure TmhSubBacia.CopiarParametros;
begin
  mhApplication.PSB.TemDados   := True;
  mhApplication.PSB.Parametros := pDados.Parametros;
  mhApplication.PSB.ExecDados  := pDados.ExecDados;
end;

procedure TmhSubBacia.MostrarParametros();
Var D: TDLG_Parametros;
Begin
  Editing := True;
  D := TDLG_Parametros.Create(mhApplication.ActiveProject);
  Form := D;
  D.SubBaciaNode := FContainerNode;
  D.Dados := pDados;
  D.ShowModal();
  Editing := False;
End;

function TmhSubBacia.ToString: String;
begin
  Result := '';
end;

procedure TmhSubBacia.ColocaValoresIniciaisNoHistorico();
var i: Integer;
    sl: TStrings;
    p: TTabParamDados;
begin
  p := self.pDados.Parametros;
  sl := TStringList.Create();
  sl.Add('Vals.Ini.');
  for i := Low(p) to High(p) do sl.Add(FloatToStr(p[i].ValsIni));
  self.Historico.AddCol(sl, 0);
  sl.Free();
end;

{ TmhApplication }

procedure TmhApplication.Initialize();
var Ini: TIniFile;
begin
  with TSplashForm.Create(Application) do
    begin
    Show();
    Delay(2000);
    Free();
    end;

  {$ifdef DEMO}
  ShowDemoMessage();
  {$endif}

  Application.Initialize();
  Application.Title := 'Modhac 2000 - Versão 1.771';
  {$ifdef VERSAO_LIMITADA}
  Application.Title := Application.Title + '  (Versão Limitada)';
  {$endif}

  FOldDecimalSeparator := SysUtils.DecimalSeparator;
  SysUtils.DecimalSeparator  := '.';

  FAppPath := ExtractFilePath(Application.ExeName);
  FDrive   := FAppPath[1];
  FYear    := FormatDateTime('yyyy', Date);

  Ini := TIniFile.Create(FAppPath + 'Modhac.ini');
  FLastPath := Ini.ReadString('Paths', 'Path', '');
  FNE := Ini.ReadInteger('Geral', 'Numero de Execucoes', 0);
  inc(FNE);
  Ini.Free;

  FPSB.TemDados := False;

  if FErros = nil then
     begin
     FErros := TfoMessages.Create();
     FErros.FormStyle := fsStayOnTop;
     FAssistant := TAssistente.Create(Application);
     end;
end;

procedure TmhApplication.Finalize;
var Ini: TIniFile;
begin
  Ini := TIniFile.Create(FAppPath + 'Modhac.ini');
  if FLastPath <> '' then Ini.WriteString('Paths', 'Path', FLastPath);
  Ini.WriteDateTime('Geral', 'Ultima Execucao', Now);
  Ini.WriteInteger('Geral', 'Numero de Execucoes', FNE);
  Ini.Free;
  FErros.Free;
  FAssistant.Free;
end;

procedure TmhApplication.Run;
begin
  Application.Run;
end;

procedure TmhApplication.CreateForm(InstanceClass: TComponentClass; var Reference);
begin
  Application.CreateForm(InstanceClass, Reference);
end;

function TmhSubBacia.GetClassName: String;
begin
  Result := Self.ClassName;
end;

procedure TmhSubBacia.ToXML(Buffer: TStrings; Ident: Integer);
var x: TXML_Writer;
    i: Integer;
begin
  x := TXML_Writer.Create(Buffer, Ident);
  x.BeginIdent;
  x.BeginTag('DadosGerais');
    x.BeginIdent;
    with pDados.InfoGerais do
      begin
      x.Write('Area',       Area);
      x.Write('Mes',        Mes);
      x.Write('ExtVZO',     ExtVZO);
      x.Write('ExtPLU',     ExtPLU);
      x.Write('Ano',        Ano);
      x.Write('Titulo1',    Titulo1);
      x.Write('Titulo2',    Titulo2);
      x.Write('Titulo3',    Titulo3);
      x.Write('ArqPLU',     ArqPLU);
      x.Write('ArqETP',     ArqETP);
      x.Write('ArqVZO',     ArqVZO);
      x.Write('ArqVZC',     ArqVZC);
      x.Write('NomeArqEnt', NomeArqEnt);
      x.Write('N999PLU',    pDados.N999PLU);
      x.Write('Unidade',    pDados.Unidade);
      end;
    x.EndIdent;
  x.EndTag('DadosGerais');

  x.Write;

  x.BeginTag('Parametros');
    x.BeginIdent;
    for i := 1 to NParametros do
      with pDados.Parametros[i] do
        begin
        x.BeginTag('Parametro');
        x.BeginIdent;
          x.Write('Param',    Param);
          x.Write('ValsIni',  ValsIni);
          x.Write('ValsMin',  ValsMin);
          x.Write('ValsMax',  ValsMax);
          x.Write('PassoIni', PassoIni);
          x.Write('Precisao', Precisao);
        x.EndIdent;
        x.EndTag('Parametro');
        end;
    x.EndIdent;
  x.EndTag('Parametros');

  x.Write;

  x.BeginTag('DadosDeExecucao');
    x.BeginIdent;
    with pDados.ExecDados do
      begin
      x.Write('IntSim',   IntSim);
      x.Write('IntComp',  IntComp);
      x.Write('ExecMode', ExecMode);

      // Calibração
      x.Write('NStep',  NStep);
      x.Write('MaxIT',  MaxIT);
      x.Write('Iprint', Iprint);
      x.Write('FTol',   FTol);
      x.Write('FOpt',   FOpt);
      x.Write('QRef1',  QRef1);
      x.Write('QRef2',  QRef2);
      x.Write('BI',     BI);
      x.Write('BS',     BS);

      // Simulação
      x.Write('IQS', IQS);
      x.Write('RSP', RSP);
      x.Write('RSS', RSS);
      x.Write('RSB', RSB);
      x.Write('TS',  TS);
      x.Write('TB',  TB);
      end;
    x.EndIdent;
  x.EndTag('DadosDeExecucao');

  x.EndIdent;
  x.Free;
end;

procedure TmhSubBacia.FromXMLNodeList(NodeList: IXMLDOMNodeList);

  procedure LerDadosGerais(NodeList: IXMLDOMNodeList);
  begin
    with pDados.InfoGerais do
      begin
      Area           := StrToFloat(NodeList.NextNode.Text);
      Mes            := StrToInt(NodeList.NextNode.Text);
      ExtVZO         := StrToInt(NodeList.NextNode.Text);
      ExtPLU         := StrToInt(NodeList.NextNode.Text);
      Ano            := NodeList.NextNode.Text;
      Titulo1        := NodeList.NextNode.Text;
      Titulo2        := NodeList.NextNode.Text;
      Titulo3        := NodeList.NextNode.Text;
      ArqPLU         := NodeList.NextNode.Text;
      ArqETP         := NodeList.NextNode.Text;
      ArqVZO         := NodeList.NextNode.Text;
      ArqVZC         := NodeList.NextNode.Text;
      NomeArqEnt     := NodeList.NextNode.Text;
      pDados.N999PLU := StrToInt(NodeList.NextNode.Text);
      pDados.Unidade := StrToInt(NodeList.NextNode.Text);
      end;
  end;

  procedure LerParametros(NodeList: IXMLDOMNodeList);

    procedure LerParametro(NodeList: IXMLDOMNodeList; i: Integer);
    begin
      with pDados.Parametros[i] do
        begin
        Param    := NodeList.NextNode.Text;
        ValsIni  := StrToFloat(NodeList.NextNode.Text);
        ValsMin  := StrToFloat(NodeList.NextNode.Text);
        ValsMax  := StrToFloat(NodeList.NextNode.Text);
        PassoIni := StrToFloat(NodeList.NextNode.Text);
        Precisao := StrToFloat(NodeList.NextNode.Text);
        end;
    end;

  var i: Integer;
  begin
    for i := 1 to NParametros do
      LerParametro(NodeList.NextNode.childNodes, i);
  end;

  procedure LerDadosDeExecucao(NodeList: IXMLDOMNodeList);
  begin
    with pDados.ExecDados do
      begin
      IntSim   := StrToInt(NodeList.NextNode.Text);
      IntComp  := StrToInt(NodeList.NextNode.Text);
      ExecMode := StrToInt(NodeList.NextNode.Text);

      // Calibração
      NStep  := StrToInt(NodeList.NextNode.Text);
      MaxIT  := StrToInt(NodeList.NextNode.Text);
      Iprint := StrToInt(NodeList.NextNode.Text);
      FTol   := StrToFloat(NodeList.NextNode.Text);
      FOpt   := StrToInt(NodeList.NextNode.Text);
      QRef1  := StrToFloat(NodeList.NextNode.Text);
      QRef2  := StrToFloat(NodeList.NextNode.Text);
      BI     := StrToFloat(NodeList.NextNode.Text);
      BS     := StrToFloat(NodeList.NextNode.Text);

      // Simulação
      IQS := StrToInt(NodeList.NextNode.Text);
      RSP := StrToFloat(NodeList.NextNode.Text);
      RSS := StrToFloat(NodeList.NextNode.Text);
      RSB := StrToFloat(NodeList.NextNode.Text);
      TS  := StrToFloat(NodeList.NextNode.Text);
      TB  := StrToFloat(NodeList.NextNode.Text);
      end;
  end;

begin
  LerDadosGerais(NodeList.nextNode.childNodes);
  LerParametros(NodeList.nextNode.childNodes);
  LerDadosDeExecucao(NodeList.nextNode.childNodes);
  ColocaValoresIniciaisNoHistorico();
end;

procedure TmhApplication.ShowDemoMessage();
begin
  Dialogs.MessageDLG('Esta é uma versão de demostração do Programa Modhac.'#13 +
                     'Algumas capacidades estão limitadas.',
                      mtInformation, [mbOk], 0);
end;

{ TmhDataSetNode }

procedure TmhDataSetNode.FromXMLNodeList(NodeList: IXMLDOMNodeList);
begin
  inherited;
  if FileExists(FFileName) then
     try
       FObj := TwsDataSet.LoadFromFile(FFileName);
     except
       ShowMessage('Não foi possível a leitura dos dados'#13 + FFileName);
     end
  else
     ShowMessage('Arquivo inexistente:'#13 + FFileName);
end;

function TmhDataSetNode.getDataSet: TwsDataSet;
begin
  Result := TwsDataSet(FObj);
end;

function TmhDataSetNode.getFileName: String;
begin
  Result := getDataSet.FileName;
end;

procedure TmhDataSetNode.SaveToFile(const FileName: String);
begin
  inherited;
  DataSet.SaveToFile(FileName);
end;

{ TmhSubBaciaNode }

procedure TmhSubBaciaNode.FromXMLNodeList(NodeList: IXMLDOMNodeList);
var s: String;
begin
  inherited;
  FObj := TmhSubBacia.Create;
  TmhSubBacia(FObj).Node := Self;

  if FileExists(FFileName) then
     try
       TmhSubBacia(FObj).LoadFromFile(FFileName);
     except
       on E: exception do
          ShowMessage('Não foi possível a leitura da Sub-Bacia'#13 + FFileName + #13 + E.Message);
     end
  else
     ShowMessage('Arquivo inexistente:'#13 + FFileName);
end;

function TmhSubBaciaNode.getSB: TmhSubBacia;
begin
  Result := TmhSubBacia(FObj);
end;

procedure TmhSubBaciaNode.SaveToFile(const FileName: String);
begin
  inherited;
  SubBacia.SaveToFile(FileName);
end;

{ TmhBaseNode }

constructor TmhBaseNode.Create(aProject: TmhProject; aObject: TObject);
begin
  inherited Create;
  FProject := aProject;
  FProject.Modified := True;
  FObj := aObject;
end;

destructor TmhBaseNode.Destroy;
begin
  FObj.Free;
  inherited;
end;

function TmhBaseNode.GetClassName: String;
begin
  Result := self.ClassName;
end;

function TmhBaseNode.getRelativeFileName: String;
begin
  Result := ExtractRelativePath(FProject.Path, getFileName);
end;

function TmhBaseNode.GetObjectReference: TObject;
begin
  Result := Self;
end;

procedure TmhBaseNode.ToXML(Buffer: TStrings; Ident: Integer);
var s: String;
begin
  s := StringOfChar(' ', Ident) + '  ';
  Buffer.Add(s + '<FileName>' + getRelativeFileName + '</FileName>');
end;

procedure TmhBaseNode.FromXMLNodeList(NodeList: IXMLDOMNodeList);
begin
  // Servirá de base para a leitura dos objetos
  FFileName := ExpandFileName(NodeList.nextNode.text);
end;

procedure TmhBaseNode.SaveToFile(const FileName: String);
begin
  FFileName := FileName;
  FProject.Modified := True;
end;

function TmhBaseNode.getFileName: String;
begin
  Result := FFileName;
end;

function TmhBaseNode.ToString: String;
begin
  Result := '';
end;

{ TmhProject }

constructor TmhProject.Create;
begin
  inherited Create(self, nil);
end;

procedure TmhProject.FromXMLNodeList(NodeList: IXMLDOMNodeList);
var no: IXMLDOMNode;
begin
  inherited;

  no := NodeList.nextNode();
  while (no <> nil) do
    begin
    if CompareText(no.nodeName, 'ProjectName') = 0 then
       FProjectName := no.text else

    if CompareText(no.nodeName, 'DelOutPutFiles') = 0 then
       FDelOutPutFiles := Boolean(StrToInt(no.text));

    no := NodeList.nextNode();
    end;
end;

procedure TmhProject.ToXML(Buffer: TStrings; Ident: Integer);
var s: String;
begin
  inherited;
  s := StringOfChar(' ', Ident + 2);
  Buffer.Add(s + '<ProjectName>' + FProjectName + '</ProjectName>');
  Buffer.Add(s + '<DelOutPutFiles>' + IntToStr(byte(FDelOutPutFiles)) + '</DelOutPutFiles>');
end;

Initialization
  mhApplication := TmhApplication.Create;

Finalization
  mhApplication.Free;

end.


