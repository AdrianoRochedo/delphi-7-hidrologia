      SUBROUTINE CHUVAP
	use var

      real, allocatable, dimension (:) :: pord
	if(.not.allocated(pord))allocate (pord(nt))

      READ(1,'(F10.0)')POS
      IP=NTT*POS
      IF(IP.LT.2)RETURN
      IF (POS.EQ.0.75)GO TO 400
      IR=(2*IP-2)/2
      L1=IP+IR+1
      L2=NTT
      LS=1
      LC=0
      GO TO 150
400   IR=NTT-IP
      L1=1
      L2=IP-IR-1
      LS=-1
      LC=NTT+1
150   PORD(IP)=PRE(1)

      DO 100 K=1,IR
      PORD(IP+K)=PRE(2*K)
100   PORD(IP-K)=PRE(2*K+1)

      IF(L2.LT.L1)GO TO 500
        DO 200 K=L1,L2
200     PORD(K)=PRE(LS*K+LC)

500   PA(1)=PORD(1)
      PRE(1)=PORD(1)

      DO 300 K=2,NTT
      PRE(K)=PORD(K)
300   PA(K)=PA(K-1)+PRE(K)

      deallocate (pord)
!______________________________________________________
        RETURN
        END
C************************
