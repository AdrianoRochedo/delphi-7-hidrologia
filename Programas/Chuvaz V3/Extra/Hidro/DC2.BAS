'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' PROGRAMA  : DC.BAS                                                          '
' Adaptado por Juan Santiago
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     CLS
     ON ERROR GOTO ERROS
     DIM TEXTO$(15), TELA$(8), HELP$(30), BUFFER$(250)
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
     HELP$(16) = "    SOBRE OS PREFIXOS   "
     HELP$(17) = "      NOS ARQUIVOS      "
     HELP$(18) = "     ( 5I ) ==> Q95-    "
     HELP$(19) = "     ( 5S ) ==> Q95+    "
     HELP$(20) = "     ( 9I ) ==> Q99-    "
     HELP$(21) = "    SOBRE OS PREFIXOS   "
     HELP$(22) = "      NOS ARQUIVOS      "
     HELP$(23) = "     ( 9S ) ==> Q99+    "
     HELP$(24) = "     ( QR ) ==> QREG    "
     HELP$(25) = "                        "
     HELP$(26) = "     SOBRE OS ERROS     "
     HELP$(27) = "   Quando for  provocado"
     HELP$(28) = "um  erro  aparecera  na "
     HELP$(29) = "tela uma mensagem  sobre"
     HELP$(30) = "este erro.              "

     DIM AR$(1000), AI$(1000)
     DIM TE$(8), TE(8), TS$(8), CQ(2), B(100), A(100), EXT$(5)
     DIM A$(1000), V$(1000), T(1000)
     FOR TESTE = 0 TO 15
       TEXTO$(TESTE) = ""
     NEXT TESTE
     FOR TESTE = 0 TO 8
       TELA$(TESTE) = ""
     NEXT TESTE
     VEZ = 0
     APAGA = 0
     CONTHELP = 1
     GOSUB DESENTELA
     LOCATE 6, 23: PRINT "Instituto de Pesquisas Hidraulicas"
     LOCATE 8, 20: PRINT "Universidade Federal do Rio Grande do Sul"
     LOCATE 10, 15: PRINT "PROGRAMA PARA:"
     LOCATE 11, 15: PRINT "* ESTIMATIVAS DE VALORES COM TEMPO DE RETORNO DADO"
     LOCATE 12, 15: PRINT "* ESTIMATIVA DE CURVA DE FREQUENCIA REGIONAL "
     LOCATE 13, 15: PRINT "* GRAVACAO DE ARQUIVO PARA GRAFICACAO"
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
      A1$ = "SEM NOME"
      A2$ = "SEM NOME"
      APAGA = 1
      FOR I = 21 TO 3 STEP -1
	LOCATE 2, I
	PRINT "SISTEMA DE REGIONALIZACAO HIDROLOGICA VRS. 1.0 "
	FOR J = 1 TO 20
	NEXT J
      NEXT I
      LOCATE 1, 50: PRINT CHR$(203)
      LOCATE 2, 50: PRINT CHR$(186)
      LOCATE 10, 1: PRINT CHR$(204); STRING$(78, 205); CHR$(185);
      DEF SEG = &HB800
      FOR I = 163 TO 257 STEP 2
	POKE I, &H13
      NEXT I
      DEF SEG

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                          INICIALIZA VARIAVEIS                               '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    WIDTH "LPT1:", 132
    BC$ = STRING$(80, " ")
    T(1) = 2
    T(2) = 5
    FOR J = 1 TO 10: T(J + 2) = J * 10: NEXT J
    NT = 12
    TE$(1) = "LINEAR      "
    TE$(2) = "LOG(E)      "
    TE$(3) = "EXTREMOS    "
    TE$(4) = "NORMAL      "
    TE$(5) = "GAMA-3      "
    TE(1) = 1
    TE(2) = 1

MENUP: ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
       '                          MENU PRINCIPAL                              '
       ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     TECLA$ = "12345": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
     LOCATE 3, 50: PRINT CHR$(206)
     LOCATE 4, 50: PRINT CHR$(186)
     LOCATE 5, 50: PRINT CHR$(200); STRING$(29, 205); CHR$(185);
     LOCATE 4, 5: PRINT "Determinacao de Distribuicao Regional"
     LOCATE 5, 5: PRINT "1.  Edita Postos da Curva Individual"
     LOCATE 6, 5: PRINT "2.  Edita Postos da Curva Regional"
     LOCATE 7, 5: PRINT "3 . Edita Tempo de Retorno"
EIXO: LOCATE 8, 5: PRINT "4.  Transformacao Eixo X (Tempo de retorno)  : "; TE$(TE(1))
      LOCATE 9, 5: PRINT "5.  Transformacao Eixo Y (Variavel aleatoria): "; TE$(TE(2))
     LOCATE 24, 46: PRINT CHR$(175); " OPCAO "; CHR$(174);
