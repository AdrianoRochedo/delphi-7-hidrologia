'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' PROGRAMA LE                                                                 '
' adaptada por Juan Santiago
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Parte 1: Inicializacao de variaveis e tela de apresentacao                  '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'TRON
     CLS
     ON ERROR GOTO ERROS
     DIM TEXTO$(15), TELA$(8), HELP$(20), BUFFER$(250)
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
     HELP$(16) = "     SOBRE OS ERROS     "
     HELP$(17) = "   Quando for  provocado"
     HELP$(18) = "um  erro  aparecera  na "
     HELP$(19) = "tela uma mensagem  sobre"
     HELP$(20) = "este erro.              "

     FOR TESTE = 0 TO 15
     TEXTO$(TESTE) = ""
     NEXT TESTE
     FOR TESTE = 0 TO 8
     TELA$(TESTE) = ""
     NEXT TESTE
     DIM V$(1000), A$(1000), FG(4)
     VEZ = 0
     APAGA = 0
     NEG = 0
     CONTHELP = 1
     FG(1) = 1
     GRAVA = 0

     GOSUB DESENTELA
     LOCATE 6, 23: PRINT "Instituto de Pesquisas Hidraulicas"
     LOCATE 8, 20: PRINT "Universidade Federal do Rio Grande do Sul"
     LOCATE 11, 11: PRINT "PROGRAMA PARA RELATORIOS, ADIMENSIONALIZACAO E ESTATISTICA"
     LOCATE 12, 27: PRINT "DE UMA SERIES DE VALORES"
     LOCATE 15, 30: PRINT "VERSAO 1.0  /  1990"
     LOCATE 18, 20: PRINT "Desenvolvido por: "
     LOCATE 19, 37: PRINT "Antonio Eduardo Leao Lanna"
     LOCATE 20, 37: PRINT "Luciano Nunes de Oliveira"
     LOCATE 24, 46: PRINT CHR$(175); " Tecle << ENTER >> "; CHR$(174);
AQUI1: OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI1
      IF ASC(OP$) <> 13 THEN BEEP: GOTO AQUI1
      LOCATE 24, 46: PRINT STRING$(21, 205);
      GOSUB LIMPATELA
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
' foi anulada a sentencia sequinte para nao imprimir
'      WIDTH "LPT1:", 132
      C$ = CHR$(27)
      BC$ = "                                        "

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                                  Final Parte 1                              '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Parte 2: Definicao dos recursos a serem utilizados                          '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

MENUP: ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
       '                       MENU PRINCIPAL                                 '
       ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     OUTROS = 0: TECLA$ = "12345": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
1040 LOCATE 5, 5: PRINT "1. ano inicial: "; CI
     LOCATE 6, 5: PRINT "2. numero de anos: "; TA
     LOCATE 7, 5: PRINT "3. editar estacoes"
     LOCATE 8, 5: PRINT "4. vazoes preenchidas ";
     IF FG(3) = 0 THEN GOSUB 1900
     PRINT "constam    ": LOCATE 9, 8: PRINT "do relatorio"
     LOCATE 5, 40: PRINT "5. ";
     IF FG(2) = 0 THEN GOSUB 1900
     PRINT "havera adimensionalizacao    "
     LOCATE 6, 40: PRINT "6. estatisticas ";
     IF FG(4) = 0 THEN GOSUB 1900
     PRINT "serao calculadas    "
     LOCATE 24, 46: PRINT CHR$(175); " OPCAO "; CHR$(174);
AQUI2: LOCATE 2, 58: PRINT MUD$; A$; STRING$(13 - LEN(A$), 32)
     OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI2
     IF ASC(MID$(OP$, 1, 1)) = 0 THEN
       IF MID$(OP$, 2, 1) = ";" THEN GOSUB AJUDA: GOTO MENUP
       IF MID$(OP$, 2, 1) = "<" THEN GOSUB DIRETORIO: GOTO MENUP
       IF MID$(OP$, 2, 1) = "=" THEN
			      IF MUD$ = "A:\" THEN MUD$ = "B:\": GOTO AQUI2
			      IF MUD$ = "B:\" THEN MUD$ = "C:\": GOTO AQUI2
			      IF MUD$ = "C:\" THEN MUD$ = "A:\": GOTO AQUI2
			    END IF
       IF MID$(OP$, 2, 1) = ">" THEN
			      GOSUB MEIATELA
			      LOCATE 12, 29
			      PRINT "Confirma opcao (S/N) ?"
