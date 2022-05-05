'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'PROGRAMA DE PREENCHIMENTO DE FALHAS : PF.BAS                                 '
'adaptado por Juan Santiago                                                                             '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	CLS
	ON ERROR GOTO ERROS
	DIM TELA$(8), HELP$(25), BUFFER$(250)
	HELP$(0) = "123456789012345678901234"
	HELP$(1) = "    SOBRE AS OPCOES     "
	HELP$(2) = "   Para selecionar opcao"
	HELP$(3) = "desejada pressione tecla"
	HELP$(4) = "correspondente.         "
	HELP$(5) = "                        "
	HELP$(6) = "   SOBRE OS ARQUIVOS    "
	HELP$(7) = "   O  nome  dos arquivos"
	HELP$(8) = "devem ter no maximo  (8)"
	HELP$(9) = "caracteres  e  mais  (3)"
	HELP$(10) = "para a extensao.        "
	HELP$(11) = "   SOBRE OS ARQUIVOS    "
	HELP$(12) = "   Se nao  for  digitada"
	HELP$(13) = "a extensao do  arquivo o"
	HELP$(14) = "sistema assume  extensao"
	HELP$(15) = "( .REG ) .              "
	HELP$(16) = "        ATENCAO         "
	HELP$(17) = "   Se Semente  Aleatoria"
	HELP$(18) = "for igual a (-999) entao"
	HELP$(19) = "nao  sera gerado  numero"
	HELP$(20) = "aleatorio.              "
	HELP$(21) = "     SOBRE OS ERROS     "
	HELP$(22) = "   Quando for  provocado"
	HELP$(23) = "um  erro  aparecera  na "
	HELP$(24) = "tela uma mensagem  sobre"
	HELP$(25) = "este erro.        "
	DIM L$(10), TC(10)
	DIM V$(1000), T$(2)
	FOR TELA = 0 TO 8
	  TELA$(TELA) = ""
	NEXT TELA
	VEZ = 0
	APAGA = 0
	NEG = 0
	GRAVA = 0
	CONTHELP = 1
	GOSUB DESENTELA
	LOCATE 6, 23: PRINT "Instituto de Pesquisas Hidraulicas"
	LOCATE 8, 20: PRINT "Universidade Federal do Rio Grande do Sul"
	LOCATE 11, 20: PRINT "   PROGRAMA PARA PREENCHIMENTO DE FALHAS"
	LOCATE 12, 20: PRINT "       POR CORRELACAO LINEAR SIMPLES"
	LOCATE 15, 30: PRINT "VERSAO 1.0  /  1990"
	LOCATE 18, 20: PRINT "Desenvolvido por: "
	LOCATE 19, 37: PRINT "Antonio Eduardo Leao Lanna"
	LOCATE 20, 37: PRINT "Luciano Nunes de Oliveira"
	LOCATE 24, 46: PRINT CHR$(175); " Tecle << ENTER >> "; CHR$(174);
AQUI1:  OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI1
	IF ASC(OP$) <> 13 THEN BEEP: GOTO AQUI1
	LOCATE 24, 46: PRINT STRING$(21, 205);
	GOSUB LIMPATELA
	T$(1) = "NAO"
	T$(2) = "SIM"
	KI = 1
	SM = .5
	BC$ = STRING$(80, " ")
	NA = 0
	NR = 0
	T = 1
	EXEC = 0
	MUD$ = "A:\"
	A$ = "SEM NOME"
	APAGA = 1
	FOR I = 21 TO 3 STEP -1
	  LOCATE 2, I
	  PRINT "SISTEMA DE REGIONALIZACAO HIDROLOGICA VRS. 1.0 "
	  FOR J = 1 TO 20
	  NEXT J
	NEXT I
	LOCATE 1, 50: PRINT CHR$(203)
	LOCATE 2, 50: PRINT CHR$(186)
	LOCATE 3, 50: PRINT CHR$(202)
	LOCATE 10, 1: PRINT CHR$(204); STRING$(78, 205); CHR$(185);
	DEF SEG = &HB800
	FOR I = 163 TO 257 STEP 2
	  POKE I, &H13
	NEXT I
	DEF SEG

MENU1:  '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                          MENU PRINCIPAL                             '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	TECLA$ = "12345": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
MACETE: LOCATE 4, 25: PRINT "Entrada Inicial de Informacoes"
	LOCATE 6, 5: PRINT "1. Anamorfose logaritimica ( "; T$(T); " )"
	LOCATE 7, 5: PRINT "2. Dimensao dos arquivos   (    "
	LOCATE 7, 33: PRINT NR: LOCATE 7, 38: PRINT " )"
	LOCATE 8, 5: PRINT "3. Editar arquivos"
	LOCATE 24, 46: PRINT CHR$(175); " OPCAO "; CHR$(174);
	IF TESERRO = 1 THEN TESERRO = 0: RETURN
AQUI2:  LOCATE 2, 58: PRINT MUD$; A$; STRING$(13 - LEN(A$), 32)
	OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI2
	IF ASC(MID$(OP$, 1, 1)) = 0 THEN
	 IF MID$(OP$, 2, 1) = ";" THEN GOSUB AJUDA: GOTO MENU1
	 IF MID$(OP$, 2, 1) = "<" THEN GOSUB DIRETORIO: GOTO MENU1
	 IF MID$(OP$, 2, 1) = "=" THEN
		IF MUD$ = "A:\" THEN MUD$ = "B:\": GOTO AQUI2
		IF MUD$ = "B:\" THEN MUD$ = "C:\": GOTO AQUI2
		IF MUD$ = "C:\" THEN MUD$ = "A:\": GOTO AQUI2
	 END IF
	 IF MID$(OP$, 2, 1) = ">" THEN
		GOSUB MEIATELA
		LOCATE 12, 29
		PRINT "Confirma opcao (S/N) ?"
AQUI0:          OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI0
		IF OP$ = "S" OR OP$ = "s" THEN CLS : END
		IF OP$ = "N" OR OP$ = "n" THEN LOCATE 12, 2: PRINT STRING$(78, " "): GOTO AQUI2
		BEEP: GOTO AQUI0
	  END IF
	IF MID$(OP$, 2, 1) = "?" THEN
	   IF OUTROS = 0 THEN
	      OUTROS = 1
	      IF IMPRESSAO = 1 THEN IF GRAVA = 0 THEN TECLA$ = "124": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO: GOTO AQUI2
	      IF IMPRESSAO = 1 THEN IF GRAVA = 1 THEN TECLA$ = "12": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO: GOTO AQUI2
	      IF IMPRESSAO = 0 THEN IF GRAVA = 0 THEN TECLA$ = "1234": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO: GOTO AQUI2
	      IF IMPRESSAO = 0 THEN IF GRAVA = 1 THEN TECLA$ = "123": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO: GOTO AQUI2
	   END IF
	   IF OUTROS = 1 THEN OUTROS = 0: TECLA$ = "12345": GOSUB VALIDO: GOTO AQUI2
	END IF
	IF MID$(OP$, 2, 1) = "@" THEN EXEC = EXEC + 1: BUF = 0: TECLA$ = "": OUTROS = 0: GOSUB VALIDO: GOTO 2024
	IF MID$(OP$, 2, 1) = "A" THEN
	   IF IMPRESSAO = 0 THEN
	     IMPRESSAO = 1
	     IF OUTROS = 0 THEN OUTROS = 1
	     IF GRAVA = 0 THEN TECLA$ = "124"
	     IF GRAVA = 1 THEN TECLA$ = "12"
	     IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO: GOTO MACETE
	   END IF
	   IF IMPRESSAO = 1 THEN
	     IMPRESSAO = 0
	     IF OUTROS = 0 THEN OUTROS = 1
	     IF GRAVA = 0 THEN TECLA$ = "1234"
	     IF GRAVA = 1 THEN TECLA$ = "123"
	     IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO: GOTO MACETE
	   END IF
	END IF
	IF MID$(OP$, 2, 1) = "B" THEN
	  IF GRAVA = 0 THEN
	    GRAVA = 1
	    IF OUTROS = 0 THEN OUTROS = 1
	    IF IMPRESSAO = 0 THEN TECLA$ = "123"
	    IF IMPRESSAO = 1 THEN TECLA$ = "12"
	    IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO: GOTO MACETE
	  END IF
	  IF GRAVA = 1 THEN
	    GRAVA = 0
	    IF OUTROS = 0 THEN OUTROS = 1
	    IF IMPRESSAO = 0 THEN TECLA$ = "1234"
	    IF IMPRESSAO = 1 THEN TECLA$ = "124"
	    IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO: GOTO MACETE
	  END IF
	END IF
      END IF
	IF OP$ = "1" THEN
		       IF T = 1 THEN T = 2: GOTO MACETE
		       IF T = 2 THEN T = 1: GOTO MACETE
		     END IF
	IF OP$ = "2" THEN
