	PROGRAM EXTREMOS

C+--------------------------------------------------------------------------+
C|    Calcula valores de sequencias de extremos maximos ou minimos de series|
C|    hidrologicas diarias (geralmente vazoes medias diarias)               |
C|                                                                          |
C|    Desenvolvido por Antonio Eduardo Lanna                                |
C|    Instituto de Pesquisas Hidraulicas                                    |
C|    Univesidade Federal do Rio Grande do Sul                              |
C|                                                                          |
C|    Dicionario                                                            |
C|                                                                          |
C|    RIO : nome do curso de agua ou do municipio                           |
C|    SECAO : nome da secao fluvial ou da estacao pluviometrica             |
C|                                                                          |
C|    ANOI, ANOF : anos inicial e final do periodo de analise               |
C|    TIPARQ : tipo de arquivo de dados : 1 = DNAEE; 2 = IPH/UFRGS          |
C|    TIPDAT : tipo de dado hidrologico : 1 = chuva; 2 = vazao              |
C|    QA(D) : observacoes diarias, D = 1, 365/366                           |
C|    Q(I,J,K) : observacoes completas do arquivo de dados,                 |
C|    nos dias I, (I = 1, 28 a 31), meses J, (J = 1,12)                     |
C|    e anos K, (K=1,ANOF-ANOI+1).                                          |
C|                                                                          |
C|    MINMAX : Identificador de extremos - se -1, extremos minimos;         |
C|             Se + 1, extremos maximos. (Observacao : o programa sempre    |
C|             busca o valor maximo da variavel multiplicada por MINMAX;    |
C|             diante disto, quando MINMAX=-1, obtem-se o maximo dos ne-    |
C|             gativos, que e' o valor minimo)                              |
C|                                                                          |
C|    NDUR : numero de periodos de locacao dos extremos                     |
C|    DUR(L) : dias em cada periodo de locacao de extremos (L = 1,NDUR)     |
C|    LMAX : Numero de estacoes hidrologicas anuais                         |
C|    MESI(LM), MESF(LM) : meses inicial e final da estacao LM, (LM=1,LMAX) |
C|    QA(D) = observacoes em uma estacao hidrologica                        |
C|    QEXT(L,K) : serie de extremos anuais (K) para diferentes duracoes (L) |
C+--------------------------------------------------------------------------+

C+--------------------------------------------------------------------------+
C|  EXTREMOS : Programa para calculo de sequencias valores extremos anuais  |
C|             de variaveis hidrologicas diarias.                           |
C|                                                                          |
C|  Roteiro de utilizacao : ARQUIVO DE INSTRUCOES                           |
C|                                                                          |
C|  LINHA 1 :                                                               |
C|  Curso de agua ou municipio, secao ou local                              |
C|  Nome do arquivo de dados hidrologicos                                   |
C|  tipo de dado (1 = chuva, 2 = vazao), tipo arquivo (1=DNAEE, 2=SUDENE)   |
C|                                                                          |
C|  LINHA 2 :                                                               |
C|  Tipo extremo (-1=minimo, +1=maximo), numero de anos, sequencia de anos, |
C|  valor indicador de ocorrencia de falha                                  |
C|                                                                          |
C|  LINHA 3 :                                                               |
C|  Numero de estacoes hidrologicas distintas.                              |
C|                                                                          |
C|  LINHA 4 :                                                               |
C|  Mes inicial estacao 1, mes final estacao 1, e sucessivamente para 2,... |
C|                                                                          |
C|  LINHA 5 :                                                               |
C|  Numero de duracoes a considerar, duracao 1, duracao 2, ...              |
C|                                                                          |
C+-------------------------------------------------------------VER 02-11/92-+

	INTEGER ANO,ANOS(50),DUR(10),D,DIA(12),TIPDAT,TIPARQ
	DIMENSION Q(31,12,50),MESI(12),MESF(12),QEXT(10,50)
	DOUBLE PRECISION QA(366),QT(10)
	CHARACTER*7 EXTRE(2),TIPO
	CHARACTER*40 RIO,SECAO,ARQDAT
	DATA DIA/31,28,31,30,31,30,31,31,30,31,30,31/
	DATA EXTRE/'MINIMOS','MAXIMOS'/

1     FORMAT(A)
	OPEN(1,FILE=' ',STATUS='OLD')

	READ(1,*) RIO,SECAO,ARQDAT,TIPDAT,TIPARQ
	
C     Le identificador de extremos MINMAX (-1 = min, 1 = MAX),
C     numero de anos e sua sequencia

	READ(1,*) MINMAX, NANOS,(ANOS(I),I=1,NANOS),FALHA 

C     Le numero de estacoes hidrologicas

	READ(1,*) LMAX
	TIPO = EXTRE(1)
	IF(MINMAX.GT.0) TIPO = EXTRE(2)
	
C     Le meses extremos de cada estacao hidrologica      

	READ(1,*) (MESI(LM),MESF(LM),LM=1,LMAX)

C     Le numero e duracoes a computar, e fecha arquivo de dados

	READ(1,*) NDUR,(DUR(L),L=1,NDUR)      
	CLOSE (1)

C     Abre arquivo de saida

	OPEN(4,FILE=' ',STATUS='UNKNOWN')
	WRITE(4,2) TIPO, RIO, SECAO
2     FORMAT(' RESULTADO DO PROGRAMA EXTREMOS'/' VALORES EXTREMOS ',A/
     +' PARA ',A,' EM ', A/)
	
	OPEN(3,FILE=ARQDAT,STATUS='OLD')

C     Leitura de dados hidrologicos

	DO 150 K = 1,NANOS
	ANO = ANOS(K)
	WRITE(*,1111) ANO
1111  FORMAT(' BUSCA PARA LEITURA ANO : ',I4)
	
C     Verifica se ano e' bissexto; se for corrige numero de dias FEV
	IF(MOD(ANO,4).EQ.0) THEN 
	DIA(2) = 29
	ELSE 
	DIA(2) = 28
	ENDIF

175   GOTO(110,125),TIPARQ
C    ************************************************************************
C    *Leitura de dados diarios no formato DNAEE, para ano 1                 *
C    *Atencao : altere aqui caso seus dados hidrologicos sejam introduzidos *
C    *          com um MES por linha.                                       *
C    ************************************************************************
110   DO 121 J = 1,12
	NDIA = DIA(J)
	GOTO(115,116), TIPDAT 

C     Dados de chuva
115   READ (3,122) ICOD,JANO,(Q(I,J,K),I=1,NDIA)
122   FORMAT(I8,4X,I4,4X,31F5.1)      
	GOTO 121

C     Dados de vazao
116   READ (3,1122) ICOD,JANO,(Q(I,J,K),I=1,NDIA)
1122  FORMAT(I8,4X,I4,4X,31F5.1)      

121   CONTINUE
	GOTO 127
C    ************************************************************************
C    *Leitura de dados diarios no formato IPH-UFRGS                         *
C    *Atencao : altere aqui caso seus dados hidrologicos sejam introduzidos *
C    *          com um ANO por linha.                                       *
C    ************************************************************************
125   GOTO (1251,1252), TIPDAT 

C     Dados de chuva
1251  READ(3,126) ICOD,JANO,((Q(I,J,K),I=1,32),J=1,12)
126   FORMAT(I8,I4,384F5.1)
	GOTO 127

C     Dados de vazao
1252  READ(3,1126) ICOD,JANO,((Q(I,J,K),I=1,32),J=1,12)
1126  FORMAT(I8,I4,384F5.1)

C     Verifica se ano lido e' o ano solicitado

127   IF(JANO.EQ.ANO) GOTO 150

C     Ano lido nao e' o solicitado - retorna para outro ano
	WRITE(*,18) JANO, ANO
18    FORMAT(' ATENCAO : Ano no arquivo : ',I4,' nao coincide com',
     1' solicitado : ',I4)

C     Se ano lido > buscado ha' erro no arquivo : aborta execucao

	IF(JANO.GT.ANO) GOTO 1227

C     Se ano lido < buscado va' ao ano seguinte

	GO TO 175

1227  WRITE(*,119) JANO,ANO
119   FORMAT(' ABORTOU : Verifique arquivo de chuvas ou anos fixados'/
     1' ano lido = ',I4,' ; ano buscado = ',I4)
	STOP

150   CONTINUE
	WRITE(*,1112)
1112  FORMAT(/' ENCERRADA LEITURA DE DADOS - INICIA PROCESSAMENTO'//)
	CLOSE (3)

C     Fim da leitura de dados hidrologicos



C     Loop sobre estacoes hidrologicas

	DO 100 LM = 1,LMAX
	WRITE(*,14) LM
14    FORMAT(/' Inicio computacao estacao hidrologica ',I2/)
	MES1 = MESI(LM)
	MES2 = MESF(LM)
	WRITE(4,90) LM,MES1,MES2
90    FORMAT(//' ESTACAO HIDROLOGICA ',I2,2X,' MES INICIAL = ',I2,2X,
     +'MES FINAL = ',I2/7X,'DURACOES DOS SUB-PERIODOS'/)
	WRITE(4,99) (DUR(L),L=1,NDUR)
99    FORMAT(1X,'ANOS',2X,10(5X,I3,4X))

C     Verifica se estacao hidrologica esta contida no ano civil

	IF(MES2-MES1) 20,50,50

C     Estacao abrange parte de 2 anos civis 

20    DO 40 K = 1,NANOS - 1
	ANO = ANOS(K)
	WRITE(*,21) ANO
21    FORMAT(' Computando ano ',I4)

C     Inicializa contador de dias       
	
	D = 0

C     Sequencia final do ano inicial

	DO 25 J = MES1,12
	NDIA = DIA(J)
	IF(J.NE.2) GOTO 22
	IF((ANO/4)*4.EQ.ANO)  NDIA = 29
22    DO 25 I = 1,NDIA
	D = D + 1
	QA(D) = Q(I,J,K)
	IF(QA(D) .LT. FALHA ) GOTO 25
      WRITE(*,2222) I, J, ANO
	WRITE(4,2222) I, J, ANO
2222  FORMAT(' FALHA NO DIA ',I2,' DO MES ',I2,' DO ANO ',I4)
25    CONTINUE      

C     Sequencia inicial do ano seguinte

	ANO = ANOS(K + 1)
	DO 35 J = 1,MES2
	NDIA = DIA(J)
	IF(J.NE.2) GOTO 30
	IF((ANO/4)*4.EQ.ANO) NDIA = 29
30    DO 35 I = 1,NDIA
	D = D + 1
	QA(D) = Q(I,J,K+1)
	IF(QA(D) .LT. FALHA ) GOTO 35
	WRITE(*,2222) I, J, ANO
	WRITE(4,2222) I, J, ANO
35    CONTINUE
	NT = D

	CALL XTREMO(QA,QT,NT,DUR,NDUR,MINMAX,FALHA)

C     Tranformacao : reduz valor obtido a seu absoluto, reduz a 4 casas 
C     significativas e transforma em precisao simples

	DO 37 L = 1, NDUR
	QEXT(L,K) = SNGL(DNINT(10000.*DABS(QT(L)))/10000.)
37    CONTINUE

40    CONTINUE
	KFIM = K - 1
	GOTO 85
	
C     Estacao hidrologica contida em um unico ano

50    DO 70 K = 1, NANOS
	ANO = ANOS(K)
	WRITE(*,21) ANO
	D = 0
	DO 60 J = MES1,MES2
	NDIA = DIA(J)
	IF(J.NE.2) GOTO 52
	IF((ANO/4)*4.EQ.ANO) NDIA = 29
52    DO 60 I = 1,NDIA
	D = D + 1
	QA(D) = Q(I,J,K)
	IF(QA(D) .LT. FALHA ) GOTO 60
	WRITE(*,2222) I, J, ANO
	WRITE(4,2222) I, J, ANO
60    CONTINUE
	NT = D

	CALL XTREMO(QA,QT,NT,DUR,NDUR,MINMAX,FALHA)

C     Tranformacao : reduz valor obtido a seu absoluto, reduz a 4 casas 
C     significativas e transforma em precisao simples

	DO 65 L = 1, NDUR
	QEXT(L,K) = SNGL(DNINT(10000.*DABS(QT(L)))/10000.)
65    CONTINUE

70    CONTINUE
	KFIM = K - 1

C     Grava sequencia de extremos para estacao hidrologica recem analisada

85    DO 87 K = 1,KFIM
	ANO = ANOS(K)
	WRITE(4,91) ANO,(QEXT(L,K),L=1,NDUR)
91    FORMAT(1X,I4,2X,10(1PG11.4,1X))
87    CONTINUE

100   CONTINUE

	STOP
	END

	SUBROUTINE XTREMO(QA,QT,N,DUR,NDUR,MINMAX,FALHA)
	INTEGER DUR(NDUR)
	DOUBLE PRECISION QA(N),QT(NDUR)  

C     Inicio do ciclo sobre duracoes      
	DO 120 L = 1, NDUR
	ND = DUR(L)

C     Verifica duracao : 1 ou mais dias
	IF(ND.GT.1) GOTO 80
C     Duracao e' 1 dia -----------------------Inicio computacao para 1 dia
      I = 1
C     Busca dia sem falha para inicializar extremo
      DO 50 I = 1,N
      IF( QA(I) .LT. FALHA)  GOTO 60
50    CONTINUE
      GOTO 75
C     Encontrado dia sem falha : inicializa extremo
60    QT(1) = MINMAX * QA(I)
C     Prossegue para demais dias apos inicializar com primeiro dia sem falha
      I2 = I + 1
	DO 70 I = I2,N
      QAM = MINMAX*QA(I)
      IF(QA(I) .GE. FALHA .OR. QT(1) .GE. QAM ) GOTO 70
	QT(1) = QAM
70    CONTINUE
	GOTO 120
C     Coloca overflow quando so'houver falhas no ano hidrologico
75    QT(1) = -12345678901234567890.
      GOTO 120
C     ----------------------------------------Final computacao para 1 dia
C     Duracao e'superior a 1 dia ==========Inicio computacao para varios dias
C     Calcula valor da soma do primeiro sub-periodo
80    KEY = 0
      QTA = 1.E+20
      QT(L) = 0.
      I1 = 1
85    ND1 = ND + I1 - 1
	DO 90 I = I1,ND1
C     Verifica se ha' falha   
      IF(QA(I) .LT. FALHA) GOTO 90
C     Ocorreu falha : desloca inicio do sub-periodo inicial, se nao acabou ano
      IF(I1 .GT. (N - ND) ) GOTO 110
      I1 = I1 + 1
      GOTO 85
C     Acumula valores para sub-periodo inicial
90    QT(L) = QT(L) + MINMAX*QA(I)/ND
C     Prossegue com demais sub-periodos do ano
      KEY = 1
	QTA = AMIN1(QT(L),QTA)
	L1 = ND + I1
	DO 100 I = L1,N
      IF(QA(I) .LT. FALHA) GOTO 95
C     Falha encontrada : volta `a busca de sub-periodo inicial
      I1 = I + 1
      QT(L) = 0.
      IF(I1 .LT. N - ND) GOTO 85
      GOTO 110
C     Prossegue computacao
95    IA = I - ND
	QT(L) = QT(L) + MINMAX * (QA(I) - QA(IA)) / ND
	IF(QTA .GE. QT(L)) GOTO 100
	QTA = QT(L)
100   CONTINUE
C     Guarda valor extremo com duracao L
105   QT(L) = QTA
      GOTO 120
C     Induz overflow se so'  ocorreram falhas
110   IF(KEY .EQ. 1) GOTO 105
      QT(L) = -12345678901234567890.
C     =====================================Final computacao para varios dias
120   CONTINUE
	RETURN
	END

