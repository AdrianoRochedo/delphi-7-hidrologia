'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'  PROGRAMA ED.BAS                                                        '
'  Adaptado por Juan Santiago
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'  Parte 1: Inicializacao de variaveis e tela de apresentacao             '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

     CLS
     ON ERROR GOTO ERROS
     DIM TEXTO$(15), TELA$(8), HELP$(35)
     HELP$(0) = "123456789012345678901234"
     HELP$(1) = "    SOBRE AS OPCOES     "
     HELP$(2) = "   Para selecionar opcao"
     HELP$(3) = "desejada pressione tecla"
     HELP$(4) = "correspondente.         "
     HELP$(5) = "                        "
     HELP$(6) = "     OPCOES 1 a 6       "
     HELP$(7) = "   Devera  ser  digitado"
     HELP$(8) = "o numero da linha/coluna"
     HELP$(9) = "que deseja-se operar.   "
     HELP$(10) = "                        "
     HELP$(11) = "     OPCOES 7 e 8       "
     HELP$(12) = "   Acrescentara  ao  fim"
     HELP$(13) = "da  matriz uma linha  ou"
     HELP$(14) = "coluna caso nao ocorra o"
     HELP$(15) = "estouro da mesma.       "
     HELP$(16) = "   SOBRE OS ARQUIVOS    "
     HELP$(17) = "   O  nome  dos arquivos"
     HELP$(18) = "devem ter no maximo  (8)"
     HELP$(19) = "caracteres  e  mais  (3)"
     HELP$(20) = "para a extensao.        "
     HELP$(21) = "   SOBRE OS ARQUIVOS    "
     HELP$(22) = "   Se nao  for  digitada"
     HELP$(23) = "a extensao  do arquivo o"
     HELP$(24) = "sistema assume  extensao"
     HELP$(25) = "( .REG ) .              "
     HELP$(26) = "        ATENCAO         "
     HELP$(27) = "   Quando  houver  falha"
     HELP$(28) = "de  observacao   deve-se"
     HELP$(29) = "digitar  ( -999 ).      "
     HELP$(30) = "                        "
     HELP$(31) = "     SOBRE OS ERROS     "
     HELP$(32) = "   Quando for  provocado"
     HELP$(33) = "um  erro,  aparecera  na"
     HELP$(34) = "tela uma mensagem  sobre"
     HELP$(35) = "este erro.              "
     FOR TESTE = 0 TO 15
       TEXTO$(TESTE) = ""
     NEXT TESTE
     FOR TESTE = 0 TO 8
       TELA$(TESTE) = ""
     NEXT TESTE
     MUD$ = "A:\"
     A$ = "SEM NOME"
     VEZ = 0
     APAGA = 0
     CONTHELP = 1

     GOSUB DESENTELA
     LOCATE 6, 23: PRINT "Instituto de Pesquisas Hidraulicas"
     LOCATE 8, 20: PRINT " Universidade Federal do Rio Grande do Sul"
     LOCATE 13, 23: PRINT "PROGRAMA PARA EDICAO DE ARQUIVOS"
     LOCATE 15, 30: PRINT "VERSAO 1.0  /  1990"
     LOCATE 18, 20: PRINT "Desenvolvido por: "
     LOCATE 19, 37: PRINT "Antonio Eduardo Leao Lanna"
     LOCATE 20, 37: PRINT "Luciano Nunes de Oliveira"
     LOCATE 24, 46: PRINT CHR$(175); " Tecle << ENTER >> "; CHR$(174);
AQUI1: OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI1
     IF ASC(OP$) <> 13 THEN BEEP: GOTO AQUI1
     LOCATE 24, 46: PRINT STRING$(21, 205);
     GOSUB LIMPATELA
     LOCATE 10, 1: PRINT CHR$(204); STRING$(78, 205); CHR$(185);
     APAGA = 1

     MC = 2
     ML = 1000
     DIM V(ML)
     DIM M(ML, MC)

     FOR I = 21 TO 3 STEP -1
       LOCATE 2, I
       PRINT "SISTEMA DE REGIONALIZACAO HIDROLOGICA VRS. 1.0 "
       FOR J = 1 TO 20
       NEXT J
     NEXT I
     LOCATE 1, 50: PRINT CHR$(203)
     LOCATE 2, 50: PRINT CHR$(186)
     LOCATE 3, 50: PRINT CHR$(202)

     DEF SEG = &HB800
     FOR I = 163 TO 257 STEP 2
       POKE I, &H13
     NEXT I
     DEF SEG

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                               Final Parte 1                             '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'  Parte 2: Criacao dos Arquivos                                          '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