OPD:                   LOCATE 7, 34
		       PRINT STRING$(4, "_")
		       CODIGO$ = "05480570734": GOSUB TRTR
		       NR = VAL(LETRA$)
		       IF NR > 1000 THEN BEEP: GOTO OPD
		       IF NR < 1000 THEN LOCATE 7, 37: PRINT " "
		       GOTO MACETE
		     END IF
	IF OP$ = "3" THEN GOSUB MENU2: NAUX = N: GOSUB LIMPATELA: GOTO MENU1
	BEEP
	GOTO AQUI2

2024    GOSUB MEIATELA
	IF GRAVA = 0 THEN
VAI1:                  LOCATE 15, 2: PRINT STRING$(78, " ");
		       LOCATE 15, 6: PRINT "Qual o nome do arquivo em que sera gravado o relatorio "
		       LOCATE 15, 61: PRINT STRING$(12, "_")
		       CODIGO$ = "13321221561": GOSUB TRTR
		       AUX$ = LETRA$
		       IF AUX$ = "" THEN AUX$ = "SEM NOME"
		       IF AUX$ = "SEM NOME" THEN GOSUB CANCELA: LOCATE 15, 2: PRINT STRING$(78, " "); : GOTO MENU1
		       YYY$ = AUX$: GOSUB VALIDADE: AUX$ = YYY$: IF ERG = 101 THEN GOSUB ERGS: GOTO VAI1
		       ARQREL$ = AUX$
		       LOCATE 15, 2: PRINT STRING$(78, " ");
		     END IF
	GOSUB DEFFUNC
	NA = NAUX: 'N
	IF EXEC = 1 THEN
		      DIM A$(NA), Q(NA, NR), X(NR), Y(NR)
		      DIM AA(NA), BB(NA), EE(NA), RR(NA), NN(NA)
		    END IF
	IF EXEC > 1 THEN
		      REDIM A$(NA), Q(NA, NR), X(NR), Y(NR)
		      REDIM AA(NA), BB(NA), EE(NA), RR(NA), NN(NA)
		     END IF
	FOR I = 1 TO NA
	  A$(I) = V$(I)
	NEXT I

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                     LEITURA DE ARQUIVO                              '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
3025    GOSUB MEIATELA: LOCATE 12, 31: PRINT "LEITURA DO ARQUIVO"
	FOR I = 1 TO NA
	  GOSUB TESTDRIVE: IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: GOSUB MEIATELA: GOTO MENU1
	  LIMPA = (80 - (14 + LEN(A$(I)))) / 2
	  LOCATE 13, 2: PRINT STRING$(78, " ");
	  LOCATE 13, LIMPA: PRINT "ARQUIVO ("; I; ") "; A$(I); STRING$(10, " ")
	  ARQUIVO$ = MUD$ + A$(I)
	  OPEN ARQUIVO$ FOR INPUT AS #1
	  IF TESERRO = 1 THEN TESERRO = 0: GOSUB LIMPATELA: GOTO MENU1
	  INPUT #1, Z, LIXO
	  IF Z = NR GOTO 3090
	  LOCATE 15, 15: PRINT " O arquivo "; A$(I);
	  PRINT " tem dimensao "; Z; " diferente de "
	  LOCATE 16, 15: PRINT NR; " que foi informada. "
	  LOCATE 17, 15: PRINT " Essa ultima sera adotada, se possivel."
	  IF Z < NR THEN NR = Z
	  BEEP: LOCATE 24, 46: PRINT CHR$(175); " Tecle << ENTER >> "; CHR$(174);
AQUI4:    OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI4
	  IF ASC(OP$) <> 13 THEN BEEP: GOTO AQUI4
	  LOCATE 24, 46: PRINT STRING$(21, 205);
3090      FOR J = 1 TO NR
	    INPUT #1, Q(I, J)
	  NEXT J
	  CLOSE #1
	NEXT I
	GOTO 4021

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                      FUNCOES DE TRANSFORMACAO                       '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
DEFFUNC: DEF FNFU (X)
	  IF T = 1 THEN FNFU = X
	  IF T = 2 THEN FNFU = LOG(X + .000001)
	END DEF
	DEF FNFV (X)
	  IF T = 1 THEN FNFV = X
	  IF T = 2 THEN FNFV = EXP(X) - .000001
	END DEF
	RETURN

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                        IMPRESSAO REGRESSAO                          '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'       ** Ciclo da Variavel Dependente **
4021    GOSUB LIMPATELA
	FOR IA = 1 TO NA
	  LIMPA = (80 - (21 + LEN(A$(IA)))) / 2
	  LOCATE 5, LIMPA: PRINT "Variavel dependente: "; A$(IA); STRING$(10, " ")
AQUI5:    LOCATE 7, 25: PRINT "Deseja preencher falhas (S/N) ?"
	  LOCATE 24, 46: PRINT CHR$(175); " OPCAO "; CHR$(174);
	  OUTROS = 0: TECLA$ = "4": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
	  OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI5
	  IF OP$ = "N" OR OP$ = "n" THEN GOTO 4950
	  IF OP$ = "S" OR OP$ = "s" THEN GOTO AQUI6
	  IF ASC(MID$(OP$, 1, 1)) = 0 THEN
	    IF MID$(OP$, 2, 1) = ">" THEN GOTO VAI2
	  END IF
	  BEEP: GOTO AQUI5
AQUI6:    LOCATE 24, 46: PRINT STRING$(21, 205);
	  TECLA$ = "": GOSUB VALIDO
