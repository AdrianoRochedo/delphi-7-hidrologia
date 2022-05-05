unit pr_Dialogo_Planilha_FalhasDasDemandas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pr_Dialogo_PlanilhaBase, Menus, AxCtrls, OleCtrls, vcf1,
  pr_Classes;

type
  TprDialogo_Planilha_FalhasDasDemandas = class(TprDialogo_PlanilhaBase)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    FPCs: TListaDePCs;
  public
    property PCs: TListaDePCs read FPCs write FPCs;
  end;

var
  prDialogo_Planilha_FalhasDasDemandas: TprDialogo_Planilha_FalhasDasDemandas;

implementation
uses pr_Const, pr_Tipos, drPlanilha;

{$R *.DFM}

procedure TprDialogo_Planilha_FalhasDasDemandas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

procedure TprDialogo_Planilha_FalhasDasDemandas.FormShow(Sender: TObject);
var i: Integer;
    Falhas: TListaDeFalhas;
begin
  inherited;

  Tab.TextRC[1, 3] := 'Falhas Primárias';
  Tab.TextRC[1, 6] := 'Falhas Secundárias';
  Tab.TextRC[1, 9] := 'Falhas Terciárias';
  Tab.TextRC[2, 1] := 'PCs';

  Tab.TextRC[2, 2] := 'INTs'; Tab.TextRC[2, 3] := 'CRITs'; Tab.TextRC[2, 4 ] := 'ANOs';
  Tab.TextRC[2, 5] := 'INTs'; Tab.TextRC[2, 6] := 'CRITs'; Tab.TextRC[2, 7 ] := 'ANOs';
  Tab.TextRC[2, 8] := 'INTs'; Tab.TextRC[2, 9] := 'CRITs'; Tab.TextRC[2, 10] := 'ANOs';

  SetCellsFont(Tab, [1,3, 1,6, 1,9, 2,1], 'ARIAL', 10, clBLUE, True);
  SetCellsFont(Tab, [2,2, 2,3, 2,4, 2,5, 2,6, 2,7, 2,8, 2,9, 2,10], 'ARIAL', 10, clBLACK, True);

  for i := 0 to FPCs.PCs-1 do
    begin
    Tab.TextRC[i+3, 1] := FPCs[i].Nome;

    Falhas := TprPCP(FPCs[i]).ObtemFalhas;

    // Falhas Primárias
    Tab.NumberRC[i+3, 2] := Falhas.IntervalosTotais(pdPrimaria);
    Tab.NumberRC[i+3, 3] := Falhas.IntervalosCriticos(pdPrimaria);
    Tab.NumberRC[i+3, 4] := Falhas.FalhasPrimarias;

    // Falhas Secundárias
    Tab.NumberRC[i+3, 5] := Falhas.IntervalosTotais(pdSecundaria);
    Tab.NumberRC[i+3, 6] := Falhas.IntervalosCriticos(pdSecundaria);
    Tab.NumberRC[i+3, 7] := Falhas.FalhasSecundarias;

    // Falhas Terciárias
    Tab.NumberRC[i+3, 8]  := Falhas.IntervalosTotais(pdTerciaria);
    Tab.NumberRC[i+3, 9]  := Falhas.IntervalosCriticos(pdTerciaria);
    Tab.NumberRC[i+3, 10] := Falhas.FalhasTerciarias;
    end;
end;

end.
