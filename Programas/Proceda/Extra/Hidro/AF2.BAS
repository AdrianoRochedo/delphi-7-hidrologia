'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' PROGRAMA ANALISE DE FREQUENCIA : AF.BAS                                     '
' Adaptado por Juan Santiago
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
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
     HELP$(20) = "este erro.        "
     ' 8,2,6,6,6,2
     DIM TE$(8), TE(8), L$(8), L(8), TC(8), TS$(8)
     DIM A$(1000), V$(1000), Q(1000), T(1000)
     FOR TESTE = 0 TO 15
       TEXTO$(TESTE) = ""
     NEXT TESTE
     FOR TESTE = 0 TO 8
       TELA$(TESTE) = ""
     NEXT TESTE
     VEZ = 0
     APAGA = 0
     NEG = 0
     CONTHELP = 1
     GOSUB DESENTELA
     LOCATE 6, 23: PRINT "Instituto de Pesquisas Hidraulicas"
     LOCATE 8, 20: PRINT "Universidade Federal do Rio Grande do Sul"
     LOCATE 11, 22: PRINT "PROGRAMA PARA ANALISE DE FREQUENCIAS"
     LOCATE 12, 22: PRINT " E EMISSAO DE ARQUIVOS PARA GRAFICO"
     LOCATE 15, 30: PRINT "VERSAO 1.0  /  1990"
     LOCATE 18, 20: PRINT "Desenvolvido por: "
     LOCATE 19, 37: PRINT "Antonio Eduardo Leao Lanna"
     LOCATE 20, 37: PRINT "Luciano Nunes de Oliveira"
     LOCATE 24, 46: PRINT CHR$(175); " Tecle << ENTER >> "; CHR$(174);
AQUI1: OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI1
      IF ASC(OP$) <> 13 THEN BEEP: GOTO AQUI1
      LOCATE 24, 46: PRINT STRING$(21, 205);
      GOSUB LIMPATELA

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                          INICIALIZA VARIAVEIS                               '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
      BC$ = STRING$(80, " ")
      AA = .38
      AP = .4
      TS = 1
      FP = 0
      FR = 0
      FC = 0
      ZT = 0
      POSICAO = 15
      NPCONT = 0
      MUD$ = "A:\"
      A$ = "SEM NOME"
      APAGA = 1
      TE$(1) = "LINEAR  "
      TE$(2) = "LOG(E)  "
      TE$(3) = "EXTREMOS"
      TE$(4) = "NORMAL  "
      TE$(5) = "GAMA-3  "
      TE$(6) = "POTENCIA"
      TE$(7) = "LOG(SUP)"
      TE$(8) = "LOG(INF)"
      TE(1) = 1
      TE(2) = 1
      TS$(1) = "ASCENDENTE "
      TS$(2) = "DESCENDENTE"
      'DEF FNFT(I) = (N + 1 - 2 * AP) / (I - AP)
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

MENUP: ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
       '                          MENU PRINCIPAL                              '
       ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
       TECLA$ = "12345": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
MACETE: LOCATE 4, 5: PRINT "1. Eixo X (Tempo Retorno): "; TE$(TE(1))
       LOCATE 4, 42: PRINT "2. Eixo Y (Variavel): "; TE$(TE(2))
       IF TE(2) > 5 THEN PRINT "= "; ZT
       LOCATE 5, 5: PRINT "3. Classificacao  : "; TS$(TS)
       LOCATE 5, 42: PRINT "4. Nomes dos arquivos de dados"
       LOCATE 6, 5: PRINT "5. "; : IF FR = 0 THEN PRINT "NAO havera relatorio completo"
       IF FR <> 0 THEN PRINT "Havera relatorio completo      "
       LOCATE 6, 42: PRINT "6. "; : IF FC = 0 THEN PRINT "NAO havera relatorio sumario"
       IF FC <> 0 THEN PRINT "Havera relatorio sumario       "
       LOCATE 7, 5: PRINT "7. Tempo de retorno computado pela formula geral com A = "; AP
       
       LOCATE 8, 5: PRINT "8. "; : IF FP = 0 THEN PRINT "NAO serao gerados arquivos para regionalizacao"
       IF FP <> 0 THEN PRINT "Serao gerados arquivos para regionalizacao      "
       LOCATE 24, 46: PRINT CHR$(175); " OPCAO "; CHR$(174);
