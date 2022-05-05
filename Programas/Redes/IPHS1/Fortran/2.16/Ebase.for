	SUBROUTINE EBASE
	use var

	READ(1,'(8F10.0)') AREA,XKSUB,QSUB0
	WRITE(2,5) QSUB0,XKSUB

	XK2=XKSUB*3600./AT
	XK2=EXP(-1/XK2)
	FATOR=AREA*1000/AT
	QSUB1=QSUB0/FATOR

	DO 10 J=1,NT
	QSUB1=QSUB1*XK2+VOP(J)*(1.-XK2)
	Q(J,IS)=Q(J,IS)+QSUB1*FATOR
10	CONTINUE
!___________________________________________________________________
5	FORMAT(//,10X,'V BASE INIC:',F20.2,' M3/SEG'/
     1	10X,'KSUB             :',F14.2,' HORAS')

	RETURN
	END
C*******************************