AQUI0:                        OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI0
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
       IF MID$(OP$, 2, 1) = "@" THEN EXEC = EXEC + 1: TECLA$ = "": OUTROS = 0: GOSUB VALIDO: BUF = 0: GOTO 1400
       IF MID$(OP$, 2, 1) = "A" THEN
			      IF IMPRESSAO = 0 THEN
						 FG(1) = 0
						 IMPRESSAO = 1
						 IF OUTROS = 0 THEN OUTROS = 1
						 IF GRAVA = 0 THEN TECLA$ = "124"
						 IF GRAVA = 1 THEN TECLA$ = "12"
						 IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO: GOTO AQUI2
					       END IF
			      IF IMPRESSAO = 1 THEN
						 FG(1) = 1
						 IMPRESSAO = 0
						 IF OUTROS = 0 THEN OUTROS = 1
						 IF GRAVA = 0 THEN TECLA$ = "1234"
						 IF GRAVA = 1 THEN TECLA$ = "123"
						 IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO: GOTO AQUI2
					       END IF
			    END IF
	 IF MID$(OP$, 2, 1) = "B" THEN
			       IF GRAVA = 0 THEN
					      GRAVA = 1
					      IF OUTROS = 0 THEN OUTROS = 1
					      IF IMPRESSAO = 0 THEN TECLA$ = "123"
					      IF IMPRESSAO = 1 THEN TECLA$ = "12"
					      IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO: GOTO AQUI2
					    END IF
			       IF GRAVA = 1 THEN
					      GRAVA = 0
					      IF OUTROS = 0 THEN OUTROS = 1
					      IF IMPRESSAO = 0 THEN TECLA$ = "1234"
					      IF IMPRESSAO = 1 THEN TECLA$ = "124"
					      IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO: GOTO AQUI2
					    END IF
			     END IF
       END IF
     IF ASC(OP$) < 49 OR ASC(OP$) > 54 THEN BEEP: GOTO AQUI2
     IF OP$ = "1" THEN
OP1:                LOCATE 5, 22
		    PRINT STRING$(4, "_");
		    CODIGO$ = "05480570522": GOSUB TRTR
		    CI = VAL(LETRA$)
		    IF CI = 0 THEN LOCATE 5, 22: PRINT STRING$(4, " "): GOTO MENUP
		    IF (CI < 1500) OR (CI > 3000) THEN
						BEEP
						LOCATE 5, 22
						PRINT STRING$(4, "_");
						GOTO OP1
					      END IF
		    GOTO MENUP
		  END IF

     IF OP$ = "2" THEN
OP2:                LOCATE 6, 25
		    PRINT STRING$(4, "_");
		    CODIGO$ = "05480570625": GOSUB TRTR
		    TA = VAL(LETRA$)
		    IF TA < 100 THEN
				  LOCATE 6, 25: PRINT STRING$(4, " ")
				  LOCATE 6, 25: PRINT TA
				  GOTO MENUP
				END IF
		    IF TA > 1000 THEN
				   BEEP
				   LOCATE 6, 25
				   PRINT STRING$(4, "_");
				   GOTO OP2
				 END IF
		    GOTO MENUP
		  END IF
     IF OP$ = "4" THEN
		    IF FG(3) = 0 THEN FG(3) = 1: GOTO MENUP
		    IF FG(3) = 1 THEN FG(3) = 0: GOTO MENUP
		  END IF
     IF OP$ = "5" THEN
		    IF FG(2) = 0 THEN FG(2) = 1: GOTO MENUP
		    IF FG(2) = 1 THEN FG(2) = 0: GOTO MENUP
		  END IF
     IF OP$ = "6" THEN
		    IF FG(4) = 0 THEN FG(4) = 1: GOTO MENUP
		    IF FG(4) = 1 THEN FG(4) = 0: GOTO MENUP
		  END IF
     IF OP$ = "3" THEN
		  I$ = "** ESTACOES **"
		  FOR I = 1 TO NP
		    V$(I) = A$(I)
		  NEXT I
		  N = NP
		  GOSUB MENU2
		  FOR I = 1 TO N
		    A$(I) = V$(I)
		  NEXT I
		  NP = N
		  GOTO MENUP
		END IF

