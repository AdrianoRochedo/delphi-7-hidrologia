      SUBROUTINE NEWT2(RTSAFE,X1,X2,XACC,Q,B,SO,RUG,CEL)
C	ROTINA PARA ACHAR A RAIZ DE UMA FUNCAO DADA EM FUNCD
	REAL Q,B,SO,RUG,CEL
      INTEGER MAXIT
      REAL RTSAFE,X1,X2,XACC
      EXTERNAL funcd2
      PARAMETER (MAXIT=100)
      INTEGER j
      REAL df,dx,dxold,f,fh,fl,temp,xh,xl
      call funcd2(x1,fl,df,Q,B,SO,RUG,CEL)
      call funcd2(x2,fh,df,Q,B,SO,RUG,CEL)

c      if((fl.gt.0..and.fh.gt.0.).or.(fl.lt.0..and.fh.lt.0.))!pause
c     *!'root must be bracketed in rtsafe'
      if(fl.eq.0.)then
        rtsafe=x1
        return
      else if(fh.eq.0.)then
        rtsafe=x2
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
      call funcd2(rtsafe,f,df,Q,B,SO,RUG,CEL)

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
        call funcd2(rtsafe,f,df,Q,B,SO,RUG,CEL)
        if(f.lt.0.) then
          xl=rtsafe
        else
          xh=rtsafe
        endif
11    continue
      pause 'rtsafe exceeding maximum iterations'
      return
      END