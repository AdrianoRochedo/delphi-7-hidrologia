unit iphs1_Constantes;

interface
uses Messages,
     LanguageControl;

Const
  Aspa = #39;

  AM_ABRIR_ARQUIVO          = WM_USER + 1001;
  AM_ABRIR_APAGAR_ARQUIVO   = WM_USER + 1002;

var
  cFiltroPascalScript: String;

  cMsgAjuda01: String;
  cMsgAjuda02: String;
  cMsgAjuda03: String;
  cMsgAjuda04: String;
  cMsgAjuda05: String;
  cMsgAjuda06: String;
  cMsgAjuda07: String;
  cMsgAjuda08: String;

  cMsgStatus01: String;
  cMsgStatus02: String;
  cMsgStatus03: String;
  cMsgStatus04: String;
  cMsgStatus05: String;
  cMsgStatus06: String;

  cMsgErro01: String;
  cMsgErro02: String;
  cMsgErro03: String;
  cMsgErro04: String;
  cMsgErro05: String;
  cMsgErro06: String;
  cMsgInfo01: String;
  cMsgInfo02: String;
  cMsgInfo03: String;
  cMsgInfo04: String;

  { Linguagens -------------------------------------------------------------------------------}

  cMesID_IPH     : Integer;
  cMesID_SYSTEM  : Integer;
  cMesID_HIDRO   : Integer;
  cMesID_DIALOGS : Integer;

  procedure IniciarConstantes;

implementation

procedure IniciarConstantes;
begin
  cFiltroPascalScript := LanguageManager.GetMessage(cMesID_IPH, 54);
                        //'Arquivos Script Pascal (*.pscript)|*.pscript' + '|' +
                        //'Arquivos Pascal (*.pas)|*.pas' + '|' +
                        //'Todos (*.*)|*.*'

  cMsgAjuda01 := LanguageManager.GetMessage(cMesID_IPH, 55);
                  //'Clique consecutivamente em dois Pontos de Controle ' +
                  //'para criar um Trecho D`água.'

  cMsgAjuda02 := LanguageManager.GetMessage(cMesID_IPH, 56);
                  //'Clique em um Ponto de Controle para criar uma Sub-Bacia.'

  cMsgAjuda03 := LanguageManager.GetMessage(cMesID_IPH, 57);
                  //'Clique em uma janela de projeto para criar um Ponto de Controle.';

  cMsgAjuda04 := LanguageManager.GetMessage(cMesID_IPH, 58);
                  //'Clique em outro Ponto de Controle para fechar a conexão.';

  cMsgAjuda05 := LanguageManager.GetMessage(cMesID_IPH, 59);
                  //'Selecione dois Pontos de Controle pertencentes a um Trecho D`água.'#13 +
                  //'Mas Atenção: Primeiro o ponto Montante e depois o Jusante.';

  cMsgAjuda06 := LanguageManager.GetMessage(cMesID_IPH, 60);
                  //'Agora selecione o Ponto de Controle Jusante a este Trecho D`água.';

  cMsgAjuda07 := LanguageManager.GetMessage(cMesID_IPH, 61);
                  //'Clique em um Ponto de Controle ou em uma Sub-Bacia para criar uma Demanda.'#13 +
                  //'Atenção: Se houver uma Classe de Demanda selecionada a demanda criada herdará seus dados';

  cMsgAjuda08 := LanguageManager.GetMessage(cMesID_IPH, 62);
                  //'Clique em uma janela de projeto para criar um Reservatório.';


  cMsgStatus01 := LanguageManager.GetMessage(cMesID_IPH, 63);
                  //'Trecho D`água criado entre os PCs "%s" e "%s"';

  cMsgStatus02 := LanguageManager.GetMessage(cMesID_IPH, 64);
                  //'Primeiro Ponto de Controle: %s';

  cMsgStatus03 := LanguageManager.GetMessage(cMesID_IPH, 65);
                  //'Segundo Ponto: ?? (indefinido)';

  cMsgStatus04 := LanguageManager.GetMessage(cMesID_IPH, 66);
                  //'Ponto Montante: %s';

  cMsgStatus05 := LanguageManager.GetMessage(cMesID_IPH, 67);
                  //'Ponto Jusante: ?? (indefinido)';

  cMsgStatus06 := LanguageManager.GetMessage(cMesID_IPH, 68);
                  //'Ponto de Controle inserido entre os PCs "%s" e "%s"';


  cMsgErro01 := LanguageManager.GetMessage(cMesID_IPH, 69);
                  //'O PC selecionado "%s" não é Jusante ao PC "%s"';

  cMsgErro02 := LanguageManager.GetMessage(cMesID_IPH, 70);
                  //'O PC selecionado "%s" não é um PC Montante.';

  cMsgErro03 := LanguageManager.GetMessage(cMesID_IPH, 71);
                  //'O nome "%s" já pertence a outro objeto !'#13 +
                  //'Por favor, escolha um nome que não exista.';

  cMsgErro04 := LanguageManager.GetMessage(cMesID_IPH, 72);
                  //'Objeto: %s'#13 +
                  //'Código de Retorno de Contribuição Inválido';

  cMsgErro05 := LanguageManager.GetMessage(cMesID_IPH, 73);
                  //'Este PC já possui um outro PC a jusante!';

  cMsgErro06 := LanguageManager.GetMessage(cMesID_IPH, 74);
                  //'O PC "%s" é um dos PCs a Montante do PC "%s"';


  cMsgInfo01 := LanguageManager.GetMessage(cMesID_IPH, 75);
                  //'Os dados da Demanda "%s" foram'#13 +
                  //'sincronizados com os dados da Classe "%s"';

  cMsgInfo02 := LanguageManager.GetMessage(cMesID_IPH, 76);
                  //'Somente posso remover uma classe se não houverem descendentes !';

  cMsgInfo03 := LanguageManager.GetMessage(cMesID_IPH, 77);
                  //'Inserir uma demanda com base na Classe de Demanda: "%s"';

  cMsgInfo04 := LanguageManager.GetMessage(cMesID_IPH, 78);
                  //' %s. Intervalo: (%d a %d)';
end;

end.
