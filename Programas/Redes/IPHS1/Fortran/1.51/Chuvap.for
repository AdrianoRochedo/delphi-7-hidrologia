C*******************************
        SUBROUTINE CHUVAP
        DIMENSION PORD(300)
        COMMON /DATA/Q(300,200),IPL(200),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1PRE(300),AT,QO(300),IOBS,IPR,ILIST,PA(300),PEF(300),NTT,PER(300),
     2PMAX,VOP(300),P(300,10)
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
