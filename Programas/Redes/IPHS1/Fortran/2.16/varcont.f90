MODULE varcont
IMPLICIT NONE
SAVE

character (20)CABEcont                             !CABEÇALHO

real Area
real AAT


real, allocatable, dimension (:) :: Pcont          !precipitacao proveniente da simulacao continua
real, allocatable, dimension (:) :: QOcont         !vazao observada proveniente da simulacao continua
real, allocatable, dimension (:) :: Vfo            !
real, allocatable, dimension (:) :: Xpar           !
real, allocatable, dimension (:) :: Media          !
real, allocatable, dimension (:) :: Somapar        !
real, allocatable, dimension (:) :: Reflex         !
real, allocatable, dimension (:) :: Contra         !
real, allocatable, dimension (:) :: Fold           !
real, allocatable, dimension (:) :: Prob           !
real, allocatable, dimension (:) :: Pmincont       !
real, allocatable, dimension (:) :: Pmaxcont       !
real, allocatable, dimension (:,:) :: Qcont        !vazao proveniente da simulacao continua
real, allocatable, dimension (:,:) :: Fo           !
real, allocatable, dimension (:,:) :: Par          !
real, allocatable, dimension (:,:) :: Ppar         !
real, allocatable, dimension (:,:,:) :: Spar       !
real, allocatable, dimension (:,:,:) :: Fplex      !


integer NF                                         !NUMERO DE funcoes objetivo
integer NSF                                        !NUMERO DE DADOS DE VAZAO SEM FALHA
integer NPAR                                       !NUMERO DE PARAMETROS DA FUNÇÃO A OTIMIZAR
integer Nptos                                      !NUMERO DE PONTOS DA AMOSTRA INICIAL
integer ISEED                                      !SEMENTE DO PROCESSO ALEATORIO
integer NPC                                        !NUMERO DE COMPLEXOS
integer IBETA                                      !NUMERO DE PASSOS DE EVOLUÇÃO DE CADA COMPLEXO
integer int

integer, allocatable, dimension (:) :: Iparet      !
integer, allocatable, dimension (:) :: Iruim       !


END MODULE