AQUI2: LOCATE 2, 58: PRINT MUD$; A$; STRING$(13 - LEN(A$), 32)
       LOCATE 23, 10
       Z$ = INKEY$: IF Z$ = "" THEN GOTO AQUI2
       IF ASC(MID$(Z$, 1, 1)) = 0 THEN
	 IF MID$(Z$, 2, 1) = ";" THEN GOSUB AJUDA: GOTO MENUP
	 IF MID$(Z$, 2, 1) = "<" THEN GOSUB DIRETORIO: GOTO MENUP
	 IF MID$(Z$, 2, 1) = "=" THEN
				IF MUD$ = "A:\" THEN MUD$ = "B:\": GOTO AQUI2
				IF MUD$ = "B:\" THEN MUD$ = "C:\": GOTO AQUI2
				IF MUD$ = "C:\" THEN MUD$ = "A:\": GOTO AQUI2
			      END IF
	 IF MID$(Z$, 2, 1) = ">" THEN
				GOSUB MEIATELA
				LOCATE 12, 29
				PRINT "Confirma opcao (S/N) ?"
AQUI0:                          OP$ = INKEY$: IF OP$ = "" THEN GOTO AQUI0
				IF OP$ = "S" OR OP$ = "s" THEN CLS : END
				IF OP$ = "N" OR OP$ = "n" THEN LOCATE 12, 2: PRINT STRING$(78, " "): GOTO AQUI2
				BEEP: GOTO AQUI0
			      END IF
	 IF MID$(Z$, 2, 1) = "?" THEN
				IF OUTROS = 0 THEN
						OUTROS = 1
						IF IMPRESSAO = 1 THEN IF GRAVA = 0 THEN TECLA$ = "124": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO: GOTO AQUI2
						IF IMPRESSAO = 1 THEN IF GRAVA = 1 THEN TECLA$ = "12": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO: GOTO AQUI2
						IF IMPRESSAO = 0 THEN IF GRAVA = 0 THEN TECLA$ = "1234": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO: GOTO AQUI2
						IF IMPRESSAO = 0 THEN IF GRAVA = 1 THEN TECLA$ = "123": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO: GOTO AQUI2
					      END IF
				IF OUTROS = 1 THEN OUTROS = 0: TECLA$ = "12345": GOSUB VALIDO: GOTO AQUI2
			      END IF
	 IF MID$(Z$, 2, 1) = "@" THEN EXEC = EXEC + 1: BUF = 0: TECLA$ = "": OUTROS = 0: GOSUB VALIDO: GOTO 3000
	 IF MID$(Z$, 2, 1) = "A" THEN
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
	 IF MID$(Z$, 2, 1) = "B" THEN
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
       IF ASC(Z$) < 49 OR ASC(Z$) > 56 THEN BEEP: GOTO AQUI2
       IF Z$ = "1" THEN
		     IF TE(1) < 5 THEN TE(1) = TE(1) + 1: GOTO MACETE
		     IF TE(1) = 5 THEN TE(1) = 1: GOTO MACETE
		   END IF
       IF Z$ = "2" THEN
		     IF TE(2) = 1 THEN TE(2) = 2: GOTO MACETE
		     IF TE(2) = 8 THEN TE(2) = 1: GOTO MACETE
		     IF TE(2) = 2 THEN TE(2) = 6: GOSUB 1400: GOTO MENUP
		     IF TE(2) = 6 THEN TE(2) = 7: GOSUB 1400: GOTO MENUP
		     IF TE(2) = 7 THEN TE(2) = 8: GOSUB 1400: GOTO MENUP
		   END IF
       IF Z$ = "3" THEN
		     IF TS = 1 THEN TS = 2: GOTO MACETE
		     IF TS = 2 THEN TS = 1: GOTO MACETE
		   END IF
       IF Z$ = "4" THEN
		     I$ = "** NOMES DOS ARQUIVOS **"
		     FOR I = 1 TO NP
		       V$(I) = A$(I)
		     NEXT I
		     N = NP
		     NPCONT = NPCONT + 1
		     GOSUB MENU2
		     FOR I = 1 TO N
		       A$(I) = V$(I)
		     NEXT I
		     NP = N
		     IF NPCONT > 1 THEN REDIM A(NP), B(NP), R2(NP), NI(NP)
		     IF NPCONT = 1 THEN DIM A(NP), B(NP), R2(NP), NI(NP)
		     GOTO MENUP
		   END IF
       IF Z$ = "5" THEN
		     IF FR = 0 THEN FR = 1: GOTO MACETE
		     IF FR = 1 THEN FR = 0: GOTO MACETE
		   END IF
       IF Z$ = "6" THEN
		     IF FC = 0 THEN FC = 1: GOTO MACETE
		     IF FC = 1 THEN FC = 0: GOTO MACETE
		   END IF
