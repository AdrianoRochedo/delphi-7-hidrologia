C****************************
        SUBROUTINE PROPR
        COMMON /DATA/Q(300,200),IPL(200),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1PRE(300),AT,QO(300),IOBS,IPR,ILIST,PA(300),PEF(300),NTT,PER(300),
     2PMAX,VOP(300),P(300,10)
	integer np
        READ (1,2)NCODP,NP
        GO TO (100,200,300,400,500),NCODP
100     CALL AMUSK(NP)
        GO TO 1000
200     READ(1,3)QREF
        CALL AMC(NCODP,QREF)
        GO TO 1000
300     CALL AMC(NCODP,QREF)
        GO TO 1000
400     CALL AMCP
        GO TO 1000
500     CALL AMCPFECH(NCODP,NP)
1000    IF (IPR.GT.0)CALL PLOTA(0)
        IF (ILIST.GT.0)CALL HID
        RETURN
2       FORMAT(8I10)
3       FORMAT(F10.0)
	END
C**************************