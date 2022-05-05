  	SUBROUTINE CONTINUA (is,NT)
!	ESTE PROGRAMA EH O ALGORITMO DE OTIMIZAÇÃO MOCOM-UA APLICADO AO IPH2
!	MultiObjective Complex Evolution - UNIVERSITY OF ARIZONA
!	Versão de testes
!     Walter Collischonn
!	IPH UFRGS
!	Porto Alegre -  Fevereiro de 2001
	
      USE PORTLIB
	use varcont
      COMMON /PARAM/X(7),AI,BI,AIL,BIL,AT,BT,ATL,BTL,SMAX
      COMMON P(19999),E(19999),QO(19999),T1,QT1,QS1,MT,
     1SQ1,FATOR,SS,ST,HIST(70),NH,DIST(12),ND,AINP,SF1,QF1
      integer tipofo(10) 
      REAL Y(7)
	REAL Qcontinua(19999)
      REAL QC(19999)  !so usa aqui
      integer tipo(10)

 	READ(1,'(I10)')IOP19

!     seleciona se vai otimizar ou simplesmente simular      
      otimizacao: select case (iop19)

	case (0)
      READ(1,'(310)')Nptos,NF,npar
      read(1,'(3i10)')(tipofo(inf),inf=1,nf)

	case (1)
      npontos=10
      nf=2
      tipofo(1)=1
      tipofo(2)=6      

	CASE DEFAULT otimizacao 
	CONTINUE
	END SELECT otimizacao


	!verifica a alocacao das variaveis
	call alocacont

      READ(1,'(I10,F10.2)')NH,XN				!numero ordenadas HTA e param forma
	SF1=1.E10
      SF=0.

C	LEITURA DE QOBS, P E EVAPO
      READ(1,*)

      DO J=1,NT
      READ(1,'(f10.1,2f10.2)')P(J),QO(J),E(J)
      ENDDO

	READ(1,'(9F10.2)')T1,QT1,QS1,AREA,AINP
   61 READ(1,'(7F10.2)') (X(J),J=1,7)
      write(2,*)
      write(2,1120)(X(J),J=1,6)

      N=0
      IF(XN)84,84,83
   83 C=0.5/(NH/2.)**XN
      L=NH/2
      XA=0.
      DO 88 I=1,L
      XA1=C*I**XN
      HIST(I)=XA1-XA
      XA=XA1
      L1=NH-I+1
      HIST(L1)=HIST(I)
   88 CONTINUE
      IF(NH/2*2-NH)89,86,89
   89 HIST(I)=(C*(NH/2.)**XN-XA)*2
      GO TO 86
   84 READ(1,'(9F10.2)')(HIST(J),J=1,NH)

   86 ST=0.
      SS=0.

	NSF=0
      DO J=1,NT
		IF(QO(J).GE.0.0)THEN
			SS=SS+QO(J)
			NSF=NSF+1
		ENDIF
	ENDDO

	IF(NSF.EQ.0)THEN
		SS=SS+.00001  !EVITA ERROS DE DIVISÃO QUANDO NÃO TEM Q OBSERVADA
		SM=SS 
	ELSE
		SM=SS/NSF
	ENDIF

      DO J=1,NT
		IF(QO(J).GE.0.0)THEN
			ST=ST+(QO(J)-SM)**2
		ENDIF
	ENDDO

	IF(ST.LT.0.0001)THEN !NÃO EXISTE NENHUMA VAZÃO OBSERVADA
		ST=0.0001
	ENDIF

      DO 100 J=1,7
	N=N+1
      Y(N)=X(J)
  100 CONTINUE
!	READ(1,'(9F10.2)')T1,QT1,QS1,AREA,AINP
      FATOR=AREA*100/AAT/6.  !transforma para hectare / hora
      TC=NH*AAT/60.

   66 MT=NT
      T1=T1/FATOR
      QT1=QT1/FATOR
      QS1=QS1/FATOR