1400 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '                         DIMENSIONAMENTOS                               '
     ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
      IF EXEC > 1 THEN GOTO 1500
      DIM M(TA, NP)
      DIM MD(NP), DP(NP), SA(NP)
      DIM CA(NP)
      DIM TC(NP + 2), L(NP + 2), L$(NP + 2)
      DIM Z(NP)
      GOTO 2000
1500  REDIM M(TA, NP), MD(NP), DP(NP), SA(NP)
      REDIM CA(NP), TC(NP + 2), L(NP + 2), L$(NP + 2), Z(NP)
      GOTO 2000

1900 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '                         NAO                                            '
     ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     PRINT "NAO ";
     RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                                  Final Parte 2                              '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Parte 3: Execucao do programa                                               '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

2000 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '                         INICIO DO PROGRAMA                             '
     ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     IF GRAVA = 0 THEN
		     FG(1) = 1
VAI1:                 LOCATE 15, 6: PRINT "Qual o nome do arquivo em que sera gravado o relatorio "
		      LOCATE 15, 61: PRINT STRING$(12, "_")
		      CODIGO$ = "13321221561": GOSUB TRTR
		      AUX$ = LETRA$
		      IF AUX$ = "" THEN AUX$ = "SEM NOME"
		      IF AUX$ = "SEM NOME" THEN GOSUB CANCELA: LOCATE 15, 2: PRINT STRING$(78, " "); : GOTO MENUP
		      YYY$ = AUX$: GOSUB VALIDADE: AUX$ = YYY$: IF ERG = 101 THEN GOSUB ERGS: GOTO VAI1
		      ARQREL$ = AUX$
		      LOCATE 15, 2: PRINT STRING$(78, " ");
		  END IF

     GOSUB LEITARQ
     IF TESERRO = 1 THEN TESERRO = 0: GOSUB MEIATELA: GOTO MENUP
     IF FG(2) = 1 OR FG(4) = 1 THEN GOSUB CALCESTAT
     IF FG(1) = 1 THEN GOSUB RELAT
     IF FG(2) = 1 THEN
		    GOSUB ADIMENSIONA
		    IF TESERRO = 1 THEN TESERRO = 0: GOSUB LIMPATELA: GOTO MENUP
		    GOSUB CALCESTAT
		    IF FG(1) = 1 THEN GOSUB RELAT
		  END IF
     GOSUB LIMPATELA: GOTO MENUP

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                         RELATORIO                                           '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
RELAT: IF IMPRESSAO = 1 THEN IF GRAVA = 1 THEN RETURN
     LOCATE 15, 29: PRINT "Impressao do Relatorio"
5060 NC = NP + 1
     TC(1) = 8
     Z = INT(71 / NP) - 1
     FOR K = 2 TO NC
       TC(K) = Z
     NEXT K
     FLAG = 6: GOSUB INPINIT
     FLAG = 8: GOSUB INPINIT
     IF IMPRESSAO = 0 THEN T$ = CHR$(15): FLAG = 2: GOSUB IMPPADRAO
5130 LOCATE 17, 15: PRINT "Digite o proximo cabecalho ou tecle << ENTER >>"
     LOCATE 19, 5: PRINT "CABECALHO: "; STRING$(60, "_");
     CODIGO$ = "61321221916": GOSUB TRTR
     T$ = LETRA$
     IF LEN(T$) = 0 THEN GOTO 5210
     Z = INT((79 - LEN(T$)) / 2)
     T$ = LEFT$(BC$, Z) + T$ + LEFT$(BC$, Z): NEG = 1
     FLAG = 2: GOSUB IMPPADRAO
     FLAG = 3: GOSUB IMPPADRAO: NEG = 0
     GOTO 5130
5210 LOCATE 17, 2: PRINT STRING$(78, " ")
     LOCATE 19, 2: PRINT STRING$(78, " ")
     FLAG = 4: GOSUB IMPPADRAO
     L$(1) = "ANO"
     FOR I = 1 TO NP
       L$(I + 1) = A$(I)
     NEXT I
     FLAG = 1: GOSUB IMPPADRAO
     FLAG = 4: GOSUB IMPPADRAO
     CI = CI - 1
     FOR J = 1 TO TA
       L$(1) = STR$(J + CI)
       FOR I = 1 TO NP
	 IF M(J, I) < 0 AND FG(3) = 0 THEN L$(I + 1) = "***": GOTO 5330
	 Z = M(J, I)
	 GOSUB ARREDO
	 L$(I + 1) = Z$