AQUI2: LOCATE 2, 58: PRINT MUD$; A1$; STRING$(13 - LEN(A1$), 32)
      LOCATE 4, 58: PRINT MUD$; A2$; STRING$(13 - LEN(A2$), 32)
      LOCATE 23, 10
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
AQUI0:                         LOCATE 12, 29
			       PRINT "Confirma opcao (S/N) ?"
			       OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI0
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
	IF MID$(OP$, 2, 1) = "@" THEN EXEC = EXEC + 1: BUF = 0: TECLA$ = "": OUTROS = 0: GOSUB VALIDO: GOTO INICIO
	IF MID$(OP$, 2, 1) = "A" THEN
			       IF IMPRESSAO = 0 THEN
						  IMPRESSAO = 1
						  IF OUTROS = 0 THEN OUTROS = 1
						  IF GRAVA = 0 THEN TECLA$ = "124"
						  IF GRAVA = 1 THEN TECLA$ = "12"
						  IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO: GOTO AQUI2
						END IF
			       IF IMPRESSAO = 1 THEN
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
      IF OP$ = "1" THEN
			      I$ = "** ARQUIVOS PARA CURVA LOCAL **"
			      FOR I = 1 TO NI
				V$(I) = AI$(I)
			      NEXT I
			      N = NI
			      A$ = A1$
			      GOSUB MENU2
			      A1$ = A$
			      FOR I = 1 TO N
				AI$(I) = V$(I)
			      NEXT I
			      NI = N
			      AI$(0) = A$
			      GOTO MENUP
			    END IF
      IF OP$ = "2" THEN
			      I$ = "** ARQUIVOS PARA CURVA REGIONAL **"
			      FOR I = 1 TO NR
				V$(I) = AR$(I)
			      NEXT I
			      N = NR
			      A$ = A2$
			      GOSUB MENU2
			      A2$ = A$
			      FOR I = 1 TO N
				AR$(I) = V$(I)
			      NEXT I
			      NR = N
			      AR$(0) = A$
			      GOTO MENUP
			    END IF
      IF OP$ = "3" THEN
			      I$ = "** TEMPO DE RETORNO **"
			      N = NT
			      FOR I = 1 TO NT
				V$(I) = STR$(T(I))
			      NEXT I
			      A$ = "SEM NOME"
			      GOSUB MENU2
			      NT = N
			      FOR I = 1 TO NT
				T(I) = VAL(V$(I))
			      NEXT I
			      GOTO MENUP
			    END IF
      IF OP$ = "4" THEN
			      IF TE(1) < 5 THEN TE(1) = TE(1) + 1
			      IF TE(1) = 5 THEN TE(1) = 1
			      GOTO EIXO
			    END IF
      IF OP$ = "5" THEN
			      IF TE(2) = 1 THEN TE(2) = 2: GOTO EIXO
			      IF TE(2) = 2 THEN TE(2) = 1: GOTO EIXO
			    END IF
      BEEP: GOTO MENUP

INICIO: ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
       '                          INICIO DO PROGRAMA                          '
       ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	GOSUB MEIATELA
	IF GRAVA = 0 THEN
VAI1:                  LOCATE 15, 2: PRINT STRING$(78, " ");
		       LOCATE 15, 6: PRINT "Qual o nome do arquivo em que sera gravado o relatorio "
		       LOCATE 15, 61: PRINT STRING$(12, "_")
		       CODIGO$ = "13321221561": GOSUB TRTR
		       AUX$ = LETRA$
		       IF AUX$ = "" THEN AUX$ = "SEM NOME"
		       IF AUX$ = "SEM NOME" THEN GOSUB CANCELA: LOCATE 15, 2: PRINT STRING$(78, " "); : GOTO MENUP
		       YYY$ = AUX$: GOSUB VALIDADE: AUX$ = YYY$: IF ERG = 101 THEN GOSUB ERGS: GOTO VAI1
		       ARQREL$ = AUX$
		       LOCATE 15, 2: PRINT STRING$(78, " ");
		     END IF

      IF NR = 0 AND NI = 0 THEN
			     GOSUB MEIATELA
			     LOCATE 15, 24
			     PRINT "NAO HA POSSIBILIDADE DE EXECUCAO"
			     BEEP
			     LOCATE 24, 46: PRINT CHR$(175); " Tecle << ENTER >> "; CHR$(174);