!	************BLOCO QUE DECIDE TIPO DE EXECUÇÃO**********************
x
	if(iop19==0)then
      OPEN(21,FILE='Resultado da Otimizacao.sai',STATUS='UNKNOWN')
      endif
	

!            DO 999 inf=1,nf
!          	Nfo=Nfo+1
!              tipo(Nfo)=tipofo(inf)
!999         CONTINUE


	IF(IOP19.EQ.0)THEN !SEGUE NORMALMENTE
      	itime1 = TIME()

!	    LIMITES DOS PARAMETROS
	    OPEN(19,FILE='Limites dos parametros para otimizacao.txt',
     1     STATUS='OLD')
	    READ(19,*)CABEcont
	        DO L=1,NPAR
	        READ(19,*)CABEcont,PMINcont(L),PMAXcont(L)
	        ENDDO

!	    GERA A SEMENTE DO PROCESSO ALEATORIO
	    CALL SEMENTE(ISEED)
	    ibobo=MOD(ISEED,100)
	    write(*,*)iseed,ibobo
	        do iw=1,ibobo
		    xbobo=ran1(iseed)
	        enddo
	    write(*,*)ran1(iseed)

!	    GERA VALOR RELATIVO DO PARAMETRO E MULTIPLICA PELA FAIXA DE VALIDADE
	        DO I=1,Nptos
		        DO L=1,NPAR
			    PPAR(L,I)=RAN1(ISEED)
			    PAR(L,I)=PMINcont(L)+PPAR(L,I)*(PMAXcont(L)-PMINcont(L))
		        ENDDO
	        ENDDO
!	-------------------------------------
	    KOUNTF=0
!	    AVALIA A FUNÇÃO EM CADA PONTO
	        DO I=1,Nptos
		        
                  DO L=1,NPAR
			    X(L)=PAR(L,I)
		        ENDDO
		        
                  CALL OBJEC(X,NF,VFO,QC,SFNS,SQ,NSF,tipofo)
		        KOUNTF=KOUNTF+1
		            
                  DO JF=1,NF
			    FO(I,JF)=VFO(JF)
		        ENDDO

	        ENDDO	
!	-------------------------------------
          FMIN=999999999999999999.9
	    ISHUFFLE=0
	    IRMAX=10
	        
          DO WHILE (IRMAX.GT.1)
		ISHUFFLE=ISHUFFLE+1
		IRUIM=0
		IBETA=2*NPAR+1
!	-	----------------------------------------------------------
!		INICIA RANKING
		IPARET=1
		ISOMA=0
		IRMAX=1

3000		DO I=1,Nptos
			IF(IPARET(I).EQ.IRMAX)THEN
				DO J=1,Nptos
					IF(J.NE.I.AND.IPARET(J).EQ.IRMAX)THEN	
						DO K=1,NF
							IF(FO(I,K).GT.FO(J,K))THEN
								IDOMIN=1
								IDD=J
							ELSE
								IDOMIN=0
								GOTO 1000
							ENDIF
						ENDDO
						IF(IDOMIN.EQ.1)THEN !ESTE PONTO É DOMINADO
							GOTO 2000 
						ENDIF
1000					ENDIF
				ENDDO
2000				IF(IDOMIN.EQ.1)THEN
					!WRITE(21,*)I,X(I),' DOMINADO POR',IDD
					!WRITE(21,'(10F10.4)')(FO(I,K),K=1,NF)
					IPARET(I)=IPARET(I)+1
					ISOMA=1
				ELSE
					!WRITE(21,*)I,X(I),' NAO DOMINADO'
					!WRITE(21,'(10F10.4)')(FO(I,K),K=1,NF)
					IPARET(I)=IRMAX
				ENDIF
				IDOMIN=0
				IDD=0
			ENDIF
		ENDDO
		IF(ISOMA.EQ.1)THEN
			IRMAX=IRMAX+1
			ISOMA=0
			GOTO 3000
		ENDIF
		if(irmax.eq.1.OR.ISHUFFLE.EQ.1)then !GRAVA PRIMEIRA E ULTIMA SITUAÇÃO
			WRITE(21,*)ISHUFFLE
	            
                  if(nf==2)then
                  WRITE(21,1123)
         	        WRITE(21,1124)
	            else
                  WRITE(21,1128)
         	        WRITE(21,1124)
			    endif

              DO I=1,Nptos
			    if(nf>2)then
                      WRITE(21,'(7F10.2,3x,3F10.5,I4)')
	1    		    (PAR(L,I),L=1,7),(FO(I,JF),JF=1,NF),IPARET(I)
	            else
                      WRITE(21,'(7F10.2,3x,2F10.5,I4)')
	1    		    (PAR(L,I),L=1,7),(FO(I,JF),JF=1,NF),IPARET(I)
	            endif
			ENDDO
		endif