EDITA: ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
       '                             EDITA MATRIZ                             '
       ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
      TECLA$ = "1234": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
      IF AN = 1 THEN AN = 0
      LOCATE 4, 5: PRINT "A. ano de inicio"; AN
      LOCATE 5, 5: PRINT "1. editar linha...                 "
      LOCATE 6, 5: PRINT "2. editar coluna...                "
      LOCATE 7, 5: PRINT "3. inserir linha                   "
      LOCATE 8, 5: PRINT "4. inserir coluna                  "
      LOCATE 9, 5: PRINT "5. apagar linha                    "
      LOCATE 5, 40: PRINT "6. apagar coluna                        "
      LOCATE 6, 40: PRINT "7. inserir linha                        "
      LOCATE 7, 40: PRINT "8. inserir coluna                       "
      LOCATE 8, 40: PRINT "B. carrega matriz                       "
      LOCATE 9, 40: PRINT "G. grava matriz                         "
AQUI4: LOCATE 12, 5: PRINT "M. nome da MATRIZ   :   "; A$; STRING$(12, " ");
      LOCATE 13, 5: PRINT "L. numero de LINHAS :  "; NL; STRING$(3, " ");
      LOCATE 14, 5: PRINT "C. numero de COLUNAS:  "; NC; STRING$(3, " ");
      LOCATE 24, 46: PRINT CHR$(175); " OPCAO "; CHR$(174);
      LOCATE 2, 58: PRINT MUD$; A$; STRING$(13 - LEN(A$), 32)
      OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI4
      TESTE = 0
      IF ASC(MID$(OP$, 1, 1)) = 0 THEN
       IF MID$(OP$, 2, 1) = ";" THEN GOSUB AJUDA: GOTO EDITA
       IF MID$(OP$, 2, 1) = "<" THEN GOSUB DIRETORIO: GOTO EDITA
       IF MID$(OP$, 2, 1) = "=" THEN
			      IF MUD$ = "A:\" THEN MUD$ = "B:\": GOTO AQUI4
			      IF MUD$ = "B:\" THEN MUD$ = "C:\": GOTO AQUI4
			      IF MUD$ = "C:\" THEN MUD$ = "A:\": GOTO AQUI4
			    END IF
       IF MID$(OP$, 2, 1) = ">" THEN
			      GOSUB MEIATELA
			      LOCATE 12, 29
			      PRINT "Confirma opcao (S/N) ?"
AQUI0:                        OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI0
			      IF OP$ = "S" OR OP$ = "s" THEN CLS : END
			      IF OP$ = "N" OR OP$ = "n" THEN LOCATE 12, 2: PRINT STRING$(78, " "): GOTO EDITA
			      BEEP: GOTO AQUI0
			    END IF
      END IF
      IF OP$ = "M" OR OP$ = "m" THEN
OPMm:                             LOCATE 12, 29
				  PRINT STRING$(12, "_")
				  CODIGO$ = "13321221229": GOSUB TRTR
				  AUX$ = LETRA$
				  IF AUX$ = "" THEN AUX$ = A$
				  YYY$ = AUX$: GOSUB VALIDADE: AUX$ = YYY$
				  IF ERG = 101 THEN GOSUB ERGS: GOTO OPMm
				  A$ = AUX$
				  TESTE = 1
				END IF
      IF OP$ = "L" OR OP$ = "l" THEN
OPLl:                             TESTE = 1
				  LOCATE 13, 29
				  PRINT STRING$(3, "_")
				  CODIGO$ = "04480571329": GOSUB TRTR
				  NL = VAL(LETRA$)
				  IF (NL > ML) THEN
					       BEEP: LOCATE 13, 29
					       PRINT STRING$(3, "_");
					       GOTO OPLl
					     END IF
				END IF
     IF OP$ = "C" OR OP$ = "c" THEN
OPCc:                             TESTE = 1
				  LOCATE 14, 29
				  PRINT STRING$(1, "_")
				  CODIGO$ = "02480571429": GOSUB TRTR
				  NC = VAL(LETRA$)
				  IF (NC > MC) THEN
					       BEEP: LOCATE 14, 29
					       PRINT STRING$(1, "_");
					       GOTO OPCc
					     END IF
				END IF
     IF OP$ = "A" OR OP$ = "a" THEN
OPCA:                             TESTE = 1
				  LOCATE 4, 22
				  PRINT STRING$(4, "_")
				  CODIGO$ = "05480570422": GOSUB TRTR
				  AN = VAL(LETRA$)
				  IF AN = 0 THEN LOCATE 4, 22: PRINT "0   ": GOTO AQUI4
				  IF (AN < 1500) OR (AN > 3000) THEN
							      BEEP: LOCATE 4, 22
							      PRINT STRING$(4, "_");
							      GOTO OPCA
							    END IF
				END IF

      IF OP$ = "B" OR OP$ = "b" THEN GOTO BUSCA
      IF OP$ = "G" OR OP$ = "g" THEN GOTO GRAVA
      IF OP$ = "1" THEN TESTE = 1: GOTO EDLINHA
      IF OP$ = "2" THEN TESTE = 1: GOTO EDCOLUNA
      IF OP$ = "3" THEN TESTE = 1: GOTO INLINHA
      IF OP$ = "4" THEN TESTE = 1: GOTO INCOLUNA
      IF OP$ = "5" THEN TESTE = 1: GOTO DELLINHA
      IF OP$ = "6" THEN TESTE = 1: GOTO DELCOLUNA
      IF OP$ = "7" THEN TESTE = 1: GOTO ACRELINHA
      IF OP$ = "8" THEN TESTE = 1: GOTO ACRECOLUNA
      IF TESTE <> 1 THEN BEEP
      GOTO AQUI4

