unit iphs1_Tipos;

interface
uses Arrays;

type
  // Enumera��es
  TenModoDeExecucao = (meDOS, meWIN);
  TenCodOper        = (co0, coRes, coRio, coTCV, coH, coSH, coDer, coGH, coDH); // C�digo das Opera��es
  TenES             = (esHU, esHT, esHYMO, esCLARK);                            // Escoamento Superficial
  TenSE             = (seIPHII, seSCS, seHEC1, seFI, seHOLTAN);                 // Separa�ao do Escoamento
  TenMPE            = (mpeKX, mpeCL, mpeCNL, mpeCPI, mpeCF);                    // M�todo de Propaga��o do Escoamento
  TenTP             = (tp0, tp25, tp50, tp75);                                  // Tormenta de Projeto Reordenada
  TenTipoSubBacia   = (sbTCV, sbHidrograma);                                    // Tipo da Sub-Bacia

  // Sin�nimos
  TTab1D = TReal_Array;
  TTab2D = T2D_Real_Array;
  TTab3D = T3D_Real_Array;

implementation

end.
