      PROGRAM MODHACDW 
c      - (DW = executável DOS para versão WINDOWS)
C  /=========================================================30/08/2001==\
C ||                                                                    ||
C ||    MODIFICACOES FEITAS PARA A VERSAO FOR WINDOWS                   ||
C ||    complementações cosméticas introduzidas desde a versão de 1998  ||
C ||                                                                    ||
C ||    VERSAO   PARA O SAGBAH :                                        ||
C ||    SISTEMA DE APOIO AO GERENCIAMENTO DE BACIAS HIDROGRAFICAS       ||
C ||    Incorpora opcao de computacao mensal e novo parametro de hetero-||
C ||    geneidade temporal de chuva - CHET                              ||
C ||--------------------------------------------------------------------||
C ||    Este programa gera as contribuicoes hidricas difusas a uma secao||
C ||    fluvial que define uma bacia hidrografica em funcao das chuvas e||
C ||    evaporacoes conhecidas. Eventualmente podera calibrar os parame-||
C ||    tros do modelo quando forem fornecidas vazoes observadas.       ||
C  \---------------------------------------------------------------------/
C  |                                                                     |
C  |    O PROGRAMA E' COMPOSTO PELOS SEGUINTES APLICATIVOS :             |
C  |                                                                     |
C  |    PROGRAMA PRINCIPAL : MODHAC - ENTRADA DE INSTRUCOES DE EXECUCAO  |
C  |                                 DADOS E INICIO DA EXECUCAO          |
C  |                                                                     |
C  |    SUBROTINA FUNCAO   : ORGANIZACAO DOS ARQUIVOS DE DADOS PARA A    |
C  |                         EXECUCAO DA SUBROTINA MODELO.               |
C  |                                                                     |
C  |    SUBROTINA MODELO   : CEREBRO DO MODELO MODHAC - REALIZA O BALAN- |
C  |                         CO HIDRICO COMPUTANDO ESCOAMENTOS.          |
C  |                                                                     |
C  |    SUBROTINA ROSEN    : SUBROTINA PARA CALIBRACAO AUTOMATICA DE     |
C  |                         PARAMETROS DO MODELO.                       |
C  |                                                                     |
C  +---------------------------------------------------------------------+