EDLINHA: IF NL < 1 THEN
		     LOCATE 22, 22
		     PRINT "DIMENSIONE ANTES O NUMERO DE LINHAS"
		     BEEP
		     GOSUB TEMPO
		     GOSUB LIMPALINHA
		     GOTO AQUI4
		   END IF
AQUI5: LOCATE 5, 30: PRINT "# "; STRING$(3, "_")
       CODIGO$ = "04480570532": GOSUB TRTR
       AUX$ = LETRA$
       IF AUX$ = "" THEN GOSUB CANCELA: GOTO EDITA
       I = VAL(LETRA$)
       I = INT(I)
       IF I < 1 OR I > NL THEN BEEP: GOTO AQUI5
       FOR J = 1 TO NC
	 V(J) = M(I, J)
       NEXT J
       N = NC
       I$ = "LINHA # " + STR$(I)
       FLAG$ = "COLUNA"
       GOSUB MENU2
       FOR J = 1 TO NC
	 M(I, J) = V(J)
       NEXT J
       GOTO EDITA

EDCOLUNA: IF NC < 1 THEN
		     LOCATE 22, 22
		     PRINT "DIMENSIONE ANTES O NUMERO DE COLUNAS"
		     BEEP
		     GOSUB TEMPO
		     GOSUB LIMPALINHA
		     GOTO AQUI4
		   END IF
AQUI6: LOCATE 6, 30: PRINT "# "; STRING$(1, "_")
       CODIGO$ = "02480570632": GOSUB TRTR
       AUX$ = LETRA$
       IF AUX$ = "" THEN GOSUB CANCELA: GOTO EDITA
       J = VAL(LETRA$)
       J = INT(J)
       IF J < 1 OR J > NC THEN BEEP: GOTO AQUI6
       FOR I = 1 TO NL
	 V(I) = M(I, J)
       NEXT I
       N = NL
       I$ = "COLUNA # " + STR$(J)
       FLAG$ = "LINHA"
       GOSUB MENU2
       NL = N
       FOR I = 1 TO NL
	 M(I, J) = V(I)
       NEXT I
       GOTO EDITA

INLINHA: IF NL < 1 THEN
		     LOCATE 22, 22
		     PRINT "DIMENSIONE ANTES O NUMERO DE LINHAS"
		     BEEP
		     GOSUB TEMPO
		     GOSUB LIMPALINHA
		     GOTO AQUI4
		   END IF
       IF NL = ML THEN TESTE = 1: GOSUB ESTOURO: GOTO AQUI4

AQUI7: LOCATE 7, 30: PRINT "# "; STRING$(3, "_")
       CODIGO$ = "04480570732": GOSUB TRTR
       AUX$ = LETRA$
       IF AUX$ = "" THEN GOSUB CANCELA: GOTO EDITA
       L = VAL(LETRA$)
       IF L < 1 OR L > NL THEN BEEP: GOTO AQUI7
       FOR I = L TO NL
	 FOR J = 1 TO NC
	   M(I + 1, J) = M(I, J)
	 NEXT J
       NEXT I
       NL = NL + 1
       N = NC
       I$ = "LINHA # " + STR$(L)
       FLAG$ = "COLUNA"
       GOSUB MENU2
       FOR J = 1 TO NC
	 M(L, J) = V(J)
       NEXT J
       GOTO EDITA

INCOLUNA: IF NC < 1 THEN
		      LOCATE 22, 22
		      PRINT "DIMENSIONE ANTES O NUMERO DE COLUNAS"
		      BEEP
		      GOSUB TEMPO
		      GOSUB LIMPALINHA
		      GOTO AQUI4
		    END IF
	  IF NC = MC THEN TESTE = 2: GOSUB ESTOURO: GOTO AQUI4

AQUI8: LOCATE 8, 30: PRINT "# "; STRING$(1, "_")
       CODIGO$ = "02480570832": GOSUB TRTR
       AUX$ = LETRA$
       IF AUX$ = "" THEN GOSUB CANCELA: GOTO EDITA
       C = VAL(LETRA$)
       IF C < 1 OR C > NC THEN BEEP: GOTO AQUI8
       FOR J = C TO NC
	 FOR I = 1 TO NL
	   M(I, J + 1) = M(I, J)
	 NEXT I
       NEXT J
       NC = NC + 1
       N = NL
       I$ = "COLUNA # " + STR$(C)
       FLAG$ = "LINHA"
       GOSUB MENU2
       NL = N
       FOR I = 1 TO NL
	 M(I, C) = V(I)
       NEXT I
       GOTO EDITA

