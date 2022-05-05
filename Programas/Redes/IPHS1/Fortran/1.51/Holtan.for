C*******************************
      SUBROUTINE HOLTAN
        COMMON /DATA/Q(300,200),IPL(200),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1PRE(300),AT,QO(300),IOBS,IPR,ILIST,PA(300),EXE(300),NTT,PER(300),
     2PMAX,VOP(300),P(300,10)
      READ(1,120)SAI,BE,FC1,GIA1
120	FORMAT(4F10.2)
	AT1=AT/3600.
	FC=FC1*AT1
	GIA=GIA1*AT1
	TOTP=0.0
	TOTL=0.0
	TOTE=0.0
	SA1=SAI
	DO 1 I=1,NTT
        PPP=PRE(I)
	AD=PPP
	F1=GIA*SA1**BE+FC
	PVI=F1
	IF(PVI.GE.AD) GO TO 2
	AD=PVI
2	SA2=SA1-AD+FC
	IF(SA2.LE.0.0) GO TO 6
	F2=GIA*SA2**BE+FC
	PVI=.5*(F1+F2)
	IF(AD.LE.PVI) GO TO 3
	AD=AD-0.1
	IF(AD.GE.0.0) GO TO 2
	AD=0.0
	GO TO 2
3	PER(I)=AD
	GO TO 7
6	PER(I)=SA1+FC
	SA2=0.0
7	SA1=SA2
	EXE(I)=PPP-PER(I)
	TOTL=TOTL+PPP
	TOTE=TOTE+EXE(I)
	TOTP=TOTP+PER(I)
1	CONTINUE
 	WRITE(2,140) SAI,BE,FC1,GIA1
140	FORMAT(2(/),10X,'METODO DE HOLTAN',2(/),10X,'SAI =',F 5.1,
     1	' MM',3X,'BE =',F 5.1,3X,'FC =',F 5.1,' MM/HS',3X,
     2	'GIA =',F5.1,' MM/HS',2(/))
	IF(IPP.EQ.0) GO TO 33
        WRITE(2,280)
280     FORMAT(/,10X,'INT',5X,'PRECIP',5X,'PACUM',5X,'PERD ',5X,'PEFCT'/
     119X,'(MM)',7X,'(MM)',5X,'(MM)',7X,'(MM)'/)
 	WRITE(2,260)(I,PRE(I),PA(I),PER(I),EXE(I),I=1,NTT)
260	FORMAT(10X,I3,F11.2,F10.2,F9.2,F10.2)
33	WRITE(2,110) TOTL,TOTP,TOTE
110	FORMAT(2(/),10X,'TOTAL PRECIPITADO',F10.2,' MM',/,10X,'TOTAL',
     1' DE PERDAS',F12.2,' MM'/,10X,'TOTAL DE EXCESOS ',F10.2,' MM'//)
130	FORMAT(5F10.0)
	RETURN
	END
C*********************************
