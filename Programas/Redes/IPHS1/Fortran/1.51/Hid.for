C************************
        SUBROUTINE HID
        COMMON /DATA/Q(300,200),IPL(200),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1PRE(300),AT,QO(300),IOBS,IPR,ILIST,PA(300),PEF(300),NTT,PER(300),
     2PMAX,VOP(300),P(300,10)
        WRITE(2,5)IS
        SUM=0
        DO 100 K=1,NT
100     SUM=SUM+Q(K,IS)
        VOL= SUM*AT/1.E6
        WRITE(2,10)(K,Q(K,IS),K+NT/2,Q(K+NT/2,IS),K=1,NT/2)
5       FORMAT(//10X,'HIDROGRAMA RESULTANTE DA OPERACAO:',I3/
     1/10X,'INT',5X,'   VAZAO',8X,'INT',5X,'   VAZAO'/
     2	9X,'TEMPO',7X,'(M3/S)',6X,'TEMPO',7X,'(M3/S)'/)
10      FORMAT(10X,I3,5X,F8.2,8X,I3,6X,F8.2)
        WRITE(2,20)VOL
20      FORMAT(//,10X,'VOL ESCOADO=',F8.2,' HM3')
        RETURN
        END
C************************