5330   NEXT I
5340   FLAG = 1: GOSUB IMPPADRAO
5350 NEXT J
     CI = CI + 1
     FLAG = 4: GOSUB IMPPADRAO
     IF FG(4) = 0 THEN GOTO VAI2: 'RETURN
     L$(1) = "MEDIA"
     FOR I = 1 TO NP
       Z = MD(I)
       GOSUB ARREDO
       L$(I + 1) = Z$
     NEXT I
     FLAG = 1: GOSUB IMPPADRAO
     L$(1) = "DESVIO PADRAO"
     FOR I = 1 TO NP
       Z = DP(I)
       GOSUB ARREDO
       L$(I + 1) = Z$
     NEXT I
     FLAG = 1: GOSUB IMPPADRAO
     L$(1) = "ASSIMETRIA"
     FOR I = 1 TO NP
       Z = SA(I)
       GOSUB ARREDO
       L$(I + 1) = Z$
     NEXT I
     FLAG = 1: GOSUB IMPPADRAO
     FLAG = 4: GOSUB IMPPADRAO
VAI2: IF GRAVA = 0 THEN
		    FOR BUF = 1 TO 250
		      IF BUFFER$(BUF) <> " " THEN GOSUB GRARELAT: RETURN
		    NEXT BUF
		  END IF
     RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                         ARREDONDAMENTO                                      '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ARREDO: Z = Z * 100
      Z = Z + .5
      Z = INT(Z)
      Z = Z / 100
      Z$ = STR$(Z)
      RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                         INIT IMPRESSAO                                      '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
INPINIT: IF FLAG = 8 THEN FLAG = 0: TT$ = " ": RETURN
	IF FLAG = 9 THEN FLAG = 0: TT$ = "!": RETURN
	IF FLAG = 7 THEN FLAG = 0: Z$ = "+": GOSUB TRACOTAB: RETURN
	IF FLAG = 6 THEN FLAG = 0: Z$ = "-": GOSUB TRACOTAB: RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                         COLUNAS DE TAMANHO IGUAL                            '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
20110 FOR K = 1 TO NC
	TC(K) = INT(79 / NC) - 1
      NEXT K
      RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                         TRACO DE TABELA                                     '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
TRACOTAB: TR$ = Z$
	 FOR I = 1 TO NC
	   FOR J = 1 TO TC(I)
	     TR$ = TR$ + "-"
	   NEXT J
	   TR$ = TR$ + Z$
	 NEXT I
	 RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                         IMPRESSAO PADRAO                                    '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
IMPPADRAO: IF FLAG = 3 THEN FLAG = 0: T$ = " ": GOTO 21170
	  IF FLAG = 4 THEN FLAG = 0: T$ = TR$: GOTO 21170
	  IF FLAG = 2 THEN FLAG = 0: GOTO 21170
	  T$ = TT$
	  IF FLAG = 1 THEN FLAG = 0: GOTO 21110
	  FOR K = 1 TO NC
	    L$(K) = STR$(L(K))
	  NEXT K
21110 FOR K = 1 TO NC
	IF LEN(L$(K)) > TC(K) THEN L$(K) = LEFT$(L$(K), TC(K))
	IF LEN(L$(K)) < TC(K) AND K = 1 THEN L$(K) = L$(K) + LEFT$(BC$, TC(K) - LEN(L$(K))): GOTO 21140
	IF LEN(L$(K)) < TC(K) AND K <> 1 THEN L$(K) = LEFT$(BC$, TC(K) - LEN(L$(K))) + L$(K)
21140   T$ = T$ + L$(K) + TT$
	L$(K) = " "
      NEXT K
21170 ERG = 100: IF GRAVA = 0 THEN BUF = BUF + 1: BUFFER$(BUF) = T$
      IF BUF = 250 THEN GOSUB GRARELAT
      IF IMPRESSAO = 1 THEN T$ = " ": ERG = 0: RETURN

' foi anulada a sentencia seguinte para impedir impressao
'      IF NEG = 0 THEN LPRINT T$ ELSE GOSUB NEGRITO
     
      IF TESERRO = 1 THEN TESERRO = 0: GOSUB LIMPALINHA: GOTO 21170
      T$ = " ": ERG = 0
      RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                         CALCULO DE ESTATISTICAS                             '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
