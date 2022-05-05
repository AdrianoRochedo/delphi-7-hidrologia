      SUBROUTINE AMClinear(NCODP,QREF)
	use var

	REAL, allocatable:: QM(:),QC(:,:),QCOR(:),QL(:)
	
      real B,H,ALONG,COTMON,COTJUS,DTCAL,dx
	integer trecho
      integer ILAT
      
	READ(1,'(6F10.2,i10,F10.3,I10)')
	1B,H,ALONG,COTMON,COTJUS,DTCAL,TRECHO,RUG,ILAT
	
      ntrech=trecho
	SO=(COTMON-COTJUS)/ALONG !calcula a declividade
      COEF=1.67*SO**0.3/RUG**0.6

      Qreferencia: if(Qref==0.)then
			QMMX=0.0
			DO IWC=1,NT
				IF(Q(IWC,IE).GT.QMMX)THEN
				QMMX=Q(IWC,IE)
				ENDIF
			ENDDO
			QREF=QMMX*2./3. !a Qref e substituida
      endif Qreferencia

	CEL=COEF* (QREF/B)**0.4
	QESP=QREF/B

	IF(DTCAL==0.)DTCAL=AT  !se dtcal nao e definido, adota dtcal=at (simulacao)

     	automatico: if (ntrech.eq.0)then
		H1=0.1*(((QESP*RUG)/SO**0.5)**0.6) !PROFUNDIDADE EM METROS (1 ESTIMATIVA)
		H2=10.*(((QESP*RUG)/SO**0.5)**0.6) !PROFUNDIDADE EM METROS (2 ESTIMATIVA)
		XACC=0.001*QREF
		CALL NEWT2(H,H1,H2,XACC,QREF,B,SO,RUG,CEL)  !calc a prof e estima a cel (dQ/dA = dQ/dH*(1/B) )
		VEL=((((B*H)/(B+2.*H))**0.667)*SO**0.5)/RUG
!		Aqui é calculado o melhor numero de trechos NTRECH - valido somente para metodo linear
		DTCAL=AT    !por seguranca 
		IWCT=1
		DX1=0.5     !valor arbitrado bem pequeno 
		DX2=ALONG*100000.
		XACC=0.5    !erro admitido na raiz
1919		CALL NEWTRAP(RTSAFE,DX1,DX2,xacc,QREF,B,SO,CEL,DTCAL)
		DX=RTSAFE
!		TESTA ESTE DX 
			IF((ABS(DX-ALONG))/ALONG.LT.0.1.OR.DX/ALONG.LT.0.6)THEN
				XTRECH=ALONG/DX
				NTRECH=NINT(XTRECH)
			ELSE
				IWCT=IWCT+1
					IF(IWCT.GT.10)THEN 	!DESISTE DE DIMINUIR DTCAL E USA DX=ALONG
					WRITE(*,*) 'DX=ALONG,  DTCAL=',DTCAL
					write(9,*)' ',ca
					WRITE(9,*)'VALOR DE CALCULO','DX=ALONG,  DTCAL=',DTCAL
					NTRECH=1
					GOTO 2019
					ENDIF
				DTCAL=AT/IWCT !VAI DIMINUINDO DTCAL,MAS MANTEM MULTIPLO DE AT
				GOTO 1919
			ENDIF
		NCALC=AT/DTCAL*(NT-1)+1  !trechos de calculo, usa o DT calculado
	endif automatico

      DX=ALONG/NTRECH
2019	AK=DX/CEL
	XXX=0.5 - (0.5*QESP/SO)/CEL/DX
	DEN=2*AK*(1- XXX)+DTCAL
	C1=(2*AK*XXX+DTCAL)/DEN
	C2=(DTCAL-2*AK*XXX)/DEN
	C3=(2*AK*(1-XXX)-DTCAL)/DEN

	NCALC=AT/DTCAL*(NT-1)+1  !trechos de calculo, usa o DT calculado
	allocate (qm(ncalc),qc(nt,ncalc))

      DO 202 K=1,NT    
202   QM(K)=Q(K,IE)
	
      DO 24 I=1,NTRECH+1
	    DO 24 J=1,ncalc
24    QC(I,J)=0.

	DX=ALONG/NTRECH
	IF(DTCAL.EQ.AT)GO TO 80
	NCALC=AT/DTCAL*(NT-1)+1
	N=AT/DTCAL

      if(.not.allocated (QL))allocate (QL(ncalc))
      if(.not.allocated (Qcor))allocate (Qcor(ncalc))
	
      DO 90 I=1,NT-1
          DO 110 J=N*(I-1)+1,N*(I-1)+N
          QL(J)=0
          IF(ILAT.NE.0)QL(J)=(Q(I,ILAT)+(Q(I+1,ILAT)-Q(I,ILAT))
     1    *(J-(N*(I-1)+1))/(1.*N))/ALONG
110	    QCOR(J)=Q(I,IE)+(Q(I+1,IE)-Q(I,IE))*(J-(N*(I-1)+1))/(1.*N)
 90	CONTINUE
	
      QCOR(NCALC)=Q(NT,IE)
	GO TO 120
 80	NCALC=NT
	N=1

      if(.not.allocated (QL))allocate (QL(ncalc))
      if(.not.allocated (Qcor))allocate (Qcor(ncalc))

	DO 130 I=1,NT
      QL(I)=0
      IF(ILAT.NE.0)QL(I)=Q(I,ILAT)/ALONG
130	QCOR(I)=QM(I)

C	CONDICAO INICIAL
120	DO 20 J=1,NTRECH+1
20 	QC(J,1)=QCOR(1)
C
C	CONDICAO DE CONTORNO
	DO 30 N=2,NCALC
30	QC(1,N)=QCOR(N)

	DO 40 J=1,NTRECH    !do trechos
      	DO 50 N=1,NCALC-1   !do tempo
          C4= 2*QL(N)*DTCAL*DX
          C4=C4/DEN
          QC(J+1,N+1)=C1*QC(J,N)+C2*QC(J,N+1)+C3*QC(J+1,N)+C4  
          GO TO 50
55        QC(J+1,N+1)=0.
50	    CONTINUE
40	CONTINUE

      N=AT/DTCAL

      DO 1040 I=1,NT
1040  Q(I,IS)=QC(NTRECH+1,1+(I-1)*N)

	WRITE(2,209)DX,RUG,B,SO,DTCAL,NTRECH
      write(8,778)is  !escreve as cotas
      QMAX=MAXVAL(Q(:,is))
      
	do I=1,nt
	cot=Q(I,is)/QMAX
      write(8,'(f10.3)')cot
      enddo !do impresao cota

	DEALLOCATE (QM,QC,QCOR,QL)
!     ______________________________________________________________________________________-
209   FORMAT(//10X,'PARAMETROS',
     1//10X,'AX',6X,'N',
     14X,'LARGURA',4X,'DECLIVIDADE',4X,'INT. TEMPO',4X,' NTRECH ',
     1/ 9X,' M ',13X,' M ',9X,' M/M ',9X,' SEG',/
     1(F12.1,F7.3,F11.1,F15.5,F14.0,I11))
11	FORMAT(4F10.0,I10,F10.0,I10)
778	FORMAT('ophid',I5)
        RETURN
        END