DELLINHA: IF NL < 1 THEN
		      LOCATE 22, 22
		      PRINT "DIMENSIONE ANTES O NUMERO DE LINHAS"
		      BEEP
		      GOSUB TEMPO
		      GOSUB LIMPALINHA
		      GOTO AQUI4
		    END IF

AQUI10: LOCATE 9, 30: PRINT "# "; STRING$(3, "_")
	CODIGO$ = "04480570932": GOSUB TRTR
	AUX$ = LETRA$
	IF AUX$ = "" THEN GOSUB CANCELA: GOTO EDITA
	L = VAL(LETRA$)
	IF L < 0 OR L > NL THEN BEEP: GOTO AQUI10
	FOR I = L TO NL - 1
	  FOR J = 1 TO NC
	    M(I, J) = M(I + 1, J)
	  NEXT J
	NEXT I
	NL = NL - 1
	GOTO EDITA

DELCOLUNA: IF NC < 1 THEN
		       LOCATE 22, 22
		       PRINT "DIMENSIONE ANTES O NUMERO DE COLUNAS"
		       BEEP
		       GOSUB TEMPO
		       GOSUB LIMPALINHA
		       GOTO AQUI4
		     END IF
AQUI11: LOCATE 5, 60: PRINT "# "; STRING$(1, "_")
	CODIGO$ = "02480570562": GOSUB TRTR
	AUX$ = LETRA$
	IF AUX$ = "" THEN GOSUB CANCELA: GOTO EDITA
	C = VAL(LETRA$)
	IF C < 0 OR C > NC THEN BEEP: GOTO AQUI11
	FOR J = C TO NC - 1
	  FOR I = 1 TO NL
	    M(I, J) = M(I, J + 1)
	  NEXT I
	NEXT J
	NC = NC - 1
	GOTO EDITA

ACRELINHA: IF NL = ML THEN TESTE = 1: GOSUB ESTOURO: GOTO AQUI4
       NL = NL + 1
       N = NC
       L = NL
       I$ = "LINHA # " + STR$(L)
       FLAG$ = "COLUNA"
       GOSUB MENU2
       FOR C = 1 TO NC
	 M(L, C) = V(C)
       NEXT C
       GOTO EDITA

ACRECOLUNA: IF NC = MC THEN TESTE = 2: GOSUB ESTOURO: GOTO AQUI4
       NC = NC + 1
       N = NL
       C = NC
       I$ = "COLUNA # " + STR$(C)
       FLAG$ = "LINHA"
       GOSUB MENU2
       FOR L = 1 TO NL
	 M(L, C) = V(L)
       NEXT L
       GOTO EDITA

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                              ESTOURO DA MATRIZ                              '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ESTOURO: LOCATE 22, 25: PRINT "ESTOUROU O NUMERO DE ";
     IF TESTE = 1 THEN IF NL = ML THEN PRINT "LINHAS "
     IF TESTE = 2 THEN IF NC = MC THEN PRINT "COLUNAS"
     BEEP
     GOSUB TEMPO
     GOSUB LIMPALINHA
     RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                                   CARGA                                     '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
BUSCA: LOCATE 22, 22: PRINT "Qual o nome da MATRIZ "; STRING$(12, "_")
     CODIGO$ = "13321222244": GOSUB TRTR
     AUX$ = LETRA$
     GOSUB LIMPALINHA
     IF AUX$ = "" THEN AUX$ = A$
     IF AUX$ = "SEM NOME" THEN GOSUB CANCELA: GOTO AQUI4
     YYY$ = AUX$: GOSUB VALIDADE: AUX$ = YYY$: IF ERG = 101 THEN GOSUB ERGS: GOTO BUSCA
     GOSUB TESTDRIVE: IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: GOTO AQUI4
     ARQUIVO$ = MUD$ + AUX$
     OPEN ARQUIVO$ FOR INPUT AS #1
     IF TESERRO = 1 THEN TESERRO = 0: CLOSE #1: GOSUB CANCELA: GOTO AQUI4
     INPUT #1, NL, NC
     IF NL > ML OR NC > MC THEN CLOSE #1: GOTO INICIALIZA
     FOR I = 1 TO NL
       FOR J = 1 TO NC
	 INPUT #1, M(I, J)
       NEXT J
     NEXT I
     CLOSE #1
     A$ = AUX$
     GOTO AQUI4

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                                   GRAVACAO                                  '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
GRAVA: LOCATE 22, 22: PRINT "Qual o nome da MATRIZ "; STRING$(12, "_")
       CODIGO$ = "13321222244": GOSUB TRTR
       AUX$ = LETRA$
       GOSUB LIMPALINHA
       IF AUX$ = "" THEN AUX$ = A$
       IF AUX$ = "SEM NOME" THEN GOSUB CANCELA: GOTO AQUI4
       YYY$ = AUX$: GOSUB VALIDADE: AUX$ = YYY$: IF ERG = 101 THEN GOSUB ERGS: GOTO GRAVA
       GOSUB TESTDRIVE: IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: GOTO AQUI4
       LOCATE 22, 15: PRINT "A MATRIZ "; AUX$; " sera gravada. Confirma opcao (S/N) ?"