OP7:   IF Z$ = "7" THEN
		     GOSUB MEIATELA
		     LOCATE 12, 5
		     PRINT "FORMULA GERAL DE ESTIMATIVA DE TEMPO DE RETORNO DE AMOSTRAS ORDENADAS"
		     LOCATE 14, 5: PRINT "Se A < 1 entao T = ( N + 1 - 2 * A ) / ( I - A )"
		     LOCATE 16, 5: PRINT "Se A >=1 entao T = 100 * ( I + A ) / ( N + A )"
OP73:                LOCATE 7, 63
		     LOCATE 7, 63: PRINT STRING$(3, "_")
		     CODIGO$ = "13450570763": GOSUB TRTR
		     AUX$ = LETRA$
		     IF AUX$ = "" THEN GOTO OP75
		     IF VAL(AUX$) > 1000 THEN
					 BEEP
					 LOCATE 18, 2
					 PRINT STRING$(78, " ");
					 GOTO OP73
				       END IF
		     AP = VAL(AUX$)
OP75:                GOSUB MEIATELA
		     GOTO MACETE
		   END IF
       IF Z$ = "8" THEN
		     IF FP = 0 THEN FP = 1: GOTO MACETE
		     IF FP = 1 THEN FP = 0: GOTO MACETE
		   END IF
       IF ZT = 1 THEN TE(2) = 1
       IF ZT = 0 THEN TE(2) = 2
       GOTO MACETE

1400 GOSUB MEIATELA: ON TE(2) - 5 GOTO 1410, 1420, 1430
1410 LOCATE 12, 5: PRINT "TRANSFORMACAO DE POTENCIA"
     LOCATE 14, 5: PRINT "Y = ( Y^ZT - 1 ) / ZT"
     GOTO 1450
1420 LOCATE 12, 5: PRINT "TRANSFORMACAO LOG COM LIMITE SUPERIOR"
     LOCATE 14, 5: PRINT "Y = LOG( ZT - Y )"
     GOTO 1450
1430 LOCATE 12, 5: PRINT "TRANSFORMACAO LOG COM LIMITE INFERIOR"
     LOCATE 14, 5: PRINT "Y = LOG( Y - ZT )"
     GOTO 1450
1450 LOCATE 16, 5: PRINT "1. Entrada do parametro ZT"
'     LOCATE 18,5:PRINT "2. Estimativa do parametro ZT"
     LOCATE 18, 5: PRINT "2. Outra transformacao"
     OUTROS = 0: TECLA$ = "4": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
