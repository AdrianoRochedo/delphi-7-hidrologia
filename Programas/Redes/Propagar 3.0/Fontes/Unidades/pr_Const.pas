unit pr_Const;

interface
uses Messages,
     pr_Tipos;

Const
  Aspa = #39;

  caNumIntSimMes: Array[isQuinquendial..isMensal] of byte = (6,  4,  3,  2,  1);
  caNumIntSimAno: Array[isQuinquendial..isMensal] of byte = (72, 48, 36, 24, 12);

  naCDs: byte = 1;

// Inicio Dados de sincroniza??o das demandas
type
  TRec_SD = record
              Dado: String;
              Cod : Integer;
            end;
const
  cTP_ScrollCanvas = 'ScrollCanvas';
  cTP_ZoomPanel = 'ZoomPanel';

  cSD_ED  = 1;
  cSD_EST = 2;
  cSD_FC  = 3;
  cSD_FR  = 4;
  cSD_BM  = 5;
  cSD_UCA = 6;
  cSD_UD  = 7;
  cSD_TVU = 8;
  cSD_TUD = 9;
  cSD_TFI = 10;
  cSD_SVU = 11;
  cSD_SUD = 12;
  cSD_SFI = 13;

  cSD_Count = 13;
  cSD_Dados : array[1..cSD_Count] of TRec_SD = (
     (Dado: '?cone'                                           ; Cod: cSD_BM),
     (Dado: 'Estado'                                          ; Cod: cSD_EST),
     (Dado: 'Escala de Desenvolvimento'                       ; Cod: cSD_ED),
     (Dado: 'Fator de Convers?o'                              ; Cod: cSD_FC),
     (Dado: 'Fra??o de Retorno'                               ; Cod: cSD_FR),
     (Dado: 'Unidade de Consumo D`?gua'                       ; Cod: cSD_UCA),
     (Dado: 'Unidade de Demanda'                              ; Cod: cSD_UD),
     (Dado: 'Tab. de Valores Unit?rios'                       ; Cod: cSD_TVU),
     (Dado: 'Tab. de Unidades de Demanda'                     ; Cod: cSD_TUD),
     (Dado: 'Tab. de Fatores de Implanta??o'                  ; Cod: cSD_TFI),
     (Dado: 'Opc. de Sinc. da Tab. de Valores Unit?rios'      ; Cod: cSD_SVU),
     (Dado: 'Opc. de Sinc. da Tab. de Unidades de Demanda'    ; Cod: cSD_SUD),
     (Dado: 'Opc. de Sinc. da Tab. de Fatores de Implanta??o' ; Cod: cSD_SFI)
  );