AQUI6:                       OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI6
			     IF ASC(OP$) <> 13 THEN BEEP: GOTO AQUI6
			     LOCATE 24, 46: PRINT STRING$(21, 205);
			     GOSUB MEIATELA
			     OUTROS = 0: GOTO MENUP
			   END IF
      IF NR = 0 THEN
		  FOR I = 0 TO NI
		    AR$(I) = AI$(I)
		  NEXT I
		  NR = NI
		  GOTO CHAMADEF
		END IF
      IF NI = 0 THEN
		  FOR I = 0 TO NR
		    AI$(I) = AR$(I)
		  NEXT I
		  NI = NR
		  GOTO CHAMADEF
		END IF
      IF NI = NR THEN GOTO CHAMADEF
      LOCATE 14, 15: PRINT "O numero de estacoes para o calculo da CURVA REGIONAL"
      LOCATE 15, 15: PRINT "deve ser igual para o calculo das CURVAS INDIVIDUAIS."
      LOCATE 16, 15: PRINT "Reedite uma das listas."
      BEEP
      LOCATE 24, 46: PRINT CHR$(175); " Tecle << ENTER >> "; CHR$(174);
AQUI: OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI
      IF ASC(OP$) <> 13 THEN BEEP: GOTO AQUI
      LOCATE 24, 46: PRINT STRING$(21, 205);
      GOSUB MEIATELA
      GOTO MENUP

CHAMADEF:  ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	   '            CHAMA DEFINICAO DAS FUNCOES                           '
	   ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
      GOSUB DEFINE

     ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '                   DIMENSIONA                                           '
     ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     IF EXEC = 1 THEN
		   DIM X(NR, 100), Q(NR, 100), EP(NT), QI(4, NT), QR(NT)
		   DIM L(NT + 1), L$(NT + 1), TC(NT + 1)
		 END IF
     IF EXEC > 1 THEN
		   REDIM X(NR, 100), Q(NR, 100), EP(NT), QI(4, NT), QR(NT)
		   REDIM L(NT + 1), L$(NT + 1), TC(NT + 1)
		 END IF
     GOTO CR

DEFINE: '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'               DEFINICAO DAS FUNCOES                                 '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
       FLAGDEF = 0
       FLAGGAUSS = 0
FUNCAUX: '                ** FUNCOES AUXILIARES **
       DEF FNFF (X) = X - (2.515517 + .802853 * X + .010328 * X ^ 2) / (1 + 1.432788 * X + .189269 * X ^ 2 + .001308 * X ^ 3)
       DEF FNFW (X) = SQR(LOG(1 / X ^ 2))
       IF FLAGDEF = 1 THEN RETURN

15000 DEF FNFU (X)
       IF TE(1) = 1 THEN FNFU = X: '        ** X LINEAR **
       IF TE(1) = 2 THEN FNFU = LOG(X): '   ** X LOG    **
       IF TE(1) = 3 THEN FNFU = LOG(-LOG(1 - 1 / X)):  ' ** X GUMBEL **
       IF TE(1) = 4 THEN FNFU = -1 * FNFF(FNFW(1 - 1 / X)): FLAGDEF = 1: '** GAUSS **
      END DEF

      DEF FNFV (X)
       IF TE(1) = 1 THEN FNFV = X: '        ** X LINEAR **
       IF TE(1) = 2 THEN FNFV = LOG(X): '   ** X LOG    **
       IF TE(1) = 3 THEN FNFV = LOG(-LOG(1 - 1 / X)):  '    ** X GUMBEL **
       IF TE(1) = 4 THEN FNFV = FNFF(FNFW(1 / X)): FLAGDEF = 1: ' ** GAUSS **
      END DEF

      IF FLAGDEF = 1 THEN GOSUB FUNCAUX: FLAGDEF = 0
      IF FLAGGAUSS = 1 THEN RETURN
      IF TE(1) <> 5 THEN GOTO TE2

      DEF FNFP (X) = 2 / ASS1 * ((1 - (ASS1 / 6) ^ 2 + (ASS1 / 6) * X) ^ 3 - 1)

      IF TE(1) = 5 THEN FLAGGAUSS = 1: TE(1) = 4: GOSUB 15000: TE(1) = 5: FLAGGAUSS = 0
TE2:  ' ** IF TE(2)=3 THEN GOSUB MENUP:RETURN
      ' ** IF TE(2)=4 THEN GOSUB MENUP:RETURN
      ' ** IF TE(2)=5 THEN GOSUB MENUP:RETURN

      DEF FNFY (X)
       IF TE(2) = 1 THEN FNFY = X: '          ** Y LINEAR **
       IF TE(2) = 2 THEN FNFY = LOG(X): '   ** Y LOG    **
       ' ** IF TE(2)=6 THEN FNFY = (X ^ ZT - 1) / ZT:' ** Y POTENCIA **
       ' ** IF TE(2)=7 THEN FNFY = LOG (ZT - X):' ** Y LOG C/ LIM SUP **
       ' ** IF TE(2)=8 THEN FNFY = LOG (X - ZT):' ** Y LOG C/ LIM INF **
      END DEF

      DEF FNFK (X)
       IF TE(2) = 1 THEN FNFK = X: '          ** Y LINEAR **
       IF TE(2) = 2 THEN FNFK = EXP(X): '   ** Y LOG    **
       ' ** IF TE(2)=6 THEN FNFK = (X * ZT + 1) ^ (1 / ZT):' ** Y POTENCIA **
       ' ** IF TE(2)=7 THEN FNFK = ZT - EXP (X):' ** Y C/ LIM SUP **
       ' ** IF TE(2)=8 THEN FNFK = EXP (X) + ZT:' ** Y C/ LIM INF **
      END DEF
      RETURN

     ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '                   CURVA REGIONAL                                       '
     ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