AQUI4: LOCATE 20, 5: PRINT "Valor de ZT = "; ZT; STRING$(25, " ");
      W$ = INKEY$: IF W$ = "" THEN GOTO AQUI4
      IF ASC(MID$(W$, 1, 1)) = 0 THEN
       IF MID$(W$, 2, 1) = ">" THEN GOSUB MEIATELA: RETURN
      END IF
      IF W$ = "1" THEN GOTO 1470
'      IF W$ = "2" THEN GOTO 1490
      IF W$ = "2" THEN GOTO 1480
      BEEP: GOTO AQUI4
1470 LOCATE 22, 5: PRINT "Digite parametro ZT "; STRING$(12, "_")
     CODIGO$ = "13450572225": GOSUB TRTR
     AUX$ = LETRA$
     IF AUX$ = "" THEN GOSUB LIMPALINHA: GOTO AQUI4
     ZT = VAL(AUX$): GOSUB LIMPALINHA: GOTO AQUI4
1480 IF TE(2) < 8 THEN TE(2) = TE(2) + 1: GOTO 1400
1485 IF TE(2) = 8 THEN TE(2) = 1: GOSUB MEIATELA: RETURN
'1490 IP = 1
'     GOSUB MEIATELA
'     GOSUB LEITARQ
'     IF TESERRO = 1 THEN TESERRO = 0:GOSUB MEIATELA:GOTO 1410
'     GOSUB 2000
'     LOCATE 22,5:PRINT "ZT = ";ZT
'     GOTO 1410

'2000 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '                    ESTIMATIVAS DE ZT                                   '
     ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'     ON TE(1) GOTO 2020,2020,2020,IMPINIT
'2020 LOCATE 15,28:PRINT "ASSIMETRIA ALVO --> 2.44": GOTO 2040
'     LOCATE 15,28:PRINT "ASSIMETRIA ALVO --> 0.0 "
'2040 AUX=TE(1):TE(1)=0:GOSUB DEFINE:TE(1)=AUX:'** ON TE(2) - 5 GOSUB 11400,11500,11600 **
'     N = NI(IP)
'2050 LOCATE 17,28:LINE INPUT "Digite parametro ZT ";AUX$
'     IF ASC(AUX$)<45 OR ASC(AUX$)>57 THEN BEEP:GOTO 2050
'     ZT = VAL(AUX$): GOSUB ASSIMETRIA
'     LOCATE 19,28:PRINT "ASSIMETRIA = ";ASS1:ASS1 = 0
'     LOCATE 21,28:PRINT " Deseja Continuar (S/N) ?"
'2065 OP$=INKEY$:IF OP$="" THEN GOTO 2065
'     IF OP$="S" OR OP$="s" THEN
'                             LOCATE 17,2:PRINT STRING$(78," ");
'                             LOCATE 19,2:PRINT STRING$(78," ");
'                             LOCATE 21,2:PRINT STRING$(78," ");
'                             GOTO 2050
'                           END IF
'     IF OP$="N" OR OP$="n" THEN GOSUB MEIATELA:RETURN
'     BEEP:GOTO 2065

DEFINE: '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'               DEFINICAO DAS FUNCOES                                 '
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
       DEF FNFT (X)
	IF AP < 1 THEN FNFT = (N + 1 - 2 * AP) / (X - AP)
	IF AP >= 1 THEN FNFT = 100 * (X + AP) / (N + AP)
       END DEF

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
TE2:  IF TE(2) = 3 THEN GOSUB MENUP: RETURN
      IF TE(2) = 4 THEN GOSUB MENUP: RETURN
      IF TE(2) = 5 THEN GOSUB MENUP: RETURN

      DEF FNFY (X)
       IF TE(2) = 1 THEN FNFY = X: '          ** Y LINEAR **
       IF TE(2) = 2 THEN FNFY = LOG(X): '   ** Y LOG    **
       IF TE(2) = 6 THEN FNFY = (X ^ ZT - 1) / ZT: ' ** Y POTENCIA **
       IF TE(2) = 7 THEN FNFY = LOG(ZT - X): ' ** Y LOG C/ LIM SUP **
       IF TE(2) = 8 THEN FNFY = LOG(X - ZT): ' ** Y LOG C/ LIM INF **
      END DEF

      DEF FNFK (X)
       IF TE(2) = 1 THEN FNFK = X: '          ** Y LINEAR **
       IF TE(2) = 2 THEN FNFK = EXP(X): '   ** Y LOG    **
       IF TE(2) = 6 THEN FNFK = (X * ZT + 1) ^ (1 / ZT): ' ** Y POTENCIA **
       IF TE(2) = 7 THEN FNFK = ZT - EXP(X): ' ** Y C/ LIM SUP **
       IF TE(2) = 8 THEN FNFK = EXP(X) + ZT: ' ** Y C/ LIM INF **
      END DEF
      RETURN

