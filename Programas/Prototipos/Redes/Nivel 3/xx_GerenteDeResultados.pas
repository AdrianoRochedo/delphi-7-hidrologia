unit xx_GerenteDeResultados;

interface
uses // Geral
     Menus,

     // projeto
     hidro_Classes,
     xx_Classes;

type
  TxxGerenteDeResultados = class(TGerenteDeResultados)
    procedure ObterAcoes(MenuDestino: TMenu; const ID_Obj: String); override;
  end;

implementation

{ TxxGerenteDeResultados }

procedure TxxGerenteDeResultados.ObterAcoes(MenuDestino: TMenu; const ID_Obj: String);
begin

end;

end.
