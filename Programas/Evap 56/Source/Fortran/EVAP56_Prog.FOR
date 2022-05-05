      Program evap

c	!DEC$ ATTRIBUTES DLLEXPORT :: evap
c	!DEC$ ATTRIBUTES ALIAS: 'evap' :: evap
c	!DEC$ ATTRIBUTES stdcall,reference:: evap



	USE DFLIB
	CHARACTER($MAXPATH) drivedir
	Character*100 Direct
	cHARACTER NOMEVT*30, NEVT*34, NET0*34
	Character*30 NomTPA,NomTPI,NomINS,NomVEN,NomHUM,NomTDEW,
     +						NomTWET,NomTDRY,NomRHI,NomRHA
	Character*34 NTPA,NTPI,NINS,NVEN,NHUM,NTDEW,NTWET,NTDRY,NRHI,NRHA
	Character*9 MESC0(12),MESC(12)

	REAL TPA(100,372),TPI(100,372),INS(100,372),INSc(100,372),
     +		VEN(100,372),HUM(100,372),RHI(100,372),RHA(100,372),
     +		TDEW(100,372),TDRY(100,372),TWET(100,372), Kr

	real Lat,ALTIT,Zm,LatV,ALTITV,ZmV,VenReg, Cven,as,bs
	Real MatRa(100,372),MatWs(100,372),MatRns(100,372),MatRs(100,372)
	Real MatRaV(100,372),MatWsV(100,372),MatRsV(100,372),
     +  	 Tant(100,372),Tmed(100,372),MatG(100,372)
	Real Matea(100,372),MatETo(100,372)

	INTEGER STEP,year,YN,FY,MES1,MES2,dec,ncol,c,y,
     +				IflagIns,IflagVen,IflagHUM
	INTEGER NdMes0(12),ndDec0(36),NdMes(12),ndDec(36),BIS,mbis
c	Logical BIS

	DATA MESC0 /'January','February','March','April','May','June',
     +	'July','August','September','October','November','December'/

	DATA NdMes0 /31,28,31,30,31,30,31,31,30,31,30,31/

	DATA ndDec0 /10,10,11, 10,10,8, 10,10,11, 10,10,10, 10,10,11,
     +		10,10,10, 10,10,11, 10,10,11, 10,10,10, 10,10,11,
     +		10,10,10, 10,10,11/

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	DIRECT='C:\Test\Antonio\Hm94-95'
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	NOMEVT='huimin'
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	status = CHANGEDIRQQ(DIRECT)
      result = GETDRIVEDIRQQ (drivedir)

	MatETo= 0.
	NDMes = NDMes0
	NDDec = NDDec0

	IN=INDEX(NOMEVT,'.')
	If (IN==0) Then
		IN=INDEX(NOMEVT,' ')
		NEVT = NOMEVT(1:IN-1)//'.EVT'
		IF (IN.EQ.0) NEVT=NOMEVT //'.EVT'
	Else
		NEVT=NOMEVT
		NOMEVT=NEVT(1:IN-1)
	EndIf
	Open (1,File=NEVT,Status='Old')

	NET0 = NOMEVT(1:IN-1)//'.ET0'
	IF (IN.EQ.0) NET0=NOMEVT //'.ET0'

	Read(1,*) Lat,ALTIT, Zm
	Read(1,*) NomTpa
	Read(1,*) NomTpi
	Read(1,*) IflagIns,IflagVen,IflagHUM

	IN=INDEX(NOMTPA,'.')
	If (IN==0) Then

		IN=INDEX(NomTPA,' ')
		NTPA = NOMTPA(1:IN-1)//'.TPA'
		IF (IN.EQ.0) NTPA=NOMTPA //'.TPA'
	Else
		NTPA=NOMTPA
	Endif
	Open (2,File=NTpa,Status='Old')
	call Leclima (2,STEP,YN,FY,MES1,MES2,NC1,NC2,TPA,iUniT)
	Close(2)

	IN=INDEX(NOMTPI,'.')
	If (IN==0) Then
		IN=INDEX(NomTPI,' ')
		NTPI = NOMTPI(1:IN-1)//'.TPI'
		IF (IN.EQ.0) NTPI=NOMTPI //'.TPI'
	Else
		NTPI=NOMTPI
	Endif
	Open (3,File=NTPI,Status='Old')
	call Leclima (3,STEP,YN,FY,MES1,MES2,NC1,NC2,TPI,iUniT)
	Close(3)