AQUI13: OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI13
	IF OP$ = "S" OR OP$ = "s" THEN GOTO 4011
	IF OP$ = "N" OR OP$ = "n" THEN
				    GOSUB CANCELA
				    GOTO AQUI4
				  END IF
	BEEP: GOTO AQUI13
4011    GOSUB LIMPALINHA
	LOCATE 22, 25: PRINT "Anular Preenchimentos (S/N) ?"
AQUI14: OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI14
	IF OP$ = "N" OR OP$ = "n" THEN GOTO 4021
	IF OP$ = "S" OR OP$ = "s" THEN GOTO 4021
	BEEP: GOTO AQUI14
4021    GOSUB LIMPALINHA
	ARQUIVO$ = MUD$ + AUX$
	OPEN ARQUIVO$ FOR OUTPUT AS #1
	IF TESERRO = 1 THEN TESERRO = 0: CLOSE #1: GOSUB CANCELA: GOTO AQUI4
	PRINT #1, NL, NC
	FOR I = 1 TO NL
	  FOR J = 1 TO NC
	    IF OP$ = "N" OR OP$ = "n" THEN GOTO 4095
	    '** COLOCA -999 NAS FALHAS **
	    IF M(I, J) < 0 THEN M(I, J) = -999
4095       PRINT #1, M(I, J)
	  NEXT J
	NEXT I
	CLOSE #1
	IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: GOTO AQUI4
	A$ = AUX$
	GOTO AQUI4

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                                 INICIALIZACAO                               '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
INICIALIZA: IF NL > ML THEN
			 LOCATE 22, 15
			 PRINT "DIMENSAO IMPOSSIVEL, DIMINUA NUMERO DE LINHAS"
			 BEEP
			 GOSUB TEMPO
			 GOSUB LIMPALINHA
		       END IF
	    IF NC > MC THEN
			 LOCATE 22, 15
			 PRINT "DIMENSAO IMPOSSIVEL, DIMINUA NUMERO DE COLUNAS"
			 BEEP
			 GOSUB TEMPO
			 GOSUB LIMPALINHA
		       END IF
	    GOTO AQUI4

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                               Final Parte 2                             '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'  Parte 3: Edicao dos Arquivos                                           '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

MENU2: GOSUB LIMPATELA
      IF AN = 0 THEN AN = 1
      LOCATE 4, 5: PRINT I$
      LOCATE 5, 5: PRINT "A - alterar item corrente"
      LOCATE 6, 5: PRINT "B - alterar vetor completo"
      LOCATE 7, 5: PRINT "D - apagar item "
      LOCATE 8, 5: PRINT "I - pre-insercao de item"
      LOCATE 9, 5: PRINT "J - pos-insercao de item"
      LOCATE 5, 40: PRINT "K - apagar arquivo do disco "
      LOCATE 6, 40: PRINT "P - proximo item"
      LOCATE 7, 40: PRINT "R - retornar item"
      LOCATE 8, 40: PRINT "V - inserir vetor completo"
      LOCATE 9, 40: PRINT "Z - zerar o vetor de edicao"
      P = 0
      LOCATE 12, 5
26140 IF P > N THEN P = 1
      IF P < 1 THEN P = N
      LN = CSRLIN
26157 IF LN > 19 THEN LN = 12
26170 TECLA$ = "1234": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
      LOCATE 2, 58: PRINT MUD$; A$; STRING$(13 - LEN(A$), 32)
      OP$ = INKEY$: IF OP$ = "" THEN GOTO 26170
      IF ASC(MID$(OP$, 1, 1)) = 0 THEN
       IF MID$(OP$, 2, 1) = ";" THEN GOSUB AJUDA: GOTO 26170
       IF MID$(OP$, 2, 1) = "<" THEN GOSUB DIRETORIO: GOTO MENU2
       IF MID$(OP$, 2, 1) = "=" THEN
			      IF MUD$ = "A:\" THEN MUD$ = "B:\": GOTO 26170
			      IF MUD$ = "B:\" THEN MUD$ = "C:\": GOTO 26170
			      IF MUD$ = "C:\" THEN MUD$ = "A:\": GOTO 26170
			    END IF
       IF MID$(OP$, 2, 1) = ">" THEN GOSUB LIMPATELA: FLAG$ = "": RETURN
      END IF

      IF OP$ = "A" OR OP$ = "a" THEN GOSUB ALTERA: GOTO IMPRIME
      IF OP$ = "P" OR OP$ = "p" THEN
				  P = P + 1
				  IF P > N THEN P = 1
				  GOTO IMPRIME
				END IF
      IF OP$ = "Y" THEN
		     FOR AI = 1 TO NL
		       FOR AJ = 1 TO NC
			 LPRINT M(AI, AJ);
		       NEXT AJ
		       LPRINT
		     NEXT AI
		   END IF
      IF OP$ = "R" OR OP$ = "r" THEN
				  P = P - 1
				  IF P < 1 THEN P = N
				  GOTO IMPRIME
				END IF
      IF OP$ = "J" OR OP$ = "j" THEN GOSUB JUSTAPOS: GOTO IMPRIME
      IF OP$ = "K" OR OP$ = "k" THEN GOSUB REMOVE: GOTO IMPRIME
      IF OP$ = "V" OR OP$ = "v" THEN GOSUB VETCOMP: GOTO IMPRIME
      IF OP$ = "Z" OR OP$ = "z" THEN GOSUB ZERAVET: GOTO IMPRIME
      IF OP$ = "D" OR OP$ = "d" THEN GOSUB DELETA: GOTO IMPRIME
      IF OP$ = "B" OR OP$ = "b" THEN GOSUB ALTVET: GOTO MENU2
      IF OP$ = "I" OR OP$ = "i" THEN GOSUB INSERE: GOTO IMPRIME
      BEEP

