      SUBROUTINE PULS
	use var

	PARAMETER (G=9.81)
      DIMENSION QD(50,30),S(50,20),FNP(30,20),NP(30),ITT(30),COTAS(50)
      real SXZ(50),ZOP(50,30)
	REAL,ALLOCATABLE:: QM(:),QDUT(:)
	ALLOCATE (QM(NT+1),QDUT(NT+1))

!      Unidades: Cotas em M, VAZÃO EM M3/S E VOLUMES EM 1000 m3
      READ(1,'(I10,2F10.0,I10)')NO,SI,zmax,npzs
	SI=SI*1000.0/AT	!SI É O VOLUME INICIAL NO RESERVATORIO
	SI1=SI
      no1=no

      if(no.eq.0)no1=1

      do 110 i=1,npzs            !le a curva cota-volume
      read(1,'(2F10.2)')cotas(I),SXZ(I)
      SXZ(I)=SXZ(I)*1000./AT !TRANSFORMA EM M3/DELTAT (UNIDADE DO PULS)
110   continue
c
      IF(NO.EQ.0)go to 101 
C	___________________________________________________________________    
c	DADOS DE ENTRADA: curvas altura-vazão para cada operação
      DO 10 I=1,NO  !VAZÃO EM M3/S 
		READ(1,'(8I10)')NP(I),ITT(I)
		DO K=1,NP(I)
			READ(1,'(2F10.2)')zop(k,i),QD(K,I)
			S(K,I)=fint(cotas(1),sXz(1),npzs,zop(k,i)) 
	        if(s(k,I)<0)S(K,I)=0.
		ENDDO
10	CONTINUE
	go to 169
C	___________________________________________________________________

101	continue

c############ operação definida pelas estruturas de descarga ######################
c
      np(1)=npzs
      read(1,'(2I10,F10.2)')ivert,iorif,QLIM  !indicam vertedor, orificio e vazao MAXIMA do bypass
c  o coeficiente não deveria incluir 2g

      if(ivert.eq.0.and.iorif.eq.0)THEN
      WRITE(*,*)'ERRO no foi definida politica de operação nem',
     1' estruturas de descarga '
	write(9,*)'OPERAÇAO ',ca
	WRITE(9,*)'ERRO no foi definida politica de operação nem',
     1' estruturas de descarga '
	ENDIF
c
	if(ivert.eq.0)Cvert=0.0
	if(ivert.eq.0)go to 166
	READ(1,'(8F10.2)')Cvert,XL,Zvert !LÊ PARÂMETROS DO VERTEDOR
	
      IF(Cvert.GT.3.0.OR.Cvert.LT.1.5)THEN !TESTA DADO DE ENTRADA
      WRITE(*,*)'ERRO NO COEFICIENTE DE DESCARGA DO VERTEDOR '
	write(9,*)'OPERAÇAO ',ca
	WRITE(9,*)'ERRO NO COEFICIENTE DE DESCARGA DO VERTEDOR '
	ENDIF

c	Lê coeficiente, área, cota do orifício
166	if(iorif.ne.0)READ(1,'(8F10.2)')CORIF,AORIF,ZORIF
	if(iorif.eq.0)corif=0.0
167   continue
	
      DO 168 K=1,NP(1)
	DH=MAX(0.0,COTAS(K)-Zvert)
	HORIF=MAX(0.0,COTAS(K)-ZORIF)
	QD(K,1)=Cvert*XL*DH**1.5 !VAZAO DO VERTEDOR
	QD(K,1)=QD(K,1)+CORIF*AORIF*(2.*G*HORIF)**0.5 !VAZAO DO ORIFICIO
	QD(K,1)=MAX(0.001*K,QD(K,1)) !PARA NAO SER ZERO
168	CONTINUE
      
      S(:,1)=Sxz
c
169   continue
      if(no.lt.2)ITT(1)=NT+1

	DO 185 I=1,NO1
		DO 170 K=1,NP(I)
170		FNP(K,I)=S(K,I)+QD(K,I)/2.
185	CONTINUE 	

	DO 175 J=1,NT
175	QM(J)=Q(J,IE)	!VAZAO DE ENTRADA ORIGINAL