c     ****************************** LEITURA DE DADOS: INS *******************************************
	If (iFlagIns.ne.2) then  ! Leitura de ficheiro de insolação
		Read(1,*) NomIns
		Read(1,*) as,bs

		IN=INDEX(NOMINS,'.')
		If (IN==0) Then
			IN=INDEX(NomINS,' ')
			NINS = NOMINS(1:IN-1)//'.INS'
			IF (IN.EQ.0) NINS=NOMINS //'.INS'			
		Else
			NINS=NOMINS
		Endif
		Open (2,File=NIns,Status='Old')
		call Leclima (2,STEP,YN,FY,MES1,MES2,NC1,NC2,INS,iUnIns)
		Close(2)
		INSc = INS
	Else
		Read(1,*) Kr	
	Endif
	If (IflagIns==1) Read(1,*) LatV, AltitV		
	

c     ************************* LEITURA DE DADOS:  VENTO *************************************
	If (IflagVen==0) then  ! Existe vento
		Read(1,*) NomVen
		
		IN=INDEX(NOMVEN,'.')
		If (IN==0) Then
			IN=INDEX(NomVen,' ')
			NVen = NOMVen(1:IN-1)//'.Ven'
			IF (IN.EQ.0) NVen=NOMVen //'.Ven'
		Else
			NVEN=NOMVEN
		Endif
		Open (2,File=NVen,Status='Old')
		call Leclima (2,STEP,YN,FY,MES1,MES2,NC1,NC2,VEN,iUnVen)
		Close(2)
	Elseif (IflagVen==1) then  ! Existe vento de estação vizinha
		Read(1,*) NomVen
		Read(1,*) ZmV

		IN=INDEX(NOMVEN,'.')
		If (IN==0) Then
			IN=INDEX(NomVen,' ')
			NVen = NOMVen(1:IN-1)//'.Ven'
			IF (IN.EQ.0) NVen=NOMVen //'.Ven'
		Else
			NVEN=NOMVEN
		Endif
		Open (2,File=NVen,Status='Old')
		call Leclima (2,STEP,YN,FY,MES1,MES2,NC1,NC2,VEN,iUnVen)
		Close(2)

	elseif(IflagVen==2) then  ! Uso de vento regional
		Read(1,*) VenReg
		
		VEN=VenReg
	endif

