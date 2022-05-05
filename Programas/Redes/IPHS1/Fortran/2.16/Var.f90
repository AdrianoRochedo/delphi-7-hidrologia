MODULE VAR
IMPLICIT NONE
SAVE

character (LEN = 12) REAL_CLOCK (3)            !para escrever a hora
integer*4 DATE_TIME (8)                        !para escrever a hora
character*160 FNAME							   !definem os nomes de entrada e saida
character*160 FNAME1
character*160 FNAME3
character*160 FNAME4
character*160 FNAME5
character*160 FNAME6
character*160 FNAME7
character(40) ca


real, allocatable, dimension (:,:) :: Q        !vazao
real, allocatable, dimension (:,:) :: P        !precipitacao
real, allocatable, dimension (:) :: PRE        !
real, allocatable, dimension (:) :: QO         !
real, allocatable, dimension (:) :: PER        !
real, allocatable, dimension (:) :: PEF        !
real, allocatable, dimension (:) :: VOP        !
real, allocatable, dimension (:) :: PA         !
real, allocatable, dimension (:) :: EXE        !
real, allocatable, dimension (:) :: QEXCESO    !
real, allocatable, dimension (:) :: Qccont     !vazao calculada simulacao continua



real AUXILIO
real plotagem
real QMAX
real QMIN
real AT
real PMAX

real, allocatable:: QMAXW(:)       !MAXIMA VAZAO DE CADA OPERACAO HIDROLOGICA
real, allocatable:: VOLA(:,:)      !VOLUME NECESSARIO PARA REDUZIR PICO AOS 9 QLIM
real, allocatable:: ARRES(:,:)     !AREA NECESSARIA PARA REDUZIR PICO AOS 9 QLIM

integer, allocatable, dimension (:) :: IPL     
integer IS
integer IE
integer IPP
integer NPL
integer NT
integer IOBS
integer IPR
integer ILIST 
integer NTT 
integer NCOD 
integer EXCESSO 
integer controla
integer OPCAO
integer NS                          !numero de operacoes hidrologicas


END MODULE
