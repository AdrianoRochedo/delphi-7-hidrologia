      SUBROUTINE SOMA
	use var

      integer, allocatable, dimension (:) :: ism
	 
      READ(1,'(I10)')NSUM

      if(.not.allocated(ism))allocate (ism(nsum))

      READ(1,'(8I10)')(ISM(K),K=1,NSUM)
      WRITE(2,5)NSUM,(ISM(K),K=1,NSUM)

      DO 100 I=1,NSUM
      L=ISM(I)
            DO 100 J=1,NT
100   Q(J,IS)=Q(J,IS)+ Q(J,L)
      
      IF(IPR.EQ.0)GO TO 1000
      CALL PLOTA(0)
1000  IF(ILIST.EQ.0)GO TO 2000
      CALL HID
2000  deallocate (ism)
      RETURN
!______________________________________________________________________________
5     FORMAT(/,10X,'SOMA DE ',I2,' HIDROGRAMAS '//10X,'HIDROGRAMAS ',
     1'SOMADOS:',5I10)
      
      END
C************************