c     ******************************** LEITURA DE DADOS: HUMIDADE ********************************
	If (IflagHum==4) then
		Read(1,*) NomHum

		IN=INDEX(NOMHUM,'.')
		If (IN==0) Then
			IN=INDEX(NomHum,' ')
			NHum = NOMHum(1:IN-1)//'.Hum'
			IF (IN.EQ.0) NHum=NOMHum //'.Hum'		
		Else
			NHUM=NOMHUM
		Endif
		Open (2,File=NHum,Status='Old')
		call Leclima (2,STEP,YN,FY,MES1,MES2,NC1,NC2,HUM,iUnHum)
		Close(2)			

	ElseIF(IflagHum==0) then
		Read(1,*) NomTDEW

		IN=INDEX(NOMTDEW,'.')
		If (IN==0) Then
			IN=INDEX(NomTDEW,' ')
			NTDEW = NOMTDEW(1:IN-1)//'.DEW'
			IF (IN.EQ.0) NTDEW=NOMTDEW //'.DEW'			
		Else
			NTDEW=NOMTDEW
		Endif
		Open (2,File=NTDEW,Status='Old')
		call Leclima (2,STEP,YN,FY,MES1,MES2,NC1,NC2,TDEW,iUnHum)
		Close(2)

	ElseIF (IflagHum==1) then
		Read(1,*) NomTWET
		Read(1,*) Casp
		
		IN=INDEX(NOMTwet,'.')
		If (IN==0) Then
			IN=INDEX(NomTWET,' ')
			NTWET = NOMTWET(1:IN-1)//'.WET'
			IF (IN.EQ.0) NTWET=NOMTWET //'.WET'			
		Else
			Ntwet=NOMtwet
		Endif
		Open (2,File=NTWET,Status='Old')
		call Leclima (2,STEP,YN,FY,MES1,MES2,NC1,NC2,TWET,iUnHum)
		Close(2)			
					
		Read(1,*) NomTDRY
		IN=INDEX(NOMTDRY,'.')
		If (IN==0) Then
			IN=INDEX(NomTDRY,' ')
			NTDry = NOMTDry(1:IN-1)//'.DRY'
			IF (IN.EQ.0) NTDry=NOMTDry //'.DRY'			
		Else
			Ntdry=NOMtdry
		Endif
		Open (2,File=NTDry,Status='Old')
		call Leclima (2,STEP,YN,FY,MES1,MES2,NC1,NC2,TDry,iUnHum)
		Close(2)			

	ElseIF (IflagHum==2) then
		Read(1,*) NomRHA, NomRHI		

		IN=INDEX(NOMRHA,'.')
		If (IN==0) Then
			IN=INDEX(NomRHA,' ')
			NRHA = NOMRHA(1:IN-1)//'.RHA'
			IF (IN.EQ.0) NRHA=NOMRHA //'.RHA'			
		Else
			Nrha=NOMrha
		Endif
		Open (2,File=NRHA,Status='Old')
		call Leclima (2,STEP,YN,FY,MES1,MES2,NC1,NC2,RHA,iUnHum)
		Close(2)
		
		IN=INDEX(NOMRHI,'.')
		If (IN==0) Then
			IN=INDEX(NomRHI,' ')
			NRHI = NOMRHI(1:IN-1)//'.RHI'
			IF (IN.EQ.0) NRHI=NOMRHI //'.RHI'
		Else
			Nrhi=NOMrhi
		Endif
		Open (2,File=NRHI,Status='Old')
		call Leclima (2,STEP,YN,FY,MES1,MES2,NC1,NC2,RHI,iUnHum)
		Close(2)	

	ElseIF (IflagHum==3) then
		Read(1,*) NomRHA


		IN=INDEX(NOMRHA,'.')
		If (IN==0) Then
			IN=INDEX(NomRHA,' ')
			NRHA = NOMRHA(1:IN-1)//'.RHA'
			IF (IN.EQ.0) NRHA=NOMRHA //'.RHA'			
		Else
			Nrha=NOMrha
		Endif
		Open (2,File=NRHA,Status='Old')
		call Leclima (2,STEP,YN,FY,MES1,MES2,NC1,NC2,RHA,iUnHum)
		Close(2)
	EndIF
	close(1)

	IN=INDEX(NOMEVT,' ')

	Open (3,File= NOMEVT(1:IN-1)//'.OUT',Status='unknown')
				
	Write(3,1)	
1	Format('  J    TPA     TPI     TDEW    Tdry    Twet    ',
     +			 'RHI     RHA     HUM     INS     VEN    MatEa  ',
     +			 'MatRa   MatRs  MatRns   MatG    MatETo')
	 
	If (step.eq.1) then
		nCol=NC2-NC1+1
	Elseif (step.eq.3) then
		nCol=(NC2-NC1+1)*3
	Elseif (step.Eq.31) then
		nCol=(NC2-NC1+1)*31
	Endif 
	Year=FY	
	dec=0

	Do 100 y=1,YN  ! Corre os anos
		Write(3,*) year
		J=0
		call testBis(year,NdMes0,NdDec0,BIS)
		dec=1
		Do 200 c=1,nCol  ! C é o valor corrente e nCol é o n. total de valores existentes em cd ano

			If (step.eq.1) then  !Dados mensais
				M=NC1+c-1

				If (mes1.LE.mes2) then
					j=15-32+INT(275.*M/9.)+2*INT(3./(M+1.))+
     +					INT(M/100.-(MOD(year,4)/4.)+0.975)
				Else		
C					Quando o ano de calculos inclui 2 anos:
					If(J==15) call TestBis(year,NdMes0,NdDec0,BIS)  !Ano bisexto do segundo ano do conjunto de dois
					If (c==1) then
						Call TestBis(year-1,NdMes0,NdDec0,BIS)	!Ano bisexto do primeiro ano do conjunto de dois
						CALL MUDREF(MES1,NDMES,MESC,NDDec,Mbis,
     +						MESINI,NDMES0,MESC0,NDdec0)
					Endif
c					Calcular o dia Juliano até ao primeiro dia do mes1      
					If(c==1) then			
						Call JULIAN(15,mes1,J,NdMes0,1)
					Else
						if(((bis==1 .and. J.eq.381).or.
     +					  (bis==0 .and. J.eq.380)) .eqv. .false.) then
							J=J+NDMes(M-1)
						Else
							J=15
						Endif						
					Endif

				Endif

			Else If (step.eq.3) then   !Dados 10-day

				MD=NC1+c-1
					
				if (c==1.and.MD==1) M=NC1+c-1
				if (dec==4) then
					dec=1
					M=M+1
				endif	

				If (mes1.LE.mes2) then
					Select case (dec)
						Case (1) 
							j=5-32+Int(275.*M/9.)+2*Int(3./(M+1.))+
     +							Int(M/100.-(Mod(year,4)/4.)+0.975)
							idec=M*3-2
						Case (2)
							j=15-32+Int(275.*M/9.)+2*Int(3./(M+1.))+
     +							Int(M/100.-(Mod(year,4)/4.)+0.975)
							idec=M*3-1
						Case (3)
							j=25-32+Int(275.*M/9.)+2*Int(3./(M+1.))+
     +							Int(M/100.-(Mod(year,4)/4.)+0.975)
							idec=M*3
					End Select
					dec=dec+1
				Else
C					Quando o ano de calculos inclui 2 anos:
					If(J==5) call TestBis(year,NdMes0,NdDec0,BIS)  !Ano bisexto do segundo ano do conjunto de dois
					If (c==1) Then
						call TestBis(year-1,NdMes0,NdDec0,BIS)	!Ano bisexto do primeiro ano do conjunto de dois
						CALL MUDREF(MES1,NDMES,MESC,NDDec,mbis,
     +						MESINI,NDMES0,MESC0,NDdec0)
					Endif

c					Calcular o dia Juliano até ao primeiro dia do mes1      
					if(c==1) then			
						Call JULIAN(5,mes1,J,NdMes0,1)
					else
						if(((bis==1 .and. J.eq.371).or.
     +					  (bis==0 .and. J.eq.370)) .eqv. .false.) then

							J=J+NDDec(idec-1)
						Else
							J=5
						Endif
					Endif
				Endif


			Else If ((step.eq.31).and.TPA(y,c).NE.-99) THEN   !dados diarios
				if (TPA(y,c).NE.-77) then
					If (mes1.LE.mes2) then
						M=NC1+c-1
						If (M.eq.2 .and. Mod(year,4).EQ.0) then
							J=J+2
						Else
							J=J+1
						Endif			
					Else
C					Quando o ano de calculos inclui 2 anos:
						If(J==1) call TestBis(year,NdMes0,NdDec0,BIS)  !Ano bisexto do segundo ano do conjunto de dois
						If (c==1) call TestBis(year-1,NdMes0,NdDec0,BIS)	!Ano bisexto do primeiro ano do conjunto de dois

c					Calcular o dia Juliano até ao primeiro dia do mes1      
						if(c==1) then			
							Call JULIAN(c,mes1,J,NdMes0,1)
						else
							If(TPA(y,c).NE.-99) then
     							if((bis==1 .and. J.eq.366).or.
     +					   (bis==0 .and. J.eq.365)) then
									J=1
								else
									J=J+1
								endif
							Endif
						Endif
					Endif
				Endif			
			Endif


c         =============== Calculos com: INS ========================================================

			If (iFlagIns==0) then		
				if (Ins(y,c).NE.-99) then
					if (Ins(y,c).NE.-77) then
						call RadExt(J,lat,MatRa(y,c),MatWs(y,c))
						
						MatRs(y,c)=Rs(step,NdMes(M),NdDec(idec),iUnIns,MatRa(y,c),
     +					Ins(y,c),MatWs(y,c),as,bs)
						MatRNS(y,c)=RNS(iUnIns,Ins(y,c),MatRs(y,c))
					Else
						MatRNS(y,c)=-77
					Endif
				Else
					MatRNS(y,c)=-99
				EndIf
				
			else
				If (IflagIns==1) then
					if (Ins(y,c).NE.-99) then
						if (Ins(y,c).NE.-77) then
						  call RadExt(J,lat,MatRa(y,c),MatWs(y,c))
						
							call RadExt(J,latV,MatRaV(y,c),MatWsV(y,c))
						
							MatRsV(y,c)=Rs(step,NdMes(M),NdDec(idec),iUnIns,
     +								MatRaV(y,c),Ins(y,c),MatWsV(y,c),as,bs)					
						

							MatRs(y,c)=(MatRsV(y,c)/MatRaV(y,c))*MatRa(y,c)												
						
							MatRns(y,c)=Rns(iUnIns,Ins(y,c),MatRs(y,c))

						Else
							MatRNS(y,c)=-77
						Endif						
					Else
						MatRNS(y,c)=-99
					EndIf			

				else
c				se iFlagins=2
					if (Ins(y,c).NE.-99) then
						if (Ins(y,c).NE.-99) then
							call RadExt(J,lat,MatRa(y,c),MatWs(y,c))
							MatRs(y,c)=Kr*SQRT(TPA(y,c)-TPI(y,c))*MatRa(y,c) 
							MatRNS(y,c)=RNS(iUnIns,Ins(y,c),MatRs(y,c))
					
						Else
							MatRNS(y,c)=-77
						Endif					
					Else
						MatRNS(y,c)=-99
					EndIf						
				endif
			endif
	
c         ========================= Calculo com VENTO ====================================		
			If(VEN(y,c).ne.-99) Then
				If (VEN(y,c).ne.-77) Then				
					If(IflagVen==0) Then
						VEN(y,c)=CVen(iunven,Zm,VEN(y,c))
					Else If (IflagVen==1) Then
						VEN(y,c)=CVen(iunven,ZmV,VEN(y,c))
					EndIf			
				Endif
			Endif

c         =========================== Calculo com: PRESSÃO DE VAPOR ================================
			If (IflagHum==4) then
				if (HUM(y,c).NE.-99) then
					if (HUM(y,c).NE.-77) then
						MatEA(y,c)=EA(iflagHum,Tdew(y,c),Twet(y,c),Tdry(y,c),Casp,
     +						TPI(y,c),TPA(y,c),RHI(y,c),RHA(y,c),HUM(y,c),Altit)	
					Else
						MatEA(y,c)=-77
					Endif
				else
					MatEA(y,c)=-99
				EndIf
	
			ElseIF(IflagHum==0) then
				if (TDEW(y,c).NE.-99) then
					if (TDEW(y,c).NE.-77) then
						MatEA=EA(iFlagHum,Tdew(y,c),Twet(y,c),Tdry(y,c),Casp,
     +						TPI(y,c),TPA(y,c),RHI(y,c),RHA(y,c),HUM(y,c),Altit)
					Else
						MatEA(y,c)=-77
					Endif
				Else
					MatEA(y,c)=-99
				EndIf

			ElseIF (IflagHum==1) then
				if (TWET(y,c).NE.-99) then
					if (TWET(y,c).NE.-77) then

						MatEA(y,c)=EA(iFlagHum,Tdew(y,c),Twet(y,c),Tdry(y,c),Casp,
     +						TPI(y,c),TPA(y,c),RHI(y,c),RHA(y,c),HUM(y,c),Altit)	
					Else
						MatEA(y,c)=-77
					Endif
				Else
					MatEA(y,c)=-99
				EndIf

			ElseIF (IflagHum==2) then
				if ((RHI(y,c).NE.-99).and.(RHA(y,c).NE.-99)) then
					if ((RHI(y,c).NE.-77).and.(RHA(y,c).NE.-77)) then
						MatEA(y,c)=EA(iFlagHum,Tdew(y,c),Twet(y,c),Tdry(y,c),
     +					Casp,TPI(y,c),TPA(y,c),RHI(y,c),RHA(y,c),HUM(y,c),Altit)	
					Else
						MatEA(y,c)=-77
					Endif
				Else
					MatEA(y,c)=-99
				EndIf

			ElseIF (IflagHum==3) then
				if ((TPI(y,c).NE.-99).and.(RHA(y,c).NE.-99)) then
					if ((TPI(y,c).NE.-77).and.(RHA(y,c).NE.-77)) then
						MatEA(y,c)=EA(iFlagHum,Tdew(y,c),Twet(y,c),Tdry(y,c),
     +					Casp,TPI(y,c),TPA(y,c),RHI(y,c),RHA(y,c),HUM(y,c),Altit)	

					Else
						MatEA(y,c)=-77
					Endif
				Else
					MatEA(y,c)=-99
				EndIf

			ElseIF (IflagHum==5) then
				if (TPI(y,c).NE.-99) then
					if (TPI(y,c).NE.-99) then
						MatEA(y,c)=EA(iFlagHum,Tdew(y,c),Twet(y,c),Tdry(y,c),
     +					Casp,TPI(y,c),TPA(y,c),RHI(y,c),RHA(y,c),HUM(y,c),Altit)	
					Else
						MatEA(y,c)=-77
					Endif
				Else
					MatEA(y,c)=-99
				EndIf
			EndIF


C         Calculo da temperatura media:
			if (TPI(y,c).NE.-99) then
				if (TPI(y,c).NE.-77) then
					Tmed(y,c)=(TPI(y,c)+TPA(y,c))/2.
c             Calculo da temperatura anterior:
					if(year==fy) then
						if (c==1 .or. TPI(y,c-1)== -99) then   
							if (TPI(y,c-1)== -77) then						
								Tant(y,c)=Tmed(y,c)
							else
								Tant(y,c)=Tmed(y,c-1)
							endif
						else
							Tant(y,c)=Tmed(y,c-1)
						endif
						k=c
					else
						if (c==1) then
							if (TPI(y-1,k)== -99) then
								if (TPI(y-1,k)== -77) then
									Tant(y,c)=Tmed(y,c)
								else
									Tant(y,c)=Tmed(y-1,k)   
								endif
							else
								Tant(y,c)=Tmed(y-1,k)   
							endif
						else
							if (TPI(y,c-1)== -99) then
								if (TPI(y,c-1)== -77) then
									Tant(y,c)=Tmed(y,c)
								else
									Tant(y,c)=Tmed(y,c-1)
								endif
							else
								Tant(y,c)=Tmed(y,c-1)
							endif
						endif
					endif
C         Calculo de G:
					if(step.eq.1) then
						MatG(y,c)= 0.14*(Tmed(y,c)-Tant(y,c))
					else
						MatG(y,c)= 0.
					endif
C         Calculo da EVAPOTRANSPIRAÇÃO DE REFERENCIA:	
					MatETo(y,c)=EToMOD(ALTIT,TPA(y,c),TPI(y,c),VEN(y,c),
     +				Matea(y,c),MatRa(y,c),MatWs(y,c),MatRs(y,c),MatRns(y,c),
     +				MatG(y,c))
				Endif
			endif


C         Escrita dos resultados:
			
			if (TPI(y,c).NE.-99) then
				if (TPI(y,c).NE.-77) then
					Write(3,30) J, TPA(y,c),TPI(y,c),TDEW(y,c),Tdry(y,c),
     +				Twet(y,c),RHI(y,c),RHA(y,c),HUM(y,c),INSc(y,c),VEN(y,c),
     +				MatEa(y,c),MatRa(y,c),MatRs(y,c),MatRns(y,c),MatG(y,c),
     +				MatETo(y,c)
30					Format (I3,16(1x,F7.3))
				Else
					MatETo(y,c) = -77
				endif
			Else
				MatETo(y,c) =-99
			endif
200		CONTINUE
		YEAR=YEAR+1
100	CONTINUE
	Close(3)


	Open (3,File=NET0,Status='unknown')
	call WriETo (3,STEP,YN,FY,MES1,MES2,MatETo)
	Close(3)

	End Program evap
     
     
          
     
      FUNCTION E0(T)
	REAL T,E0
      E0=0.6108*EXP(17.27*T/(T+237.3))
      RETURN
      END      

	FUNCTION P(ALTIT)
	real ALTIT
      P=101.3*((293-0.0065*ALTIT)/293.)**5.26
      RETURN
      END      
	


	Function Ea(iEA,Tdew,Twet,Tdry,Casp,TPI,TPA,RHmin,RHmax,HUMREL,Altit)
	real Ea,Tdew,Twet,Tdry,Casp,TPI,TPA,RHmin,RHmax,HUMREL,Altit
	Integer iEA
	Select case (iEA)
		case (0)
			EA=E0(Tdew)
		case (1)
			EA=E0(Twet)-Casp*(Tdry-Twet)*P(ALTIT)
		case (2)
			EA=(E0(TPI)*RHmax/200)+(E0(TPA)*RHmin/200)
		case (3)
			EA=(E0(TPI)*RHmax/100)
		case (4)
			EA=(HUMREL/100.) * ((E0(TPI)+E0(TPA))/2.)	
		case (5)
			EA=E0(TPI)
	End select
	return
	end

	Subroutine RadExt(J,lat,Ra,Ws)
	Real PI,lat,rlat,dr,SolInc,Ws,Ra
	Integer J
	Pi=4*Atan(1.)
	Rlat=lat*PI/180.
	Dr=1.+0.033*cos(2*Pi*J/365)
	SolInc=0.409*sin(2*Pi/365*J -1.39)
	Ws=acos(-tan(rlat)*tan(solInc))
	Ra=24*60/Pi*0.082*dr*(Ws*sin(rlat)*sin(solInc)+cos(rlat)
     +		*cos(solinc)*Sin(Ws))
	return
	end
	
	
	FUNCTION N(Ws)
	real Ws,N
	Pi=4*Atan(1.)
      N=(24/Pi)*Ws
      RETURN
      END      


	FUNCTION Rs(step,NdMes,NdDec,iunins,Ra,Rins,ws,as,bs)
	real ws,Rs,Ra,Rins,as,bs, Pi, N
      Integer step,NdMes,NdDec,iunins

C	iunins=1 -> sunshine daily average value (n)
C	iunins=2 -> sunshine hours / max sunshine hours (n/N)=Rins
C	iunins=3 -> sunshine hours per decade or month
C	iunins=4 -> Global radiation (Rs) in MJ/m2/day
C	iunins=5 -> Shortwave net radiation (Rns) in MJ/m2/day

	if (iunins.le.3) then
		if(iunins.ne.2) then
			Pi=4*Atan(1.)
			N=(24./Pi)*Ws
			if(iunins.eq.3) then	
C				conversão de h/periodo para h/dia:
				if (step.eq.1) Rins=Rins/NdMes
				if (step.eq.3) Rins=Rins/NdDec
			endif
			Rins=Rins/N
		endif
		if(as==0 .and. bs==0) then
			as=0.25
			bs=0.50
		endif
		Rs=(as+bs*Rins)*Ra
      else
		if(iunins.eq.4) then
			Rs=Rins
		else
			Rs=Rins/0.77
		endif
      endif
      RETURN
      END      



	FUNCTION Rns(iunins,Rins,Rs)
	real Rns,Rins,Rs
	if(iunins.eq.5) then
        Rns=Rins
      Else
        Rns=0.77*Rs
      endif     
      RETURN
      END      


	FUNCTION CVen(iunven,Zm,ven)
	real Zm,ven,CVen
	INTEGER iunven
C	Correcção de km/h para m/s
	If (iunven==1) then 
		CVen=ven
	else
		CVen=ven/3.6
	endif
C	Correcção para 2 m de altura
	IF (Zm.NE.2 ) CVEN=CVEN * 4.87 / (log(67.8* Zm - 5.42))
      RETURN
      END      









c     cv-Correc‡„o do vento
c     RA- eadia‡„o no topo da atmosfera
c     HUMREL- Humidade relativa
c     VENTO - Vel. vento
c     Tmed- Temp. m‚dia
c     rins- Insola‡„o relativa n/N
c     iunven - Unidades do vento (1-m/s; 2-km/h)
c     altit-altitude
c     TPA- temp. m xima
c     TPI- temp. m¡nima
c     G- fluxo do solo
c     nano - ano
c     rhor - N§ te¢rico de horas de sol
c     itemp (1: Temp. m‚dia; 2: Temp m xima e m¡nima)
      FUNCTION EToMOD(ALTIT,TPA,TPI,VEN,ea,Ra,Ws,Rs,Rns,G)
			
	Real ALTIT,TPA,TPI,Tmed,VEN,EA,Ra,Ws,Rs,Rns,G, RsRso,VPD
	
	RLAMED=2.45
	GAMA=.00163*P(ALTIT)/RLAMED
	
	es=(e0(TPA)+e0(TPI))/2.	
	VPD=es-ea
	Tmed=(TPA+TPI)/2.
	DELTA=4098 *0.6108*EXP(Tmed*17.27/(Tmed+237.3))/(Tmed+237.3)**2
		
	c=0.25
	d=0.50
	Rso=(c+d+0.00002*altit)*Ra ! Radiação solar de curto comp.onda em dias de céu limpo

	a2=1.35
	b2=0.35
	a1=0.34
	b1=0.14
	RNL0=4.903*1E-09

	RsRso=Rs/Rso	
	if (RsRso.GT.1) RsRso=1.	!Limitação dada por R. Allen in "REF-ET Guide.pdf"
	if (RsRso.LT.0.2) RsRso=0.2	! Idem

	RNL1=a2*RsRso-b2 !Factor Nebulosidade 
	RNL2=a1-b1*SQRT(ea) ! Emissividade liquida da superficie
	RNL3=((TPA+273.16)**4+(TPI+273.16)**4)/2.

	RNL=RNL0*RNL1*RNL2*RNL3
      
	RN=RNS-RNL

	RNUM1=0.408*DELTA*(RN-G)
	rnum2=GAMA*900/(Tmed+273)*VEN*VPD
	DENOM=DELTA+GAMA*(1+0.34*VEN)

	RAD=rnum1/denom
	AERO=rnum2/denom
	EToMOD=RAD+AERO
      RETURN
      END












	SUBROUTINE LECLIMA (nfic,STEP,YN,FY,MES1,MES2,NC1,NC2,M,Iuni)
C	*** Leitura dos ficheiros PRE e ETo...
C	STEP=1=dados mensais; =31=dados diarios; =3=dados decendiais
C	MES1-primeiro mes no ficheiro meteorologico
C	MES2-ultimo mes no ficheiro meteorologico
	INTEGER STEP,YN,YEAR,MES1, MES2,FY,ISOMA(36),NFIC, lvali, pipas
      REAl V(372),M(100,372)
	LOGICAL BIS

	DATA ISOMA/80,80,85,85,105,105,110,110,105,105,85,85,
     *	      80,83,80,80,83,87,85,85,92,98,107,
     *        110,110,107,103,105,105,101,95,83,0,0,0,0/

	READ(nfic,*) STEP,Iuni
	READ(nfic,*) YN,MES1, MES2
	READ(nfic,*) FY

	M=0.

	NC1=mes1
	NC2=mes2

c	Determina as linhas inicial e final do vector V(372) 
      CALL LVAL(STEP,NC1,NC2, Lvali,LVALF,ISOMA,IDIF)
	
	pipas=lvali
	YEAR=FY	
C	*** 1) Le os valores (ano a ano) da matriz do ficheiro
C	*** 2)Armazena os valores de um ano num vector de dimensao 376 
	DO 350 i=1,YN
