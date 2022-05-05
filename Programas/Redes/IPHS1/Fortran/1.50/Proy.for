      !ms$debug
C  AUTOR: CARLOS E. M. TUCCI
C   Modificações
c     Equipo de Hidrologia do IPH-UFRGS
C   	
c  Historico:
C     16/10/2001 - Adriano Rochedo Conceição
C     - Modificacoes na leitura do arquivo DRVPROY  
C       Este arquivo possui duas strings: 
C         - Nome do arquivo de entrada
C         - Nome do arquivo de saida
C     - A partir de agora este programa passa a ser a versao utilizada pelo
C       IPHS1 para Windows.
C	20/11/2001 - Sobreescreve .sai/ Se Qmax=0 no plota, adota o maximo do hidrograma
c            aumentados todos os limites das matrizes ate 900.
C**********************************************************************
                PROGRAM IPHS1
C               -------------                                         *
C     MODELO DISTRIBUIDO DE SIMULACAO HIDROLOGICA DE EVENTOS ISOLADOS *
C**********************************************************************
C
C       DATA ULTIMA VERSAO 05/02/90
C
C DADOS DE ENTRADA
C
C CARTAO A
C CABE(I)          COMENTARIOS GERAIS
C                  FORMAT(20A4)
C CARTAO B
C NT               NUMERO DE INTERVALOS DE TEMPO
C NS               NUMERO DE OPERACOES HIDROLOGICAS
C NPCH             NUMERO DE POSTOS DE CHUVA
C                        =0 NAO TEM TRANSFORMACAO CHUVA-VAZAO
C NTT              NUMERO DE INTERVALOS DE TEMPO COM CHUVA
C AT               INTERVALO DE TEMPO EM SEGUNDOS
C                        FORMAT(2I10,F10.2)
C
C******* CARTOES C E  D SAO REPETIDOS PARA CADA POSTO DE CHUVA
C CARTAO C 
C NPO              NUMERO DO POSTO DE CHUVA (ORDEM CRECENTE)
C       NCHUVA          =1 TORMENTA DESAGREGADA EM (MM/AT)
C                       =2 TORMENTA DE PROYECTO ACUMULADA EM MM.
C 
C CARTAO  D
C (P(I,J),I=1,NTT) CHUVA PARA O POSTO J
C
C CARTAO E
C CA(I)            COMENTARIO PARA CADA OPERACAO HIDROLOGICA
C                  FORMAT(20A4)
C CARTAO F
C NCOD            NUMERO DE CODIGO DA OPERACAO
C                       =1     PROPAGACAO EM RESERVATORIO
C                 =2     PROPAGACAO EM RIO
C                       =3     TRANSFORMACAO CHUVA-VAZAO
C                 =4     HIDROGRAMA LIDO
C                       =5     SOMA
C                       =6     DERIVACAO
C                       =7     IMPRESSAO FINAL
C IPP             =0     IMPRESAO RESUMIDA DO ALGORIT DE PERDAS
C                 =1     IMPRIME TABELA DE ESCOAM E PERDAS
C IPR             =0     NAO GRAFICA HIDROGRAMA RESULTANTE
C                 =1     GRAFICA
C       ILIST           =0     NAO IMPRIME TABELA DO HIDROGRAMA
C                       =1     IMPRIME TABELA DO HIDROGRAMA
C       IS              NUMERO DE ARMAZENAMENTO DO HIDROGRAMA DE SAIDA
C IE              NUMERO DE ARMAZENAMENTO DO HIDROGRAMA DE ENTRADA
C                       (VALIDO PARA CODIGOS 1,2,6) OUTROS CODIGOS IE=0
C IOBS            0 NAO POSEE DADOS OBSERVADOS
C                 1 POSEE DADOS OBSERVADOS
C CARTAO G        QUANDO IPR E MAIOR QUE ZERO
C QMAX            VAZAO MAXIMA PARA GRAFICAR (M3/S)
C QMIN            VAZAO MINIMA PARA GRAFICAR (M3/S)
C       PMAX            PRECIPITACAO MAXIMA PARA GRAFICAR (MM)
C                 FORMAT(8F10.2)
C CARTAO H        CUANDO IOBS ES MAYOR QUE CERO
C QO(K)           VALORES OBSERVADOS PARA PLOTAR
C                 FORMAT(8F10.2)
C******* NCOD=1 ******** PROPAGACAO EM RESERVATORIO ****************
C       CARTAO I       
C       NO              NUMERO DE MOVIMENTACOES DAS ESTRUTURAS 
C                       ESTRAVAZORAS. (MAX=10)
C                       NO > 0 ==> UMA TABELA Q=F(S) PARA CADA MOV.
C                       NO = 0 ==> OPERACAO UNICA E TABELA H=F(S)
C SI              ARMAZENAMENTO INICIAL NO RESERVATORIO (M3/S)
C CARTAO J         
C                       EXISTE SE NO > 0
C       NP(I)           NUMERO DE PONTOS DA TABELA Q=F(S) (MAX=15)
C       ITT(I)          INTERVALO DE TEMPO ATE O QUAL A OPERACAO I E
C                       VALIDA
C       CARTAO K
C (QD(K,I),S(K,I),K=1,NP(I))
C                       RELACAO VAZAO (M3/S) - ARMAZENAMENTO(M3/S),
C                 PARA CADA MOVIMENTACAO 
C       CARTAO L        EXISTE SE NO = 0
C       NP(1)           NUMERO DE PONTOS DA TABELA H=F(S)
C       CARTAO M  
C                       EXISTE SE NO = 0
C ( H(K,1),S(K,1),K=1,NP(1))
C                       RELACAO COTA (M) - ARMAZENAMENTO(M3/S),
C                 DO VERTEDOR DA BARRAGEM 
C CARTAO N        EXISTE SE NO =0   
C C               COEFICIENTE DE DESCARGA
C XL              LARGURA DO VERTEDOR (M)
C ZK              COTA DA CRESTA DO VERTEDOR (M)
C****** NCOD=2 ********* PROPAGACAO EM RIO *************************
C       CARTAO O
C       NCODP           =1 MUSKINGUM K=F(Q) E X=F(K) - TRECHO UNICO
C                       =2 MUSKINGUM-CUNGE LINEAR
C                       =3 MUSKINGUM-CUNGE NAO LINEAR
C                       =4 MUSKINGUM-CUNGE COM PLANICIE DE INUNDACAO
C       NP              NUMERO DE PONTOS DA TABELA PARA NCODP=1
C       CARTAO P        *** NCODP=1 E NP POSITIVO **** NP CARTOES
C       X(K)            VALOR DO PARAMETRO X DA FUNCAO X=F(Q)
C       XK(K)           VALOR DO PARAMETRO K DA FUNCAO K=F(Q)
C       Q(K)            VALORES DE VAZAO PARA CADA PARA X, K
C       CARTAO Q        *** NCODP=2 ****
C       QREF            VAZAO DE REFERENCA PARA MC-LINEAR (M3/S)
C       CARTAO R        IDEM QUE PARA NCODP=3
C       CARTAO S        *** NCODP=3 ****
C       B               LARGURA DO CANAL (M)
C       ALONG           COMPRIMENTO DO TRECHO DE PROPAGACAO (M)
C       SO              DECLIVIDADE DO FUNDO DO CANAL (M/M)
C       DTCAL           INTERVALO DE TEMPO DE CALCULO (SEG)
C       NTRECH          NUMERO DE SUBTRECHOS
C       RUG             RUGOSIDADE DO TRECHO
C       ILAT            EXISTE QUANDO SE DESEJA QUE UM HIDROGRAMA
C                       APORTE EM FORMA DISTRIBUIDA
C                       NUMERO DE ARMAZENAMENTO DO HIDROGRAMA DE
C                       CONTRIBUICAO LATERAL
C       CARTAO T        *** NCODP=4 ***
C       B               LARGURA DO CANAL PRINCIPAL (M)
C       ALONG           COMPRIMENTO DO TRECHO DE PROPAGACAO (M)
C       SO              DECLIVIDADE DO FUNDO DO CANAL PRINCIPAL (M/M)
C       DTCAL           INTERVALO DE TEMPO DE CALCULO (SEG)
C       NTRECH          NUMERO DE SUBTRECHOS
C       RUG             RUGOSIDADE DO CANAL PRINCIPAL
C       ILAT            EXISTE QUANDO SE DESEJA QUE UM HIDROGRAMA
C                       APORTE EM FORMA DISTRIBUIDA
C                       NUMERO DE ARMAZENAMENTO DO HIDROGRAMA DE
C                       CONTRIBUICAO LATERAL
C       CARTAO U        CARACTERISTICAS DA PLANICIE DE INUNDACAO
C       B1              LARGURA DA PLANICIE DE INUNDACAO (M)
C       RUG1            RUGOSIDADE DA PLANICIE DE INUNDACAO
C       Y0              COTA DO FUNDO DA PLANICIE (M)
C****** NCOD=3********** TRANSFORMACAO CHUVA-VAZAO ***************
C       CARTAO V
C       NTPU            NRO DE POSTOS DE CHUVA EMPREG NA SUB-BACIA
C       LCHUVA          =0 NAO REORDENA A TORMENTA DE PROYECTO
C                       =1 REORDENA A TORMENTA DE PROYECTO
C                       SO APLICAVEL QUANDO A TORMENTA DE PROJETO E 
C                       OBTIDA DE RELACOES I-D-F
C
C       CARTAO W        TORMENTA DE PROYECTO ACUMULADA (NCHUVA=2)
C       (NPU(I),I=1,NTPU)  NUMEROS DOS POSTOS EMPREGADOS(ORDEM CRECENTE)
C CARTAO X 
C (COTH(I),I=1,NTPU) COEFIENTE DOS POLIGONOS DE THIESSENN
C       CARTAO Y        EXISTE SE NCHUVA=2 E LCHUVA=1
C       POS             POSICAO DO PICO DA TORMENTA DE PROYECTO
C                       = 0.25 25% DA DURACAO
C                       = 0.50 50% DA DURACAO
C                       = 0.75 75% DA DURACAO
C       CARTAO Z        ALGORITMOS DE AVALIACAO DE PERDAS
C       NPER            =1 IPHII
C                       =2 SCS
C                       =3 HEC1
C                       =4 FI
C                       =5 HOLTAN
C       CARTAO A1       NPER=1 *** IPHII ***
C XIO             PARAMETRO IO (MM/HORA)
C XIB             PARAMETRO IB (MM/HORA)
C H               PARAMETRO H
C RMAX            PARAMETRO RMAX (MM)
C RT1             VAZAO DE BASE ESPECIFICO AO INICIO DA
C                 CHUVA (M3/SEG/KM2)
C AINP            PORCENTAGEM DE AREA IMPERMEAVEL(0.0-1.0)
C       CARTAO B1       NPER=2 *** SCS ***
C       CN              NUMERO DE CURVA DO SCS
C       CARTAO C1       NPER=3 *** HEC1 ***
C       STRKR           VALOR INICIAL DO COEFICIENTE DE ESCORRENTIA
C       DLTKR           LAMINA A PARTIR DA QUAL NAO SE INCREMENTA O
C                       COEF.DE ESCORRENTIA POR PERDAS INICIAIS[MM]
C       RTIOL           PARAMETRO, DECLIVIDADE DO GRAFICO SEMILOG.
C       ERAIN           EXPOENTE DA PRECIPITACAO
C       CARTAO D1       NPER=4 *** INDICE FI ***
C       PI              PERDA INICIAL (MM)
C       PU              INDICE FI EM (MM/HORA)
C       CARTAO E1       NPER=5 *** HOLTAN ***
C       SAI             EST. INICIAL DO RESER DE UMIDADE DO SOLO[MM]
C       BE              EXPOENTE EMPIRICO
C       FC              INFILTRACAO BASE [MM/HS]
C       GIA             CAPACIDADE DE INFIL INICIAL[MM/HS]    REVISAR
C       CARTAO F1       ALGORITMOS DE PROP DO ESCOAMENTO SUPERFICIAL
C*******NPRPC**********=1 HIDROGRAMA UNITARIO DADO HU( 1 MM.,AT)****************
C                       =2 HIDROGRAMA TRIANGULAR (SCS)
C                       =3 HYMO (NASH MODIFICADO)
C                       =4 CLARK
C NESCB           =0 NAO PROP ESCOAMENTO BASE
C                 =1 PROPAGA( CONDICAO NPER=1 )
C       CARTAO G1       NPROPC=1 *** HU ***
C       NORD            NUMERO DE ORDENADAS DO HU
C       CARTAO H1
C       HUO(K)          ORDENADAS DO HU, K=1,NORD (M3/S)
C       CARTAO I1       NPROPC=2 *** HID TRIANG ***
C       AREA            AREA DA BACIA EM (KM2)
C       TC              TEMPO DE CONCENTRACAO (HORAS)
C       CARTAO J1       EXISTE SE TC=0
C       S               DECLIVIDADE EM (M/KM)
C       CARTAO K1       NPROPC=3 *** HYMO ****
C       AREA            AREA DA SUBACIA EM (KM2)
C       XK              RETARDO DOS RESER. NASH, (HRS) XK=0 USASE AS
C                 EQUACOES DE REGRESSAO
C       TP              TEMPO AO PICO DO HIDROGRAMA UNITARIO EM HORAS
C       CARTAO L1       EXISTE SE TP E/OU XK SAO 0
C       HT              DIFERENCIA DE NIVEL NA SUBACIA EM (M)
C       XL              COMPRIMENTO DO CAUCE PRINCIPAL EM (KM)
C       CARTAO M1       NPRPOPC=4 *** CLARK ****
C XK              PARAMETRO KS (RETARDO DO RES. LIN SIM) (HRS)
C TC              TEMPO DE CONCENTRACAO DA BACIA (HRS)
C XN              PARAMETRO XN (FORMA DO HIST. TEMPO-AREA)
C       AREA            AREA DA SUBBACIA EM (KM2)
C                 FORMAT(8F10.2)
C       CARTAO N1       EXISTE SE XK E/OU TC SAO 0
C       S               DECLIVIDADE DA BACIA EM (M/KM)
C       CARTAO O1       EXISTE SE XN=0
C       HIST(II)        ORDENADAS DO (HIST. TEMPO-AREA) II=1,NH
C 
C CARTAO P1
C AREA            AREA DA BACIA(KM2)
C XKSUB           PARAMETRO DO RES LIN SIM (HRS)
C QSUB0           VAZAO BASE INICIAL(M3/SEG)
C
C ***** NCOD=4 ************** HIDROGRAMA LIDO *************************
C       CARTAO Q1
C Q(J,IS)          HIDROGRAMA CONHECIDO NA SECAO IS   J=1,NT
C ***** NCOD=5 ************** SOMA DE HIDROGRAMAS *********************
C       CARTAO R1
C       NSUM            NUMERO DE HIDROGRAMAS A SER SOMADOS
C       CARTAO S1
C ISM(K)          NUMERO DE ARMAZENAMENTO DOS HIDROGRAMAS
C                 A SER SOMADOS FORMAT(8I10)
C ***** NCOD=6 ************** DERIVACAO *******************************
C       CARTAO T1
C       B1               LARGURA DO CANAL DE DERIVACAO
C       RUGO1            RUGOSIDADE DO CANAL DE DERIVACAO
C       DEC1             DECLIVIDADE DO CANAL DE DERIVACAO