C		QUANDO CHEGA AQUI EXISTEM Nptos PONTOS AVALIADOS, CADA UM COM UM RANKING DADO POR IPARET
C		IPARET(I)=1 INDICA OS MELHORES PONTOS E IPARET(I)=IRMAX INDICA OS PIORES PONTOS
		NPC=0
		DO I=1,Nptos
			IF(IPARET(I).EQ.IRMAX)THEN
				NPC=NPC+1 !CONTA O NUMERO DE PONTOS QUE TEM RANKING IGUAL AO PIOR DE TODOS (IRMAX)
				IRUIM(NPC)=I !GUARDA O LOCAL EM QUE ESTÁ O PONTO RUIM
			ENDIF
		ENDDO

		!DEFINE PROBABILIDADE DE QUE CADA UM DOS Nptos PONTOS SEJA ESCOLHIDO PARA FAZER PARTE DE UM SIMPLEX
		SPARET=0.0
		RMAX=IRMAX
		DO I=1,Nptos
			SPARET=SPARET+IPARET(I)
		ENDDO
		DO I=1,Nptos
			PROB(I)=(RMAX-IPARET(I)+1.)/(Nptos*(RMAX+1.)-SPARET)
		ENDDO
		DO I=2,Nptos
			PROB(I)=PROB(I-1)+PROB(I) !CALCULA PROBABILIDADE ACUMULADA
		ENDDO
		IF(ABS(PROB(Nptos)-1.0).GT.0.001)STOP 'ALGO ERRADO PROBABILID'
		PROB(Nptos)=1.0 !ESTA LINHA CORRIGE EVENTUAIS ERROS DE ARREDONDAMENTO

		!VARIÁVEL QUE CONTEM OS NPAR+1 PONTOS DO SIMPLEX 1...NPC, DEFINIDOS POR NPAR PARÂMETROS
		ALLOCATE (SPAR(NPC,NPAR+1,NPAR),FPLEX(NPC,NPAR+1,NF))

		DO K=1,NPC
			LRUIM=IRUIM(K)
			DO IPAR=1,NPAR
				SPAR(K,1,IPAR)=PAR(IPAR,LRUIM)
			ENDDO

			DO J=2,NPAR+1 !ESCOLHE OS OUTROS Nptos PONTOS PARA CADA COMPLEXO
				RANDO=RAN1(ISEED) !GERA NUMERO ALEATORIO
				PINI=0.0
				DO I=1,Nptos
					IF(RANDO.GE.PINI.AND.RANDO.LE.PROB(I))THEN
						!I É O PONTO ESCOLHIDO
						DO IPAR=1,NPAR
							SPAR(K,J,IPAR)=PAR(IPAR,I)	!GUARDA VALORES DOS PARÂMETROS
							DO IFUNC=1,NF
								FPLEX(K,J,IFUNC)=FO(I,IFUNC) !GUARDA VALOR DAS FUNÇÕES
							ENDDO
						ENDDO
					ENDIF
					PINI=PROB(I)
				ENDDO

			ENDDO
		ENDDO


		!CHEGANDO AQUI FORAM ESCOLHIDOS OS SIMPLEXES
		!CADA UM DELES TEM UM PONTO PIOR CUJA LOCALIZAÇÃO É DADA PELO VETOR IRUIM(:)