3000 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '                   DEFINICAO DE FUNCOES                                 '
     ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     GOSUB MEIATELA
     IF GRAVA = 0 THEN
		    IF (FR = 1) OR (FC = 1) THEN
VAI1:                 LOCATE 15, 2: PRINT STRING$(78, " ");
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
		  END IF
     GOSUB DEFINE

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                               ESTIMATIVAS                                   '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ESTIMATIVA: NC = 6: GOSUB IMPINIT
     FLAG = 8: GOSUB IMPINIT
     FLAG = 6: GOSUB IMPINIT
     IP = 0
     IF FP = 0 THEN GOTO 3070: ' ** nao serao gerados arquivos graficos **
     GOSUB MEIATELA
     LOCATE 12, 20: PRINT "GRAVAR O ARQUIVO GRAFICO (SELECIONE UM):"
     LOCATE 14, 25: PRINT "1. Observados apenas : O<NOME>"
     LOCATE 16, 25: PRINT "2. Completo          : P<NOME>"
     LOCATE 18, 25: PRINT "3. Ambos                      "
     OUTROS = 0: TECLA$ = "4": IF TECLA$ <> TECLAANT$ THEN GOSUB VALIDO
AQUI5: Z$ = INKEY$: IF Z$ = "" THEN GOTO AQUI5
       IF ASC(MID$(Z$, 1, 1)) = 0 THEN
	 IF MID$(Z$, 2, 1) = ">" THEN GOSUB MEIATELA: GOTO MENUP
       END IF
      IF ASC(Z$) < 49 OR ASC(Z$) > 51 THEN BEEP: GOTO AQUI5
      GOSUB MEIATELA
      TECLA$ = "": GOSUB VALIDO
