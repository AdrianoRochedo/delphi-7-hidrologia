	PROGRAM CP

C  /===============================================versao 23/03/93=======\
C  || Desenvolvido por                                                   ||
C  || Antonio Eduardo Lanna, IPH/UFRGS                                   ||
C  ||                                                                    ||
C  ||   Este programa :                                                  ||
C  ||   1. Le codigos de postos fluviometricos regionais;                ||
C  ||   2. Constroi as curvas de permanencia diaria, mensal e anual      ||  
C  ||                                                                    ||
C  ||   INSTRUCOES DE UTILIZACAO: criar arquivo de dados com as seguintes||
C  ||   instrucoes:                                                      ||    
C  ||   Linha 1: nome do arquivo de vazoes médias diarias, entre aspas   ||
C  ||   Linha 2: numero de anos da amostra                               ||
C  ||   Linha 3: anos encontrados no arquivo                             ||
C  ||   Linha seguinte: numero de pontos da curva de permenencia anual;  ||
C  ||                   idem da curva de permanencia mensal;             ||
C  ||                   idem da curva de permanencia diaria.             ||
C  ||   Ultima linha: nome do arquivo de resultados, entre aspas         ||
C  ||                                                                    ||
C  ||   Nota: o arquivo de dados e' lido com o segyinte formato:         ||
C  ||                                                                    ||
C           READ (10,22,ERR=8888)ICOD,JANO,(Q(I),I=I1,I2)                ||       
C     22    FORMAT(1X,I8,I4,27X,31F6.0)                                  ||
C  ||                                                                    ||
C  ||   Apenas os anos relacionados a partir da linha 3 sao processados; ||
C  ||   isto permite que anos em que ocorra muitas falhas sejam excluidos||                                                                  ||
C  ||   mesmo que estejam presentes no arquivo; alem disto, poderao exis-||
C  ||   anos que sejam excluidos do arquivo - desde que eles nao sejam   ||
C  ||   relacionados na linhas 3 e seguintes nao havera erro.            ||
C  ||   O usuario, quando necessario, podera alterar o formato de leitura||
C  ||   adequando-o ao seu arquivo de dados.                             ||
C  \=====================================================================/

      CHARACTER*80 ARQFLU, ARQRES, TEXTO
      INTEGER IANO(50), ND(12)
      DIMENSION Q(18600),QANO(50),QMES(600),T(18600)

C     Estabelece numero de dias de cada cinquendio (NDC)
      DATA ND/31,28,31,30,31,30,31,31,30,31,30,31/

      OPEN(10,FILE=' ',STATUS='OLD')
      READ(10,*,ERR=8888) ARQFLU,KANO,(IANO(K),K=1,KANO),NPANO,NPMES,
     *                    NPDIA,ARQRES
      CLOSE(10)

C     Inicio do processamento : leitura dos dados do  posto fluviometrico
      OPEN(10,FILE=ARQFLU,STATUS='OLD')
      WRITE(*,7) ARQFLU
7     FORMAT(' Abre para leitura arquivo ',A)
      
      IMES = 0
      n = 0
      i2 = 0
      DO 50 K = 1,KANO
C     Verifica se ano e' bissexto; se for corrige numero de dias ultimo
C     cinquendio de FEV
      ND(2) = 28
      IF(MOD(IANO(K),4).EQ.0) ND(2) = 29

C     Leitura de dados diarios de vazao no formato linha-mensal, para ano 1
10    DO 21 L=1,12
      NDM = ND(L)
      I1 = I2+1
      I2 = I1 + NDM - 1
      READ (10,22,ERR=8888)ICOD,JANO,(Q(I),I=I1,I2)
22    FORMAT(1X,I8,I4,27X,31F6.0)
      IF(JANO.ne.IANO(K)) GOTO 1234 
      N = N + ndm
      SUM = 0.0
      DO 2222 I = I1,I2
      SUM = SUM + Q(I)
2222  CONTINUE
      IMES = IMES + 1
      QMES(IMES) = SUM/ndm
21    CONTINUE

      IF(JANO.EQ.IANO(K)) GOTO 45 
      WRITE(*,8000) JANO, IANO(K)
8000  FORMAT(' ATENCAO : Ano no arquivo : ',I4,' nao coincide com',
     1' solicitado : ',I4)

C     Se ano lido > buscado ha' erro no arquivo : aborta execucao
1234  i1 = i1 - ndm
      i2 = i2 - ndm
      IF(JANO.GT.IANO(K)) GOTO 227

C     Se ano lido < buscado va' ao ano seguinte
      GO TO 10
C     Leu ok ano K - vai arrumar arquivo de vazaos na bacia
45    WRITE(*,2400) K, IANO(K) 
2400  FORMAT(' Leu vazoes ate ano ... ', I4,' = ',I4)
      IMES1 = IMES - 12 + 1      
      SUM = 0.0
      DO 47 I = IMES1,IMES
      SUM = SUM + QMES(I)
