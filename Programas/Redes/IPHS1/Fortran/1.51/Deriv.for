C****************************************
        SUBROUTINE DERIV
        COMMON /DATA/Q(300,200),IPL(200),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1PRE(300),AT,QO(300),IOBS,IPR,ILIST,PA(300),PEF(300),NTT,PER(300),
     2PMAX,VOP(300),P(300,10)
	READ(1,3)  B1,RUGO1,DEC1, B2,RUGO2,DEC2
	WRITE(2,8)  B1,DEC1,RUGO1, B2,DEC2,RUGO2
	FAC=1+B2/B1*(DEC2/DEC1)**0.5*RUGO1/RUGO2
	Q(1,IS)=Q(1,IE)/FAC
	Q(1,IE)=Q(1,IE)-Q(1,IS)
	ALFA=RUGO2**0.6/(DEC2**0.3*B2**0.6)
	H=ALFA*Q(1,IE)**0.6
	DO 35 J=2,NT
	RP=(2*H+B1)/(2*H+B2)
	FAC=1+RP**0.667*(B2/B1)**1.667*(DEC2/DEC1)**0.5*(RUGO1/RUGO2)
	Q(J,IS)=Q(J,IE)/FAC
	Q(J,IE)=Q(J,IE)-Q(J,IS)
	ALFA=RUGO2**0.6*(2*H+B2)**0.4/(DEC2**0.3*B2)
	H=ALFA*Q(J,IE)**0.6
35	CONTINUE
        IF(IPR.GT.0)CALL PLOTA(0)
        IF(ILIST.GT.0)CALL HID
        RETURN
3       FORMAT(8F10.0)
8       FORMAT(/10X,'DERIVACAO'//10X,'CANAL DERIV:', '  B=',F7.2,
     1 ' M    DEC=',F7.5,'   RUG=',F7.3
     1                         /10X,'CANAL PRINC:', '  B=',F7.2,
     1 ' M    DEC=',F7.5,'   RUG=',F7.3)
       END
C**********************************
