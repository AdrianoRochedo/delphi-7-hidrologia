unit iphs1_EscolherSB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Dialogo_EscolherObjeto, StdCtrls;

type
  Tiphs1_Form_EscolherSB = class(TDialogoEscolherObjeto)
  protected
     procedure MostrarObjetos; override;
  end;


implementation
uses hidro_Classes,
     iphs1_Classes;

{$R *.dfm}

{ TTiphs1_Form_EscolherSB }

procedure Tiphs1_Form_EscolherSB.MostrarObjetos;
var L: TList;
    i: Integer;
    PC: TPC;
    TD: Tiphs1_TrechoDagua;
begin
  inherited;

  // Obtem as sub-bacias conectadas aos PCs
  L := Projeto.ObtemSubBacias;
  for i := 0 to L.Count-1 do
    lbObjetos.Items.AddObject(TSubBacia(L[i]).Nome + ' (PC)', L[i]);

  // Obtem as sub-bacias conectadas aos trechos-dágua
  for i := 0 to Projeto.PCs.PCs-1 do
    begin
    PC := Projeto.PCs.PC[i];
    if PC.TrechoDagua <> nil then
       begin
       TD := Tiphs1_TrechoDagua(PC.TrechoDagua);
       if TD.SubBacia <> nil then
          lbObjetos.Items.AddObject(TD.SubBacia.Nome + ' (TD)', TD.SubBacia);
       end;
    end;
end;

end.
