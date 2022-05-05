unit pro_Const;

interface
Uses Forms, Controls, SysUtils, Classes;

Const
  cTodos                 = '|Todos os Arquivos (*.*)|*.*';

  {Confirma��es}
  cMSG1                  = 'ATEN��O'#13 +
                           'Este processo implica na remo��o permanente dos dados !'#13 +
                           'Voc� tem certeza ?';

  cMSG2                  = 'O arquivo < %s > j� existe !'#13 +
                           'Se voce quiser salv�-lo assim mesmo, use o Editor.';

  cMSG3                  = 'O arquivo < %s >'#13 +
                           'n�o pode ser lido. Tipo desconhecido';

  cMSG4                  = 'Data inicial inexistente';

  cMSG5                  = 'Datas n�o compat�veis (verifique os per�odos indicados)';

  cMSG6                  = 'A Data %s n�o � a data final do m�s';

  cMSG7                  = 'A Data %s n�o � a data inicial do m�s';

  cMSG8                  = 'O arquivo < %s > j� est� aberto.';

  cMSG9                  = 'A data inicial n�o pode ser maior que a final.';

  cMSG10                 = 'Arquivo inv�lido';

  {Erros}
  cSaveError             = 'Erro na tentativa de salvar o arquivo';
  cLoadError             = 'Erro na abertura do arquivo < %s >';
  cNotSuported           = 'Capacidade n�o suportada: %s';
  
  {Gerais}
  cSQLDate               = 'mm/dd/yyyy';
  cMMYYYY                = '!90/0000;1;';
  cDDMMYYYY              = '!90/90/0000;1;';
  csDDMMYYYY             = 'Formato: Dia/Mes/Ano';
  csMMYYYY               = 'Formato: Mes/Ano';
  cNomeCurtoMes          : array[1..12] of String[3] = (
                           'Jan',
                           'Fev',
                           'Mar',
                           'Abr',
                           'Mai',
                           'Jun',
                           'Jul',
                           'Ago',
                           'Set',
                           'Out',
                           'Nov',
                           'Dez'
                           );

  cINTCOMP_DIARIO        = 0;
  cINTCOMP_MENSAL        = 1;

  cINTSIM_DIARIO         = 0;
  cINTSIM_QUINQUENDIAL   = 1;
  cINTSIM_SEMANAL        = 2;
  cINTSIM_DECENDIAL      = 3;
  cINTSIM_QUINZENAL      = 4;
  cINTSIM_MENSAL         = 5;
  cINTSIM_ANUAL          = 6;

  CDEFAULTDAYSFORFAIL    = 5;

// Imagens
const
  iiUnknown                 = -1;
  iiCloseFolder             =  0;
  iiField                   =  1;
  iiTables                  =  2;
  iiDataset                 =  3;
  iiDatabase                =  4;
  iiDatabases               =  5;
  iiRB_Unchecked            =  6;
  iiRB_Checked              =  7;
  iiObjects                 =  8;
  iiItem                    =  9;
  iiPizza                   = 10;
  iiScript                  = 11;
  iiWorld                   = 12;
  iiOptions                 = 13;
  iiInformation             = 14;
  iiTable                   = 15;
  iiWindowsCascade          = 16;
  iiWindowsHoriz            = 17;
  iiWindowsVert             = 18;
  iiNumericField            = 19;
  iiMemoField               = 20;
  iiTimeField               = 21;
  iiDateField               = 22;
  iiAlfaField               = 23;
  iiGraphicField            = 24;
  iiSQLs                    = 25;
  iiBooleanField            = 31;
  iiVector                  = 32;
  iiNumericField_AutoInc    = 33;
  iiNumericField_Integer    = 34;
  iiNumericField_Float      = 35;
  iiNumericField_Currency   = 36;

var
  UM_RELEASE_REF: integer;

implementation
uses MessageManager;

initialization
  UM_RELEASE_REF := getMessageManager.RegisterMessageID('UM_RELEASE_REF');

end.


