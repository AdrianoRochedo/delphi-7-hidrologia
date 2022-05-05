      SUBROUTINE PROPR
	use var
	integer np

      READ (1,'(2I10,3f10.2)')NCODP,NP,cotmon,cotjus,h
!_____________________________________________________
	propagacao: select case (ncodp)

      case (1) propagacao
	call amusk(np,cotmon,cotjus,h) !linear
      GO TO 1000

	case (2) propagacao
      READ(1,'(F10.0)')QREF
	CALL AMClinear(NCODP,QREF) !LINEAR com 2/3 Q
      GO TO 1000

	case (3) propagacao 
      call AMCnaolinear(ncodp,qref) !nao linear
	GO TO 1000

	case (4) propagacao
      call amcp		!com planicie de inundacao
	GO TO 1000

	case (5) propagacao
	call amcpfech(np)   !conduto fechado e com planicie

	case default propagacao  
	continue 
	end select propagacao

1000  IF (IPR.GT.0)CALL PLOTA(0)
      IF (ILIST.GT.0)CALL HID
    
      RETURN
	END
C**************************