CALCESTAT: GOSUB LIMPATELA
      LOCATE 5, 28: PRINT "Calculando Estatisticas"
      FOR I = 1 TO NP
	LOCATE 7, 35: PRINT "POSTO: "; I
	MD(I) = 0
	N = 0
	FOR J = 1 TO TA
	  IF FG(3) = 0 AND M(J, I) < 0 THEN GOTO 25080
	  IF M(J, I) = -999 THEN GOTO 25080
	  MD(I) = MD(I) + ABS(M(J, I))
	  N = N + 1
25080   NEXT J
	MD(I) = MD(I) / N
	S1 = 0: S2 = 0
	FOR J = 1 TO TA
	  IF FG(3) = 0 AND M(J, I) < 0 THEN GOTO 25130
	  IF M(J, I) = -999 THEN GOTO 25130
	  S1 = S1 + (ABS(M(J, I)) - MD(I)) ^ 2
	  S2 = S2 + (ABS(M(J, I)) - MD(I)) ^ 3
25130   NEXT J
      DP(I) = SQR(S1 / (N - 1))
      SA(I) = N * S2 / (N - 1) / (N - 2) / DP(I) ^ 3
      NEXT I
      RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                         EDITOR DE MATRIZ                                    '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
MENU2: GOSUB LIMPATELA
      LOCATE 4, 5: PRINT I$
      LOCATE 5, 5: PRINT "A - alterar item corrente"
      LOCATE 6, 5: PRINT "C - carregar arquivo"
      LOCATE 7, 5: PRINT "D - deletar item corrente"
      LOCATE 8, 5: PRINT "G - gravar arquivo"
      LOCATE 9, 5: PRINT "I - pre-insercao de item"
      LOCATE 5, 40: PRINT "J - pos-insercao de item"
      LOCATE 6, 40: PRINT "K - remover arquivo do disco"
      LOCATE 7, 40: PRINT "P - proximo item"
      LOCATE 8, 40: PRINT "R - retornar item"
      LOCATE 9, 40: PRINT "T - trocar extensao do arquivo"
      P = 0
      LOCATE 12, 5
26140 IF P > N THEN P = 1
      IF P < 1 THEN P = N
      LN = CSRLIN
26157 IF LN > 19 THEN LN = 12
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
       IF MID$(OP$, 2, 1) = ">" THEN GOSUB LIMPATELA: RETURN
      END IF
      IF OP$ = "A" OR OP$ = "a" THEN GOSUB ALTERA: GOTO IMPRIME
      IF OP$ = "P" OR OP$ = "p" THEN
				  P = P + 1
				  IF P > N OR P < 1 THEN P = 1
				  GOTO IMPRIME
				END IF
      IF OP$ = "R" OR OP$ = "r" THEN
				  P = P - 1
				  IF P < 1 THEN P = N
				  GOTO IMPRIME
				END IF
      IF OP$ = "J" OR OP$ = "j" THEN GOSUB JUSTAPOS: GOTO IMPRIME
      IF OP$ = "G" OR OP$ = "g" THEN GOSUB SALVA: LOCATE 2, 58: PRINT MUD$; A$; STRING$(13 - LEN(A$), 32): GOTO IMPRIME
      IF OP$ = "D" OR OP$ = "d" THEN GOSUB DELETA: GOTO IMPRIME
      IF OP$ = "C" OR OP$ = "c" THEN GOSUB RECUPERA: LOCATE 2, 58: PRINT MUD$; A$; STRING$(13 - LEN(A$), 32): GOTO IMPRIME
      IF OP$ = "I" OR OP$ = "i" THEN GOSUB INSERE: GOTO IMPRIME
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
26240 GOTO 26140

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                     ALTERA UM VALOR DE CADA VEZ                             '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ALTERA: IF P < 1 OR N < 1 THEN BEEP: RETURN
	LOCATE 22, 15: PRINT "Qual o novo dado #"; P
	LOCATE 22, 40: PRINT STRING$(12, "_")
	CODIGO$ = "13321222240": GOSUB TRTR
	V$(P) = LETRA$
	GOSUB LIMPALINHA
	LOCATE LN, 5
	RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                     INSERE UM VALOR DE CADA VEZ                             '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
