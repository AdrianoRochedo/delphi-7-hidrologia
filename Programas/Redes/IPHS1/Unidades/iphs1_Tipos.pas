unit iphs1_Tipos;

interface
uses Arrays;

type
  // Enumerações
  TenModoDeExecucao = (meDOS, meWIN);
  TenCodOper        = (co0, coRes, coRio, coTCV, coH, coSH, coDer, coGH, coDH); // Código das Operações
  TenES             = (esHU, esHT, esHYMO, esCLARK);                            // Escoamento Superficial
  TenSE             = (seIPHII, seSCS, seHEC1, seFI, seHOLTAN);                 // Separaçao do Escoamento
  TenMPE            = (mpeKX, mpeCL, mpeCNL, mpeCPI, mpeCF);                    // Método de Propagação do Escoamento
  TenTP             = (tp0, tp25, tp50, tp75);                                  // Tormenta de Projeto Reordenada
  TenTipoSubBacia   = (sbTCV, sbHidrograma);                                    // Tipo da Sub-Bacia

  // Sinônimos
  TTab1D = TReal_Array;
  TTab2D = T2D_Real_Array;
  TTab3D = T3D_Real_Array;

implementation

end.
