 	!MS$DEBUG
      PROGRAM IPHS1
!     ___________________________________                                        *
!     data        Quem     Descricao
!     01/01/2000  Walter   Calculo automatico de trechos em Muskingum Cunge
!     23/02/2002  Daniel   Adatado a Viegas
!     JANEIRO/2003 Rutinéia   Adaptado para simulaçao continua,otimizacao 
!                             e alocaçao dinâmica de variáveis
!__________________________________________________________________________
	use var
	use varcont
      DIMENSION CABE(20)

C       Le os nomes dos arquivos de entrada e saida ++++fechado para o teste
        OPEN  (3,FILE='DRVPROY',STATUS='OLD')
        READ  (3,'(1A160)') FNAME                !arquivo entrada
        READ  (3,'(1A160)') FNAME1               !arquivo saida
        READ  (3,'(1A160)') FNAME3               !arquivo de erro

c        CLOSE (3)
        WRITE (*,1001) 
        WRITE (*,'(1A160)') FNAME 

        WRITE (*,1002) 
        WRITE (*,'(1A160)') FNAME1
        
        WRITE (*,1003) 
        WRITE (*,'(1A160)') FNAME3

1100    CONTINUE

!bacia completa-tractebel-NS.ent
	  OPEN(1,FILE=FNAME,STATUS='OLD')
        OPEN(2,FILE=FNAME1,STATUS='unknown')
        OPEN(18,FILE=FNAME3,STATUS='unknown')
        OPEN(55,FILE='soma',STATUS='unknown')

        WRITE (2,1001) 
        WRITE (2,'(1A160)') FNAME 

        CALL DATE_AND_TIME (REAL_CLOCK (1), REAL_CLOCK (2),
     * REAL_CLOCK (3),DATE_TIME)     !!Escreve a data e hora da simulação
        write(2,*)'Simulado o ',DATE_TIME(3),'/',DATE_TIME(2),'/',
     *DATE_TIME(1)
        write(2,*)' As ',DATE_TIME(5),':',DATE_TIME(6),':',
     *DATE_TIME(7),'horas'                                                      
        read(1,'(20A4)')(CABE(I),I=1,20)

      fname4='hidrograma.iph'

c	ARQUIVO DE SAIDA de VAZOES - En colunna -ok
	  OPEN(3,FILE=fname4,STATUS='UNKNOWN')
	fname5='vazao cont.iph'
c      ARQUIVO DE SAIDA - CURVA VAZAO CONTROLADA X VOLUME NECESSARIO -OK
	  OPEN(4,FILE=fname5,STATUS='UNKNOWN')
	fname6='reservatorio.iph'
C	ARQUIVO DE SAIDA - COTA MAXIMA NOS RESERVATORIOS
	  OPEN(7,FILE=fname6,STATUS='UNKNOWN')
	fname7='alagamento.iph'
C	ARQUIVO DE SAIDA - ALAGAMENTOS NA PROPAGACAO  -OK
	  OPEN(16,FILE=fname7,STATUS='UNKNOWN')
C	ARQUIVO DE SAIDA - PRECIPITACAO EFETIVA
	  OPEN(5,FILE='precipit.IPH',STATUS='UNKNOWN')
C	ARQUIVO DE SAIDA - BYPASS E PROPAGACAO SUPERFICIAL DE EXCESSOS
	  OPEN(6,FILE='QRUA.IPH',STATUS='UNKNOWN')
C	ARQUIVO DE SAIDA - cotas nos trechos
	  OPEN(8,FILE='cotas.IPH',STATUS='UNKNOWN')
C	ARQUIVO DE SAIDA - comentarios a serem lidos pela interfase
	  OPEN(9,FILE='comentario.IPH',STATUS='UNKNOWN')
!C	ARQUIVO DE SAIDA - precipitação total para cada intervalo de tempo
!		OPEN(10,FILE='Ptotal.iph',STATUS='UNKNOWN')

	WRITE(2,920)
      WRITE(2,'(//,10X,20A4)')(CABE(I),I=1,20)
	WRITE(4,*)'  OPHID       QLIM/QMAX   QLIM(M3/SEG)   VOL (M3)
     *   AREA NEC(M2)'
	WRITE(7,*)'        DT   COTA(M)     Qvert      Qbyp    Qsaida'

!	Leitura da informacao inicial para simulacao
	READ(1,'(4I10,F10.2,6i10)') NT,NS,NPCH,NTT,AT,controla
	
!	muda o intervalo de tempo para simulacao continua
	AAT=AT/60 !SIMULACAO CONTINUA deve estar em minutos      
	
      WRITE(2,15)NT,NS,NPCH,NTT,AT
