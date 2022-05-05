subroutine alocacao

use var
use varcont

	if(.not.allocated(Q))allocate (Q(NT,NS))
	if(.not.allocated(P))allocate (P(NT,NS))
	if(.not.allocated(IPL))allocate (IPL(NS))
	if(.not.allocated(PRE))allocate (PRE(NT))
	if(.not.allocated(QO))allocate (QO(NT))
	if(.not.allocated(PER))allocate (PER(NT))
	if(.not.allocated(PEF))allocate (PEF(NT))
	if(.not.allocated(VOP))allocate (VOP(NT))
	if(.not.allocated(PA))allocate (PA(NT))
	if(.not.allocated(EXE))allocate (EXE(NT))
	if(.not.allocated(VOLA))allocate (VOLA(NS,9))
	if(.not.allocated(ARRES))allocate (ARRES(NS,9))
	if(.not.allocated(QMAXW))allocate (QMAXW(NS))
	if(.not.allocated(QEXCESO))allocate (QEXCESO(NT))
	if(.not.allocated(Qcont))allocate (Qcont(NT,NS))
	if(.not.allocated(Pcont))allocate (Pcont(NT))
	if(.not.allocated(QOcont))allocate (QOcont(NT))

return
end