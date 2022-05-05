	SUBROUTINE FI
	use var 
	
	READ(1,'(2F10.2)') PI,PU1
      WRITE(2,120)PI,PU1
	TOTP=0.0
	TOTL=0.0
	TOTE=0.0
      PU=PU1*AT/3600.
	PREI=PI

	DO 1 I=1,NTT
      PPP=PRE(I)
	PER(I)=0.0
	IF(PREI.LE.0.0) GO TO 2
	IF(PREI.GE.PPP) GO TO 3
	PER(I)=PREI
	PR=PPP-PREI
	PREI=0.0
	PX=PR*PU/PPP
	IF(PX.GE.PR) GO TO 4
	PER(I)=PER(I)+PX
	EXE(I)=PPP-PER(I)
	GO TO 5
4	EXE(I)=0.0
	PER(I)=PER(I)+PR
	GO TO 5
3	PER(I)=PPP
	PREI=PREI-PPP
	EXE(I)=0.0
	GO TO 5
2	IF(PPP.GE.PU) GO TO 6
	PER(I)=PPP
	EXE(I)=0.0
	GO TO 5
6	PER(I)=PU
	EXE(I)=PPP-PU
5	TOTP=TOTP+PER(I)
	TOTL=TOTL+PPP
1	TOTE=TOTE+EXE(I)

	PEF=EXE  !COLOQUEI PARA IGUALAR AS MATRIZES

	IF(IPP.EQ.0) GO TO 33
 	WRITE(2,'(10X,I3,F11.2,F10.2,F9.2,F10.2)')
	1(I,PRE(I),PA(I),PER(I),EXE(I),I=1,NTT)
33	WRITE(2,110) TOTL,TOTP,TOTE
!_____________________________________________________________________
120	FORMAT(2(/),10X,'METODO DA PERDA INICIAL E INDICE FI',
     12(/),10X,'PERDA INICIAL =',F 5.1,' MM',3X,
     1	'INDICE FI =',F 5.1,' MM/H',2(/))
280     FORMAT(/,10X,'INT',5X,'PRECIP',5X,'PACUM',5X,'PERD ',5X,'PEFCT'/
     119X,'(MM)',7X,'(MM)',5X,'(MM)',7X,'(MM)'/)
110	FORMAT(2(/),10X,'TOTAL PRECIPITADO',F10.2,' MM',/,10X,'TOTAL',
     1' DE PERDAS',F12.2,' MM'/,10X,'TOTAL DE EXCESOS ',F10.2,' MM'//)

	RETURN
	END
!*****************************************************************************