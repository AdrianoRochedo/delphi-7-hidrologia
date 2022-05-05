unit pr_Equacoes;

interface

// Se��o dos identificadores das Equa��es -------------------------------------

type
  Teq_Identificador = (eqiQM , eqiSB , eqiDM, eqiQJ,
                       eqiSTF, eqiSTI, eqiP , eqiE );

const
  ceqIdentificador : array[Teq_Identificador] of string =
                     ('QM' , 'SB' , 'DM' , 'QJ' ,
                      'STF', 'STI', 'PRE', 'ETR');

// Se��o dos operadores das Equa��es ------------------------------------------

const
  sopAdicao     = ' + ';
  sopSubtracao  = ' - ';
  sopIgual      = ' = ';

// Classes --------------------------------------------------------------------

type
  TeqIdentificadores = class
  private

  public

  end;

implementation

end.
