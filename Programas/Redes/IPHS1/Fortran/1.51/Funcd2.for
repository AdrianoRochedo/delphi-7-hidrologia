	SUBROUTINE funcd2(H,F,df,Q,B,SO,RUG,CEL)
	REAL F,DF,H
	REAL Q,B,SO,RUG


	F=(B*H*(((B*H)/(B+2.*H))**0.667)*SO**0.5)/RUG-Q
	H=H+.01
	F1=(B*H*(((B*H)/(B+2.*H))**0.667)*SO**0.5)/RUG-Q

	DF=(F1-F)/.01

	H=H-0.01
	CEL=DF/B

	RETURN
	END