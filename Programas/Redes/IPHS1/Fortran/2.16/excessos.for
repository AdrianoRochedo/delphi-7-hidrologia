      SUBROUTINE excessos()
	use var
	use varexcesso

 !     RUTINA AMC MODIFICADA PARA PROPAGAR EXCESSOS
      NTRECH=1 !DEFINO SOMENTE UM TRECHO
      rug=rugrua
      if (j==1)then
	QREF=(QMaXin-Qfull)*2./3. !AQUI QREF É SUBSTITUÍDA
      Qmaxc=Qmaxin-Qfull
	COEF=1.67*SO**0.3/RUG**0.6
      B=((rugrua**0.6*1.5*Qref**0.6)/(SO**1.3*DX))**1.67  !isolando de Co(pag 468 hif- e DX pag 470)
      CEL=COEF*(QREF/B)**0.4
	b2=(2.5*qREF)/(SO*cEL*DX)
	QESP=QREF/B  
!      parametros lineares
2019	AK=DX/CEL
	XXX=0.5 - (0.5*QESP/SO)/CEL/DX
	DEN=2*AK*(1- XXX)+DTCAL
	C1=(2*AK*XXX+DTCAL)/DEN
	C2=(DTCAL-2*AK*XXX)/DEN
	C3=(2*AK*(1-XXX)-DTCAL)/DEN
      endif
	
	if (N.eq.1)then
      QExc(J+1,N+1)=QExc(J,N) !no primeiro intervalo propaga direto
      else
      QExc(J+1,N+1)=C1*QExc(J,N)+C2*QExc(J,N+1)+C3*QExc(J+1,N)
      endif

      RETURN
      END
C**************************
