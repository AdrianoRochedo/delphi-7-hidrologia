        SUBROUTINE AMCPFECH(ncodp,NP)
	USE VAR  
      DIMENSION H(30),qt(30),cel(31),qfulls(10)
     1,ak(30),xxx(30),sar(50),ATOT(30),A(30,10),Qmaximas(10),
     2itipe(30),B(30),y0(30),Qx(30,10),Tx(30,10),stor(300,200),t(30)
      COMMON /DATA/Q(300,200),IPL(200),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1PRE(300),AT,QO(300),IOBS,IPR,ILIST,PA(300),PEF(300),NTT,PER(300),
     2PMAX,VOP(300),P(300,10)
      COMMON /AUXILIO/NS
	COMMON /EXCESSOte/QEXC(20,5000),SO,
     *DTCAL,bagua,QMAXIN,RUGRUA,Qfull,j,N,DX,brua,
     *NCALC
	common /plotagem/ncod,excesso,Qexceso(300)
	integer iexc
	integer secion


      real cele
      REAL zl(30),zr(30) !DECLARO MATRICES DECLIVIDADE
	real rug(30)       !matriz rugosidade Manning
	integer excesso,ANCHO,ALTO,ZESQ,ZDIR 
      REAL, ALLOCATABLE:: QL(:),sto(:,:),qc(:,:),QM(:),QCOR(:)
!     A PROGRAMACAO E CONFUSA MAS FUNCIONA (daniel)
      QMAXin=MAXVAL(Q(:,ie)) !vazão maxima no intervalo anterior
      B=0.
	y0=0.
	rug=0.


	READ(1,23)QREF,excesso 
23    format(F10.2,I10)
21    format (4i10)
22    format (f10.3)
      
      select case (excesso) !le a linha seguinte dependendo da escolha de que fazer comk excessos
      case (1)
      read (1,21)secion,ANCHO,ALTO,ZESQ,ZDIR     !le em que dimensões amplia, caso seja tubo deixar linha em branco
      case (2)
      read (1,22)rugrua
	end select

500   IF (NP.EQ.0)nP=1 !por default num trechos paralelos= 1
18    FORMAT(I10, 8F10.2, 2I10)	
      
      J=1
      READ(1,18)itipe(j),y0(J),B(J),zl(j),zr(j),RUG(j),ALONG,SO,
     *DTCAL,NTRECH,ILAT 
	xlong=along

      IF(DTCAL==0.)DTCAL=AT  !SE DTCAL NAO E DEFINIDO ADOTA O DA SIMULAÇAO
      
      if (np.GT.1)then	!caso exista trechos paralelos le os valores
      dO 501 J=2,NP
	READ(1,18)itipe(j),y0(J),B(J),zl(j),zr(j),RUG(j)
501	continue
	endif

3535	iclose =1	!indico na rutina de prop que a secao e fechada
      QEXC=0.
	H=0.    !inicializaçao de variaveis e matrices
	qt=0.
	cel=0.
	ak=0.
	xxx=0.
	sar=0.
	ATOT=0.
      A=0.
	Tx=0.
	T=0.
	qfulls=0.
	qmaximas=0.
	qfull=0.
	qmax=0.
	Qexceso=0.

	DH=maxval(Y0)/20. !adoto a secao mais alta para fazer a tabela K, X =F(Q)

	do 502 j=1,np !do dos trechos paralelos, comeca a discretizar em fatias
c     ----------------
c    	secao retangular
c     ----------------
	retang: if(itipe(j).eq.1)then
	QMX=(B(j)*Y0(j))**(5./3.)/RUG(J)/(B(j)+2*Y0(j)
     1)**.66667*SO**.5 !VAZAO MAXIMA, quando supera o valor armazena o excedente e propaga direto
      Qfulls(j)=(B(j)*Y0(j))**(5./3.)/RUG(J)/(2*B(j)+2*Y0(j))
     1**.66667*SO**.5
      Qmaximas(j)=Qmx

      DO 57 I=1,20
      H(I)=I*DH	   !incremento i em delta H