c	*** Numa serie de anos, com dados diarios, há que saber qual e o ano bisexto,
c	para se retirar este valor, pois a serie de valores diarios medios não
c	trabalha com valores diarios
C	BIS - Indica se um dado ano é bisesto	
		IF (STEP.EQ.31) THEN
			BIS=.FALSE.
			IF (MOD(YEAR,4).EQ.0) BIS=.TRUE.
		ENDIF
		DO 450 li=1,STEP
c			le os valores do ficheiro:
			READ(NFIC,*) (V(j), j=li+pipas,LVALF, STEP)
			Do 10 j=li+pipas,LVALF, STEP
				M(i,j)=V(j)	
10			continue
450		CONTINUE
  		IF (STEP.NE.1.AND. i.LT.YN) THEN
			READ(NFIC,*) YEAR
		ENDIF
350	CONTINUE
	RETURN
	END	subroutine leclima




	SUBROUTINE LVAL(ITEMPO,NCI,NCF,Lvali,LVALF,ISOMA,IDIF)
	DIMENSION ISOMA(36)
	IF (NCI.GT.NCF) THEN		
		NCF=12-NCI+1+NCF
		NCI=1
	ENDIF
	IF(ITEMPO.EQ.31.AND.NCI.GT.1) THEN
		IDIF=(NCI-1)*ITEMPO-ISOMA(NCI-1)
	ELSE
		IDIF=0
	ENDIF
	Lvali=(NCI-1)*ITEMPO-IDIF
	LVALF=ITEMPO*NCF-IDIF
	RETURN
	END
		

	SUBROUTINE WriETo (nfic,STEP,YN,FY,MES1,MES2,M)