!	somente para a otimizacao
!	________________________________
!	WRITE(*,*)'caso a opcao seja OTIMIZACAO DE PARAMETROS deve ser
!	1ser realizada para cada bacia individualmente'
!      WRITE(*,*)'e o resultado e apresentado no arquivo
!	1RESULTADOS DA OTIMIZACAO' 

	call alocacao
	
	IF(NPCH.NE.0)CALL PRECIP(NPCH)
      Q=0.       !zera arquivo de vazoes
	QMAXW=0.0	!ZERA VETOR DOS MÁXIMOS
!
      DO 519 I=1,NS
		WRITE(*,*)'Realizando operacao hidrologica',i
		WRITE(*,*)'de um total de:',ns
		WRITE(*,*)
		
		if(i.eq.1)then !escreve no arquivo de erro
		WRITE(18,*)NS
		WRITE(18,*)i
		WRITE(18,*)CA
		endif

		READ(1,'(a40)')CA !cabeçalho
		READ(1,'(8I10)')NCOD,IPP,IPR,ILIST,IS,IE,IOBS,controla         !IS=OPERACAO HIDROLOGICA

		WRITE(2,33) I
		WRITE(2,'(a40)')CA
		WRITE(2,25)NCOD,IPP,IPR,ILIST,IS,IE,IOBS,controla      !is num oph ie num hidro entrada

		IF(IPR.GT.0)READ(1,'(8f10.2)')QMAX,QMIN,PMAX
		IF(IOBS.GT.0.AND.NCOD.NE.9) READ(1,'(8f10.2)')(QO(K),K=1,NT)     !COLOQUEI PARA EVITAR A INFORMACAO DE DADOS 

!	seleciona o caso conforme operecao hidrologica

		operacaohidrologica: SELECT CASE (ncod)

		case (1) operacaohidrologica
		call puls
		GO TO 500

		case (2) operacaohidrologica
	    call propr
		GO TO 500

		case (3) operacaohidrologica
	    call tcv
		GO TO 500

		case (4) operacaohidrologica
		READ(1,'(8f10.2)')(Q(J,IS),J=1,NT)
		IF(IPR.EQ.0) GO TO 320
		CALL PLOTA(0)
320		IF(ILIST.EQ.0)GO TO 500
		CALL HID
		GO TO 500

		case (5) operacaohidrologica
		call soma 
		GO TO 500

		case (6) operacaohidrologica
		call deriv 
	    GO TO 500

		case (7) operacaohidrologica
		READ(1,'(8i10)')NPL
		IF(NPL)600,600,310

		case (8) operacaohidrologica
		call divide 
	    GO TO 500

		case (9) operacaohidrologica
		call continua (is,nt) 
	    Q(:,is)=Qcont(:,is)
		Pef(:)=Pcont(:)
		QO(:)=QOcont(:)
          IF (IPR.EQ.0)GO TO 500
          CALL PLOTA(-1)
          GO TO 500
		CASE DEFAULT operacaohidrologica 
		CONTINUE

		END SELECT operacaohidrologica
!	fim operacao hidrologica

310		READ(1,'(8i10)')(IPL(K),K=1,NPL)
		CALL PLOTA(1)

500		IF(NCOD.EQ.3)THEN   !SE E PRECIPITACAO VAZAO ESCREVO A PRECIPITACAO EFETIVA
		write(5,778)I
      		do jj=1,nt
			WRITE(5,'(10F10.2)')PEF(jj),Pre(jj)
			enddo
		ENDIF

c	
C     **************************************************
c	CALCULA CURVA VAZAO CONTROLADA X VOLUME NECESSARIO 
c	procura maximos	de cada operacao hidrologica
C     **************************************************

		curvavol: if(controla.eq.1)then !se e ativado calcula o seguinte

		QMAXW(I)=MAXVAL(Q(:,I))

C	IF(DFOZ(I).GE.0.0)THEN
C		WRITE(6,929)ALFCOD(I),DFOZ(I),QMAXW(I)
C	ENDIF
c	achou maximos
c	AS VAZOES DE SAIDA REQUERIDA SERAO QMAX/9, QMAX/8 ... ATE QMAX/10
			DO NDW=1,9 !MULTIPLICADOR DE QMAX/10
			QLIM=NDW*QMAXW(I)/10. !VAZAO DE SAIDA REQUERIDA

				DO IWC=NT,1,-1 !VARRE HIDROGRAMA DE TRAS PARA A FRENTE
					IF(QLIM.LT.Q(IWC,I))THEN
					NFIM=IWC
					GOTO 514
					ENDIF		
				ENDDO

514			CONTINUE !JÁ CONHECO O INTERVALO DO FIM

				DO IWC=2,NT
				DEL=Q(IWC,I)-Q(IWC-1,I)
					IF(DEL.GT.0.001) THEN !HIDROGRAMA COMEÇOU A CRESCER!
					NINI=IWC
					GOTO 515
					ENDIF
				ENDDO
515			CONTINUE

			VOLA(I,NDW)=0.0
			RETA=0.0
			QBASE=0.0

				DO IWC=NINI,NFIM
