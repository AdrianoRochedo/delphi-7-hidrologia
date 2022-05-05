unit pr_Equacoes;

interface

// Seção dos identificadores das Equações -------------------------------------

type
  Teq_Identificador = (eqiQM , eqiSB , eqiDM, eqiQJ,
                       eqiSTF, eqiSTI, eqiP , eqiE );

const
  ceqIdentificador : array[Teq_Identificador] of string =
                     ('QM' , 'SB' , 'DM' , 'QJ' ,
                      'STF', 'STI', 'PRE', 'ETR');

// Seção dos operadores das Equações ------------------------------------------

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
