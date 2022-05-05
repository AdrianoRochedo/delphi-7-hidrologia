C******************************
	FUNCTION FINT(X,Y,N,ABC)
	DIMENSION X(1),Y(1)
	
      if (X(1)==ABC)then !verifica se o primeiro satisfaz a condição
	fint=y(1)
	return
	endif

      NM1=N-1
	DO 10 I=2,NM1
	IF(ABC-X(I))20,40,10
10	CONTINUE
	J=N-1
	GO TO 30
20	J=I-1
30	FINT=Y(J)+(Y(I)-Y(J))*(ABC-X(J))/(X(I)-X(J))
	RETURN
40	FINT=Y(I)
	RETURN
	END
C************************
