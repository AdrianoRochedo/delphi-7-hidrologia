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
     hidro_Form_GlobalMessages,
     psBASE;

Var
  gErros            : TfoMessages;                // Janela de mensagens
  g_psLib           : TLib;                       // Bibliotecas do PascalScript

   // Mensagens de comunicação entre os objetos
      // UM_  -->   User Message
      // AM_  -->   Application Message

  UM_RESET_VISIT                : Integer;
  UM_OBJETO_SE_DESTRUINDO       : Integer;
  UM_OBTEM_OBJETO               : Integer;
  UM_REPINTAR_OBJETO            : Integer;
  UM_CLICK_GERENTE              : Integer;
  UM_NOME_OBJETO_MUDOU          : Integer;
  UM_COMENTARIO_OBJETO_MUDOU    : Integer;
  UM_TROCAR_REFERENCIA          : Integer;
  UM_DESCRICAO_OBJETO_MUDOU     : Integer;
  UM_HABILITAR_STATUS           : Integer;
  UM_DESABILITAR_STATUS         : Integer;
  UM_BLOQUEAR_OBJETOS           : Integer;

implementation

initialization
  UM_RESET_VISIT                 := GetMessageManager.RegisterMessageID('UM_RESET_VISIT');
  UM_OBJETO_SE_DESTRUINDO        := GetMessageManager.RegisterMessageID('UM_OBJETO_SE_DESTRUINDO');
  UM_OBTEM_OBJETO                := GetMessageManager.RegisterMessageID('UM_OBTEM_OBJETO');
  UM_REPINTAR_OBJETO             := GetMessageManager.RegisterMessageID('UM_REPINTAR_OBJETO');
  UM_CLICK_GERENTE               := GetMessageManager.RegisterMessageID('UM_CLICK_GERENTE');
  UM_NOME_OBJETO_MUDOU           := GetMessageManager.RegisterMessageID('UM_NOME_OBJETO_MUDOU');
  UM_COMENTARIO_OBJETO_MUDOU     := GetMessageManager.RegisterMessageID('UM_COMENTARIO_OBJETO_MUDOU');
  UM_TROCAR_REFERENCIA           := GetMessageManager.RegisterMessageID('UM_TROCAR_REFERENCIA');
  UM_DESCRICAO_OBJETO_MUDOU      := GetMessageManager.RegisterMessageID('UM_DESCRICAO_OBJETO_MUDOU');
  UM_HABILITAR_STATUS            := GetMessageManager.RegisterMessageID('UM_HABILITAR_STATUS');
  UM_DESABILITAR_STATUS          := GetMessageManager.RegisterMessageID('UM_DESABILITAR_STATUS');
  UM_BLOQUEAR_OBJETOS            := GetMessageManager.RegisterMessageID('UM_BLOQUEAR_OBJETOS');
end.