C	-	----------------------------------------------------------			

		!QUANDO CHEGA AQUI, O PROGRAMA TEM UMA AMOSTRA DE Nptos PONTOS NO ESPAÇO
		!DE DIMENSAO NPAR. A FUNÇAO OBJETIVO FOI AVALIADA EM TODOS OS PONTOS
		!E A CADA PONTO FOI DADO UM RANKING MULTI-OBJETIVO
		
		DO K=1,NPC !EVOLUI CADA UM DOS SIMPLEXOS
			LRUIM=IRUIM(K)
			SOMAPAR=0.0
			IREJECT=0
			DO J=2,NPAR+1 !CALCULA O CENTROIDE DOS MELHORES PONTOS
				DO L=1,NPAR
					SOMAPAR(L)=SOMAPAR(L)+SPAR(K,J,L)
				ENDDO
			ENDDO
			SOMAPAR=SOMAPAR/(NPAR) !CALCULA O CENTROIDE DOS MELHORES PONTOS (MEDIA DAS COORDENADAS DO PONTO)

			DO L=1,NPAR
				DIFPAR=SOMAPAR(L)-SPAR(K,1,L) !DISTÂNCIA DO PIOR PONTO AO CENTROIDE
				REFLEX(L)=SOMAPAR(L)+DIFPAR	!COORDENADAS DO PONTO DE REFLEXÃO
				CONTRA(L)=SOMAPAR(L)-DIFPAR/2. !COORDENADAS DO PONTO DE CONTRAÇÃO
			ENDDO
			!Verifica se o ponto gerado por reflexão está dentro da região válida
			DO L=1,NPAR
				IF(REFLEX(L).LT.PMINcont(L).OR.REFLEX(L).GE.PMAXcont(L))THEN
					IREJECT=1
					GOTO 4000
				ENDIF
			ENDDO
			!Se chegou aqui é porque o ponto gerado por reflexão é válido
			!Verifica o valor da função objetivo
			CALL OBJEC(REFLEX,NF,VFO,Qcontinua,SFNS,SQ,NSF,tipofo)
			KOUNTF=KOUNTF+1
			DO JF=1,NF
				FO(LRUIM,JF)=VFO(JF)
			ENDDO
			!VERIFICA SE O PONTO REFLEX É DOMINADO
			!SOMENTE ACEITA O PONTO SE REFLEX É NÃO DOMINADO
			DO J=2,NPAR+1 !VERIFICA SE O PONTO J DOMINA O NOVO PONTO
				IDOMIN=0
				DO IFUNC=1,NF
					IF(FPLEX(K,J,IFUNC).LT.FO(LRUIM,IFUNC))THEN
						IDOMIN=IDOMIN+1	!CONTA PARA QUANTAS FUNÇÕES OBJ. O NOVO PONTO É PIOR
					ENDIF
				ENDDO
				IF(IDOMIN.EQ.NF)THEN !SE O NOVO PONTO É PIOR PARA TODAS AS F. O.
					!ESTE PONTO J DOMINA O NOVO PONTO
					!REJEITA O NOVO PONTO
C					WRITE(*,*)'PONTO REJEITADO POR',
C	&				(FPLEX(K,J,IFUNC),IFUNC=1,NF)
					IREJECT=1
					GOTO 4000
				ENDIF
			ENDDO
4000			IF(IREJECT.EQ.0)THEN
				!SE CHEGOU AQUI O PONTO DE REFLEXÃO FOI ACEITO
C				WRITE(*,*)'PONTO ACEITO'
				DO IPAR=1,NPAR
					PAR(IPAR,LRUIM)=REFLEX(IPAR)
				ENDDO

			ELSE
				!SE CHEGOU AQUI O PONTO DE REFLEXÃO FOI REJEITADO - USA CONTRAÇÃO
				CALL OBJEC(CONTRA,NF,VFO,Qcontinua,SFNS,SQ,NSF,tipofo)
				KOUNTF=KOUNTF+1
				DO JF=1,NF
					FO(LRUIM,JF)=VFO(JF)
				ENDDO
				DO IPAR=1,NPAR
					PAR(IPAR,LRUIM)=CONTRA(IPAR)
				ENDDO
			ENDIF

		ENDDO !FIM DO LOOP DOS SIMPLEXOS

		if(irmax.eq.1)then
			write(*,*)'vai terminar'
		endif

		DEALLOCATE (SPAR,FPLEX)
		VMIN1=99999999999990.0
		VMIN2=99999999999990.0
		VMIN3=99999999999990.0
		DO KS=1,Nptos
			VMIN1=MIN(VMIN1,FO(KS,1))
			VMIN2=MIN(VMIN2,FO(KS,2))