C	*** Leitura dos ficheiros PRE e ETo...
C	STEP=1=dados mensais; =31=dados diarios; =3=dados decendiais
C	MES1-primeiro mes no ficheiro meteorologico
C	MES2-ultimo mes no ficheiro meteorologico
	INTEGER STEP,YN,YEAR,MES1, MES2,FY,ISOMA(36),NFIC, lvali, pipas
      REAl V(372),M(100,372)
	LOGICAL BIS

	DATA ISOMA/80,80,85,85,105,105,110,110,105,105,85,85,
     *	      80,83,80,80,83,87,85,85,92,98,107,
     *        110,110,107,103,105,105,101,95,83,0,0,0,0/

	write(nfic,'(2I)') STEP
	write(nfic,'(3I,2(2x,2I))') YN,MES1, MES2
	write(nfic,'(4I)') FY
c	Determina as linhas inicial e final do vector V(372) 	
      CALL LVAL(STEP,MES1,MES2, Lvali,LVALF,ISOMA,IDIF)
	pipas=lvali
	YEAR=FY	
C	*** 1) Le os valores (ano a ano) da matriz do ficheiro
C	*** 2)Armazena os valores de um ano num vector de dimensao 376 
	DO 350 i=1,YN
c	*** Numa serie de anos, com dados diarios, há que saber qual e o ano bisexto,
c	para se retirar este valor, pois a serie de valores diarios medios não
c	trabalha com valores diarios
C	BIS - Indica se um dado ano é bisesto	
		IF (STEP.EQ.31) THEN
			BIS=.FALSE.
			IF (MOD(YEAR,4).EQ.0) BIS=.TRUE.
		ENDIF
		DO 450 li=1,STEP