IMPRIME:  IF P = 0 THEN P = 1
	  INICIO = P
	  FIM = N
	  FOR TELA = 1 TO 8
	    IF LN = 12 THEN LOCATE LN, 3: PRINT "Í ";
	    LOCATE LN, 5
	    TELA$(TELA) = ""
	    TELA$(TELA) = STR$(V(INICIO))
	    NUM$ = STRING$(5 - LEN(STR$(INICIO + AN - 1)), "0") + RIGHT$(STR$(INICIO + AN - 1), LEN(STR$(INICIO + AN - 1)) - 1)
	    PRINT " # "; NUM$; " : "; TELA$(TELA); STRING$(20, " ")
	    INICIO = INICIO + 1
	    IF INICIO > FIM THEN INICIO = 1
	    LN = LN + 1
	  NEXT TELA
26240 GOTO 26140

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                        ALTERA UM VALOR DE CADA VEZ                          '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ALTERA: IF P < 1 OR N < 1 THEN BEEP: RETURN
	LOCATE 22, 15: PRINT "Qual o novo valor #"; P + AN - 1
	LOCATE 22, 40: PRINT STRING$(12, "_")
	CODIGO$ = "13450572240": GOSUB TRTR
	AUX$ = LETRA$
	IF AUX$ = "" THEN GOSUB CANCELA: GOTO PERG1
	V(P) = VAL(AUX$)
PERG1:  GOSUB LIMPALINHA
	LOCATE LN, 5
	RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                        PRE-INSERCAO DE ELEMENTOS                            '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
INSERE:   IF P < 1 THEN P = 1
	  IF P > N THEN BEEP: RETURN
	  IF FLAG$ = "LINHA" THEN IF N = ML THEN BEEP: RETURN
	  IF FLAG$ = "COLUNA" THEN IF N = MC THEN BEEP: RETURN
	  'LOCATE 23,5:PRINT "P ";P, " N ";N
	  FOR K = N TO P STEP -1
	    V(K + 1) = V(K)
	  NEXT K
	  N = N + 1
PERG2:    LOCATE 22, 10: PRINT "Qual o valor a inserir #"; P + AN - 1
	  LOCATE 22, 40: PRINT STRING$(12, "_")
	  CODIGO$ = "13450572240": GOSUB TRTR
	  AUX$ = LETRA$
	  GOSUB LIMPALINHA
	  IF AUX$ <> "" THEN
			   V(P) = VAL(AUX$)
			   P = P + 1
			   GOTO INSERE
			  END IF
	  IF AUX$ = "" THEN
			 FOR K = P TO N - 1
			   V(K) = V(K + 1)
			 NEXT K
			 N = N - 1
		       END IF
	  LOCATE LN, 5
	  RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                        POS-INSERCAO DE ELEMENTOS                            '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
JUSTAPOS: IF P > N THEN BEEP: RETURN
	  IF FLAG$ = "LINHA" THEN IF N = ML THEN BEEP: RETURN
	  IF FLAG$ = "COLUNA" THEN IF N = MC THEN BEEP: RETURN
	  FOR K = N TO P STEP -1
	    V(K + 1) = V(K)
	  NEXT K
	  N = N + 1
	  P = P + 1
PERG3:    LOCATE 22, 10: PRINT "Qual o valor a inserir #"; P + AN - 1
	  LOCATE 22, 40: PRINT STRING$(12, "_")
	  CODIGO$ = "13450572240": GOSUB TRTR
	  AUX$ = LETRA$
	  GOSUB LIMPALINHA
	  IF AUX$ <> "" THEN
			   V(P) = VAL(AUX$)
			   GOTO JUSTAPOS
			 END IF
	  IF AUX$ = "" THEN
			 FOR K = P TO N - 1
			   V(K) = V(K + 1)
			 NEXT K
			 N = N - 1
			 P = P - 1
		       END IF
	  LOCATE LN, 5
	  RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                       DELETA UM VALOR DE CADA VEZ                           '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