CR:  GOSUB LEITAR
     IF TESERRO = 1 THEN TESERRO = 0: GOSUB MEIATELA: GOTO MENUP
2050 PR = 0: GOSUB RLCREG
     FOR J = 1 TO NT
       IF T(J) < 2 THEN QR(J) = FNFK(AR + BR * FNFU(T(J)))
       IF T(J) >= 2 THEN QR(J) = FNFK(AR + BR * FNFV(T(J)))
     NEXT J

     ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '                   CURVA INDIVIDUAL                                     '
     ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     'LOCATE 12,15:PRINT "DETERMINANDO CURVAS INDIVIDUAIS.."
     NC = 5: GOSUB IMPINIT
     FLAG = 6: GOSUB IMPINIT
     FLAG = 8: GOSUB IMPINIT
     IF IMPRESSAO = 0 THEN T$ = CHR$(15): FLAG = 2: GOSUB IMPPADRAO
     FLAG = 4: GOSUB IMPPADRAO
     L$(1) = "CURVAS LOCAIS"
     L$(2) = "A"
     L$(3) = "B"
     L$(4) = "R2"
     L$(5) = "PONTOS"
     FLAG = 1: GOSUB IMPPADRAO
     FLAG = 4: GOSUB IMPPADRAO
     I = 0
LOOP1: I = I + 1
     IF AR$(I) <> AI$(I) THEN GOSUB LEITAI
     IF TESERRO = 1 THEN TESERRO = 0: GOSUB MEIATELA: GOTO MENUP
3190 GOSUB RLCIND
     L$(1) = AI$(I)
     Z = A(I): GOSUB ARREDO
     L$(2) = Z$
     Z = B(I): GOSUB ARREDO
     L$(3) = Z$
     Z = R2: GOSUB ARREDO
     L$(4) = Z$
     Z = X(I, 0): GOSUB ARREDO
     L$(5) = Z$
     FLAG = 1: GOSUB IMPPADRAO
     IF I < NI THEN GOTO LOOP1
     FLAG = 4: GOSUB IMPPADRAO

     ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '                   IMP CURVA REGIONAL                                   '
     ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     L$(1) = "CURVA REGIONAL"
     Z = AR: GOSUB ARREDO
     L$(2) = Z$
     Z = BR: GOSUB ARREDO
     L$(3) = Z$
     Z = RR: GOSUB ARREDO
     L$(4) = Z$
     Z = PR: GOSUB ARREDO
     L$(5) = Z$
     FLAG = 1: GOSUB IMPPADRAO
     FLAG = 4: GOSUB IMPPADRAO
     FLAG = 3: GOSUB IMPPADRAO

     ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '                   SEGUNDA TABELA                                       '
     ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     V$(1) = "Q95-": EXT$(1) = "5I"
     V$(2) = "Q95+": EXT$(2) = "5S"
     V$(3) = "Q99-": EXT$(3) = "9I"
     V$(4) = "Q99+": EXT$(4) = "9S"
     T$ = "ERRO PADRAO REGIONAL": NEG = 1
     FLAG = 2: GOSUB IMPPADRAO
     FLAG = 3: GOSUB IMPPADRAO: NEG = 0
     MKL = NT / 6
     IF MKL > 1 THEN AUXL = NT: NT = 6
     GWL = 1
     NC = NT + 1
     TC(1) = 20
