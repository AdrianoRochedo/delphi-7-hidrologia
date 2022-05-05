      SUBROUTINE OBJEC(Y,NF,VFO,Qcontinua,SFNS,SQ,NSF,tipofo)
c	Esta sub-rotina contem as funções objetivo e é a sub-rotina que
c	chama o modelo IPH2 para todos os intervalos de tempo.
	
      DIMENSION PV(70)
	REAL SF !FUNÇÃO OBJETIVO (VÁRIAS OPÇÕES)
	REAL SFNS !SOMA DOS DESVIOS QUADRADOS (PARA CALCULAR R Nash Sutcliffe)
	integer nsf
	integer nf
	real vfo(nf)
	dimension y(7)
      COMMON /PARAM/X(7),AI,BI,AIL,BIL,AT,BT,ATL,BTL,SMAX
      COMMON P(19999),E(19999),QO(19999),T1,QT1,QS1,MT,
     1SQ1,FATOR,SS,ST,HIST(70),NH,DIST(12),ND,AINP,SF1,QF1
	REAL Qcontinua(19999)
      integer tipofo(10) 

      X=Y
      RR=0.
      N=0
      AUX=X(3)
      BI=X(1)/ALOG(AUX)/(X(1)-X(2))
      AI=-X(1)*BI
      AT=0.
      BT=-X(1)/X(2)/ALOG(AUX)
      AIL=-AI/BI
      BIL=1/BI
      ATL=0.
      BTL=1/BT
      SMAX=-X(1)/ALOG(AUX)
      X(4)=EXP(-1/X(4))
      X(5)=EXP(-1/X(5))
      SF=0.
	SFNS=0.0
      SQ=0.
      DO 80 KT=1,NH
  80  PV(KT)=0.
      SX=AT+BT*T1
      RI=AIL+BIL*SX
      QTT=QT1
      QST=QS1
      ALF=X(7)

	SF=0.0
	SF2=0.0
	SFNS=0.0
	SQ=0.0
	SOBS=0.0

	!loop do tempo
      DO 110 J=1,MT	!MT e o numero total de intervalos de tempo
      QSO=0.
      PAUX=P(J)
      EAUX=E(J)
      CALL MODEL(PAUX,EAUX,RI,SX,QTT,QST,QMM,X(2),X(3),X(4),X(5),X(6),
     1ALF,AI,BI,AIL,BIL,AT,BT,ATL,BTL,SMAX,PV,HIST,NH,AINP,RR) !esta igual ao do iphprev

      Qcontinua(J)=QMM*FATOR

	IF(QO(J).GT.0.0)THEN !VERIFICA FALHA
!     _______________________________________________________________________________________
!     escolhe qual fo vai utilizar
!	if(tipofo
	
         do numfo=1,nf
             if(tipofo(numfo)==1)sfns=sfns+(qo(j)-qcontinua(j))**2        !desvio quadrado (padrao)
             if(tipofo(numfo)==2)sf2=sf2+abs(qo(j)-qcontinua(j))          !desvio absoluto 
             if(tipofo(numfo)==3)sf2=sf2+(1./qo(j)-1./qcontinua(j))**2    !desvio inverso
             if(tipofo(numfo)==4)sf2=sf2+((qo(j)-qcontinua(j))/qo(j))**2  !desvio quadrado relativo
             if(tipofo(numfo)==5)sf2=sf2+(abs(qo(j)-qcontinua(j)))/qo(j)  !desvio relativo
             if(tipofo(numfo)==6)then
          		SQ=SQ+Qcontinua(J)   !para avaliar erros no volume
		        SOBS=SOBS+QO(J)      !para avaliar erros no volume
              endif
      	enddo
	
      ENDIF
  110 CONTINUE

	IF(NSF.GT.0)THEN
	VFO(1)=(SFNS/NSF)**0.5                !para primeira Fo (ROOT MEAN SQUARE ERROR - UNIDADES DE M3/S)
	VFO(2)=(SF2/NSF)**0.5                 !para a segunda FO (UNIDADES DE 1/M3/S (AVALIA VAZÕES BAIXAS)
	ENDIF

      if(nsf.gt.0.and.nf==3)then
      VFO(3)=(100.*ABS(SQ-SOBS))/SOBS       !para a terceira FO (ERRO NO VOLUME - UNIDADE %)
	endif 

      SF=SFNS
      AUX=X(4)
      X(4)=-1./ALOG(AUX)
      AUX=X(5)
      X(5)=-1/ALOG(AUX)

	RETURN
      END
