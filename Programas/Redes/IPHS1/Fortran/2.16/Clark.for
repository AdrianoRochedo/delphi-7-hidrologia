      SUBROUTINE CLARK
	use var

      real, allocatable, dimension (:) :: hist
      real, allocatable, dimension (:) :: pv

      READ(1,'(5F10.2)')XK,TC,XN,AREA
	xk=xk
      IF(TC.NE.0.AND.XK.NE.0)GO TO 101
      READ(1,'(5F10.2)')SSS
      SSS=10.*SSS
      IF(XK.NE.0)GO TO 102
      XK=80.7*AREA**0.23/SSS**0.7
102   IF(TC.NE.0)GO TO 101
      TC=1.75*AREA**0.41/SSS**0.17
101   NH=TC*3600./AT
	
      if(.not.allocated(hist))allocate (hist(nh))
      XK1=XK*3600./AT
      QS1=0
      IF(XN.EQ.0)GO TO 234
      C=0.5/(NH/2.)**XN
      L=NH/2
      XA=0.

      
      DO 232 II=1,L
      XA1=C*(II*1.)**XN
      HIST(II)=XA1-XA
      XA=XA1
      L1=NH-II+1
      HIST(L1)=HIST(II)
 232  CONTINUE
      
      IF(NH/2*2.EQ.NH)GO TO 236
      HIST(L+1)=(C*(NH/2.)**XN-XA)*2
      GO TO 236
 234  READ(1,'(8F10.2)')(HIST(II),II=1,NH)
 236  FATOR=AREA*1000/AT
      WRITE(2,24)
	ATA=AT/60.
      WRITE(2,25)AREA,ATA,TC,XK
      WRITE(2,21)(II,HIST(II),II=1,NH)
      QS1=QS1/FATOR
      XK1=EXP(-1/XK1)
      
      if(.not.allocated(pv))allocate (pv(nh))
      PV(:)=0.

      DO 280 J=1,NT
      VE=PEF(J)
          DO 265 KT=1,NH
265       PV(KT)=PV(KT)+VE*HIST(KT)
      VE=PV(1)
      LL=NH-1
          DO 270 KT=1,LL
270       PV(KT)=PV(KT+1)
      PV(NH)=0.
      QS1=QS1*XK1+VE*(1.-XK1)
      Q(J,IS)=QS1*FATOR
280   CONTINUE

	deallocate (hist)
	deallocate (pv)

!___________________________________________________________      
 21   FORMAT(///,10X,'HISTOGRAMA TEMPO-AREA',//,10X,'I',3X,
     1'ORDENADA'//,(I11,F10.2))
 24   FORMAT(///,10X,'PARAMETROS DA BACIA - METODO DE CLARK')
 25   FORMAT(/,10X,'AREA',3X,'INTERVALO DE TEMPO',3X,
     1'TEMPO DE CONCENTRACAO',3X,'RET. RES. LINEAR'/,11X,'KM2',
     29X,'MINUTOS',16X,'MINUTOS',15X,'HORAS'/,F14.1,F16.0,2F21.2)
      
      RETURN
      END
! *************************