LPLP: Z = 8
     FOR I = GWL TO NT
       TC(I + 1) = Z
     NEXT I
     FLAG = 6: GOSUB IMPINIT
     FLAG = 8: GOSUB IMPINIT
     FLAG = 4: GOSUB IMPPADRAO
     L$(1) = "ESTACAO"
     RT = 0
     FOR I = GWL TO NT
       RT = RT + 1
       L$(RT + 1) = STR$(T(I))
     NEXT I
     FLAG = 1: GOSUB IMPPADRAO
     FLAG = 4: GOSUB IMPPADRAO
     FOR I = 1 TO NI
       L$(1) = AI$(I): RT = 0
       FOR J = GWL TO NT
	 RT = RT + 1
	 IF T(J) < 2 THEN QE = FNFK(A(I) + B(I) * FNFU(T(J)))
	 IF T(J) >= 2 THEN QE = FNFK(A(I) + B(I) * FNFV(T(J)))
	 Z = QE: GOSUB ARREDO
	 L$(RT + 1) = Z$
	 EP(J) = EP(J) + (QE - QR(J)) ^ 2
       NEXT J
       FLAG = 1: GOSUB IMPPADRAO
     NEXT I
     MKL = MKL - 1
     FLAG = 4: GOSUB IMPPADRAO
     L$(1) = "QREG": EXT$(5) = "QR"
     RT = 0
     FOR J = GWL TO NT
       RT = RT + 1
       Z = QR(J): GOSUB ARREDO
       L$(RT + 1) = Z$
     NEXT J
     FLAG = 1: GOSUB IMPPADRAO
     L$(1) = "ERRO PADRAO"
     RT = 0
     FOR J = GWL TO NT
       RT = RT + 1
       EP(J) = SQR(EP(J) / NI)
       Z = EP(J): GOSUB ARREDO
       L$(RT + 1) = Z$
     NEXT J
     FLAG = 1: GOSUB IMPPADRAO
     CQ(1) = 1.96
     CQ(2) = 2.576
     FOR I = 1 TO 4
       L$(1) = V$(I): RT = 0
       FOR J = GWL TO NT
	 RT = RT + 1
	 Z = QR(J) + (-1) ^ I * CQ(INT((I + 1) / 2)) * EP(J): GOSUB ARREDO
	 QI(I, J) = Z
	 L$(RT + 1) = Z$
       NEXT J
       FLAG = 1: GOSUB IMPPADRAO
     NEXT I
     IF MKL > 0 THEN
		  GWL = GWL + 6: NT = NT + 6
		  IF NT > AUXL THEN NT = AUXL
		  GOTO LPLP
		END IF
     FLAG = 4: GOSUB IMPPADRAO
VAI2: IF GRAVA = 0 THEN
		    FOR BUF = 1 TO 250
		      IF BUFFER$(BUF) <> " " THEN GOSUB GRARELAT: GOTO VAI3
		    NEXT BUF
		  END IF

VAI3: ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '                   GRAVA ARQUIVOS PARA PLOTTER                          '
     ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
       GOSUB MEIATELA
       LOCATE 15, 20: PRINT "Gravar Arquivos para Graficador (S/N) ?"
AQUI4: OP$ = INKEY$: IF OP$ = "" GOTO AQUI4
       IF OP$ = "N" OR OP$ = "n" THEN GOSUB MEIATELA: OUTROS = 0: GOTO MENUP
       IF OP$ = "S" OR OP$ = "s" THEN GOTO AQUI5
       BEEP: GOTO AQUI4
AQUI5: FOR I = 1 TO 4
	 LIXO$ = AR$(0): ARR$ = AR$(0)
	 LIXO$ = LEFT$(LIXO$, INSTR(LIXO$, ".") - 1)
	 IF LEN(LIXO$) = 8 THEN
			   ARR$ = LEFT$(AR$(0), INSTR(AR$(0), ".") - 3) + MID$(AR$(0), INSTR(AR$(0), "."), LEN(AR$(0)))
			END IF
	 ARR$ = EXT$(I) + ARR$
	 ARQUIVO$ = MUD$ + ARR$
	 OPEN ARQUIVO$ FOR OUTPUT AS #1
	 IF TESERRO = 1 THEN GOSUB CANCELA: OUTROS = 0: GOTO MENUP
	 PRINT #1, NT
	 PRINT #1, 2
	 FOR J = 1 TO NT
	   PRINT #1, T(J)
	   PRINT #1, QI(I, J)
	 NEXT J
	 CLOSE #1
       NEXT I
       LIXO$ = AR$(0): ARR$ = AR$(0)
       LIXO$ = LEFT$(LIXO$, INSTR(LIXO$, ".") - 1)
       IF LEN(LIXO$) = 8 THEN
			 ARR$ = LEFT$(AR$(0), INSTR(AR$(0), ".") - 3) + MID$(AR$(0), INSTR(AR$(0), "."), LEN(AR$(0)))
		       END IF
       ARR$ = EXT$(I) + ARR$
       ARQUIVO$ = MUD$ + ARR$
       OPEN ARQUIVO$ FOR OUTPUT AS #1
       IF TESERRO = 1 THEN GOSUB CANCELA: OUTROS = 0: GOTO MENUP
       PRINT #1, NT
       PRINT #1, 2
       FOR J = 1 TO NT
	 PRINT #1, T(J)
	 PRINT #1, QR(J)
       NEXT J
       CLOSE #1
       GOSUB MEIATELA: OUTROS = 0: GOTO MENUP

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                          ARREDONDAMENTO                                     '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ARREDO: Z = INT(1000 * Z + .5) / 1000
       Z$ = STR$(Z)
       RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                          INIT IMPRESSAO                                     '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
