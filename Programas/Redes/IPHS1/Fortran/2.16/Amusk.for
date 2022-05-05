      SUBROUTINE AMUSK(NP,cotmon,cotjus,h)
	use var
      
      real, allocatable, dimension (:) :: x
      real, allocatable, dimension (:) :: xk
      real, allocatable, dimension (:) :: qt
      real, allocatable, dimension (:) :: qm

	!alocacao das matrizes acima
      if(.not.allocated(x))allocate (x(np))
      if(.not.allocated(xk))allocate (xk(np))
      if(.not.allocated(qt))allocate (qt(np))
      if(.not.allocated(qm))allocate (qm(nt))

   	DO 3333 K=1,NP
3333	READ(1,'(3F10.0)')X(K),XK(K),QT(K)

      DO 205 J=1,NT
      QM(J)=Q(J,IE)
205	CONTINUE
      
	Q(1,IS)=QM(1)
      
	DO 210 J=2,NT
	QENT=QM(J)
      QQ=Q(J-1,IS)
      XX=FINT(QT,X,NP,QQ)
	XKK=FINT(QT,XK,NP,QQ)
      C=XX * XKK
	CC=XKK-C+0.5*AT
	C1=(-C+0.5*AT)/CC
	C2=(C+0.5*AT)/CC
	C3=(XKK-C-0.5*AT)/CC
      QQ=QENT*C1+QM(J-1)*C2+QQ*C3
210   Q(J,IS)=QQ
      
	WRITE(2,7)(K,X(K),XK(K),QT(K),K=1,NP)
      write(8,778)is,1  !escreve as cotas

      QMAX=MAXVAL(Q(:,is))

      do I=1,nt
	cotant=cot
      cot=Q(I,is)/QMAX
      write(8,'(f10.3)')cot
      enddo !do impresao cota

	deallocate (x,xk,qt,qm)
      !--------------------------------
778	FORMAT('ophid',2I5)
7	FORMAT(//10X,'TRECHO EN CANAL',
     1///,10X,'PARAMETROS',//,15X,'X',9X,
     1'K',5X,'VAZAO',/,100(I6,3F10.2,/))
      RETURN
      END
C**************************