4200      FLAG = 0: NC = 7: GOSUB IMPINIT:  ' ** Campo para 7 COLUNAS **
	  FLAG = 6: GOSUB IMPINIT: ' ** Traco "-" para TABELA **
	  FLAG = 8: GOSUB IMPINIT: ' ** Limpa TT$ **
	  T$ = "REGRESSOES LINEARES DAS VAZOES OBSERVADAS EM POSTOS CONSIDERADOS DOIS A DOIS"
	  NEG = 1
	  FLAG = 2: GOSUB IMPPADRAO
	  FLAG = 3: GOSUB IMPPADRAO: ' ** Limpa T$ **
	  NEG = 0
	  FLAG = 4: GOSUB IMPPADRAO: ' ** Traco de TABELA **
	  IF T = 1 THEN T$ = "EQUACAO : Y = A + B * X": FLAG = 2: GOSUB IMPPADRAO: 'I$
	  IF T = 2 THEN T$ = "EQUACAO : Y = A * X ^ B": FLAG = 2: GOSUB IMPPADRAO
	  T$ = "VARIAVEL DEPENDENTE : " + A$(IA)
	  FLAG = 2: GOSUB IMPPADRAO
	  FLAG = 4: GOSUB IMPPADRAO
	  L$(1) = "SERIE"
	  L$(2) = "VAR. IND."
	  L$(3) = "INTERSEC.": IF T = 2 THEN L$(3) = "COEF."
	  L$(4) = "DECLIVE": IF T = 2 THEN L$(4) = "EXPOENTE"
	  L$(5) = "CORRELACAO"
	  L$(6) = "ERRO PAD."
	  L$(7) = "PONTOS"
	  FLAG = 1: GOSUB IMPPADRAO: ' ** Imprime Titulos das COLUNAS **
	  FLAG = 4: GOSUB IMPPADRAO: ' ** Traco de TABELA **
	  ' ** Ciclo da Variavel Independente **
	  FOR IB = 1 TO NA
	    IF IB = IA THEN GOTO 4370
	    IP = 0
	    ' ** Ciclo sobre Valores **
	    FOR IQ = 1 TO NR
	      IF Q(IA, IQ) < 0 OR Q(IB, IQ) < 0 THEN GOTO 4270
	      IP = IP + 1
	      Y(IP) = FNFU(Q(IA, IQ))
	      X(IP) = FNFU(Q(IB, IQ))
4270        NEXT IQ
	    L$(2) = A$(IB): L$(7) = STR$(IP): L$(1) = STR$(IB)
	    IF IP < 3 THEN
			FOR K = 3 TO 6
			  L$(K) = "***"
			NEXT K
			FLAG = 1: GOSUB IMPPADRAO
			GOTO 4370
		      END IF
	    ' ** Regressao Linear **
	    LOCATE 14, 32: PRINT "REGRESSAO LINEAR"
	    GOSUB 15000
	    IF TESERRO = 1 THEN TESERRO = 0: T$ = "*** " + L$(2) + MENSERRO$: GOSUB 21160: GOTO 4370
	    Z = FNFV(A): GOSUB ARREDO
	    L$(3) = Z$
	    Z = B: GOSUB ARREDO
	    L$(4) = Z$
	    Z = R2: GOSUB ARREDO
	    L$(5) = Z$
	    Z = EP: GOSUB ARREDO
	    L$(6) = Z$
	    FLAG = 1: GOSUB IMPPADRAO
4370      NEXT IB
	  FLAG = 4: GOSUB IMPPADRAO
	  FLAG = 3: GOSUB IMPPADRAO

	  ' ** Condicoes de Preenchimento de Falhas das Observacoes **
	  NM = 7: RM = .5
4540      APAGA = 0
	  GOSUB LIMPATELA
	  LOCATE 10, 1: PRINT CHR$(186); : LOCATE 10, 80: PRINT CHR$(186);
MENU3:    LOCATE 6, 21: PRINT "Condicoes de Preenchimento de Falhas"
	  LOCATE 9, 24: PRINT "  1. Amostra minima      ( "; NM; " )"; STRING$(10, " ")
	  LOCATE 11, 24: PRINT "  2. Correlacao minima   ( "; RM; " )"; STRING$(10, " ")
	  LOCATE 13, 24: PRINT "  3. Semente aleatoria   ( "; SM; " )"; STRING$(10, " ")
	  LOCATE 15, 52: PRINT CHR$(201); STRING$(24, 205); CHR$(187);
	  FOR LIMPA = 16 TO 22
	    LOCATE LIMPA, 52: PRINT CHR$(186);
	    LOCATE LIMPA, 77: PRINT CHR$(186);
	  NEXT LIMPA
	  LOCATE 23, 52: PRINT CHR$(200); STRING$(24, 205); CHR$(188);
	  HH = 0: CONTHELP = 16
	  FOR LIMPA = CONTHELP TO CONTHELP + 4
	    HH = HH + 1
	    LOCATE 16 + HH, 53
	    PRINT HELP$(LIMPA)
	  NEXT LIMPA: CONTHELP = 1
	  LOCATE 24, 46: PRINT CHR$(175); " OPCAO "; CHR$(174);
	  OUTROS = 1: TECLA$ = "2": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
AQUI10:   ZZ$ = INKEY$: IF ZZ$ = "" THEN GOTO AQUI10
	  IF ASC(MID$(ZZ$, 1, 1)) = 0 THEN
	   IF MID$(ZZ$, 2, 1) = "@" THEN
				  GOSUB LIMPATELA
				  LOCATE 24, 46: PRINT STRING$(21, 205);
				  LOCATE 10, 1: PRINT CHR$(204); STRING$(78, 205); CHR$(185);
				  APAGA = 1: GOTO 4750
				END IF
	  END IF
OP1:      IF ZZ$ = "1" THEN
		       LOCATE 9, 51: PRINT STRING$(20, " ")
		       LOCATE 9, 51: PRINT STRING$(10, "_"); " )"
		       CODIGO$ = "11450570951": GOSUB TRTR
		       NM = VAL(LETRA$)
		       GOTO MENU3
		     END IF
OP2:      IF ZZ$ = "2" THEN
		       LOCATE 11, 51: PRINT STRING$(20, " ")
		       LOCATE 11, 51: PRINT STRING$(10, "_"); " )"
		       CODIGO$ = "11450571151": GOSUB TRTR
		       RM = VAL(LETRA$)
		       GOTO MENU3
		     END IF
OP3:      IF ZZ$ = "3" THEN
		       LOCATE 13, 51: PRINT STRING$(20, " ")
		       LOCATE 13, 51: PRINT STRING$(10, "_"); " )"
		       CODIGO$ = "11450571351": GOSUB TRTR
		       SM = VAL(LETRA$)
		       GOTO MENU3
		     END IF
	  BEEP: GOTO AQUI10

4750      OUTROS = 0: TECLA$ = "": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
	  NG = 1
	  LOCATE 6, 31: PRINT "PREENCHENDO FALHAS"
	  GOSUB PREENCHE
	  ON NG GOTO 4950, 4540
	  GOSUB GRAVACAO
4950    NEXT IA
VAI2:   IF GRAVA = 0 THEN
		       FOR BUF = 1 TO 250
			 IF BUFFER$(BUF) <> " " THEN GOSUB GRARELAT: GOSUB LIMPATELA: GOTO MENU1
		       NEXT BUF
		     END IF
	GOSUB LIMPATELA: GOTO MENU1

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                         ARREDONDAMENTO                              '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ARREDO: Z = Z * 1000
	Z = Z + .5
	Z = INT(Z)
	Z = Z / 1000
	Z$ = STR$(Z)
	RETURN

