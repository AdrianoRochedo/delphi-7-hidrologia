unit Hi_Const;

interface
uses SysUtils, Messages;

Const
   NParametros        = 14;    {N�mero de par�metros}
   Aspa               = #39 ;

{Tipos Globais}
Type
   TInfoGerais        = Packed Record
                          Area        : Real48;
                          Mes         : Byte;
                          ExtVZO      : Longint;
                          ExtPLU      : Longint;
                          Ano         : String[04];
                          Titulo1     : String[80];
                          Titulo2     : String[80];
                          Titulo3     : String[80];
                          ArqPLU      : String[12];
                          ArqETP      : String[12];
                          ArqVZO      : String[12];
                          ArqVZC      : String[12];
                          NomeArqEnt  : String[80];
                        End;

   TParamDados        = Packed Record
                          Param    : String[4];
                          ValsIni  : Real48;
                          ValsMin  : Real48;
                          ValsMax  : Real48;
                          PassoIni : Real48;
                          Precisao : Real48;
                        End;

  TTabParamDados      = Packed Array[1..NParametros] of TParamDados;

  TExecDados          = Packed Record
                          IntSim   : Byte;
                          IntComp  : Byte;
                          ExecMode : Byte;

                          {Calibra��o}
                               NStep  : Smallint;
                               MaxIT  : Smallint;
                               Iprint : Smallint;
                               FTol   : Real48;
                               FOpt   : Byte;
                               QRef1  : Real48;
                               QRef2  : Real48;
                               BI     : Real48;
                               BS     : Real48;

                          {Simula��o}
                               IQS    : Word;
                               RSP    : Real48;
                               RSS    : Real48;
                               RSB    : Real48;
                               TS     : Real48;
                               TB     : Real48;
                        End;

  TDadosDaBacia       = Packed Record
                          InfoGerais : TInfoGerais;
                          Parametros : TTabParamDados;
                          ExecDados  : TExecDados;
                          N999PLU    : Longint; {N�mero de separadores do arquivo de Chuvas = -999}
                          Unidade    : Byte; { 0 - mm, 1 - m3/s}
                        End;

  pTDadosDaBacia      = ^TDadosDaBacia;

  TParametros         = Packed Record
                          TemDados   : Boolean;
                          Parametros : TTabParamDados;
                          ExecDados  : TExecDados;
                        end;  