c     ............................................................
	if (H(i).LE.y0(j)) then
      QX(I,J)=(B(j)*h(i))**(5./3.)/RUG(J)/(B(j)+2*h(i))**.66667*SO**.5 !VAZAO NA FAtiA
	A(I,J)=B(j)*H(I) !AREA DA FAtiA
	Tx(I,J)=B(j) !AREA MOLHADA da fatia
	
      else
	Qx(i,j)=Qmx
	A(i,j)=b(J)*y0(j)
	TX(I,J)=0.
	
      endif !FIM ROTINA RETANGULAR
c     ............................................................

57	continue
      endif retang 
c     -----------------
c 	secao circular
c     -----------------
      if(itipe(j).eq.2)then
c     ............................................................
c     !calculo da vazão para secao cheia
      pi=3.14159
      DS=Y0(j)
      RS=DS/2
      AX=PI*rs**2
      PMX=2*PI*rs
	RX=Ax/PMX
      QMX=AX*RX**(0.666667)*SO**(0.5)/RUG(J)
      Qfulls(j)=Qmx 
      !vazão maxima fechada
      y=0.94*y0(j)
      THE=2.*PI-2.*ACOS((y-RS)/RS)  !angulo para vazao maxima
      AX=(THE-SIN(THE))*DS*DS/8.
      RX=(1.-SIN(THE)/THE)*DS/4.
      QMX=AX*RX**(0.666667)*SO**(0.5)/RUG(J)
	TXX=2*sqrt(y*(DS-y))
      qmaximas(j)=Qmx 
c     ............................................................

      DO 58 I=1,20
      H(I)=I*DH

	if (0.99*H(i).LE.0.938*y0(j)) then  ! O 0,99 BEM DO FATO QUE DEVIDO A ARREDONDAMENTO NUNCA CUMPLIA A CONDICAO H(FINAL)=Y0(J)+0,00001 E ISO ME VOLVIO MALUCO
c     ............................................................
70    IF(H(i)-RS)71,71,72
71	  THE=2.*ACOS((RS-H(i))/RS)	!angulo de calculo para H=<RS - vide V. T. CHOW
      GO TO 73
72      if(H(I).LT.DS)THE=2.*PI-2.*ACOS((H(I)-RS)/RS) !H>RS
        if(H(i)>=DS)THE=2*PI
73    menor20:  if(I.LT.20)then

      alfa:  if(H(I).le.0.938*Y0(J))then    !se o valor e menor que a Qmax calculo
        TX(I,J)=2*SQRT(H(i)*(DS-H(I)))
        A(I,J)=(THE-SIN(THE))*DS*DS/8.
	  R=(1.-SIN(THE)/THE)*DS/4.
	  else      !quando diminui a vazão considera sempre a maxima
	  TX(I,J)=txx
        A(I,J)=ax
	  R=rx

	endif alfa

	QX(I,j)=A(I,J)*R**(0.666667)*SO**(0.5)/RUG(J)  !vazao
	
      else
      QX(I,J)=Qmx                   
      A(i,J)=Ax
	TX(i,j)=TXX
	end if menor20
c     .........................................
      else
      QX(I,J)=Qmx                   
      A(i,J)=Ax
	TX(i,j)=TXX
      endif

 58   continue

      end if !fim rotina circular