15000   '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                     REGRESSAO LINEAR                                '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
15023   J = 0: K = 0: L = 0: M = 0: R2 = 0: N = IP
	FOR I = 1 TO N
	  J = J + X(I)
	  K = K + Y(I)
	  L = L + X(I) ^ 2
	  M = M + Y(I) ^ 2
	  R2 = R2 + X(I) * Y(I)
	NEXT I
	B = (N * R2 - K * J) / (N * L - J ^ 2)
	BB(IB) = B
	A = (K - B * J) / N
	AA(IB) = A
	J = B * (R2 - J * K / N)
	M = M - K ^ 2 / N
	R2 = J / M
	EP = (1 - R2) * M / (N - 2)
	R2 = SQR(R2): EP = SQR(EP)
	RR(IB) = R2: EE(IB) = EP: NN(IB) = N
	RETURN

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                         INIT IMPRESSAO                              '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
IMPINIT: IF FLAG = 8 THEN FLAG = 0: TT$ = " ": GOTO 20121
	IF FLAG = 9 THEN FLAG = 0: TT$ = "!": GOTO 20121
	IF FLAG = 7 THEN FLAG = 0: Z$ = "+": GOSUB 20120: GOTO 20121
	IF FLAG = 6 THEN FLAG = 0: Z$ = "-": GOSUB 20120: GOTO 20121

	'** Colunas de igual tamanho **
	FOR K = 1 TO NC
	  TC(K) = INT(79 / NC) - 1
	NEXT K
	GOTO 20121

	'** Traco de tabela **
20120   TR$ = Z$
	FOR I = 1 TO NC
	  FOR J = 1 TO TC(I)
	    TR$ = TR$ + "-"
	  NEXT J
	  TR$ = TR$ + Z$
	NEXT I
20121   RETURN

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                      IMPRESSAO PADRAO                               '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
IMPPADRAO: IF FLAG = 2 THEN GOSUB MEIATELA: FLAG = 0: GOTO 21160
	IF FLAG = 3 THEN FLAG = 0: T$ = " ": GOTO 21160
	IF FLAG = 4 THEN FLAG = 0: T$ = TR$: GOTO 21160
	T$ = TT$
	IF FLAG = 1 THEN FLAG = 0: GOTO 21090
21090   FOR K = 1 TO NC
	  IF LEN(L$(K)) > TC(K) THEN L$(K) = LEFT$(L$(K), TC(K))
	  IF LEN(L$(K)) < TC(K) AND K = 1 THEN L$(K) = L$(K) + LEFT$(BC$, TC(K) - LEN(L$(K))): GOTO 21130
	  IF LEN(L$(K)) < TC(K) AND K <> 1 THEN L$(K) = LEFT$(BC$, TC(K) - LEN(L$(K))) + L$(K)
21130     T$ = T$ + L$(K) + TT$
	  L$(K) = " "
	NEXT K
21160   ERG = 100: IF GRAVA = 0 THEN BUF = BUF + 1: BUFFER$(BUF) = T$
	IF BUF = 250 THEN GOSUB GRARELAT
	IF IMPRESSAO = 1 THEN T$ = " ": ERG = 0: RETURN
'       IF NEG = 0 THEN LPRINT T$ ELSE GOSUB NEGRITO "foi anulada para evitar impressao
	IF TESERRO = 1 THEN TESERRO = 0: GOSUB LIMPALINHA: GOTO 21160
	T$ = " ": ERG = 0
	RETURN

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                            EDICAO                                   '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
MENU2:  GOSUB LIMPATELA
	LOCATE 4, 5: PRINT I$
	LOCATE 5, 5: PRINT "A : alterar nome do arquivo corrente"
	LOCATE 6, 5: PRINT "C : carregar arquivos pre-gravados"
	LOCATE 7, 5: PRINT "D : eliminar arquivo corrente"
	LOCATE 8, 5: PRINT "G : salvar nome dos arquivos"
	LOCATE 9, 5: PRINT "I : pre-insercao de arquivo"
	LOCATE 5, 45: PRINT "J : pos-insercao de arquivo"
	LOCATE 6, 45: PRINT "K : remover arquivo do disco"
	LOCATE 7, 45: PRINT "+ : proximo arquivo"
	LOCATE 8, 45: PRINT "- : retornar arquivo"
	LOCATE 9, 45: PRINT "T : trocar extensao do arquivo"
	P = 0
	LOCATE 12, 5
26140   IF P > N THEN P = 1
	IF P < 1 THEN P = N
	LN = CSRLIN
26166   IF LN > 19 THEN LN = 12
AQUI3: OUTROS = 0: TECLA$ = "1234": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
      LOCATE 2, 58: PRINT MUD$; A$; STRING$(13 - LEN(A$), 32)
      OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI3
      IF ASC(MID$(OP$, 1, 1)) = 0 THEN
       IF MID$(OP$, 2, 1) = ";" THEN GOSUB AJUDA: GOTO AQUI3
       IF MID$(OP$, 2, 1) = "<" THEN GOSUB DIRETORIO: GOTO MENU2
       IF MID$(OP$, 2, 1) = "=" THEN
			      IF MUD$ = "A:\" THEN MUD$ = "B:\": GOTO AQUI3
			      IF MUD$ = "B:\" THEN MUD$ = "C:\": GOTO AQUI3
			      IF MUD$ = "C:\" THEN MUD$ = "A:\": GOTO AQUI3
			    END IF
       IF MID$(OP$, 2, 1) = ">" THEN RETURN
      END IF
	IF OP$ = "P" OR OP$ = "p" THEN
			      P = P + 1
			      IF P > N THEN P = 1
			      GOTO IMPRIME
	END IF
	IF OP$ = "A" OR OP$ = "a" THEN GOSUB ALTERA: GOTO IMPRIME
	IF OP$ = "R" OR OP$ = "r" THEN
				P = P - 1
				IF P < 1 THEN P = N
				GOTO IMPRIME
	END IF
	IF OP$ = "I" OR OP$ = "i" THEN GOSUB INSERE: GOTO IMPRIME
	IF OP$ = "D" OR OP$ = "d" THEN GOSUB DELETA: GOTO IMPRIME
	IF OP$ = "J" OR OP$ = "j" THEN GOSUB JUSTAPOS: GOTO IMPRIME
	IF OP$ = "G" OR OP$ = "g" THEN GOSUB SALVA: LOCATE 2, 58: PRINT MUD$; A$; STRING$(13 - LEN(A$), 32): GOTO IMPRIME
	IF OP$ = "C" OR OP$ = "c" THEN GOSUB RECUPERA: LOCATE 2, 58: PRINT MUD$; A$; STRING$(13 - LEN(A$), 32): GOTO IMPRIME
	IF OP$ = "K" OR OP$ = "k" THEN GOSUB REMOVE: GOTO IMPRIME
	IF OP$ = "T" OR OP$ = "t" THEN GOSUB TROCA: GOTO IMPRIME
	BEEP

IMPRIME:  IF P = 0 THEN P = 1
	  INICIO = P
	  FIM = N
	  FOR TELA = 1 TO 8
	    IF LN = 12 THEN LOCATE LN, 3: PRINT "Í ";
	    LOCATE LN, 5
	    TELA$(TELA) = ""
	    TELA$(TELA) = V$(INICIO)
	    NUM$ = STRING$(5 - LEN(STR$(INICIO)), "0") + RIGHT$(STR$(INICIO), LEN(STR$(INICIO)) - 1)
	    PRINT " # "; NUM$; " : "; TELA$(TELA); STRING$(20, " ")
	    INICIO = INICIO + 1
	    IF INICIO > FIM THEN INICIO = 1
	    LN = LN + 1
	  NEXT TELA
