	PROGRAM CASCATA

C+----------------------------------------------------versao 2.1 SET/93------+
C|      Determina a relacao entre a capacidade de armazenamento e a descarga |
C|      garantida, para cada reservatorio em um sistema de multiplos         |
C|      reservatorios em cascata                                             |
C|                                                                           |
C|      DICIONARIO                                                           |
C|                                                                           |
C|      Indices                                                              |
C|                                                                           |
C|      I, I = 1, NVAZ : indice que indentifica os meses de simulacao        |
C|      J, J = 1, NR : indice que identifica os reservatorios em cascata     |
C|                                                                           |
C|      Dados de entrada                                                     |
C|                                                                           |
C|      NANOS : numero de anos de simulacao                                  |
C|      IANO  : ano inicial de simulacao                                     |
C|      TITLEG  : titulo geral do problema                                   |
C|      TITLER  : titulo atribuido a cada reservatorio estudado              |
C|      ALFA    : coeficiente de correcao das vazoes afluentes               |
C|      VAZOES  : nome do arquivo de vazoes                                  |
C|      CHUVAS  : nome do arquivo de chuvas                                  |
C|                                                                           |
C|      CHUVA(I) : chuvas precipitadas sobre a superficie do reservatorio du-|
C|      rante o mes I, em mm/mes                                             |
C|      VAZAO(I) : vazoes afluentes naturais a secao fluvial do              |
C|      reservatorio durante o mes I, caso nao houvesse reservatorio a       |
C|      montante (dado de entrada, em m3/s)                                  |
C|      QMIN (I) : descargas minimas a serem retiradas do reservatorio       |
C|                 (Hm3/mes)                                                 |
C|      DESC(I)  : sazonalidade da demanda a ser suprida em cada reservatorio|
C|                 (%)                                                       |  
C|      DESCR(I) : sazonalidade da descarga de retorno (%)                   |
C|                                                                           |
C|      BETA     : coeficiente de correcao da evaporacao                     |
C|      EVAP(I)  : taxa mensal de evaporacao em cada reservatorio (mm/mes)   |
C|                                                                           |
C|      IDD : grau do polinomio area vs volume                               |
C|      A(L), L = 1,ID + 1 : coeficientes do polinomio acima                 |
C|                                                                           |
C|      STOMAX : valor maximo de armazenamento a ser considerado (Hm3)       |
C|      STOMOR : volume morto do reservatorio (Hm3)                          |
C|      FTOLS  : tolerancia para armazenamento minimo (%)                    |
C|      SININ  : armazenamento inicial em percentagem da capacidade (%)      |
C|      KMAX   : numero de pontos funcao descarga vs capacidade              |
C|      KD     : valor que estabelece criterio de decrescimo de STOMAX       |
C|                                                                           |
C|      NPOL   : numero de polinomios a serem ajustados a funcao acima       |
C|      IDD(K), K = 1, NPOL : grau de cada polinomio a ser ajustado          |
C|                                                                           |
C|      FTOL   : valor percentual da tolerancia a falhas (%)                 |
C|      FFTOL  : tolerancia requerida para atingir tolerancia FTOL (%)       |
C|      KLOOPM : numero maximo de "loops reversos"                           |
C|                                                                           |
C|      PS : Percentagem da media entre armazenamento inicial e final para   |
C|           convergencia da estimativa e calculo de armazenamento final (%) |
C|      KCICM : numero maximo de iteracoes para atingir convergencia acima   |
C|                                                                           |
C|      Variaveis indexadas de estado                                        |
C|                                                                           |
C|      ARMAZ(I) : trajetoria dos armazenamentos do reservatorio no inicio   |
C|      de cada mes I                                                        |
C|      VAZAOM(I) : vazoes afluentes naturais a secao fluvial do             |
C|      reservatorio de montante, durante o mes I.                           |
C|      VAZAOR(I) : vazao da bacia incremental VAZAO(I) - VAZAOM(I)          |
C|                                                                           |
C|      DEFLU(I,K): vazoes afluentes oriundas das descarga de reservatorio   |
C|      a montante durante o mes I, e com a capacidade K                     |
C|      DEFLUT(I)  : variavel temporaria que arquiva valores acima           |
C|                                                                           |
C|      YY(KP),XX(KP) : variaveis com pontos da funcao de regularizacao      |
C|      A(ID),B(ID)   : coeficientes do polinomio ajustado `a funcao acima   |
C|                                                                           |
C|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
C|                                                                           |
C|      Desenvolvimento e programacao : Prof. A. Eduardo Lanna, IPH/UFRGS    |
C|                                                                           |
C|      Versao : Julho de 1992                                               |
C+---------------------------------------------------------------------------+        
	
	DIMENSION ARMAZ(1001), VAZAOM(1000), VAZAO(1000), VAZAOR(1000),
     *            DEFLU(1000,20), DEFLUT(1000), CHUVA(1000),
     *            QMIN(12), DESC(12), DESCR(12), EVAP(12)
	DIMENSION YY(20), XX(20), A(5), B(5), IDD(5)
	CHARACTER*80 TITLEG, TITLER
	CHARACTER*80 CHUVAS
	
1       FORMAT(A)

	OPEN(1,FILE=' ',STATUS='OLD')
	OPEN(2,FILE=' ',STATUS='unknown')
	OPEN(3,FILE=' ',STATUS='unknown')        

	READ(1,*) TITLEG, NRES, NANOS, IANO       
	
C       Inicia pelo reservatorio mais a montante : zera vazoes afluentes
C       a secao fluvial do reservatorio de montante (que no caso inexiste)

	NVAZ = NANOS * 12
	KULT = 1
	DO 5 I = 1, NVAZ
	VAZAO(I) = 0.0
	DO 5 K = 1, 20
	DEFLU(I,K) = 0.0
5       CONTINUE         

	KTOT = 1

C       IMPRESSAO DADOS DE ENTRADA
	
	WRITE(2,501) TITLEG,NANOS,IANO
501     FORMAT(//1X,'Programa CASCATA - Capacidade de Reservatorios'/
     1           1X,'Desenvolvido no IPH/UFRGS - Prof. A. E. LANNA'//
     2           1X, A///
     3           5X,'NUMERO DE ANOS DE ANALISE ...... ',I3/
     4           5X,'ANO INICIAL .................... ',I4//)  
		 
C       Inicia ciclo sobre cada reservatorio

	RESKEY = 0
	
	DO 170 NR = 1, NRES
	WRITE(*,7) NR
7       FORMAT(/////////' Analise do reservatorio : ', I2)

C       Armazena vazao afluente ao reservatorio de montante na variavel certa

	DO 10 I = 1,NVAZ
	VAZAOM(I) = VAZAO(I)
10      CONTINUE

C       Le dados relativos ao reservatorio em analise

	READ(1,*) TITLER, ALFA

	WRITE(*,5015) TITLER
5015    FORMAT(/' LENDO VAZOES E CHUVAS EM ',A)

C       Leitura e transformacao de vazoes
	
	CALL DATA (NVAZ,IANO,VAZAO,ALFA)
	
C       Computa vazao afluente da bacia incremental

	DO 15 I   = 1, NVAZ
	VAZAOR(I) = VAZAO(I) - VAZAOM(I) 
	IF(VAZAOR(I) .LT. 0.0) VAZAOR(I) = 0.0
15      CONTINUE
				  
	READ(1,*) CHUVAS
	OPEN(5,FILE=CHUVAS,STATUS='OLD')        
	READ(5,*) (CHUVA(I), I = 1,NVAZ)
	CLOSE (5)

	READ(1,*) (QMIN(I), I=1,12)
	READ(1,*) (DESC(I), I=1,12)
	READ(1,*) (DESCR(I),I=1,12)
	READ(1,*) BETA,(EVAP(I), I=1,12)
	READ(1,*) ID, (A(I),I=1,ID+1)    
	READ(1,*) STOMAX, STOMOR, SININ, FTOLS, FTOL, FFTOL, KLOOPM
		     
C       Corrige FFTOL para evitar loops

	FFTOL = AMAX1(FFTOL, 100./NVAZ)
	IF(FTOL .EQ. 0.0) FFTOL = 10.

	READ(1,*) KMAX,KD,NPOL,(IDD(K),K=1,NPOL)

C       Corrige KD para evitar problemas se KMAX = 1
	
	IF(KMAX.EQ.1 .AND. KD.EQ.0) KD = 10

	READ(1,*) PS,KCICM
     
	IF(KMAX .GT. 1 .AND. RESKEY .NE. 0) PRINT*,' ATENCAO : MAIS DE 
     *UM RESERVATORIO COM VARIACAO DE CAPACIDADE'
	IF(KMAX.GT.1) RESKEY = RESKEY + 1
	KTOT = MAX(KTOT,KMAX)

	WRITE(2,502) TITLER
502   FORMAT(//1X,A//25X,'SAZONALIDADE DA DEMANDA TOTAL ANUAL (%)'/)
	WRITE(2,503) (DESC(I),I=1,12)  
503   FORMAT(5X,12(F8.2,1X))       
	WRITE(2,504)        
504   FORMAT(//25X,'SAZONALIDADE DA DESCARGA DE RETORNO (%)')
	WRITE(2,503) (DESCR(I),I=1,12)                                        
	WRITE(2,5045)
5045  FORMAT(//25X,'DESCARGA MINIMA MANTIDA PARA JUSANTE (Hm3/mes)')          
	WRITE(2,503) (QMIN(I),I=1,12)
	WRITE(2,505) ALFA
505   FORMAT(//25X,'VAZOES AFLUENTES BACIA INCREMENTAL (Hm3/mes)'/
     1         25X,'COEFICIENTE DE CORRECAO ADOTADO : ',F6.3/)
	WRITE(2,506) (VAZAOR(I),I = 1,NVAZ)
506   FORMAT(5X,12F9.2)
	WRITE(2,5065)
5065  FORMAT(//25X,'CHUVAS SOBRE A SUPERFICIE DO RESERVATORIO (mm/mes)')
	WRITE(2,506) (CHUVA(I), I = 1,NVAZ)
	WRITE(2,507) BETA
507   FORMAT(//25X,'TAXA SAZONAL DE EVAPORACAO (mm/mes)'/
     1         25X,'COEFICIENTE DE CORRECAO ADOTADO : ',F6.3/)
	WRITE(2,503) (EVAP(I),I = 1,12)
	WRITE(2,508) (A(I),I=1,5)
508   FORMAT(//25X,'POLINOMIO AREA VS. VOLUME'///
     15X,'AREA(KM2) = ',F15.10,' + ',F15.10,' * VOL +'/
     15X,'+',F15.10,' *VOL**2 +',F15.10,'*VOL**3 + '/
     15X,' + ',F15.10,' * VOL**4          (VOL EM HM3)')
	WRITE(2,5085) SININ,FTOLS
5085    FORMAT(/25X,'ARMAZENAMENTO INICIAL = ',F10.3,' % CAPACIDADE'/
     1          25X,'TOLERANCIA PARA ARMAZENAMENTO MINIMO = ',F6.3/)

C       Calculo da media das vazoes historicas - YMED; na carona faz
C       transformacao de chuva de km2*mm/mes em Hm3/mes

	SUM     = 0.0
	DO 20 I = 1,NVAZ
	SUM     = SUM  + VAZAOR(I) + DEFLU(I,KULT) 
	CHUVA(I) = CHUVA(I) * 0.001
20      CONTINUE        

	YMED    = SUM / NANOS

C       Conversao de % para fracao e Km2*mm/mes em Hm3/mes 

	
	PS       =  PS       / 100.
	FTOLS    =  FTOLS    / 100.
      
	DO 30 I  =  1,12
	DESC(I)  =  DESC(I)  / 100.
	DESCR(I) =  DESCR(I) / 100.
30      EVAP(I)  =  BETA * EVAP(I)  *   0.001
	
C       Determina a producao garantida a fio de agua
	
	M = 0
	IF(DESC(1).GT.0.0) VFIO = (VAZAOR(1) + DEFLU(1,KULT)) / DESC(1) 
	ELSE VFIO = 1. E+20

	DO 40 I = 1,NVAZ
	M    = M + 1
	IF(M.EQ.13) M = 1
	IF(DESC(M) .GT. 0.0) BIG = (VAZAOR(I) + DEFLU(I,KULT)) / DESC(M)
	IF(BIG .GE. VFIO) GO TO 40
	VFIO = BIG
	NFIO = I
40      CONTINUE
	 
C       Calcula maxima capacidade util: Capacidade p/ produzir YMED
	
	M        = 0
	ARMAZ(1) = 0.0
	VOLMIN   =  1. E+20
	VOLMAX   = -1. E+20
	DO 50 I  = 1,NVAZ
	M        = M + 1
	IF(M.EQ.13) M = 1
	STR1 = ARMAZ(I) + VAZAOR(I) + DEFLU(I,KULT) - YMED * DESC(M) 
	ARMAZ(I+1)    = STR1
	IF(STR1.LT.VOLMIN) VOLMIN = STR1
	IF(STR1.GT.VOLMAX) VOLMAX = STR1
50      CONTINUE
	 
	STORA = VOLMAX - VOLMIN
	DXULT = STORA        

	WRITE(*,509) TITLER,VFIO,YMED,VOLMIN,VOLMAX,STORA,STOMOR,NFIO
	WRITE(2,509) TITLER,VFIO,YMED,VOLMIN,VOLMAX,STORA,STOMOR,NFIO

509   FORMAT(///1X,A////5X,'PARAMETROS BASICOS EM HM3/ANO'/
     15X,'PRODUCAO ANUAL FIO DAGUA : ',F12.3/
     25X,'PRODUCAO MEDIA ANUAL     : ',F12.3/
     35X,'ACUMULACAO MINIMA        : ',F12.3/
     45X,'ACUMULACAO MAXIMA        : ',F12.3/
     55X,'MAXIMA CAPACIDADE UTIL   : ',F12.3/
     65X,'VOLUME MORTO             : ',F12.3/
     75X,'MES CRITICO              : ',4X,I5//)
	
C       Inicia simulacao 
	
	X = YMED 
	WRITE(2,510) FTOL, FFTOL
510   FORMAT(1X,'FUNCAO REGULARIZACAO'///
     1/2X,'PERCENTUAL TOLERADO DE FALHAS : ',F5.2,' (ERRO < ',F5.2,'%)'/
     2//2X,'CAPACIDADE',2X,'PRODUCAO ANUAL',2X,'EVAP.EFETIVA MEDIA'
     3,2X,'VERT. MEDIO',2X,'FINAL PER. CRIT',2X,'FALHAS',2X,'ARM. MIN'/
     4,5X,'(HM3)',6X,'(HM3/ANO)',8X,'(HM3/ANO)',9X,'(HM3/ANO)',
     58X,'(MES)',9X,'(%)',5X,'(HM3)',/)

	ICRIT = NVAZ
	KSTOP = 0
	
C       Ajusta FTOL para evitar que todos PFAL < FTOL

	IF(FTOL. GT. 0.0) FTOL = FTOL + FFTOL/2.

C       Funcao e' discretizada em KTOT pontos          
	
	XS = X
	IF(STOMAX .LT. STOMOR) STOMAX = 5 * STOMOR

C       Inicio ciclo sobre valores de armazenamento
	
	DO 130 K = 1, KTOT
	KLOOP    = 0
	IF(KMAX.EQ.1) GOTO 55
	L        = KMAX - K + 1
	SMAX     = STOMOR + L * (STOMAX - STOMOR) / KMAX
	
C       Fixa armazenamento inicial e inicializa o minimo       

	ARMAZ(1) = AMAX1(STOMOR,(SININ/100.) * SMAX)
	GOTO 60

C       Capacidade e armazenamento inicial reservatorio de capacidade fixa 

55      SMAX = STOMAX
	ARMAZ(1) = AMAX1(STOMOR,(SININ/100.) * SMAX)

C       Inicio da fase de balanco hidrico

60      ARMMIN = STOMAX
	SUMSP = 0.0
	SEVAP = 0.0

C       Zera defluvio do reservatorio

	DO 70 I = 1,NVAZ
	DEFLUT(I) = 0.0
70      CONTINUE

	I = 0
	KONTA=0
	M = 0
	PFAL=0.0

C       Inicio do ciclo de simulacao

80      I = I + 1
	M = M + 1
	
	SPL = 0.0
	ARMI = ARMAZ(I)
	ARMF = ARMI

C       Inicio do ciclo para ajuste do armazenamento final

	KCIC = 0

85      KCIC = KCIC + 1
	ARMM  = (ARMI + ARMF)/2.
	AREA  = A(1)+A(2)*ARMM+A(3)*ARMM**2+A(4)*ARMM**3+A(5)*ARMM**4
	EVAPO = AMAX1( (EVAP(M) - CHUVA(I)) * AREA, 0.0)
	STR2  = ARMI + VAZAOR(I)+DEFLU(I,K) - DESC(M)*X - EVAPO-QMIN(M)

C       Defluvio do reservatorio : vazao minima mais de retorno        
	
	DEFLUT(I) = QMIN(M) + DESCR(M) * DESC(M) * X
	
C       Testa condicao de contorno do maximo armazenamento

	IF(STR2.GT.SMAX) GO TO 90
	ARMAZ(I+1) = STR2

C       Testa condicao de contorno do minimo armazenamento 
	
	IF(ARMAZ(I+1) .GT. STOMOR) GOTO 100
	DEFLUT(I)  = DEFLUT(I) + ARMAZ(I+1) - STOMOR
	DEFLUT(I)  = AMAX1(0.,DEFLUT(I))
	ARMAZ(I+1) = STOMOR
	GO TO 100

C       Correcao para situacao de vertimento

90      ARMAZ(I+1) = SMAX
	SPL        = STR2 - SMAX
	DEFLUT(I)  = DEFLUT(I) + SPL

100     IF(ABS(ARMAZ(I+1)-ARMF).LE.PS*ARMM .OR. KCIC.GT.KCICM) GOTO 105
	ARMF = ARMAZ(I+1)
	GOTO 85
	
C       Convergencia obtida nos armazenamentos : acumula valores de
C       evaporacao e vertimento, e prossegue com outro mes

105     ARMMIN = AMIN1(ARMMIN,ARMAZ(I+1))
	SEVAP = SEVAP + EVAPO
	SUMSP = SUMSP + SPL

C       Testa para ver se chegou ao intervalo final de simulacao                                            

	IF(I .EQ. NVAZ) GO TO 110
	IF(M .EQ. 12) M = 0        

C       Testa para verificacao se houve falha (armazenamento < volume morto)
C       se nao, volte ao inicio do ciclo para mais um mes

	IF(STR2 .GE. STOMOR) GO TO 80
	
C       Falha : contabiliza e verifica se ultrapassa tolerancia
	
	KONTA = KONTA + 1
	PFAL  = KONTA * 100. / NVAZ

C       Se falha nao ultrapassa tolerancia retorne para mais um mes

	IF(PFAL .LE. FTOL) GOTO 80

C       Falha acima da tolerancia : Zera contador

	KONTA = 0

C       Se SMAX fracassa, diminuir X, guardando antes ultimo decrescimo

	DXULT = X
	X = X * ( 1. - ( FLOAT(K) / (KD * KTOT)/(KLOOP+1)))
	DXULT = DXULT - X

	ICRIT = I
	WRITE(*,511) SMAX, X, ICRIT, PFAL, KLOOP
511     FORMAT( ' CAP -> ',1PG10.4,' X -> ',1PG10.4,' I -> ',I5,
     1          ' FAL -> ',1PG10.4,' #',I3)
	
C       Se X for menor que suprimento ao fio de agua, encerre computos

	IF(X .GT. VFIO) GOTO 60        
	
C       X e' menor que suprimento ao fio de agua
	
	KSTOP = 1
	X = AMAX1(0.01, X)

C       Retorna para inicio do balanco hidrico        

	GO TO 60

C       Se percentual de falha estiver em torno do estabelecido e 
C       o armazenamento minimo proximo ao volume morto,
C       ou numero de "loops reversos" for maior que KLOOPM, pare ciclos  
							    
110     IF(  FTOL-PFAL    .LE.        FFTOL             .AND.
     1     ARMMIN-STOMOR  .LE. FTOLS*(STOMOR+SMAX)/2.   .OR.
     1         KLOOP      .GT.        KLOOPM          ) GOTO 115

C       Percentual de falha muito abaixo do requerido : aumente X        
	
	KLOOP = KLOOP + 1
	X = X + KLOOP * DXULT / 1.95

	WRITE(*,5115) KLOOP,PFAL,ARMMIN,X
5115    FORMAT(' ------- LOOP: ',I2,1X,'FALHA: ',F5.2,1X,'VOLMIN: ',
     1         1PG11.4,1X,'SUP: ',1PG11.4)
	
	GOTO 60

C       Se SMAX garante X, finalize as iteracoes
C       Producao garantida e' ajustada para deficit resultante do
C       armazenamento final ser diferente do inicial 

115     XS = X - (SMAX * SININ / 100. - STR2) * (1. / FLOAT(NANOS))

C       Corrige XS caso seja menor que producao ao fio de agua
	
	IF(XS.LE.VFIO) XS = VFIO * 1.0001
	SEVAP = SEVAP / NANOS
	SUMSP = SUMSP / NANOS
	WRITE(*,512)SMAX, XS, PFAL, ARMMIN, ICRIT
	WRITE(2,512)SMAX, XS, SEVAP, SUMSP, ICRIT, PFAL, ARMMIN
512     FORMAT(1X,1PG12.3,1X,1PG12.3,5X,1PG12.3,6X,1PG12.3,7X,I4,5X,
     1  2(1PG11.3))
	
C       Organiza dados para ajuste do polinomio

	YY(K) = (XS - VFIO) / YMED
	XX(K) = (SMAX - STOMOR)/ STORA

C       Armazena defluvios do reservatorio

	DO 120 I = 1,NVAZ
	DEFLU(I,K) = DEFLUT(I)
120     CONTINUE

C       Armazena trajetorias de armazenamentos e defluvios

	WRITE(3,513) TITLER, SMAX
513     FORMAT(1X,A,3X,'CAPACIDADE : ',F10.3/ 
     1         1X,'ARMAZENAMENTO E DEFLUVIOS'/)
	WRITE(3,503) (ARMAZ(I), I = 1,NVAZ) 
	WRITE(3,503) (DEFLUT(I),I = 1,NVAZ)

C       Retorna para outra capacidade

125     IF(KSTOP.EQ.1) GOTO 135
130     CONTINUE        

135     KTOT = AMIN1(K,KTOT)     
	
C       Ajusta polinomio somente se houver mais que 4 pontos

	IF (KMAX.LE.5) GOTO 170
	
	DO 160 K=1,NPOL
	ID=IDD(K)
	CALL REGPOL(YY,XX,B,R,EP,KTOT,ID)
	WRITE(2,514) FTOL, B(1)
	WRITE(*,514) FTOL, B(1)
514     FORMAT(///5X,'FUNCAO AJUSTADA PARA CURVA DE REGULARIZACAO'/
     1 5X,'COM TOLERANCIA DE FALHA = ', F6.3//
     15X,'Y = ', 1PG12.4,' + '/)
	WRITE(2,515) (B(I+1),I,I=1,ID)
	WRITE(*,515) (B(I+1),I,I=1,ID)
515     FORMAT(9X,' + (',1PG12.4,') * X ** ',I2)
	WRITE(*,516) VFIO,YMED,STOMOR,STORA,R,EP
	WRITE(2,516) VFIO,YMED,STOMOR,STORA,R,EP
516     FORMAT(
     35X,'SENDO Y = (PRODUCAO ANUAL - ',G12.4,')/',G12.4/
     45X,'      X = (CAPACIDADE - ',G12.4,' / ',G12.4,')'//
     55X,'COEFICIENTE DE DETERMINACAO = ',G12.4/
     65X,'DESVIO PADRAO DOS RESIDUOS = ',G12.4//
     75X,'ESTIMATIVAS COM MODELO AJUSTADO'/
     85X,'CAPACIDADE UTIL',5X,'PROD. ANUAL OBS.',
     95X,'PRO. ANUAL CAL.')
	
	DO 150 KP = 1,KTOT
	SMAX = STOMOR + XX(KP)*STORA
	XS = YY(KP)*YMED+VFIO
	XSC = B(1)
	DO 140 I = 1,ID
	XSC = XSC + B(I+1)*XX(KP)**I
140     CONTINUE
	XSC = XSC*YMED+VFIO
	WRITE(*,517)SMAX,XS,XSC
	WRITE(2,517)SMAX,XS,XSC
517     FORMAT(1X,3(F16.3,5X))
150     CONTINUE
160     CONTINUE

C       Guarda ultimo valor de KTOT para calculo dos defluvio ao proximo
C       reservatorio (usado apenas para calculo da curva de massa)

	KULT = KTOT

170    CONTINUE

	STOP
	END
	
	SUBROUTINE DATA(N,JANO,VAZAO,ALFA)
C       Entrada de vazoes em m3/s e suas transformacoes em Hm3/mes        
	
	DIMENSION VAZAO(N),ND(12)
	CHARACTER*80 VAZOES
	DATA ND/31,28,31,30,31,30,31,31,30,31,30,31/
	
	READ(1,*) VAZOES
	OPEN(4,FILE=VAZOES,STATUS='OLD')        
	
	READ(4,*) (VAZAO(I), I = 1, N)
	J=0
	IANO = JANO
	DO 20 I = 1, N
	J=J+1
	ND(2) = 28
	IF(J .EQ. 2 . AND . (IANO/4)*4 .EQ. IANO) ND(J) = 29
	IF(J .LE. 12) GOTO 20 
	IANO = IANO + 1
	J = 1

C       TRANSFORMACAO PARA VAZOES DE M3/S*MES EM HM3*MES 

20      VAZAO(I) = ALFA * VAZAO(I) * ND(J) * 0.0864
	
	CLOSE (4)
	
	RETURN
	END
	
	SUBROUTINE REGPOL(Y,X,B,CD,EP,N,ID)
C       REGRESSAO POLINOMIAL POR MINIMOS QUADRADOS;
C       DIMENSIONADA PARA POLINOMIOS ATE GRAU 4;
C       MAIORES GRAU AUMENTAR DIMENSIONS DE ACORDO COM :
C       R(D+1,D+2),A(2*D+1),T(D+2),B(D+1), SENDO D O GRAU DO POLINOMIO
	INTEGER DIDM1
	DIMENSION Y(N),X(N),R(5,6),A(9),T(6),B(5)
	A(1) = N
	IDM1 = ID+1
	IDM2 = ID+2
	DIDM1=2*ID+1
	DO 1 J = 1,IDM2
	T(J) = 0.
	DO 1 I = 1,IDM1
	B(I) = 0.
	R(I,J) = 0.
1       CONTINUE
	DO 2 K = 2,DIDM1
	A(K) = 0.
2       CONTINUE
	DO 30 I = 1,N
	DO 20 J = 2,DIDM1
20      A(J) = A(J)+X(I)**(J-1)
	DO 25 K = 1,IDM1
	R(K,IDM2)=T(K)+Y(I)*X(I)**(K-1)
25      T(K)=T(K)+Y(I)*X(I)**(K-1)
30      T(IDM2)=T(IDM2)+Y(I)**2
	DO 37 J = 1,IDM1
	DO 35 K = 1,IDM1
	JMKM1=J+K-1
35      R(J,K)=A(JMKM1)
37      CONTINUE
	DO 64 J = 1,IDM1
	DO 40 K = J,IDM1
	IF(R(K,J)) 42,40,42
40      CONTINUE
	WRITE(2,1010)
1010    FORMAT(' NAO EXISTE SOLUCAO UNICA PARA O POLINOMIO' )
	RETURN
42      DO 45 I = 1,IDM2
	S=R(J,I)
	R(J,I)=R(K,I)
45      R(K,I)=S
	Z=1/R(J,J)
	DO 50 I = 1,IDM2
50      R(J,I)=Z*R(J,I)
	DO 63 K=1,IDM1
	IF(K.EQ.J) GO TO 63
	Z=-R(K,J)
	DO 60 I=1,IDM2
60      R(K,I)=R(K,I)+Z*R(J,I)
63      CONTINUE
64      CONTINUE
	DO 65 J = 1,IDM1
65      B(J)=R(J,IDM2)
	P=0.
	DO 70 J = 2,IDM1
70      P=P+R(J,IDM2)*(T(J)-A(J)*T(1)/N)
	Q=T(IDM2)-T(1)*T(1)/N
	Z=Q-P
	I=N-ID-1
	CD=P/Q
	EP=SQRT(ABS(Z/I))
	RETURN
	END