DELETA: IF N < 1 OR P < 1 THEN BEEP: RETURN
	IF N = 1 THEN V(P) = 0: P = P - 1: RETURN
	FOR K = P TO N - 1
	  V(K) = V(K + 1)
	NEXT K
	N = N - 1
	P = P - 1
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
'                      IGUALA TODO O VETOR A UMA CONSTANTE                    '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ZERAVET: LOCATE 22, 20: PRINT " Qual o valor zero "
	 LOCATE 22, 40: PRINT STRING$(12, "_")
	 CODIGO$ = "13450572240": GOSUB TRTR
	 AUX$ = LETRA$
	 IF AUX$ = "" THEN GOSUB CANCELA: RETURN:
	 VP = VAL(AUX$)
	 GOSUB LIMPALINHA
	 FOR P = 1 TO N
	   V(P) = VP
	 NEXT P
	 P = P - 1
	 LOCATE LN, 5
	 RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                     INSERE TODOS OS VALORES DE UMA SO VEZ                   '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
VETCOMP: FOR P = 1 TO N
	   LOCATE 22, 10: PRINT "Qual o valor a inserir #"; P + AN - 1
	   LOCATE 22, 40: PRINT STRING$(12, "_")
	   CODIGO$ = "13450572240": GOSUB TRTR
	   AUX$ = LETRA$
	   IF AUX$ = "" THEN
			  FOR K = P TO N
			    V(K) = -999
			  NEXT K
			  GOSUB LIMPALINHA
			  GOTO PERG4
			END IF
	   V(P) = VAL(AUX$)
	   GOSUB LIMPALINHA
	 NEXT P
PERG4:   P = P - 1
	 LOCATE LN, 5
	 RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'               ALTERA TODO O VETOR                                           '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ALTVET: TEXTO$(1) = "   Esta rotina processa a lista contida na memoria, comparando cada"
	TEXTO$(2) = "item a uma constante. Os itens que  satisfizerem a  condicao  serao"
	TEXTO$(3) = "alterados de acordo com instrucoes a seguir."
	GOSUB JANELA1
	LOCATE 22, 10: PRINT "Qual a constante a qual a lista sera comparada "; STRING$(12, "_");
	CODIGO$ = "13450572257": GOSUB TRTR
	AUX$ = LETRA$
	C1 = VAL(AUX$)
	GOSUB LIMPALINHA
COND1:  LOCATE 22, 15: PRINT "Qual a condicao de alteracao ( > < = ) "; STRING$(1, "_")
	CODIGO$ = "02600622254": GOSUB TRTR
	C$ = LETRA$: GOSUB LIMPALINHA
	IF C$ <> "<" AND C$ <> ">" AND C$ <> "=" THEN GOTO COND1
	TEXTO$(1) = "   Os valores serao :     <A>dicionados por uma constante"
	TEXTO$(2) = "                           <E>liminados"
	TEXTO$(3) = "                            <M>ultiplicados por uma constante"
	TEXTO$(4) = "                             <S>ubstituidos por uma constante"
	GOSUB JANELA1
COND2:  LOCATE 8, 9: PRINT "Tecle opcao desejada "; STRING$(1, "_");
	CODIGO$ = "02651220830": GOSUB TRTR
	Z$ = LETRA$
	IF (Z$ <> "E" AND Z$ <> "e") AND (Z$ <> "S" AND Z$ <> "s") AND (Z$ <> "A" AND Z$ <> "a") AND (Z$ <> "M" AND Z$ <> "m") THEN
	     BEEP
	     GOTO COND2
	END IF
	IF Z$ = "E" OR Z$ = "e" THEN GOTO AQUI15
	LOCATE 9, 9: PRINT "Determine um operando "; STRING$(12, "_");
	CODIGO$ = "13450570931": GOSUB TRTR
	AUX$ = LETRA$
	C2 = VAL(AUX$)
AQUI15: LOCATE 22, 31: PRINT "Confirma opcao (S/N) ?"
	OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI15
	IF OP$ = "N" OR OP$ = "n" THEN RETURN
	IF OP$ = "S" OR OP$ = "s" THEN GOTO SEGUE
	BEEP: GOTO AQUI15
SEGUE:  IF Z$ = "E" OR Z$ = "e" THEN GOSUB ELIMINA
	IF Z$ = "S" OR Z$ = "s" THEN GOSUB SUBST
	IF Z$ = "A" OR Z$ = "a" THEN GOSUB ADICAO
	IF Z$ = "M" OR Z$ = "m" THEN GOSUB MULT
	RETURN

ELIMINA: IF C$ = "=" THEN TESTE = 1
	 IF C$ = "<" THEN TESTE = 2
	 IF C$ = ">" THEN TESTE = 3