c     -----------------
c    	secao trapezoidal
c     -----------------
c
C      ESQUERDA  \_______/  DIREITA
c
	trapez: if(itipe(j).eq.3)then
	
      !VALORES PARA SECAO CHEIA

      YS=Y0(J) 
	Ammx=(0.5*(b(j)+ys*zl(j))+0.5*(b(j)+ys*zr(j)))*ys
      Pmmx=0.5*(b(j)+2.*ys*sqrt(1+zl(j)*zl(j)))+
     10.5*(b(j)+2.*ys*sqrt(1+zr(j)*zr(j)))
      Tmmx=b(j)+ys*(zl(j)+zr(j))
      Rmmx=Ammx/Pmmx
	QMX=Ammx/RUG(J)*Rmmx**0.6667*SO**0.5
      qmaximas(j)=Qmx  !vazão maxima

      Pmmx=0.5*(ys*zl(j)+b(j)+2.*ys*sqrt(1+zl(j)*zl(j)))+  !bsup+binf+talud (se repete para cada metade
     10.5*(ys*zr(j)*b(j)+2.*ys*sqrt(1+zr(j)*zr(j)))
      Tmmx=b(j)+ys*(zl(j)+zr(j))
      Rmmx=Ammx/Pmmx
	QMX=Ammx/RUG(J)*Rmmx**0.6667*SO**0.5
      Qfulls(j)=Qmx !vazão a secao cheia
 
      DO 59 I=1,20   !DO DAS FATIAS
      H(I)=I*DH	   !incremento i em delta H3
	YS=H(I)        !USO YS PORQUE JA Tinha A RUTINA PRONTA
c     ............................................................
	if (H(i).LE.y0(j)) then
	A(I,J)=(0.5*(b(j)+ys*zl(j))+0.5*(b(j)+ys*zr(j)))*ys
	Tx(I,J)=b(j)+ys*(zl(j)+zr(j))
      Pmmx=0.5*(b(j)+2.*ys*sqrt(1+zl(j)*zl(j)))+
     10.5*(b(j)+2.*ys*sqrt(1+zr(j)*zr(j)))
      Rmmx=A(I,J)/Pmmx
      QX(I,J)=A(i,j)/RUG(J)*Rmmx**0.6667*SO**0.5
	
      else
	Qx(i,j)=Qmx
	A(i,j)=AMMX
	TX(I,J)=0.
	
      endif 
c     ............................................................

59	continue
      endif TRAPEZ 


502	  continue  !fim do calculo de area por trecho paralelo
      !------ SOMA DAS AREAS E VAZOES  --------
	do 505 i=1,30
      if(i.gt.20)qt(i)=Qt(20)+i/10000.

      do 503 j=1,np
	QT(i)=QT(i)+Qx(I,j)	 ! somatoria dos valores
	ATOT(I) =ATOT(I)+A(I,J)
	T(I)=T(I)+TX(I,J)

503   continue
      Qmax=sum(Qmaximas)
      Qfull=sum(Qfulls)

	IF (i.eq.1)cel(i)=Qt(i)/ATOT(I)
     	if(itipe(1).eq.2.AND.h(i).gt.0.94*y0(1))then
      cel(i)=cel(i-1)    !so neste caso fazo isto, nos outros calculo como segue
      else
      IF (i.GT.1.AND.i.le.20)cel(i)=(Qt(I)-Qt(I-1))     !creava problemas porque se cerraba la seccion despacio
     */(ATOT(I)-ATOT(I-1))                              !supestamente esto no es mas necessario, pero lo dejo pq estoy apurado
	!revise y avise si tiene error
     
	if(np==1.AND.itipe(1)==2.AND.h(i)>0.94*y0(1))cel(i)=cel(i-1)
      if(i.gt.20)cel(i)=cel(20)
	endif
505   continue

c     calculo dos parametros
c     --------------------------------------------------------------
c     -----------  dteremino No trechos para cond de estabilidade --
	deltax: if(Ntrech.eq.0.)then   !SE NTRECHOS E =0 CALCULO AUTOMATICAMENTE
	!suprimo Qref se igual a 0.
	if (qref==0)then
      
	QREF=Qmaxin*2./3. !AQUI QREF É SUBSTITUÍDA
	if (qref>qfull) Qref=Qfull*2/3
	endif
      
	! verifico que a vazao de ref nao seja maior que a capacidade do conduto
      if(qref.gt.qfull)THEN
      Write(*,*)"conduto muito pequeno para a vazão 
     * de referencia"
			write(9,*)'OPERAÇAO',ca
			WRITE(9,*)"conduto muito pequeno para a vazão 
     * de referencia"
      ENDIF

	!procuro o valor de celeridade para Qref
      cele=FINT(QT,cel,30,Qref)
      Te=FINT(QT,T,30,Qref)

!wc	Aqui é calculado o melhor numero de trechos NTRECH 

      DTCAL=AT !POR UMA QUESTAO DE SEGURANÇA
	IWCT=1
C	DX=(2.5*QREF)/(B*SO*CEL) !ESTIMATIVA INICIAL DE DX
	DX1=0.5 !VALOR ARBITRARIO BEM PEQUENO
	DX2=ALONG*100000.
	XACC=0.5 !ERRO ADMITIDO NA RAIZ
1919	CALL NEWTRAP(RTSAFE,DX1,DX2,xacc,QREF,Te,SO,cele,DTCAL)
	DX=RTSAFE
!WC	TESTA ESTE DX 
	IF((ABS(DX-ALONG))/ALONG.LT.0.1.OR.DX/ALONG.LT.0.6)THEN
		XTRECH=ALONG/DX
		NTRECH=NINT(XTRECH)

	ELSE
		IWCT=IWCT+1
		IF(IWCT.GT.10)THEN 	!DESISTE DE DIMINUIR DTCAL E USA DX=ALONG
			WRITE(2,*)'DX=ALONG,  DTCAL=',DTCAL
			NTRECH=1
			GOTO 2019
		ENDIF
		DTCAL=AT/IWCT !VAI DIMINUINDO DTCAL,MAS MANTEM MULTIPLO DE AT
		GOTO 1919
	ENDIF
c	if(ntrech.ne.1)write(*,*)is,ntrech
	endif deltax

!WC
2019	DX=ALONG/NTRECH
c     ---------------------------------------------------------
	!parametros x e K do método

      do 504 i=1,30

      AK(I)=DX/CEL(I)
      if(i.gt.20)then
	XXX(I)=xxx(20)
	else
      XXX(I)=0.5 - (0.5*QT(I)/T(I)/SO)/CEL(I)/DX
	endif

504   continue
      WRITE(2,7)(K,H(K),ATOT(K),CEL(K),XXX(K),AK(K),QT(K),K=1,20)

	WRITE(2,*)'Qmaxima',Qmax,'Qcheia',Qfull

c    ---------------------------------------------------------------------
c    ----------------  propagaçcao mesmo   -------------------------------
	
102      IF (.NOT. ALLOCATED(qm))ALLOCATE (qm(NT+1))
         DO 202 K=1,NT
202     QM(K)=Q(K,IE)
 
	DX=ALONG/NTRECH

    
      IF(DTCAL.EQ.AT)GO TO 80
	NCALC=AT/DTCAL*(NT-1)+1

	IF (.NOT. ALLOCATED(ql))ALLOCATE (QL(ncalc))
      IF (.NOT. ALLOCATED(sto))ALLOCATE (sto(NS,ncalc))
      IF (.NOT. ALLOCATED(qc))ALLOCATE (qc(NTRECH+1,ncalc))
!      IF (.NOT. ALLOCATED(qc))ALLOCATE (qexc(NTRECH+1,ncalc))
       IF (.NOT. ALLOCATED(qcor))ALLOCATE (QCOR(ncalc)) 
 
      QC=0.

	N=AT/DTCAL
	DO 90 I=1,NT-1
	DO 110 J=N*(I-1)+1,N*(I-1)+N
        QL(J)=0.
        IF(ILAT.NE.0)QL(J)=(Q(I,ILAT)+(Q(I+1,ILAT)-Q(I,ILAT))
     1*(J-(N*(I-1)+1))/(1.*N))/ALONG

c      if(is.gt.58)write(*,*)i,ie,n,j,N*(I-1)+N
110	QCOR(J)=Q(I,IE)+(Q(I+1,IE)-Q(I,IE))*(J-(N*(I-1)+1))/(1.*N)
 90	CONTINUE
	QCOR(NCALC)=Q(NT,IE)
	GO TO 120
 80	NCALC=NT

	IF (.NOT. ALLOCATED(ql))ALLOCATE (QL(ncalc))
      IF (.NOT. ALLOCATED(sto))ALLOCATE (sto(NS,ncalc))
      IF (.NOT. ALLOCATED(qc))ALLOCATE (qc(NTRECH+1,ncalc))
!     IF (.NOT. ALLOCATED(qc))ALLOCATE (qexc(NTRECH+1,ncalc))
      IF (.NOT. ALLOCATED(qcor))ALLOCATE (QCOR(ncalc)) 
       QC=0.

	N=1
	DO 130 I=1,NT
        QL(I)=0
        IF(ILAT.NE.0)QL(I)=Q(I,ILAT)/ALONG
130	QCOR(I)=QM(I)
120	DO 20 J=1,NTRECH+1
20 	QC(J,1)=QCOR(1)
	DO 30 N=2,NCALC
30	QC(1,N)=QCOR(N)
      do 31 n=1,ncalc
      sto(is,n)=0.0      !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
31    continue      
c
	DO 40 J=1,NTRECH   ! DO dos trechos
c
	DO 50 N=1,NCALC-1  ! DO do tempo
      sto(is,n)=sto(is,n)+sar(j)*dtcal 
      QC(J,N)=QC(J,N)+QEXC(J,N) !SUMO A PROPAGACAO DE EXCESOS SE EXISTE
        AUX1=QL(N)
        IF(ICLOSE.LE.0)GO TO 45 
        AUX=QC(J,N+1)+QL(N)*DX
        IF(AUX.GE.Qmax)GO TO 305
        IF(SAR(J).EQ.0)GO TO 45
        IF(SAR(J).GT.Qfull-AUX)GO TO 48
        AUX1=AUX1+SAR(J)/DX
        SAR(J)=0.
        GO TO 45
 48     QC(J+1,N+1)=Qfull
        SAR(J)=SAR(J)-(Qfull-AUX)
        GO TO 50
 45     QQ=(QC(J,N)+QC(J+1,N)+QC(J,N+1))/3.
        IF(QQ.LT.QT(1))QQ=QT(1)
        XX=FINT(QT,XXX,30,QQ)
	XKK=FINT(QT,AK,30,QQ)
	DEN=2*XKK*(1- XX)+DTCAL
	C1=(2*XKK*XX+DTCAL)/DEN
	C2=(DTCAL-2*XKK*XX)/DEN
	C3=(2*XKK*(1-XX)-DTCAL)/DEN
        C4=2*AUX1*DX*DTCAL/DEN

      if(Qc(j+1,N)>5*Qc(j,n).or.Qc(j+1,N)>5*Qc(j,n+1))then !quando a decida e muito rapida produz incosistencia
      if(c1.lt.0.0)c1=0.0
	if(c2.lt.0.0)c2=0.0
	if(c3.lt.0.0)c3=0.0
	if(c4.lt.0.0)c4=0.0
	endif

        QC(J+1,N+1)=C1*QC(J,N)+C2*QC(J,N+1)+C3*QC(J+1,N)+C4
c
      if(QC(J+1,N+1).le.0.0.and.abs(QC(J+1,N+1)).le.0.3)
     1QC(J+1,N+1)=-QC(J+1,N+1)
c

c	if(QC(J+1,N+1).lt.0.)write(3,*)ie,is,j,n
        GO TO 50

 305  Qexc(j,N)=Aux-Qfull
      QC(J+1,N+1)=Qfull
	if (excesso==2)then  !se propaga superficialmente
	bagua=t(20)
      CALL excessos()
      else  !caso contrario almacena
      SAR(J)=SAR(J)+(AUX-Qfull)
	endif

50	CONTINUE
40	CONTINUE
c      sto(ncalc,is)=sto(ncalc-1,is)
C     ---------------------------------
c	- ------------EXCESSOS ----------
      !DETERMINA OS EXCESSOS NAO PROPAGADOS
      N=AT/DTCAL            
	alaga=0.
	duracao=0.
	qcmax=0.
      if(excesso==2)WRITE(6,777)is
      DO 1040 I=1,NT
        Q(I,IS)=QC(NTRECH+1,1+(I-1)*N)
	if(excesso==2)Qexceso(I)=Qexc(NTRECH+1,1+(I-1)*N)
	if(excesso==2)write(6,776)I,Qexceso(I)
        stor(i,is)=sto(is,1+(I-1)*N)/at
	  alaga=alaga+stor(i,is)
	  if(stor(i,is).ne.0) then
	  duracao=duracao+1.
	  endif
1040  continue
776   FORMAT (i10,F10.2)
777   fORMAT('OPHID',I5,F10.2)
	duracao=duracao*at/60
      if(duracao.ne.0.) then ! ISTO ME AVISA SE ALAGOU

      !----SE A OPCAO FOI REDIMENSIONAR------------
	EXCe:IF (EXCESSO==1)THEN 
      j=secion
          if(itipe(J).eq.2)then  !SECAO CIRCULAR, INCREMENTA DIAMETRO EM 1%
	    y0(J)=y0(J)+0.01*Y0(J)
	    write(2,*)'SECAO',NP,'NOVO DIAMETRO',Y0(J)
          elseif(itipe(J).eq.1) then !SECAO RETANGULAR, INCREMENTA SEGUNDO OPCAO
	    IF (ANCHO==1)b(J)=b(J)+0.01*B(J)
	    IF (ALTO==1) y0(J)=y0(J)+0.01*Y0(J)
	    write(2,*)'SECAO',NP,'ALTURA',Y0(J),'LARGURA',B(J)
          elseif(itipe(1).eq.3) then !SECAO TRAPEZOIDAL, INCREMENTA SEGUNDO OPCAO
          IF (ANCHO==1)b(J)=b(J)+0.01*B(J)
	    IF (ALTO==1) y0(J)=y0(J)+0.01*Y0(J)
	    IF (ZESQ==1) ZL(J)=ZL(J)+0.01*ZL(J)
	    IF (ZDIR==1) ZR(J)=ZR(J)+0.01*ZR(J)
          
 	Write(2,*)'SECAÓ',NP,'ALTURA',Y0(J),'LARGURA',B(J),'ZESQ',ZL(J),
     *'ZDIR',ZR(J)
      endif
      goto 3535
      ENDIF EXCe
      !---------------------------------------------
            
      WRITE(*,*)
	write(*,*) 'O TRECHO COM SAIDA NO HIDROGRAMA',IS,' INUNDOU - VERI
     1FIQUE O ARQUIVO (.ALG)'  
	WRITE(*,*)
			write(9,*)'OPERAÇAO',ca
			WRITE(9,*) 'O TRECHO INUNDOU - VERIFIQUE A SAIDA' 

	  WRITE(2,*)'O TRECHO ALAGOU-VERIFIQUE .ALG'
	  write(16,5986)
	  write(16,5987)is,alaga,duracao
5986	format(2x,'operacao',2x,'volume m3',2x,'duracao min')
5987  format(i10,4f10.3) 
	endif


209     FORMAT(//10X,'PARAMETROS',
     1//10X,'AX',6X,'N',
     14X,'B ',4X,'SO',4X,'DTCAL',4X,'NTRECH',4X,'BPLAN',4X,'NPLAN',4X,
     1'Y0'
     1/ 9X,'(M)',10X,'(M)',2X,'(M/M)',3X,'(SEG)',15X,'(M)',13X,'(M)',/,/
     1(F12.1,F7.3,F5.1,F7.4,F9.0,I10,F9.1,F9.3,F6.2))
7	FORMAT(//10X,'TRECHO COM GALERIA FECHADA',
     1///,9X,'I',9X,'H',9X,'A',7X,'CEL', 9X,'X',9X,
     1'K',5X,'VAZAO',/,
     119X,'M',7X,'M/S',18X,'HS',6X,'M3/S',/,
     1100(I10,2F10.2,4F10.2/)//)
11	FORMAT(4F10.0,I10,F10.0,2I10)
13	FORMAT(/10X,'TRECHO COM GALERIA FECHADA','   Qmax=',f8.2,
     1'   Qclose=',f8.2)

	deALLOCATE (QL,sto,qc,QM,QCOR) 
	
      write(8,778)is,h(10),1  !escreve as cotas
778	FORMAT('ophid',I5,f10.2,I10)
      do i=1,nt
      cot=Fint(QT,h,30,Q(i,is))
	write(8,12)cot
      enddo
12    format (f10.3)

      RETURN
        END

