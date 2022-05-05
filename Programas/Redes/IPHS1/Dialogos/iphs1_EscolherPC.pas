unit iphs1_EscolherPC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Dialogo_EscolherObjeto, StdCtrls;

type
  Tiphs1_Form_EscolherPC = class(TDialogoEscolherObjeto)
  protected
     procedure MostrarObjetos; override;
  end;

implementation
uses hidro_Classes,
     iphs1_Classes;

{$R *.dfm}

{ Tiphs1_Form_EscolherPC }

procedure Tiphs1_Form_EscolherPC.MostrarObjetos;
var i  : Integer;
    PC : TPC;
begin
  inherited;
  for i := 0 to Projeto.PCs.PCs-1 do
    begin
    PC := Projeto.PCs.PC[i];
    if not (PC is Tiphs1_PCR) then
       lbObjetos.Items.AddObject(PC.Nome, PC);
    end;
end;

end.
