unit iphs1_EscolherTD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Dialogo_EscolherObjeto, StdCtrls;

type
  Tiphs1_Form_EscolherTD = class(TDialogoEscolherObjeto)
  protected
     procedure MostrarObjetos; override;
  end;


implementation
uses hidro_Classes,
     iphs1_Classes;

{$R *.dfm}

{ TTiphs1_Form_EscolherTD }

procedure Tiphs1_Form_EscolherTD.MostrarObjetos;
var i  : Integer;
    PC : TPC;
begin
  inherited;
  for i := 0 to Projeto.PCs.PCs-1 do
    begin
    PC := Projeto.PCs.PC[i];
    if PC.TrechoDagua <> nil then
       lbObjetos.Items.AddObject(PC.TrechoDagua.Nome, PC.TrechoDagua);
    end;
end;

end.