26250   GOTO 26140

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'              ALTERA UM VALOR DE CADA VEZ                            '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ALTERA: IF P < 1 OR N < 1 THEN BEEP: RETURN
	LOCATE 22, 15: PRINT "Qual o novo dado #"; P
	LOCATE 22, 40: PRINT STRING$(12, "_")
	CODIGO$ = "13321222240": GOSUB TRTR
	AUX$ = LETRA$
	IF AUX$ = "" THEN GOSUB CANCELA: GOTO PERG1
	V$(P) = AUX$
PERG1:  GOSUB LIMPALINHA
	LOCATE LN, 5
	RETURN

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                INSERE UM VALOR DE CADA VEZ                          '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
INSERE: IF P < 1 THEN P = 1
	IF N = 1000 THEN BEEP: RETURN
	'****** IF P > N THEN BEEP:RETURN ******
	FOR J = N TO P STEP -1
	  V$(J + 1) = V$(J)
	NEXT J
	N = N + 1
	LOCATE 22, 10: PRINT "Qual o dado a inserir #"; P
	LOCATE 22, 40: PRINT STRING$(12, "_")
	CODIGO$ = "13321222240": GOSUB TRTR
	V$(P) = LETRA$
	GOSUB LIMPALINHA
	IF V$(P) <> "" THEN P = P + 1: GOTO INSERE
	IF V$(P) = "" THEN
		      FOR K = P TO N - 1
			V$(K) = V$(K + 1)
		      NEXT K
		      N = N - 1
		    END IF
	LOCATE LN, 5
	RETURN

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                   DELETA UM VALOR DE CADA VEZ                       '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
DELETA: IF N < 1 OR P < 1 THEN BEEP: RETURN
	IF N = 1 THEN V$(P) = "": P = P - 1: RETURN
	FOR I = P TO N - 1
	  V$(I) = V$(I + 1)
	NEXT I
	N = N - 1
	P = P - 1
	RETURN

     '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '                     TROCA EXTENSAO                                      '
     '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
TROCA:    LOCATE 22, 10: PRINT "Qual a extensao a ser trocada "; STRING$(12, "_")
	  CODIGO$ = "13321222240": GOSUB TRTR
	  AUX$ = LETRA$
	  GOSUB LIMPALINHA
	  IF AUX$ = "" THEN GOSUB CANCELA: RETURN
	  TESTE = LEN(AUX$)
	  LOCATE 22, 19: PRINT "Qual a nova extensao "; STRING$(12, "_")
	  CODIGO$ = "13321222240": GOSUB TRTR
	  AUX1$ = LETRA$
	  GOSUB LIMPALINHA
	  FOR K = 1 TO N
	    IF AUX$ = RIGHT$(V$(K), TESTE) THEN V$(K) = LEFT$(V$(K), LEN(V$(K)) - TESTE) + AUX1$
	  NEXT K
	  RETURN

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                  JUSTAPOSICAO DE VALORES                            '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
JUSTAPOS: IF N = 1000 THEN BEEP: RETURN
	  '****** IF P > N THEN BEEP:RETURN ******
	  FOR J = N TO P STEP -1
	    V$(J + 1) = V$(J)
	  NEXT J
	  N = N + 1
	  P = P + 1
	  LOCATE 22, 10: PRINT "Qual o dado a inserir #"; P
	  LOCATE 22, 40: PRINT STRING$(12, "_")
	  CODIGO$ = "13321222240": GOSUB TRTR
	  V$(P) = LETRA$
	  GOSUB LIMPALINHA
	  IF V$(P) <> "" THEN GOTO JUSTAPOS
	  IF V$(P) = "" THEN
			FOR K = P TO N - 1
			  V$(K) = V$(K + 1)
			NEXT K
			N = N - 1
			P = P - 1
		      END IF
	  LOCATE LN, 5
	  RETURN

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                   GRAVA MATRIZ                                      '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SALVA:  LOCATE 22, 15: PRINT "Qual o nome do arquivo "; STRING$(12, "_")
	CODIGO$ = "13321222238": GOSUB TRTR
	AUX$ = LETRA$
	IF AUX$ = "" THEN AUX$ = A$
	IF AUX$ = "SEM NOME" THEN GOSUB CANCELA: GOTO 26800
	YYY$ = AUX$: GOSUB VALIDADE: AUX$ = YYY$: IF ERG = 101 THEN GOSUB ERGS: GOTO SALVA
	GOSUB TESTDRIVE: IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: GOTO 26800
	GOSUB LIMPALINHA: LOCATE 12, 5
	LOCATE 22, 15: PRINT "SALVANDO ARQUIVO !!"
	ARQUIVO$ = MUD$ + AUX$
	OPEN ARQUIVO$ FOR OUTPUT AS #1
	IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: CLOSE #1: GOTO 26800
	PRINT #1, N, 1
	FOR I = 1 TO N
	  PRINT #1, V$(I)
	NEXT I
	CLOSE #1
	IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: GOTO 26800
	A$ = AUX$
	LOCATE 22, 15: PRINT "ARQUIVO SALVO !!   "
	GOSUB TEMPO
26800   GOSUB MEIATELA: LOCATE 12, 5
	RETURN

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                      CARREGA MATRIZ                                 '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
RECUPERA: LOCATE 22, 15: PRINT "Qual o nome do arquivo "; STRING$(12, "_")
	  CODIGO$ = "13321222238": GOSUB TRTR
	  AUX$ = LETRA$
	  IF AUX$ = "" THEN AUX$ = A$
	  IF AUX$ = "SEM NOME" THEN GOSUB CANCELA: GOTO 27500
	  YYY$ = AUX$: GOSUB VALIDADE: AUX$ = YYY$: IF ERG = 101 THEN GOSUB ERGS: GOTO RECUPERA
	  GOSUB TESTDRIVE: IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: GOTO 27500
	  GOSUB LIMPALINHA: LOCATE 12, 5
	  LOCATE 22, 15: PRINT "CARREGANDO ARQUIVO !!"
	  ARQUIVO$ = MUD$ + AUX$
27000     OPEN ARQUIVO$ FOR INPUT AS #1
	  IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: CLOSE #1: GOTO 27500
	  INPUT #1, N, Z
	  FOR I = 1 TO N
	    INPUT #1, V$(I)
	  NEXT I
	  CLOSE #1
	  A$ = AUX$
	  P = 1
	  LOCATE 22, 15: PRINT "ARQUIVO CARREGADO !! "
	  GOSUB TEMPO
27500     GOSUB MEIATELA: LOCATE 12, 5
	  RETURN

     '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '                    REMOVE  MATRIZ                                       '
     '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
REMOVE: LOCATE 22, 15: PRINT "Qual o nome do arquivo "; STRING$(12, "_")
       CODIGO$ = "13321222238": GOSUB TRTR
       AUX$ = LETRA$
       IF AUX$ = "" THEN GOSUB CANCELA: GOTO 26860
       IF AUX$ = "SEM NOME" THEN GOSUB CANCELA: GOTO 26860
       YYY$ = AUX$: GOSUB VALIDADE: AUX$ = YYY$: IF ERG = 101 THEN GOSUB ERGS: GOTO REMOVE
       GOSUB TESTDRIVE: IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: GOTO 26860
       GOSUB LIMPALINHA: LOCATE 12, 5
       LOCATE 22, 15: PRINT "REMOVENDO ARQUIVO !!"
       ARQUIVO$ = MUD$ + AUX$
       KILL ARQUIVO$
       IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: CLOSE #1: GOTO 26860
       LOCATE 22, 15: PRINT "ARQUIVO REMOVIDO !! "
       GOSUB TEMPO