LOP:     K = 0
	 FOR P = 1 TO N - 1
	   IF TESTE = 1 THEN
			IF V(P) = C1 THEN
				     IF V(P) = V(P + 1) THEN GOTO PROXIMO
				     V(P) = V(P + 1)
				     V(P + 1) = C1
				     K = 1
				   END IF
		      END IF
	   IF TESTE = 2 THEN
			IF V(P) < C1 THEN
				     IF V(P) >= V(P + 1) THEN GOTO PROXIMO
				     TROCA = V(P)
				     V(P) = V(P + 1)
				     V(P + 1) = TROCA
				     K = 1
				   END IF
		      END IF
	   IF TESTE = 3 THEN
			IF V(P) > C1 THEN
				     IF V(P) <= V(P + 1) THEN GOTO PROXIMO
				     TROCA = V(P)
				     V(P) = V(P + 1)
				     V(P + 1) = TROCA
				     K = 1
				   END IF
		      END IF
PROXIMO: NEXT P
	 IF K <> 0 THEN GOTO LOP
	 TROCA = 0
	 FOR P = 1 TO N
	   IF TESTE = 1 THEN IF V(P) = C1 THEN TROCA = TROCA + 1
	   IF TESTE = 2 THEN IF V(P) < C1 THEN TROCA = TROCA + 1
	   IF TESTE = 3 THEN IF V(P) > C1 THEN TROCA = TROCA + 1
	 NEXT P
	 N = N - TROCA
	 IF N < 1 THEN
		    GOSUB LIMPALINHA
		    LOCATE 22, 32
		    BEEP
		    PRINT "Vetor encerrado"
		    GOSUB TEMPO
		    V(1) = 0
		    RETURN
		  END IF
	 RETURN

SUBST: FOR K = 1 TO N
	IF C$ = "<" AND V(K) < C1 OR C$ = "=" AND V(K) = C1 OR C$ = ">" AND V(K) > C1 THEN V(K) = C2
      NEXT K
      RETURN

ADICAO: FOR K = 1 TO N
	 IF C$ = "<" AND V(K) < C1 OR C$ = "=" AND V(K) = C1 OR C$ = ">" AND V(K) > C1 THEN V(K) = V(K) + C2
       NEXT K
       RETURN

MULT: FOR K = 1 TO N
	IF C$ = "<" AND V(K) < C1 OR C$ = "=" AND V(K) = C1 OR C$ = ">" AND V(K) > C1 THEN V(K) = V(K) * C2
      NEXT K
      RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                               Final Parte 3                             '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'  Parte 4: Rotinas Auxiliares                                            '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'               LIMPA TELA                                                    '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
LIMPATELA: FOR LIMPA = 4 TO 23
	     IF LIMPA = 10 THEN IF APAGA = 1 THEN GOTO PULALIMPA
	     LOCATE LIMPA, 2
	     PRINT STRING$(78, " ")
PULALIMPA: NEXT LIMPA
	   RETURN

MEIATELA:  FOR LIMPA = 11 TO 23
	     LOCATE LIMPA, 2
	     PRINT STRING$(78, " ")
	   NEXT LIMPA
	   RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'               LIMPA LINHA 22                                                '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
LIMPALINHA: LOCATE 22, 2: PRINT STRING$(78, " "); : RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                         DIRETORIO                                       '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
DIRETORIO: GOSUB LIMPATELA
       TECLA$ = "4": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
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
'       IF DRIVE$="B" OR DRIVE$="b" THEN GOSUB BARRA:FILES"B:":GOTO VOLTA
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

JANELA1: FOR TESTE = 4 TO 9
	   LOCATE TESTE, 2
	   PRINT STRING$(78, " ");
	   LOCATE TESTE, 6
	   PRINT TEXTO$(TESTE - 3)
	   TEXTO$(TESTE - 3) = ""
	 NEXT TESTE
	 RETURN

TEMPO:  FOR TESTE = 1 TO 8000: NEXT TESTE: RETURN

CANCELA: GOSUB LIMPALINHA
	 LOCATE 22, 31
	 PRINT "OPERACAO CANCELADA"
	 GOSUB TEMPO
	 GOSUB LIMPALINHA
	 RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                          TRATAMENTO DE ERROS                                '
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
'         LOCATE 23,16:PRINT ERR;:GOSUB TEMPO
	 IF SOM = 0 THEN TESERRO = 0
	 IF SOM = 1 THEN BEEP: GOSUB TEMPO
	 RESUME NEXT

     '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '                        TECLAS VALIDAS                                   '
     '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
VALIDO: TECLAVAL$ = "12345"
	KK = 1: JJ = 1
	ATX = &H10
	LINHA$ = "           _F1  Ajuda   _F2  Diretorio   _F3  Drive   _F4  Encerrar                     "
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
AJUDA: IF CONTHELP > 35 THEN CONTHELP = 1
       LOCATE 24, 46: PRINT STRING$(21, 205);
       TECLA$ = "4": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
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
     '                   TESTA VALIDADE DO NOME DO ARQUIVO                     '
     '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
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

