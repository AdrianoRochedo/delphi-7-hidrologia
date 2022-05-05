subroutine alocacont
use varcont


	if(.not.allocated(iruim))allocate (iruim(Nptos))
	if(.not.allocated(fo))allocate (fo(Nptos,nf))
	if(.not.allocated(vfo))allocate (vfo(nf))
	if(.not.allocated(iparet))allocate (iparet(nptos))
	if(.not.allocated(xpar))allocate (xpar(npar))
	if(.not.allocated(somapar))allocate (somapar(npar))
	if(.not.allocated(reflex))allocate (reflex(npar))
	if(.not.allocated(contra))allocate (contra(npar))
	if(.not.allocated(media))allocate (media(nptos))
	if(.not.allocated(ppar))allocate (ppar(npar,nptos))
	if(.not.allocated(par))allocate (par(npar,nptos))
	if(.not.allocated(pmincont))allocate (pmincont(npar))
	if(.not.allocated(pmaxcont))allocate (pmaxcont(npar))
	if(.not.allocated(fold))allocate (fold(nptos))
	if(.not.allocated(prob))allocate (prob(nptos))


return
end