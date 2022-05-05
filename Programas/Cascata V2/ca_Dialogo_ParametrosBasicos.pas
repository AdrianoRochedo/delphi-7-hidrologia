unit ca_Dialogo_ParametrosBasicos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ca_Dialogo_PlanilhaBase, Menus, AxCtrls, OleCtrls, vcf1;

type
  TcaDialogo_PlanilhaPB = class(TprDialogo_PlanilhaBase)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Planilha_PB: TcaDialogo_PlanilhaPB;

implementation

{$R *.DFM}

end.
