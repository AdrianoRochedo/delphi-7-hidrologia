unit pr_Const;

interface
uses Messages,
     pr_Tipos;

Const
  Aspa = #39;

  caNumIntSimMes: Array[isQuinquendial..isMensal] of byte = (6,  4,  3,  2,  1);
  caNumIntSimAno: Array[isQuinquendial..isMensal] of byte = (72, 48, 36, 24, 12);

  naCDs: byte = 1;

// Inicio Dados de sincronização das demandas
type
  TRec_SD = record
              Dado: String;
              Cod : Integer;
            end;
const
  cSD_ED  = 1;
  cSD_FC  = 2;
  cSD_FR  = 3;
  cSD_BM  = 4;
  cSD_UCA = 5;
  cSD_UD  = 6;
  cSD_TVU = 7;
  cSD_TUD = 8;
  cSD_TFI = 9;
  cSD_SVU = 10;
  cSD_SUD = 11;
  cSD_SFI = 12;

  cSD_Count = 12;
  cSD_Dados : array[1..cSD_Count] of TRec_SD = (
     (Dado: 'Ícone'                                           ; Cod: cSD_BM),
     (Dado: 'Escala de Desenvolvimento'                       ; Cod: cSD_ED),
     (Dado: 'Fator de Conversão'                              ; Cod: cSD_FC),
     (Dado: 'Fração de Retorno'                               ; Cod: cSD_FR),
     (Dado: 'Unidade de Consumo D`água'                       ; Cod: cSD_UCA),
     (Dado: 'Unidade de Demanda'                              ; Cod: cSD_UD),
     (Dado: 'Tab. de Valores Unitários'                       ; Cod: cSD_TVU),
     (Dado: 'Tab. de Unidades de Demanda'                     ; Cod: cSD_TUD),
     (Dado: 'Tab. de Fatores de Implantação'                  ; Cod: cSD_TFI),
     (Dado: 'Opc. de Sinc. da Tab. de Valores Unitários'      ; Cod: cSD_SVU),
     (Dado: 'Opc. de Sinc. da Tab. de Unidades de Demanda'    ; Cod: cSD_SUD),
     (Dado: 'Opc. de Sinc. da Tab. de Fatores de Implantação' ; Cod: cSD_SFI)
  );

// Fim Dados de sincronização das demandas

  AM_ABRIR_ARQUIVO               = WM_USER + 1001;
  AM_ABRIR_APAGAR_ARQUIVO        = WM_USER + 1002;

  cFiltroPascalScript            = 'Arquivos Script Pascal (*.pscript)|*.pscript' + '|' +
                                   'Arquivos Pascal (*.pas)|*.pas' + '|' +
                                   'Todos (*.*)|*.*';

  cMsgAjuda01   = 'Clique consecutivamente em dois Pontos de Controle ' +
                  'para criar um Trecho D`água.';

  cMsgAjuda02   = 'Clique em um Ponto de Controle para criar uma Sub-Bacia.';

  cMsgAjuda03   = 'Clique em uma janela de projeto para criar um Ponto de Controle.';

  cMsgAjuda04   = 'Clique em outro Ponto de Controle para fechar a conexão.';

  cMsgAjuda05   = 'Selecione dois Pontos de Controle pertencentes a um Trecho D`água.'#13 +
                  'Mas Atenção: Primeiro o ponto Montante e depois o Jusante.';

  cMsgAjuda06   = 'Agora selecione o Ponto de Controle Jusante a este Trecho D`água.';

  cMsgAjuda07   = 'Clique em um Ponto de Controle ou em uma Sub-Bacia para criar uma Demanda.'#13 +
                  'Atenção: Se houver uma Classe de Demanda selecionada a demanda criada herdará seus dados';

  cMsgAjuda08   = 'Clique em uma janela de projeto para criar um Reservatório.';


  cMsgStatus01  = 'Trecho D`água criado entre os PCs "%s" e "%s"';

  cMsgStatus02  = 'Primeiro Ponto de Controle: %s';

  cMsgStatus03  = 'Segundo Ponto: ?? (indefinido)';

  cMsgStatus04  = 'Ponto Montante: %s';

  cMsgStatus05  = 'Ponto Jusante: ?? (indefinido)';

  cMsgStatus06   = 'Ponto de Controle inserido entre os PCs "%s" e "%s"';

  cMsgStatus07   = 'Função: Mostrar Registros';

  cMsgStatus08   = 'Selecione uma camada vetorial';

  cMsgStatus09   = 'Nenhuma camada selecionada';


  cMsgErro01     = 'O PC selecionado "%s" não é Jusante ao PC "%s"';

  cMsgErro02     = 'O PC selecionado "%s" não é um PC Montante.';

  cMsgErro03     = 'O nome "%s" já pertence a outro objeto !'#13 +
                   'Por favor, escolha um nome que não exista.';

  cMsgErro04     = 'Objeto: %s'#13 +
                   'Código de Retorno de Contribuição Inválido';

  cMsgErro05     = 'Este PC já possui um outro PC a jusante!';

  cMsgErro06     = 'O PC "%s" é um dos PCs a Montante do PC "%s"';

  cMsgErro07     = 'Método "%s" não Implementado na classe "%s"';

  cMsgErro08     = 'Um projeto que já possui uma camada em branco não'#13 +
                   'pode possuir outras camadas';


  cMsgInfo01     = 'Os dados da Demanda "%s" foram'#13 +
                   'sincronizados com os dados da Classe "%s"';

  cMsgInfo02     = 'Somente posso remover uma classe se não houverem descendentes !';

  cMsgInfo03     = 'Inserir uma demanda com base na Classe de Demanda: "%s"';

  cMsgInfo04     = ' %s. Intervalo: (%d a %d)';

implementation

end.