// Fim Dados de sincroniza??o das demandas

  AM_ABRIR_ARQUIVO               = WM_USER + 1001;
  AM_ABRIR_APAGAR_ARQUIVO        = WM_USER + 1002;

  cFiltroPascalScript            = 'Arquivos Script Pascal (*.pscript)|*.pscript' + '|' +
                                   'Arquivos Pascal (*.pas)|*.pas' + '|' +
                                   'Todos (*.*)|*.*';

  cFiltroEquacoes                = 'Formato Literal|*.LTX;*.LT' + '|' +
                                   'Formato MPS|*.MPS' + '|' +
                                   'Texto|*.TXT' + '|' +
                                   'Todos|*.*';

  cFiltroTexto                   = 'Arquivos Texto (*.txt)|*.txt' + '|' +
                                   'Todos (*.*)|*.*';

  cMsgAjuda01   = 'Clique consecutivamente em dois Pontos de Controle ' +
                  'para criar um Trecho D`?gua.';

  cMsgAjuda02   = 'Clique em um Ponto de Controle para criar uma Sub-Bacia.';

  cMsgAjuda03   = 'Clique em uma janela de projeto para criar um Ponto de Controle.';

  cMsgAjuda04   = 'Clique em outro Ponto de Controle para fechar a conex?o.';

  cMsgAjuda05   = 'Selecione dois Pontos de Controle pertencentes a um Trecho D`?gua.'#13 +
                  'Mas Aten??o: Primeiro o ponto Montante e depois o Jusante.';

  cMsgAjuda06   = 'Agora selecione o Ponto de Controle Jusante a este Trecho D`?gua.';

  cMsgAjuda07   = 'Clique em um Ponto de Controle ou em uma Sub-Bacia para criar uma Demanda.'#13 +
                  'Aten??o: Se houver uma Classe de Demanda selecionada a demanda criada herdar? seus dados';

  cMsgAjuda08   = 'Clique em uma janela de projeto para criar um Reservat?rio.';

  cMsgAjuda09   = 'Cria em uma Demanda um poss?vel cen?rio de Demanda por recursos h?dricos';

  cMsgAjuda10   = 'Cria uma descarga de poluentes em um destes poss?veis componentes: PC, Trecho-D?gua ou Demanda';

  cMsgAjuda11   = 'Cria uma representacao visual da qualidade da ?gua em um destes poss?veis componentes: PC ou Demanda';

  // ---------------------------------------------------------------------------------------------------------

  cMsgStatus01  = 'Trecho D`?gua criado entre os PCs "%s" e "%s"';

  cMsgStatus02  = 'Primeiro Ponto de Controle: %s';

  cMsgStatus03  = 'Segundo Ponto: ?? (indefinido)';

  cMsgStatus04  = 'Ponto Montante: %s';

  cMsgStatus05  = 'Ponto Jusante: ?? (indefinido)';

  cMsgStatus06  = 'Ponto de Controle inserido entre os PCs "%s" e "%s"';

  cMsgStatus07  = 'Fun??o: Mostrar Registros';

  cMsgStatus08  = 'Selecione uma camada vetorial';

  cMsgStatus09  = 'Nenhuma camada selecionada';


  cMsgErro01     = 'O PC selecionado "%s" n?o ? Jusante ao PC "%s"';

  cMsgErro02     = 'O PC selecionado "%s" n?o ? um PC Montante.';

  cMsgErro03     = 'O nome "%s" j? pertence a outro objeto !'#13 +
                   'Por favor, escolha um nome que n?o exista.';

  cMsgErro04     = 'Objeto: %s'#13 +
                   'C?digo de Retorno de Contribui??o Inv?lido';

  cMsgErro05     = 'Este PC j? possui um outro PC a jusante!';

  cMsgErro06     = 'O PC "%s" ? um dos PCs a Montante do PC "%s"';

  cMsgErro07     = 'M?todo "%s" n?o Implementado na classe "%s"';

  cMsgErro08     = 'Um projeto que j? possui uma camada em branco n?o'#13 +
                   'pode possuir outras camadas';

  cMsgErro09     = 'Objeto: %s'#13 +
                   'Erro(s):'#13'%s';


  cMsgInfo01     = 'Os dados da Demanda "%s" foram'#13 +
                   'sincronizados com os dados da Classe "%s"';

  cMsgInfo02     = 'Somente posso remover uma classe se n?o houverem descendentes !';

  cMsgInfo03     = 'Inserir uma demanda com base na Classe de Demanda: "%s"';

  cMsgInfo04     = ' %s. Intervalo: (%d a %d)';

  // Caminhos --------------------------------------------------------------------------------

const

  cPATH_MWFoloder  = 'Solvers\MWSolver\';
  cPATH_LPSolveIDE = 'Solvers\LpSolveIDE\';
  cPATH_LPSolve    = 'Solvers\LpSolve\';

  // Ferramentas --------------------------------------------------------------------------------

const

  cTOOL_MWFoloder  = cPATH_MWFoloder + 'Solver.exe';
  cTOOL_LPSolveIDE = cPATH_LPSolveIDE + 'LpSolveIDE.exe';
  cTOOL_LPSolve    = cPATH_LPSolve + 'LP_Solve.exe';

implementation

end.
