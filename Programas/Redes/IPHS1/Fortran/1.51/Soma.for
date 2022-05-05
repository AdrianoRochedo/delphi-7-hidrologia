C************************
        SUBROUTINE SOMA
        DIMENSION ISM(15)
        COMMON /DATA/Q(300,200),IPL(200),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1PRE(300),AT,QO(300),IOBS,IPR,ILIST,PA(300),PEF(300),NTT,PER(300),
     2PMAX,VOP(300),P(300,10)
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
