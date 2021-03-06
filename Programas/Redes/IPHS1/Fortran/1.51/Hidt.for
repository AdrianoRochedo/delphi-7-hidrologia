C*******************************
        SUBROUTINE HIDT
        DIMENSION QU(300),QT(300)
        COMMON /DATA/Q(300,200),IPL(200),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1PRE(300),AT,QO(300),IOBS,IPR,ILIST,PA(300),PEF(300),NTT,PER(300),
     2PMAX,VOP(300),P(300,10)
        DO 1001 I=1,NT
1001    QT(I)=0.
	READ(1,2)AR,TC
        IF(TC.NE.0.)GO TO 101
        READ(1,2)SSS
        SSS=10.*SSS
        TC=3.83*AR**0.41/SSS**0.17
101  	TP=AT/7200.+.6*TC
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
215	QU(ITG)=QP*(TB/TR-J)/(TB/TR-TP/TR)
220	CONTINUE
        DO 200 J=1,NTT
        PE1=PEF(J)
        DO 300 K=J,NH+J-1
300     QT(K)=QT(K)+PE1*QU(K-J+1)
200     CONTINUE
        DO 400 J=1,NT
400     Q(J,IS)=QT(J)
        RETURN
2	FORMAT(8F10.2)
5	FORMAT(/10X,'HIDROGRAMA DE PROJETO PELO METODO SCS',
     1//10X,'AREA DA BACIA:        ',F10.2,1X,'KM2',/10X,
     1'TEMPO DE CONCENTRACAO:',F10.2,1X,'HORAS',
     1/10X,'QP UNITARIO (1MM,AT):',F11.2,1X,'M3/S'/
     110X,'TP UNITARIO:          ',F10.2,1X,'HORAS'/
     110X,'TB UNITARIO:          ',F10.2,1X,'HORAS')
	END
C****************************************