C  /---------------------------------------------------------------------\
C  |    DICIONARIO                                                       |
C  |                                                                     |
C  |    INTERVALO DE SIMULACAO : INTERVALO DURANTE O QUAL SAO ACUMULADAS |
C  |                             AS VAZOES CALCULADAS PELO MODELO : N    |
C  |                                                                     |
C  |    INTERVALO DE COMPUTACAO: INTERVALO NO QUAL SAO COMPUTADOS OS     |
C  |                             BALANCOS HIDRICOS, EM GERAL MENOR QUE   |
C  |                             O INTERVALO DE SIMULACAO                |
C  |                                                                     |
C  |    EXEMPLO : INTERVALO DE SIMULACAO MENSAL                          |
C  |              INTERVALO DE COMPUTACAO DIARIO                         |
C  |                                                                     |
C  |    ESSES INTERVALOS SAO ESTABELECIDOS NO ARQUIVO DE PRECIPITACOES : |
C  |    QUANDO FOR ENCONTRADO UM VALOR -999, INTERPRETA-SE COMO O FINAL  |
C  |    DE UM INTERVALO DE SIMULACAO. OS DEMAIS VALORES DE PRECIPITACAO  |
C  |    DEVERAO SER FORNECIDOS A CADA INTERVALO DE COMPUTACAO. QUANDO    |
C  |    HOUVER SEQUENCIA DE K DIAS SEM CHUVA, PODE SER OPCIONALMENTE     |
C  |    DIGITADO - K. NOTAR QUE, POR ESSA SISTEMATICA, OS INTERVALOS DE  |
C  |    SIMULACAO PODERAO SER VARIAVEIS, EM TERMOS DO NUMERO DE INTERVA- |
C  |    LOS DE COMPUTACAO QUE OS COMPOEM.                                |
C  |                                                                     |
C  |    Indices :                                                        |
C  |                                                                     |
C  |    I, I = 1,...,N : Intervalos de simulacao.                        |
C  |                                                                     |
C  |    DADOS DE ENTRADA : VARIAVEIS EXOGENAS  EM MM/INTERVALO DE COMPU- |
C  |                       TACAO                                         |
C  |    QO(I), I=1,...,N : VAZAO OBSERVADA NOS INTERVALOS DE SIMULACAO I,|
C  |                      EM MM                                          |
C  |    AREA     AREA DE DRENAGEM DA BACIA (usada na transformacao de va-|
C  |             zoes de mm em m3/s) - ADMITE-SE QUE INTERVALO DE COMPU- |
C  |             TACAO E' O DIA - SE NAO FOR ADAPTAR DE ACORDO           |
C  |                                                                     |
C  |    IOP : Opcao de execucao                                          |
C  |                            1 - calibracao                           |
C  |                            2 - verificacao                          |
C  |                            3 - simulacao                            |
C  |                            4 - acompanhamento                       |
C  |    X(J), j= 1,...,14 : parametros de calibracao                     |
C  |                                                                     |
C  |    QRE1,QREF2: limites de vazoes entre as quais os parametros sao   |
C  |               calibrados; se ambos sao 0, todas as vazoes sao usadas|
C  |                                                                     |
C  |    VARIAVEIS DE SAIDA EM MM/INTERVALO DE COMPUTACAO                 |
C  |                                                                     |
C  |    QC(I)   ESCOAMENTO CALCULADO PARA A BACIA COMPOSTO POR           |
C  |    ES      ESCOAMENTO SUPERFICIAL                                   |
C  |    EB      ESCOAMENTO DE BASE                                       |
C  |            gravado como m3/s no arquivo dado                        |
C  |                                                                     |
C  |    ESP     EVAPOTRANSPIRACAO DO RESERVATORIO SUPERFICIAL            |
C  |    ESS     EVAPOTRANSPIRACAO DO RESERVATORIO SUBSUPERFICIAL         |
C  |                                                                     |
C  |    VARIAVEIS DE ESTADO EM MM/INTERVALO DE COMPUTACAO                |
C  |                                                                     |
C  |    RSP     ALTURA DE AGUA NO RESERVATORIO SUPERFICIAL               |
C  |    RSS     ALTURA DE  AGUA DO RESERVATORIO SUBSUPERFICIAL           |
C  |    RSB     ALTURA DE AGUA NO RESERVATORIO SUBTERRANEO               |
C  |                                                                     |
C  |    PARAMETROS : VER SUBROTINA MODELO                                |
C  |                                                                     |
C  |    REFERENCIA : LANNA, A.E E MIRIAM SCHWARZBACH (1989).             |
C  |                 MODHAC - MODELO HIDROLOGICO AUTO-CALIBRAVEL         |
C  |                 MANUAL DO USUARIO                                   |
C  |                 RECURSOS HIDRICOS, PUBLICACAO 21                    |
C  |                 PROGRAMA DE POS-GRADUACAO EM RECURSOS HIDRICOS E    |
C  |                 SANEAMENTO, INSTITUTO DE PESQUISAS HIDRAULICAS,UFRGS|
C  |                                                                     |
C  |    ARQUIVOS UTILIZADOS                                              |
C  |   CODIGO  VARIAVEL    CONTEUDO                                      |
C  |     10                  INSTRUCOES DE EXECUCAO - LE                 |
C  |     11      ARQU2       PRECIPITACOES - LE                          |
C  |     12      ARQU3       EVAPOTRANSPIRACOES POTENCIAIS - LE          |
C  |     13      ARQU4       VAZOES OBSERVADAS - LE                      |
C  |     14      ARQU5       VAZOES CALCULADAS - GRAVA                   |
C  |     15                  RESULTADOS - GRAVA                          |
c  |                                                                     |
c  |      Modificacoes Realizadas Para a Versao For Windows              |  
c  |                                                                     |
c  |  Arquivos Utilizados                                                |
c  |  Codigo   Nome        Conteudo                                      |
c  |    16  ARQU6   Tabela com todos os resultados:como intervalo,|
c  |                       chuva, Vazao Obser, Vazao Calc, Umidades, etc.|
c  |                       (Aresentada em colunas e sem Titulo           |
c  |                                                                     |
c  |   17  ARQU7     Os valores finais de cada parametro de cali-  |
c  |                       bracao (apenas para a opcao CALIBRACAO)       |
c  |
c  |
c  |
c  |
c  |
c  |
C  \---------------------------------------------------------------------/

	INTEGER FOPT
	CHARACTER*80 TEXTO
	CHARACTER*80 ARQU2, ARQU3, ARQU4, ARQU5, ARQU6, ARQU7
	CHARACTER*80 RIO,SEC,PER,SIM,COM
	CHARACTER*4 APAR(14),UPAR(14)
	CHARACTER*14 AFOPT(4)
	DIMENSION PD(20000),ETPM(5000),QO(5000),QC(5000)
	DIMENSION X(14),E(14),ETOL(14),XMIN(14),XMAX(14)
	DIMENSION XX(14),EE(14),EETOL(14),XXMIN(14),XXMAX(14)

	DATA APAR/'RSPX','RSSX','RSBX','RSBY','IMAX','IMIN','IDEC',
     1' ASP',' ASS',' ASB','ASBY','PRED','CEVA','CHET'/
	DATA AFOPT/'Min. Quadrados','Modulada','Valor Absoluto',
	+'Logarítmica'/
C     LEITURA DE INSTRUCOES VIA ARQUIVO
1     FORMAT (A)
C     LEITURA DE INSTRUCOES DE EXECUCAO
	OPEN (10,FILE=' ',STATUS='OLD')

C     Leitura da dados : bacia, simulacao e nome dos arquivos
	READ(10,*) RIO,SEC,AREA,PER,SIM,COM,ARQU2,ARQU3,ARQU4,ARQU5
	READ(10,*) ARQU6,ARQU7

C     Leitura do numero de intervalos de computacao, simulacao, 
C     dos valores iniciais dos parametros, seus limites, etc ...
	READ(10,*) NP, N, X, XMIN, XMAX, E, ETOL

C     Leitura da opcao sobre intervalo de computacao
C     ITCP   = 0 --> diario
C     ITCP nao 0 --> mensal
	READ(10,*) ITCP
	IF (ITCP .NE. 0) READ(10,*) IANO,MES
	MES = MES - 1 ! Decrementa mes para correto posicionamento adiante
C     Leitura da opcao de execucao
	READ(10,*) IOP

C     Se nao for calibracao pule entrada de controle de calibracao
	IF(IOP.NE.1) GOTO 5

C     Opcoes para calibracao automatica       
	READ(10,*) NSTEP,MAXIT,IPRINT,FTOL,FOPT,QREF1,QREF2,IQS

C     Testa se opcao e' acompanhamento
5     IF(IOP.EQ.4) IPRINT = -1

C     Leitura das condicoes iniciais
	READ(10,*) RSP, RSS, RSB, LS, LB
	
C     OBSERVA LIMITES MAXIMOS DOS ESTADOS INICIAIS
1850  IF(RSP.GT.X(1)) RSP = X(1)
	IF(RSS.GT.X(2)) RSS = X(2)
	IF(RSB.GT.X(3)) RSB = X(3)

C      IMPRESSAO DA EXECUCAO NO ARQUIVO NOMEADO 'Arquivo 15'

C     ABERTURA DO ARQUIVO 'S_RESULT.TXT'        'Arquivo 16'   
	OPEN(15,FILE=' ',STATUS='UNKNOWN')
      OPEN(16,FILE=ARQU6,STATUS='UNKNOWN')
      
	WRITE(15,10)
10    FORMAT(/9X,60(1H-),//9X,22(1H*),5X,'MODHAC',5X,22(1H*)/
     1 15X,'MODELO HIDROLOGICO MODHAC '//
     2 15X,'desenvolvido por'/
     3 15X,'Antonio Eduardo Lanna e Miriam Schwarzbach'/
     4 15X,'INSTITUTO DE PESQUISAS HIDRAULICAS DA UFRGS'/)

	WRITE(15,49) RIO,SEC,AREA,PER,SIM,N,COM,NP
49    FORMAT(/1X,60(1H-)/' IDENTIFICACAO DO PROBLEMA'/
     1'  Curso de agua    : ', A /
     2'  Secao fluvial    : ', A /
     3'  Area de drenagem : ', F8.1,' Km2'//
     4'  Periodo          : ', A /
     5'  Intervalo de simulacao            : ', A/ 
     6'  Numero de intervalos de simulacao : ',I4/
     7'  Intervalo de computacao           : ', A/ 
     8'  Tamanho arquivo de chuvas         : ',I5/1X,60(1H-)/)

	WRITE(15,92) ARQU2, ARQU3
92    FORMAT(/1X,60(1H-)/
     3'  Nome arquivo de chuvas     : ', A /
     4'  Nome arquivo ET Potencial  : ', A )
 
	IF (IOP.LE.2) WRITE(15,95) ARQU4
95    FORMAT('  Nome arquivo de vazoes     : ',A)

	WRITE(15,145)(APAR(I),X(I),XMIN(I),XMAX(I),E(I),ETOL(I),I=1,14)
145   FORMAT(/1X,54(1H-)/' MODHAC : PARAMETROS DESTA SIMULACAO
     1'/7X,' VALOR ',4X,' MIN.',6X,' MAX.',4X,'PASSO ',5X,'PREC.'/
     2  1X,A,5(1X,1H|,F8.4)/1X,A,5(1X,1H|,F8.4)/1X,A,5(1X,1H|,F8.4)/
     3  1X,A,5(1X,1H|,F8.4)/1X,A,5(1X,1H|,F8.4)/1X,A,5(1X,1H|,F8.4)/
     4  1X,A,5(1X,1H|,F8.6)/1X,A,5(1X,1H|,F8.6)/1X,A,5(1X,1H|,F8.6)/
     5  1X,A,5(1X,1H|,F8.6)/1X,A,5(1X,1H|,F8.4)/1X,A,5(1X,1H|,F8.4)/
     6  1X,A,5(1X,1H|,F8.4)/1X,A,5(1X,1H|,F8.4)/1X,54(1H-))

	IF(IOP.NE.1) GOTO 130
	WRITE(15,1800)MAXIT,IPRINT,FTOL
1800  FORMAT(/' CONTROLE DO PROCEDIMENTO AUTOMATICO DE CALIBRACAO',
     1/' NUMERO MAXIMO DE SIMULACOES     : ',I4/
     2 ' SIMULACOES ENTRE LISTAGENS      : ',I4/
     3 ' PRECISAO MINIMA DA F.O.         : ',F10.3/)

	IF(FOPT.EQ.2) WRITE(15,182) QREF1,QREF2
182   FORMAT(' FUNCAO-OBJETIVO MODULADA'/' AJUSTE ENTRE ',
     11PG12.4,'mm e ',1PG12.4,' mm de lamina de agua')
	IF(FOPT.EQ.3) WRITE (15,18) QREF1,QREF2
18    FORMAT(' FUNCAO-OBJETIVO VALOR ABSOLUTO'/' AJUSTE ENTRE ',
     11PG12.4,'mm e ',1PG12.4,' mm de lamina de agua')
	IF(FOPT.EQ.1) WRITE (15,181) QREF1,QREF2
181   FORMAT(' FUNCAO-OBJETIVO MINIMOS QUADRADOS'/' AJUSTE ENTRE ',
     11PG12.4,'mm e ',1PG12.4,' mm de lamina de agua')
	IF(FOPT.EQ.4) WRITE(15,1815) QREF1,QREF2
1815  FORMAT(' FUNCAO OBJETIVO LOGARITIMICA'/' AJUSTE ENTRE ',
     11PG12.4,'mm e ',1PG12.4,' mm de lamina de agua')
	IF(NSTEP.EQ.0) WRITE(15,183) 
183   FORMAT(/' PASSO INICIAL DE VARIACAO MANTIDO A CADA ROTACAO')
	IF(NSTEP.NE.0.) WRITE (15,184)
184   FORMAT(/' PASSO FINAL DO ESTAGIO = PASSO INICIAL APOS ROTACAO')
130   WRITE(15,194) LS,LB,RSP,RSS,RSB
194   FORMAT(/1X,60(1H-)//' CONDICOES SUPLEMENTARES E INICIAIS'/
     1' RETARDO DOS ESCOAMENTOS'/
     2'                         SUPERFICIAL ... ',I2/
     3'                         SUBTERRANEO ... ',I2/
     4' RESERVAS INICIAIS DE UMIDADE NA BACIA'/
     5'                   RESERVA SUPERFICIAL ...... ',F6.1/
     6'                   RESERVA SUBSUPERFICIAL ... ',F6.1/
     7'                   RESERVA SUBTERRANEA ...... ',F6.1/)

C     INICIO DA EXECUCAO EFETIVA

C     LEITURA DOS ARQUIVOS DE DADOS
131   LE = 1
	WRITE(*,*) ' Lendo arquivos de dados'

C     Le arquivo de chuvas
      OPEN(11,FILE=ARQU2,STATUS='OLD')
	WRITE(*,1301) ARQU2
1301  FORMAT(' -----> ',A)
	READ(11,*) (PD(I), I=1,NP)
	do 135 i=1,np                                    ! Corrige possível erro 
      if(pd(i).le.0.0 .and. pd(i).gt.-1.) pd(i) = 0.0  ! de aproximação do 
135	continue										 ! valor nulo de chuva

C     Le arquivo de ETPM
	OPEN(12,FILE=ARQU3,STATUS='OLD')
	WRITE(*,1301) ARQU3
	READ(12,*) (ETPM(I),I=1,N)

136   IF(IOP.EQ.3) GO TO 140
	OPEN(13,FILE=ARQU4,STATUS='OLD')
	WRITE(*,1301) ARQU4
137   READ(13,*) (QO(I), I = 1, N)      ! Le vazoes observadas
	CLOSE (13)

	GOTO 205

C     ATRIBUI -999. AOS VALORES DE VAZOES OBSERVADAS INEXISTENTES
140   DO 141 I=1,N
	QO(I)=-999.
141   CONTINUE

C     Faz de XMAX(1) o identificador de opcao simulacao 
	XMAX(1) = -999.

205   IF (IOP .NE. 1) GO TO 221

	WRITE(*,*) ' Inicio da calibracao'

C     EXECUCAO NO STATUS DE CALIBRACAO
C     LE BANDAS PARA CONSIDERACAO DO AJUSTE DA VAZAO CALCULADA       
	READ(10,*) BI,BS
	CLOSE (10)

	WRITE(15,2020) BI,BS
2020  FORMAT(/10X,'BANDAS DE ACEITACAO DE ERRO DE AJUSTE'/
     1         10X,'BANDA INFERIOR = ', F10.3/
     2         10X,'BANDA SUPERIOR = ',F10.3/)

C     TESTA SE PARAMETRO DEVERA SER CALIBRADO (XMIN < XMAX)
	J=0
	DO 209 I=1,14
	IF(XMAX(I) .LE. 1.001 * XMIN(I) . OR. 
     1XMIN(I) .GE. 0.999 * XMAX(I)) GO TO 209
	J = J + 1
	XX(J)    =  X(I)
	EE(J)    =  E(I)
	EETOL(J) =  ETOL(I)
	XXMIN(J) =  XMIN(I)
	XXMAX(J) =  XMAX(I)
	UPAR(J)  =  APAR(I)
209   CONTINUE
	IF(J.EQ.0) GOTO 221

C     CONTROLE ASSUMIDO PELA SUBROTINA DE CALIBRACAO AUTOMATICA

	CALL ROSEN(J,XX,XXMIN,XXMAX,EE,EETOL,F,IPRINT,N,PD,ETPM,QO,QC,
     1           X,XMIN,XMAX,RSP,RSS,RSB,LS,LB,MAXIT,NSTEP,FOPT,QREF1,
     2           QREF2,FTOL,IQS,APAR,AREA,BI,BS,ITCP,IANO,MES,UPAR)

C     IMPRESSAO DOS RESULTADOS DA CALIBRACAO AUTOMATICA

	WRITE(15,213) (APAR(I),I=1,14), (X(I),I=1,14)
213   FORMAT(/' VALOR OTIMO DOS PARAMETROS'/1X,14(A,5X)/1x,14(1PG9.3))

	WRITE(15,218) AFOPT(FOPT),F
218   FORMAT(/' Valor otimo da funcao-objetivo (',A,') = ',1PG16.4)

C      Impressao do Arquivo 'S_PARAM.TXT' 
C      Neste arquivo contem os valores finais dos parametros de calibracao e Valor da Fobj
      IF(IOP.EQ.1) THEN
          OPEN(17,FILE=ARQU7,STATUS='UNKNOWN')
              WRITE(17,333) (X(I),I=1,14)
 333           FORMAT(1PG10.4)
               WRITE(17,444) F
444           FORMAT(1PG16.8)
          CLOSE(17)
      END IF

	GOTO 300

C     EXECUCAO NO STATUS NAO CALIBRACAO

221   DO 223 I=1,14
	XMIN(I) = XMAX(I)
	XX(I) = X(I)
223   CONTINUE

C     CONTROLE ASSUMIDO PELA SUBROTINA DE EXECUCAO DA SIMULACAO
	WRITE(*,*) ' Execucao da simulacao'
	
	CALL FUNCAO(N,PD,ETPM,QO,XX,F,IPRINT,X,XMIN,XMAX,RSP,RSS,RSB,LS,LB
     1,FOPT,QREF1,QREF2,QC,IQS,APAR,AREA,BI,BS,ITCP,IANO,MES)
C	WRITE(*,3000) FOPT,F,IQS
C3000  FORMAT(/' Valor da funcao-objetivo -  ',I1,'  = ', G14.7/
C     1' no periodo de aquecimento ',I3) 

C     GRAVACAO DOS ESCOAMENTOS CALCULADOS NO ARQUIVO NOMEADO EM ARQU5  

300   OPEN(14,FILE=ARQU5,STATUS='UNKNOWN')
	WRITE(14,6000) (QC(I),I=1,N)
6000  FORMAT(12F8.2)
	CLOSE (14)
	STOP

7000  READ(10,*) TEXTO
	WRITE(*,7001) TEXTO
7001  FORMAT(' ERRO NA LEITURA DO ARQUIVO ' /' PROXIMA LINHA :'/
     1        A/' EXECUCAO ABORTADA !')
	STOP
	END

C****************************************************************************
  SUBROUTINE FUNCAO(N,PD,ETPM,QO,XX,F,IPRINT,X,XMIN,XMAX,RSPO,RSSO,
  1                 RSBO,LS,LB,FOPT,QREF1,QREF2,QSAL,IQS,APAR,AREA,
  2                 BI,BS,ITCP,IANO,MES)

C     UTILIZADA NO PROGRAMA MODHAC
C     SEU OBJETIVO E' (1). ESTRUTURAR OS DADOS DE PRECIPITACAO, VAZAO E
C                          EVAPOTRANSPIRACAO POTENCIAL ;
C                     (2). PROCESSAR O BALANCO HIDRICO NA SUBROTINA MODELO;
C                     (3). COMPUTAR INDICES DE AJUSTE;
C                     (4). IMPRIMIR RESULTADOS.

	CHARACTER*4 APAR(14)
	INTEGER FOPT
	DIMENSION X(14),XMIN(14),XMAX(14),PD(20000),ETPM(5000),
     1          QO(5000),XX(14),QSAL(5000),IDMES(12)

	DATA KEY /0/
	DATA IDMES /31,28,31,30,31,30,31,31,30,31,30,31/

C     SE AREA = 0.0 FACA-A PEQUENA MAS NAO NULA PARA EVITAR 'OVERFLOW'
	IF(AREA.EQ.0.0) AREA = 1.
	
	IF (KEY.NE.0 .OR. XMAX(1) .EQ. -999.) GOTO 200
	
C     CALCULA MEDIA DAS VAZOES OBSERVADAS
	KEY   =  1
	QMO   =  0.
	SOMO  =  0.
	SOMOL =  0.
	J     =  0
	I1    =  IQS + 1
	DO 103 I = I1,N
	IF(QO(I) .LT. 0.) GOTO 103
	J    =  J + 1
	SOMO =  SOMO + QO(I)
	SOMOL = SOMOL + LOG(QO(I)+0.0001)
103   CONTINUE
	IF(J .EQ. 0) GOTO 200
	QMO = SOMO/J
	QMOL = SOMOL/J

C     CALCULA QUADRADO DA DISPERSAO DAS VAZOES OBSERVADAS
	SOMO = 0.
	SOMOL = 0.
	DO 104 I = I1, N
	IF(QO(I) .LT. 0.) GOTO 104
	SOMO = SOMO + (QO(I)-QMO)**2
	SOMOL = SOMOL + (LOG(QO(I)+0.0001)-QMOL)**2
104   CONTINUE

C     RECUPERA VALORES DOS PARAMETROS
200   KP = 0
	DO 244 I = 1,14
	IF(XMAX(I) . LE . 1.001 * XMIN(I) . OR .
     1   XMIN(I) . GE . 0.999 * XMAX(I)) GO TO 244
	KP = KP + 1
	X(I) = XX(KP)
244   CONTINUE 
	
C     INICIALIZACAO DOS ESTADOS INICIAIS E DE PARAMETROS DE EXECUCAO
	RSP    =  AMIN1(RSPO,X(1))
	RSS    =  AMIN1(RSSO,X(2))
	RSB    =  AMIN1(RSBO,X(3))
	ESA    =  0.
	EBA    =  0.
	KKK    =  0
	TQO    =  0.    
	TPO    =  0.
	TQC    =  0.
	TTETP  =  0.
	TTESS  =  0.
	TTETPR =  0.
	TTESP  =  0.

	QPQ    =  0.0
	F1     =  0.0
	F2     =  0.0
	F3     =  0.0 
	F4     =  0.0
	K      =  0

C     VERIFICA SE DEVERA' SER IMPRESSO RESULTADO DESSA EXECUCAO
	IF (IPRINT.NE.0) GO TO 275

C     IMPRESSAO NORMAL DA SIMULACAO A CADA INTERVALO 
	WRITE(15,264)(APAR(I),X(I),I=1,14)
264   FORMAT(/1X,116(1H*)/' MODHAC : RESULTADOS OBTIDOS'
     1/' PARAMETROS USADOS NESTA SIMULACAO'/7(1X,A,'=',F10.4),/,
     2 7(1X,A,'=',F10.4)/1X,116(1H*))

	WRITE(15,270)
270   FORMAT('     ',4X,'CHUVA',6X,'VAZAO',6X,'VAZAO',15X,
     1 'EVAPOTRANSPIRACOES',23X,'UMIDADES',16X/
     2 41X,39(1H-),4X,30(1H-)/22X,'OBS',8X,'CAL',5X,'POTENCIAL',
     3 2X,'SUPERFICIE',3X,'SUBSOLO',2X,' TOTAL',4X,'SUPERFICIE',
     4 2X,'SUBSOLO',3X,'AQUIFERO')
	
C     VERIFICA SE HAVERA' DETALHAMENTO DAS COMPUTACOES (OPCAO VERIFICACAO)
275   IF(IPRINT.GE.0) GO TO 283

C     DETALHAMENTO DAS COMPUTACOES REALIZADAS
	WRITE(15,277)(X(I),I=1,14)
277   FORMAT(/1X,120(1H*)/' MODHAC - ACOMPANHAMENTO DAS COMPUTACOE'
     1,'S PASSO A PASSO'/'PARAMETROS DESTA SIMULACAO : '
     2 /1X,14(1PG10.5,2X)/)

	WRITE(15,280)

C     INICIO DO CICLO DE SIMULACOES
283   DO 402 I = 1, N
C	write(15,11111) I
C11111 format(' i=',i3)
C---> IDENTIFICA POSICAO FINAL DESTE INTERVALO DE SIMULACAO
C     IDIA = dias no intervalo de simulacao
C     K   = posição do último  -999 no arquivo de chuvas
C     KK  = posição do próximo -999 no arquivo de chuvas
C     KKK = número de valores entre -999 sucessivos
      IDIA = 0
	KKK  =  0
	PO   =  0.0
C     Inicio ciclo sobre arq.chuvas: identifica fim interv. simulação
	DO 293 IJ = 1,32
	KK = K + IJ
C	write(15,11112) ij,kk
C11112	format(' ij= ', i3,' kk= ', i3)
	IF(PD(KK) .LT. -500.) GO TO 295    ! encontrou fim intervalo (-999.)
	KIJ = 1                        
	IF(PD(KK) .LE. -1.) KIJ = - PD(KK) ! se negativo = dias sem chuva  
	KKK = KKK + KIJ
C	write(15,11113) kij,kkk
C11113	format(' kij= ', i3,' kkk= ', i3)
293   CONTINUE
C	 Se passou aqui é erro: não encontrou -999 onde devia!
	WRITE(*,294)  I
294   FORMAT(' ATENCAO: no intervalo ',I4,' falta um -999. para',
     +' indicar final'/
     +' do intervalo de simulacao ***  execucao encerrada'/)
	STOP

C---->DEFINE INTERVALO LIMITE DE CONTRIBUICAO DOS ESCOAMENTOS
295   KLIMS  =  KKK - LS + 1
	KLIMB  =  KKK - LB + 1
	KK     =  0
	TES    =  ESA
	TEB    =  EBA
	TETPR  =  0.
	ESA    =  0.
	EBA    =  0.
	TESP   =  0.
	TESS   =  0.
	TESB   =  0.
	TETPM  =  0.

	KEYS   =  0
	KEYB   =  0

C     K : CONTADOR DOS VALORES DA SERIE DE PRECIPITACOES
309   K = K + 1       

C     VERIFICA SE INTERVALO DE SIMULACAO TERMINOU
	IF(PD(K).LT.-500.) GO TO 385
	KK   = KK + 1
	IF(KK.EQ.KLIMS) KEYS = 1
	IF(KK.EQ.KLIMB) KEYB = 1

C     VERIFICA SE EXISTEM DIAS COM CHUVA OU SEQUENCIA DE DIAS SECOS
	IF(PD(K).GE.0) GO TO 353

C     SEQUENCIA DE DIAS SECOS
	KK  =  KK - 1
	JM  = -PD(K)
	DO 349 J=1,JM
	KK = KK + 1
	IF(KK.EQ.KLIMS) KEYS = 1
	IF(KK.EQ.KLIMB) KEYB = 1

C     TRANSFERE CONTROLE PARA SUBROTINA DE BALANCO HIDRICO EM DIA SECO
	CALL MODELO(X,0.,ETPM(I),ES,EB,ESP,ESS,RSP,RSS,RSB,ETPR)

	IDIA = IDIA + 1

C     IMPRESSAO DETALHADA DOS RESULTADOS COMPUTADOS
C      No arquivo 15 todos os dados (conforme versaoa anterior) e
c      No arquivo 16 os dados sem titulo e sem soma.

	IF(IPRINT.LT.0) THEN
          WRITE(15,391)KK,PD(K),ETPM(I),ES,EB,ESP,ESS,ETPR,RSP,RSS,RSB
          WRITE(16,391)KK,PD(K),ETPM(I),ES,EB,ESP,ESS,ETPR,RSP,RSS,RSB
      END IF
       
C     ACUMULA ESCOAMENTOS GERADOS A CADA INTERVALO DE COMPUTACAO
	IF(EB.EQ.0.0) GO TO 345
	EBX  =  EB
	IF(KEYB.EQ.0.) GO TO 344
	EBX  =  0.
	EBA  =  EBA + EB

C     TOTALIZA RESULTADOS
344   TEB    =  TEB + EBX
345   TESP   =  TESP + ESP
	TESS   =  TESS + ESS
	TETPR  =  ETPR + TETPR
	TETPM  =  TETPM + ETPM(I)
349   CONTINUE

	GO TO 309

C     TRANSFERE CONTROLE PARA SUBROTINA DE BALANCO HIDRICO EM DIA CHUVOSO
353   CALL MODELO(X,PD(K),ETPM(I),ES,EB,ESP,ESS,RSP,RSS,RSB,ETPR)

	IDIA = IDIA + 1

C     VERIFICA SE HAVERA' IMPRESSAO DETALHADA DA COMPUTACAO
C	IF(IPRINT.LT.0.)
C     1WRITE(15,391) KK,PD(K),ETPM(I),ES,EB,ESP,ESS,ETPR,RSP,RSS,RSB

C      No arquivo 15 todos os dados (conforme versaoa anterior) e
c      No arquivo 16 os dados sem titulo e sem soma.

	IF(IPRINT.LT.0) THEN
      WRITE(15,391)KK,PD(K),ETPM(I),ES,EB,ESP,ESS,ETPR,RSP,RSS,RSB
      WRITE(16,391)KK,PD(K),ETPM(I),ES,EB,ESP,ESS,ETPR,RSP,RSS,RSB
      END IF

C     ACUMULA OS ESCOAMENTOS GERADOS NO INTERVALO DE COMPUTACAO
	IF(ES.EQ.0) GOTO 372
	ESX = ES
	IF(KEYS.EQ.0.) GO TO 371
	ESX = 0.        
	ESA = ESA + ES

C     TOTALIZA RESULTADOS COMPUTADOS
371   TES = TES + ESX
372   IF(EB.EQ.0.) GO TO 378
	EBX = EB
	IF(KEYB.EQ.0.) GO TO 377
	EBX = 0.
	EBA = EBA + EB
377   TEB = TEB + EBX
378   TESP = TESP + ESP
	TESS = TESS + ESS
	TETPR = TETPR + ETPR
	PO = PO + PD(K)
	TETPM = TETPM + ETPM(I)

	GOTO 309

C     VERIFICA SE HOUVE DIA COMPUTADO
385   IF(IDIA.GT.0) GOTO 3855
	WRITE(*,3850) I
3850  FORMAT(' ATENCAO - Verifique arq. chuvas: não houve dia computado
     + no intervalo', I4/' *** Computacao interrompida ***'/)
	STOP

C     COMPUTA VAZAO CALCULADA
3855  QC = TES + TEB  

C     TRANSFORMA VAZAO OBSERVADA EM LAMINA DE AGUA (MM/AREA) NA BACIA
	FDIA = FLOAT(IDIA)
	IF(ITCP .EQ. 0) GOTO 386 ! Se computacao nao for diaria va' adiante

C     Opcao de intervalo de computacao mensal
	MES = MES + 1             ! incrementa mes 
	IF(MES .LE. 12) GOTO 3856 ! verifica se passou de dezembro
	IANO = IANO + 1           ! passou de desembro: aumenta ano
	MES = 1                   ! retorna `a janeiro
	GOTO 3857

3856  IF(MES .NE. 2) GOTO 3857  ! verifica se mes e' fevereiro
	IF(4*(IANO/4) .NE. IANO) GOTO 3857 ! verifica se ano nao e' bissexto
	FDIA = 29 ! ano bissexto: numero de dias de fevereiro
	GOTO 386

3857  FDIA = IDMES(MES) ! retoma numero de dias do mes
	
386   QOI = (QO(I) / AREA) * 86.4 * FDIA ! transforma unidade de vazao
	BIL = BI/AREA*86.4 * FDIA          ! idem para bandas
	BSL = BS/AREA*86.4 * FDIA

C     VERIFICA SE HAVERA' IMPRESSAO DETALHADA
	IF(IPRINT.LT.0.) WRITE(15,270) 

C      No arquivo 15 todos os dados (conforme versao anterior) e
c      No arquivo 16 os dados sem titulo e sem soma.
	IF(IPRINT.LE.0.) THEN
	    WRITE(15,391) I,PO,QOI,QC,TETPM,TESP,TESS,TETPR,RSP,RSS,RSB 
          WRITE(16,391) I,PO,QOI,QC,TETPM,TESP,TESS,TETPR,RSP,RSS,RSB     
	END IF
	
	IF(IPRINT.LT.0.) WRITE(15,280)

C     GUARDA ESCOAMENTO CALCULADO TRANSFORMANDO-O EM M3/S
	QSAL(I) = QC * AREA / (86.4 * FDIA)

C     SE FOR OPCAO SIMULACAO NAO COMPUTA MEDIA DAS VAZOES OBSERVADAS
	IF(XMAX(1) .EQ. -999.) GOTO 401

C     TOTALIZA E COMPUTA INDICES DE AJUSTAMENTO CASO VAZAO OBSERVADA FOR 
C     CONHECIDA OU NAO FOR INTERVALO DE AQUECIMENTO
	IF(QOI .LT. 0. .OR. I .LE. IQS) GO TO 402
	IF(QREF1+QREF2 .EQ. 0.0) GOTO 3865 ! Se ambos sao 0 aceita todos
	IF(QOI .LT. QREF1) GOTO 402 ! Rejeita menores que QREF1
	IF(QOI .GT. QREF2) GOTO 402 ! Rejeita maiores que QREF2
3865  TQO = TQO + QOI
	QOIMQC = (QOI-QC)
	QOIMQL = LOG(QOI+0.0001) - LOG(QC+0.0001)

C     MODIFICACAO: DEFINE UMA FAIXA DE VAZOES NO ENTORNO DA VAZAO
C     OBSERVADA DENTRO DA QUAL SE A VAZAO CALCULADA CAIR SE SUPOEM
C     NAO HAVER ERRO
C     QO - BI : BANDA SUPERIOR DA FAIXA
C     QO + BS : BANDA INFERIOR DA FAIXA
C     SE {QO - BI < QC < QO + BS} ENTAO QC = QO
	IF(QC.LT.(QOI-BIL) .OR. QC.GT.(QOI+BSL)) GOTO 399
	QOIMQC = 0.    ! Vazao calculada dentro da faixa
	QOIMQL = 0.    ! de tolerancia: erro e' nulo
399   IF(QOIMQC .GT. 1.E10) QOIMQC = 1.E5 ! e v i t a 
	IF(QOIMQL .GT. 1.E10) QOIMQL = 1.E5 ! overflow

	F1= F1 + QOIMQC*QOIMQC
	F3= F3 + ABS(QOIMQC)
	QPQ = (QOI + QC)/2.
	IF(QPQ .EQ. 0.) GO TO 402
	F2 = F2 + QOIMQC*QOIMQC/QPQ
	F4 = F4 + QOIMQL*QOIMQL
	
401   TPO = TPO + PO
	TQC = TQC + QC

	TTETP  = TTETP  + TETPM
	TTESP  = TTESP  + TESP
	TTESS  = TTESS  + TESS
	TTETPR = TTETPR + TETPR


402   CONTINUE

C     FINAL DO CICLO DE SIMULACAO
C     CALCULA INDICES DE AJUSTE
	IF(XMAX(1) .EQ. -999.) GOTO 420
	IF(SOMO.EQ.0.)GOTO 409
	F1 = F1 / SOMO * 100.
	F3 = F3 / SQRT(SOMO)
409   F4 = F4 / SOMOL * 100.

C     ATRIBUI A FUNCAO OBJETIVO O INDICE DE AJUSTE SELECIONADO
	GOTO (410,411,412,413), FOPT
410   F = F1
	GOTO 420
411   F = F2
	GOTO 420
412   F = F3
	GOTO 420
413   F = F4

420   QPQO = 100*tqo/tpo
      QPQC = 100*tqc/tpo
      IF(IPRINT.LE.0.)WRITE(15,400)TPO,TQO,TQC,TTETP,TTESP,TTESS,
     1 TTETPR,QPQO,QPQC
	IF(IPRINT.LE.0.) WRITE(15,407) F1,F2,F3,F4

C     FORMATS
280   FORMAT(/2X,'PER',8X,'PD',8X,'ETP',9X,'ES',9X,'EB',8X,'ESP',
     1 8X,'ESS',8X,'ETPR',7X,'RSP',8X,'RSS',8X,'RSB')
391   FORMAT(1X,I4,1X,11(F10.3,1X))
400   FORMAT(2X,'TOT',7(1X,F10.3)/1X,126(1H*)//
     11x,'Vazões totais (% chuva total):'/
	21x,'                    Observada: ',f4.1/,
     31x,'                    Calculada: ',f4.1)
407   FORMAT(/' VALORES DAS FUNCOES-OBJETIVO'/
     1' FUNCAO-OBJETIVO MINIMOS QUADRADOS = ',1PG12.3/
     2' FUNCAO-OBJETIVO MODULADA          = ',1PG12.3/
     3' FUNCAO-OBJETIVO VALOR ABSOLUTO    = ',1PG12.3/
     4' FUNCAO-OBJETIVO LOGARITIMICA      = ',1PG12.3)

	RETURN
	END

C***************************************************************************

	SUBROUTINE MODELO(X,PD,ETP,ES,EB,ESP,ESS,RSP,RSS,RSB,ETPR)
C /--------------------------------------------------------------------------\
C |     PROPOSITO : REALIZA O BALANCO HIDRICO NA BACIA                       |
C |                 CONFORME MODELO MODAC                                    |
C +--------------------------------------------------------------------------+ 
C |     DICIONARIO                                                           |
C |                                                                          |
C |     VARIAVEIS EXOGENAS (ENTRADA) EM MM/INTERVALO DE COMPUTACAO           |
C |                                                                          |
C |     P       PRECIPITACAO TOTAL NA BACIA                                  |
C |     ETP     EVAPOTRANSPIRACAO POTENCIAL                                  |
C |                                                                          | 
C |     VARIAVEIS DE SAIDA EM MM/INTERVALO DE COMPUTACAO                     |
C |                                                                          |
C |     ES      ESCOAMENTO SUPERFICIAL                                       |
C |     EB      ESCOAMENTO DE BASE                                           |
C |     ESP     EVAPOTRANSPIRACAO DO RESERVATORIO SUPERFICIAL                |
C |     ESS     EVAPOTRANSPIRACAO DO RESERVATORIO SUBSUPERFICIAL             |
C |                                                                          |
C |      VARIAVEIS DE ESTADO EM MM/INTERVALO DE COMPUTACAO                   |
C |                                                                          |
C |     RSP     ALTURA DE AGUA NO RESERVATORIO SUPERFICIAL                   |
C |     RSS     ALTURA DE  AGUA DO RESERVATORIO SUBSUPERFICIAL               |
C |     RSB     ALTURA DE AGUA NO RESERVATORIO SUBTERRANEO                   |
C |                                                                          |
C |     PARAMETROS                                                           |
C |                                                                          |
C |     RSPX    CAPACIDADE DO RESERVATORIO SUPERFICIAL                       |
C |     RSSX    CAPACIDADE DO RESERVATORIO SUBSUPERFICIAL                    |
C |     RSBX    CAPACIDADE TOTAL DO RESERVATORIO SUBTERRANEO                 |
C |     RSBY    CAPACIDADE DO RESERVATORIO SUBTERRANEO EM QUE AQUIFERO 2     |
C |             CONTRIBUI                                                    |
C |                                                                          |
C |     IMAX    INFILTRACAO MAXIMA                                           |
C |     IMIN    INFILTRACAO MINIMA                                           |
C |     IDEC    COEFICIENTE DE INFILTRACAO INTERMEDIARIA                     |
C |                                                                          |
C |     ASP     COEFICIENTE DE PERCOLACAO DO RESERVATORIO SUPERFICIAL        |
C |     ASS     COEFICIENTE DE PERCOLACAO DO RESERVATORIO SUBSUPERFICIAL     |
C |     ASB     COEFICIENTE DE PERCOLACAO DO RESERVATORIO SUBTERRANEO        |
C       ASBY    COEFICIENTE DE PERCOLACAO DO AQUIFERO 2
C |                                                                          |
C |     PRED    COEFICIENTE DE ALTERACAO DA PRECIPITACAO                     |
C |     CEVA    COEFICIENTE DE EVAPORACAO DO RESERVATORIO SUBSUPERFICIAL     |
C |     CHET    COEFICIENTE DE HETEROGENEIDADE TEMPORAL DA CHUVA             |
C |                                                                          |
C \--------------------------------------------------------------------------/
	REAL IMAX, IMIN, IDEC
	DIMENSION  X(14)

C     INICIALIZA OS VALORES DAS VARIAVEIS CONFORME TRANSFERENCIA DA 
C     SUBROTINA FUNCAO
	RSPX = X(1)
	RSSX = X(2)
	RSBX = X(3)
	RSBY = X(4) * X(3) / 100.
	IMAX = X(5)
	IMIN = X(6)
	IDEC = X(7)     
	ASP  = X(8)
	ASS  = X(9)
	ASB  = X(10)
	ASBY = X(11)
	PRED = X(12)
	CEVA = X(13)
	CHET = X(14)

C     TESTA A NECESSIDADE DE EMPREGO DE CORRECAO DA PRECIPITACAO
	IF(PRED.EQ.999.)GOTO 450

C     CORRECAO DA PRECIPITACAO
	IF(PD.EQ.0.) GOTO 450
	IF(PRED)420,420,430
420   POT = 1 + EXP((PRED/100)*PD)
	GOTO 440
430   POT = 1 - EXP((-PRED/100)*PD)
440   P = PD * POT
	GOTO 451
450   P = PD

C     TESTA PRECIPITACAO FRENTE A ETP MODIFICADA
C     CHET*ETP e' a parcela da chuva que podera' ser evaporada antes de
C     atingir o solo. Se CHET = 1 retorna-se a concepcao original
451   IF(P-CHET *ETP) 493,493,459

C     PRECIPITACAO MAIOR QUE EVAPOTRANSPIRACAO POTENCIAL 
C     FASE DE UMIDECIMENTO
C     INICIALMENTE SACA EVAPORACAO DA CHUVA
459   PR = P - CHET *ETP
      ETPR = P - PR     ! evaporacao real acumulada
      EX = ETP - ETPR   ! evaporacao potencial remanescente

C     VERIFICA SE EVAPORACAO POTENCIAL REMANESCENTE SERA SUPRIDA PELO 
C     RESERVATORIO SUPERFICIAL
      IF (RSP .LT. EX) GOTO 4595
C     EVAPORACAO E' TOTALMENTE SUPRIDA PELO RESERVATORIO SUPERFICIAL      
      ESP = EX          ! evaporacao do reservatorio superficial
      RSP = RSP - ESP   ! novo armazenamento no reservatorio superficial
      EX = 0.0          ! nao ha' ETP remanescente
      ETPR = ETP        ! evaporacao real acumulada e' igual a ETP
      ESS = 0.          ! nao ha' evaporacao do reser. subsuperficial
      GOTO 460

C     EVAPORACAO NAO E' SUPRIDA TOTALMENTE NO RESERVATORIO SUPERFICIAL
4595  ESP = RSP         ! evaporacao seca reservatorio superficial 
      RSP = 0.0         ! armazenamento remanescente nulo
      EX = EX - ESP     ! ETP remanescente
      ETPR = ETPR + ESP ! evaporacao real acumulada      
      
C     EVAPORACAO DO RESERVATORIO SUBSUPERFICIAL
      IF(RSS .EQ. 0.0) GOTO 4599 ! verifica se ha' umidade 
      ESS = EX * ( CEVA + (1 - CEVA) * (RSS / RSSX)) ! evaporacao
      ESS = AMIN1(ESS,RSS) ! evaporacao nao pode ser maior que umidade
      ESS = AMAX1(ESS,0.)  ! evaporacao nao pode ser menor que zero
      RSS = RSS - ESS      ! umidade remanescente
      ETPR = ETPR + ESS    ! evaporacao real acumulada
      EX = ETP - ETPR      ! ETP remanescente 
      GOTO 460
4599  ESS = 0.0

C     RX E' DEFICIT DO RESERVATORIO SUPERFICIAL
460   RX = RSPX - RSP

C     VERIFICA SE PRECIPITACAO REMANESCENTE ENCHE RESERVATORIO SUPERFICIAL
      IF(PR-RX)465,465,466

C     PRECIPITACAO E' TOTALMENTE CONTIDA NO RESERVATORIO SUPERFICIAL
465   RSP = RSP + PR
      PR = 0.
      PX = 0.
      GOTO 467

C     PRECIPITACAO ENCHE RESERVATORIO SUPERFICIAL
C     PR E' A PRECIPITACAO EXCEDENTE
466   PR = PR - RX
      RSP= RSPX

C     CALCULO DA INFILTRACAO NO RESERVATORIO SUBSUPERFICIAL
467   PIR = RSP * ( 1. - EXP( - ASP ))
      RSP = RSP - PIR

C     PARTICAO SUPERFICIAL DA PRECIPITACAO REMANESCENTE
C     PSB E' INFILTRACAO TOTAL
C     PMAX PRECIPITACAO ACIMA DA QUAL INFILTRACAO TORNA-SE CONSTANTE
C     PX E' ESCOAMENTO RAPIDO SUPERFICIAL
468   IF(PR-IMIN)470,470,472
      
C     FASE 1 : P REMANESCENTE E' TOTALMENTE INFILTRADA
470   PSB = PR + PIR
      PX = 0.0
      GO TO 8

C     FASE 2 : P REMANESCENTE E' PARCIALMENTE INFILTRADA
472   IF(IDEC - 1.0) 473,474,474
473   PMAX = (IMAX - IMIN) / (1. - IDEC) + IMIN
      IF(PR - PMAX) 474,474,475

C     FASE 2.1 : INFILTRACAO E' MENOR QUE A MAXIMA    
474   PX = (PR - IMIN) * IDEC
      PSB = PR - PX + PIR
      GO TO 8

C     FASE 2.2 : INFILTRACAO E' IGUAL A MAXIMA
475   PX = PR - IMAX
      PSB = IMAX + PIR

C     TESTA EXISTENCIA DE RESERVATORIO SUBTERRANEO
8     IF(RSBX.GT.0.) GOTO 77
      PB = 0.
      GOTO 478

C     CALCULO DA PERCOLACAO NO RESERVATORIO SUBTERRANEO
77    PSB1 = PSB + RSBX - RSB
      IF(PSB1 .EQ. 0.0) PSB1 = 0.0000001
      PB = PSB * (RSBX - RSB) / PSB1
      RSB = RSB + PB

C     CALCULO DA PERCOLACAO NO RESERVATORIO SUBSUPERFICIAL
478   PS=PSB-PB
      RSS=RSS+PS
      IF(RSS-RSSX) 480,480,479
479   PS=PS-(RSS-RSSX)
      RSS=RSSX

C     CALCULO DO EXTRAVAZAMENTO DOS RESERVATORIOS SUBSUPERFICIAL
C     E SUBTERRANEO
480   PSX=PSB-PB-PS
      PX=PX+PSX
      GOTO 532

C     PRECIPITACAO MENOR QUE EVAPOTRANSPIRACAO POTENCIAL
C     FASE RESSECAMENTO : P REMANESCENTE E EXCEDENTE NULAS
493   ETPR = P
      PR = 0.
      PX = 0.

C     EX E' QUANTO FALTA PARA SUPRIR ETP
      EX = ETP - ETPR
      IF (EX - RSP) 502,502,500

C     DEFICIT AGRICOLA MAIOR QUE RESERVA SUPERFICIAL
500   ESP = RSP
      ETPR = ETPR + ESP
      RSP = 0.        
      EX = ETP - ETPR
      GOTO 504

C     DEFICIT AGRICOLA MENOR QUE RESERVA SUPERFICIAL
502   RSP = RSP - EX
      ESP = EX
      ETPR = ETP
      EX = 0.

C     CALCULO DA INFILTRACAO DO RESERVATORIO SUPERFICIAL
      PIR = RSP * (1. - EXP(-ASP))
      RSP = RSP - PIR
      RSS = RSS + PIR
      
      IF (RSSX - RSS) 503,504,504

C     RESERVATORIO SUBSUPERFICIAL ENCHE 
503   RSS = RSSX
      RSP = RSP + (RSS - RSSX)

C     CALCULO DA EVAPOTRANSPIRACAO DO RESERVATORIO SUBSUPERFICIAL
C     TESTA SE ESSE RESERVATORIO TEM AGUA
504   IF(RSS)530,530,506
506   ESS = EX * ( CEVA + (1 - CEVA) * (RSS / RSSX))
      ESS = AMIN1(ESS,RSS)
      ESS = AMAX1(ESS,0.)
      RSS = RSS - ESS

C     COMPUTO DO DEFICIT AGRICOLA FINAL 
510   ETPR = ETPR + ESS
      EX = ETP - ETPR
      GOTO 532
530   ESS = 0.

C     COMPUTO DO ESCOAMENTO SUPERFICIAL = PRECIPITACAO REMANESCENTE
532   ES = PX

C     ESCOAMENTO SUBTERRANEO ORIUNDO DO RESERVATORIO SUBSUPERFICIAL
      EBS = RSS * ( 1. - EXP( -ASS) )

C     VERIFICA DE EXISTE RESERVATORIO SUBTERRANEO
      IF(RSBX.EQ.0) GOTO 538
      EBB  = 1. - EXP( -ASB)
      EBBY = 1. - EXP(-ASBY)

C     VERIFICA SE NIVEL RESERVATORIO SUBTERRANEO ESTA ACIMA DO NIVEL
C     DE CONTRIBUICAO DO AQUIFERO 2
      IF(RSB - RSBY) 535,535,533

C     AQUIFERO 1 CONTRIBUI
533   EBB = RSB * EBB
      GOTO 540

C     AQUIFERO 2 CONTRIBUI
535   EBB = RSB * EBBY
      GOTO 540

C     AUSENCIA DE RESERVATORIO SUBTERRANEO : NAO HA ESCOAMENTO DE BASE
C     NEM INFILTRACAO PROFUNDA
538   EBB = 0.
540   EB  = EBS + EBB

C     VARIACAO DO ARMAZENAMENTO NOS RESERVATORIOS SUBSUPERFICIAL
C     E SUBTERRANEO
      RSS = RSS - EBS
      RSB = RSB - EBB

      RETURN
      END

C****************************************************************************
	SUBROUTINE ROSEN(M,X,XMIN,XMAX,E,ETOL,F,PR,NN,PD,ETPM,QO,QSAL,
     +XO,XOMIN,XOMAX,RSP,RSS,RSB,LS,LB,LOOPY,NSTEP,FTP,QREF1,QREF2,
     +FTOL,IQS,APAR,AREA,BI,BS,ITCP,IANO,MES,UPAR)

C       METODO DE OTIMIZACAO BLOQUEADA DE ROSENBROCK

C       DICIONARIO BASICO
C       FBEST - MELHOR VALOR DA F-O ATE ULTIMA ROTACAO, OU ESTAGIO PREVIO
C       FO    - MELHOR VALOR DA F-O APOS ULTIMA ROTACAO, OU NESTE ESTAGIO
C       F     - VALOR CORRENTE DA F-O, OBTIDO NA ULTIMA SIMULACAO       
	
	INTEGER PR,R,C,FTP
	REAL LC
	CHARACTER VALE(14),SETA(2),VAL,MEL
	CHARACTER*4 APAR(14),UPAR(14)
	DIMENSION X(14),E(14),ETOL(14),XMIN(14),XMAX(14),V(14,14),D(14),
     +H(14),B(14,14),BX(14),VV(14,14),EINT(14),AL(14),QSAL(5000)
	DIMENSION PD(20000),ETPM(5000),QO(5000),XO(14),XOMIN(14),
     +XOMAX(14)
	DIMENSION MARCA(14),IND(14)
	DATA SETA/' ','<'/,VAL/'V'/,MEL/'M'/

	WRITE(15,551) M,NSTEP,LOOPY,FTOL

C     INICIALIZA PARAMETROS E VARIAVEIS
	IPRINT = PR
	LOOP = 1
	INIT = 0
	KOUNT = 0
	TERM = 0.0

C     AVALIACAO INICIAL DA FUNCAO-OBJETIVO
	WRITE(*,550)
550     FORMAT(' AVALIACAO PRELIMINAR DO AJUSTE'/)
	CALL FUNCAO(NN,PD,ETPM,QO,X,F,IPRINT,XO,XOMIN,XOMAX,RSP,RSS,RSB,LS
     1,LB,FTP,QREF1,QREF2,QSAL,IQS,APAR,AREA,BI,BS,ITCP,IANO,MES)
	FO = F

C     ESTABELE TOLERANCIA DE AJUSTE DA FUNCAO-OBJETIVO
	FTOL = FTOL * F

C     ESTABELECE ZONA FRONTEIRICA DA REGIAO VIAVEL E COMPUTA PRECISAO
C     PARA PARAMETROS 
	DO 565 K = 1,M
		AL(K) = (XMAX(K)-XMIN(K)) * ETOL(K)
		ETOL(K) = ETOL(K) * ABS(E(K))

565     CONTINUE

C     INICIALIZA COMO INDENTIDADE MATRIZ V DOS VETORES UNIDIRECIONAIS
	DO 572 I = 1,M
	DO 572 J = 1,M
		V(I,J) = 0.0
		IF(I-J) 572,571,572
571             V(I,J) = 1.0
572   CONTINUE

C     GUARDA VALORES INICIAIS DO PASSO DE VARIACAO DE CADA VARIAVEL
	DO 576 KK=1,M
		EINT(KK) = E(KK)
576     CONTINUE

C     INICIO DA PARTE ITERATIVA :
C     ATUALIZA PASSO DE VARIACAO NO INICIO DE NOVO ESTAGIO E ZERA
C     INDICADOR DE EXISTENCIA DE VALE
578   DO 583 J = 1,M
		IF(NSTEP . EQ . 0) E(J) = EINT(J)

C     INICIALIZA D : ALTERACAO TOTAL DA VARIAVEL NO ESTADO CORRENTE
		D(J) = 0.0
		VALE(J) = SETA(1)
		IND(J) = 0
583   CONTINUE

C     ATUALIZA MELHOR VALOR DA F.O. ATE ESTAGIO ANTERIOR
	FBEST = FO 
586     WRITE(*,7)
7       FORMAT(1X,30(1H-)/' INICIO DE CICLO DE VARIACAO DE PARAMETROS')
	I = 1

C     VERIFICA SE OTIMO FOI ATINGIDO VIA PASSO DE VARIACAO
	KETOL = 0
	DO 588 K = 1,M
	MARCA(K) = 1

C     EVITA INSENSIBILIDADE DO PARAMETRO NAO ACEITANDO PASSO NULO
	IF(E(K).EQ.0.0) E(K) = ETOL(K) 
	IF(X(K).EQ.XMAX(K)) E(K) = - E(K)
	
	IF( ABS( E(K) ) . LT . ETOL(K)) GOTO 588
	KETOL = 1
588   CONTINUE
	IF(KETOL . NE . 0) GOTO 589
	WRITE(15,755) KOUNT
	WRITE(*,755) KOUNT
	TERM = 1
	GOTO 726

C     VERIFICA SE CONDICAO DE VALE FOI OBTIDA APROXIMADAMENTE
589   KONT = KOUNT + 1
	WRITE(*,11) KONT,LOOP
11      FORMAT(/' VALORES PARAMETROS NA SIMULACAO',I5,' E ESTAGIO ',
     1  I2,/' PARAMETRO',3X,'MINIMO',5X,'VALOR',6X,'MAXIMO',6X,'PASSO',
     2  4X,'PRECISAO')
	MARCA(I) = 2
	DO 590 K = 1,M
C     ALTERACAO UNIVARIACIONAL DOS PARAMETROS
		X(K) = X(K) + E(I) * V(I,K)
		J = MARCA(K)
	WRITE(*,12) UPAR(K),XMIN(K),X(K),XMAX(K),E(K),ETOL(K),
     1  VALE(K),SETA(J)
12    FORMAT(3X,A,4X,5(G10.4,1X),3X,A1,2X,A1)

C     GUARDA MELHOR VALOR DA F-O  NO ESTAGIO ATUAL 
	H(K) = FO

590   CONTINUE

C     SE VALOR DO PARAMETRO FOR INVIAVEL, NAO EXECUTAR A SIMULACAO
	DO 594 K = 1,M
	IF(X(K) . GE . XMIN(K) . AND . X(K) . LE . XMAX(K)) GOTO 594
	WRITE(*,9) UPAR(K)
9     FORMAT(' FALHA : PARAMETRO ', A,' INVIAVEL')
	GOTO 714 
594   CONTINUE

	INIT = 1        
	KOUNT = KOUNT + 1
	IF(IPRINT . LT . 0) GOTO 596
	IF(MOD(KOUNT,PR) . EQ . 0 ) IPRINT = 0

C     AVALIACAO DO AJUSTE
596   CALL FUNCAO(NN,PD,ETPM,QO,X,F,IPRINT,XO,XOMIN,XOMAX,RSP,RSS,RSB,LS
     1,LB,FTP,QREF1,QREF2,QSAL,IQS,APAR,AREA,BI,BS,ITCP,IANO,MES)

	WRITE(*,1) FBEST,FO,F
1     FORMAT(/' VALORES DA F-O : MELHOR  GLOBAL - ',1PG10.4/
     1'                  MELHOR ESTAGIO - ',1PG10.4/
     2'                           ATUAL - ',1PG10.4) 

C     TESTA LIMITE DE SIMULACOES
	IF(KOUNT . EQ . LOOPY) GOTO 740 

	IPRINT = 1.

C     VERIFICA SE A SOLUCAO E' MELHOR QUE A MELHOR OBTIDA ATE
C     AGORA NESSE ESTAGIO (OU ASCENSAO DA F-O).
	IF(F . LT . FO) GO TO 610
	IF(F.GT.FO . OR . IND(I).EQ.1) GOTO 597
	IND(I) = 1
	GOTO 610
597   WRITE(*,5)
5     FORMAT(' FALHA : PIOROU VALOR DA F-O')
	GOTO 714

C     VERIFICA SE SOLUCAO ESTA NA ZONA FRONTEIRICA, PENALIZANDO F-O
C     CASO ISSO OCORRA
610   J = 1
611   XC = X(J)
	LC = XMIN(J)
	UC = XMAX(J)
	IF(XC . LT . (LC+AL(J)) . OR . XC . GT . (UC-AL(J)) ) GOTO 627

C     GUARDA VALOR F.O. COM PARAMETRO X(J) FORA DA ZONA FRONTEIRICA
	H(J) = F
	GO TO 654

C     PARAMETROS ACHAM-SE NA ZONA FRONTEIRICA
627   BW = AL(J)
	IF(XC.LT.(LC+BW))GO TO 638
	IF((UC-BW).LT.XC) GO TO 641

C     PARAMETROS NA REGIAO LIMITROFE INFERIOR
638   PW = (LC + BW - XC) / BW
	GO TO 642

C     PARAMETROS NA REGIAO LIMITROFE SUPERIOR
641   PW = (XC - UC + BW) / BW
642   PH = 3.0 * PW - 4.0 * PW * PW + 2.0 * PW * PW * PW

C     PENALIZA VALOR DA F-O QDO PARAMETROS SE ACHAM NA ZONA FRONTEIRICA
645   F = F + (H(J) - F) * PH 

C     VERIFICA SE NAO HOUVE PIORA NO VALOR CORRIGIDO DA F-O, FACE AOS
C     RESULTADOS OBTIDOS ATE AGORA NESSE ESTAGIO
	IF( F . LT . FO ) GOTO 650

C     PIOROU !
	WRITE(*,10) J,F
10    FORMAT(' PARAMETRO X(',I1,') NA ZONA FRONTEIRICA.'/
     1       ' CORRECAO DA F-O,',1PG10.4,' PIOROU RESULTADOS') 

	GOTO 714

650   WRITE(*,2) J,F
2     FORMAT(' PARAMETRO X(',I1,') NA ZONA FRONTEIRICA; F CORRIGIDO :
     1',1PG10.4)

C     PROSSEGUE PESQUISANDO OUTRO PARAMETRO OU ENCERRANDO ESSA AVALIACAO
654   IF(J . EQ . M) GO TO 661
	J = J + 1
	GO TO 611

C     FINAL DA AVALIACAO FRONTEIRICA
      
C     OCORRE MELHORIA NA F-O : GUARDA ALTERACAO TOTAL DA VARIAVEL (D) E
C     ACELERA O PASSO POR 3
661   D(I) = D(I) + E(I)
	E(I) = 3.0 * E(I)

C     TESTA VALOR DO PASSO EVITANDO INVIABILIDADE
	DO 663 K = 1 , M
	IF(E(I)*V(I,K) .LT. 0.0 .AND. E(I)*V(I,K) .LT. (XMIN(K) - X(K))) 
     1  E(I) = (XMIN(K) - X(K)) / V(I,K)
	IF(E(I)*V(I,K) .GT. 0.0 .AND. E(I)*V(I,K) .GT. (XMAX(K) - X(K))) 
     1  E(I) = (XMAX(K) - X(K)) / V(I,K) 
663     CONTINUE

	WRITE(*,3)
3     FORMAT(' SUCESSO : MELHOROU VALOR DA F-O')

C     MELHOR RESULTADO E' REGISTRADO EM FO, SENDO FO GUARDADO ANTES
C     PARA TESTAR SE VALE FOI ENCONTRADO NA APROXIMACAO
	FO = F

670   IF(VALE(I).NE.VAL) VALE(I) = MEL

C     VERIFICA SE VALE FOI ENCONTRADO ATRAVES DOS VALORES DE SA
671   DO 673 JJ = 1,M
	IF(VALE(JJ) . NE . VAL) GO TO 722
673   CONTINUE

C     VALE ENCONTRADO : FINAL DAS COMPUTACOES DESTE ESTAGIO
C     VERIFICA INICIALMENTE SE OTIMO FOI ATINGIDO
	IF(ABS(FBEST - F) - FTOL) 675,675,676

C     SOLUCAO E' OTIMA - ENCERRA 
675   WRITE(15,750) KOUNT
	WRITE(*,750) KOUNT
	TERM = 1
	GOTO 726

C     SOLUCAO SUB-OTIMA : ROTACAO DOS EIXOS
676   WRITE(*,4) 
4     FORMAT(1X,30(1H*)/' VALE ENCONTRADO - ROTACAO E NOVO ESTAGIO')
	DO 677 R=1,M
	DO 677 C=1,M
	VV(C,R) = 0.0
677   CONTINUE

	DO 683 R=1,M
	KR = R
	DO 683 C = 1,M
	DO 682 K = KR,M
	VV(R,C) = D(K) * V(K,C) + VV(R,C)
682   CONTINUE  

	B(R,C) = VV(R,C)
683   CONTINUE

	BX(1) = 0.0

	DO 687 C=1,M
	BX(1) = BX(1) + B(1,C) * B(1,C)
687   CONTINUE
	
	BX(1) = SQRT(BX(1))
	IF(BX(1).EQ. 0.) BX(1) = 0.000001

	DO 691 C = 1,M
	V(1,C) = B(1,C) / BX(1)
691   CONTINUE

	DO 701 R=2,M
	IR = R-1
	DO 701 C=1,M
	SUMVM = 0.0
	DO 700 KK = 1,IR
	SUMAV = 0.0
	DO 699 KJ = 1,M
	SUMAV = SUMAV + VV(R,KJ)* V(KK,KJ)
699   CONTINUE
	SUMVM = SUMAV*V(KK,C) + SUMVM
700   CONTINUE
	B(R,C) = VV(R,C) - SUMVM
701   CONTINUE

	DO 708 R=2,M
	BX(R) = 0.0
	DO 705 K = 1,M
	BX(R) = BX(R) + B(R,K) * B(R,K)
705   CONTINUE
	BX(R) = SQRT(BX(R))
	IF(BX(R).EQ.0.0) BX(R) = 0.0000001

	DO 708 C = 1,M
	V(R,C) = B(R,C) / BX(R)
708   CONTINUE

C     FINAL DA ROTACAO - INICIA ESTAGIO SEGUINTE DE COMPUTACOES
	LOOP = LOOP + 1
	GO TO 726

C     SOLUCAO E' INVIAVEL OU PIOR : 1) RETORNA AO VALOR PREVIO DA
C     VARIAVEL ALTERADA; 2) MODIFICA O SENTIDO DA ALTERACAO;
714   IF(INIT . EQ . 0) GO TO 726
	DO 716 IX = 1,M
	X(IX) = X(IX) - E(I) * V(I,IX)
716   CONTINUE

C     SOLUCAO PIOROU : MUDA SENTIDO DE VARIACAO E CONTRAI 
C     O PASSO 'A METADE
	E(I) =  - 0.5 * E(I)

C     TESTA VALOR DO PASSO EVITANDO INVIABILIDADE
	DO 720 K = 1, M 
	IF(E(I)*V(I,K).LT. 0.0  . AND . E(I)*V(I,K) .LT. (XMIN(K)-X(K))) 
     1  E(I) = (XMIN(K) - X(K)) / V(I,K)
	IF(E(I)*V(I,K).GT. 0.0  . AND . E(I)*V(I,K) .GT. (XMAX(K)-X(K))) 
     2  E(I) = (XMAX(K) -X(K)) / V(I,K)
720   CONTINUE
 
C     ALTERA INDICADOR DE VALE
	IF(VALE(I) . EQ . SETA(1)) GOTO 671
	VALE(I) = VAL
	GO TO 671

C     VERIFICA SE TODOS PARAMETROS FORAM MODIFICADOS
722   IF(I . EQ . M) GO TO 586
	I = I + 1
	GO TO 589

726   WRITE(15,727)
	WRITE(15,730) LOOP,FO
	WRITE(15,732) KOUNT
	WRITE(15,734)
	WRITE(15,736) (JM,X(JM),JM=1,M)

735   IF(INIT.EQ.0.) GO TO 742
	IF(TERM.EQ.1.)  GO TO 745
	GO TO 578

740   WRITE(15,6)LOOPY
	WRITE(*,6) LOOPY

C     RECUPERA VALORES PREVIOS DOS PARAMETROS 
	DO 741 K = 1,M
	X(K) = X(K) - E(I) * V(I,K)
741   CONTINUE

	GO TO 745

742   WRITE (15,743)
745   WRITE(15,746)

	DO 748 J=1,M
	WRITE(15,749) (J,I,V(J,I), I = 1,M)
748   CONTINUE

	WRITE(15,751)
	WRITE(15,753) (J,E(J),J = 1,M)

C     AVALIACAO FINAL 

	CALL FUNCAO(NN,PD,ETPM,QO,X,F,0,XO,XOMIN,XOMAX,RSP,RSS,RSB,LS,LB,
     +FTP,QREF1,QREF2,QSAL,IQS,APAR,AREA,BI,BS,ITCP,IANO,MES)

	RETURN
	
C     FORMATS
551   FORMAT(/1X,90(1H=)//' MODHAC : CALIBRACAO AUTOMATICA PELO ME',
     +'TODO DE OTIMIZACAO BLOQUEADA DE ROSENBROCK'//
     +' NUMERO DE PARAMETROS        = ',I4,
     +5X,'OPCAO PASSO INICIAL         = ',I1/
     +' MAXIMO NUMERO DE INTERACOES = ',I4,
     +5X,'PRECISAO FUNCAO OBJETIVO    = ',G15.8//1X,90(1H=)/)
603   FORMAT(/' ULTIMO VALOR DA FUNCAO OBJETIVO = ',1PG14.6//)
727   FORMAT(/' ESTAGIO',8X,'FUNCAO')
730   FORMAT(1X,I5,6X,1PG14.6)
732   FORMAT(/' NUMERO DE SIMULACOES = ',I5)
734   FORMAT(/' VALORES DOS PARAMETROS NESTE ESTAGIO')
736   FORMAT(5(' X(',I1,') = ',1PG14.6,2X))
6     FORMAT(1X,' NUMERO DE INTERACOES EXCEDEU O LIMITE DE',1X,I3,
     1 1X,'INTERACOES')        
743   FORMAT(/' VALORES INICIAIS DOS PARAMETROS VIOLAM BLOQUEIO')
746   FORMAT(/' MATRIZ DOS VETORES DIRECIONAIS FINAIS')
749   FORMAT(/1X,5('V(',I1,',',I1,') = ' ,G14.6,2X))
750   FORMAT(/5X,'OTIMO ATINGIDO NA SIMULACAO ',I5,', PELA PRECISAO'
     1 ,' DA FUNCAO OBJETIVO'/)
751   FORMAT(/' DIMENSAO DOS PASSOS FINAIS')
753   FORMAT(/1X,5('E(',I1,') = ',1PG14.6,4X))
755   FORMAT(/5X,'OTIMO ATINGIDO NA SIMULACAO ',I5,', PELA PRECISAO'
     1,' DOS PARAMETROS'/)

	END

