      SUBROUTINE MODEL(P,E,RI,S,QT,QS,Qcontinua,RIB,H,XK1,XK2,
     1RMAX,ALF,AI,BI,AIL,BIL,AT,BT,ATL,BTL,SMAX,PV,HIST,NH,
     1AINP,R)

      DIMENSION PV(70),HIST(70)
c	Esta subrotina é o modelo IPH2 propriamente dito.	

      IF(P-E)100,130,130
 100  EP=E-P
      P=0.
      IF(EP-R)101,101,102
 101  R=R-EP
      GO TO 140
 102  EP=EP-R
      R=0.
      ER=EP*S/SMAX	  !q 618 pág 250 - ER evapotranspiracao EP evapo potencial
      S=S-ER			  ! S estado umidade camada superior Smax caoacidade max de uymidade 
      IF(S)110,120,120
  110 ER=ER+S
      S=0.
  120 RI=AIL+BIL*S
      T=ATL+BTL*S
      ER=ER+P
      GO TO 140
  130 P=P-E
      ER=E
      RD=RMAX-R
      IF(P-RD)131,131,132
  131 R=R+P
      P=0.
      GO TO 140
  132 P=P-RD
      R=RMAX
  140 AT1=1.
      par= p
      IF(P-RI)150,180,180
  150 CR=(P/RI)**2/((P/RI)+ALF)
      VES=VES+P*CR
      P=P*(1-CR)
      S1=(S*(2.-1/BT)+2*P)/(2+1./BT)
      RI1=AIL+BIL*S1
      IF(P-RI1)160,170,170
  160 T=ATL+BTL*S1
      VE=0.
      VI=P
      GO TO 200
  170 SX=AI+BI*P	   ! armazenamento no solo
      ATX=2*BT*(SX-S)/(2*P*BT+2*AT-SX-S)
      AT1=AT1-ATX
      RAUX=P
      VAUX=P*ATX
      GO TO 190
  180 RAUX=RI
      VAUX=0.
  190 RI1=RIB+(RAUX-RIB)*H**AT1
      S1=AI+BI*RI1
      T=ATL+BTL*S1
      VI=RIB*AT1+(RAUX-RIB)*(H**AT1-1)/ALOG(H)+VAUX
      VE=P*AT1-VI+VAUX
  200 VP=S-S1+VI
      VE= ve*(1-ainp) + Par*ainp
      DO 210 KT=1,NH
  210 PV(KT)=PV(KT)+VE*HIST(KT)
      VE=PV(1)
      LL=NH-1
      DO 220 KT=1,LL
  220 PV(KT)=PV(KT+1)
      PV(NH)=0.
      QS =QS*XK1+VE*(1.-XK1)
      QT =QT*XK2+VP*(1.-XK2)
      Qcontinua=QS +QT
      S=S1
      RI=RI1

      RETURN
      END
!_________________________________________________________________________________________