2019				RIWC=IWC
				RINI=NINI
				RFIM=NFIM
					IF(NFIM.EQ.NINI)THEN
					RETA=QBASE
					ELSE
					RETA=QBASE+((RIWC-RINI)/(RFIM-RINI))*(QLIM-QBASE)
					ENDIF
				DIF=Q(IWC,I)-RETA
C	QUANDO A RETA EH MAIOR QUE O HIDROGRAMA, DESLOCA INICIO DA RETA
					IF(DIF.LT.0.0)THEN
					QBASE=MIN(Q(IWC,I),RETA)
					NINI=IWC
					GOTO 2019
					ENDIF
				VOLA(I,NDW)=VOLA(I,NDW)+MAX(0.0,DIF) !NAO SOMA NEGATIVOS
				ENDDO
			VOLA(I,NDW)=VOLA(I,NDW)*AT !CALCULA VOLUME EM M3

		!CALCULA PRELIMINARMENTE A AREA NECESSARIA	NO RESERVATORIO DE CONTROLE
		!CONSIDERANDO UMA PROFUNDIDADE MEDIA DE 2 METROS 
			ARRES(I,NDW)=VOLA(I,NDW)/2.0
			XAUX2=NDW/10.	
      		WRITE(4,'(I5,4F15.1)')I,XAUX2,QLIM,VOLA(I,NDW),ARRES(I,NDW)

			ENDDO
 
		endif curvavol
!_______________________________________________________________________	
      CONTINUE !DO DA OPERACAO HIDROLOGICA

C     **************************************************************
      if(i.eq.1)rewind(18)
      WRITE(18,*)NS
 	WRITE(18,*)i
      WRITE(18,*)CA

519   REWIND(18) !FIM DO LOOP DAS OPERACOES


C	GRAVA HIDROGRAMAS                       !arquivo de saida *.hid
	DO IWT=1,NS
	write(3,778)iwt
		do jj=1,nt
		WRITE(3,'(10F10.2)')Q(jj,iwt)
		enddo
      ENDDO
C
	ENDFILE 3
	ENDFILE 4

	CLOSE (3)
	CLOSE (4)

600	continue
	stop
!___________________________________________________________________________
15      FORMAT(//10X,'NUMERO  DE  INTERVALOS  DE TEMPO: ',I7/10X,
     1'NUMERO DE OPERACOES HIDROLOGICAS: ',I7/10X,
     2'NUMERO DE POSTOS DE CHUVA       : ',I7/10X,
     3'NUMERO DE INTERVALOS COM CHUVA  : ',I7/10X,
     1/10X,'DURACAO DO  INTERVALO  DE  TEMPO: ',F7.0,' SEG.')
25    FORMAT(/5X,'NCOD=',I3,'  IPP=',I3,'  IPR=',I3,' ILIST=',I3,
     1'  IS=',I3,'  IE=',I3,'  IOBS=',I3,'   Controla=',i3)

33	FORMAT(////10X,20('*')/10X,'*',18X,'*'/
     1	10X,'* OPERACAO NRO ',I3,' *'/10X,'*',18X,'*'/10X,20('*'))
778	FORMAT('ophid',I5)
920	FORMAT(//10X,20('*'),30X,20('*')/,10X,'*',68X,'*',/
     1	10X,'*  INSTITUTO DE PESQUISAS HIDRAULICAS',32X,'*'/
     110X,'*  UNIVERSIDADE FEDERAL DO RIO GRANDE DO SUL',25X,'*'/
     110X,'*  MODELO IPHS1',54X,'*'/10X,'*',68X,'*'/10X,20('*'),30X,
     1	20('*'))
921	FORMAT(//10X,20('*'),30X,20('*')/,10X,'*',68X,'*',/
     1	10X,'*  INSTITUTO DE PESQUISAS HIDRAULICAS',32X,'*'/
     110X,'*  UNIVERSIDADE FEDERAL DO RIO GRANDE DO SUL',25X,'*'/
     110X,'*  MODELO IPHS1 - MODULO IPHMEN',30X,'*'/10X,'*',68X,'*'/10X,20('*'),30X,
     1	20('*'))
929   FORMAT(A10,2F10.2)
1001  FORMAT(' ARQUIVO DE ENTRADA: ') 
1002  FORMAT(' ARQUIVO DE SAIDA: ') 
1003  FORMAT(' ARQUIVO DE ERRO: ') 

	END