INSERE:   IF P < 1 THEN P = 1
	  IF N = 1000 THEN BEEP: RETURN
	  '****** IF P > N THEN BEEP:RETURN ******
	  FOR K = N TO P STEP -1
	    V$(K + 1) = V$(K)
	  NEXT K
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

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                     DELETA UM VALOR DE CADA VEZ                             '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
DELETA: IF N < 1 OR P < 1 THEN BEEP: RETURN
	IF N = 1 THEN V$(P) = "": RETURN
	FOR K = P TO N - 1
	  V$(K) = V$(K + 1)
	NEXT K
	N = N - 1
	P = P - 1
	RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                     POS-INSERCAO DE ELEMENTOS                               '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
JUSTAPOS: IF N = 1000 THEN BEEP: RETURN
	  '****** IF P > N THEN BEEP:RETURN ******
	  FOR K = N TO P STEP -1
	    V$(K + 1) = V$(K)
	  NEXT K
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
	  LOCATE 12, 5
	  RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                     TROCA EXTENSAO                                          '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
TROCA: LOCATE 22, 10: PRINT "Qual a extensao a ser trocada "; STRING$(12, "_")
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

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                     SALVA MATRIZ                                            '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SALVA: LOCATE 22, 15: PRINT "Qual o nome do arquivo "; STRING$(12, "_");
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
26800  GOSUB MEIATELA: LOCATE 12, 5
       RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                    CARREGA MATRIZ                                           '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
RECUPERA: LOCATE 22, 15: PRINT "Qual o nome do arquivo "; STRING$(12, "_")
       CODIGO$ = "13321222238": GOSUB TRTR
       AUX$ = LETRA$
       IF AUX$ = "" THEN AUX$ = A$
       IF AUX$ = "SEM NOME" THEN GOSUB CANCELA: GOTO 26850
       YYY$ = AUX$: GOSUB VALIDADE: AUX$ = YYY$: IF ERG = 101 THEN GOSUB ERGS: GOTO RECUPERA
       GOSUB TESTDRIVE: IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: GOTO 26850
       GOSUB LIMPALINHA: LOCATE 12, 5
       LOCATE 22, 15: PRINT "CARREGANDO ARQUIVO !!"
       ARQUIVO$ = MUD$ + AUX$
       OPEN ARQUIVO$ FOR INPUT AS #1
       IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: CLOSE #1: GOTO 26850
       INPUT #1, N, Z
       FOR I = 1 TO N
	 INPUT #1, V$(I)
       NEXT I
       CLOSE #1
       A$ = AUX$
       P = 1
       LOCATE 22, 15: PRINT "ARQUIVO CARREGADO !! "
       GOSUB TEMPO
26850  GOSUB MEIATELA: LOCATE 12, 5
       RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                    REMOVE  MATRIZ                                           '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
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

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                         ADIMENSIONALIZA                                     '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ADIMENSIONA: FOR I = 1 TO NP
	      V$(I) = STR$(MD(I))
	    NEXT I
	    TESTEX = NP
	    N = NP

27100 I$ = "CONSTANTES DE ADIMENSIONALIZACAO (MD)"
      GOSUB MENU2: TECLA$ = "": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
      LOCATE 24, 46: PRINT STRING$(21, 205);
      IF N = TESTEX THEN GOTO 27130
      LOCATE 5, 10: PRINT "O numero de valores da lista e' diferente do numero de postos."
      BEEP: TECLA$ = "4": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
      LOCATE 24, 46: PRINT CHR$(175); " Tecle << ENTER >> "; CHR$(174);
AQUI4: OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI4
      IF ASC(MID$(OP$, 1, 1)) = 0 THEN
			   IF MID$(OP$, 2, 1) = ">" THEN GOSUB LIMPATELA
			   TESERRO = 1: LOCATE 24, 46: PRINT STRING$(21, 205);
			   RETURN
				END IF
      IF ASC(OP$) <> 13 THEN BEEP: GOTO AQUI4
      LOCATE 24, 46: PRINT STRING$(21, 205); : GOTO 27100

27130 FOR I = 1 TO N
	CA(I) = VAL(V$(I))
      NEXT I
      FOR I = 1 TO NP
	IF CA(I) = 0 THEN FLAG = 1
      NEXT I
      IF FLAG = 0 THEN GOTO 27200
      LOCATE 5, 26: PRINT "Ha alguma constante zerada.": BEEP
      LOCATE 24, 46: PRINT CHR$(175); " Tecle << ENTER >> "; CHR$(174);
      TECLA$ = "4": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
