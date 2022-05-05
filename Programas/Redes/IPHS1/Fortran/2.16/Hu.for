      SUBROUTINE HU
	use var

      real, allocatable, dimension (:) :: qt
	real, allocatable, dimension (:) :: huo

	if(.not.allocated(qt))allocate (qt(nt+ntt))
      READ(1,'(8I10)')NORD
	if(.not.allocated(huo))allocate (huo(nord+ntt))

      READ(1,'(8F10.0)')(HUO(K),K=1,NORD)
      WRITE(2,5)NORD
      WRITE(2,10)(HUO(K),K=1,NORD)

      DO 100 K=1,NT
100   QT(K)=0.
      
      DO 200 J=1,NTT
      PE1=PEF(J)
          DO 300 K=J,NORD+J-1
300       QT(K)=QT(K)+PE1*HUO(K-J+1)
200   CONTINUE
      
      DO 400 J=1,NT
400   Q(J,IS)=QT(J)

      deallocate (qt,huo)
!_________________________________________________________________________      
5     FORMAT(/10X,'NUMERO DE ORDENADAS DO HU:',I3/)
10    FORMAT(/10X,'ORDENADAS DO HU(1MM,AT) (M3/S):'//(10X,10 F7.2))

      RETURN
      END
C**********************************
