C**************************
        SUBROUTINE AMUSK(NP)
        DIMENSION X(30),XK(30),QT(30),QM(100)
        COMMON /DATA/Q(300,200),IPL(200),QMAX,QMIN,IS,IE,IPP,NPL,NT,
     1PRE(300),AT,QO(300),IOBS,IPR,ILIST,PA(300),PEF(300),NTT,PER(300),
     2PMAX,VOP(300),P(300,10)
   	DO 3333 K=1,NP
3333	READ(1,3)X(K),XK(K),QT(K)
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
210     Q(J,IS)=QQ
        WRITE(2,7)(K,X(K),XK(K),QT(K),K=1,NP)
      !--------------------------------
      write(8,778)is,1  !escreve as cotas
778	FORMAT('ophid',I5,f10.2)

      QMAX=MAXVAL(Q(:,is))

      	
      do I=1,nt
	cotant=cot
      cot=Q(I,is)/QMAX
 
      write(8,12)cot
      enddo !do impresao cota
      !-----------------------------------
12    format (f10.3)
        RETURN
3       FORMAT(3F10.0)
7	FORMAT(//10X,'TRECHO EN CANAL',
     1///,10X,'PARAMETROS',//,15X,'X',9X,
     1'K',5X,'VAZAO',/,100(I6,3F10.2,/))
        END
C**************************
