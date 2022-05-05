unit iphs1_EscolherDER;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Dialogo_EscolherObjeto, StdCtrls;

type
  Tiphs1_Form_EscolherDER = class(TDialogoEscolherObjeto)
  protected
     procedure MostrarObjetos; override;
  end;


implementation
uses hidro_Classes,
     iphs1_Classes;

{$R *.dfm}

{ TTiphs1_Form_EscolherDER }

procedure Tiphs1_Form_EscolherDER.MostrarObjetos;
var i  : Integer;
    PC : TPC;
begin
  inherited;
  for i := 0 to Projeto.PCs.PCs-1 do
    begin
    PC := Projeto.PCs.PC[i];
    if not (PC is Tiphs1_PCR) then
       if Tiphs1_PC(PC).Derivacao <> nil then
          lbObjetos.Items.AddObject(Tiphs1_PC(PC).Derivacao.Nome, Tiphs1_PC(PC).Derivacao);
    end;
end;

end.
