	SUBROUTINE PRECIP(NPCH)
	use var

	DO 10 J=1,NPCH
	READ(1,'(8I10)') NPO,NCHUVA
	READ(1,'(8F10.2)') (P(I,J),I=1,NTT)
      IF(NCHUVA.EQ.1)GO TO 10
        DO 20 I=NTT,2,-1
20      P(I,J)=P(I,J)-P(I-1,J)
10    CONTINUE

      WRITE(2,900)NPCH,(I,I=1,NPCH)

      DO 1000 I=1,NTT
      WRITE(2,'(8X,I4,2X,10F6.2)')I,(P(I,J),J=1,NPCH)
1000  CONTINUE
!________________________________________________
900   FORMAT(//10X,'NUMERO DE POSTOS COM CHUVA:',I3//
     1  10X,'INT',10X,'POSTO'/9X,'TEMPO',10I6) 

	RETURN
	END
C****************************