c			le os valores do ficheiro:
			Do 10 j=li+pipas,LVALF, STEP
				V(j)=M(i,j)
c				if (V(j)==0.) V(j)=-99  
10			continue
			write(NFIC,11) (V(j), j=li+pipas,LVALF, STEP)
11			format(2x,12(1x,F6.2))
450		CONTINUE
		YEAR=YEAR+1
  		IF (STEP.NE.1.AND. i.LT.YN) THEN
			write(NFIC,'(4I)') YEAR
		ENDIF

350	CONTINUE
	RETURN
	END	subroutine WriETo


      SUBROUTINE JULIAN(IDIA,IMES,L,IDIA0,MESINI)
      INTEGER IDIA0(12)
      IFLAG=0
      IDI=IDIA
      IF(IMES.GE.MESINI)THEN
        IMI=IMES-MESINI+1
      ELSE
        IMI=(IMES+12)-MESINI+1
      ENDIF
      L=0
      DO 10 I=1,IMI-1
        DO 20 J=1,IDIA0(I)
          L=L+1
20		CONTINUE
10	continue
      DO 30 I=1,IDI
        L=L+1
30    CONTINUE
      RETURN
      END

	
	
	subroutine TestBis (year,NdMes,NdDec,BIS)
	integer year,NdMes(12),NdDec(36),bis

	If(Mod(year,4).eq.0) then
		Bis=1
		NdMes(2)=29
		NDdec(6)=9
	Else
		Bis=0
		NdMes(2)=28
		NDdec(6)=8
	Endif
	return
	End subroutine TestBis




      SUBROUTINE MUDREF(IMF,IDIAS,MES,IDEC,MBIS,MESINI,IDIAUX,
     +		MES0,IDEAUX)
      INTEGER IDIAS(12),IDIAUX(12),IDEC(36),IDEAUX(36)
	CHARACTER*9 MES(12),MES0(12)
      IREF=1
      IXX=IMF-1
      MESINI=IMF
      DO 777 IX=1,12
        IXX=IXX+1
        IF(IXX.GT.12) IXX=IXX-12
        IF(IXX.EQ.2) MBIS=IX
        MES(ix)=MES0(ixx)
        IDIAS(IX)=IDIAUX(IXX)
777   CONTINUE
      IXX=(IMF-1)*3
      DO 779 IX=1,36
        IXX=IXX+1
        IF(IXX.GT.36) IXX=IXX-36
        IDEC(IX)=IDEAUX(IXX)
779   CONTINUE

	Iano=0	!Linha errada!
      RAZ=IANO/4.
      DIF=RAZ-INT(RAZ)
      IF(DIF.LT.0.00001) THEN
        IDIAS(MBIS)=29
        IDEC(3*MBIS)=9
      ENDIF
      RETURN
      END