26860  GOSUB MEIATELA: LOCATE 12, 5
       RETURN

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                     PREENCHIMENTO DAS FALHAS                        '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PREENCHE: NC = 5: GOSUB IMPINIT
	FLAG = 6: GOSUB IMPINIT
	FLAG = 8: GOSUB IMPINIT
	T$ = "RESULTADO DO PREENCHIMENTO DE FALHAS": NEG = 1: FLAG = 2: GOSUB IMPPADRAO
	FLAG = 3: GOSUB IMPPADRAO: NEG = 0: FLAG = 4: GOSUB IMPPADRAO
	L$(1) = "ORDEM": L$(2) = "INFORMACAO": L$(3) = "SERIE"
	L$(4) = "RUIDO": L$(5) = "RESULTADO": FLAG = 1: GOSUB IMPPADRAO
	FLAG = 4: GOSUB IMPPADRAO
	LP = 0
30015   RX = 0
	' ** Ciclo sobre ARQUIVOS **
	FOR I = 1 TO NA
	  IF RR(I) < RX OR I = IA THEN GOTO 30040
	  IX = I: RX = RR(I)
30040   NEXT I
	IF RX < RM THEN GOTO 30500
	LP = 1
	RR(IX) = -RR(IX)
	IF NN(IX) < NM THEN GOTO 30015
	' ** Geracao de Observacao para a Falha **
	FOR I = 1 TO NR
	  IF Q(IA, I) = -999 AND Q(IX, I) >= 0 THEN GOSUB 50000
	NEXT I
	GOTO 30015
	RETURN
30500   IF LP = 0 THEN GOTO 31000
	IF NG > 0 THEN
		    T$ = "NAO FOI POSSIVEL O PREENCHIMENTO DE FALHAS": NEG = 1: FLAG = 2: GOSUB IMPPADRAO
		    FLAG = 3: GOSUB IMPPADRAO: NEG = 0: FLAG = 4: GOSUB IMPPADRAO
		    LOCATE 14, 26: PRINT "Nao foi possivel preencher."
		    GOTO 30520
		  END IF
	FLAG = 4: GOSUB IMPPADRAO: FLAG = 3: GOSUB IMPPADRAO
	LOCATE 14, 28: PRINT "Preenchimento encerrado."
30520   LOCATE 24, 46: PRINT CHR$(175); " Tecle << ENTER >> "; CHR$(174);
	OP$ = INKEY$: IF OP$ = "" THEN GOTO 30520
	IF ASC(OP$) <> 13 THEN BEEP: GOTO 30520
	LOCATE 24, 46: PRINT STRING$(21, 205);
	GOSUB LIMPATELA: RETURN
31000   LOCATE 14, 19: PRINT "Nao existe possibilidade de preenchimento."
	LOCATE 16, 23: PRINT "Deseja alterar condicoes (S/N) ?"
	LOCATE 24, 46: PRINT CHR$(175); " OPCAO "; CHR$(174);
AQUI8:  S$ = INKEY$: IF S$ = "" THEN GOTO AQUI8
	IF S$ = "N" OR S$ = "n" THEN
				  NG = 1
				  T$ = "NAO FOI POSSIVEL O PREENCHIMENTO DE FALHAS": NEG = 1: FLAG = 2: GOSUB IMPPADRAO
				  FLAG = 3: GOSUB IMPPADRAO: NEG = 0: FLAG = 4: GOSUB IMPPADRAO
				  GOSUB LIMPATELA: RETURN: REM OUTRO POSTO
				END IF
	IF S$ = "S" OR S$ = "s" THEN
				NG = 2
				FOR I = 1 TO NA
				  RR(I) = ABS(RR(I))
				NEXT I
				REM ALTERA CONDICOES
				RETURN
			      END IF
	BEEP: GOTO AQUI8

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                         GRAVACAO                                    '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
GRAVACAO: GOSUB LIMPATELA
	LIMPA = (80 - (25 + LEN(A$(IA)))) / 2
	LOCATE 5, LIMPA: PRINT "A matriz "; A$(IA); " sera regravada."
	LOCATE 7, 27: PRINT "Confirma operacao (S/N) ?"
	LOCATE 24, 46: PRINT CHR$(175); " OPCAO "; CHR$(174);
AQUI9:  OUTROS = 0: TECLA$ = "3": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
	LOCATE 2, 58: PRINT MUD$; A$; STRING$(13 - LEN(A$), 32)
	OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI9
	IF ASC(MID$(OP$, 1, 1)) = 0 THEN
	  IF MID$(OP$, 2, 1) = "=" THEN
				 IF MUD$ = "A:\" THEN MUD$ = "B:\": GOTO AQUI9
				 IF MUD$ = "B:\" THEN MUD$ = "C:\": GOTO AQUI9
				 IF MUD$ = "C:\" THEN MUD$ = "A:\": GOTO AQUI9
			       END IF
	  END IF
	IF OP$ = "S" OR OP$ = "s" THEN GOTO 40500
	IF OP$ = "N" OR OP$ = "n" THEN GOTO 40550
	BEEP: GOTO AQUI9
40500   LIMPA = (80 - (18 + LEN(A$(IA)))) / 2
	LOCATE 16, LIMPA: PRINT "Gravando arquivo "; A$(IA)
	ARQUIVO$ = MUD$ + A$(IA)
	GOSUB TESTDRIVE: IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: GOSUB MEIATELA: GOTO AQUI9
	OPEN ARQUIVO$ FOR OUTPUT AS #1
	IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: CLOSE #1: GOTO GRAVACAO
	PRINT #1, NR, 1
	FOR I = 1 TO NR
	  PRINT #1, Q(IA, I)
	NEXT I
	CLOSE #1
	IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: GOTO GRAVACAO
40550   OUTROS = 0: TECLA$ = "": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
	GOSUB LIMPATELA
	RETURN

50000   '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                      GERACAO DE OBSERVACAO                          '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	' ** Formula de Geracao de Valores Normais de BOX e MULLER **
	IF SM = -999 THEN U1 = 0: GOTO 50600
	IF KI = 0 GOTO 50500
	KI = 0: SM = RND(SM): S1 = SM: SM = RND(SM): S2 = SM
	U1 = SQR(-2 * LOG(S1)) * COS(2 * 3.141694 * S2)
	GOTO 50600
50500   U1 = SQR(-2 * LOG(S1)) * SIN(2 * 3.141694 * S2)
	KI = 1
50600   QX = FNFU(Q(IX, I))
	Q(IA, I) = AA(IX) + BB(IX) * QX + U1 * EE(IX): Q(IA, I) = FNFV(Q(IA, I))
	IF Q(IA, I) < 0 THEN Q(IA, I) = .000001
	Z = I: GOSUB ARREDO: L$(1) = Z$
	Z = Q(IX, I): GOSUB ARREDO: L$(2) = Z$
	Z = IX: GOSUB ARREDO: L$(3) = Z$
	Z = U1: GOSUB ARREDO: L$(4) = Z$
	Z = Q(IA, I): GOSUB ARREDO: L$(5) = Z$
	FLAG = 1: GOSUB IMPPADRAO
	Q(IA, I) = -Q(IA, I): NG = 0
	RETURN

     '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '                         DIRETORIO                                       '
     '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
