  	SUBROUTINE PLOTA(K)
	use var 

	DIMENSION IY( 6),LL(8),IPLOT( 51),MY(51)

	Qmin=0

      IF (QMAX==0)then
          if (ie==0)then
              QMAX=MAXVAL(Q(:,is))
              else
              QMAX=MAXVAL(Q(:,ie))
	    endif
      endif

      IF (PMAX==0)PMAX=MAXVAL(Pef)
	if(pmax==0.)pmax=0.001

	DATA MY/51*'-'/,MAIS/'+'/,IAST/'*'/,IO/'0'/,IPONT/'.'/,
     1IBRAN/' '/,LL/'1','2','3','4','5','6','7','8'/,IPRE/'I'/
	CONST= 50/(QMAX-QMIN)
      
	DO 110 J=1,6
110	IY(J)=(QMAX-QMIN)*.2*(J-1)+0.0001
	DO 100 J=1,51,10
100	MY(J)=MAIS
	WRITE(2,1)(IY(J),J=1, 6),(MY(J),J=1, 51)
	IX=0
	
      DO 250 J=1,NT
	IF(J/10*10-J)120,150,120
120	DO 130 M=1, 51
130	IPLOT(M)=IBRAN
	DO 140 M=1, 51,10
140	IPLOT(M)=IPONT
	GO TO 170
150	DO 160 M=1, 51
160	IPLOT(M)=MY(M)
170	IF(K)180,180,190
180	M=(Q(J,IS)-QMIN)*CONST+1.0001
      
	if(ie>1)N=(Q(J,IE)-QMIN)*CONST+1.0001
      IF(M>51.OR.M<=0)then
	else
      IPLOT(M)=IAST
	endif
	IF(N>51.OR.N<=0)then
	else
      if(ncod<3)IPLOT(n)=mais !grafica a entrada no reservatorio e prop
      endif
      if(excesso==2)then !se propaga superficialmente
      HH=(Qexceso(J)-QMIN)*CONST+1.0001
      if(hh>=51)hh=50
      if (hh<0)hh=1
      IPLOT(hh)='e'
	
      endif          
181	IF(IOBS.LE.0) GO TO 183
	M=(QO(J)-QMIN)*CONST+1.001
	IF(M.GT. 51.OR.M.LE.0) GO TO 183
	IPLOT(M)=IO
183	IF(K.GE.0)GO TO 185
	  KK= 51.-PEF(J)/PMAX*20.
        IKM= 51-KK+1
        DO 182 II=1,IKM
        MM= 51-II+1
182     IPLOT(MM)=IPRE

185	i2 =ie
      if(ie==0)i2=is	  
      WRITE(2,2)J,Q(J,I2),Q(j,is),Qexceso(J),(IPLOT(L),L=1, 51)
      GO TO 250
190	DO 200 L=1,NPL
	M=IPL(L)
	M=(Q(J,M)-QMIN)*CONST+1.0001
	IF(M.GT. 51.OR.M.LE.0)GO TO 200
	IPLOT(M)=LL(L)
200	CONTINUE
	WRITE(2,3)J,(IPLOT(L),L=1, 51)
250 	CONTINUE
	Qexceso=0.
!_____________________________________________________________________ 
1     FORMAT(/, /, /, 2X, 'AT',2x,'    Qent      Qsai     Qbyp/ex',
     +I3, 5I10,/, 38X, 51A1)
2     FORMAT(I4, 3F10.1, 4X, 51A1)
3     FORMAT(I4, 25X, 51A1)
      RETURN
	END