3070 IP = IP + 1
     GOSUB LEITARQ: '   ** LEITURA DE ARQUIVO **
     IF TESERRO = 1 THEN TESERRO = 0: GOSUB MEIATELA: GOTO MENUP
     GOSUB ELIMINA: ' ** -999 **
     LOCATE 17, 10: PRINT "ORDENACAO"
     GOSUB ORDENA
     IF FP = 1 THEN GOSUB 27000: ' ** ABS & CPT gravando arquivos graficos **
     IF TESERRO = 1 THEN TESERRO = 0: GOSUB MEIATELA: GOTO MENUP
     FOR I = 1 TO N
       Q(I) = ABS(Q(I))
     NEXT I
     LOCATE 17, 36: PRINT "TRASFORMACAO"
     GOSUB REDUCAO
     LOCATE 17, 60: PRINT "REGRESSAO"
     GOSUB REGRESSAO
     IF FR = 0 THEN GOTO 3470: ' ** nao havera relatorio de estimativas **
     T$ = A$(IP) + ": AJUSTE ": NEG = 1
     FLAG = 2: GOSUB IMPPADRAO
     FLAG = 3: GOSUB IMPPADRAO
     T$ = "DISTRIBUICAO  : " + TE$(TE(1))
     FLAG = 2: GOSUB IMPPADRAO
     T$ = "TRANSFORMACAO : " + TE$(TE(2))
     FLAG = 2: GOSUB IMPPADRAO
     FLAG = 3: GOSUB IMPPADRAO: NEG = 0
     FLAG = 4: GOSUB IMPPADRAO
     L$(1) = "ORDEM"
     L$(2) = "OBSERVACAO"
     L$(3) = "T.RETORNO"
     L$(4) = "FREQUENCIA"
     L$(5) = "V.REDUZIDA"
     L$(6) = "ESTIMATIVA"
     FLAG = 1: GOSUB IMPPADRAO
     FLAG = 4: GOSUB IMPPADRAO
     FOR I = 1 TO NI(IP)
       N = NI(IP)
       L$(1) = STR$(I)
       Z = Q(I)
       GOSUB ARREDO
       L$(2) = Z$
       Z = FNFT(I)
       GOSUB ARREDO
       L$(3) = Z$
       Z = 1 / FNFT(I)
       GOSUB ARREDO
       L$(4) = Z$
       Z = T(I)
       GOSUB ARREDO
       L$(5) = Z$
       Z = A(IP) + B(IP) * T(I)
       GOSUB ARREDO
       L$(6) = Z$
       FLAG = 1: GOSUB IMPPADRAO
     NEXT I
     FLAG = 4: GOSUB IMPPADRAO
     FLAG = 3: GOSUB IMPPADRAO
3470 IF IP < NP THEN GOTO 3070

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                            INICIO LO LOOP                                   '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     IF FC = 0 THEN GOSUB MEIATELA: GOTO VAI2
'LOOP:
     NC = 5: GOSUB IMPINIT
     FLAG = 8: GOSUB IMPINIT
     FLAG = 6: GOSUB IMPINIT
     T$ = "COEFICIENTES": NEG = 1: FLAG = 2: GOSUB IMPPADRAO
     FLAG = 3: GOSUB IMPPADRAO: NEG = 0
     FLAG = 4: GOSUB IMPPADRAO
     L$(1) = "ESTACAO"
     L$(2) = "A"
     L$(3) = "B"
     L$(4) = "R2"
     L$(5) = "PONTOS"
     FLAG = 1: GOSUB IMPPADRAO
     FLAG = 4: GOSUB IMPPADRAO
     FOR IP = 1 TO NP
       L$(1) = A$(IP)
       Z = A(IP)
       GOSUB ARREDO: L$(2) = Z$
       Z = B(IP)
       GOSUB ARREDO: L$(3) = Z$
       Z = R2(IP)
       GOSUB ARREDO: L$(4) = Z$
       Z = NI(IP)
       GOSUB ARREDO: L$(5) = Z$
       FLAG = 1: GOSUB IMPPADRAO
     NEXT IP
     FLAG = 4: GOSUB IMPPADRAO
     FLAG = 3: GOSUB IMPPADRAO
     FLAG = 1: GOSUB IMPPADRAO
     T$ = "ESTIMATIVA = A + B * VARIAVEL REDUZIDA": NEG = 1
     FLAG = 2: GOSUB IMPPADRAO: NEG = 0
     GOSUB MEIATELA
VAI2: IF GRAVA = 0 THEN
		    FOR BUF = 1 TO 250
		      IF BUFFER$(BUF) <> "" THEN GOSUB GRARELAT: GOTO MENUP
		    NEXT BUF
		  END IF
     GOTO MENUP

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                          ARREDONDAMENTO                                     '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ARREDO: Z = Z * 1000
       Z = Z + .5
       Z = INT(Z)
       Z = Z / 1000
       Z$ = STR$(Z)
       RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                          INIT IMPRESSAO                                     '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
IMPINIT: IF FLAG = 9 THEN FLAG = 0: TT$ = "!": RETURN
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

