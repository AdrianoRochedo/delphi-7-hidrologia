unit ca_Dialogo_FuncaoRegula;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ca_Dialogo_PlanilhaBase, Menus, AxCtrls, OleCtrls, vcf1;

type
  TcaDialogo_PlanilhaFR = class(TprDialogo_PlanilhaBase)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    Linha: Integer;
  end;

var
  Planilha_FR: TcaDialogo_PlanilhaFR;

implementation

{$R *.DFM}

procedure TcaDialogo_PlanilhaFR.FormCreate(Sender: TObject);
begin
  inherited;
  Linha := 3;
end;

end.