AQUI5: OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI5
      IF ASC(MID$(OP$, 1, 1)) = 0 THEN
			   IF MID$(OP$, 2, 1) = ">" THEN GOSUB LIMPATELA
			   TESERRO = 1: LOCATE 24, 46: PRINT STRING$(21, 205);
			   RETURN
				END IF
      IF ASC(OP$) <> 13 THEN BEEP: GOTO AQUI5
      LOCATE 24, 46: PRINT STRING$(21, 205); : FLAG = 0: GOTO 27100

27200 LOCATE 5, 19: PRINT "Adimensionalizando e gravando arquivos A-*"
      GOSUB TESTDRIVE: IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: GOTO AQUI6
      FOR I = 1 TO NP
	LIXO$ = A$(I): FORA$ = A$(I)
	LIXO$ = LEFT$(LIXO$, INSTR(LIXO$, ".") - 1)
	IF LEN(LIXO$) = 8 THEN
			  A$(I) = LEFT$(A$(I), INSTR(A$(I), ".") - 2) + MID$(A$(I), INSTR(A$(I), "."), LEN(A$(I)))
			END IF
	LIXO$ = ""
	A$(I) = "A" + A$(I)
	ARQUIVO$ = MUD$ + A$(I)
	OPEN ARQUIVO$ FOR OUTPUT AS #1
	IF TESERRO = 1 THEN TESERRO = 0: CLOSE #1: GOSUB CANCELA: GOTO AQUI6
	PRINT #1, TA
	PRINT #1, 1
	FOR J = 1 TO TA
	  IF M(J, I) <> -999 THEN M(J, I) = 100 * M(J, I) / CA(I)
	  Z = M(J, I): GOSUB ARREDO: M(J, I) = Z
	  PRINT #1, M(J, I)
	NEXT J
	CLOSE #1
	IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: GOTO AQUI6
	FORA$ = ""
	A$ = A$(I)
	LOCATE 2, 58: PRINT MUD$; A$; STRING$(13 - LEN(A$), 32)
      NEXT I
27300 LOCATE 7, 19: PRINT "Batize a Regiao Adimensionalizada "; STRING$(12, "_")
      CODIGO$ = "13321220753": GOSUB TRTR
      AUX$ = LETRA$
      IF AUX$ = "" THEN ERG = 101: GOSUB ERGS: GOTO 27300
      YYY$ = AUX$: GOSUB VALIDADE: AUX$ = YYY$
      IF ERG = 101 THEN GOSUB ERGS: GOTO 27300
      ARQUIVO$ = MUD$ + AUX$
      OPEN ARQUIVO$ FOR OUTPUT AS #1
      IF TESERRO = 1 THEN TESERRO = 0: CLOSE #1: GOSUB CANCELA: GOTO AQUI6
      PRINT #1, NP
      PRINT #1, 1
      FOR I = 1 TO NP
	PRINT #1, A$(I)
      NEXT I
      CLOSE #1
      IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: GOTO AQUI6
      A$ = AUX$
      LOCATE 2, 58: PRINT MUD$; A$; STRING$(13 - LEN(A$), 32)
      RETURN

AQUI6: 'LOCATE 22,17:PRINT"DADO INCONSISTENTE, PROVAVELMENTE NO ITEM #";I;"."
      'BEEP:GOSUB TEMPO:GOSUB LIMPALINHA
      A$(I) = FORA$: GOTO 27100

LEITARQ: ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	 '                     LEITURA  A$(1-NP)                              '
	 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
29030 LOCATE 12, 30: PRINT "LEITURA DE ARQUIVOS"
      GOSUB TESTDRIVE: IF TESERRO = 1 THEN GOSUB CANCELA: RETURN
      LOCATE 24, 46: PRINT STRING$(21, 205);
      I = 0
