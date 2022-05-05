C    ------------------------------------------------------------
C     IPHMEN
C      ------
C    Modelo precipitacao-vazao com intervalo de tempo mensal.             
C    Esse modelo e programa foi desenvolvido no Instituto de 
C    Pesquisas Hidraulicas da UFRGS pelo prof. Carlos E.M.Tucci
C    versao de marco de 1994.
C     DATA   QUEM   MODIFICAO
C    02/2002 DANIEL PARA JUNTAR AO IPHS1WIN
C
C    ------------------------------------------------------------
      SUBROUTINE IPHMEN
      DIMENSION EPS(7),Y(7),CABE(20)
      COMMON/DID/ P(1000),E(1000),QO(1000),Q(1000),QT1,M,IQ(7),X(7)
     1,SQ1,FATOR,ST,STT,SF1,R2,DE,IOP3,SS,IOP4,QF1
      P=0.
	E=0.
	QO=0.
	IQ=0.
	X=0.
      
      READ(1,10)CABE
      READ(1,1)NT,IOP3,IOP4
      SF1=1.E10
      SF=0.
      WRITE(2,10)CABE
      READ(1,2)(P(J),J=1,NT)
      READ(1,2)(E(J),J=1,NT)
      READ(1,2)(QO(J),J=1,NT)
      IF(IOP3.EQ.0)READ(1,1) (IQ(J),J=1,7)
      READ(1,2) (X(J),J=1,7)
      N=0
      ST=0.
      SS=0.
      STT=0.
      DO 85 J=1,NT
  85  SS=SS+QO(J)
      SM=SS/NT
      DO 87 J=1,NT
      ST=ST+((QO(J)-SM)/QO(J))**2
  87  STT=STT+(QO(J)-SM)**2 
      IF(IOP3.NE.0)GO TO 110
      DO 100 J=1,7
      IF(IQ(J).LE.0)GO TO 100
      N=N+1
      Y(N)=X(J)
  100 CONTINUE
      READ(1,2) (EPS(J),J=1,N)
      READ(1,13)MAXK,MKAT,MCYC,ALPHA,BETA,NSTEP,EPSY
      EPSY=EPSY*ST/100.
  110 READ(1,2)QT1,AREA
      FATOR=2628./AREA
      WRITE(2,24)
      WRITE(2,25)AREA,QT1
      WRITE(2,5)(X(K),K=1,7)
      IF(IOP3.GT.0)GO TO 120
      WRITE(2,6)(K,IQ(K),EPS(K),K=1,N)
      WRITE(2,7)MAXK,MKAT,MCYC,ALPHA,BETA,NSTEP,EPSY
      WRITE(2,29)
      WRITE(2,30)
  120 M=NT
      QT1=QT1*FATOR
      IF(IOP3.LE.0)GO TO 130
      CALL OBJEC(X,SF,7)
      GO TO 160
  130 CALL ROSE1(Y,EPS,N,MAXK,MKAT,MCYC,ALPHA,BETA,NSTEP,EPSY)
      N=0
      DO 150 J=1,7
      IF(IQ(J).LE.0)GO TO 150
      N=N+1
      X(J)=Y(N)
 150  CONTINUE
      CALL OBJEC(Y,SF,N)
      WRITE(2,9) (X(J),J=1,7)
 160  SQ2=SQ1/NT
      WRITE(2,26)SF1,QF1,SS,SQ1
      WRITE(2,27)SM,SQ2,DE
      CALL PLOTA2(1,NT,QO,Q,P,CABE)
  1   FORMAT(8i10)
   2  FORMAT(12F10.1)
  3   FORMAT(I10,4F10.4)
    5 FORMAT(///,5X,'VALOR DOS PARAMETROS DO MODELO',//,6X,'A',6X,'B'
     1,7X,'C',6X,'KS',4X,'KSUB',6X,'CR',6X,'ALF'/,7F8.2)
    6 FORMAT(///,10X,'PARAMETROS DA OTIMIZACAO',//,3X,'ORDEM',3X,'IQ',3X
     1,'ESPACAMENTO',/,(I7,I6,F11.3))
    7 FORMAT( /,5X,'MAXK',3X,'MKAT',3X,'MCYC',3X,'ALPHA',3X,'BETA',3X,'N
     1STEP',3X,'EPSY',/,I9,2I7,F8.2,F7.2,I8,F7.2)
    9 FORMAT(///,5X,'VALORES FINAIS PARA OS PARAMETROS DO MODELO',//,
     16X,'A',6X,'B',7X,'C',6X,'KS',4X,'KSUB',6X,'CR',5X,'ALF',/,8F8.2)
  10  FORMAT(20A4)
  13  FORMAT(3I10,2F10.2,I10,F10.2)
   22 FORMAT(' ',4X,50('-'),///,19X,'MODELO IPH II-MENSAL',//,15X,
     1'SIMULACAO PRECIPITACAO-VAZAO',///,4X,50('-'),////,2X,20A4)
   23 FORMAT(I10,F10.1,F10.1,F10.4)
   24 FORMAT(///,5X,'PARAMETROS DA BACIA')
   25 FORMAT(/,5X,'AREA',5X,'VAZAO INICIAL DE BASE',/,5X,'KM2',14X,
     1'M3/S',/F9.1,F19.1)
   26 FORMAT(///,5X,'ESTATISTICA DOS RESULTADOS',//,2X,'FUNCAO OBJETIVA
     1',4X,'R2',2X,'VOLUME',5X,'VOLUME',/,25X,'OBSERVADO',2X,'CALCULADO'
     2/,27X,'M3/S',7X,'M3/S',/,2X,F12.2,1X,F8.2,2X,F8.2,1X,F8.2,/)
   27 FORMAT(/,2X,'VAZAO MEDIA',3X,'VAZAO MEDIA',3X,
     1 'DESVIO PADRAO',/,3X,'OBSERVADA',5X,'CALCULADA',/
     2 F12.2,F13.2,F15.2)
   29 FORMAT(/5X,'LEGENDA DOS RESULTADOS',//,5X,'QCM = Vazao media cal
     1culada',/,5x,'QOM = Vazao media observada',/,5x,'EV = erro media 
     2percentual no volume',/,5x,'R2A = R2 absoluto= 1-[Som(Qo-Qc)**2/So
     3m(Qo-Qom)**2]' ,/,5x,'DE = Desvio padrao',/,5x'R2R = R2 relativo =
     41 -{Som[(Qo-Qc)/Qo]**2/Som[(Qo-Qom)/Qo]**2',/,5x,'DR = Somatorio d
     5o erro = [Som (Qo-Qc)/Qo]**2',/,5X,'DA = Somatorio absoluto = [Som
     6 (Qo-Qc)**2]')
   30 FORMAT(5X,//,'Primeira linha os parametros A, B, C, Ks, Kb, Cr, Al
     1f',//,'Segunda linha as estatisticas QCM, QOM, EV, R2A,DE, R2R, DR
     2, DA')
 240  RETURN
      END

      SUBROUTINE PLOTA2(I1,I2,QS,Q,PI,CABE)
      DIMENSION  CABE(20),Q(1),QS(1),PI(1),MY(101),IY(7),IPLOT(101)
     1 ,PS(900)
      INTEGER YI(5)
      DATA MY/101*'-'/,MAIS/'+'/,IAST/'O'/,IO/'*'/,IPONT/'.'/,
     1IPREC/'I'/,IBRAN/' '/
      WRITE(2,5) CABE
      QMAX=0
      QMIN=10000.
      PMAX=0
      PMIN=10000.
      DO 80 I=I1,I2
      IF(QMIN.GT.Q(I)) QMIN= Q(I)
      IF(PMIN.GT.PI(I)) PMIN=PI(I)
      IF(PMAX.LT.PI(I)) PMAX=PI(I)
      IF(QMAX.LT.Q(I)) QMAX=Q(I)
      IF(QS(I).EQ.0)GO TO 80
      IF(QMIN.GT.QS(I))QMIN=QS(I)
      IF(QMAX.LT.QS(I))QMAX=QS(I)
80    CONTINUE
      QMIN= QMIN* .85
      PMIN= PMIN* .85
      PMAX= PMAX*1.15
      QMAX= QMAX*1.15
      CONST= 40./(QMAX-QMIN)
      CONSK= 10./(PMAX-PMIN)
      DO 100 J=1,51,5
100   MY(J)= MAIS
      DO 110  J=1,9
110   IY(J)= (QMAX-QMIN)*0.1250000*(J-1)+ 0.0001+ QMIN
      DO 120 J=1,3
120   YI(J)= PMAX - ((PMAX-PMIN)*0.50*(J-1)+0.0001 + PMIN)
      WRITE(2,2)(IY(J),J=1,9),(YI(J),J=1,3),(MY(J),J=1,51)
      DO 220  J=I1,I2
      IF(J/5*5.NE.J)THEN
      DO 130 M=1,51
130   IPLOT(M)=IBRAN
      DO 140 M=1,51,5
140   IPLOT(M)=IPONT
      ELSE
      DO 150 M=1,51
150   IPLOT(M)=MY(M)
      ENDIF
      K=(QS(J)-QMIN)* CONST+1.0001
      IF(K.GT.40.OR.K.LE.0) GO TO 170
      IPLOT(K)= IAST
170   K=(Q(J)-QMIN)*CONST+1.0001
      IF(K.GT.40 .OR.K.LE.0) GO TO 175
      IPLOT(K)=IO
175   K=(PI(J)-PMIN)*CONSK+ 1.0001
      IF(K.GT.20 .OR.K.LE.00) GO TO 210
      DO 200 I=51-K,51
200   IPLOT(I)=IPREC
210   WRITE(2,3) J,QS(J),Q(J),PI(J),(IPLOT(I),I=1,51)
220   CONTINUE
      WRITE(2,4)
2     FORMAT(//,2X,'AT',3X,'OBSER',4X,'CALC',2X,'PRECIP',1X,
     12I4,5(1X,I4),2(1X,I3),'-',I3,2(1X,I3),/,31X,51A1)
3     FORMAT(I4,3F8.3,3X,51A1)
4     FORMAT(//,82('-'))
5     FORMAT(//,2X,20A4)
      RETURN
      END

C     *******************************************************
      SUBROUTINE OBJEC(Y,SF,KM)
      DIMENSION Y(7)
      COMMON/DID/PP(1000),EE(1000),QO(1000),Q(1000),QT1,M,IQ(7),X(7)
     1,SQ1,FATOR,ST,STT,SF1,R2,DE,IOP3,SS,IOP4,QF1
      IF(IOP3.LE.0)THEN
      N=0
      DO 90 J=1,7
      IF(IQ(J).GT.0)THEN
      N=N+1
      X(J)=Y(N)
      ENDIF
   90 CONTINUE
      ENDIF
      A =X(1)
      B =X(2)
      C =X(3)
      SMAX=A/(C-B)
      XK1=EXP(-1/X(4))
      XK2=EXP(-1/X(5))
      SX=QT1/C
      QT=QT1
      IF(SX.LE.SMAX)GO TO 97
      SX=SMAX
      QT=SMAX*C
  97  QS=QT1-QT
      RI=A+B*SX
      CR=X(6)
      ALF=X(7)
      QSO=0.
      SFF1=0.
      SFF2=0.
      SQ=0.
      S=SX
      DO 300 J=1,M
      P=PP(J)
      E=EE(J)  
      PE=0.0
      A1=1.
      E1=0.0
      ES=0.0
      EEX=EXP(-ALF*S/SMAX)
      IF(P.GE.RI)GO TO 200
      CA= (P/RI)**2/(P/RI +CR)
      E1=P*CA
      P=P*(1-CA)
      W=P-E*(1-EEX)+ALF*S*E/SMAX*EEX
      RR= C+ALF*E/SMAX*EEX
      EX=EXP(-RR*A1) 
      S1=W/RR*(1-EX)+S*EX
      IF(S1.LT.0)S1=0. 
      RI1= A +B*S1
      IF(P.GT.RI1)GO TO 100
      PE= C*(S+S1)/2
      GO TO 250
 100  SSX=  - A/B+1/B*P
      AX= -ALOG((SSX-W/RR)/(S-W/RR))/RR
      PE= C*(SSX+S)/2*AX
      S= SSX
      A1= 1 - AX
 200  W= A-E*(1-EEX)+ALF*E*S/SMAX*EEX   
      RR= C-B+ALF*E*EEX/SMAX
      EX=EXP(-RR*A1)
      S1= W/RR*(1-EX)+S*EX
      IF(S1.LT.0)S1=0.01*SMAX 
      RI1=A + B*S1
      ES= (P-(A+B*(S1+S)/2))*A1
      PE=PE+C*(S1+S)/2*A1
 250  RI=RI1
      ES=ES+E1
      S=S1
      QT=QT*XK2+PE*(1-XK2)
      QS=QS*XK1+ES*(1-XK1)
      QC= QT+ QS
      Q(J)=QC/FATOR
      SFF1=SFF1+((QO(J)-Q(J))/QO(J))**2
      SFF2=SFF2+(QO(J)-Q(J))**2 
      SQ=SQ+Q(J)
300   CONTINUE
      R2A= 1-(SFF1/ST)
      R22=1-(SFF2/STT)
      DE=(SFF2/M)**.5
      VV=ABS((SQ-SS)/SS*100)
      WRITE(2,2)(X(K),K=1,7)
      WRITE(2,3)SQ/M,SS/M,VV,R22,DE,R2A,SFF1,SFF2
      IF(IOP4.GT.0)THEN
      SF=SFF2
      QF1=R22
      ELSE
      SF=SFF1
      QF1=R2A
      ENDIF
      IF(SF.GE.SF1)GO TO 330
 2    FORMAT(5x,7F8.2) 
 3    FORMAT(5x,6F8.2,2F10.1)
      SF1=SF
      SQ1=SQ
 330  RETURN
      END

C     *****************************************************************
      SUBROUTINE ROSE1(AKE,EPS,KM,MAXK,MKAT,MCYC,ALPHA,BETA,NSTEP,EPSY)
      DIMENSION AKE(7),D(7),BLEN(7),EPS(7),AJ(7),E(7),AFK(7),V(7,7),
     1AL(7,7),BL(7,7)
      KAT=1
      DO 98 II=1,KM
      DO 98 JJ=1,KM
      V(II,JJ)=0.0
      IF(II-JJ)98,97,98
  97  V(II,JJ)=1.0
  98  CONTINUE
      CALL OBJEC(AKE,SUMN,KM)
      SUMO=SUMN
      DO 812 K=1,KM
      AFK(K)=AKE(K)
 812  CONTINUE
      KK1=1
      IF(NSTEP -1) 701,700,701
 700  GO TO 1000
 701  CONTINUE
      DO 350 I=1,KM
      E(I)=EPS(I)
  350 CONTINUE
 1000 DO 250 I=1,KM
      FBEST=SUMN
      AJ(I)=2.0
      IF(NSTEP-1)702,703,702
 702  GO TO 250
 703  CONTINUE
      E(I)=EPS(I)
 250  D(I)=0.
      III=0
 397  III=III+1
 258  I=1
 259  DO 251 J=1,KM
 251  AKE(J)=AKE(J)+E(I)*V(I,J)
       CALL OBJEC(AKE,SUMN,KM)
      KAT=KAT+1
      SUMDI =FBEST-SUMN
      IF(ABS(SUMDI )-EPSY)704,704,705
 704  GO TO 1001
 705  CONTINUE
      IF(KAT-MAXK)706,707,707
 707  GO TO 1001
 706  CONTINUE
      IF(SUMN-SUMO)708,708,709
 708  GO TO 253
 709  CONTINUE
      DO 254 J=1,KM
 254  AKE(J)=AKE(J)-E(I)*V(I,J)
      E(I)=-BETA*E(I)
      IF(AJ(I)-1.5)710,711,711
 710  AJ(I)=0.
 711  CONTINUE
      GO TO 255
 253  D(I)=D(I)+E(I)
      E(I)=ALPHA*E(I)
      SUMO=SUMN
      DO 813 K=1,KM
  813 AFK(K)=AKE(K)
      IF(AJ(I)-1.5)712,712,713
 713  AJ(I)=1.
 712  CONTINUE
 255  DO 256 J=1,KM
      IF(AJ(J)-0.5)256,256,715
  715 GO TO 299
 256  CONTINUE
      GO TO 257
 299  IF(I-KM)717,716,717
 716  GO TO 399
 717  CONTINUE
      I=I+1
      GO TO 259
  399 DO 398 J=1,KM
      IF(AJ(J)-2.)718,398,398
  718 GO TO 258
 398  CONTINUE
      IF(III-MCYC)720,721,721
 720  GO TO 397
 721  CONTINUE
      GO TO 1001
 257  CONTINUE
      DO 290 I=1,KM
      DO 290 J=1,KM
  290 AL(I,J)=0.
      WRITE(2,280)KK1
  280 FORMAT(//,2X,'NUMERO DO CICLO',I2)
      WRITE(2,281)SUMO
 281  FORMAT(/,7X,'VALOR DA FUNCAO OBJETIVO =' ,E16.8)
      WRITE(2,282)
 282  FORMAT(/,7X,'VALORES DA VARIAVEIS INDEPENDENTES',/)
      DO 284 IX =1,KM
      WRITE(2,283)IX,AKE(IX)
 283  FORMAT(/,7X,2HX(,I2,4H) = ,E16.8)
  284 CONTINUE
      DO 260 I=1,KM
      KL=I
      DO 260 J=1,KM
      DO 261 K=KL,KM
  261 AL(I,J)=D(K)*V(K,J)+AL(I,J)
 260  BL(I,J)=AL(I,J)
      BLEN(1)=0.
      DO 351 K=1,KM
      BLEN(1)=BLEN(1)+BL(1,K)*BL(1,K)
 351  CONTINUE
      BLEN(1)=SQRT (BLEN(1))
      DO 352 J=1,KM
      V(1,J)=BL(1,J)/BLEN(1)
 352  CONTINUE
      DO 263 I=2,KM
      II=I-1
      DO 263 J=1,KM
      SUMVV=0.
      DO 264 KK=1,II
      SUMAV=0.
      DO 262 K=1,KM
 262  SUMAV=SUMAV+AL(I,K)*V(KK,K)
 264  SUMVV =SUMAV*V(KK,J)+SUMVV
 263  BL(I,J)=AL(I,J)-SUMVV
      DO 266 I=2,KM
      BLEN(I)=0.
      DO 267 K=1,KM
  267 BLEN(I)=BLEN(I)+BL(I,K)*BL(I,K)
      BLEN(I)=SQRT(BLEN(I))
      DO 266 J=1,KM
  266 V(I,J)=BL(I,J)/BLEN(I)
      KK1=KK1+1
      IF(KK1- MKAT)723,722,722
 722  GO TO 1001
  723 GO TO 1000
 1001 WRITE(2,1002)KK1
 1002 FORMAT(///,2X,'numero total de estagios =',I2)
      WRITE(2,1003)KAT
 1003 FORMAT(/,2X,'numero total de avaliacoes da funcao', I5)
      WRITE(2,1005) SUMO
 1005 FORMAT(/,2X,'valor final da funcao objetiva = ' , E16.8)
      DO 1007 IX=1,KM
      WRITE(2,1006) IX,AFK(IX)
      AKE(IX)=AFK(IX)
 1006 FORMAT(/,2X,2HX(,I2,4H) = ,E16.8)
 1007 CONTINUE
      RETURN
      END

C      DADOS DE ENTRADA
C      ----------------
C
C  Registro  A
C   CABE      - Comentarios
C              Format(20A)
C
C  Registro  B
C   NT        - Numero de intervalos de tempo.
C   IOP3      - = 0 Com otimizacao automatica
C               > 0 Sem otimizacao automatica 
C   IOP4        - > 0 Funcao objetiva e o quadrados dos desvios
C                      relativos
C               = 0 funcao objetica quadrado dos desvios absolutos 
C              Format(8I10)
C
C  Registro C
C   P(J)      - Precipitacao no intervalo J em mm
C              Format(12F8.1)
C
C  Registro D
C   E(J)      - Evaporacao no intervalo de tempo J em mm
C              Format(12F8.1)
C  Registro E
C   QO(J)     - Vazao observada em m3/s. Caso nao existam valores
C               observados coloque as linhas corresondentes 
C              Format(12F8.1)
C
C  Registro F  IOP3=0
C   IQ(J)     - quando IQ(J)=0 o parametro J do modelo nao sera
C                otimizado
C                  J   PARAMETRO
C                  1   A
C                  2   B
C                  3   C
C                  4   KS
C                  5   KSUB
C                  6   CR
C                  7   ALF
C                 Format(8I10)
C  Registro G
C     A       - Parametro A
C     B       - Parametro B
C     C       - Parametro C
C     KS      - Parametro Ks
C     KSUB    - Parametro Ksub
C     CR      - Fator para escoamento superficial
C     ALF     - Coeficiente da equacao de infiltracao
C              OS VALORES DOS PARAMETROS SERAO OS INICIAIS CASO A
C              OPCAO SEJA DE OTIMIZACAO
C              Format(12F8.1)
C
C  Registro H   IOP3=0
C    EPS(J)    -Espacamento do parametro J a ser otimizado
C               Format (12F8.1)
C
C  Registro I   IOP3=0
C    MAXK      - Numero maximo de tentativas
C    MKAT      - Numero maximo de ciclos
C    MCYC      - Numero maximo de falhas e acertos
C    ALPHA     - Ccoeficiente de aceleracao
C    BETA      - Coeficiente de reducao
C    NSTEP     - Quando =1 EPS(J) e igual ao valor dado no inicio do
C               ciclo; =2 ultimo valor do ciclo
C    EPSY      - Precisao utilizada na otimizacao em percentagem do
C                 somatorio das vazoes observadas.
C                 Format(3I10,2F10.2,I10,F10.2)
C  Registro J
C     QT1      - Vazao de base inicial em m3/s
C     AREA     - Area da bacia em km2
C    
C----------------------------------------------------------------------