' a linha seguinte foi anulada para nao necessitar de impressora para rodar
'           IF NEG = 0 THEN LPRINT T$ ELSE GOSUB NEGRITO

      IF TESERRO = 1 THEN TESERRO = 0: GOSUB LIMPALINHA: GOTO 21170
      T$ = " ": ERG = 0
      RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                      ELIMINACAO DAS FALHAS ( -999 )                         '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ELIMINA: N = NI(IP)
      J = 0
      FOR I = 1 TO N
	IF Q(I) = -999 THEN GOTO 22090
	J = J + 1
	Q(J) = Q(I)
22090 NEXT I
      NI(IP) = J
      RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                              ASSIMETRIA                                     '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ASSIMETRIA: MD = 0: S1 = 0: S2 = 0
      FOR I = 1 TO N
	MD = MD + FNFY(Q(I))
      NEXT I
      MD = MD / N
      FOR I = 1 TO N
	S1 = S1 + (Q(I) - MD) ^ 2
	S2 = S2 + (Q(I) - MD) ^ 3
      NEXT I
      DP = (S1 / (N - 1)) ^ .5
      ASS1 = (N * S2) / ((N - 1) * (N - 2) * (DP ^ 3))
      RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                           REDUCAO DE FN FT                                  '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
REDUCAO: IF TE(1) = 5 THEN GOSUB ASSIMETRIA
      N = NI(IP)
      FOR I = 1 TO N
	Z = FNFT(I): IF Z < 1.000001 THEN Z = 1.000001
	IF Z <= 2 THEN T(I) = FNFU(Z)
	IF Z > 2 THEN T(I) = FNFV(Z)
	IF TE(1) = 5 THEN T(I) = FNFP(T(I))
	Q(I) = FNFY(ABS(Q(I)))
      NEXT I
      RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                              REGRESSAO LINEAR                               '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
REGRESSAO: J = 0: K = 0: L = 0: M = 0
      R2 = 0
      N = NI(IP)
      FOR I = 1 TO N
	X = T(I)
	Y = Q(I)
	J = J + X
	K = K + Y
	L = L + X ^ 2
	M = M + Y ^ 2
	R2 = R2 + X * Y
      NEXT I
      B(IP) = (N * R2 - K * J) / (N * L - J ^ 2)
      A(IP) = (K - B(IP) * J) / N
      J = B(IP) * (R2 - J * K / N)
      M = M - K ^ 2 / N
      K = M - J
      R2(IP) = J / M
      RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                                 EDICAO                                            '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
MENU2: GOSUB LIMPATELA
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
       IF TESERRO = 1 THEN TESERRO = 0: GOSUB CANCELA: GOTO 26800
       PRINT #1, N, 1
       FOR I = 1 TO N
	 PRINT #1, V$(I)
       NEXT I
       CLOSE #1
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
DIRETORIO: GOSUB LIMPATELA
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
		  GOSUB BARRA: FILES "B:": GOTO VOLTA
		 ELSE
		  ERROR 76: IF TESERRO = 1 THEN TESERRO = 0: GOSUB LIMPALINHA
		  GOTO DRIVE
	      END IF
	      DEF SEG = 0
       END IF
       IF DRIVE$ = "C" OR DRIVE$ = "c" THEN GOSUB BARRA: FILES "C:": GOTO VOLTA
       BEEP: GOTO DRIVE
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

27000 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
      '                       ARQUIVOS PLOTTER                                '
      '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
      GOSUB TESTDRIVE: IF TESERRO = 1 THEN GOSUB CANCELA: RETURN
      N = NI(IP): ZN = 0
      LIXO$ = A$(IP): ARR$ = A$(IP)
      LIXO$ = LEFT$(LIXO$, INSTR(LIXO$, ".") - 1)
      IF LEN(LIXO$) = 8 THEN
			ARR$ = LEFT$(A$(IP), INSTR(A$(IP), ".") - 2) + MID$(A$(IP), INSTR(A$(IP), "."), LEN(A$(IP)))
		      END IF
      ARR$ = "O" + ARR$
      ARQUIVO$ = MUD$ + ARR$
      IF Z$ = "2" THEN GOTO 27150

      ' ** ARQUIVOS OBS **
      FOR I = 1 TO N
	IF Q(I) >= 0 THEN ZN = ZN + 1
      NEXT I
      OPEN ARQUIVO$ FOR OUTPUT AS #1
      IF TESERRO = 1 THEN GOSUB CANCELA: RETURN
      PRINT #1, ZN
      PRINT #1, 2
      FOR I = 1 TO NI(IP)
	IF Q(I) < 0 THEN GOTO 27060
	PRINT #1, FNFT(I)
	PRINT #1, Q(I)
