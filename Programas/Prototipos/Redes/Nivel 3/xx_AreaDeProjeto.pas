unit xx_AreaDeProjeto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, hidro_AreaDeProjeto, hidro_Classes;

type
  TxxAreaDeProjeto = class(THidroAreaDeProjeto)
  private
    function CriarProjeto(TN: TStrings): TProjeto; override;
    function ObjetoPodeSerConectadoEm(const ID: String; Objeto: THidroComponente): Boolean; override;
  public
    { Public declarations }
  end;

implementation
uses xx_Classes;

{$R *.dfm}

{ TxxAreaDeProjeto }

function TxxAreaDeProjeto.CriarProjeto(TN: TStrings): TProjeto;
begin
  Result := Txx_Projeto.Create(TN, self);
end;

function TxxAreaDeProjeto.ObjetoPodeSerConectadoEm(const ID: String; Objeto: THidroComponente): Boolean;
begin
  Result := True;
end;

end.
