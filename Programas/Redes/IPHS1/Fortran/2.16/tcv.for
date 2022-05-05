      SUBROUTINE TCV
	use var
      integer, allocatable, dimension (:) :: npu
      real, allocatable, dimension (:) :: coth

	DO 30 I=1,NTT
	PA(I)=0.
30	PRE(I)=0.

	READ(1,'(8I10)') NTPU,LCHUVA
      
      if(.not.allocated(npu))allocate (npu(ntpu))
      if(.not.allocated(coth))allocate (coth(ntpu))

	READ(1,'(8I10)') (NPU(I),I=1,NTPU)
	READ(1,'(8F10.0)') (COTH(I),I=1,NTPU)

  	DO 20 J=1,NTPU
		DO 20 I=1,NTT
		  KKK=NPU(J)
20	PRE(I)=PRE(I)+COTH(J)*P(I,KKK)

        PA(1)=PRE(1)

      DO 70 I=2,NTT
70    PA(I)=PA(I-1)+PRE(I)

        IF(LCHUVA.EQ.0)GO TO 200
        CALL CHUVAP
200     IF(NTT.GE.NT)GO TO 220

      DO 210 K=NTT+1,NT
      PA(K)=0.
      PEF(K)=0.
210   PRE(K)=0.

220   READ(1,'(8I10)')NPER
!_____________________________________________________
      chuvavazao: select case (nper)

	case (1) chuvavazao	
      CALL IPHII

	case (2) chuvavazao	
      CALL SCS

	case (3) chuvavazao	
      CALL HEC1
	
      case (4) chuvavazao
      CALL FI

      case (5) chuvavazao
      CALL HOLTAN
	
      case default chuvavazao
	continue 
	end select chuvavazao

800   READ(1,'(8I10)') NPRPC,NESCB
	
!__________________________________________________________________
      propagachuva: select case (nprpc)
  
  	case (1) propagachuva
      CALL HU

	case (2) propagachuva
      CALL HIDT

	case (3) propagachuva
      CALL NASH

	case (4) propagachuva
      CALL CLARK

      case default propagachuva
	continue 
	end select propagachuva
!_____________________________________________________________

      do 2100 i=1,nt
      if(q(i,is).le.0.0)q(i,is)=0.001
2100  continue      

2000	IF(NESCB.NE.0) CALL EBASE
        IF (IPR.EQ.0)GO TO 3000
        CALL PLOTA(-1)
3000    IF (ILIST.EQ.0)GO TO 4000
        CALL HID
4000  deallocate (npu,coth)


      RETURN
!________________________________________________________________

        END