IMPINIT: IF FLAG = 8 THEN FLAG = 0: TT$ = " ": RETURN
      IF FLAG = 9 THEN FLAG = 0: TT$ = "!": RETURN
      IF FLAG = 7 THEN FLAG = 0: Z$ = "+": GOSUB 20120: RETURN
      IF FLAG = 6 THEN FLAG = 0: Z$ = "-": GOSUB 20120: RETURN

      ' ** COLUNAS DE IGUAL TAMANHO **
      FOR K = 1 TO NC
	TC(K) = INT(79 / NC) - 1
      NEXT K
      RETURN

20120 ' ** TRACO DE TABELA **
      TR$ = Z$
      FOR I = 1 TO NC
	FOR J = 1 TO TC(I)
	  TR$ = TR$ + "-"
	NEXT J
	TR$ = TR$ + Z$
      NEXT I
      RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                            IMPRESSAO PADRAO                                 '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
IMPPADRAO: IF FLAG = 1 THEN FLAG = 0: T$ = TT$: GOTO 21110
	  IF FLAG = 2 THEN FLAG = 0: GOTO 21170
	  IF FLAG = 3 THEN FLAG = 0: T$ = " ": GOTO 21170
	  IF FLAG = 4 THEN FLAG = 0: T$ = TR$: GOTO 21170
      T$ = TT$
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
21170  ERG = 100: IF GRAVA = 0 THEN BUF = BUF + 1: BUFFER$(BUF) = T$
       IF BUF = 250 THEN GOSUB GRARELAT
       IF IMPRESSAO = 1 THEN T$ = " ": ERG = 0: RETURN
' linha seguinte anulada para nao utilizar impressora
'       IF NEG = 0 THEN LPRINT T$ ELSE GOSUB NEGRITO
       IF TESERRO = 1 THEN TESERRO = 0: GOSUB LIMPALINHA: GOTO 21170
       T$ = " ": ERG = 0
       RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                   REGRESSAO LINEAR ( CURVA REGIONAL )                       '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
RLCREG: 'LOCATE 15,15:PRINT "CURVA REGIONAL"
       G = 0: H = 0: M = 0: RR = 0
       FOR I = 1 TO NR
	 FOR J = 1 TO X(I, 0)
	   G = G + X(I, J)
	   H = H + Q(I, J)
	   L = L + X(I, J) ^ 2
	   M = M + Q(I, J) ^ 2
	   RR = RR + X(I, J) * Q(I, J)
	   PR = PR + 1
	 NEXT J
       NEXT I
       BR = (PR * RR - G * H) / (PR * L - G ^ 2)
       AR = (H - BR * G) / PR
       G = BR * (RR - G * H / PR)
       M = M - H ^ 2 / PR
       H = M - G
       RR = G / M
       RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                   REGRESSAO LINEAR ( CURVA INDIVIDUAL )                     '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
RLCIND: G = 0: H = 0: L = 0: M = 0: R2 = 0
       T$ = "REDUCAO: " + TE$(TE(1)) + "/" + TE$(TE(2))
       FOR J = 1 TO X(I, 0)
	 L(1) = J
	 L(2) = X(I, J)
	 L(3) = Q(I, J)
	 G = G + X(I, J)
	 H = H + Q(I, J)
	 L = L + X(I, J) ^ 2
	 M = M + Q(I, J) ^ 2
	 R2 = R2 + X(I, J) * Q(I, J)
       NEXT J
       B(I) = (X(I, 0) * R2 - H * G) / (X(I, 0) * L - G ^ 2)
       A(I) = (H - B(I) * G) / X(I, 0)
       G = B(I) * (R2 - G * H / X(I, 0))
       M = M - H ^ 2 / X(I, 0)
       H = M - G
       R2 = G / M
       RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                           ASSIMETRIA / CR                                   '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' ******  NINGUEM CHAMA ESTA ROTINA ***********
ASSIMCR: MD = 0: S1 = 0: S2 = 0: Z = 0
	FOR I = 1 TO NR
	  FOR J = 1 TO X(I, 0)
	    MD = MD + Q(I, J)
	    Z = Z + 1
	  NEXT J
	NEXT I
	MD = MD / Z
	FOR I = 1 TO NR
	  FOR J = 1 TO X(I, 0)
	    S1 = S1 + (Q(I, J) - MD) ^ 2
	    S2 = S2 + (Q(I, J) - MD) ^ 3
	  NEXT J
	NEXT I
	DP = (S1 / (Z - 1)) ^ .5
	ASS1 = (Z * S2) / ((Z - 1) * (Z - 2) * (DP ^ 3))
	RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                           ASSIMETRIA / CI                                   '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ASSIMCI: MD = 0: S1 = 0: S2 = 0
	FOR J = 1 TO X(I, 0)
	  MD = MD + Q(I, J)
	NEXT J
	MD = MD / X(I, 0)
	FOR J = 1 TO X(I, 0)
	  S1 = S1 + (Q(I, J) - MD) ^ 2
	  S2 = S2 + (Q(I, J) - MD) ^ 3
	NEXT J
	DP = (S1 / (X(I, 0) - 1)) ^ .5
	ASS1 = (X(I, 0) * S2) / ((X(I, 0) - 1) * (X(I, 0) - 2) * (DP ^ 3))
	RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                           LEITURA ARQUIVOS AR$(I)                           '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