C       B2               LARGURA DO CANAL PRINCIPAL
C       RUGO2            RUGOSIDADE DO CANAL PRINCIPAL
C       DEC2             DECLIVIDADE DO CANAL PRINCIPAL
C ***** NCOD=7 ************* IMPRESSAO DE RESULTADOS ******************
C CARTAO U1
C NPL             CANTIDAD DE SECOES COM GRAFICACAO
C                 CONJUNTA
C CARTAO V1       NPL(+)
C NPL             NUMERO DE HIDROGRAMAS COM GRAFICACAO CONJUNTA
C
C*****************************************************************
c$LARGE
        DIMENSION CABE(20),CA(20)
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),pef(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
       
C       Definirao os nomes de entrada e saida respectivamente
        CHARACTER*160 FNAME
        CHARACTER*160 FNAME1,FNAME3

C       Le os nomes dos arquivos de entrada e saida
1000    FORMAT(1A160)
        OPEN  (3,FILE='DRVPROY',STATUS='OLD')
        READ  (3,1000) FNAME
        READ  (3,1000) FNAME1
        READ  (3,1000) FNAME3

        CLOSE (3)

1001    FORMAT(' ARQUIVO DE ENTRADA: ') 
        WRITE (*,1001) 
        WRITE (*,1000) FNAME 

1002    FORMAT(' ARQUIVO DE SAIDA: ') 
        WRITE (*,1002) 
        WRITE (*,1000) FNAME1

1003    FORMAT(' ARQUIVO DE ERRO: ') 
        WRITE (*,1003) 
        WRITE (*,1000) FNAME3

1100    CONTINUE
        OPEN(1,FILE=FNAME,STATUS='OLD')
        OPEN(2,FILE=FNAME1,STATUS='unknown')
        OPEN(4,FILE=FNAME3,STATUS='unknown')

        READ(1,1)(CABE(I),I=1,20)
        WRITE(2,920)
        WRITE(2,16)(CABE(I),I=1,20)
        READ(1,12) NT,NS,NPCH,NTT,AT
        WRITE(2,15)NT,NS,NPCH,NTT,AT
        IF (NPCH.NE.0) CALL PRECIP(NPCH)
  
        Q=0.

       DO 700 I=1,NS
	
	 if(i.eq.1)then
       WRITE(4,*)NS
  	 WRITE(4,*)i
       WRITE(4,19)(CA(jj),jj=1,20)
	 endif

       READ(1,1)(CA(K),K=1,20)
       READ(1,2)NCOD,IPP,IPR,ILIST,IS,IE,IOBS
       WRITE(2,33) I
        WRITE(2,24)(CA(K),K=1,20)
        WRITE(2,25)NCOD,IPP,IPR,ILIST,IS,IE,IOBS
        IF(IPR.GT.0)READ(1,3)QMAX,QMIN,PMAX
       IF(IOBS.GT.0) READ(1,3)(QO(K),K=1,NT)
        GO TO(150,200,250,300,350,400,450),NCOD
150     CALL PULS
       GO TO 500
200     CALL PROPR
        GO TO 500
250   CALL TCV
       GO TO 500
300    READ(1,3)(Q(J,IS),J=1,NT)
        IF(IPR.EQ.0) GO TO 320
        CALL PLOTA(0)
320     IF(ILIST.EQ.0)GO TO 500
        CALL HID
        GO TO 500
350     CALL SOMA
        GO TO 500
400     CALL DERIV
        GO TO 500
450    READ(1,2)NPL
       IF(NPL)600,600,310
310   READ(1,2)(IPL(K),K=1,NPL)
       CALL PLOTA(1)

500    if(i.eq.1)rewind(4)
       WRITE(4,*)NS
 	 WRITE(4,*)i
       WRITE(4,19)(CA(jj),jj=1,20)
 19    FORMAT(20A4)

700    REWIND(4)
600   STOP
1      FORMAT(20A4)
2      FORMAT(8I10)
3      FORMAT(8F10.2)
12      FORMAT(4I10,F10.2)
15      FORMAT(//10X,'NUMERO  DE  INTERVALOS  DE TEMPO: ',I7/10X,
     1'NUMERO DE OPERACOES HIDROLOGICAS: ',I7/10X,
     2'NUMERO DE POSTOS DE CHUVA       : ',I7/10X,
     3'NUMERO DE INTERVALOS COM CHUVA  : ',I7/10X,
     1/10X,'DURACAO DO  INTERVALO  DE  TEMPO: ',F7.0,' SEG.')
920    FORMAT(//10X,20('*'),30X,20('*')/,10X,'*',68X,'*',/
     1 10X,'*  INSTITUTO DE PESQUISAS HIDRAULICAS',32X,'*'/
     110X,'*  UNIVERSIDADE FEDERAL DO RIO GRANDE DO SUL',25X,'*'/
     110X,'*  MODELO IPHS1',54X,'*'/10X,'*',68X,'*'/10X,20('*'),30X,
     1 20('*'))
16    FORMAT(//,10X,20A4)
24      FORMAT(//,10X,20A4///)
25      FORMAT(/10X,'NCOD=',I3,'  IPP=',I3,'  IPR=',I3,' ILIST=',I3,
     1'  IS=',I3,'  IE=',I3,'  IOBS=',I3)
33    FORMAT(////10X,20('*')/10X,'*',18X,'*'/
     1 10X,'* OPERACAO NRO ',I3,' *'/10X,'*',18X,'*'/10X,20('*'))
900     FORMAT(' NOME DO ARQUIVO DE ENTRADA:')
910     FORMAT(A)
     
	END
C***************************
       SUBROUTINE PRECIP(NPCH)
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),pef(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
       DO 10 J=1,NPCH
       READ(1,110) NPO,NCHUVA
       READ(1,100) (P(I,J),I=1,NTT)
        IF(NCHUVA.EQ.1)GO TO 10
        DO 20 I=NTT,2,-1
20      P(I,J)=P(I,J)-P(I-1,J)
10      CONTINUE
        WRITE(2,900)NPCH,(I,I=1,NPCH)
900     FORMAT(//10X,'NUMERO DE POSTOS COM CHUVA:',I3//
     1  10X,'INT',10X,'POSTO'/9X,'TEMPO',10I6) 
        DO 1000 I=1,NTT
        WRITE(2,200)I,(P(I,J),J=1,NPCH)
1000    CONTINUE
100    FORMAT(8F10.0)
110   FORMAT(8I10)
200     FORMAT(8X,I4,2X,10F6.2)
       RETURN
       END
C****************************
        SUBROUTINE PROPR
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),pef(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
        READ (1,2) NCODP,NP
        GO TO (100,200,300,400),NCODP
100     CALL AMUSK(NP)
        GO TO 1000
200     READ(1,3)QREF
        CALL AMC(NCODP,QREF)
        GO TO 1000
300     CALL AMC(NCODP,QREF)
        GO TO 1000
400     CALL AMCP
1000    IF (IPR.GT.0)CALL PLOTA(0)
        IF (ILIST.GT.0)CALL HID
        RETURN
2       FORMAT(8I10)
3       FORMAT(F10.0)
       END
C**************************
        SUBROUTINE AMUSK(NP)
        DIMENSION X(900),XK(900),QT(900),QM(900)
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),pef(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
      DO 3333 K=1,NP
3333   READ(1,3)X(K),XK(K),QT(K)
        DO 205 J=1,NT
       QM(J)=Q(J,IE)
205   CONTINUE
        Q(1,IS)=QM(1)
        DO 210 J=2,NT
      QENT=QM(J)
        QQ=Q(J-1,IS)
        XX=FINT(QT,X,NP,QQ)
      XKK=FINT(QT,XK,NP,QQ)
        C=XX * XKK
      CC=XKK-C+0.5*AT
      C1=(-C+0.5*AT)/CC
      C2=(C+0.5*AT)/CC
      C3=(XKK-C-0.5*AT)/CC
      write(2,*)'c1=',c1,'   c2=',c2,'   c3=',c3
        QQ=QENT*C1+QM(J-1)*C2+QQ*C3
210     Q(J,IS)=QQ
        WRITE(2,7)(K,X(K),XK(K),QT(K),K=1,NP)
        RETURN
3       FORMAT(3F10.0)
7     FORMAT(//10X,'TRECHO EN CANAL',
     1///,10X,'PARAMETROS',//,15X,'X',9X,
     1'K',5X,'VAZAO',/,100(I6,3F10.2,/))
        END
C**************************
        SUBROUTINE AMC(NCODP,QREF)
        DIMENSION QM(9000),QC(900,5000),QCOR(5000),QL(9000)
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),pef(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
        READ(1,11)B,ALONG,SO,DTCAL,NTRECH,RUG,ILAT
        WRITE(*,11)B,ALONG,SO,DTCAL,NTRECH,RUG,ILAT
      COEF=1.67*SO**0.3/RUG**0.6
        IF(NCODP.EQ.3)GO TO 501
      CEL=COEF* (QREF/B)**0.4
      QESP=QREF/B
        DX=ALONG/NTRECH
      AK=DX/CEL
      XXX=0.5 - (0.5*QESP/SO)/CEL/DX
      DEN=2*AK*(1- XXX)+DTCAL
      C1=(2*AK*XXX+DTCAL)/DEN
      C2=(DTCAL-2*AK*XXX)/DEN
      C3=(2*AK*(1-XXX)-DTCAL)/DEN
501     DO 202 K=1,NT
202     QM(K)=Q(K,IE)
        WRITE(*,1)NCODP
   1    FORMAT(I10) 
      DO24 I=1,NTRECH+1
      DO 24 J=1,200
24      QC(I,J)=0.
      DX=ALONG/NTRECH
      IF(DTCAL.EQ.AT)GO TO 80
      NCALC=AT/DTCAL*(NT-1)+1
      N=AT/DTCAL
      DO 90 I=1,NT-1
      DO 110 J=N*(I-1)+1,N*(I-1)+N
        QL(J)=0
        IF(ILAT.NE.0)QL(J)=(Q(I,ILAT)+(Q(I+1,ILAT)-Q(I,ILAT))
     1*(J-(N*(I-1)+1))/(1.*N))/ALONG
110   QCOR(J)=Q(I,IE)+(Q(I+1,IE)-Q(I,IE))*(J-(N*(I-1)+1))/(1.*N)
 90   CONTINUE
      QCOR(NCALC)=Q(NT,IE)
      GO TO 120
 80   NCALC=NT
      N=1
        WRITE(*,11)ALONG
      DO 130 I=1,NT
        QL(I)=0
        IF(ILAT.NE.0)QL(I)=Q(I,ILAT)/ALONG
130   QCOR(I)=QM(I)
C CONDICAO INICIAL
120   DO 20 J=1,NTRECH+1
20    QC(J,1)=QCOR(1)
C
C CONDICAO DE CONTORNO
C
      DO 30 N=2,NCALC
30    QC(1,N)=QCOR(N)
      DO 40 J=1,NTRECH
      DO 50 N=1,NCALC-1
        C4= 2*QL(N)*DTCAL*DX
107     IF(NCODP.EQ.2)GO TO 399
      Q1=QC(J,N)/B
      Q2=QC(J+1,N)/B
      Q3=QC(J,N+1)/B
        IF((Q1.EQ.0.).AND.(Q2.EQ.0.).AND.(Q3.EQ.0))GO TO 55
      CEL=COEF*(Q1**0.4+Q2**0.4+Q3**0.4)/3.
      QESP=(Q1+Q2+Q3)/3.
      AK=DX/CEL
      XXX=0.5 - (0.5*QESP/SO)/CEL/DX
      D=(QESP/SO)/CEL/DX
      DEN=2*AK*(1- XXX)+DTCAL
      C1=(2*AK*XXX+DTCAL)/DEN
      C2=(DTCAL-2*AK*XXX)/DEN
      C3=(2*AK*(1-XXX)-DTCAL)/DEN
399     C4=C4/DEN
        QC(J+1,N+1)=C1*QC(J,N)+C2*QC(J,N+1)+C3*QC(J+1,N)+C4
        GO TO 50
55      QC(J+1,N+1)=0.
50    CONTINUE
40    CONTINUE
        N=AT/DTCAL
        DO 1040 I=1,NT
1040    Q(I,IS)=QC(NTRECH+1,1+(I-1)*N)
        WRITE(2,209)DX,RUG,B,SO,DTCAL,NTRECH
209     FORMAT(//10X,'PARAMETROS',
     1//10X,'AX',6X,'N',
     14X,'LARGURA',4X,'DECLIVIDADE',4X,'INT. TEMPO',4X,' NTRECH ',
     1/ 9X,' M ',13X,' M ',9X,' M/M ',9X,' SEG',/
     1(F12.1,F7.3,F11.1,F15.5,F14.0,I11))
11    FORMAT(4F10.0,I10,F10.0,I10)
        RETURN
        END
C**************************
        SUBROUTINE AMCP
        DIMENSION QM(900),QC(900,9000),QCOR(900),H(900),QT(900),CEL(900)
     1,AK(900),XXX(900),QL(900)
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),pef(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
        READ(1,11)B,ALONG,SO,DTCAL,NTRECH,RUG,ILAT
        READ(1,12)B1,RUG1,Y0
12      FORMAT(3F10.0)
        DH=Y0/10.
        DX=ALONG/NTRECH
      COEF=1.67*SO**0.3/RUG**0.6
        DO 55 I=1,15
        H(I)=I*DH
        QT(I)=SO**0.5*B*H(I)**1.67/RUG
      CEL(I)=COEF* (QT(I)/B)**0.4
      AK(I)=DX/CEL(I)
55      XXX(I)=0.5 - (0.5*QT(I)/B/SO)/CEL(I)/DX
        DO 70 I=11,15
        DH1=I*DH-Y0
        QT(I)=QT(I)+SO**0.5*B1*DH1**1.67/RUG1
        CEL(I)=1.67*SO**0.5*(B/RUG*(Y0+DH1)**0.67
     1+B1/RUG1*DH1**0.67)
        CEL(I)=CEL(I)/(B+B1)
        AK(I)=DX/CEL(I)
70      XXX(I)=0.5- (0.5*QT(I)/(B+B1)/SO)/CEL(I)/DX
        WRITE(2,209)DX,RUG,B,SO,DTCAL,NTRECH,B1,RUG1,Y0
        WRITE(2,7)(K,H(K),CEL(K),XXX(K),AK(K),QT(K),K=1,15)
        DO 202 K=1,NT
202     QM(K)=Q(K,IE)
      DO 24 I=1,NTRECH+1
      DO 24 J=1,200
24      QC(I,J)=0.
      DX=ALONG/NTRECH
      IF(DTCAL.EQ.AT)GO TO 80
      NCALC=AT/DTCAL*(NT-1)+1
      N=AT/DTCAL
      DO 90 I=1,NT-1
      DO 110 J=N*(I-1)+1,N*(I-1)+N
        QL(J)=0
        IF(ILAT.NE.0)QL(J)=(Q(I,ILAT)+(Q(I+1,ILAT)-Q(I,ILAT))
     1*(J-(N*(I-1)+1))/(1.*N))/ALONG
110   QCOR(J)=Q(I,IE)+(Q(I+1,IE)-Q(I,IE))*(J-(N*(I-1)+1))/(1.*N)
 90   CONTINUE
      QCOR(NCALC)=Q(NT,IE)
      GO TO 120
 80   NCALC=NT
      N=1
      DO 130 I=1,NT
        QL(I)=0
        IF(ILAT.NE.0)QL(I)=Q(I,ILAT)/ALONG
130   QCOR(I)=QM(I)
120   DO 20 J=1,NTRECH+1
20    QC(J,1)=QCOR(1)
      DO 30 N=2,NCALC
30    QC(1,N)=QCOR(N)
      DO 40 J=1,NTRECH
      DO 50 N=1,NCALC-1
        QQ=(QC(J,N)+QC(J+1,N)+QC(J,N+1))/3.
        IF(QQ.LT.QT(1))QQ=QT(1)
        XX=FINT(QT,XXX,15,QQ)
      XKK=FINT(QT,AK,15,QQ)
      DEN=2*XKK*(1- XX)+DTCAL
      C1=(2*XKK*XX+DTCAL)/DEN
      C2=(DTCAL-2*XKK*XX)/DEN
      C3=(2*XKK*(1-XX)-DTCAL)/DEN
        C4=2*QL(N)*DX*DTCAL/DEN
        QC(J+1,N+1)=C1*QC(J,N)+C2*QC(J,N+1)+C3*QC(J+1,N)+C4
50    CONTINUE
40    CONTINUE
        N=AT/DTCAL
        DO 1040 I=1,NT
1040    Q(I,IS)=QC(NTRECH+1,1+(I-1)*N)
209     FORMAT(//10X,'PARAMETROS',
     1//10X,'AX',6X,'N',
     14X,'B ',4X,'SO',4X,'DTCAL',4X,'NTRECH',4X,'BPLAN',4X,'NPLAN',4X,
     1'Y0'
     1/ 9X,'(M)',10X,'(M)',2X,'(M/M)',3X,'(SEG)',15X,'(M)',13X,'(M)',/,/
     1(F12.1,F7.3,F5.1,F7.4,F9.0,I10,F9.1,F9.3,F6.2))
7     FORMAT(//10X,'TRECHO EN CANAL COM PLANICIE DE INUNDACAO',
     1///,9X,'I',9X,'H',7X,'CEL', 9X,'X',9X,
     1'K',5X,'VAZAO',/,
     119X,'M',7X,'M/S',18X,'HS',6X,'M3/S',/,
     1100(I10,F10.2,4F10.2/)//)
11    FORMAT(4F10.0,I10,F10.0,I10)
        RETURN
        END
C**************************
C   CORRIGIDA PARA ACUMULAR AGUA QUANDO A VAZAO DE SAIDA e'IGUAL A 0
        SUBROUTINE PULS
       DIMENSION QD(900,900),S(900,900),FNP(900,900),NP(900)
	1,ITT(900),QM(900)
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),pef(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
        READ(1,4)NO,SI
        s1=si
        IF(NO.EQ.0)GO TO 101
        DO 10 I=1,NO
        READ(1,2)NP(I),ITT(I)
10    READ(1,3)(QD(K,I),S(K,I),K=1,NP(I))         
        
        do k=1,np(i)!transforma o armazenamento a m3/seg
	  S(k,I)=S(k,I)/(1000*at)
	  enddo

	  GO TO 169
101     NO=1
        ITT(1)=NT+1
        READ(1,2)NP(1)
        READ(1,3)(QD(K,1),S(K,1),K=1,NP(1))
   
        do k=1,np(i) !transforma o armazenamento a m3/seg
	  S(k,I)=S(k,I)/(1000*at)
	  enddo
        
        READ(1,3)C,XL,ZK
        DO 168 K=1,NP(1)
      DH=QD(K,1)-ZK
      IF(DH.GT.0.) GO TO 167
      QD(K,1)=0.001*K
      GO TO 168
167     QD(K,1)=C*XL*DH**1.5
168   CONTINUE
169   continue
      smax=0.
      do 166 i=1,no
      npo=np(i)
      if(s(npo,i).gt.smax)smax=s(npo,i)      
166   continue      
c      
      DO 185 I=1,NO
      DO 170 K=1,NP(I)
170   FNP(K,I)=S(K,I)+QD(K,I)/2.
185        CONTINUE  
       DO 175 J=1,NT
175     QM(J)=Q(J,IE)
        IO=1
       NPP=NP(IO)
        Q(1,IS)=FINT(S(1,IO),QD(1,IO),NPP,SI)
       IF(Q(1,IS).LT.0.) Q(1,IS)=0.      
       QI1=QM(1)
       QE=Q(1,IS)
C
       DO 180 J=2,NT
       QI2=QM(J)
        NPP=NP(IO)
       IF(QE.LE.0.)GO TO 20
       ST=FINT(QD(1,IO),S(1,IO),NPP,QE)
       GO TO 21
20     ST=SI
21     VAL=(QI2+QI1)/2.-QE/2+ST
      if(val.gt.smax)write(2,176) j
        IF(J.GT.ITT(IO))IO=IO+1
        NPP=NP(IO)
       Q(J,IS)=FINT(FNP(1,IO),QD(1,IO),NPP,VAL)
       IF(Q(J,IS).LT.0.) Q(J,IS)=0.
       QE=Q(J,IS)
       IF(QE.GT.0.)GO TO 180
       SI=VAL
180   QI1=QI2
C
       WRITE(2,5) S1
        DO 225 I=1,NO
225    WRITE(2,75)ITT(I),(K,QD(K,I),S(K,I),K=1,NP(I))
       IF (IPR.GT.0)CALL PLOTA(0)
        IF (ILIST.GT.0)CALL HID
        RETURN
1      FORMAT(20A4)
2      FORMAT(8I10)
3      FORMAT(8F10.2)
4     FORMAT(I10,F10.0)
5      FORMAT(/10X,'PROPAGACAO EM RESERVATORIO'///
     1,10X,'ESTADO INICIAL S =',F9.1,' M3/S',//)
6      FORMAT(///,10X,10A4)
75     FORMAT(
     110X,'CURVA VAZAO-VOLUME VALIDA ATE O INTERVALO: ',I3,
     1//,10X,'INT',5X,'VAZAO',5X,'VOLUME',/,18X,'(M3/S)',4X,'(M3/S)',
     1/,100(10X,I3,F9.1,F11.1,/))
176   format(/'   ATENCAO !!! : O ARMAZENAMENTO SUPEROU A CAPACIDADE',
     1' DO RESERVATORIO, TEMPO=',I6) 
        END
C**************************
      SUBROUTINE PLOTA(K)
      DIMENSION IY( 6),LL(8),IPLOT(51 ),MY(51)
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),pef(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
       DATA MY/51*'-'/,MAIS/'+'/,IAST/'*'/,IO/'0'/,IPONT/'.'/,
     1IBRAN/' '/,LL/'1','2','3','4','5','6','7','8'/,IPRE/'I'/
      
      IF (QMAX==0)QMAX=MAXVAL(Q(:,IS))
      IF (PMAX==0)PMAX=MAXVAL(Pef)

	CONST= 50/(QMAX-QMIN)
      DO 110 J=1,6
110    IY(J)=(QMAX-QMIN)*.2*(J-1)+0.0001
      DO 100 J=1,51,10
100   MY(J)=MAIS
      WRITE(2,1)(IY(J),J=1, 6),(MY(J),J=1, 51)
      IX=0
      DO 250 J=1,NT
      IF(J/10*10-J)120,150,120
120   DO 130 M=1, 51
130   IPLOT(M)=IBRAN
      DO 140 M=1, 51,10
140   IPLOT(M)=IPONT
      GO TO 170
150   DO 160 M=1, 51
160   IPLOT(M)=MY(M)
170   IF(K)180,180,190
180   M=(Q(J,IS)-QMIN)*CONST+1.0001
        IF(M.GT. 51.OR.M.LE.0)GO TO 181
      IPLOT(M)=IAST
181   IF(IOBS.LE.0) GO TO 183
       M=(QO(J)-QMIN)*CONST+1.001
      IF(M.GT. 51.OR.M.LE.0) GO TO 183
      IPLOT(M)=IO
183   IF(K.GE.0)GO TO 185
        KK= 51.-PEF(J)/PMAX*20.
        IKM= 51-KK+1
        DO 182 II=1,IKM
        MM= 51-II+1
182     IPLOT(MM)=IPRE
185   WRITE(2,2)J,Q(J,IS),(IPLOT(L),L=1, 51)
      GO TO 250
190   DO 200 L=1,NPL
      M=IPL(L)
      M=(Q(J,M)-QMIN)*CONST+1.0001
      IF(M.GT. 51.OR.M.LE.0)GO TO 200
      IPLOT(M)=LL(L)
200   CONTINUE
      WRITE(2,3)J,(IPLOT(L),L=1, 51)
250   CONTINUE
1     FORMAT(///4X,'AT',4X,'VAZAO',I5, 5I10,/,19X, 51A1)
2     FORMAT(I6,F9.2,4X, 51A1)
3     FORMAT(I6,13X, 51A1)
      RETURN
      END
C******************************
      FUNCTION FINT(X,Y,N,ABC)
      DIMENSION X(1),Y(1)
      NM1=N-1
      DO 10 I=2,NM1
      IF(ABC-X(I))20,40,10
10    CONTINUE
      J=N-1
      GO TO 30
20    J=I-1
30    FINT=Y(J)+(Y(I)-Y(J))*(ABC-X(J))/(X(I)-X(J))
      RETURN
40    FINT=Y(I)
      RETURN
      END
C************************
        SUBROUTINE TCV
      DIMENSION NPU(900),COTH(900)
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),pef(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
      DO 30 I=1,NTT
      PA(I)=0.
30    PRE(I)=0.
      READ(1,2) NTPU,LCHUVA
      READ(1,2) (NPU(I),I=1,NTPU)
      READ(1,3) (COTH(I),I=1,NTPU)
      DO 20 J=1,NTPU
      DO 20 I=1,NTT
        KKK=NPU(J)
20    PRE(I)=PRE(I)+COTH(J)*P(I,KKK)
        PA(1)=PRE(1)
        DO 70 I=2,NTT
70      PA(I)=PA(I-1)+PRE(I)
        IF(LCHUVA.EQ.0)GO TO 200
        CALL CHUVAP
200     IF(NTT.GE.NT)GO TO 220
        DO 210 K=NTT+1,NT
        PA(K)=0.
        PEF(K)=0.
210     PRE(K)=0.
220     READ(1,2)NPER
        GO TO(300,400,500,600,700)NPER
300     CALL IPHII
        GO TO 800
400     CALL SCS
        GO TO 800
500     CALL HEC1
        GO TO 800
600     CALL FI
        GO TO 800
700     CALL HOLTAN
800     READ(1,2) NPRPC,NESCB
        GO TO (1000,1100,1200,1300)NPRPC
1000    CALL HU
        GO TO 2000
1100    CALL HIDT
        GO TO 2000
1200    CALL NASH
        GO TO 2000
1300    CALL CLARK
2000  IF(NESCB.NE.0) CALL EBASE
        IF (IPR.EQ.0)GO TO 3000
        CALL PLOTA(-1)
3000    IF (ILIST.EQ.0)GO TO 4000
        CALL HID
4000    RETURN
2       FORMAT(8I10)
3       FORMAT(8F10.0)
        END
C************************
       SUBROUTINE EBASE
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),pef(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
      READ(1,3) AREA,XKSUB,QSUB0
      WRITE(2,5) QSUB0,XKSUB
      XK2=XKSUB*3600./AT
      XK2=EXP(-1/XK2)
      FATOR=AREA*1000/AT
      QSUB1=QSUB0/FATOR
      DO 10 J=1,NT
      QSUB1=QSUB1*XK2+VOP(J)*(1.-XK2)
      Q(J,IS)=Q(J,IS)+QSUB1*FATOR
10    CONTINUE
      RETURN
3     FORMAT(8F10.0)
5     FORMAT(//,10X,'V BASE INIC:',F20.2,' M3/SEG'/
     1 10X,'KSUB             :',F14.2,' HORAS')
      END
C*******************************
        SUBROUTINE CHUVAP
        DIMENSION PORD(900)
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),pef(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
        READ(1,10)POS
        IP=NTT*POS
        IF(IP.LT.2)RETURN
        IF (POS.EQ.0.75)GO TO 400
        IR=(2*IP-2)/2
        L1=IP+IR+1
        L2=NTT
        LS=1
        LC=0
        GO TO 150
400     IR=NTT-IP
        L1=1
        L2=IP-IR-1
        LS=-1
        LC=NTT+1
150     PORD(IP)=PRE(1)
        DO 100 K=1,IR
        PORD(IP+K)=PRE(2*K)
100     PORD(IP-K)=PRE(2*K+1)
        IF(L2.LT.L1)GO TO 500
        DO 200 K=L1,L2
200     PORD(K)=PRE(LS*K+LC)
500     PA(1)=PORD(1)
        PRE(1)=PORD(1)
        DO 300 K=2,NTT
        PRE(K)=PORD(K)
300     PA(K)=PA(K-1)+PRE(K)
        RETURN
10      FORMAT(F10.0)
        END
C************************
        SUBROUTINE SOMA
        DIMENSION ISM(900)
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),pef(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
        READ(1,2)NSUM
        READ(1,3)(ISM(K),K=1,NSUM)
        WRITE(2,5)NSUM,(ISM(K),K=1,NSUM)
        DO 100 I=1,NSUM
        L=ISM(I)
        DO 100 J=1,NT
100     Q(J,IS)=Q(J,IS)+ Q(J,L)
        IF(IPR.EQ.0)GO TO 1000
        CALL PLOTA(0)
1000    IF(ILIST.EQ.0)GO TO 2000
        CALL HID
2000    RETURN
2       FORMAT(I10)
3       FORMAT(8I10)
5       FORMAT(/,10X,'SOMA DE ',I2,' HIDROGRAMAS '//10X,'HIDROGRAMAS ',
     1'SOMADOS:',5I10)
        END
C************************
        SUBROUTINE HID
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),pef(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
        WRITE(2,5)IS
        SUM=0
        DO 100 K=1,NT
100     SUM=SUM+Q(K,IS)
        VOL= SUM*AT/1.E6
        WRITE(2,10)(K,Q(K,IS),K+NT/2,Q(K+NT/2,IS),K=1,NT/2)
5       FORMAT(//10X,'HIDROGRAMA RESULTANTE DA OPERACAO:',I3/
     1/10X,'INT',5X,'   VAZAO',8X,'INT',5X,'   VAZAO'/
     2 9X,'TEMPO',7X,'(M3/S)',6X,'TEMPO',7X,'(M3/S)'/)
10      FORMAT(10X,I3,5X,F8.2,8X,I3,6X,F8.2)
        WRITE(2,20)VOL
20      FORMAT(//,10X,'VOL ESCOADO=',F8.2,' HM3')
        RETURN
        END
C************************
        SUBROUTINE CLARK
        DIMENSION HIST(900),PV(900)
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),pef(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
      DO 999 I=1,50
999   PV(I)=0.
        READ(1,13)XK,TC,XN,AREA
        IF(TC.NE.0.AND.XK.NE.0)GO TO 101
        READ(1,13)SSS
        SSS=10.*SSS
        IF(XK.NE.0)GO TO 102
        XK=80.7*AREA**0.23/SSS**0.7
102     IF(TC.NE.0)GO TO 101
        TC=1.75*AREA**0.41/SSS**0.17
101     NH=TC*3600./AT
        XK1=XK*3600./AT
        QS1=0
        IF(XN.EQ.0)GO TO 234
        C=0.5/(NH/2.)**XN
        L=NH/2
        XA=0.
        DO 232 II=1,L
        XA1=C*(II*1.)**XN
        HIST(II)=XA1-XA
        XA=XA1
        L1=NH-II+1
        HIST(L1)=HIST(II)
 232    CONTINUE
        IF(NH/2*2.EQ.NH)GO TO 236
        HIST(L+1)=(C*(NH/2.)**XN-XA)*2
        GO TO 236
 234    READ(1,3)(HIST(II),II=1,NH)
 236    FATOR=AREA*1000/AT
        WRITE(2,24)
      ATA=AT/60.
        WRITE(2,25)AREA,ATA,TC,XK
        WRITE(2,21)(II,HIST(II),II=1,NH)
        QS1=QS1/FATOR
        XK1=EXP(-1/XK1)
        DO 280 J=1,NT
        VE=PEF(J)
        DO 265 KT=1,NH
265     PV(KT)=PV(KT)+VE*HIST(KT)
        VE=PV(1)
        LL=NH-1
        DO 270 KT=1,LL
270     PV(KT)=PV(KT+1)
        PV(NH)=0.
        QS1=QS1*XK1+VE*(1.-XK1)
        Q(J,IS)=QS1*FATOR
280     CONTINUE
        RETURN
   3    FORMAT(8F10.2)
  13    FORMAT(5F10.2)
 21     FORMAT(///,10X,'HISTOGRAMA TEMPO-AREA',//,10X,'I',3X,
     1'ORDENADA'//,(I11,F10.2))
 24     FORMAT(///,10X,'PARAMETROS DA BACIA - METODO DE CLARK')
 25     FORMAT(/,10X,'AREA',3X,'INTERVALO DE TEMPO',3X,
     1'TEMPO DE CONCENTRACAO',3X,'RET. RES. LINEAR'/,11X,'KM2',
     29X,'MINUTOS',16X,'HORAS',15X,'HORAS'/,F14.1,F16.0,2F21.2)
        END
C *************************
        SUBROUTINE HU
        DIMENSION HUO(900),QT(9000)
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),pef(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
        READ(1,2)NORD
        READ(1,3)(HUO(K),K=1,NORD)
        WRITE(2,5)NORD
        WRITE(2,10)(HUO(K),K=1,NORD)
        DO 100 K=1,NT
100     QT(K)=0.
        DO 200 J=1,NTT
        PE1=PEF(J)
        DO 300 K=J,NORD+J-1
300     QT(K)=QT(K)+PE1*HUO(K-J+1)
200     CONTINUE
        DO 400 J=1,NT
400     Q(J,IS)=QT(J)
        RETURN
2       FORMAT(8I10)
3       FORMAT(8F10.0)
5       FORMAT(/10X,'NUMERO DE ORDENADAS DO HU:',I3/)
10      FORMAT(/10X,'ORDENADAS DO HU(1MM,AT) (M3/S):'//(10X,10 F7.2))
        END
C**********************************
       SUBROUTINE HEC1
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),exe(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
      READ(1,130) STRKR,DLTKR1,RTIOL,ERAIN
        AT1=AT/3600.
      DLTKR=DLTKR1/25.4
C COEFICIENTES COM UNID. [1/PULG.]
      COE1=0.1
      COE2=0.2
      TOTL=0.0
      TOTP=0.0
      TOTE=0.0
      DO 1 I=1,NTT
        PPP=PRE(I)/25.4
      AK=STRKR/RTIOL**(COE1*TOTP)
      IF(TOTP.GE.DLTKR) GO TO 3
C DLTK=(1-TOTP/DLTKR)**2*COE2*DLTKR
      DLTK=(1-TOTP/DLTKR)**2*COE2
      AK=AK+DLTK
3     PE=AK*AT1*(PPP/AT1)**ERAIN
      IF(PE.LE.PPP) GO TO 4
      PER(I)=PPP
      EXE(I)=0.0
      GO TO 5
4     EXE(I)=PPP-PE
      PER(I)=PE
5     TOTP=TOTP+PER(I)
      TOTL=TOTL+PPP
      TOTE=TOTE+EXE(I)
1     CONTINUE
      DO 6 I=1,NTT
      EXE(I)=EXE(I)*25.4
6     PER(I)=PER(I)*25.4
      TOTP=TOTP*25.4
      TOTE=TOTE*25.4
      TOTL=TOTL*25.4
      WRITE(2,100) STRKR,DLTKR1,RTIOL,ERAIN
100   FORMAT(2(/),10X,'METODO EXPONENCIAL',2(/),10X,'STRKR=',F9.2,
     1 /10X,'DLTKR =',F8.2,' MM'/10X,'RTIOL =',F8.2/10X,'ERAIN =',
     2 F 8.2,2(/))
      IF(IPP.EQ.0) GO TO 33
      WRITE(2,280)
280     FORMAT(/,10X,'INT',5X,'PRECIP',5X,'PACUM',5X,'PERD ',5X,'PEFCT'/
     119X,'(MM)',7X,'(MM)',5X,'(MM)',7X,'(MM)'/)
      WRITE(2,260)(I,PRE(I),PA(I),PER(I),EXE(I),I=1,NTT)
260   FORMAT(10X,I3,F11.2,F10.2,F9.2,F10.2)
33    WRITE(2,110) TOTL,TOTP,TOTE
110   FORMAT(2(/),10X,'TOTAL PRECIPITADO',F10.2,' MM',/,10X,'TOTAL',
     1' DE PERDAS',F12.2,' MM'/,10X,'TOTAL DE EXCESOS ',F10.2,' MM'//)
130   FORMAT(5F10.0)
      RETURN
       END
C*******************************
      SUBROUTINE FI
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),exe(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
      READ(1,150) PI,PU1
150   FORMAT(2F10.2)
        WRITE(2,120)PI,PU1
      TOTP=0.0
      TOTL=0.0
      TOTE=0.0
        PU=PU1*AT/3600.
      PREI=PI
      DO 1 I=1,NTT
        PPP=PRE(I)
      PER(I)=0.0
      IF(PREI.LE.0.0) GO TO 2
      IF(PREI.GE.PPP) GO TO 3
      PER(I)=PREI
      PR=PPP-PREI
      PREI=0.0
      PX=PR*PU/PPP
      IF(PX.GE.PR) GO TO 4
      PER(I)=PER(I)+PX
      EXE(I)=PPP-PER(I)
      GO TO 5
4     EXE(I)=0.0
      PER(I)=PER(I)+PR
      GO TO 5
3     PER(I)=PPP
      PREI=PREI-PPP
      EXE(I)=0.0
      GO TO 5
2     IF(PPP.GE.PU) GO TO 6
      PER(I)=PPP
      EXE(I)=0.0
      GO TO 5
6     PER(I)=PU
      EXE(I)=PPP-PU
5     TOTP=TOTP+PER(I)
      TOTL=TOTL+PPP
1     TOTE=TOTE+EXE(I)
120   FORMAT(2(/),10X,'METODO DA PERDA INICIAL E INDICE FI',
     12(/),10X,'PERDA INICIAL =',F 5.1,' MM',3X,
     1 'INDICE FI =',F 5.1,' MM/H',2(/))
      IF(IPP.EQ.0) GO TO 33
        WRITE(2,280)
280     FORMAT(/,10X,'INT',5X,'PRECIP',5X,'PACUM',5X,'PERD ',5X,'PEFCT'/
     119X,'(MM)',7X,'(MM)',5X,'(MM)',7X,'(MM)'/)
      WRITE(2,260)(I,PRE(I),PA(I),PER(I),EXE(I),I=1,NTT)
260   FORMAT(10X,I3,F11.2,F10.2,F9.2,F10.2)
33    WRITE(2,110) TOTL,TOTP,TOTE
110   FORMAT(2(/),10X,'TOTAL PRECIPITADO',F10.2,' MM',/,10X,'TOTAL',
     1' DE PERDAS',F12.2,' MM'/,10X,'TOTAL DE EXCESOS ',F10.2,' MM'//)
130   FORMAT(5F10.0)
      RETURN
      END
C******************************
       SUBROUTINE SCS
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),exe(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
      READ(1,100) CN
100   FORMAT(F10.2)
      S=(1000./CN-10)*25.4
      PIA=0.2*S
      TOTE=0.0
      TOTP=0.0
      TOTL=0.0
      DO 3 I=1,NTT
      IF(PIA.LT.PA(I)) GO TO 1
      PER(I)=PRE(I)
      EXE(I)=0.0
      GO TO 2
1     EXE(I)=(PA(I)-PIA)**2/(PA(I)+0.8*S)-TOTE
      PER(I)=PRE(I)-EXE(I)
2     TOTP=TOTP+PER(I)
      TOTE=TOTE+EXE(I)
      TOTL=TOTL+PRE(I)
3     CONTINUE
      WRITE(2,130) CN
130   FORMAT(2(/),10X,'AVALIACAO DE PERDAS'//,
     1  10X,'METODO DO SCS-EE.UU.',2(/),
     110X,'CURVA NUMERO (CN) =',F10.0,2(/))
      IF(IPP.EQ.0) GO TO 33
        WRITE(2,280)
280     FORMAT(/,10X,'INT',5X,'PRECIP',5X,'PACUM',5X,'PERD ',5X,'PEFCT'/
     119X,'(MM)',7X,'(MM)',5X,'(MM)',7X,'(MM)'/)
      WRITE(2,260)(I,PRE(I),PA(I),PER(I),EXE(I),I=1,NTT)
260   FORMAT(10X,I3,F11.2,F10.2,F9.2,F10.2)
33    WRITE(2,110) TOTL,TOTP,TOTE
110   FORMAT(2(/),10X,'TOTAL PRECIPITADO',F10.2,' MM',/,10X,'TOTAL',
     1' DE PERDAS',F12.2,' MM'/,10X,'TOTAL DE EXCESOS ',F10.2,' MM'//)
      RETURN
      END
C*******************************
      SUBROUTINE HOLTAN
      COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),exe(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
      READ(1,120)SAI,BE,FC1,GIA1
120   FORMAT(4F10.2)
      AT1=AT/3600.
      FC=FC1*AT1
      GIA=GIA1*AT1
      TOTP=0.0
      TOTL=0.0
      TOTE=0.0
      SA1=SAI
      DO 1 I=1,NTT
        PPP=PRE(I)
      AD=PPP
      F1=GIA*SA1**BE+FC
      PVI=F1
      IF(PVI.GE.AD) GO TO 2
      AD=PVI
2     SA2=SA1-AD+FC
      IF(SA2.LE.0.0) GO TO 6
      F2=GIA*SA2**BE+FC
      PVI=.5*(F1+F2)
      IF(AD.LE.PVI) GO TO 3
      AD=AD-0.1
      IF(AD.GE.0.0) GO TO 2
      AD=0.0
      GO TO 2
3     PER(I)=AD
      GO TO 7
6     PER(I)=SA1+FC
      SA2=0.0
7     SA1=SA2
      EXE(I)=PPP-PER(I)
      TOTL=TOTL+PPP
      TOTE=TOTE+EXE(I)
      TOTP=TOTP+PER(I)
1     CONTINUE
      WRITE(2,140) SAI,BE,FC1,GIA1
140   FORMAT(2(/),10X,'METODO DE HOLTAN',2(/),10X,'SAI =',F 5.1,
     1 ' MM',3X,'BE =',F 5.1,3X,'FC =',F 5.1,' MM/HS',3X,
     2 'GIA =',F5.1,' MM/HS',2(/))
      IF(IPP.EQ.0) GO TO 33
        WRITE(2,280)
280     FORMAT(/,10X,'INT',5X,'PRECIP',5X,'PACUM',5X,'PERD ',5X,'PEFCT'/
     119X,'(MM)',7X,'(MM)',5X,'(MM)',7X,'(MM)'/)
      WRITE(2,260)(I,PRE(I),PA(I),PER(I),EXE(I),I=1,NTT)
260   FORMAT(10X,I3,F11.2,F10.2,F9.2,F10.2)
33    WRITE(2,110) TOTL,TOTP,TOTE
110   FORMAT(2(/),10X,'TOTAL PRECIPITADO',F10.2,' MM',/,10X,'TOTAL',
     1' DE PERDAS',F12.2,' MM'/,10X,'TOTAL DE EXCESOS ',F10.2,' MM'//)
130   FORMAT(5F10.0)
      RETURN
      END
C*********************************
      SUBROUTINE IPHII
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),exe(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
      READ(1,140) AIO,AIB,HK,RMAX,RT1,AINP
140   FORMAT(6F10.2)
      RT11=RT1*AT/0.1E+04
      TOTP=0.0
      TOTL=0.0
      TOTE=0.0
      BI=AIO/ALOG(HK)/(AIO-AIB)
      AI=-AIO*BI
      ATT=0.
      BT=-AIO/AIB/ALOG(HK)
      AIL=-AI/BI
      BIL=1./BI
      ATL=0.
      BTL=1/BT
      SMAX=-AIO/ALOG(HK)
      SX=RT11*(0.5+BT)
      SO=SX
      RI=AIL+BIL*SX
      T=ATL+BTL*SX
      R=0.
      DO 1 I=1,NTT
      RD=RMAX-R
        PR=PRE(I)
      IF(PR.GT.RD) GO TO 2
      R=R+PR
      PR=0.
      GO TO 6
2     PR=PR-RD
      R=RMAX
6     AT1=1.
      VES=PR*AINP
      PR=PR-VES
      IF(PR.GE.RI) GO TO 4
      S1=(SX*(2.-1/BT)+2*PR)/(2+1/BT)
      RI1=AIL+BIL*S1
      IF(PR.GE.RI1) GO TO 5
      T=ATL+BTL*S1
      VE=0.
      VI=PR
      GO TO 8
5     SXX=AI+BI*PR
      ATX=2.*BT*(SXX-SX)/(2.*PR*BT+2.*ATT-SXX-SX)
      AT1=AT1-ATX
      RAUX=PR
      VAUX=PR*ATX
      GO TO 7
4     RAUX=RI
      VAUX=0.0
7     RI1=AIB+(RAUX-AIB)*HK**AT1
      S1=AI+BI*RI1
      T=ATL+BTL*S1
      VI=AIB*AT1+(RAUX-AIB)*(HK**AT1-1)/ALOG(HK)+VAUX
      VE=PR*AT1-VI+VAUX
8     VOP(I)=SX-S1+VI
      VE=VE+VES
      PER(I)=PRE(I)-VE
      EXE(I)=VE
      TOTL=TOTL+PRE(I)
      TOTP=TOTP+PER(I)
      TOTE=TOTE+EXE(I)
      SX=S1
      RI=RI1
1     CONTINUE
      WRITE(2,150) AIO,AIB,HK,SO,RMAX
150   FORMAT(2(/),10X,'METODO IPHII',2(/),/,10X,
     1'AIO =',F10.1,' MM/H' /,10X,'AIB =',F10.1,' MM/H'/,10X,
     1'HK  =',F10.2,/,
     110X,'ST  =',F10.2,' MM'/,10X,'RMAX=',F10.1,' MM',3(/))
      IF(IPP.EQ.0) GO TO 33
        WRITE(2,280)
280     FORMAT(/,10X,'INT',5X,'PRECIP',5X,'PACUM',5X,'PERD ',5X,'PEFCT'/
     119X,'(MM)',7X,'(MM)',5X,'(MM)',7X,'(MM)'/)
      WRITE(2,260)(I,PRE(I),PA(I),PER(I),EXE(I),I=1,NTT)
260   FORMAT(10X,I3,F11.2,F10.2,F9.2,F10.2)
33    WRITE(2,110) TOTL,TOTP,TOTE
110   FORMAT(2(/),10X,'TOTAL PRECIPITADO',F10.2,' MM',/,10X,'TOTAL',
     1' DE PERDAS',F12.2,' MM'/,10X,'TOTAL DE EXCESOS ',F10.2,' MM'//)
130   FORMAT(5F10.0)
      RETURN
      END
C*******************************
        SUBROUTINE HIDT
        DIMENSION QU(900),QT(900)
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),pef(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
        DO 1001 I=1,NT
1001    QT(I)=0.
      READ(1,2)AR,TC
        IF(TC.NE.0.)GO TO 101
        READ(1,2)SSS
        SSS=10.*SSS
        TC=3.83*AR**0.41/SSS**0.17
101   TP=AT/7200.+.6*TC
      QP=0.208*AR/TP
      TB=2.67*TP
      WRITE(2,5)AR,TC,QP,TP,TB
      TR=AT/3600.
      NH=TB/TR
      DO 220 J=1,NH
      ITG=J
      IF(J.GT.TP/TR)GO TO 215
      QU(ITG)=QP*J/(TP/TR)
      GO TO 220
215   QU(ITG)=QP*(TB/TR-J)/(TB/TR-TP/TR)
220   CONTINUE
        DO 200 J=1,NTT
        PE1=PEF(J)
        DO 300 K=J,NH+J-1
300     QT(K)=QT(K)+PE1*QU(K-J+1)
200     CONTINUE
        DO 400 J=1,NT
400     Q(J,IS)=QT(J)
        RETURN
2     FORMAT(8F10.2)
5     FORMAT(/10X,'HIDROGRAMA DE PROJETO PELO METODO SCS',
     1//10X,'AREA DA BACIA:        ',F10.2,1X,'KM2',/10X,
     1'TEMPO DE CONCENTRACAO:',F10.2,1X,'HORAS',
     1/10X,'QP UNITARIO (1MM,AT):',F11.2,1X,'M3/S'/
     110X,'TP UNITARIO:          ',F10.2,1X,'HORAS'/
     110X,'TB UNITARIO:          ',F10.2,1X,'HORAS')
      END
C****************************************
        SUBROUTINE DERIV
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),pef(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
      READ(1,3)  B1,RUGO1,DEC1, B2,RUGO2,DEC2
      WRITE(2,8)  B1,DEC1,RUGO1, B2,DEC2,RUGO2
      FAC=1+B2/B1*(DEC2/DEC1)**0.5*RUGO1/RUGO2
      Q(1,IS)=Q(1,IE)/FAC
      Q(1,IE)=Q(1,IE)-Q(1,IS)
      ALFA=RUGO2**0.6/(DEC2**0.3*B2**0.6)
      H=ALFA*Q(1,IE)**0.6
      DO 35 J=2,NT
      RP=(2*H+B1)/(2*H+B2)
      FAC=1+RP**0.667*(B2/B1)**1.667*(DEC2/DEC1)**0.5*(RUGO1/RUGO2)
      Q(J,IS)=Q(J,IE)/FAC
      Q(J,IE)=Q(J,IE)-Q(J,IS)
      ALFA=RUGO2**0.6*(2*H+B2)**0.4/(DEC2**0.3*B2)
      H=ALFA*Q(J,IE)**0.6
35    CONTINUE
        IF(IPR.GT.0)CALL PLOTA(0)
        IF(ILIST.GT.0)CALL HID
        RETURN
3       FORMAT(8F10.0)
8       FORMAT(/10X,'DERIVACAO'//10X,'CANAL DERIV:', '  B=',F7.2,
     1 ' M    DEC=',F7.5,'   RUG=',F7.3
     1                         /10X,'CANAL PRINC:', '  B=',F7.2,
     1 ' M    DEC=',F7.5,'   RUG=',F7.3)
       END
C**********************************
      SUBROUTINE NASH
      DIMENSION CFS(900)
        COMMON /DATA/Q(900,900),IPL(900),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1pre(900),AT,QO(900),IOBS,IPR,ILIST,PA(900),pef(900),NTT,per(900),
     2PMAX,vop(900),p(900,900)
        MM=0
      WRITE(2,3003)
      READ(1,3010) AREA,XK,TP
3010  FORMAT(10F10.0)
      IF(XK.NE.0.) GO TO 2
        MM=1
      READ(1,3010) HT,XL
      SLOPE=HT/XL
      XLDW=(XL**2.)/AREA
      XK=5.9485119*(AREA**.231)*(SLOPE**(-.777))*(XLDW**.124)
      TP=1.4413144*(AREA**.422)*(SLOPE**(-.46))*(XLDW**.133)
2     PEAK=1.
      DO 45 I=1,50
 45   Q(I,IS)=0.
C CALCULA N POR ITERACAO
 103  XN=5.0
      XKTP=XK/TP
      DO 20 I=1,50
      TINF=1.+SQRT(1./(XN-1.))
      XN1=.05/(XKTP*(ALOG(TINF/(TINF+.05))+.05))+1
      DIFF=ABS(XN1-XN)
      IF(DIFF-.001)21,21,22
 22   XN=XN1
 20   CONTINUE
      WRITE(*,23)
 23   FORMAT('N NO CONVERGE LUEGO DE 50 ITERACIONES')
      GO TO 16
C DETERMINA C1.
 21   DELT=TINF/100.
      TC1=0.
      XN1P=XN-1.
      XN1M=1.-XN
      DO 24 I=2,101
      TC1=TC1+DELT
      CFS(I)=(TC1**XN1P)*EXP(XN1M*(TC1-1.))
24    CONTINUE
      SUM=CFS(101)/2.
      DO 25 I=2,100
 25   SUM=SUM+CFS(I)
      C1=SUM*DELT
      CFSII=CFS(101)
      TTINF=TINF*TP
      TREC1=TTINF+2.*XK
      EEE=EXP((TTINF-TREC1)/XK)
      XK1=3.*XK
      B=7.056  /(C1+CFSII*(XKTP*(1.-EEE)+EEE*(XK1/TP)))
C CALCULA B, QP E CFSI.
        QP=(B*AREA)/TP/25.4
      CFSI=QP*CFS(101)
      CFSR1=CFSI*EEE
      IF(MM.EQ.1) WRITE(2,3008) HT,XL
      WRITE(2,3007) XN,XK,QP,TP
3007   FORMAT(10X,'NRO RESER=',F13.1,5X,'CTE RESER =',F10.1,' HS',/
     110X,'PICO UNIT(M3/S)=',F7.1,5X,'TP UNIT =',F10.1,' HS')
3008  FORMAT(10X,'MAX DESNIVEL =',F10.1,' M',3X,'COMP CANAL PRIN =',
     1 F10.1,' KM',/)
C CALCULO DEL HIDROGRAMA UNITARIO
      T2=0
      CFS(1)=0.
      DO 11 I=2,100
      T2=T2+AT/3600.
      IF(T2-TTINF)9,9,10
9     CFS(I)=QP*((T2/TP)**XN1P)*EXP(XN1M*(T2/TP-1.))
      GO TO 11
10    IF(T2-TREC1) 41,41,42
41    CFS(I)=CFSI*EXP((TTINF-T2)/XK)
      GO TO 11
42    IF(CFSR1*EXP((TREC1-T2)/XK1).GT.0.001) GO TO 771
      CFS(I)=0.
      GO TO 12
771   CFS(I)=CFSR1*EXP((TREC1-T2)/XK1)
      IF(CFS(I)-0.1)12,12,11
 11   CONTINUE
      I=100
 12   ICND=I
C CALCULO DEL HIDROGRAMA DE LA TORMENTA
      DO 43 J=2,NTT+1
      N=J+ICND-2
      IF(N - 100) 46,46,47
 47   N=100
 46   KK=J
      I=2
      DO 43 K=KK,N
      Q(K,IS)=Q(K,IS)+PEF(J-1)*CFS(I)
 43   I=I+1
      M=K-1
      RO=0.
      DO 44 I=2,M
C CALCULO DO VOLUME ESCOADO
      RO=RO+Q(I,IS)
C DETERMINACAO DO PICO
      IF(Q(I,IS)-PEAK) 44,44,112
 112  PEAK=Q(I,IS)
 44   CONTINUE
      ROIN=(RO*AT)/(AREA*0.1E+04)
      WRITE(2,3005) ROIN,PEAK,AREA
3005  FORMAT(//,10X,'LAMINA(MM)=',F8.1,3X,'QP(M3/S)=',F8.2,3X,
     1'AREA(KM2)=',F8.2)
3003  FORMAT(5(/),10X,'METODO DE NASH MODIFICADO',///)
16    RETURN
	pause
      END
