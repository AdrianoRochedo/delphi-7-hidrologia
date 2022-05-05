unit hidro_Variaveis;

interface
uses Classes,
     MessageManager,
     Messages,
     IniFiles {TMemIniFile},
     comCTRLs {TStatusBar},
     stdCTRLs {TMemo},
     extCTRLs {TImage},
     MessagesForm {Janela de Mansagens},
     graphics {TBitmap},
     controls {TImageList},
     Form_Chart {TGraficos},
     esquemas_OpcoesGraf {TListaDeEsquemasGraficos},
     //wsOutPut {TwsOutPut},
     psBASE,
     WindowsManager;

// Mensagens de comunicação entre os objetos
   // UM_  -->   User Message
   // AM_  -->   Application Message
var
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
  UM_DESBLOQUEAR_DEMANDAS       : Integer;
  UM_BLOQUEAR_OBJETOS           : Integer;
  UM_PREPARAR_SCRIPTS           : Integer;
  UM_LIBERAR_SCRIPTS            : Integer;
  UM_OBTER_OBJETO_PELA_OPER     : Integer;

  // Variáveis globais
  Var gVersao           : String;                   // Versão do Programa
      gIPHS1_DOS        : String;                   // Versão DOS do IPHS1 que está sendo utilizada. Esta variável é lida de um ini
      gSB               : TStatusBar;               // Barra de Status global
      gMemo             : TMemo;                    // Barra de mensagens global
      gDesc             : TMemo;                    // Barra de descrições global
      gNome             : TMemo;                    // Barra de nomes global
      gLeds             : TImage;                   // Leds de Status de cada janela
      gErros            : TfoMessages;              // Janela de mensagens
      gExePath          : String;                   // Diretório onde estão os executáveis
      gDir              : String;                   // Diretorio de trabalho atual
      gBloqueado        : Boolean;                  // Indica se o sistema está ou não bloqueado
      g_psLib           : TLib;                     // Bibliotecas do PascalScript
      gEsq_OpcoesGraf   : TListaDeEsquemasGraficos; // Configurações salvas pelo usuário

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
  UM_DESBLOQUEAR_DEMANDAS        := GetMessageManager.RegisterMessageID('UM_DESBLOQUEAR_DEMANDAS');
  UM_BLOQUEAR_OBJETOS            := GetMessageManager.RegisterMessageID('UM_BLOQUEAR_OBJETOS');
  UM_PREPARAR_SCRIPTS            := GetMessageManager.RegisterMessageID('UM_PREPARAR_SCRIPTS');
  UM_LIBERAR_SCRIPTS             := GetMessageManager.RegisterMessageID('UM_LIBERAR_SCRIPTS');
  UM_OBTER_OBJETO_PELA_OPER      := GetMessageManager.RegisterMessageID('UM_OBTER_OBJETO_PELA_OPER');
end.
