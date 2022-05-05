      SUBROUTINE NEWTRAP(RTSAFE,x1,x2,xacc,QREF,B,SO,CEL,DTCAL)
	USE VAR
C	ROTINA PARA ACHAR A RAIZ DE UMA FUNCAO DADA EM FUNCD
	REAL QREF,B,SO,CEL,DTCAL
      INTEGER MAXIT
      REAL rtsafe,x1,x2,xacc
      EXTERNAL funcd
      PARAMETER (MAXIT=100)
      INTEGER j
      REAL df,dx,dxold,f,fh,fl,temp,xh,xl

      call funcd(x1,fl,df,QREF,B,SO,CEL,DTCAL)
      call funcd(x2,fh,df,QREF,B,SO,CEL,DTCAL)

	!x1:dx
	!fl e fh:f
      
      if((fl.gt.0..and.fh.gt.0.).or.(fl.lt.0..and.fh.lt.0.))THEN !IMPRESAO MENSAGENS
          write(*,*)'Qref foi escolhida em forma inadecuada 
     *    - pode ter problemas de convergencia'
	
          WRITE (9,*)'OPERAÇAO',CA
	    WRITE (9,*)'Qref foi escolhida em forma inadecuada 
     *    - pode ter problemas de convergencia'
	
      ENDIF !FIM DE IMPRESAO MENSAGENS

      if(fl.eq.0.)then
        rtsafe=x1         !assume o comprimento = valor de x1
        return
      else if(fh.eq.0.)then
        rtsafe=x2         !asume o comprimento = a valor de x2
        return
      else if(fl.lt.0.)then
        xl=x1
        xh=x2
      else

        xh=x1
        xl=x2
      endif
      rtsafe=.5*(x1+x2)
      dxold=abs(x2-x1)
      dx=dxold
      
      call funcd(rtsafe,f,df,QREF,B,SO,CEL,DTCAL)
      do 11 j=1,MAXIT
        if(((rtsafe-xh)*df-f)*((rtsafe-xl)*df-f).ge.0..or. abs(2.*
     *f).gt.abs(dxold*df) ) then
          dxold=dx
          dx=0.5*(xh-xl)
          rtsafe=xl+dx
          if(xl.eq.rtsafe)return
        else
          dxold=dx
          dx=f/df
          temp=rtsafe
          rtsafe=rtsafe-dx
          if(temp.eq.rtsafe)return

        endif
        if(abs(dx).lt.xacc) return
        call funcd(rtsafe,f,df,QREF,B,SO,CEL,DTCAL)
        if(f.lt.0.) then
          xl=rtsafe
        else
          xh=rtsafe
        endif
11    continue
      pause 'EXCEDIDA O MAXIMO DE ITERAÇÕES-APERTE ENTER PARA CONTINUAR'
	WRITE (9,*)'OPERAÇAO',CA
	WRITE (9,*)'EXCEDIDA O MAXIMO DE ITERAÇÕES - SOLUCAO APROXIMADA' 
      Return
      END