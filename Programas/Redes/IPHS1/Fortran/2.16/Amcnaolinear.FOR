  
      !MS$NOFREEFORM
      !MS$FIXEDFORMLINESIZE:132

      SUBROUTINE AMCnaolinear(NCODP,QREF)
	use var

	REAL,ALLOCATABLE:: QM(:),QC(:,:),QCOR(:),QL(:)

      real B,H,ALONG,COTMON,COTJUS,DTCAL,dx
	integer trecho
      integer ILAT

      open(22,file='MUSKINGUN-CUNGE NAO LINEAR.SAI', status='unknown')       
      write(22,3333)
      write(22,4444)
      write(22,5555)
      write(22,7777)
      write(22,6666)
      write(22,2222)

	READ(1,'(6F10.2,i10,F10.3,I10)')
	1B,H,ALONG,COTMON,COTJUS,DTCAL,TRECHO,RUG,ILAT
      
      aviso=0.	
      ntrech=trecho
	SO=(COTMON-COTJUS)/ALONG !calcula a declividade
      COEF=1.67*SO**0.3/RUG**0.6
      NCALC=AT/DTCAL*(NT-1)+1  

      Qreferencia: if(Qref==0.)then
			QMMX=0.0
			DO IWC=1,NT
				IF(Q(IWC,IE).GT.QMMX)THEN
				QMMX=Q(IWC,IE)
				ENDIF
			ENDDO
			QREF=QMMX*2./3. !AQUI QREF É SUBSTITUÍDA
      endif Qreferencia

      allocate (qm(nt),qc(nt,ncalc))
            
      DO 202 K=1,NT
202   QM(K)=Q(K,IE)
       
      DO 24 I=1,NTRECH+1
	    DO 24 J=1,ncalc
24    QC(I,J)=0.

	DX=ALONG/NTRECH
	IF(DTCAL.EQ.AT)GO TO 80
	NCALC=AT/DTCAL*(NT-1)+1
	N=AT/DTCAL

      if(.not.allocated (QL))allocate (QL(ncalc))
      if(.not.allocated (Qcor))allocate (Qcor(ncalc))


	DO 90 I=1,NT-1
            DO 110 J=N*(I-1)+1,N*(I-1)+N
              QL(J)=0
              IF(ILAT.NE.0)QL(J)=(Q(I,ILAT)+(Q(I+1,ILAT)-Q(I,ILAT))
     1        *(J-(N*(I-1)+1))/(1.*N))/ALONG
110	      QCOR(J)=Q(I,IE)+(Q(I+1,IE)-Q(I,IE))*(J-(N*(I-1)+1))/(1.*N)
 90	CONTINUE
	
      QCOR(NCALC)=Q(NT,IE)
	GO TO 120
 80	NCALC=NT
	N=1

      if(.not.allocated (QL))allocate (QL(ncalc))
      if(.not.allocated (Qcor))allocate (Qcor(ncalc))

	DO 130 I=1,NT
        QL(I)=0
        IF(ILAT.NE.0)QL(I)=Q(I,ILAT)/ALONG
130	QCOR(I)=QM(I)

C	CONDICAO INICIAL
120	DO 20 J=1,NTRECH+1
20 	QC(J,1)=QCOR(1)
C
C	CONDICAO DE CONTORNO
	DO 30 N=2,NCALC
30	QC(1,N)=QCOR(N)

	DO 40 J=1,NTRECH
      	DO 50 N=1,NCALC-1
            C4= 2*QL(N)*DTCAL*DX
	        Q1=QC(J,N)/B
	        Q2=QC(J+1,N)/B
	        Q3=QC(J,N+1)/B
              IF((Q1.EQ.0.).AND.(Q2.EQ.0.).AND.(Q3.EQ.0))GO TO 55
                  IF((Q1.lt.0.).or.(Q2.lt.0.).or.(Q3.lt.0))then
	            write(*,*)'Nao se verificou as condicoes de estabilidade do metodo'
	            write(*,*)'de Muskingun-Cunge nao-linear'
	            stop
                  endif
	        CEL=COEF*(Q1**0.4+Q2**0.4+Q3**0.4)/3.
	        QESP=(Q1+Q2+Q3)/3.
	        AK=DX/CEL
	        XXX=0.5 - (0.5*QESP/SO)/CEL/DX
	        D=(QESP/SO)/CEL/DX
	        DEN=2*AK*(1- XXX)+DTCAL
	        C1=(2*AK*XXX+DTCAL)/DEN
	        C2=(DTCAL-2*AK*XXX)/DEN
	        C3=(2*AK*(1-XXX)-DTCAL)/DEN
              teste1=2*xxx*ak
	        teste2=2*ak*(1-xxx)
              write(22,'(i5,2x,i5,2x,2f10.2,f10.2,2x,f10.2,2x,2f10.2)')j,n,ak,xxx,teste1,dtcal,teste2,dtcal/ak
	        !teste para validar os coeficientes
                 if((c2<0.or.c3<0.).and.aviso==0.)then
	           write(*,*)'ATENCAO!!!!!'
	           write(*,*)'_______________________________________________________'
	           write(*,*)'Verificar as condicoes de estabilidade do metodo'
	           write(*,*)'de Muskingun-Cunge nao-linear'
	           write(*,*)'Redefinir intervalo de tempo de calculo ou'
	           write(*,*)'Redefinir o numero de trechos'
	           write(*,*)'na operacao hidrologica numero',is
	           write(*,*)'verificar arquivo "MUSKINGUN-CUNGE NAO LINEAR.SAI"'
                 write(*,*)'_______________________________________________________'
                 aviso=1.
                 endif
              C4=C4/DEN
              QC(J+1,N+1)=C1*QC(J,N)+C2*QC(J,N+1)+C3*QC(J+1,N)+C4  
              GO TO 50
55            QC(J+1,N+1)=0.
50	    CONTINUE
40	CONTINUE

      N=AT/DTCAL

      DO 1040 I=1,NT
1040  Q(I,IS)=QC(NTRECH+1,1+(I-1)*N)

	WRITE(2,209)DX,RUG,B,SO,DTCAL,NTRECH
      write(8,778)is  !escreve as cotas
      QMAX=MAXVAL(Q(:,is))
      
	do I=1,nt
	cot=Q(I,is)/QMAX
      write(8,'(f10.3)')cot
      enddo !do impresao cota

	DEALLOCATE (QM,QC,QCOR,QL)
!     ___________________________________________________________________________________
209   FORMAT(//10X,'PARAMETROS',//10X,'AX',6X,'N',4X,'LARGURA',4X,
     1'DECLIVIDADE',4X,'INT. TEMPO',4X,' NTRECH ',/ 9X,' M ',13X,
     1' M ',9X,' M/M ',9X,' SEG',/(F12.1,F7.3,F11.1,F15.5,F14.0,I11))
778	FORMAT('ophid',I5)
2222  format('Trecho',3x,'Tempo',3x,'Param K',5x,'Param X',3x,'2XK',6x,'tempo calc',2x,'2K(1-X)',2x,'int.tempo calc./K')
3333  format('Limites de validacao dos parametros K e X')
4444  format('0.0 <= X <= 0.5')
5555  format('2XK <= int.tempo calc <= 2K(1-X)')
6666  format('____________________________________________________________________')
7777  format('0.0 <= int. tempo calc./K <= 2.0')
      RETURN
      END
!**************************