29050 I = I + 1
      LIMPA = (80 - (14 + LEN(A$(I)))) / 2
      LOCATE 13, 2: PRINT STRING$(78, " ");
      LOCATE 13, LIMPA: PRINT "ARQUIVO ("; I; ") "; A$(I)
      IF A$(I) = "" THEN TESERRO = 1: GOSUB CANCELA: RETURN
      ARQUIVO$ = MUD$ + A$(I)
      OPEN ARQUIVO$ FOR INPUT AS #1
      IF TESERRO = 1 THEN GOSUB CANCELA: CLOSE #1: RETURN
      INPUT #1, Z
      INPUT #1, LIXO
      IF Z < TA THEN
       LOCATE 15, 15: PRINT "O arquivo "; A$(I); " tem dimensao "; Z; " diferente de "
       LOCATE 16, 14: PRINT TA; " que foi informada. "
       LOCATE 17, 15: PRINT "Deseja usar a dimensao do arquivo (S/N) ?"
       LOCATE 24, 46: PRINT CHR$(175); " OPCAO "; CHR$(174);
AQ:    OP$ = INKEY$: IF OP$ = "" THEN GOTO AQ
       IF OP$ = "S" OR OP$ = "s" THEN
			       TA = Z
			       GOSUB MEIATELA
			       LOCATE 24, 46: PRINT STRING$(21, 205);
			       LOCATE 12, 30: PRINT "LEITURA DE ARQUIVOS"
			       GOTO FTF
			     END IF
       IF OP$ = "N" OR OP$ = "n" THEN
			       TESERRO = 1: CLOSE #1
			       LOCATE 24, 46: PRINT STRING$(21, 205);
			       GOSUB CANCELA: RETURN
			     END IF
       BEEP: GOTO AQ
      END IF
FTF:  FOR J = 1 TO TA
	INPUT #1, M(J, I)
      NEXT J
      CLOSE #1
      IF I < NP THEN GOTO 29050
      RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                                 Final Parte 3                               '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Parte 4: Rotinas Auxiliares                                                 '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                         DIRETORIO                                           '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
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

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                         LIMPA TELA                                          '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
LIMPATELA: FOR LIMPA = 4 TO 23
	    IF LIMPA = 10 THEN IF APAGA = 1 THEN GOTO PULALIMPA
	    LOCATE LIMPA, 2
	    PRINT STRING$(78, " ");
PULALIMPA: NEXT LIMPA
	  RETURN

MEIATELA: FOR LIMPA = 11 TO 23
	    LOCATE LIMPA, 2
	    PRINT STRING$(78, " ");
	  NEXT LIMPA
	  RETURN

LIMPALINHA: LOCATE 22, 2: PRINT STRING$(78, " "); : RETURN

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


TEMPO: FOR TESTE = 1 TO 12000: NEXT TESTE: RETURN


CANCELA: GOSUB LIMPALINHA
	 LOCATE 22, 31
	 PRINT "OPERACAO CANCELADA"
	 GOSUB TEMPO
	 GOSUB LIMPALINHA
	 RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                        TRATAMENTO DE ERROS                                  '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ERGS:    SOM = 0
	 GOSUB LIMPALINHA
	 IF ERG = 101 THEN LOCATE 22, 28: PRINT "NOME DO ARQUIVO INVALIDO": SOM = 1
	 IF SOM = 1 THEN BEEP: GOSUB TEMPO
	 ERG = 0
	 GOSUB LIMPALINHA
	 RETURN

ERROS:   TESERRO = 1: SOM = 0
	 GOSUB LIMPALINHA
'         IF ERR=10 THEN LOCATE 22,34:PRINT "ARRAY REDIM":SOM = 1
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
	 LOCATE 23, 16: PRINT ERR;
	 IF SOM = 0 THEN TESERRO = 0
	 IF SOM = 1 THEN BEEP: GOSUB TEMPO
	 RESUME NEXT

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                        TECLAS VALIDAS                                       '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
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
'                        MENSAGENS DE AJUDA                                   '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
AJUDA: IF CONTHELP > 20 THEN CONTHELP = 1
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

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                        TESTA VALIDADE DO NOME DO ARQUIVO                    '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
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

NEGRITO: LPRINT CHR$(27); "@";
	 LPRINT CHR$(27); "E";
	 LPRINT T$
	 LPRINT CHR$(27); "@";
	 RETURN

'      LIXO$=A$
'      LIXO$=LEFT$(LIXO$,INSTR(LIXO$,".")-1)
'      IF LEN(LIXO$)=8 THEN
'                        A$ = LEFT$(A$,INSTR(A$,".")-2)+MID$(A$,INSTR(A$,"."),LEN(A$))
'                        PRINT A$
'                        PRINT
'                      END IF
'      A$="#"+A$
'      PRINT A$

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
AQUI10:                    OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI10
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
			   BEEP: GOTO AQUI10
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

