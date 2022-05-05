unit pr_Vars;

  {
    Variáveis globais do programa Propagar.
    Futuramente, estas variáveis se transformarão em propriedades de um
    objeto "Applicacao"
  }

interface
uses MessageManager,
     SysUtilsEx,
     comCTRLs {TStatusBar},
     stdCTRLs {TMemo},
     extCTRLs {TImage},
     MessagesForm {Janela de Mansagens},
     controls {TImageList},
     esquemas_OpcoesGraf {TListaDeEsquemasGraficos},
     hidro_Form_GlobalMessages,
     //wsOutPut {TwsOutPut},
     psBASE;

Var
  gErros            : TfoMessages;                // Janela de mensagens
  //gBloqueado        : Boolean;                    // Indica se o sistema está ou não bloqueado
  //gOutPut           : TwsOutPut;                  // Saída genérica de dados
  g_psLib           : TLib;                       // Bibliotecas do PascalScript
  gEsq_OpcoesGraf   : TListaDeEsquemasGraficos;   // Configurações salvas pelo usuário

   // Mensagens de comunicação entre os objetos
      // UM_  -->   User Message
      // AM_  -->   Application Message

  UM_RESET_VISIT                : Integer;
  UM_OBJETO_SE_DESTRUINDO       : Integer;
  UM_OBTEM_OBJETO               : Integer;
  UM_REPINTAR_OBJETO            : Integer;
  UM_OBTEM_DEMANDA_PELA_CLASSE  : Integer;
  UM_DADOS_DO_ANCESTRAL_MUDARAM : Integer;
  UM_CLICK_GERENTE              : Integer;
  UM_NOME_OBJETO_MUDOU          : Integer;
  UM_INICIAR_SIMULACAO          : Integer;
  UM_COMENTARIO_OBJETO_MUDOU    : Integer;
  UM_TROCAR_REFERENCIA          : Integer;
  UM_DESCRICAO_OBJETO_MUDOU     : Integer;
  UM_HABILITAR_STATUS           : Integer;
  UM_DESABILITAR_STATUS         : Integer;
  UM_PREPARAR_SCRIPTS           : Integer;
  UM_LIBERAR_SCRIPTS            : Integer;
  UM_BLOQUEAR_OBJETOS           : Integer;
  UM_DESBLOQUEAR_DEMANDAS       : Integer;
  UM_INIT_EQUATIONS             : Integer;
  UM_FINALIZE_EQUATIONS         : Integer;
  UM_SET_VAR_DECISAO            : integer; // enviado para demandas

implementation

initialization
  UM_RESET_VISIT                 := GetMessageManager.RegisterMessageID('UM_RESET_VISIT');
  UM_OBJETO_SE_DESTRUINDO        := GetMessageManager.RegisterMessageID('UM_OBJETO_SE_DESTRUINDO');
  UM_OBTEM_OBJETO                := GetMessageManager.RegisterMessageID('UM_OBTEM_OBJETO');
  UM_REPINTAR_OBJETO             := GetMessageManager.RegisterMessageID('UM_REPINTAR_OBJETO');
  UM_OBTEM_DEMANDA_PELA_CLASSE   := GetMessageManager.RegisterMessageID('UM_OBTEM_DEMANDA_PELA_CLASSE');
  UM_DADOS_DO_ANCESTRAL_MUDARAM  := GetMessageManager.RegisterMessageID('UM_DADOS_DO_ANCESTRAL_MUDARAM');
  UM_CLICK_GERENTE               := GetMessageManager.RegisterMessageID('UM_CLICK_GERENTE');
  UM_NOME_OBJETO_MUDOU           := GetMessageManager.RegisterMessageID('UM_NOME_OBJETO_MUDOU');
  UM_INICIAR_SIMULACAO           := GetMessageManager.RegisterMessageID('UM_INICIAR_SIMULACAO');
  UM_COMENTARIO_OBJETO_MUDOU     := GetMessageManager.RegisterMessageID('UM_COMENTARIO_OBJETO_MUDOU');
  UM_TROCAR_REFERENCIA           := GetMessageManager.RegisterMessageID('UM_TROCAR_REFERENCIA');
  UM_DESCRICAO_OBJETO_MUDOU      := GetMessageManager.RegisterMessageID('UM_DESCRICAO_OBJETO_MUDOU');
  UM_HABILITAR_STATUS            := GetMessageManager.RegisterMessageID('UM_HABILITAR_STATUS');
  UM_DESABILITAR_STATUS          := GetMessageManager.RegisterMessageID('UM_DESABILITAR_STATUS');
  UM_PREPARAR_SCRIPTS            := GetMessageManager.RegisterMessageID('UM_PREPARAR_SCRIPTS');
  UM_LIBERAR_SCRIPTS             := GetMessageManager.RegisterMessageID('UM_LIBERAR_SCRIPTS');
  UM_BLOQUEAR_OBJETOS            := GetMessageManager.RegisterMessageID('UM_BLOQUEAR_OBJETOS');
  UM_DESBLOQUEAR_DEMANDAS        := GetMessageManager.RegisterMessageID('UM_DESBLOQUEAR_DEMANDAS');
  UM_INIT_EQUATIONS              := GetMessageManager.RegisterMessageID('UM_INIT_EQUATIONS');
  UM_FINALIZE_EQUATIONS          := GetMessageManager.RegisterMessageID('UM_FINALIZE_EQUATIONS');
  UM_SET_VAR_DECISAO             := GetMessageManager.RegisterMessageID('UM_SET_VAR_DECISAO');
end.
