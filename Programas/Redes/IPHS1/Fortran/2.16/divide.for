      SUBROUTINE Divide
	use var

	READ(1,'(2F10.0)') xFAC
	WRITE(2,8) xFAC
	 	
	DO 35 J=1,NT
	Q(J,IS)=Q(J,IE)*xFAC
	Q(J,IE)=Q(J,IE)-Q(J,IS)
35	CONTINUE

      IF(IPR.GT.0)CALL PLOTA(0)
      IF(ILIST.GT.0)CALL HID
!_______________________________________________________________________________-
8       FORMAT(10X,'DIVISAO DE HIDROGRAMA'//10X,'PERC DIV:',F7.2)
      RETURN
      END