27060 NEXT I
      CLOSE #1
      IF Z$ = "1" THEN GOTO 27260

27150 LIXO$ = A$(IP): ARR$ = A$(IP)
      LIXO$ = LEFT$(LIXO$, INSTR(LIXO$, ".") - 1)
      IF LEN(LIXO$) = 8 THEN
			ARR$ = LEFT$(A$(IP), INSTR(A$(IP), ".") - 2) + MID$(A$(IP), INSTR(A$(IP), "."), LEN(A$(IP)))
		      END IF
      ARR$ = "P" + ARR$
      ARQUIVO$ = MUD$ + ARR$

      ' ** ARQUIVOS PCH **
      OPEN ARQUIVO$ FOR OUTPUT AS #1
      IF TESERRO = 1 THEN GOSUB CANCELA: RETURN
      PRINT #1, N
      PRINT #1, 2
      FOR I = 1 TO N
	PRINT #1, FNFT(I)
	PRINT #1, ABS(Q(I))
      NEXT I
      CLOSE #1

27260 LIXO$ = "": RETURN

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                              ORDENACAO                                      '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ORDENA: N = NI(IP)
      FOR I = 1 TO N - 1
	FOR J = I + 1 TO N
	  IF TS = 1 AND ABS(Q(I)) <= ABS(Q(J)) THEN GOTO 28130
	  IF TS = 2 AND ABS(Q(I)) >= ABS(Q(J)) THEN GOTO 28130
	  Z = Q(I)
	  Q(I) = Q(J)
	  Q(J) = Z
28130   NEXT J
      NEXT I
      RETURN

LEITARQ: ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	 '              LEITURA DE ARQUIVOS =>  A$(1-NP)                      '
	 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
      LOCATE 12, 31: PRINT "LEITURA DE ARQUIVO"
      GOSUB TESTDRIVE: IF TESERRO = 1 THEN GOSUB CANCELA: RETURN
      LOCATE 24, 46: PRINT STRING$(21, 205);
      LIMPA = (80 - (14 + LEN(A$(IP)))) / 2
      LOCATE 13, 2: PRINT STRING$(78, " ");
      LOCATE 13, LIMPA: PRINT "ARQUIVO ("; IP; ") "; A$(IP); STRING$(10, " ");
      ARQUIVO$ = MUD$ + A$(IP)
      OPEN ARQUIVO$ FOR INPUT AS #1
      IF TESERRO = 1 THEN GOSUB CANCELA: RETURN
      INPUT #1, NI(IP)
      INPUT #1, Z
      FOR I = 1 TO NI(IP)
	INPUT #1, Q(I)
      NEXT I
      CLOSE #1
29060 RETURN

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
	 IF ERR = 70 THEN LOCATE 22, 32: PRINT "DISCO PROTEGIDO": SOM = 1
	 IF ERR = 71 THEN LOCATE 22, 34: PRINT "DRIVE ABERTO": SOM = 1
	 IF ERR = 76 THEN LOCATE 22, 32: PRINT "DRIVE NAO EXISTE": SOM = 1
	 IF ERG = 100 THEN LOCATE 22, 30: PRINT "IMPRESSORA DESLIGADA": SOM = 1
'         LOCATE 23,15:PRINT ERR;
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
						   GOSUB MEIATELA: CLOSE #1
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