c			VMIN3=MIN(VMIN3,FO(KS,3))
		ENDDO

		WRITE(*,79)ISHUFFLE,IRMAX,NPC,VMIN1,VMIN2,VMIN3

		IF(ISHUFFLE.GT.100000)THEN
			WRITE(21,*)ISHUFFLE
			WRITE(21,*)
			DO I=1,Nptos
			WRITE(21,'(7F10.2,F10.4,F10.5,I4)')
	1		(PAR(L,I),L=1,7),(FO(I,JF),JF=1,NF),IPARET(I)
			ENDDO
			IRMAX=1
		ENDIF
		ENDDO !FIM DO LOOP DOS SHUFFLES (SÓ SAI QUANDO IRMAX=1)
		WRITE(*,*)'FIM DA OTIMIZACAO - VERIFIQUE SAIDA'
		STOP

	ELSE !USA OS PARAMETROS LIDOS E EXECUTA APENAS UMA VEZ

!          read(1,'(3i10)')(tipofo(inf),inf=1,nf)
		CALL OBJEC(X,NF,VFO,QC,SFNS,SQ,NSF,tipofo)
		OPEN(23,FILE='saida-sim continua IPH2.TXT',STATUS='UNKNOWN')

		write(23,*)
		write(23,1135)is
		WRITE(23,1125)
		
		DO IT=1,NT
			WRITE(23,'(I5,3F10.2)')IT,P(IT),QO(IT),QC(IT)   !VAI CALCULANDO E ESCREVENDO
		ENDDO

	QOcont=QO
	Pcont=P

      DO 9999 J=1,NT
9999  Qcont(J,IS)=Qc(J)

		 
		!CALCULA R DE Nash Sutcliffe e erro no volume
		R=(ST-SFNS)/ST
!	WRITE(*,*)ss
		ERRVOL=100.0*(SQ-SS)/SS
	WRITE(2,*)
      WRITE(2,1121)R
	WRITE(2,1122)ERRVOL

	ENDIF
		
!DEALLOCATE (PPAR,PAR,PMAXcont,PMINcont)
	errvol=0.
	r=0.

1120	format (10x,'Io (mm/h):',2x,f7.2,/,10x,'Ib (mm/h):',2x,f7.2,/,
	*10x,'h:',10x,f7.2,/10x,'Ks (h):',5x,f7.2,/,
     *10x,'Ksub (h):',3x,f7.2,/,10x,'Rmax (mm):',2x,f7.2)
1121  format(10x,'R2=',2x,F5.2)	
1122	format(10x,'Erro de volume=',2x,F8.2)
1123  FORMAT(7X,'Io',7X,'Ib',8X,'h',8X,'Ks',6X,'Ksub',6X,'Rmax',
     *6X,'alfa',8X,'FO1',8X,'FO2',3X,'Ipareto') 
1124  format('__________________________________________________________
     *____________________________________________________')	
1125  FORMAT(2x,'Tempo',4x,'Prec',6x,'Qobs',6x,'Qcalc')
1128  FORMAT(7X,'Io',7X,'Ib',8X,'h',8X,'Ks',6X,'Ksub',6X,'Rmax',
     *6X,'alfa',8X,'FO1',8X,'FO2',8x,'FO3',7X,'Ipareto') 
1135  FORMAT('Operacao hidrologica',2x,i4)
5555  format(9x,'1')			
79	FORMAT('+',3I8,3F10.5)

	RETURN
	END