!WC	AS PROXIMAS LINHAS SUBSTITUEM A VAZAO DE ENTRADA ORIGINAL
!WC	PELA VAZAO DE ENTRADA MENOS A VAZAO DO BYPASS
	DO J=1,NT
		QDUT(J)=MIN(QM(J),QLIM) !QDUT É A VAZAO DO BYPASS
		QM(J)=QM(J)-QDUT(J)	!QM É A NOVA VAZAO DE ENTRADA
	ENDDO
!WC	FIM DA MODIFICACAO DA ENTRADA

	IO=1
	NPP=NP(IO)
	Q(1,IS)=FINT(S(1,IO),QD(1,IO),NPP,SI)
	IF(Q(1,IS).LT.0.) Q(1,IS)=0.      
	QI1=QM(1)
	QE=Q(1,IS)
	COTM=0.0
	QMVERT=0.0
C
      WRITE(7,776)IS,NO,ivert,iorif !INDICA NO ARQUIVO QUE OPERACAO HIDROLOGICA E SE TEM VERTEDOR E ORIFICIO
	COTJ=FINT(SXZ(1),COTAS(1),NPP,SI)	!COTA DO RESERVATORIO
	aa=q(1,IS)+qDUT(1)
      WRITE(7,'(i10,10F10.2)')1,COTJ,Q(1,IS),QDUT(1),AA !escreve no aruivo

      DO 180 J=2,NT
	SOLD=ST
	QI2=QM(J)
	NPP=NP(IO)
	IF(QE.LE.0.)GO TO 20
	ST=FINT(QD(1,IO),S(1,IO),NPP,QE)
	GO TO 21
20	ST=SI
21	VAL=(QI2+QI1)/2.-QE/2+ST
	IF(J.GT.ITT(IO))IO=IO+1
	NPP=NP(IO)
	Q(J,IS)=FINT(FNP(1,IO),QD(1,IO),NPP,VAL)
	IF(Q(J,IS).LT.0.) Q(J,IS)=0.
	QE=Q(J,IS)
	aa=q(J,IS)+qDUT(J)
      COTJ=FINT(QD(1,1),COTAS(1),NPP,QE)	!COTA DO RESERVATORIO
	WRITE(7,'(i10,10F10.2)')J,COTJ,Q(J,IS),QDUT(J),AA
      COTM=MAX(COTM,COTJ) !COTA MAXIMA DO RESERVATORIO
	QMVERT=MAX(Q(J,IS),QMVERT) !VAZÃO MÁXIMA DO RESERVATÓRIO
	IF(QE.GT.0.)GO TO 180
	SI=VAL
180	QI1=QI2
C
!WC	SOMA A VAZAO DE SAIDA DO RESERVATORIO A VAZAO DO BYPASS
	DO J=1,NT
	    Qexceso(j)=Qdut(j)
		Q(J,IS)=Q(J,IS)+QDUT(J)
	ENDDO
!WC	FIM DA MUDANCA DA VAZAO DE SAIDA

	WRITE(7,179)COTM,QMVERT !GRAVA COTA E VAZAO MAXIMAS NO RESERVATORIO
	WRITE(2,5) SI1

	DO 225 I=1,NO
225	WRITE(2,75)ITT(I),(K,QD(K,I),S(K,I),K=1,NP(I))

	IF (IPR.GT.0)CALL PLOTA(0)
	IF (ILIST.GT.0)CALL HID
c
	DEALLOCATE (QM)
      DEALLOCATE (QDUT)
c
!________________________________________________________________________
5	FORMAT(/10X,'PROPAGACAO EM RESERVATORIO'///
     1,10X,'ESTADO INICIAL S =',F9.1,' M3/S',//)
6	FORMAT(///,10X,10A4)
75	FORMAT(
     110X,'CURVA VAZAO-VOLUME VALIDA ATE O INTERVALO: ',I3,
     1//,10X,'INT',5X,'VAZAO',5X,'VOLUME',/,18X,'(M3/S)',4X,'(M3/S)',
     1/,100(10X,I3,F9.1,F11.1,/))
776   FORMAT('OPHID',i5,5I10)
179	FORMAT('  COTAMAX ',1F10.3,'  QSAIMAX ',f10.2)

	RETURN
      END
C	**************************