47    CONTINUE
      QANO(K) = SUM/12.
50    CONTINUE

      write(*,*)' Impressao de dados'
      OPEN(10,FILE=' ',STATUS='UNKNOWN')
      write(10,*)' diarios'
      write(10,11111) (q(i),i=1,n)
11111 format(1x,10f10.3)
      nmes = kano * 12
      write(10,*)' mensais'
      write(10,11111) (qmes(I),i=1,nmes)
      write(10,*)' anuais'
      write(10,11111) (qano(i),i=1,kano)
      write(*,*)' Fim Impressao de dados'
      close(10)

      OPEN(10,FILE=arqres,STATUS='UNKNOWN')
      write(*,*)' Curva de permanencia ANUAL'
      write(10,*)' Curva de permanencia ANUAL'
      CALL perma(QANO,T,kano,NPANO)

      Nmes = KANO * 12
      write(*,*) ' Curva de permanencia mensal'
      write(10,*)' Curva de permanencia mensal'
      CALL perma(QMES,T,Nmes,NPMES)

      write(*,*)' Curva de permanencia diaria'
      write(10,*)' Curva de permanencia diaria'
      CALL perma(Q,T,N,NPDIA)

      STOP

227   WRITE(*,9) JANO,IANO(K)
9     FORMAT(' ABORTOU : Verifique arquivo de vazaos ou seus anos'/
     1 'ano lido = ',I4,' ; ano buscado = ',I4//)
	GOTO 1000
      STOP 

C     SAIDA NO CASO DE ERRO DE LEITURA DE DADOS

8888  WRITE(*,8887) ARQFLU
8887  FORMAT(/' ATENCAO : Erro de leitura de dados no arquivo : ',A/) 
      READ(10,1)TEXTO
1     format(1x,A)
      WRITE(*,8886) IANO(K), K, L, TEXTO
8886  FORMAT(//' Localizacao do erro : '/
     1' Ano pedido=',I4, ' Ano=',I4,' - Mes=',I4,' - Dia=',I4
     2 /' Proxima linha de dados : '/1X,A//' EXECUCAO ABORTADA !')

1000  STOP  1
      END

      SUBROUTINE PERMA(Q,T,N,NQ)

      DIMENSION Q(N),QQ(1000),T(N)

      IF(NQ .EQ. 0) GOTO 10000

C     Calcula a curva de permanencia por pontos
      QMAX = -1. E32          !1) Calculo
      QMIN =  1. E32          !   do maximo
      DO 100 I = 1,N          !   e do minimo
      QMAX = AMAX1(QMAX,Q(I)) !   da serie
      QMIN = AMIN1(QMIN,Q(I)) !   de valores
100   CONTINUE                !   amostrais

      DQ = (QMAX-QMIN)/(NQ-1) !2) Estabelece 
      QQ(1) = QMAX            !   serie de
      QQ(NQ) = QMIN           !   pontos da
      NQM1 = NQ-1             !   curva de
      DO 200 I = 2,NQM1       !   permanencia
200   QQ(I) = QQ(I-1) - DQ    !   

      T(1) = FLOAT(1)/FLOAT(N)
      WRITE(10,10) T(1),QQ(1)
10    FORMAT(1X,G15.6,2X,F10.3)
      NQM1 = NQ - 1
      DO 400 J = 2,NQM1              !3) Computa o numero
      K = 0                          !   de vezes K que o
      DO 300 I = 1,N                 !   valor QQ e' ultra-
      IF(QQ(J) .LT. Q(I)) K = K + 1  !   passado pelas vazoes
300   CONTINUE   
      T(J) = FLOAT(K)/FLOAT(N)
      WRITE(10,10) T(J),QQ(J)     
400   CONTINUE
      T(NQ) = 1.
      WRITE(10,10) T(NQ),QQ(NQ)   

      RETURN

C     Ordena valor por valor : o metodo faz N-1 passagens sobre a serie; em
C     cada passagem estabelece o maior/menor, o 2do maior/menor,  etc ...

10000 N1 = N - 1                      
      DO 28135 I = 1,N1             ! Contador da ordem
      J1 = I+1
      DO 28130 J = J1,N             !  
      IF(Q(I) .GE. Q(J)) GOTO 28130 !  corrige-o confrontando
      Z = Q(I)                      !  com os demais valores.
      Q(I) = Q(J)
      Q(J) = Z
28130 CONTINUE
      T(I) = FLOAT(I)/FLOAT(N)
      WRITE(10,10) T(I),Q(I)
28135 CONTINUE
      T(N) = 1.
      WRITE(10,10) T(N),Q(N)

      RETURN     
      END