LEITAR: LOCATE 12, 30: PRINT "LEITURA DE ARQUIVOS"
       GOSUB TESTDRIVE: IF TESERRO = 1 THEN GOSUB CANCELA: RETURN
       LOCATE 24, 46: PRINT STRING$(21, 205);
       I = 0
27060  I = I + 1
       LIMPA = (80 - (14 + LEN(AR$(I)))) / 2
       LOCATE 13, 2: PRINT STRING$(78, " ");
       LOCATE 13, LIMPA: PRINT "ARQUIVO ("; I; ") "; AR$(I)
       ARQUIVO$ = MUD$ + AR$(I)
       OPEN ARQUIVO$ FOR INPUT AS #1
       IF TESERRO = 1 THEN GOSUB CANCELA: CLOSE #1: RETURN
       INPUT #1, X(I, 0)
       INPUT #1, Z
       FOR J = 1 TO X(I, 0)
	 INPUT #1, X(I, J)
	 INPUT #1, Q(I, J)
       NEXT J
       CLOSE #1
       IF I < NR THEN GOTO 27060
       FOR I = 1 TO NR
	 GOSUB REDVAR: ' 29000
       NEXT I
       RETURN: ' GOTO 2050

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                           LEITURA ARQUIVOS AI$(I)                           '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
LEITAI: LOCATE 12, 30: PRINT "LEITURA DE ARQUIVOS"
       GOSUB TESTDRIVE: IF TESERRO = 1 THEN GOSUB CANCELA: RETURN
       LOCATE 24, 46: PRINT STRING$(21, 205);
       LIMPA = (80 - (14 + LEN(AI$(I)))) / 2
       LOCATE 13, 2: PRINT STRING$(78, " ");
       LOCATE 13, LIMPA: PRINT "ARQUIVO ("; I; ") "; AI$(I)
       ARQUIVO$ = MUD$ + AI$(I)
       OPEN ARQUIVO$ FOR INPUT AS #1
       IF TESERRO = 1 THEN GOSUB CANCELA: CLOSE #1: RETURN
       INPUT #1, X(I, 0)
       INPUT #1, Z
       FOR J = 1 TO X(I, 0)
	 INPUT #1, X(I, J)
	 INPUT #1, Q(I, J)
       NEXT J
       CLOSE #1
       GOSUB REDVAR: ' 29000
       RETURN: ' GOTO 3190

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                           REDUZ VARIAVEIS                                   '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
REDVAR: IF TE(1) = 5 THEN GOSUB ASSIMCI: ' 25500
	FOR J = 1 TO X(I, 0)
	  IF X(I, J) < 2 THEN X(I, J) = FNFU(X(I, J))
	  IF X(I, J) >= 2 THEN X(I, J) = FNFV(X(I, J))
	  IF TE(1) = 5 THEN X(I, J) = FNFP(X(I, J))
	  Q(I, J) = FNFY(ABS(Q(I, J)))
	NEXT J
	RETURN
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                                 EDICAO                                            '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
MENU2: LOCATE 3, 50: PRINT CHR$(202): LOCATE 5, 80: PRINT CHR$(186)
      GOSUB LIMPATELA
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
26140 IF P > N THEN P = 1
      IF P < 1 THEN P = N
      LN = CSRLIN
26157 IF LN > 19 THEN LN = 12
AQUI3: OUTROS = 0: TECLA$ = "1234": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
      LOCATE 2, 58: PRINT MUD$; A$; STRING$(13 - LEN(A$), 32)
      LOCATE 23, 10
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
      IF OP$ = "+" THEN
				  P = P + 1
				  IF P > N THEN P = 1
				  GOTO IMPRIME
				END IF
      IF OP$ = "-" THEN
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
'                    ALTERA UM VALOR DE CADA VEZ                              '
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
'                     PRE-INSERCAO DE UM VALOR                                '
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
'                        DELETA UM VALOR DE CADA VEZ                          '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
DELETA: IF N < 1 OR P < 1 THEN BEEP: RETURN
	IF N = 1 THEN V$(P) = "": P = P - 1: RETURN
	FOR K = P TO N - 1
	  V$(K) = V$(K + 1)
	NEXT K
	N = N - 1
	P = P - 1
	RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                     TROCA EXTENSAO                                          '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
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

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                        POS-INSERCAO DE UM VALOR                             '
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
	  LOCATE LN, 5
	  RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                        GRAVACAO DA MATRIZ                                   '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SALVA: LOCATE 22, 15: PRINT "Qual o nome do arquivo "; STRING$(12, "_")
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
'                         CARREGA MATRIZ                                      '
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
	  IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: GOTO 26850
	  INPUT #1, N, Z
	  FOR I = 1 TO N
	    INPUT #1, V$(I)
	  NEXT I
	  CLOSE #1
	  A$ = AUX$
	  P = 1
	  LOCATE 22, 15: PRINT "ARQUIVO CARREGADO !! "
	  GOSUB TEMPO
