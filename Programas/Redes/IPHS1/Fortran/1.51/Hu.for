C *************************
        SUBROUTINE HU
        DIMENSION HUO(50),QT(100)
        COMMON /DATA/Q(300,200),IPL(200),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1PRE(300),AT,QO(300),IOBS,IPR,ILIST,PA(300),PEF(300),NTT,PER(300),
     2PMAX,VOP(300),P(300,10)
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