DIRETORIO: GOSUB LIMPATELA
       OUTROS = 0: TECLA$ = "4": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
       LOCATE 4, 35: PRINT "DIRETORIO"
DRIVE: LOCATE 6, 30: PRINT "DRIVE ( A / B / C ) "
       DRIVE$ = INKEY$: IF DRIVE$ = "" THEN GOTO DRIVE
       IF ASC(MID$(DRIVE$, 1, 1)) = 0 THEN
				      IF MID$(DRIVE$, 2, 1) = ">" THEN
								GOSUB LIMPATELA
								RETURN
							      END IF
				    END IF
       IF DRIVE$ = "A" OR DRIVE$ = "a" THEN GOSUB BARRA: FILES "A:": GOTO VOLTA
       IF (DRIVE$ = "B" OR DRIVE$ = "b") THEN
	      DEF SEG = 0
	      IF INT(PEEK(&H410) / 64) = 1 THEN
		  GOSUB BARRA: FILES "B:": DEF SEG : GOTO VOLTA
		 ELSE
		  ERROR 76: IF TESERRO = 1 THEN TESERRO = 0: GOSUB LIMPALINHA
		  DEF SEG : GOTO DRIVE
	      END IF
       END IF
       IF DRIVE$ = "C" OR DRIVE$ = "c" THEN GOSUB BARRA: FILES "C:": GOTO VOLTA
       BEEP: LOCATE 6, 50: PRINT "                  "
       GOTO DRIVE
BARRA: CLS
       LOCATE 1, 30: PRINT "ARQUIVOS DO DRIVE "; DRIVE$
       LOCATE 3, 1
       GOSUB VALIDO
       RETURN
VOLTA: OP$ = INKEY$: IF OP$ = "" THEN GOTO VOLTA
       IF ASC(MID$(OP$, 1, 1)) = 0 THEN
	 IF MID$(OP$, 2, 1) = ">" THEN
				CLS : TESERRO = 0
				GOSUB DESENTELA
				LOCATE 10, 1: PRINT CHR$(204); STRING$(78, 205); CHR$(185);
				GOSUB VALIDO
				LOCATE 24, 46: PRINT CHR$(175); " OPCAO "; CHR$(174);
				RETURN
			      END IF
       END IF
       BEEP: GOTO VOLTA

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                            LIMPA TELA                               '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
LIMPATELA: FOR LIMPA = 4 TO 23
	     IF LIMPA = 10 THEN IF APAGA = 1 THEN GOTO PULALIMPA
	     LOCATE LIMPA, 2
	     PRINT STRING$(78, " ");
	     'IF LIMPA=10 THEN LOCATE 10,1:PRINT CHR$(186);STRING$(78," ");CHR$(186);
PULALIMPA: NEXT LIMPA
	   RETURN

MEIATELA: FOR LIMPA = 11 TO 23
	    LOCATE LIMPA, 2
	    PRINT STRING$(78, " ");
	  NEXT LIMPA
	  RETURN

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                   LIMPA LINHA 22                                    '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
LIMPALINHA: LOCATE 22, 2: PRINT STRING$(78, " ")
	    RETURN

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                    ROTINAS AUXILIARES                               '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
DESENTELA: PRINT CHR$(201); STRING$(78, 205); CHR$(187);
	   FOR I = 2 TO 23: LOCATE I, 1: PRINT CHR$(186); : LOCATE I, 80: PRINT CHR$(186): NEXT I
	   PRINT CHR$(200); STRING$(78, 205); CHR$(188);
	   LOCATE 2, 22 - VEZ * 19: IF VEZ = 1 THEN PRINT "SISTEMA DE REGIONALIZACAO HIDROLOGICA VRS. 1.0 "
	   IF VEZ = 0 THEN PRINT "SISTEMA DE REGIONALIZACAO HIDROLOGICA "
	   LOCATE 3, 1: PRINT CHR$(204); STRING$(78, 205); CHR$(185);
	   IF VEZ = 1 THEN
			LOCATE 1, 50: PRINT CHR$(203)
			LOCATE 2, 50: PRINT CHR$(186)
			LOCATE 3, 50: PRINT CHR$(202)
			DEF SEG = &HB800
			FOR I = 163 TO 257 STEP 2
			  POKE I, &H13
			NEXT I
			DEF SEG
			LOCATE 2, 58: PRINT MUD$; A$; STRING$(13 - LEN(A$), 32)
		      END IF
	   VEZ = 1
	   RETURN

CANCELA:   GOSUB LIMPALINHA
	   LOCATE 22, 31
	   PRINT "OPERACAO CANCELADA"
	   GOSUB TEMPO
	   GOSUB LIMPALINHA
	   RETURN

TEMPO:     FOR TESTE = 1 TO 8000: NEXT TESTE: RETURN

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                  TRATAMENTO DE ERROS                                '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ERGS:      SOM = 0
	   GOSUB LIMPALINHA
	   IF ERG = 101 THEN LOCATE 22, 28: PRINT "NOME DO ARQUIVO INVALIDO": SOM = 1
	   IF SOM = 1 THEN BEEP: GOSUB TEMPO
	   ERG = 0
	   GOSUB LIMPALINHA
	   RETURN

ERROS:     TESERRO = 1: SOM = 0
	   GOSUB LIMPALINHA
	   IF ERR = 11 THEN MENSERRO$ = " NAO HOUVE CORRELACAO ***"
	   IF ERR = 52 THEN LOCATE 22, 26: PRINT "ERRO DE ABERTURA DO ARQUIVO": SOM = 1
	   IF ERR = 53 THEN LOCATE 22, 31: PRINT "ARQUIVO NAO EXISTE": SOM = 1
	   IF ERR = 61 THEN LOCATE 22, 34: PRINT "DISCO CHEIO": SOM = 1
	   IF ERR = 64 THEN LOCATE 22, 28: PRINT "NOME DO ARQUIVO INVALIDO": SOM = 1
	   IF ERR = 67 THEN LOCATE 22, 28: PRINT "MUITOS ARQUIVOS NO DISCO": SOM = 1
	   IF ERR = 68 THEN LOCATE 22, 32: PRINT "DRIVE NAO EXISTE": SOM = 1
	   IF ERR = 70 THEN LOCATE 22, 32: PRINT "DISCO PROTEGIDO": SOM = 1
	   IF ERR = 71 THEN LOCATE 22, 34: PRINT "DRIVE ABERTO": SOM = 1
	   IF ERR = 76 THEN LOCATE 22, 32: PRINT "DRIVE NAO EXISTE": SOM = 1
	   IF ERG = 100 THEN LOCATE 22, 30: PRINT "IMPRESSORA DESLIGADA": SOM = 1
'           LOCATE 23,16:PRINT ERR;
	   IF SOM = 0 THEN TESERRO = 1
	   IF SOM = 1 THEN BEEP: GOSUB TEMPO
	   RESUME NEXT

     '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '                        TECLAS VALIDAS                                   '
     '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
