	SUBROUTINE IPHII
	use var

	READ(1,'(8F10.2)') AIO,AIB,HK,RMAX,RT1,AINP,area
	RT11=RT1*AT/0.1E+04
	TOTP=0.0
	TOTL=0.0
	TOTE=0.0
	BI=AIO/ALOG(HK)/(AIO-AIB)
	AI=-AIO*BI
	ATT=0.
	BT=-AIO/AIB/ALOG(HK)
	AIL=-AI/BI
	BIL=1./BI
	ATL=0.
	BTL=1/BT
	SMAX=-AIO/ALOG(HK)
	SX=RT11*(BT)
	SO=SX
	RI=AIL+BIL*SX
	T=RT11
	R=0.
	DO 1 I=1,NTT
	RD=RMAX-R
        PR=PRE(I)
	IF(PR.GT.RD) GO TO 2
	R=R+PR
	PR=0.
	GO TO 6
2	PR=PR-RD
	R=RMAX
6	AT1=1.
	PAUX=PR
	IF(PR.GE.RI) GO TO 4
	S1=(SX*(2.-1/BT)+2*PR)/(2+1/BT)
	RI1=AIL+BIL*S1
	IF(PR.GE.RI1) GO TO 5
	T=ATL+BTL*S1
	VE=0.
	VI=PR
	GO TO 8
5	SXX=AI+BI*PR
	ATX=2.*BT*(SXX-SX)/(2.*PR*BT+2.*ATT-SXX-SX)
	AT1=AT1-ATX
	RAUX=PR
	VAUX=PR*ATX
	GO TO 7
4	RAUX=RI
	VAUX=0.0
7	RI1=AIB+(RAUX-AIB)*HK**AT1
	S1=AI+BI*RI1
	T=ATL+BTL*S1
	VI=AIB*AT1+(RAUX-AIB)*(HK**AT1-1)/ALOG(HK)+VAUX   !volume infiltrado
 	VE=PR*AT1-VI+VAUX								  !volume excedente
8	VOP(I)=(SX-S1+VI)*(1-ainp)
	VES=PAUX*AINP+VE*(1-AINP)						  !volume escoado
	PER(I)=PRE(I)-VES								  !perdas
	EXE(I)=VES										  !excessos
	TOTL=TOTL+PRE(I)								  !total de chuva
	TOTP=TOTP+PER(I)								  !total de perdas
	TOTE=TOTE+EXE(I)								  !total de excessos
	SX=S1
	RI=RI1
1	CONTINUE

      PEF=EXE    !PARA IGUALAR AS MATRIZES

	write(2,*)
	WRITE(2,150) AIO,AIB,HK,SO,RMAX
	IF(IPP.EQ.0) GO TO 33
      WRITE(2,280)
 	WRITE(2,260)(I,PRE(I),PA(I),PER(I),EXE(I),I=1,NTT)
33	WRITE(2,110) TOTL,TOTP,TOTE
!_______________________________________________________________________
120   format(i3,2f10.2,f10.3,f10.2)
110	FORMAT(2(/),10X,'TOTAL PRECIPITADO',F10.2,' MM',/,10X,'TOTAL',
     1' DE PERDAS',F12.2,' MM'/,10X,'TOTAL DE EXCESOS ',F10.2,' MM'//)
150	FORMAT(2(/),10X,'METODO IPHII',2(/),/,10X,
     1'AIO =',F10.3,' MM/H' /,10X,'AIB =',F10.3,' MM/H'/,10X,
     1'HK  =',F10.3,/,
     110X,'ST  =',F10.2,' MM'/,10X,'RMAX=',F10.1,' MM',3(/))
260	FORMAT(10X,I3,F11.2,F10.2,F9.2,F10.2)
280   FORMAT(/,10X,'INT',5X,'PRECIP',5X,'PACUM',5X,'PERD ',5X,'PEFCT'/
     119X,'(MM)',7X,'(MM)',5X,'(MM)',7X,'(MM)'/)

	RETURN
	END