Const
  DIARIO = 0;
  MENSAL = 1;

  cMAX   = 100;
  cPLU   = 1;    {�ndice da coluna do Conjunto de dados}
  cVZO   = 2;    {Idem}
  cVZC   = 3;    {Idem}

  ParamNames : Array [1..NParametros] of String[4] =
    ('RSPX','RSSX','RSBX','RSBY','IMAX','IMIN','IDEC',
     'ASP ','ASS ','ASBX','ASBY','PRED','CEVA', 'CHET');

  Aux000 = 'Capacidade m�xima do reservat�rio ';
  Aux111 = 'Expoente da lei de esvaziamento do reservat�rio ';
  Aux222 = 'Efetivos no ajuste das curvas de recess�o do hidrograma';
  ParamHints : Array [1..NParametros] of String[65] =
    (Aux000 + 'superficial',
     Aux000 + 'sub-superficial',
     Aux000 + 'subterr�neo',
     Aux222,
     'Permeabilidade do solo',
     'Infiltra��o m�nima',
     'Coeficiente de infiltra��o',
     Aux111 + 'superficial',
     Aux111 + 'sub-superficial',
     Aux111 + 'subterr�neo',
     Aux222,
     'Corre��o da precipita��o',
     'Par�metro da lei de evapotranspira��o do solo',
     'Fra��o da evapotranspira��o potencial');

  cNomeColunas : Array [1..11] of String[15] =
  ('PRECIPITACAO',
   'VAZAO_OBS',
   'VAZAO_CAL',
   'ETP_POTENCIAL',
   'ETP_SUPERFICIE',
   'ETP_SUBSOLO',
   'ETP_TOTAL',
   'UM_SUPERFICIE',
   'UM_SUBSOLO',
   'UM_AQUIFERO',
   'PROFUNDA');

  {Contextos de Help}
  hcSaveError          = 0;
  hcLoadParamsError    = 1;
  hcSubBacError        = 2;
  hcN999PLUError       = 3;

  {Mensagens de Erro}
  eAux                 = 'Este n�o � um arquivo v�lido de ';
  eSaveError           = 'N�o foi poss�vel salvar o arquivo !';
  eLoadError           = 'N�o foi poss�vel ler o arquivo <%s>';
  eLoadResError        = eLoadError + ' de resultados';
  eLoadParamsError     = eAux + 'par�metros';
  eLoadSubBacError     = eAux + 'uma Sub-Bacia';
  eN999PLUError        = 'Os arquivos de Chuvas e Vaz�es Obeservadas'#13 +
                         'est�o incompat�veis entre si.'#13 +
                         'Por favor, selecione corretamente os arquivos.';

  eIntCompError        = 'Erro na especifica��o do Intervalo de Computa��o';
  eIntSimError         = 'Erro na especifica��o do Intervalo de Simula��o';
  eDSPlotError         = 'N�o foi poss�vel plotar este conjunto de dados !!';
  eDSPlotError1        = eDSPlotError + #13'Ele n�o possui dados ou registros';
  eDSPlotError2        = eDSPlotError + #13'Estrutura incorreta';

  {Assistente}
  msgDTModific         = 'Dados modificados';

  {Di�logos}
  dlgModificGeral      = 'Os dados foram modificados.'#13 +
                         'Voc� confirma os novos valores ?';

  dlgConfirmClose      = 'Voc� realmente quer fechar ';

  dlgSubBacChange      = 'A Sub-Bacia: '#13'%s'#13 +
                         'foi modificada. Deseja salv�-la ?';

  dlgFileExist         = 'O arquivo: %s'#13 +
                         'j� existe. Sobreescrevo-o ?';

  {Strings}
  gsIdentificacao      = 'Dados F�sicos e de Identifica��o';
  gsVazoesOBS          = 'Vaz�es Observadas (Postos)';
  gsConjDados          = 'Conjunto de Dados';
  gsNomeDoArq          = ' Nome do Arquivo: ';
  gsModHacFile         = 'Modhacdw.exe';

  {Mensagens}
  WM_ExecModeChange    = WM_USER + 1000;  {Comunica a mudan�a do modo de execu��o}
  WM_SubBacDataChange  = WM_USER + 1001;  {Comunica a mudan� dos dados de uma Sub-Bacia}
  WM_DataSetChange     = WM_USER + 1002;  {Comunica a mudan� dos dados de uma DataSet}
  WM_SubBacClick       = WM_USER + 1010;  {Comunica uma sele��o de SubBacia}
  WM_DatasetClick      = WM_USER + 1011;  {Comunica uma sele��o de um DataSet}
  WM_OutrosClick       = WM_USER + 1012;  {Comunica uma sele��o de outros}

  {Comandos da linguagem de projeto}
  cpSubBacia           = 'SUBBACIA';
  cpDataSet            = 'DATASET';
  cpTitle              = 'TITULO';
  cpRaiz               = 'RAIZ';

  cMinQuad             = 1;
  cFatorModulacao      = 2;
  cValorABS            = 3;
  cLogaritmica         = 4;

  {Constantes que definem a Fun��o Objetivo}
  csMinQuad            = 'Min. Quadrados';
  csFatorModulacao     = 'Fator de Modula��o';
  csValorABS           = 'Valor Absoluto';
  csLogaritmica        = 'Logar�tmica';

  cCalibracao          = 1;
  cVerificacao         = 2;
  cSimulacao           = 3;
  cAcompanhamento      = 4;

  cMM                  = 0;
  cM3s                 = 1;

implementation

end.