VALIDO: TECLAVAL$ = "12345"
	KK = 1: JJ = 1
	ATX = &H10
	IF OUTROS = 0 THEN
	LINHA$ = "    _F1  Ajuda   _F2  Diretorio   _F3  Drive   _F4  Encerrar   _F5  Outros             "
	END IF
	IF OUTROS = 1 THEN
	LINHA$ = "    _F5  Outros   _F6  Executar   _F7  Impressao   _F8  Gravar Relatorio                "
	END IF
	DEF SEG = &HB800
	FOR II = &HF00 TO &HF00 + 160 STEP 2
	  JJ = JJ + 1
	  IF MID$(LINHA$, JJ, 1) = "_" THEN
	   IF INSTR(TECLA$, MID$(TECLAVAL$, KK, 1)) <> 0 THEN ATX = &H13 ELSE ATX = &H10
	   KK = KK + 1
	   JJ = JJ + 1
	  END IF
	  POKE II + 1, ATX
	  POKE II, ASC(MID$(LINHA$, JJ, 1))
	NEXT II
	DEF SEG
	TECLAANT$ = TECLA$
	RETURN

     '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '                        MENSAGENS DE AJUDA                               '
     '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
AJUDA: IF CONTHELP > 25 THEN CONTHELP = 1
       LOCATE 24, 46: PRINT STRING$(21, 205);
       OUTROS = 0: TECLA$ = "4": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
       LOCATE 12, 52
       PRINT CHR$(201); STRING$(24, 205); CHR$(187);
       FOR LIMPA = 13 TO 19
	LOCATE LIMPA, 52: PRINT CHR$(186);
	LOCATE LIMPA, 77: PRINT CHR$(186);
       NEXT LIMPA
       LOCATE 20, 52
       PRINT CHR$(200); STRING$(2, 205); CHR$(175); " Tecle << ENTER >> "; CHR$(174); STRING$(1, 205); CHR$(188);
       HH = 0
       FOR LIMPA = CONTHELP TO CONTHELP + 4
	 HH = HH + 1
	 LOCATE 13 + HH, 53
	 PRINT HELP$(LIMPA)
       NEXT LIMPA
       CONTHELP = CONTHELP + 5
PERG:  OP$ = INKEY$: IF OP$ = "" THEN GOTO PERG
       IF ASC(MID$(OP$, 1, 1)) = 0 THEN
	 IF MID$(OP$, 2, 1) = ">" THEN GOSUB MEIATELA: RETURN
       END IF
       IF ASC(OP$) <> 13 THEN BEEP: GOTO PERG
       GOTO AJUDA

VALIDADE: IF YYY$ = "SEM NOME" THEN GOTO XXX
	  FOR QQ = 1 TO LEN(YYY$)
	    IF MID$(YYY$, QQ, 1) = "." THEN
				       IF QQ = 1 THEN ERG = 101: GOTO XXX
				       IF QQ > 9 THEN ERG = 101: GOTO XXX
				       DDD = LEN(YYY$) - QQ
				       IF DDD = 0 THEN YYY$ = YYY$ + "REG"
				       IF DDD > 3 THEN YYY$ = YYY$ + MID$(YYY$, QQ, 3)
				       GOTO XXX
				     END IF
	    IF QQ = LEN(YYY$) THEN IF QQ < 9 THEN YYY$ = YYY$ + ".REG"
	    IF QQ = LEN(YYY$) THEN IF QQ >= 9 THEN YYY$ = MID$(YYY$, 1, 8) + "." + MID$(YYY$, 9, 3)
	  NEXT QQ
XXX:      RETURN

NEGRITO: 'PARA IMPRESSAO AGORA BLOQUEADA

'         LPRINT CHR$(27);"@";
'        LPRINT CHR$(27);"E";
'        LPRINT T$
'        LPRINT CHR$(27);"@";
	 RETURN

    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    '                   ENTRADA DE DADOS VIA TECLADO                          '
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
TRTR: PP = VAL(MID$(CODIGO$, 1, 2)): 'sempre um a mais do numero de caracteres desejado
      AA = VAL(MID$(CODIGO$, 3, 2)): 'codigo ASC menor
      BB = VAL(MID$(CODIGO$, 5, 3)): 'codigo ASC maior
      YY = VAL(MID$(CODIGO$, 8, 2)): 'linha do locate
      XX = VAL(MID$(CODIGO$, 10, 2)): 'coluna do locate
      LETRA$ = ""
      FOR FF = 1 TO PP
AQUI30: OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI30
	IF ASC(OP$) = 13 THEN GOTO FIMA
	IF ASC(OP$) = 0 THEN
			IF MID$(OP$, 2, 1) = "K" THEN
						 IF LETRA$ = "" THEN GOTO AQUI30
						 LETRA$ = LEFT$(LETRA$, LEN(LETRA$) - 1)
						 FF = FF - 1
						 LOCATE YY, XX: PRINT STRING$(PP - 1, "_");
						 LOCATE YY, XX: PRINT LETRA$
						 GOTO AQUI30
					       END IF
		      END IF
	IF ASC(OP$) = 8 THEN
			IF LETRA$ = "" THEN GOTO AQUI30
			LETRA$ = LEFT$(LETRA$, LEN(LETRA$) - 1)
			FF = FF - 1
			LOCATE YY, XX: PRINT STRING$(PP - 1, "_");
			LOCATE YY, XX: PRINT LETRA$
			GOTO AQUI30
		      END IF
	IF FF = PP THEN IF ASC(OP$) <> 13 THEN BEEP: GOTO AQUI30
	IF ASC(OP$) < AA THEN BEEP: GOTO AQUI30
	IF ASC(OP$) > BB THEN BEEP: GOTO AQUI30
	LETRA$ = LETRA$ + OP$
	LOCATE YY, XX: PRINT LETRA$
      NEXT FF
FIMA: RETURN

TESTDRIVE: IF MUD$ = "B:\" THEN
	      DEF SEG = 0
	      IF INT(PEEK(&H410) / 64) = 1 THEN
		  DEF SEG : GOTO RETORNA
		 ELSE
		  ERROR 76: IF TESERRO = 1 THEN GOSUB LIMPALINHA
		  DEF SEG : GOTO RETORNA
	      END IF
	  END IF
RETORNA: RETURN

GRARELAT: ARQUIVO$ = MUD$ + ARQREL$
	  OPEN ARQUIVO$ FOR APPEND AS #1
	  IF TESERRO = 1 THEN
			   TESERRO = 0
			   GOSUB LIMPALINHA
			   LOCATE 15, 19
			   PRINT "Gravacao do relatorio no arquivo com erro."
			   LOCATE 24, 46: PRINT CHR$(175); " OPCAO "; CHR$(174);
			   LOCATE 17, 28
			   PRINT "Deseja continuar (S/N) ?"
AQUI101:                   OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI101
			   IF OP$ = "S" OR OP$ = "s" THEN
						   LOCATE 24, 46: PRINT STRING$(21, 205);
						   GOSUB MEIATELA
						   GOTO GRARELAT
						 END IF
			   IF OP$ = "N" OR OP$ = "n" THEN
						   LOCATE 24, 46: PRINT STRING$(21, 205);
						   GOSUB LIMPATELA: CLOSE #1
						   RETURN
						 END IF
			   BEEP: GOTO AQUI101
			 END IF
	  FOR BUF = 1 TO 250
	    IF BUFFER$(BUF) <> "" THEN PRINT #1, BUFFER$(BUF)
	  NEXT BUF
	  CLOSE #1
	  FOR BUF = 1 TO 250
	    BUFFER$(BUF) = ""
	  NEXT BUF
	  BUF = 0
	  RETURN