26850     GOSUB MEIATELA: LOCATE 12, 5
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
       IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: GOTO 26860
       LOCATE 22, 15: PRINT "ARQUIVO REMOVIDO !! "
       GOSUB TEMPO
26860  GOSUB MEIATELA: LOCATE 12, 5
       RETURN

     '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '                         DIRETORIO                                       '
     '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
DIRETORIO: LOCATE 3, 50: PRINT CHR$(202): LOCATE 5, 80: PRINT CHR$(186)
       GOSUB LIMPATELA
       OUTROS = 0: TECLA$ = "4": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
       LOCATE 4, 35: PRINT "DIRETORIO"
DRIVE: LOCATE 6, 30: PRINT "DRIVE ( A / B / C ) "
       LOCATE 23, 10
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
'                             LIMPA TELA                                      '
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

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                          LIMPA LINHA 22                                     '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
LIMPALINHA: LOCATE 22, 2: PRINT STRING$(78, " "); : RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                       ROTINAS AUXILIARES                                    '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
DESENTELA: LOCATE 1, 1: PRINT CHR$(201); STRING$(78, 205); CHR$(187);
	   FOR I = 2 TO 23: LOCATE I, 1: PRINT CHR$(186); : LOCATE I, 80: PRINT CHR$(186): NEXT I
	   PRINT CHR$(200); STRING$(78, 205); CHR$(188);
	   LOCATE 2, 22 - VEZ * 19: IF VEZ = 1 THEN PRINT "SISTEMA DE REGIONALIZACAO HIDROLOGICA VRS. 1.0 "
	   IF VEZ = 0 THEN PRINT "SISTEMA DE REGIONALIZACAO HIDROLOGICA "
	   LOCATE 3, 1: PRINT CHR$(204); STRING$(78, 205); CHR$(185);
	   IF VEZ = 1 THEN
			LOCATE 1, 50: PRINT CHR$(203)
			LOCATE 2, 50: PRINT CHR$(186)
			DEF SEG = &HB800
			FOR I = 163 TO 257 STEP 2
			  POKE I, &H13
			NEXT I
			DEF SEG
			LOCATE 2, 58: PRINT MUD$; A$; STRING$(13 - LEN(A$), 32)
		      END IF
	   VEZ = 1
	   RETURN

TEMPO: FOR TESTE = 1 TO 8000: NEXT TESTE: RETURN

CANCELA: GOSUB LIMPALINHA
	 LOCATE 22, 31
	 PRINT "OPERACAO CANCELADA"
	 GOSUB TEMPO
	 GOSUB LIMPALINHA
	 RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                           TRATAMENTO DE ERROS                               '
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
	 IF ERR = 53 THEN LOCATE 22, 31: PRINT "ARQUIVO NAO EXISTE": SOM = 1
	 IF ERR = 61 THEN LOCATE 22, 34: PRINT "DISCO CHEIO": SOM = 1
	 IF ERR = 67 THEN LOCATE 22, 28: PRINT "MUITOS ARQUIVOS NO DISCO": SOM = 1
	 IF ERR = 68 THEN LOCATE 22, 32: PRINT "DRIVE NAO EXISTE": SOM = 1
	 IF ERR = 71 THEN LOCATE 22, 34: PRINT "DRIVE ABERTO": SOM = 1
	 IF ERR = 70 THEN LOCATE 22, 32: PRINT "DISCO PROTEGIDO": SOM = 1
	 IF ERR = 76 THEN LOCATE 22, 32: PRINT "DRIVE NAO EXISTE": SOM = 1
	 IF ERG = 100 THEN LOCATE 22, 30: PRINT "IMPRESSORA DESLIGADA": SOM = 1
	 LOCATE 23, 15: PRINT ERR; " "; ERL
	 IF SOM = 0 THEN TESERRO = 0
	 IF SOM = 1 THEN BEEP: GOSUB TEMPO
	 RESUME NEXT

     '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '                        TECLAS VALIDAS                                   '
     '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
VALIDO: TECLAVAL$ = "12345"
	KK = 1: JJ = 1
	ATX = &H10
	IF OUTROS = 0 THEN
	LINHA$ = "    _F1  Ajuda   _F2  Diretorio   _F3  Drive   _F4  Encerrar    _F5  Outros             "
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
AJUDA: IF CONTHELP > 30 THEN CONTHELP = 1
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

NEGRITO: LPRINT CHR$(27); "@";
	 LPRINT CHR$(27); "E";
	 LPRINT T$
	 LPRINT CHR$(27); "@";
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



