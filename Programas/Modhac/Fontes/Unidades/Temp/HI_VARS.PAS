unit Hi_Vars;

interface
uses Gerent, wsTabelaDeSimbolos, Hi_Const, ErrosDLG, wsOutPut;

Var
  {Vari�veis Globais}
  gDataSistema         : TDateTime;
  gAno                 : String[4];
  gModHacPath          : String[80];
  gDrive               : Char;
  gTabVar              : TwsTabVar;       // Tabela de vari�veis global
  ActiveProject        : TDLG_Gerente;
  gPSB                 : TParametros;     // Par�metros de uma Sub-Bacia (ClipBoard)
  gErros               : TErros_DLG;
  gDir                 : String;
  gOutPut              : TwsOutPut;

implementation

initialization
  gPSB.TemDados := False;

end.
