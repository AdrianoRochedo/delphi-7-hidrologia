unit ca_Dialogo_AjustePolinomio;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ca_Dialogo_PlanilhaBase, Menus, AxCtrls, OleCtrls, vcf1;

type
  TcaDialogo_PlanilhaAP = class(TprDialogo_PlanilhaBase)
    procedure FormCreate(Sender: TObject);
  public
    Linha: Integer;
    procedure SetTitulo(L, C: Integer);
  end;

var
  Planilha_AP: TcaDialogo_PlanilhaAP;

implementation

{$R *.DFM}

{ TcaDialogo_PlanilhaAP }

procedure TcaDialogo_PlanilhaAP.SetTitulo(L, C: Integer);
begin
  Tab.SetActiveCell(L, C);
//  Tab.SetFont('MS Sans Serif', 8, True, False, False, False, clWindowText, False, False);
  Tab.SetAlignment(F1HAlignCenter, False, F1VAlignCenter, 0);
end;

procedure TcaDialogo_PlanilhaAP.FormCreate(Sender: TObject);
begin
  inherited;
  Linha := 1;
end;

end.
