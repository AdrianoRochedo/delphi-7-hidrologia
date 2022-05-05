unit ch_Const;

interface
Uses Forms, Controls, SysUtils, Classes;

Const
  cTodos                 = '|Todos os Arquivos (*.*)|*.*';

  {Confirmações}
  cMSG1                  = 'ATENÇÃO'#13 +
                           'Este processo implica na remoção permanente dos dados !'#13 +
                           'Você tem certeza ?';

  cMSG2                  = 'O arquivo < %s > já existe !'#13 +
                           'Se voce quiser salvá-lo assim mesmo, use o Editor.';

  cMSG3                  = 'O arquivo < %s >'#13 +
                           'não pode ser lido. Tipo desconhecido';

  cMSG4                  = 'Data inicial inexistente';

  cMSG5                  = 'Datas não compatíveis (verifique os períodos indicados)';

  cMSG6                  = 'A Data %s não é a data final do mês';

  cMSG7                  = 'A Data %s não é a data inicial do mês';

  cMSG8                  = 'O arquivo < %s > já está aberto.';

  cMSG9                  = 'A data inicial não pode ser maior que a final.';

  cMSG10                 = 'Arquivo inválido';

  {Erros}
  cSaveError             = 'Erro na tentativa de salvar o arquivo';
  cLoadError             = 'Erro na abertura do arquivo < %s >';

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

implementation

end.