C     **************************************************************
C     ATENCAO ONDE NAO CORRIGIDO CARTAO=LINHA
C     **************************************************************
C
C       DATA ULTIMA VERSAO 11/07/2002
c       -----------------------------
c
c     ARQUIVOS DE ENTRADA E SAIDA
C     ***************************
C     NO  NOME            DESCRICAO
C     1   VARIAVEL*       ENTRADA             *VARIAVEL INDICA QUE O NOME DEPENDE DO nome dado nA INTERFASE
C     2   VARIAVEL        SAIDA TRADICIONAL
c     18  VARIAVEL        ARQUIVO DE ERRO- APARECE A ULTIMA OPERACAO HIDROLOGICA EXECUTADA 
c     3   HIDROGFRAMA.IPH ARQUIVO DE SAIDA de VAZOES - En colunna
C     4   VAZAO CONT.IPH  ARQUIVO DE SAIDA - CURVA VAZAO CONTROLADA X VOLUME NECESSARIO - IMPRIME TEMPO,QLIM,VOL NECE,AREA RES
C     7   RESERVATORIO.IPHARQUIVO DE SAIDA - COTAS NOS RESERVATORIOS
C     16  ALAGAMENTO.IPH  ARQUIVO DE SAIDA - SE NA PROPAGACAO EM CONDUTO FECHADO ALAGA, ARMAZENA AQUI VOL, DURACAO, ETC
C     5   precipit.IPH    ARQUIVO DE SAIDA - PRECIPITACAO EFETIVA ENCOLUNADA PARA NCOD=3
C     6   QRUA.IPH        ARQUIVO DE SAIDA - PROPAGACAO SUPERFICIAL DE EXCESSOS
C     8   COTAS.IPH       ARQUIVO DE SAIDA - COTAS NOS TRECHOS
C     9   comentario.iph  ARQUIVO DE SAIDA - COMENTARIOS A SEREM LIDOS PELA INTERFASE
c
C	DADOS DE ENTRADA 
C     ****************
C    *LINHA 1 !!**!! IMPORTANTE *********linha desabilitada !!!!!
C     OPCAO            =0  SIMULAÇÃO DE EVENTOS
C                      =x  OUTRAS OPCOES POR ENCUANTO DESABILITADAS
C 
C    *LINHA 2
C	CABE(I)          COMENTARIOS GERAIS
C	                 FORMAT(20A4)
C	LINHA 3
C	NT               NUMERO DE INTERVALOS DE TEMPO
C	NS               NUMERO DE OPERACOES HIDROLOGICAS
C	NPCH             NUMERO DE POSTOS DE CHUVA
C                        =0 NAO TEM TRANSFORMACAO CHUVA-VAZAO
C	NTT              NUMERO DE INTERVALOS DE TEMPO COM CHUVA
C	AT               INTERVALO DE TEMPO EM SEGUNDOS
C                      FORMAT(2I10,F10.2)
C
C******* AS LINHAS 4 E 5 SAO REPETIDAS PARA CADA POSTO DE CHUVA
C    *LINHA 4 
C	NPO              NUMERO DO POSTO DE CHUVA (ORDEM CRECENTE)
C     NCHUVA           =1 TORMENTA DESAGREGADA EM (MM/AT)
C                      =2 TORMENTA DE PROYECTO ACUMULADA EM MM.
C 
C    *LINHA 5 
C	(P(I,J),I=1,NTT) CHUVA PARA O POSTO J
C
C    *LINHA 6 
C	CA(I)            COMENTARIO PARA CADA OPERACAO HIDROLOGICA
C	                 FORMAT(20A4)
C    *LINHA 7 
C	NCOD            NUMERO DE CODIGO DA OPERACAO
C                     =1     PROPAGACAO EM RESERVATORIO
C	                =2     PROPAGACAO EM RIO
C                     =3     TRANSFORMACAO CHUVA-VAZAO
C	                =4     HIDROGRAMA LIDO
C                     =5     SOMA
C                     =6     DERIVACAO
C                     =7     IMPRESSAO FINAL
C                     =8     DIVISAO POR PERCENTAGEM DA VAZAO
C	IPP             =0     IMPRESAO RESUMIDA DO ALGORIT DE PERDAS
C	                =1     IMPRIME TABELA DE ESCOAM E PERDAS
C	IPR             =0     NAO GRAFICA HIDROGRAMA RESULTANTE
C	                =1     GRAFICA
C     ILIST           =0     NAO IMPRIME TABELA DO HIDROGRAMA
C                     =1     IMPRIME TABELA DO HIDROGRAMA
C     IS              NUMERO DE ARMAZENAMENTO DO HIDROGRAMA DE SAIDA
C	IE              NUMERO DE ARMAZENAMENTO DO HIDROGRAMA DE ENTRADA
C                       (VALIDO PARA CODIGOS 1,2,6,8) OUTROS CODIGOS IE=0
C	IOBS            0 NAO POSEE DADOS OBSERVADOS (DADOS SOMENTE PARA GRAFICAÇAO- NAO CALCULO)
C	                1 POSEE DADOS OBSERVADOS
c     controla        CALCULA CURVA VAZAO CONTROLADA X VOLUME NECESSARIO 
C    *LINHA 8         QUANDO IPR E MAIOR QUE ZERO
C	QMAX            VAZAO MAXIMA PARA GRAFICAR (M3/S)
C					=0 ESCALA AUTOMATICA
C	QMIN            VAZAO MINIMA PARA GRAFICAR (M3/S)
C					=0 ESCALA AUTOMATICA
C     PMAX            PRECIPITACAO MAXIMA PARA GRAFICAR (MM)
C					=0 ESCALA AUTOMATICA
C	                FORMAT(8F10.2)
C	*LINHA 9        CUANDO IOBS ES MAYOR QUE CERO
C	QO(K)           VALORES OBSERVADOS PARA PLOTAR
C	                FORMAT(8F10.2)
C******* NCOD=1 ******** PROPAGACAO EM RESERVATORIO ****************
C     *LINHA A1       
C       NO              NUMERO DE MOVIMENTACOES DAS ESTRUTURAS 
C                       ESTRAVAZORAS. (MAX=10)
C                       NO = 0 tem que entrar os parâmetros da(s) estruturas de saída (vertedor
c                       e/ou orificios): 
C       SI              ARMAZENAMENTO INICIAL NO RESERVATORIO (1000*M3)
c                       ivert,iorif,QLIM  !indicam vertedor, orificio e vazao MAXIMA do bypass (default=0)
c                       ivert=1: coeficiente do vertedor, coeficiente do vertedor e cota da soleira
c                       iorif=1: coeficiente, area e cota do orificioNO > 0 ==> UMA TABELA Q=F(S) PARA CADA MOV.
c       ZMAX            Cota máxima do reservatório
c       NPZS            Nro. de pontos da tabela cota - volume.
c	*LINHA A2         -se repite NPZveces
c       COTAS(i)        COTA (m)
c       SXZ(I)         VOLUME CORRESPONDENTE A COTA (em M3x1000)
C
C                      
c -------SE NO > 0 ---- 
c	*LINHA A3
C       NP(I)           NUMERO DE PONTOS DA TABELA Q=F(S) (MAX=15)
C       ITT(I)          INTERVALO DE TEMPO ATE O QUAL A OPERACAO I E
C                       VALIDA
c	*LINHA A4        -SE REPITE ITT VEZES-
c       COTAS(i)        COTA (m)
c       QD             Vazão de saida para esa cota (M3/SEG)
C	                 
c -------SE NO = 0 ---- 
c	*LINHA A3
C       IVERT          =1 EXISTE VERTEDOR
C       IORIF          =1 EXISTE ORIFICIO
C       QLIM           vazao MAXIMA do bypassNP(1) 
c	*LINHA A4        EXISTE SE ivert =1 (EXISTE VERTEDOR)   
C   nota: a EQUAÇÃO DO VERTEDOR E QD=Cvert*XL*DH**1.5 OU SEJA QUE CVERT=(2g)^0.5*Cd, ATENÇAO QUANDO SE PEGA O COEFICIENTE DE LIVROS)
C	Cvert           COEFICIENTE DE DESCARGA 
C	XL              LARGURA DO VERTEDOR (M)
C	Zvert           COTA DA CRESTA DO VERTEDOR (M)
c
c	*LINHA A5        EXISTE SE ivert =1 (EXISTE VERTEDOR)   
C	CORIF              COEFICIENTE DE DESCARGA DO ORIFICO
C	AORIF              AREA DO ORIFICIO (M2)
C	ZORIF              COTA DO ORIFICIO (M)
c
C****** NCOD=2 ********* PROPAGACAO EM RIO *************************
c	*LINHA B1
C       NCODP           =1 MUSKINGUM K=F(Q) E X=F(K) - TRECHO UNICO
C                       =2 MUSKINGUM-CUNGE LINEAR
C                       =3 MUSKINGUM-CUNGE NAO LINEAR
C                       =4 MUSKINGUM-CUNGE COM PLANICIE DE INUNDACAO
C                       =5 MUSKINGUM-CUNGE NAO LINEAR PARA CONDUTOS FECHADOS
C       NP              PODE SER: +NUMERO DE PONTOS DA TABELA PARA NCODP=1
C                                 +NUMERO DE TRECHOS PARALELOS PARA NCODP=5 
c	*LINHA B2         *** NCODP=1 E NP POSITIVO **** SE REPETE NP VEZES !!!
C       X(K)            VALOR DO PARAMETRO X DA FUNCAO X=F(Q)
C       XK(K)           VALOR DO PARAMETRO K DA FUNCAO K=F(Q)
C       Q(K)            VALORES DE VAZAO PARA CADA PARA X, K
c	*LINHA B3        *** NCODP=2 E NCODP=3 **** UNICAMENTE VARIA O ALGORITMO INTERNO DE CALCULO
C       QREF            VAZAO DE REFERENCA  (M3/S)
C                        =0 ESTIMAAUTOMÁTICAMENTE A VAZÃO DE REFERENCIA COMO 2/3 DO HIDROGRAMA DE ENTRADA
c	*LINHA B4        IDEM QUE PARA NCODP=3
C       B               LARGURA DO CANAL (M)
C       ALONG           COMPRIMENTO DO TRECHO DE PROPAGACAO (M)
C       SO              DECLIVIDADE DO FUNDO DO CANAL (M/M)
C       DTCAL           INTERVALO DE TEMPO DE CALCULO (SEG)
C       NTRECH          NUMERO DE SUBTRECHOS
C                       =0 ESTIMA AUTOMATICAMENTE O NUMERO DE TRECHOS
C       RUG             RUGOSIDADE DO TRECHO
C       ILAT            EXISTE QUANDO SE DESEJA QUE UM HIDROGRAMA
C                       APORTE EM FORMA DISTRIBUIDA
C                       NUMERO DE ARMAZENAMENTO DO HIDROGRAMA DE
C                       CONTRIBUICAO LATERAL
c	*LINHA B5        *** NCODP=4 ***
C       QREF            VAZAO DE REFERENCA(M3/S)
C                        =0 ESTIMAAUTOMÁTICAMENTE A VAZÃO DE REFERENCIA COMO 2/3 DO HIDROGRAMA DE ENTRADA
c	*LINHA B6
C       B               LARGURA DO CANAL PRINCIPAL (M)
C       ALONG           COMPRIMENTO DO TRECHO DE PROPAGACAO (M)
C       SO              DECLIVIDADE DO FUNDO DO CANAL PRINCIPAL (M/M)
C       DTCAL           INTERVALO DE TEMPO DE CALCULO (SEG)
C                       =0 ADOTA O INTERVALO DE CALCULO DA SIMULAÇAO (AT vide linha 2)
C       NTRECH          NUMERO DE SUBTRECHOS
C                       =0 ESTIMA AUTOMATICAMENTE O NUMERO DE TRECHOS
C       RUG             RUGOSIDADE DO CANAL PRINCIPAL
C       ILAT            EXISTE QUANDO SE DESEJA QUE UM HIDROGRAMA
C                       APORTE EM FORMA DISTRIBUIDA
C                       NUMERO DE ARMAZENAMENTO DO HIDROGRAMA DE
C                       CONTRIBUICAO LATERAL
c	*LINHA B7        CARACTERISTICAS DA PLANICIE DE INUNDACAO
C       B1              LARGURA DA PLANICIE DE INUNDACAO (M)
C       RUG1            RUGOSIDADE DA PLANICIE DE INUNDACAO
C       Y0              COTA Desde O FUNDO onde começa A PLANICIE (M)
c	*LINHA B8        *** NCODP=5 ***
C       QREF            VAZAO DE REFERENCA (M3/S)
C                        =0 ESTIMA AUTOMÁTICAMENTE A VAZÃO DE REFERENCIA COMO 2/3 DO HIDROGRAMA DE ENTRADA
c     excesso           DETERMINA COMO SERAO CONSIDERADAS AS VAZÕES QUE SOBREPASAM A CAPACIDADE DO CONDUTO
C                       =0 ARMAZENA, INDICANDO NO ARQUIVO.ALG O VOLUME ARMAZENADO E A DURACAO
C                       =1 REDIMENSIONA O CONDUTO, AUMENTANDO AS DIMENSOES
C                       =2 PROPAGA SUPERFICIALMENTE (RUAS, ETC) O EXCEDENTE POR MC LINEAR  
C	*LINHA B9          DEPENDE DE VALOR DE EXCESSO
C       -----EXCESSO =0 ESTA LINHA NAO EXISTE (!IMPORTANTE!*)
C       -----EXCESSO =1 LÉ EM QUE DIMENSOES SERAO AMPLIADAS
C         se itipe=2(secao circular,deixar em branco a linha)
C       ANCHO        =1 AMPLIA A LARGURA     
C       ALTO         =1 AMPLIA NA ALTURA
C       ZESQ         =1 AMPLIA NA DECLIVIDADE A ESQUERDA (SOMENTE PARA ITIPE=3)
C       ZDIR         =1 AMPLIA NA DECLIVIDADE A DIREITA (SOMENTE PARA ITIPE=3)
C       -----EXCESSO =2 
c       rugrua         RUGOSIDADE DA RUA (MANNING, ADIM)
C	*LINHA B10         aqui se colocam cada um dos trechos paralelos, 
c                       o primeiro SEMPRE debe ser o mais alto!!!
C       itipe(j)        TIPO DE SEÇAO
C                       =1 SECAO RETANGULAR
C                       =2 SECAO CIRCULAR
C                       =3 SECAO TRAPEZOIDAL
C         Y0(J)         SE ITIPE(J) = 1 E A ALTURA DA SECAO (M)
C                                   = 2 E O DIAMETRO (M)
C         B(J)           LARGURA DO CANAL (M)
C         zl(j)          DECLIVIDADE A ESQUERDA (Z:1) (HORIZ:VERT) 
C         Zr(j)         DECLIVIDADE A DIREITA (Z:1) (HORIZ:VERT)
C         RUG           RUGOSIDADE DO CANAL PRINCIPAL
C       ALONG          LONGITUDE DO TRECHO (M)
C         SO             DECLIVIDADE DO FUNDO (ADIM)(SE ASUME A MESMA PARA TODOS OS CONDUTOS.
C         DTCAL          INTERVALO DE TEMPO DE SIMULAÇAO,NTRECH,RUG,ILAT
C                       =0 ADOTA O INTERVALO DE CALCULO DA SIMULAÇAO (AT vide linha 2)
C       NTRECH          NUMERO DE SUBTRECHOS
C                       =0 ESTIMA AUTOMATICAMENTE O NUMERO DE TRECHOS
C       ILAT            EXISTE QUANDO SE DESEJA QUE UM HIDROGRAMA
C                       APORTE EM FORMA DISTRIBUIDA
C                       NUMERO DE ARMAZENAMENTO DO HIDROGRAMA DE
C                       CONTRIBUICAO LATERAL
c	*LINHA B11         aqui vao os trechos paralelos. Esta linha se repete NP-1 vezes (o primeiro trecho
c                       ja foi definido. Lembrar o mais alto primeiro.
C       itipe(j)        TIPO DE SEÇAO
C                       =1 SECAO RETANGULAR
C                       =2 SECAO CIRCULAR
C                       =3 SECAO TRAPEZOIDAL
C         Y0(J)         SE ITIPE(J) = 1 E A ALTURA DA SECAO (M)
C                                   = 2 E O DIAMETRO (M)
C         B(J)           LARGURA DO CANAL (M)
C         zl(j)          DECLIVIDADE A ESQUERDA (Z:1) (HORIZ:VERT) 
C         Zr(j)         DECLIVIDADE A DIREITA (Z:1) (HORIZ:VERT)
C         RUG             RUGOSIDADE DO CANAL PRINCIPAL
C****** NCOD=3********** TRANSFORMACAO CHUVA-VAZAO ***************
C       CARTAO V
C       NTPU            NRO DE POSTOS DE CHUVA EMPREG NA SUB-BACIA
C       LCHUVA          =0 NAO REORDENA A TORMENTA DE PROYECTO
C                       =1 REORDENA A TORMENTA DE PROYECTO
C                       SO APLICAVEL QUANDO A TORMENTA DE PROJETO E 
C                       OBTIDA DE RELACOES I-D-F
C
C       CARTAO W        TORMENTA DE PROYECTO ACUMULADA (NCHUVA=2)
C       (NPU(I),I=1,NTPU)  NUMEROS DOS POSTOS EMPREGADOS(ORDEM CRECENTE)
C	CARTAO X 
C	(COTH(I),I=1,NTPU) COEFIENTE DOS POLIGONOS DE THIESSENN
C       CARTAO Y        EXISTE SE NCHUVA=2 E LCHUVA=1
C       POS             POSICAO DO PICO DA TORMENTA DE PROYECTO
C                       = 0.25 25% DA DURACAO
C                       = 0.50 50% DA DURACAO
C                       = 0.75 75% DA DURACAO
C       CARTAO Z        ALGORITMOS DE AVALIACAO DE PERDAS
C       NPER            =1 IPHII
C                       =2 SCS
C                       =3 HEC1
C                       =4 FI
C                       =5 HOLTAN
C       CARTAO A1       NPER=1 *** IPHII ***
C	XIO             PARAMETRO IO (MM/HORA)
C	XIB             PARAMETRO IB (MM/HORA)
C	H               PARAMETRO H
C	RMAX            PARAMETRO RMAX (MM)
C	RT1             VAZAO DE BASE ESPECIFICO AO INICIO DA
C	                CHUVA (M3/SEG/KM2)
C	AINP            PORCENTAGEM DE AREA IMPERMEAVEL(0.0-1.0)
C       CARTAO B1       NPER=2 *** SCS ***
C       CN              NUMERO DE CURVA DO SCS
C       CARTAO C1       NPER=3 *** HEC1 ***
C       STRKR           VALOR INICIAL DO COEFICIENTE DE ESCORRENTIA
C       DLTKR           LAMINA A PARTIR DA QUAL NAO SE INCREMENTA O
C                       COEF.DE ESCORRENTIA POR PERDAS INICIAIS[MM]
C       RTIOL           PARAMETRO, DECLIVIDADE DO GRAFICO SEMILOG.
C       ERAIN           EXPOENTE DA PRECIPITACAO
C       CARTAO D1       NPER=4 *** INDICE FI ***
C       PI              PERDA INICIAL (MM)
C       PU              INDICE FI EM (MM/HORA)
C       CARTAO E1       NPER=5 *** HOLTAN ***
C       SAI             EST. INICIAL DO RESER DE UMIDADE DO SOLO[MM]
C       BE              EXPOENTE EMPIRICO
C       FC              INFILTRACAO BASE [MM/HS
C       GIA             CAPACIDADE DE INFIL INICIAL[MM/HS]    REVISAR
C       CARTAO F1       ALGORITMOS DE PROP DO ESCOAMENTO SUPERFICIAL
C       NPRPC          =1 HIDROGRAMA UNITARIO DADO HU( 1 MM.,AT)
C                       =2 HIDROGRAMA TRIANGULAR (SCS)
C                       =3 HYMO (NASH MODIFICADO)
C                       =4 CLARK
C	NESCB           =0 NAO PROP ESCOAMENTO BASE
C	                =1 PROPAGA( CONDICAO NPER=1 )
C       CARTAO G1       NPROPC=1 *** HU ***
C       NORD            NUMERO DE ORDENADAS DO HU
C       CARTAO H1
C       HUO(K)          ORDENADAS DO HU, K=1,NORD (M3/S)
C       CARTAO I1       NPROPC=2 *** HID TRIANG ***
C       AREA            AREA DA BACIA EM (KM2)
C       TC              TEMPO DE CONCENTRACAO (HORAS)
C       CARTAO J1       EXISTE SE TC=0
C       S               DECLIVIDADE EM (M/KM)
C       CARTAO K1       NPROPC=3 *** HYMO ****
C       AREA            AREA DA SUBACIA EM (KM2)
C       XK              RETARDO DOS RESER. NASH, (HRS) XK=0 USASE AS
C	                EQUACOES DE REGRESSAO
C       TP              TEMPO AO PICO DO HIDROGRAMA UNITARIO EM HORAS
C       CARTAO L1       EXISTE SE TP E/OU XK SAO 0
C       HT              DIFERENCIA DE NIVEL NA SUBACIA EM (M)
C       XL              COMPRIMENTO DO CAUCE PRINCIPAL EM (KM)
C       CARTAO M1       NPRPOPC=4 *** CLARK ****
C	XK              PARAMETRO KS (RETARDO DO RES. LIN SIM) (HRS)
C	TC              TEMPO DE CONCENTRACAO DA BACIA (HRS)
C	XN              PARAMETRO XN (FORMA DO HIST. TEMPO-AREA)
C       AREA            AREA DA SUBBACIA EM (KM2)
C	                FORMAT(8F10.2)
C       CARTAO N1       EXISTE SE XK E/OU TC SAO 0
C       S               DECLIVIDADE DA BACIA EM (M/KM)
C       CARTAO O1       EXISTE SE XN=0
C       HIST(II)        ORDENADAS DO (HIST. TEMPO-AREA) II=1,NH
C	
C	CARTAO P1
C	AREA            AREA DA BACIA(KM2)
C	XKSUB           PARAMETRO DO RES LIN SIM (HRS)
C	QSUB0           VAZAO BASE INICIAL(M3/SEG)
C
C ***** NCOD=4 ************** HIDROGRAMA LIDO *************************
C       CARTAO Q1
C	Q(J,IS)          HIDROGRAMA CONHECIDO NA SECAO IS   J=1,NT
C ***** NCOD=5 ************** SOMA DE HIDROGRAMAS *********************
C       CARTAO R1
C       NSUM            NUMERO DE HIDROGRAMAS A SER SOMADOS
C       CARTAO S1
C	ISM(K)          NUMERO DE ARMAZENAMENTO DOS HIDROGRAMAS
C	                A SER SOMADOS FORMAT(8I10)
C ***** NCOD=6 ************** DERIVACAO *******************************
C       CARTAO T1
C       B1               LARGURA DO CANAL DE DERIVACAO
C       RUGO1            RUGOSIDADE DO CANAL DE DERIVACAO
C       DEC1             DECLIVIDADE DO CANAL DE DERIVACAO

C       B2               LARGURA DO CANAL PRINCIPAL
C       RUGO2            RUGOSIDADE DO CANAL PRINCIPAL
C       DEC2             DECLIVIDADE DO CANAL PRINCIPAL
C ***** NCOD=7 ************* IMPRESSAO DE RESULTADOS ******************
C	CARTAO U1
C	NPL             CANTIDAD DE SECOES COM GRAFICACAO
C	                CONJUNTA
C	CARTAO V1       NPL(+)
C	NPL             NUMERO DE HIDROGRAMAS COM  GRAFICACAO CONJUNTA
C
C ***** NCOD=8 ************** DIVISAO HIDROGRAMA***********************
C       CARTAO T1
C       B1               % VAZAO AO NOVO HIDROGRAMA (is) O RESTANTE FICA NO HIDROGRAMA DE 
C                          ENTRADA (IE) 
C *****************************************************************
C************************
